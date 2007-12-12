From: akpm@linux-foundation.org
Subject: + move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig.patch added to -mm tree
Date: Tue, 11 Dec 2007 21:39:04 -0800
Message-ID: <200712120539.lBC5d4Fj027850@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46505 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753551AbXLLFmV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 00:42:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, ananth@in.ibm.com, dhowells@redhat.com, jdike@addtoit.com, sam@ravnborg.org


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
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig           |   28 ++++++++++++++++++++++++++++
 arch/alpha/Kconfig     |    2 --
 arch/arm/Kconfig       |    2 --
 arch/blackfin/Kconfig  |    2 --
 arch/cris/Kconfig      |    2 --
 arch/frv/Kconfig       |    2 --
 arch/h8300/Kconfig     |    2 --
 arch/ia64/Kconfig      |    2 --
 arch/m32r/Kconfig      |    2 --
 arch/m68k/Kconfig      |    2 --
 arch/m68knommu/Kconfig |    2 --
 arch/mips/Kconfig      |    2 --
 arch/parisc/Kconfig    |    2 --
 arch/powerpc/Kconfig   |    2 --
 arch/ppc/Kconfig       |    2 --
 arch/s390/Kconfig      |    2 --
 arch/sh/Kconfig        |    2 --
 arch/sparc/Kconfig     |    2 --
 arch/sparc64/Kconfig   |    2 --
 arch/um/Kconfig        |    2 --
 arch/v850/Kconfig      |    2 --
 arch/x86/Kconfig       |    2 --
 arch/xtensa/Kconfig    |    2 --
 init/Kconfig           |   12 ++++++++++++
 24 files changed, 40 insertions(+), 44 deletions(-)

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
+	depends on HAVE_OPROFILE
+	help
+	  OProfile is a profiling system capable of profiling the
+	  whole system, include the kernel, kernel modules, libraries,
+	  and applications.
+
+	  If unsure, say N.
+
+config HAVE_OPROFILE
+	def_bool n
+
+config KPROBES
+	bool "Kprobes"
+	depends on KALLSYMS && MODULES
+	depends on HAVE_KPROBES
+	help
+	  Kprobes allows you to trap at almost any kernel address and
+	  execute a callback function.  register_kprobe() establishes
+	  a probepoint and specifies the callback.  Kprobes is useful
+	  for kernel debugging, non-intrusive instrumentation and testing.
+	  If in doubt, say "N".
+
+config HAVE_KPROBES
+	def_bool n
diff -puN arch/alpha/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig arch/alpha/Kconfig
--- a/arch/alpha/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig
+++ a/arch/alpha/Kconfig
@@ -655,8 +655,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/alpha/Kconfig.debug"
 
 # DUMMY_CONSOLE may be defined in drivers/video/console/Kconfig
diff -puN arch/arm/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig arch/arm/Kconfig
--- a/arch/arm/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig
+++ a/arch/arm/Kconfig
@@ -1083,8 +1083,6 @@ endmenu
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/arm/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/blackfin/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig arch/blackfin/Kconfig
--- a/arch/blackfin/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig
+++ a/arch/blackfin/Kconfig
@@ -999,8 +999,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/blackfin/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/cris/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig arch/cris/Kconfig
--- a/arch/cris/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig
+++ a/arch/cris/Kconfig
@@ -214,8 +214,6 @@ source "drivers/pci/Kconfig"
 
 source "drivers/usb/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/cris/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/frv/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig arch/frv/Kconfig
--- a/arch/frv/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig
+++ a/arch/frv/Kconfig
@@ -389,8 +389,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/frv/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/h8300/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig arch/h8300/Kconfig
--- a/arch/h8300/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig
+++ a/arch/h8300/Kconfig
@@ -223,8 +223,6 @@ endmenu
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/h8300/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/ia64/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig
+++ a/arch/ia64/Kconfig
@@ -594,8 +594,6 @@ config IRQ_PER_CPU
 
 source "arch/ia64/hp/sim/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/ia64/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/m32r/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig arch/m32r/Kconfig
