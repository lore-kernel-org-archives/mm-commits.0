From: akpm@linux-foundation.org
Subject: + combine-instrumentation-menus-in-kernel-kconfiginstrumentation.patch added to -mm tree
Date: Fri, 28 Sep 2007 15:41:18 -0700
Message-ID: <200709282241.l8SMfI82020916@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48934 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754937AbXI1Wl4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 Sep 2007 18:41:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, randy.dunlap@oracle.com


The patch titled
     Combine instrumentation menus in kernel/Kconfig.instrumentation
has been added to the -mm tree.  Its filename is
     combine-instrumentation-menus-in-kernel-kconfiginstrumentation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Combine instrumentation menus in kernel/Kconfig.instrumentation
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Quoting Randy:

"It seems sad that this patch sources Kconfig.marker, a 7-line file,
20-something times.  Yes, you (we) don't want to put those 7 lines into
20-something different files, so sourcing is the right thing.

However, what you did for avr32 seems more on the right track to me: make
_one_ Instrumentation support menu that includes PROFILING, OPROFILE, KPROBES,
and MARKERS and then use (source) that in all of the arches."

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN arch/alpha/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation arch/alpha/Kconfig
--- a/arch/alpha/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation
+++ a/arch/alpha/Kconfig
@@ -654,7 +654,7 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "arch/alpha/oprofile/Kconfig"
+source "kernel/Kconfig.instrumentation"
 
 source "arch/alpha/Kconfig.debug"
 
diff -puN arch/alpha/oprofile/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation /dev/null
--- a/arch/alpha/oprofile/Kconfig
+++ /dev/null
@@ -1,23 +0,0 @@
-
-menu "Profiling support"
-	depends on EXPERIMENTAL
-
-config PROFILING
-	bool "Profiling support (EXPERIMENTAL)"
-	help
-	  Say Y here to enable the extended profiling support mechanisms used
-	  by profilers such as OProfile.
-	  
-
-config OPROFILE
-	tristate "OProfile system profiling (EXPERIMENTAL)"
-	depends on PROFILING
-	help
-	  OProfile is a profiling system capable of profiling the
-	  whole system, include the kernel, kernel modules, libraries,
-	  and applications.
-
-	  If unsure, say N.
-
-endmenu
-
diff -puN arch/arm/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation arch/arm/Kconfig
--- a/arch/arm/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation
+++ a/arch/arm/Kconfig
@@ -1061,7 +1061,7 @@ endmenu
 
 source "fs/Kconfig"
 
-source "arch/arm/oprofile/Kconfig"
+source "kernel/Kconfig.instrumentation"
 
 source "arch/arm/Kconfig.debug"
 
diff -puN arch/arm/oprofile/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation /dev/null
--- a/arch/arm/oprofile/Kconfig
+++ /dev/null
@@ -1,42 +0,0 @@
-
-menu "Profiling support"
-	depends on EXPERIMENTAL
-
-config PROFILING
-	bool "Profiling support (EXPERIMENTAL)"
-	help
-	  Say Y here to enable the extended profiling support mechanisms used
-	  by profilers such as OProfile.
-
-
-config OPROFILE
-	tristate "OProfile system profiling (EXPERIMENTAL)"
-	depends on PROFILING
-	help
-	  OProfile is a profiling system capable of profiling the
-	  whole system, include the kernel, kernel modules, libraries,
-	  and applications.
-
-	  If unsure, say N.
-
-if OPROFILE
-
-config OPROFILE_ARMV6
-	bool
-	depends on CPU_V6 && !SMP
-	default y
-	select OPROFILE_ARM11_CORE
-
-config OPROFILE_MPCORE
-	bool
-	depends on CPU_V6 && SMP
-	default y
-	select OPROFILE_ARM11_CORE
-
-config OPROFILE_ARM11_CORE
-	bool
-
-endif
-
-endmenu
-
diff -puN arch/blackfin/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation arch/blackfin/Kconfig
--- a/arch/blackfin/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation
+++ a/arch/blackfin/Kconfig
@@ -914,7 +914,7 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "arch/blackfin/oprofile/Kconfig"
+source "kernel/Kconfig.instrumentation"
 
 menu "Kernel hacking"
 
