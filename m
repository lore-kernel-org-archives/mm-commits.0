From: akpm@linux-foundation.org
Subject: - immediate-value-add-kconfig-menus.patch removed from -mm tree
Date: Fri, 06 Jul 2007 17:28:42 -0700
Message-ID: <200707070032.l670Wrf0029805@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56455 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753461AbXGGAdT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jul 2007 20:33:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, andi@firstfloor.org, bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     Immediate Value: add kconfig menus
has been removed from the -mm tree.  Its filename was
     immediate-value-add-kconfig-menus.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: Immediate Value: add kconfig menus
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Immediate values provide a way to compile in kernels features that can be
enabled dynamically, with a very small footprint when disabled.

This patch:

Add Kconfig menus for the marker code.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Adrian Bunk <bunk@stusta.de>
CC: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/Kconfig       |    6 ++++++
 arch/arm/Kconfig         |    6 ++++++
 arch/arm26/Kconfig       |    6 ++++++
 arch/avr32/Kconfig.debug |    7 +++++++
 arch/cris/Kconfig        |    6 ++++++
 arch/frv/Kconfig         |    6 ++++++
 arch/h8300/Kconfig       |    6 ++++++
 arch/i386/Kconfig        |    2 ++
 arch/ia64/Kconfig        |    3 +++
 arch/m32r/Kconfig        |    6 ++++++
 arch/m68k/Kconfig        |    6 ++++++
 arch/m68knommu/Kconfig   |    6 ++++++
 arch/mips/Kconfig        |    6 ++++++
 arch/parisc/Kconfig      |    6 ++++++
 arch/powerpc/Kconfig     |    3 +++
 arch/ppc/Kconfig         |    6 ++++++
 arch/s390/Kconfig        |    2 ++
 arch/sh/Kconfig          |    6 ++++++
 arch/sh64/Kconfig        |    6 ++++++
 arch/sparc/Kconfig       |    2 ++
 arch/sparc64/Kconfig     |    3 +++
 arch/um/Kconfig          |    6 ++++++
 arch/v850/Kconfig        |    6 ++++++
 arch/x86_64/Kconfig      |    3 +++
 arch/xtensa/Kconfig      |    6 ++++++
 kernel/Kconfig.immediate |    9 +++++++++
 26 files changed, 136 insertions(+)

diff -puN arch/alpha/Kconfig~immediate-value-add-kconfig-menus arch/alpha/Kconfig
--- a/arch/alpha/Kconfig~immediate-value-add-kconfig-menus
+++ a/arch/alpha/Kconfig
@@ -653,6 +653,12 @@ source "fs/Kconfig"
 
 source "arch/alpha/oprofile/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.immediate"
+
+endmenu
+
 source "arch/alpha/Kconfig.debug"
 
 # DUMMY_CONSOLE may be defined in drivers/video/console/Kconfig
diff -puN arch/arm/Kconfig~immediate-value-add-kconfig-menus arch/arm/Kconfig
--- a/arch/arm/Kconfig~immediate-value-add-kconfig-menus
+++ a/arch/arm/Kconfig
@@ -1046,6 +1046,12 @@ source "fs/Kconfig"
 
 source "arch/arm/oprofile/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.immediate"
+
+endmenu
+
 source "arch/arm/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/arm26/Kconfig~immediate-value-add-kconfig-menus arch/arm26/Kconfig
--- a/arch/arm26/Kconfig~immediate-value-add-kconfig-menus
+++ a/arch/arm26/Kconfig
@@ -244,6 +244,12 @@ source "drivers/misc/Kconfig"
 
 source "drivers/usb/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.immediate"
+
+endmenu
+
 source "arch/arm26/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/avr32/Kconfig.debug~immediate-value-add-kconfig-menus arch/avr32/Kconfig.debug
--- a/arch/avr32/Kconfig.debug~immediate-value-add-kconfig-menus
+++ a/arch/avr32/Kconfig.debug
@@ -6,6 +6,9 @@ config TRACE_IRQFLAGS_SUPPORT
 
 source "lib/Kconfig.debug"
 
+menu "Instrumentation Support"
+	depends on EXPERIMENTAL
+
 config KPROBES
 	bool "Kprobes"
 	depends on DEBUG_KERNEL
@@ -16,4 +19,8 @@ config KPROBES
           for kernel debugging, non-intrusive instrumentation and testing.
           If in doubt, say "N".
 
+source "kernel/Kconfig.immediate"
+
+endmenu
+
 endmenu
diff -puN arch/cris/Kconfig~immediate-value-add-kconfig-menus arch/cris/Kconfig
--- a/arch/cris/Kconfig~immediate-value-add-kconfig-menus
+++ a/arch/cris/Kconfig
@@ -198,6 +198,12 @@ source "sound/Kconfig"
 
 source "drivers/usb/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.immediate"
+
+endmenu
+
 source "arch/cris/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/frv/Kconfig~immediate-value-add-kconfig-menus arch/frv/Kconfig