--- a/arch/m32r/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig
+++ a/arch/m32r/Kconfig
@@ -427,8 +427,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/m32r/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/m68k/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig arch/m68k/Kconfig
--- a/arch/m68k/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig
+++ a/arch/m68k/Kconfig
@@ -669,8 +669,6 @@ endmenu
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/m68k/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/m68knommu/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig arch/m68knommu/Kconfig
--- a/arch/m68knommu/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig
+++ a/arch/m68knommu/Kconfig
@@ -707,8 +707,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/m68knommu/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/mips/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig arch/mips/Kconfig
--- a/arch/mips/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig
+++ a/arch/mips/Kconfig
@@ -2082,8 +2082,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/mips/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/parisc/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig arch/parisc/Kconfig
--- a/arch/parisc/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig
+++ a/arch/parisc/Kconfig
@@ -268,8 +268,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/parisc/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/powerpc/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig
+++ a/arch/powerpc/Kconfig
@@ -699,8 +699,6 @@ source "arch/powerpc/sysdev/qe_lib/Kconf
 
 source "lib/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/powerpc/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/ppc/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig arch/ppc/Kconfig
--- a/arch/ppc/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig
+++ a/arch/ppc/Kconfig
@@ -1319,8 +1319,6 @@ endmenu
 
 source "lib/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/ppc/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/s390/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig arch/s390/Kconfig
--- a/arch/s390/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig
+++ a/arch/s390/Kconfig
@@ -528,8 +528,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/s390/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/sh/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig arch/sh/Kconfig
--- a/arch/sh/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig
+++ a/arch/sh/Kconfig
@@ -882,8 +882,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/sh/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/sparc/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig arch/sparc/Kconfig
--- a/arch/sparc/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig
+++ a/arch/sparc/Kconfig
@@ -321,8 +321,6 @@ endmenu
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/sparc/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/sparc64/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig arch/sparc64/Kconfig
--- a/arch/sparc64/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig
+++ a/arch/sparc64/Kconfig
@@ -464,8 +464,6 @@ source "drivers/sbus/char/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/sparc64/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/um/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig arch/um/Kconfig
--- a/arch/um/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig
+++ a/arch/um/Kconfig
@@ -260,6 +260,4 @@ config INPUT
 	bool
 	default n
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/um/Kconfig.debug"
diff -puN arch/v850/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig arch/v850/Kconfig
--- a/arch/v850/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig
+++ a/arch/v850/Kconfig
@@ -331,8 +331,6 @@ source "sound/Kconfig"
 
 source "drivers/usb/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/v850/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/x86/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig arch/x86/Kconfig
--- a/arch/x86/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig
+++ a/arch/x86/Kconfig
@@ -1604,8 +1604,6 @@ source "drivers/firmware/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/x86/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/xtensa/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig arch/xtensa/Kconfig
--- a/arch/xtensa/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig
+++ a/arch/xtensa/Kconfig
@@ -251,8 +251,6 @@ config EMBEDDED_RAMDISK_IMAGE
 	  provide one yourself.
 endmenu
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/xtensa/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN init/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig init/Kconfig
--- a/init/Kconfig~move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig
+++ a/init/Kconfig
@@ -665,6 +665,18 @@ config PROC_PAGE_MONITOR
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
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

git-x86.patch
kallsyms-should-prefer-non-weak-symbols.patch
kallsyms-should-prefer-non-weak-symbols-checkpatch-fixes.patch
create-arch-kconfig.patch
add-have_oprofile.patch
add-have_kprobes.patch
move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig.patch
add-cmpxchg_local-to-asm-generic-for-per-cpu-atomic-operations.patch
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
add-cmpxchg_local-to-sparc-move-__cmpxchg-to-systemh.patch
add-cmpxchg_local-to-sparc64.patch
add-cmpxchg_local-to-v850.patch
add-cmpxchg_local-to-xtensa.patch
modules-handle-symbols-that-have-a-zero-value.patch
linux-kernel-markers-support-multiple-probes.patch
linux-kernel-markers-support-multiple-probes-update.patch
linux-kernel-markers-create-modpost-file.patch
