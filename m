From: akpm@linux-foundation.org
Subject: + tools-fix-cross-compile-var-clobbering.patch added to -mm tree
Date: Mon, 08 Jan 2018 17:27:36 -0800
Message-ID: <5a541a88.3DhHcZkP9yQCghuT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33530 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753595AbeAIB1i (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jan 2018 20:27:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: martin@martingkelly.com, acme@kernel.org, broonie@kernel.org, gregkh@linuxfoundation.org, haiyangz@microsoft.com, hannes@cmpxchg.org, jacek.anaszewski@gmail.com, jic23@kernel.org, kys@microsoft.com, linus.walleij@linaro.org, lizefan@huawei.com, lv.zheng@intel.com, mario.limonciello@dell.com, mingo@redhat.com, pali.rohar@gmail.com, pavel@ucw.cz, peterz@infradead.org, rafael.j.wysocki@intel.com, robert.moore@intel.com, rpurdie@rpsys.net, shuah@kernel.org, sthemmin@microsoft.com, tj@kernel.org, valentina.manea.m@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tools: fix cross-compile var clobbering
has been added to the -mm tree.  Its filename is
     tools-fix-cross-compile-var-clobbering.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tools-fix-cross-compile-var-clobbering.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tools-fix-cross-compile-var-clobbering.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Martin Kelly <martin@martingkelly.com>
Subject: tools: fix cross-compile var clobbering

Currently a number of Makefiles break when used with toolchains that pass
extra flags in CC and other cross-compile related variables (such as
--sysroot). Thus we get this error when we use a toolchain that puts
--sysroot in the CC var:

~/src/linux/tools$ make iio
[snip]
iio_event_monitor.c:18:10: fatal error: unistd.h: No such file or directory
  #include <unistd.h>
           ^~~~~~~~~~

This occurs because we clobber several env vars related to cross-compiling
with lines like this:

CC = $(CROSS_COMPILE)gcc

Although this will point to a valid cross-compiler, we lose any extra
flags that might exist in the CC variable, which can break toolchains that
rely on them (for example, those that use --sysroot).  This easily shows
up using a Yocto SDK:

$ . [snip]/sdk/environment-setup-cortexa8hf-neon-poky-linux-gnueabi

$ echo $CC
arm-poky-linux-gnueabi-gcc -march=armv7-a -mfpu=neon -mfloat-abi=hard
-mcpu=cortex-a8
--sysroot=[snip]/sdk/sysroots/cortexa8hf-neon-poky-linux-gnueabi

$ echo $CROSS_COMPILE
arm-poky-linux-gnueabi-

$ echo ${CROSS_COMPILE}gcc
krm-poky-linux-gnueabi-gcc

Although arm-poky-linux-gnueabi-gcc is a cross-compiler, we've lost the
--sysroot and other flags that enable us to find the right libraries to
link against, so we can't find unistd.h and other libraries and headers. 
Normally with the --sysroot flag we would find unistd.h in the sdk
directory in the sysroot:

$ find [snip]/sdk/sysroots -path '*/usr/include/unistd.h'
[snip]/sdk/sysroots/cortexa8hf-neon-poky-linux-gnueabi/usr/include/unistd.h

The perf Makefile adds CC = $(CROSS_COMPILE)gcc if and only if CC is not
already set, and it compiles correctly with the above toolchain.

So, generalize the logic that perf uses in the common Makefile and remove
the manual CC = $(CROSS_COMPILE)gcc lines from each Makefile.

Note that this patch does not fix cross-compile for all the tools (some
have other bugs), but it does fix it for all except usb and acpi, which
still have other unrelated issues.

I tested both with and without the patch on native and cross-build and
there appear to be no regressions.

Link: http://lkml.kernel.org/r/20180107214028.23771-1-martin@martingkelly.com
Signed-off-by: Martin Kelly <martin@martingkelly.com>
Acked-by: Mark Brown <broonie@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Pali Rohár <pali.rohar@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Robert Moore <robert.moore@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Valentina Manea <valentina.manea.m@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Mario Limonciello <mario.limonciello@dell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/cgroup/Makefile            |    1 -
 tools/gpio/Makefile              |    2 --
 tools/hv/Makefile                |    1 -
 tools/iio/Makefile               |    2 --
 tools/laptop/freefall/Makefile   |    1 -
 tools/leds/Makefile              |    1 -
 tools/perf/Makefile.perf         |    6 ------
 tools/power/acpi/Makefile.config |    3 ---
 tools/scripts/Makefile.include   |   18 ++++++++++++++++++
 tools/spi/Makefile               |    2 --
 tools/usb/Makefile               |    1 -
 tools/vm/Makefile                |    1 -
 tools/wmi/Makefile               |    1 -
 13 files changed, 18 insertions(+), 22 deletions(-)

diff -puN tools/cgroup/Makefile~tools-fix-cross-compile-var-clobbering tools/cgroup/Makefile
--- a/tools/cgroup/Makefile~tools-fix-cross-compile-var-clobbering
+++ a/tools/cgroup/Makefile
@@ -1,7 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for cgroup tools
 
-CC = $(CROSS_COMPILE)gcc
 CFLAGS = -Wall -Wextra
 
 all: cgroup_event_listener
diff -puN tools/gpio/Makefile~tools-fix-cross-compile-var-clobbering tools/gpio/Makefile
--- a/tools/gpio/Makefile~tools-fix-cross-compile-var-clobbering
+++ a/tools/gpio/Makefile
@@ -12,8 +12,6 @@ endif
 # (this improves performance and avoids hard-to-debug behaviour);
 MAKEFLAGS += -r
 
-CC = $(CROSS_COMPILE)gcc
-LD = $(CROSS_COMPILE)ld
 CFLAGS += -O2 -Wall -g -D_GNU_SOURCE -I$(OUTPUT)include
 
 ALL_TARGETS := lsgpio gpio-hammer gpio-event-mon
diff -puN tools/hv/Makefile~tools-fix-cross-compile-var-clobbering tools/hv/Makefile
--- a/tools/hv/Makefile~tools-fix-cross-compile-var-clobbering
+++ a/tools/hv/Makefile
@@ -1,7 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for Hyper-V tools
 
-CC = $(CROSS_COMPILE)gcc
 WARNINGS = -Wall -Wextra
 CFLAGS = $(WARNINGS) -g $(shell getconf LFS_CFLAGS)
 
diff -puN tools/iio/Makefile~tools-fix-cross-compile-var-clobbering tools/iio/Makefile
--- a/tools/iio/Makefile~tools-fix-cross-compile-var-clobbering
+++ a/tools/iio/Makefile
@@ -12,8 +12,6 @@ endif
 # (this improves performance and avoids hard-to-debug behaviour);
 MAKEFLAGS += -r
 
-CC = $(CROSS_COMPILE)gcc
-LD = $(CROSS_COMPILE)ld
 CFLAGS += -O2 -Wall -g -D_GNU_SOURCE -I$(OUTPUT)include
 
 ALL_TARGETS := iio_event_monitor lsiio iio_generic_buffer
diff -puN tools/laptop/freefall/Makefile~tools-fix-cross-compile-var-clobbering tools/laptop/freefall/Makefile
--- a/tools/laptop/freefall/Makefile~tools-fix-cross-compile-var-clobbering
+++ a/tools/laptop/freefall/Makefile
@@ -2,7 +2,6 @@
 PREFIX ?= /usr
 SBINDIR ?= sbin
 INSTALL ?= install
-CC = $(CROSS_COMPILE)gcc
 
 TARGET = freefall
 
diff -puN tools/leds/Makefile~tools-fix-cross-compile-var-clobbering tools/leds/Makefile
--- a/tools/leds/Makefile~tools-fix-cross-compile-var-clobbering
+++ a/tools/leds/Makefile
@@ -1,7 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for LEDs tools
 
-CC = $(CROSS_COMPILE)gcc
 CFLAGS = -Wall -Wextra -g -I../../include/uapi
 
 all: uledmon led_hw_brightness_mon
diff -puN tools/perf/Makefile.perf~tools-fix-cross-compile-var-clobbering tools/perf/Makefile.perf
--- a/tools/perf/Makefile.perf~tools-fix-cross-compile-var-clobbering
+++ a/tools/perf/Makefile.perf
@@ -144,12 +144,6 @@ define allow-override
     $(eval $(1) = $(2)))
 endef
 