--- a/arch/frv/Kconfig~immediate-value-add-kconfig-menus
+++ a/arch/frv/Kconfig
@@ -375,6 +375,12 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.immediate"
+
+endmenu
+
 source "arch/frv/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/h8300/Kconfig~immediate-value-add-kconfig-menus arch/h8300/Kconfig
--- a/arch/h8300/Kconfig~immediate-value-add-kconfig-menus
+++ a/arch/h8300/Kconfig
@@ -223,6 +223,12 @@ endmenu
 
 source "fs/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.immediate"
+
+endmenu
+
 source "arch/h8300/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/i386/Kconfig~immediate-value-add-kconfig-menus arch/i386/Kconfig
--- a/arch/i386/Kconfig~immediate-value-add-kconfig-menus
+++ a/arch/i386/Kconfig
@@ -1260,6 +1260,8 @@ config KPROBES
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".
 
+source "kernel/Kconfig.immediate"
+
 endif # INSTRUMENTATION
 
 source "arch/i386/Kconfig.debug"
diff -puN arch/ia64/Kconfig~immediate-value-add-kconfig-menus arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~immediate-value-add-kconfig-menus
+++ a/arch/ia64/Kconfig
@@ -593,6 +593,9 @@ config KPROBES
 	  a probepoint and specifies the callback.  Kprobes is useful
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".
+
+source "kernel/Kconfig.immediate"
+
 endmenu
 
 source "arch/ia64/Kconfig.debug"
diff -puN arch/m32r/Kconfig~immediate-value-add-kconfig-menus arch/m32r/Kconfig
--- a/arch/m32r/Kconfig~immediate-value-add-kconfig-menus
+++ a/arch/m32r/Kconfig
@@ -408,6 +408,12 @@ source "fs/Kconfig"
 
 source "arch/m32r/oprofile/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.immediate"
+
+endmenu
+
 source "arch/m32r/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/m68k/Kconfig~immediate-value-add-kconfig-menus arch/m68k/Kconfig
--- a/arch/m68k/Kconfig~immediate-value-add-kconfig-menus
+++ a/arch/m68k/Kconfig
@@ -676,6 +676,12 @@ endmenu
 
 source "fs/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.immediate"
+
+endmenu
+
 source "arch/m68k/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/m68knommu/Kconfig~immediate-value-add-kconfig-menus arch/m68knommu/Kconfig
--- a/arch/m68knommu/Kconfig~immediate-value-add-kconfig-menus
+++ a/arch/m68knommu/Kconfig
@@ -668,6 +668,12 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.immediate"
+
+endmenu
+
 source "arch/m68knommu/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/mips/Kconfig~immediate-value-add-kconfig-menus arch/mips/Kconfig
--- a/arch/mips/Kconfig~immediate-value-add-kconfig-menus
+++ a/arch/mips/Kconfig
@@ -1946,6 +1946,12 @@ source "fs/Kconfig"
 
 source "arch/mips/oprofile/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.immediate"
+
+endmenu
+
 source "arch/mips/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/parisc/Kconfig~immediate-value-add-kconfig-menus arch/parisc/Kconfig
--- a/arch/parisc/Kconfig~immediate-value-add-kconfig-menus
+++ a/arch/parisc/Kconfig
@@ -269,6 +269,12 @@ source "fs/Kconfig"
 
 source "arch/parisc/oprofile/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.immediate"
+
+endmenu
+
 source "arch/parisc/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/powerpc/Kconfig~immediate-value-add-kconfig-menus arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~immediate-value-add-kconfig-menus
+++ a/arch/powerpc/Kconfig
@@ -646,6 +646,9 @@ config KPROBES
 	  a probepoint and specifies the callback.  Kprobes is useful
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".
+
+source "kernel/Kconfig.immediate"
+
 endmenu
 
 source "arch/powerpc/Kconfig.debug"
diff -puN arch/ppc/Kconfig~immediate-value-add-kconfig-menus arch/ppc/Kconfig
--- a/arch/ppc/Kconfig~immediate-value-add-kconfig-menus
+++ a/arch/ppc/Kconfig
@@ -1451,8 +1451,14 @@ endmenu
 
 source "lib/Kconfig"
 
+menu "Instrumentation Support"
+
 source "arch/powerpc/oprofile/Kconfig"
 
+source "kernel/Kconfig.immediate"
+
+endmenu
+
 source "arch/ppc/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/s390/Kconfig~immediate-value-add-kconfig-menus arch/s390/Kconfig
--- a/arch/s390/Kconfig~immediate-value-add-kconfig-menus
+++ a/arch/s390/Kconfig
@@ -547,6 +547,8 @@ config KPROBES
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".
 
+source "kernel/Kconfig.immediate"
+
 endmenu
 
 source "arch/s390/Kconfig.debug"