diff -puN arch/blackfin/oprofile/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation /dev/null
--- a/arch/blackfin/oprofile/Kconfig
+++ /dev/null
@@ -1,29 +0,0 @@
-menu "Profiling support"
-depends on EXPERIMENTAL
-
-config PROFILING
-	bool "Profiling support (EXPERIMENTAL)"
-	help
-	  Say Y here to enable the extended profiling support mechanisms used
-	  by profilers such as OProfile.
-
-config OPROFILE
-	tristate "OProfile system profiling (EXPERIMENTAL)"
-	depends on PROFILING
-	help
-	  OProfile is a profiling system capable of profiling the
-	  whole system, include the kernel, kernel modules, libraries,
-	  and applications.
-
-	  If unsure, say N.
-
-config HARDWARE_PM
-	tristate "Hardware Performance Monitor Profiling"
-	depends on PROFILING
-	help
-	  take use of hardware performance monitor to profiling the kernel
-	  and application.
-
-	  If unsure, say N.
-
-endmenu
diff -puN arch/cris/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation arch/cris/Kconfig
--- a/arch/cris/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation
+++ a/arch/cris/Kconfig
@@ -196,6 +196,8 @@ source "sound/Kconfig"
 
 source "drivers/usb/Kconfig"
 
+source "kernel/Kconfig.instrumentation"
+
 source "arch/cris/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/frv/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation arch/frv/Kconfig
--- a/arch/frv/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation
+++ a/arch/frv/Kconfig
@@ -375,6 +375,8 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
+source "kernel/Kconfig.instrumentation"
+
 source "arch/frv/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/h8300/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation arch/h8300/Kconfig
--- a/arch/h8300/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation
+++ a/arch/h8300/Kconfig
@@ -223,6 +223,8 @@ endmenu
 
 source "fs/Kconfig"
 
+source "kernel/Kconfig.instrumentation"
+
 source "arch/h8300/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/i386/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation arch/i386/Kconfig
--- a/arch/i386/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation
+++ a/arch/i386/Kconfig
@@ -1251,30 +1251,7 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-menuconfig INSTRUMENTATION
-	bool "Instrumentation Support"
-	default y
-	---help---
-	  Say Y here to get to see options related to performance measurement,
-	  debugging, and testing. This option alone does not add any kernel code.
-
-	  If you say N, all options in this submenu will be skipped and disabled.
-
-if INSTRUMENTATION
-
-source "arch/i386/oprofile/Kconfig"
-
-config KPROBES
-	bool "Kprobes"
-	depends on KALLSYMS && MODULES
-	help
-	  Kprobes allows you to trap at almost any kernel address and
-	  execute a callback function.  register_kprobe() establishes
-	  a probepoint and specifies the callback.  Kprobes is useful
-	  for kernel debugging, non-intrusive instrumentation and testing.
-	  If in doubt, say "N".
-
-endif # INSTRUMENTATION
+source "kernel/Kconfig.instrumentation"
 
 source "arch/i386/Kconfig.debug"
 
diff -puN arch/i386/oprofile/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation /dev/null
--- a/arch/i386/oprofile/Kconfig
+++ /dev/null
@@ -1,17 +0,0 @@
-config PROFILING
-	bool "Profiling support (EXPERIMENTAL)"
-	help
-	  Say Y here to enable the extended profiling support mechanisms used
-	  by profilers such as OProfile.
-	  
-
-config OPROFILE
-	tristate "OProfile system profiling (EXPERIMENTAL)"
-	depends on PROFILING
-	help
-	  OProfile is a profiling system capable of profiling the
-	  whole system, include the kernel, kernel modules, libraries,
-	  and applications.
-
-	  If unsure, say N.
-
diff -puN arch/ia64/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation
+++ a/arch/ia64/Kconfig
@@ -582,20 +582,7 @@ config IRQ_PER_CPU
 
 source "arch/ia64/hp/sim/Kconfig"
 