-# Allow setting CC and AR and LD, or setting CROSS_COMPILE as a prefix.
-$(call allow-override,CC,$(CROSS_COMPILE)gcc)
-$(call allow-override,AR,$(CROSS_COMPILE)ar)
-$(call allow-override,LD,$(CROSS_COMPILE)ld)
-$(call allow-override,CXX,$(CROSS_COMPILE)g++)
-
 LD += $(EXTRA_LDFLAGS)
 
 HOSTCC  ?= gcc
diff -puN tools/power/acpi/Makefile.config~tools-fix-cross-compile-var-clobbering tools/power/acpi/Makefile.config
--- a/tools/power/acpi/Makefile.config~tools-fix-cross-compile-var-clobbering
+++ a/tools/power/acpi/Makefile.config
@@ -56,9 +56,6 @@ INSTALL_SCRIPT = ${INSTALL_PROGRAM}
 # to compile vs uClibc, that can be done here as well.
 CROSS = #/usr/i386-linux-uclibc/usr/bin/i386-uclibc-
 CROSS_COMPILE ?= $(CROSS)
-CC = $(CROSS_COMPILE)gcc
-LD = $(CROSS_COMPILE)gcc
-STRIP = $(CROSS_COMPILE)strip
 HOSTCC = gcc
 
 # check if compiler option is supported
