From: akpm@linux-foundation.org
Subject: + linux-kernel-markers-kconfig-menus.patch added to -mm tree
Date: Wed, 14 Feb 2007 23:22:04 -0800
Message-ID: <200702150722.l1F7M4oP022844@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37654 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964959AbXBOHWO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 02:22:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca


The patch titled
     Linux Kernel Markers: Kconfig menus
has been added to the -mm tree.  Its filename is
     linux-kernel-markers-kconfig-menus.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Linux Kernel Markers: Kconfig menus
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile               |    3 ++-
 arch/alpha/Kconfig     |    6 ++++++
 arch/arm/Kconfig       |    6 ++++++
 arch/arm26/Kconfig     |    6 ++++++
 arch/cris/Kconfig      |    6 ++++++
 arch/frv/Kconfig       |    6 ++++++
 arch/h8300/Kconfig     |    6 ++++++
 arch/i386/Kconfig      |    3 +++
 arch/ia64/Kconfig      |    3 +++
 arch/m32r/Kconfig      |    6 ++++++
 arch/m68k/Kconfig      |    6 ++++++
 arch/m68knommu/Kconfig |    6 ++++++
 arch/mips/Kconfig      |    6 ++++++
 arch/parisc/Kconfig    |    6 ++++++
 arch/powerpc/Kconfig   |    3 +++
 arch/ppc/Kconfig       |    6 ++++++
 arch/s390/Kconfig      |    2 ++
 arch/sh/Kconfig        |    6 ++++++
 arch/sh64/Kconfig      |    6 ++++++
 arch/sparc/Kconfig     |    2 ++
 arch/sparc64/Kconfig   |    3 +++
 arch/um/Kconfig        |    6 ++++++
 arch/v850/Kconfig      |    6 ++++++
 arch/x86_64/Kconfig    |    3 +++
 arch/xtensa/Kconfig    |    6 ++++++
 kernel/Kconfig.marker  |   17 +++++++++++++++++
 26 files changed, 140 insertions(+), 1 deletion(-)

diff -puN Makefile~linux-kernel-markers-kconfig-menus Makefile
--- a/Makefile~linux-kernel-markers-kconfig-menus
+++ a/Makefile
@@ -308,7 +308,8 @@ AFLAGS_KERNEL	=
 # Needed to be compatible with the O= option
 LINUXINCLUDE    := -Iinclude \
                    $(if $(KBUILD_SRC),-Iinclude2 -I$(srctree)/include) \
-		   -include include/linux/autoconf.h
+		   -include include/linux/autoconf.h \
+		   -include linux/marker.h
 
 CPPFLAGS        := -D__KERNEL__ $(LINUXINCLUDE)
 
diff -puN arch/alpha/Kconfig~linux-kernel-markers-kconfig-menus arch/alpha/Kconfig
--- a/arch/alpha/Kconfig~linux-kernel-markers-kconfig-menus
+++ a/arch/alpha/Kconfig
@@ -642,6 +642,12 @@ source "fs/Kconfig"
 
 source "arch/alpha/oprofile/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.marker"
+
+endmenu
+
 source "arch/alpha/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/arm/Kconfig~linux-kernel-markers-kconfig-menus arch/arm/Kconfig
--- a/arch/arm/Kconfig~linux-kernel-markers-kconfig-menus
+++ a/arch/arm/Kconfig
@@ -967,6 +967,12 @@ source "fs/Kconfig"
 
 source "arch/arm/oprofile/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.marker"
+
+endmenu
+
 source "arch/arm/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/arm26/Kconfig~linux-kernel-markers-kconfig-menus arch/arm26/Kconfig
--- a/arch/arm26/Kconfig~linux-kernel-markers-kconfig-menus
+++ a/arch/arm26/Kconfig
@@ -244,6 +244,12 @@ source "drivers/misc/Kconfig"
 
 source "drivers/usb/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.marker"
+
+endmenu
+
 source "arch/arm26/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/cris/Kconfig~linux-kernel-markers-kconfig-menus arch/cris/Kconfig
--- a/arch/cris/Kconfig~linux-kernel-markers-kconfig-menus
+++ a/arch/cris/Kconfig
@@ -198,6 +198,12 @@ source "sound/Kconfig"
 
 source "drivers/usb/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.marker"
+
+endmenu
+
 source "arch/cris/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/frv/Kconfig~linux-kernel-markers-kconfig-menus arch/frv/Kconfig
--- a/arch/frv/Kconfig~linux-kernel-markers-kconfig-menus
+++ a/arch/frv/Kconfig
@@ -379,6 +379,12 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.marker"
+
+endmenu
+
 source "arch/frv/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/h8300/Kconfig~linux-kernel-markers-kconfig-menus arch/h8300/Kconfig