-menu "Instrumentation Support"
-
-source "arch/ia64/oprofile/Kconfig"
-
-config KPROBES
-	bool "Kprobes"
-	depends on KALLSYMS && MODULES
-	help
-	  Kprobes allows you to trap at almost any kernel address and
-	  execute a callback function.  register_kprobe() establishes
-	  a probepoint and specifies the callback.  Kprobes is useful
-	  for kernel debugging, non-intrusive instrumentation and testing.
-	  If in doubt, say "N".
-endmenu
+source "kernel/Kconfig.instrumentation"
 
 source "arch/ia64/Kconfig.debug"
 
diff -puN arch/ia64/oprofile/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation /dev/null
--- a/arch/ia64/oprofile/Kconfig
+++ /dev/null
@@ -1,20 +0,0 @@
-config PROFILING
-	bool "Profiling support (EXPERIMENTAL)"
-	help
-	  Say Y here to enable the extended profiling support mechanisms used
-	  by profilers such as OProfile.
-
-config OPROFILE
-	tristate "OProfile system profiling (EXPERIMENTAL)"
-	depends on PROFILING
-	help
-	  OProfile is a profiling system capable of profiling the
-	  whole system, include the kernel, kernel modules, libraries,
-	  and applications.
-
-	  Due to firmware bugs, you may need to use the "nohalt" boot
-	  option if you're using OProfile with the hardware performance
-	  counters.
-
-	  If unsure, say N.
-
diff -puN arch/m32r/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation arch/m32r/Kconfig
--- a/arch/m32r/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation
+++ a/arch/m32r/Kconfig
@@ -426,7 +426,7 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "arch/m32r/oprofile/Kconfig"
+source "kernel/Kconfig.instrumentation"
 
 source "arch/m32r/Kconfig.debug"
 
diff -puN arch/m32r/oprofile/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation /dev/null
--- a/arch/m32r/oprofile/Kconfig
+++ /dev/null
@@ -1,23 +0,0 @@
-
-menu "Profiling support"
-	depends on EXPERIMENTAL
-
-config PROFILING
-	bool "Profiling support (EXPERIMENTAL)"
-	help
-	  Say Y here to enable the extended profiling support mechanisms used
-	  by profilers such as OProfile.
-
-
-config OPROFILE
-	tristate "OProfile system profiling (EXPERIMENTAL)"
-	depends on PROFILING
-	help
-	  OProfile is a profiling system capable of profiling the
-	  whole system, include the kernel, kernel modules, libraries,
-	  and applications.
-
-	  If unsure, say N.
-
-endmenu
-
diff -puN arch/m68k/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation arch/m68k/Kconfig
--- a/arch/m68k/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation
+++ a/arch/m68k/Kconfig
@@ -683,6 +683,8 @@ endmenu
 
 source "fs/Kconfig"
 
+source "kernel/Kconfig.instrumentation"
+
 source "arch/m68k/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/m68knommu/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation arch/m68knommu/Kconfig
--- a/arch/m68knommu/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation
+++ a/arch/m68knommu/Kconfig
@@ -696,6 +696,8 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
+source "kernel/Kconfig.instrumentation"
+
 source "arch/m68knommu/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/mips/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation arch/mips/Kconfig
--- a/arch/mips/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation
+++ a/arch/mips/Kconfig
@@ -1961,7 +1961,7 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "arch/mips/oprofile/Kconfig"
+source "kernel/Kconfig.instrumentation"
 
 source "arch/mips/Kconfig.debug"
 