diff -puN tools/scripts/Makefile.include~tools-fix-cross-compile-var-clobbering tools/scripts/Makefile.include
--- a/tools/scripts/Makefile.include~tools-fix-cross-compile-var-clobbering
+++ a/tools/scripts/Makefile.include
@@ -42,6 +42,24 @@ EXTRA_WARNINGS += -Wformat
 
 CC_NO_CLANG := $(shell $(CC) -dM -E -x c /dev/null | grep -Fq "__clang__"; echo $$?)
 
+# Makefiles suck: This macro sets a default value of $(2) for the
+# variable named by $(1), unless the variable has been set by
+# environment or command line. This is necessary for CC and AR
+# because make sets default values, so the simpler ?= approach
+# won't work as expected.
+define allow-override
+  $(if $(or $(findstring environment,$(origin $(1))),\
+            $(findstring command line,$(origin $(1)))),,\
+    $(eval $(1) = $(2)))
+endef
+
+# Allow setting various cross-compile vars or setting CROSS_COMPILE as a prefix.
+$(call allow-override,CC,$(CROSS_COMPILE)gcc)
+$(call allow-override,AR,$(CROSS_COMPILE)ar)
+$(call allow-override,LD,$(CROSS_COMPILE)ld)
+$(call allow-override,CXX,$(CROSS_COMPILE)g++)
+$(call allow-override,STRIP,$(CROSS_COMPILE)strip)
+
 ifeq ($(CC_NO_CLANG), 1)
 EXTRA_WARNINGS += -Wstrict-aliasing=3
 endif
diff -puN tools/spi/Makefile~tools-fix-cross-compile-var-clobbering tools/spi/Makefile
--- a/tools/spi/Makefile~tools-fix-cross-compile-var-clobbering
+++ a/tools/spi/Makefile
@@ -11,8 +11,6 @@ endif
 # (this improves performance and avoids hard-to-debug behaviour);
 MAKEFLAGS += -r
 
-CC = $(CROSS_COMPILE)gcc
-LD = $(CROSS_COMPILE)ld
 CFLAGS += -O2 -Wall -g -D_GNU_SOURCE -I$(OUTPUT)include
 
 ALL_TARGETS := spidev_test spidev_fdx
diff -puN tools/usb/Makefile~tools-fix-cross-compile-var-clobbering tools/usb/Makefile
--- a/tools/usb/Makefile~tools-fix-cross-compile-var-clobbering
+++ a/tools/usb/Makefile
@@ -1,7 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for USB tools
 
-CC = $(CROSS_COMPILE)gcc
 PTHREAD_LIBS = -lpthread
 WARNINGS = -Wall -Wextra
 CFLAGS = $(WARNINGS) -g -I../include
diff -puN tools/vm/Makefile~tools-fix-cross-compile-var-clobbering tools/vm/Makefile
--- a/tools/vm/Makefile~tools-fix-cross-compile-var-clobbering
+++ a/tools/vm/Makefile
@@ -6,7 +6,6 @@ TARGETS=page-types slabinfo page_owner_s
 LIB_DIR = ../lib/api
 LIBS = $(LIB_DIR)/libapi.a
 
-CC = $(CROSS_COMPILE)gcc
 CFLAGS = -Wall -Wextra -I../lib/
 LDFLAGS = $(LIBS)
 
diff -puN tools/wmi/Makefile~tools-fix-cross-compile-var-clobbering tools/wmi/Makefile
--- a/tools/wmi/Makefile~tools-fix-cross-compile-var-clobbering
+++ a/tools/wmi/Makefile
@@ -2,7 +2,6 @@ PREFIX ?= /usr
 SBINDIR ?= sbin
 INSTALL ?= install
 CFLAGS += -D__EXPORTED_HEADERS__ -I../../include/uapi -I../../include
-CC = $(CROSS_COMPILE)gcc
 
 TARGET = dell-smbios-example
 
_

Patches currently in -mm which might be from martin@martingkelly.com are

tools-fix-cross-compile-var-clobbering.patch