diff -puN arch/sh/Kconfig~immediate-value-add-kconfig-menus arch/sh/Kconfig
--- a/arch/sh/Kconfig~immediate-value-add-kconfig-menus
+++ a/arch/sh/Kconfig
@@ -736,6 +736,12 @@ source "fs/Kconfig"
 
 source "arch/sh/oprofile/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.immediate"
+
+endmenu
+
 source "arch/sh/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/sh64/Kconfig~immediate-value-add-kconfig-menus arch/sh64/Kconfig
--- a/arch/sh64/Kconfig~immediate-value-add-kconfig-menus
+++ a/arch/sh64/Kconfig
@@ -284,6 +284,12 @@ source "fs/Kconfig"
 
 source "arch/sh64/oprofile/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.immediate"
+
+endmenu
+
 source "arch/sh64/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/sparc/Kconfig~immediate-value-add-kconfig-menus arch/sparc/Kconfig
--- a/arch/sparc/Kconfig~immediate-value-add-kconfig-menus
+++ a/arch/sparc/Kconfig
@@ -313,6 +313,8 @@ menu "Instrumentation Support"
 
 source "arch/sparc/oprofile/Kconfig"
 
+source "kernel/Kconfig.immediate"
+
 endmenu
 
 source "arch/sparc/Kconfig.debug"
diff -puN arch/sparc64/Kconfig~immediate-value-add-kconfig-menus arch/sparc64/Kconfig
--- a/arch/sparc64/Kconfig~immediate-value-add-kconfig-menus
+++ a/arch/sparc64/Kconfig
@@ -451,6 +451,9 @@ config KPROBES
 	  a probepoint and specifies the callback.  Kprobes is useful
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".
+
+source "kernel/Kconfig.immediate"
+
 endmenu
 
 source "arch/sparc64/Kconfig.debug"
diff -puN arch/um/Kconfig~immediate-value-add-kconfig-menus arch/um/Kconfig
--- a/arch/um/Kconfig~immediate-value-add-kconfig-menus
+++ a/arch/um/Kconfig
@@ -335,4 +335,10 @@ config INPUT
 	bool
 	default n
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.immediate"
+
+endmenu
+
 source "arch/um/Kconfig.debug"
diff -puN arch/v850/Kconfig~immediate-value-add-kconfig-menus arch/v850/Kconfig
--- a/arch/v850/Kconfig~immediate-value-add-kconfig-menus
+++ a/arch/v850/Kconfig
@@ -331,6 +331,12 @@ source "sound/Kconfig"
 
 source "drivers/usb/Kconfig"
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.immediate"
+
+endmenu
+
 source "arch/v850/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/x86_64/Kconfig~immediate-value-add-kconfig-menus arch/x86_64/Kconfig
--- a/arch/x86_64/Kconfig~immediate-value-add-kconfig-menus
+++ a/arch/x86_64/Kconfig
@@ -842,6 +842,9 @@ config KPROBES
 	  a probepoint and specifies the callback.  Kprobes is useful
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".
+
+source "kernel/Kconfig.immediate"
+
 endmenu
 
 source "arch/x86_64/Kconfig.debug"
diff -puN arch/xtensa/Kconfig~immediate-value-add-kconfig-menus arch/xtensa/Kconfig
--- a/arch/xtensa/Kconfig~immediate-value-add-kconfig-menus
+++ a/arch/xtensa/Kconfig
@@ -251,6 +251,12 @@ config EMBEDDED_RAMDISK_IMAGE
 	  provide one yourself.
 endmenu
 
+menu "Instrumentation Support"
+
+source "kernel/Kconfig.immediate"
+
+endmenu
+
 source "arch/xtensa/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN /dev/null kernel/Kconfig.immediate
--- /dev/null
+++ a/kernel/Kconfig.immediate
@@ -0,0 +1,9 @@
+# Immediate values configuration
+
+config IMMEDIATE
+	bool "Use self-modifying code to provide fast immediate values"
+	help
+	  Provides a way to use immediate values acting as global values to
+	  dynamically enable kernel features while having a very small
+	  footprint when disabled. You may want to disable this feature if you
+	  run your kernel code on a read-only rom/flash.
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

powerpc-promc-remove-undef-printk.patch
immediate-value-add-kconfig-menus.patch
immediate-values-kprobe-header-fix.patch
immediate-value-i386-optimization.patch
immediate-value-powerpc-optimization.patch
immediate-value-documentation.patch
f00f-bug-fixup-for-i386-use-immediate-values.patch
scheduler-profiling-use-immediate-values.patch
scheduler-profiling-use-immediate-values-fix.patch
cxgb3-vs-immediate-stuff.patch
use-data_data-in-cris.patch
add-missing-data_data-in-powerpc.patch
use-data_data-in-xtensa.patch
linux-kernel-markers-architecture-independent-code.patch
linux-kernel-markers-add-kconfig-menus-for-the-marker-code.patch
linux-kernel-markers-documentation.patch
port-of-blktrace-to-the-linux-kernel-markers.patch
port-of-blktrace-to-the-linux-kernel-markers-fix.patch