diff -puN arch/mips/oprofile/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation /dev/null
--- a/arch/mips/oprofile/Kconfig
+++ /dev/null
@@ -1,23 +0,0 @@
-
-menu "Profiling support"
-	depends on EXPERIMENTAL
-
-config PROFILING
-	bool "Profiling support (EXPERIMENTAL)"
-	help
-	  Say Y here to enable the extended profiling support mechanisms used
-	  by profilers such as OProfile.
-
-
-config OPROFILE
-	tristate "OProfile system profiling (EXPERIMENTAL)"
-	depends on PROFILING && !MIPS_MT_SMTC && EXPERIMENTAL
-	help
-	  OProfile is a profiling system capable of profiling the
-	  whole system, include the kernel, kernel modules, libraries,
-	  and applications.
-
-	  If unsure, say N.
-
-endmenu
-
diff -puN arch/parisc/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation arch/parisc/Kconfig
--- a/arch/parisc/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation
+++ a/arch/parisc/Kconfig
@@ -267,7 +267,7 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "arch/parisc/oprofile/Kconfig"
+source "kernel/Kconfig.instrumentation"
 
 source "arch/parisc/Kconfig.debug"
 
diff -puN arch/parisc/oprofile/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation /dev/null
--- a/arch/parisc/oprofile/Kconfig
+++ /dev/null
@@ -1,23 +0,0 @@
-
-menu "Profiling support"
-	depends on EXPERIMENTAL
-
-config PROFILING
-	bool "Profiling support (EXPERIMENTAL)"
-	help
-	  Say Y here to enable the extended profiling support mechanisms used
-	  by profilers such as OProfile.
-	  
-
-config OPROFILE
-	tristate "OProfile system profiling (EXPERIMENTAL)"
-	depends on PROFILING
-	help
-	  OProfile is a profiling system capable of profiling the
-	  whole system, include the kernel, kernel modules, libraries,
-	  and applications.
-
-	  If unsure, say N.
-
-endmenu
-
diff -puN arch/powerpc/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation
+++ a/arch/powerpc/Kconfig
@@ -638,20 +638,7 @@ source "arch/powerpc/sysdev/qe_lib/Kconf
 
 source "lib/Kconfig"
 
-menu "Instrumentation Support"
-
-source "arch/powerpc/oprofile/Kconfig"
-
-config KPROBES
-	bool "Kprobes"
-	depends on !BOOKE && !4xx && KALLSYMS && MODULES
-	help
-	  Kprobes allows you to trap at almost any kernel address and
-	  execute a callback function.  register_kprobe() establishes
-	  a probepoint and specifies the callback.  Kprobes is useful
-	  for kernel debugging, non-intrusive instrumentation and testing.
-	  If in doubt, say "N".
-endmenu
+source "kernel/Kconfig.instrumentation"
 
 source "arch/powerpc/Kconfig.debug"
 
diff -puN arch/powerpc/oprofile/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation /dev/null
--- a/arch/powerpc/oprofile/Kconfig
+++ /dev/null
@@ -1,24 +0,0 @@
-config PROFILING
-	bool "Profiling support (EXPERIMENTAL)"
-	help
-	  Say Y here to enable the extended profiling support mechanisms used
-	  by profilers such as OProfile.
-
-
-config OPROFILE
-	tristate "OProfile system profiling (EXPERIMENTAL)"
-	depends on PROFILING
-	help
-	  OProfile is a profiling system capable of profiling the
-	  whole system, include the kernel, kernel modules, libraries,
-	  and applications.
-
-	  If unsure, say N.
-
-config OPROFILE_CELL
-	bool "OProfile for Cell Broadband Engine"
-	depends on (SPU_FS = y && OPROFILE = m) || (SPU_FS = y && OPROFILE = y) || (SPU_FS = m && OPROFILE = m)
-	default y
-	help
-	  Profiling of Cell BE SPUs requires special support enabled
-	  by this option.
diff -puN arch/ppc/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation arch/ppc/Kconfig
--- a/arch/ppc/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation
+++ a/arch/ppc/Kconfig
@@ -1307,7 +1307,7 @@ endmenu
 
 source "lib/Kconfig"
 