--- a/arch/h8300/Kconfig~linux-kernel-markers-kconfig-menus
+++ a/arch/h8300/Kconfig
@@ -212,6 +212,12 @@ endmenu
 
 source "fs/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.marker"
+
+endmenu
+
 source "arch/h8300/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/i386/Kconfig~linux-kernel-markers-kconfig-menus arch/i386/Kconfig
--- a/arch/i386/Kconfig~linux-kernel-markers-kconfig-menus
+++ a/arch/i386/Kconfig
@@ -1258,6 +1258,9 @@ config KPROBES
 	  a probepoint and specifies the callback.  Kprobes is useful
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".
+
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/i386/Kconfig.debug"
diff -puN arch/ia64/Kconfig~linux-kernel-markers-kconfig-menus arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~linux-kernel-markers-kconfig-menus
+++ a/arch/ia64/Kconfig
@@ -581,6 +581,9 @@ config KPROBES
 	  a probepoint and specifies the callback.  Kprobes is useful
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".
+
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/ia64/Kconfig.debug"
diff -puN arch/m32r/Kconfig~linux-kernel-markers-kconfig-menus arch/m32r/Kconfig
--- a/arch/m32r/Kconfig~linux-kernel-markers-kconfig-menus
+++ a/arch/m32r/Kconfig
@@ -401,6 +401,12 @@ source "fs/Kconfig"
 
 source "arch/m32r/oprofile/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.marker"
+
+endmenu
+
 source "arch/m32r/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/m68k/Kconfig~linux-kernel-markers-kconfig-menus arch/m68k/Kconfig
--- a/arch/m68k/Kconfig~linux-kernel-markers-kconfig-menus
+++ a/arch/m68k/Kconfig
@@ -667,6 +667,12 @@ endmenu
 
 source "fs/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.marker"
+
+endmenu
+
 source "arch/m68k/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/m68knommu/Kconfig~linux-kernel-markers-kconfig-menus arch/m68knommu/Kconfig
--- a/arch/m68knommu/Kconfig~linux-kernel-markers-kconfig-menus
+++ a/arch/m68knommu/Kconfig
@@ -676,6 +676,12 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.marker"
+
+endmenu
+
 source "arch/m68knommu/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/mips/Kconfig~linux-kernel-markers-kconfig-menus arch/mips/Kconfig
--- a/arch/mips/Kconfig~linux-kernel-markers-kconfig-menus
+++ a/arch/mips/Kconfig
@@ -2088,6 +2088,12 @@ source "fs/Kconfig"
 
 source "arch/mips/oprofile/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.marker"
+
+endmenu
+
 source "arch/mips/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/parisc/Kconfig~linux-kernel-markers-kconfig-menus arch/parisc/Kconfig
--- a/arch/parisc/Kconfig~linux-kernel-markers-kconfig-menus
+++ a/arch/parisc/Kconfig
@@ -260,6 +260,12 @@ source "fs/Kconfig"
 
 source "arch/parisc/oprofile/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.marker"
+
+endmenu
+
 source "arch/parisc/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/powerpc/Kconfig~linux-kernel-markers-kconfig-menus arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~linux-kernel-markers-kconfig-menus
+++ a/arch/powerpc/Kconfig
@@ -1237,6 +1237,9 @@ config KPROBES
 	  a probepoint and specifies the callback.  Kprobes is useful
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".
+
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/powerpc/Kconfig.debug"
diff -puN arch/ppc/Kconfig~linux-kernel-markers-kconfig-menus arch/ppc/Kconfig
--- a/arch/ppc/Kconfig~linux-kernel-markers-kconfig-menus
+++ a/arch/ppc/Kconfig
@@ -1436,8 +1436,14 @@ endmenu
 
 source "lib/Kconfig"
 
+menu "Instrumentation Support"
+
 source "arch/powerpc/oprofile/Kconfig"
 
+source "kernel/Kconfig.marker"
+
+endmenu
+
 source "arch/ppc/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/s390/Kconfig~linux-kernel-markers-kconfig-menus arch/s390/Kconfig
--- a/arch/s390/Kconfig~linux-kernel-markers-kconfig-menus
+++ a/arch/s390/Kconfig
@@ -546,6 +546,8 @@ config KPROBES
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/s390/Kconfig.debug"
diff -puN arch/sh/Kconfig~linux-kernel-markers-kconfig-menus arch/sh/Kconfig
--- a/arch/sh/Kconfig~linux-kernel-markers-kconfig-menus
+++ a/arch/sh/Kconfig
@@ -712,6 +712,12 @@ source "fs/Kconfig"
 
 source "arch/sh/oprofile/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.marker"
