From: akpm@linux-foundation.org
Subject: + move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig.patch added to -mm tree
Date: Fri, 16 Nov 2007 15:03:49 -0800
Message-ID: <200711162303.lAGN3nwe008021@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33158 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760574AbXKPXFa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Nov 2007 18:05:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, ananth@in.ibm.com, linux-arch@vger.kernel.org, sam@ravnborg.org, torvalds@linux-foundation.org


The patch titled
     Move Kconfig.instrumentation to arch/Kconfig and init/Kconfig
has been added to the -mm tree.  Its filename is
     move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Move Kconfig.instrumentation to arch/Kconfig and init/Kconfig
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Move the instrumentation Kconfig to

arch/Kconfig for architecture dependent options
  - oprofile
  - kprobes

and

init/Kconfig for architecture independent options
  - profiling
  - markers

Remove the "Instrumentation Support" menu. Everything moves to "General setup".
Delete the kernel/Kconfig.instrumentation file.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig                   |   28 +++++++++++++++
 arch/alpha/Kconfig             |    2 -
 arch/arm/Kconfig               |    2 -
 arch/blackfin/Kconfig          |    2 -
 arch/cris/Kconfig              |    2 -
 arch/frv/Kconfig               |    2 -
 arch/h8300/Kconfig             |    2 -
 arch/ia64/Kconfig              |    2 -
 arch/m32r/Kconfig              |    2 -
 arch/m68k/Kconfig              |    2 -
 arch/m68knommu/Kconfig         |    2 -
 arch/mips/Kconfig              |    2 -
 arch/parisc/Kconfig            |    2 -
 arch/powerpc/Kconfig           |    2 -
 arch/ppc/Kconfig               |    2 -
 arch/s390/Kconfig              |    2 -
 arch/sh/Kconfig                |    2 -
 arch/sh64/Kconfig              |    2 -
 arch/sparc/Kconfig             |    2 -
 arch/sparc64/Kconfig           |    2 -
 arch/um/Kconfig                |    2 -
 arch/v850/Kconfig              |    2 -
 arch/x86/Kconfig               |    2 -
 arch/xtensa/Kconfig            |    2 -
 init/Kconfig                   |   12 ++++++
 kernel/Kconfig.instrumentation |   55 -------------------------------
 26 files changed, 40 insertions(+), 101 deletions(-)

diff -puN arch/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig arch/Kconfig
--- a/arch/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig
+++ a/arch/Kconfig
@@ -1,3 +1,31 @@
 #
 # General architecture dependent options
 #
+
+config OPROFILE
+	tristate "OProfile system profiling (EXPERIMENTAL)"
+	depends on PROFILING
+	depends on ARCH_HAS_OPROFILE
+	help
+	  OProfile is a profiling system capable of profiling the
+	  whole system, include the kernel, kernel modules, libraries,
+	  and applications.
+
+	  If unsure, say N.
+
+config ARCH_HAS_OPROFILE
+	def_bool n
+
+config KPROBES
+	bool "Kprobes"
+	depends on KALLSYMS && MODULES
+	depends on ARCH_HAS_KPROBES
+	help
+	  Kprobes allows you to trap at almost any kernel address and
+	  execute a callback function.  register_kprobe() establishes
+	  a probepoint and specifies the callback.  Kprobes is useful
+	  for kernel debugging, non-intrusive instrumentation and testing.
+	  If in doubt, say "N".
+
+config ARCH_HAS_KPROBES
+	def_bool n
diff -puN arch/alpha/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig arch/alpha/Kconfig
--- a/arch/alpha/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig
+++ a/arch/alpha/Kconfig
@@ -658,8 +658,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/alpha/Kconfig.debug"
 
 # DUMMY_CONSOLE may be defined in drivers/video/console/Kconfig
diff -puN arch/arm/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig arch/arm/Kconfig
--- a/arch/arm/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig
+++ a/arch/arm/Kconfig
@@ -1076,8 +1076,6 @@ endmenu
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/arm/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/blackfin/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig arch/blackfin/Kconfig
--- a/arch/blackfin/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig
+++ a/arch/blackfin/Kconfig
@@ -1077,8 +1077,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 menu "Kernel hacking"
 
 source "lib/Kconfig.debug"