-source "arch/powerpc/oprofile/Kconfig"
+source "kernel/Kconfig.instrumentation"
 
 source "arch/ppc/Kconfig.debug"
 
diff -puN arch/s390/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation arch/s390/Kconfig
--- a/arch/s390/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation
+++ a/arch/s390/Kconfig
@@ -529,21 +529,7 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-menu "Instrumentation Support"
-
-source "arch/s390/oprofile/Kconfig"
-
-config KPROBES
-	bool "Kprobes (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && MODULES
-	help
-	  Kprobes allows you to trap at almost any kernel address and
-	  execute a callback function.	register_kprobe() establishes
-	  a probepoint and specifies the callback.  Kprobes is useful
-	  for kernel debugging, non-intrusive instrumentation and testing.
-	  If in doubt, say "N".
-
-endmenu
+source "kernel/Kconfig.instrumentation"
 
 source "arch/s390/Kconfig.debug"
 
diff -puN arch/s390/oprofile/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation /dev/null
--- a/arch/s390/oprofile/Kconfig
+++ /dev/null
@@ -1,22 +0,0 @@
-
-menu "Profiling support"
-
-config PROFILING
-	bool "Profiling support"
-	help
-	  Say Y here to enable profiling support mechanisms used by
-	  profilers such as readprofile or OProfile.
-
-
-config OPROFILE
-	tristate "OProfile system profiling"
-	depends on PROFILING
-	help
-	  OProfile is a profiling system capable of profiling the
-	  whole system, include the kernel, kernel modules, libraries,
-	  and applications.
-
-	  If unsure, say N.
-
-endmenu
-
diff -puN arch/sh/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation arch/sh/Kconfig
--- a/arch/sh/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation
+++ a/arch/sh/Kconfig
@@ -749,7 +749,7 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "arch/sh/oprofile/Kconfig"
+source "kernel/Kconfig.instrumentation"
 
 source "arch/sh/Kconfig.debug"
 
diff -puN arch/sh/oprofile/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation /dev/null
--- a/arch/sh/oprofile/Kconfig
+++ /dev/null
@@ -1,23 +0,0 @@
-
-menu "Profiling support"
-	depends on EXPERIMENTAL
-
-config PROFILING
-	bool "Profiling support (EXPERIMENTAL)"
-	help
-	  Say Y here to enable the extended profiling support mechanisms used
-	  by profilers such as OProfile.
-	  
-
-config OPROFILE
-	tristate "OProfile system profiling (EXPERIMENTAL)"
-	depends on PROFILING
-	help
-	  OProfile is a profiling system capable of profiling the
-	  whole system, include the kernel, kernel modules, libraries,
-	  and applications.
-
-	  If unsure, say N.
-
-endmenu
-
diff -puN arch/sh64/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation arch/sh64/Kconfig
--- a/arch/sh64/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation
+++ a/arch/sh64/Kconfig
@@ -285,7 +285,7 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "arch/sh64/oprofile/Kconfig"
+source "kernel/Kconfig.instrumentation"
 
 source "arch/sh64/Kconfig.debug"
 
diff -puN arch/sh64/oprofile/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation /dev/null
--- a/arch/sh64/oprofile/Kconfig
+++ /dev/null
@@ -1,23 +0,0 @@
-
-menu "Profiling support"
-	depends on EXPERIMENTAL
-
-config PROFILING
-	bool "Profiling support (EXPERIMENTAL)"
-	help
-	  Say Y here to enable the extended profiling support mechanisms used
-	  by profilers such as OProfile.
-
-
-config OPROFILE
-	tristate "OProfile system profiling (EXPERIMENTAL)"
-	depends on PROFILING
-	help
-	  OProfile is a profiling system capable of profiling the
-	  whole system, include the kernel, kernel modules, libraries,
-	  and applications.
-
-	  If unsure, say N.
-
-endmenu
-
diff -puN arch/sparc/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation arch/sparc/Kconfig
--- a/arch/sparc/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation
+++ a/arch/sparc/Kconfig
@@ -320,11 +320,7 @@ endmenu
 
 source "fs/Kconfig"
 
