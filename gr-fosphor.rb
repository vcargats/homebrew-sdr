require "formula"

class GrFosphor < Formula
  homepage "http://sdr.osmocom.org/trac/wiki/fosphor"
  url "https://gitea.osmocom.org/sdr/gr-fosphor.git",
    revision: "e02a2ea4936324379b02c5a1d4878b2da0961bd9"

  option "with-qt", "Build with QT widgets in addition to wxWidgets"

  depends_on "cmake" => :build
  depends_on "pyqt5" if build.with? "qt"
  depends_on "freetype"
  depends_on "glfw3"
  depends_on "gnuradio"

  def install
    mkdir "build" do
      args = std_cmake_args

      ENV.append "LDFLAGS", "-Wl,-undefined,dynamic_lookup"
      # Point Python library to existing path or CMake test will fail.
      args = %W[
        -DCMAKE_SHARED_LINKER_FLAGS='-Wl,-undefined,dynamic_lookup'
        -DPYTHON_LIBRARY='#{HOMEBREW_PREFIX}/lib/libgnuradio-runtime.dylib'
        -DFREETYPE2_INCLUDE_DIR_ftheader='#{Formula["freetype"].include}'
      ]
      if build.with? "qt"
        qt_prefix = `brew --prefix qt5`
        args << "-DCMAKE_PREFIX_PATH=#{qt_prefix} -DENABLE_QT=ON"
      end

      system "cmake", "..", *args
      system "make", "install"
    end
  end
  test do
    system "false"
  end
end