diff -puN arch/cris/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig arch/cris/Kconfig
--- a/arch/cris/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig
+++ a/arch/cris/Kconfig
@@ -216,8 +216,6 @@ source "drivers/pci/Kconfig"
 
 source "drivers/usb/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/cris/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/frv/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig arch/frv/Kconfig
--- a/arch/frv/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig
+++ a/arch/frv/Kconfig
@@ -387,8 +387,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/frv/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/h8300/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig arch/h8300/Kconfig
--- a/arch/h8300/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig
+++ a/arch/h8300/Kconfig
@@ -226,8 +226,6 @@ endmenu
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/h8300/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/ia64/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig
+++ a/arch/ia64/Kconfig
@@ -597,8 +597,6 @@ config IRQ_PER_CPU
 
 source "arch/ia64/hp/sim/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/ia64/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/m32r/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig arch/m32r/Kconfig
--- a/arch/m32r/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig
+++ a/arch/m32r/Kconfig
@@ -430,8 +430,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/m32r/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/m68k/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig arch/m68k/Kconfig
--- a/arch/m68k/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig
+++ a/arch/m68k/Kconfig
@@ -686,8 +686,6 @@ endmenu
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/m68k/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/m68knommu/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig arch/m68knommu/Kconfig
--- a/arch/m68knommu/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig
+++ a/arch/m68knommu/Kconfig
@@ -710,8 +710,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/m68knommu/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/mips/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig arch/mips/Kconfig
--- a/arch/mips/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig
+++ a/arch/mips/Kconfig
@@ -2043,8 +2043,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/mips/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/parisc/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig arch/parisc/Kconfig
--- a/arch/parisc/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig
+++ a/arch/parisc/Kconfig
@@ -271,8 +271,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/parisc/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/powerpc/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig
+++ a/arch/powerpc/Kconfig
@@ -682,8 +682,6 @@ source "arch/powerpc/sysdev/qe_lib/Kconf
 
 source "lib/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/powerpc/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/ppc/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig arch/ppc/Kconfig
--- a/arch/ppc/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig
+++ a/arch/ppc/Kconfig
@@ -1322,8 +1322,6 @@ endmenu
 
 source "lib/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/ppc/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/s390/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig arch/s390/Kconfig
--- a/arch/s390/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig
+++ a/arch/s390/Kconfig
@@ -534,8 +534,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/s390/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/sh/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig arch/sh/Kconfig
--- a/arch/sh/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig
+++ a/arch/sh/Kconfig
@@ -760,8 +760,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/sh/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/sh64/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig arch/sh64/Kconfig
--- a/arch/sh64/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig
+++ a/arch/sh64/Kconfig
@@ -288,8 +288,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/sh64/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/sparc/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig arch/sparc/Kconfig
--- a/arch/sparc/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig
+++ a/arch/sparc/Kconfig
@@ -324,8 +324,6 @@ endmenu
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/sparc/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/sparc64/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig arch/sparc64/Kconfig
--- a/arch/sparc64/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig
+++ a/arch/sparc64/Kconfig
@@ -467,8 +467,6 @@ source "drivers/sbus/char/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/sparc64/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/um/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig arch/um/Kconfig
--- a/arch/um/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig
+++ a/arch/um/Kconfig
@@ -288,6 +288,4 @@ config INPUT
 	bool
 	default n
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/um/Kconfig.debug"
diff -puN arch/v850/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig arch/v850/Kconfig
--- a/arch/v850/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig
+++ a/arch/v850/Kconfig
@@ -334,8 +334,6 @@ source "sound/Kconfig"
 
 source "drivers/usb/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/v850/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/x86/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig arch/x86/Kconfig
--- a/arch/x86/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig
+++ a/arch/x86/Kconfig
@@ -1636,8 +1636,6 @@ source "drivers/firmware/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/x86/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/xtensa/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig arch/xtensa/Kconfig
--- a/arch/xtensa/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig
+++ a/arch/xtensa/Kconfig
@@ -254,8 +254,6 @@ config EMBEDDED_RAMDISK_IMAGE
 	  provide one yourself.
 endmenu
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/xtensa/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN init/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig init/Kconfig
--- a/init/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig
+++ a/init/Kconfig
@@ -695,6 +695,18 @@ config PROC_PAGE_MONITOR
 	  /proc/kpagecount, and /proc/kpageflags. Disabling these
           interfaces will reduce the size of the kernel by approximately 4kb.
 