-menu "Instrumentation Support"
-
-source "arch/sparc/oprofile/Kconfig"
-
-endmenu
+source "kernel/Kconfig.instrumentation"
 
 source "arch/sparc/Kconfig.debug"
 
diff -puN arch/sparc/oprofile/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation /dev/null
--- a/arch/sparc/oprofile/Kconfig
+++ /dev/null
@@ -1,17 +0,0 @@
-config PROFILING
-	bool "Profiling support (EXPERIMENTAL)"
-	help
-	  Say Y here to enable the extended profiling support mechanisms used
-	  by profilers such as OProfile.
-	  
-
-config OPROFILE
-	tristate "OProfile system profiling (EXPERIMENTAL)"
-	depends on PROFILING
-	help
-	  OProfile is a profiling system capable of profiling the
-	  whole system, include the kernel, kernel modules, libraries,
-	  and applications.
-
-	  If unsure, say N.
-
diff -puN arch/sparc64/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation arch/sparc64/Kconfig
--- a/arch/sparc64/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation
+++ a/arch/sparc64/Kconfig
@@ -460,20 +460,7 @@ source "drivers/fc4/Kconfig"
 
 source "fs/Kconfig"
 
-menu "Instrumentation Support"
-
-source "arch/sparc64/oprofile/Kconfig"
-
-config KPROBES
-	bool "Kprobes (EXPERIMENTAL)"
-	depends on KALLSYMS && EXPERIMENTAL && MODULES
-	help
-	  Kprobes allows you to trap at almost any kernel address and
-	  execute a callback function.  register_kprobe() establishes
-	  a probepoint and specifies the callback.  Kprobes is useful
-	  for kernel debugging, non-intrusive instrumentation and testing.
-	  If in doubt, say "N".
-endmenu
+source "kernel/Kconfig.instrumentation"
 
 source "arch/sparc64/Kconfig.debug"
 
diff -puN arch/sparc64/oprofile/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation /dev/null
--- a/arch/sparc64/oprofile/Kconfig
+++ /dev/null
@@ -1,17 +0,0 @@
-config PROFILING
-	bool "Profiling support (EXPERIMENTAL)"
-	help
-	  Say Y here to enable the extended profiling support mechanisms used
-	  by profilers such as OProfile.
-	  
-
-config OPROFILE
-	tristate "OProfile system profiling (EXPERIMENTAL)"
-	depends on PROFILING
-	help
-	  OProfile is a profiling system capable of profiling the
-	  whole system, include the kernel, kernel modules, libraries,
-	  and applications.
-
-	  If unsure, say N.
-
diff -puN arch/um/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation arch/um/Kconfig
--- a/arch/um/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation
+++ a/arch/um/Kconfig
@@ -289,4 +289,6 @@ config INPUT
 	bool
 	default n
 
+source "kernel/Kconfig.instrumentation"
+
 source "arch/um/Kconfig.debug"
diff -puN arch/v850/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation arch/v850/Kconfig
--- a/arch/v850/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation
+++ a/arch/v850/Kconfig
@@ -331,6 +331,8 @@ source "sound/Kconfig"
 
 source "drivers/usb/Kconfig"
 
+source "kernel/Kconfig.instrumentation"
+
 source "arch/v850/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/x86_64/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation arch/x86_64/Kconfig
--- a/arch/x86_64/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation
+++ a/arch/x86_64/Kconfig
@@ -829,20 +829,7 @@ source "drivers/firmware/Kconfig"
 
 source fs/Kconfig
 