+
+endmenu
+
 source "arch/sh/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/sh64/Kconfig~linux-kernel-markers-kconfig-menus arch/sh64/Kconfig
--- a/arch/sh64/Kconfig~linux-kernel-markers-kconfig-menus
+++ a/arch/sh64/Kconfig
@@ -281,6 +281,12 @@ source "fs/Kconfig"
 
 source "arch/sh64/oprofile/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.marker"
+
+endmenu
+
 source "arch/sh64/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/sparc/Kconfig~linux-kernel-markers-kconfig-menus arch/sparc/Kconfig
--- a/arch/sparc/Kconfig~linux-kernel-markers-kconfig-menus
+++ a/arch/sparc/Kconfig
@@ -306,6 +306,8 @@ menu "Instrumentation Support"
 
 source "arch/sparc/oprofile/Kconfig"
 
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/sparc/Kconfig.debug"
diff -puN arch/sparc64/Kconfig~linux-kernel-markers-kconfig-menus arch/sparc64/Kconfig
--- a/arch/sparc64/Kconfig~linux-kernel-markers-kconfig-menus
+++ a/arch/sparc64/Kconfig
@@ -439,6 +439,9 @@ config KPROBES
 	  a probepoint and specifies the callback.  Kprobes is useful
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".
+
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/sparc64/Kconfig.debug"
diff -puN arch/um/Kconfig~linux-kernel-markers-kconfig-menus arch/um/Kconfig
--- a/arch/um/Kconfig~linux-kernel-markers-kconfig-menus
+++ a/arch/um/Kconfig
@@ -347,4 +347,10 @@ config INPUT
 	bool
 	default n
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.marker"
+
+endmenu
+
 source "arch/um/Kconfig.debug"
diff -puN arch/v850/Kconfig~linux-kernel-markers-kconfig-menus arch/v850/Kconfig
--- a/arch/v850/Kconfig~linux-kernel-markers-kconfig-menus
+++ a/arch/v850/Kconfig
@@ -335,6 +335,12 @@ source "sound/Kconfig"
 
 source "drivers/usb/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.marker"
+
+endmenu
+
 source "arch/v850/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/x86_64/Kconfig~linux-kernel-markers-kconfig-menus arch/x86_64/Kconfig
--- a/arch/x86_64/Kconfig~linux-kernel-markers-kconfig-menus
+++ a/arch/x86_64/Kconfig
@@ -753,6 +753,9 @@ config KPROBES
 	  a probepoint and specifies the callback.  Kprobes is useful
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".
+
+source "kernel/Kconfig.marker"
+
 endmenu
 
 source "arch/x86_64/Kconfig.debug"
diff -puN arch/xtensa/Kconfig~linux-kernel-markers-kconfig-menus arch/xtensa/Kconfig
--- a/arch/xtensa/Kconfig~linux-kernel-markers-kconfig-menus
+++ a/arch/xtensa/Kconfig
@@ -251,6 +251,12 @@ config EMBEDDED_RAMDISK_IMAGE
 	  provide one yourself.
 endmenu
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.marker"
+
+endmenu
+
 source "arch/xtensa/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN /dev/null kernel/Kconfig.marker
--- /dev/null
+++ a/kernel/Kconfig.marker
@@ -0,0 +1,17 @@
+# Code markers configuration
+
+config MARKERS
+	bool "Activate markers"
+	select MODULES
+	default n
+	help
+	  Place an empty function call at each marker site. Can be
+	  dynamically changed for a probe function.
+
+config MARKERS_ENABLE_OPTIMIZATION
+	bool "Enable marker optimization"
+	depends on MARKERS
+	default y
+	help
+	  Disable code replacement jump optimisations. Especially useful if your
+	  code is in a read-only rom/flash.
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
git-mips.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-alpha.patch
atomich-complete-atomic_long-operations-in-asm-generic.patch
atomich-i386-type-safety-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-ia64.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-mips.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-parisc.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-sparc64.patch
atomich-add-atomic64_xchg-to-s390.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-x86_64.patch
atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency.patch
local_t-architecture-independant-extension.patch
local_t-alpha-extension.patch
local_t-i386-extension.patch
local_t-ia64-extension.patch
local_t-mips-extension.patch
local_t-parisc-cleanup.patch
local_t-powerpc-extension.patch
local_t-s390-cleanup.patch
local_t-sparc64-cleanup.patch
local_t-x86_64-extension.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-powerpc-optimization.patch
linux-kernel-markers-i386-optimization.patch
linux-kernel-markers-non-optimized-architectures.patch