+config PROFILING
+	bool "Profiling support (EXPERIMENTAL)"
+	help
+	  Say Y here to enable the extended profiling support mechanisms used
+	  by profilers such as OProfile.
+
+config MARKERS
+	bool "Activate markers"
+	help
+	  Place an empty function call at each marker site. Can be
+	  dynamically changed for a probe function.
+
 source "arch/Kconfig"
 
 endmenu		# General setup
diff -puN kernel/Kconfig.instrumentation~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig /dev/null
--- a/kernel/Kconfig.instrumentation
+++ /dev/null
@@ -1,55 +0,0 @@
-menuconfig INSTRUMENTATION
-	bool "Instrumentation Support"
-	default y
-	---help---
-	  Say Y here to get to see options related to performance measurement,
-	  system-wide debugging, and testing. This option alone does not add any
-	  kernel code.
-
-	  If you say N, all options in this submenu will be skipped and
-	  disabled. If you're trying to debug the kernel itself, go see the
-	  Kernel Hacking menu.
-
-if INSTRUMENTATION
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
-	depends on ARCH_HAS_OPROFILE
-	help
-	  OProfile is a profiling system capable of profiling the
-	  whole system, include the kernel, kernel modules, libraries,
-	  and applications.
-
-	  If unsure, say N.
-
-config ARCH_HAS_OPROFILE
-	def_bool n
-
-config KPROBES
-	bool "Kprobes"
-	depends on KALLSYMS && MODULES
-	depends on ARCH_HAS_KPROBES
-	help
-	  Kprobes allows you to trap at almost any kernel address and
-	  execute a callback function.  register_kprobe() establishes
-	  a probepoint and specifies the callback.  Kprobes is useful
-	  for kernel debugging, non-intrusive instrumentation and testing.
-	  If in doubt, say "N".
-
-config ARCH_HAS_KPROBES
-	def_bool n
-
-config MARKERS
-	bool "Activate markers"
-	help
-	  Place an empty function call at each marker site. Can be
-	  dynamically changed for a probe function.
-
-endif # INSTRUMENTATION
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
add-cmpxchg_local-to-asm-generic-for-per-cpu-atomic-operations.patch
fall-back-on-interrupt-disable-in-cmpxchg8b-on-80386-and-80486.patch
add-cmpxchg64-and-cmpxchg64_local-to-alpha.patch
add-cmpxchg64-and-cmpxchg64_local-to-mips.patch
add-cmpxchg64-and-cmpxchg64_local-to-powerpc.patch
add-cmpxchg64-and-cmpxchg64_local-to-x86_64.patch
add-cmpxchg_local-to-arm.patch
add-cmpxchg_local-to-avr32.patch
add-cmpxchg_local-to-blackfin-replace-__cmpxchg-by-generic-cmpxchg.patch
add-cmpxchg_local-to-cris.patch
add-cmpxchg_local-to-frv.patch
add-cmpxchg_local-to-h8300.patch
add-cmpxchg_local-cmpxchg64-and-cmpxchg64_local-to-ia64.patch
new-cmpxchg_local-optimized-for-up-case-for-m32r.patch
fix-m32r-__xchg.patch
m32r-build-fix-of-arch-m32r-kernel-smpbootc.patch
local_t-m32r-use-architecture-specific-cmpxchg_local.patch
add-cmpxchg_local-to-m86k.patch
add-cmpxchg_local-to-m68knommu.patch
add-cmpxchg_local-to-parisc.patch
add-cmpxchg_local-to-ppc.patch
add-cmpxchg_local-to-s390.patch
add-cmpxchg_local-to-sh-use-generic-cmpxchg-instead-of-cmpxchg_u32.patch
add-cmpxchg_local-to-sh64.patch
add-cmpxchg_local-to-sparc-move-__cmpxchg-to-systemh.patch
add-cmpxchg_local-to-sparc64.patch
add-cmpxchg_local-to-v850.patch
add-cmpxchg_local-to-xtensa.patch
create-arch-kconfig.patch
add-arch_supports_oprofile.patch
add-arch_supports_kprobes.patch
move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig.patch