-menu "Instrumentation Support"
-
-source "arch/x86_64/oprofile/Kconfig"
-
-config KPROBES
-	bool "Kprobes"
-	depends on KALLSYMS && MODULES
-	help
-	  Kprobes allows you to trap at almost any kernel address and
-	  execute a callback function.  register_kprobe() establishes
-	  a probepoint and specifies the callback.  Kprobes is useful
-	  for kernel debugging, non-intrusive instrumentation and testing.
-	  If in doubt, say "N".
-endmenu
+source "kernel/Kconfig.instrumentation"
 
 source "arch/x86_64/Kconfig.debug"
 
diff -puN arch/x86_64/oprofile/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation /dev/null
--- a/arch/x86_64/oprofile/Kconfig
+++ /dev/null
@@ -1,17 +0,0 @@
-config PROFILING
-	bool "Profiling support (EXPERIMENTAL)"
-	help
-	  Say Y here to enable the extended profiling support mechanisms used
-	  by profilers such as OProfile.
-	  
-
-config OPROFILE
-	tristate "OProfile system profiling (EXPERIMENTAL)"
-	depends on PROFILING
-	help
-	  OProfile is a profiling system capable of profiling the
-	  whole system, include the kernel, kernel modules, libraries,
-	  and applications.
-
-	  If unsure, say N.
-
diff -puN arch/xtensa/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation arch/xtensa/Kconfig
--- a/arch/xtensa/Kconfig~combine-instrumentation-menus-in-kernel-kconfiginstrumentation
+++ a/arch/xtensa/Kconfig
@@ -251,6 +251,8 @@ config EMBEDDED_RAMDISK_IMAGE
 	  provide one yourself.
 endmenu
 
+source "kernel/Kconfig.instrumentation"
+
 source "arch/xtensa/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN /dev/null kernel/Kconfig.instrumentation
--- /dev/null
+++ a/kernel/Kconfig.instrumentation
@@ -0,0 +1,43 @@
+menuconfig INSTRUMENTATION
+	bool "Instrumentation Support"
+	default y
+	---help---
+	  Say Y here to get to see options related to performance measurement,
+	  system-wide debugging, and testing. This option alone does not add any
+	  kernel code.
+
+	  If you say N, all options in this submenu will be skipped and
+	  disabled. If you're trying to debug the kernel itself, go see the
+	  Kernel Hacking menu.
+
+if INSTRUMENTATION
+
+config PROFILING
+	bool "Profiling support (EXPERIMENTAL)"
+	help
+	  Say Y here to enable the extended profiling support mechanisms used
+	  by profilers such as OProfile.
+
+config OPROFILE
+	tristate "OProfile system profiling (EXPERIMENTAL)"
+	depends on PROFILING
+	depends on ALPHA || ARM || BLACKFIN || X86_32 || IA64 || M32R || MIPS || PARISC || PPC || S390 || SUPERH || SPARC || X86_64
+	help
+	  OProfile is a profiling system capable of profiling the
+	  whole system, include the kernel, kernel modules, libraries,
+	  and applications.
+
+	  If unsure, say N.
+
+config KPROBES
+	bool "Kprobes"
+	depends on KALLSYMS && MODULES
+	depends on X86_32 || IA64 || PPC || S390 || SPARC64 || X86_64 || AVR32
+	help
+	  Kprobes allows you to trap at almost any kernel address and
+	  execute a callback function.  register_kprobe() establishes
+	  a probepoint and specifies the callback.  Kprobes is useful
+	  for kernel debugging, non-intrusive instrumentation and testing.
+	  If in doubt, say "N".
+
+endif # INSTRUMENTATION
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

powerpc-include-pagemaph-in-asm-powerpc-tlbh.patch
fix-f_version-type-should-be-u64-instead-of-unsigned-long.patch
local_t-documentation-update-2.patch
local_t-update-documentation.patch
combine-instrumentation-menus-in-kernel-kconfiginstrumentation.patch
linux-kernel-markers.patch
linux-kernel-markers-checkpatch-fixes.patch
add-samples-subdir.patch
linux-kernel-markers-samples.patch
linux-kernel-markers-samples-checkpatch-fixes.patch
linux-kernel-markers-documentation.patch
