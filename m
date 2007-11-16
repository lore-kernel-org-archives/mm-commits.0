From: akpm@linux-foundation.org
Subject: - add-arch_supports_oprofile.patch removed from -mm tree
Date: Thu, 15 Nov 2007 18:08:58 -0800
Message-ID: <200711160208.lAG28wsb027181@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37690 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932766AbXKPCJD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 21:09:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, linux-arch@vger.kernel.org, sam@ravnborg.org, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Add ARCH_SUPPORTS_OPROFILE
has been removed from the -mm tree.  Its filename was
     add-arch_supports_oprofile.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Add ARCH_SUPPORTS_OPROFILE
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Linus:
On the per-architecture side, I do think it would be better to *not* have
internal architecture knowledge in a generic file, and as such a line like

        depends on X86_32 || IA64 || PPC || S390 || SPARC64 || X86_64 || AVR32

really shouldn't exist in a file like kernel/Kconfig.instrumentation.

It would be much better to do

        depends on ARCH_SUPPORTS_KPROBES

in that generic file, and then architectures that do support it would just
have a

        bool ARCH_SUPPORTS_KPROBES
                default y

in *their* architecture files. That would seem to be much more logical,
and is readable both for arch maintainers *and* for people who have no
clue - and don't care - about which architecture is supposed to support
which interface...

Changelog:

Actually, I know I gave this as the magic incantation, but now that I see
it, I realize that I should have told you to just use

        config ARCH_SUPPORTS_KPROBES
                def_bool y

instead, which is a bit denser.

We seem to use both kinds of syntax for these things, but this is really
what "def_bool" is there for...

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/Kconfig             |    3 +++
 arch/arm/Kconfig               |    3 +++
 arch/blackfin/Kconfig          |    3 +++
 arch/ia64/Kconfig              |    3 +++
 arch/m32r/Kconfig              |    3 +++
 arch/mips/Kconfig              |    3 +++
 arch/parisc/Kconfig            |    3 +++
 arch/powerpc/Kconfig           |    3 +++
 arch/ppc/Kconfig               |    3 +++
 arch/s390/Kconfig              |    3 +++
 arch/sh/Kconfig                |    3 +++
 arch/sh64/Kconfig              |    3 +++
 arch/sparc/Kconfig             |    3 +++
 arch/sparc64/Kconfig           |    3 +++
 arch/x86/Kconfig               |    4 ++++
 kernel/Kconfig.instrumentation |    2 +-
 16 files changed, 47 insertions(+), 1 deletion(-)

diff -puN arch/alpha/Kconfig~add-arch_supports_oprofile arch/alpha/Kconfig
--- a/arch/alpha/Kconfig~add-arch_supports_oprofile
+++ a/arch/alpha/Kconfig
@@ -69,6 +69,9 @@ config AUTO_IRQ_AFFINITY
 config ARCH_SUPPORTS_AOUT
 	def_bool y
 
+config ARCH_SUPPORTS_OPROFILE
+	def_bool y
+
 source "init/Kconfig"
 
 
diff -puN arch/arm/Kconfig~add-arch_supports_oprofile arch/arm/Kconfig
--- a/arch/arm/Kconfig~add-arch_supports_oprofile
+++ a/arch/arm/Kconfig
@@ -117,6 +117,9 @@ config GENERIC_CALIBRATE_DELAY
 config ARCH_SUPPORTS_AOUT
 	def_bool y
 
+config ARCH_SUPPORTS_OPROFILE
+	def_bool y
+
 config ARCH_MAY_HAVE_PC_FDC
 	bool
 
diff -puN arch/blackfin/Kconfig~add-arch_supports_oprofile arch/blackfin/Kconfig
--- a/arch/blackfin/Kconfig~add-arch_supports_oprofile
+++ a/arch/blackfin/Kconfig
@@ -72,6 +72,9 @@ config GENERIC_CALIBRATE_DELAY
 config ARCH_SUPPORTS_AOUT
 	def_bool n
 
+config ARCH_SUPPORTS_OPROFILE
+	def_bool y
+
 config IRQCHIP_DEMUX_GPIO
 	bool
 	depends on (BF52x || BF53x || BF561 || BF54x)
diff -puN arch/ia64/Kconfig~add-arch_supports_oprofile arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~add-arch_supports_oprofile
+++ a/arch/ia64/Kconfig
@@ -102,6 +102,9 @@ config AUDIT_ARCH
 config ARCH_SUPPORTS_AOUT
 	def_bool n
 
+config ARCH_SUPPORTS_OPROFILE
+	def_bool y
+
 choice
 	prompt "System type"
 	default IA64_GENERIC
diff -puN arch/m32r/Kconfig~add-arch_supports_oprofile arch/m32r/Kconfig
--- a/arch/m32r/Kconfig~add-arch_supports_oprofile
+++ a/arch/m32r/Kconfig
@@ -37,6 +37,9 @@ config NO_DMA
 config ARCH_SUPPORTS_AOUT
 	def_bool y
 
+config ARCH_SUPPORTS_OPROFILE
+	def_bool y
+
 source "init/Kconfig"
 
 
diff -puN arch/mips/Kconfig~add-arch_supports_oprofile arch/mips/Kconfig
--- a/arch/mips/Kconfig~add-arch_supports_oprofile
+++ a/arch/mips/Kconfig
@@ -725,6 +725,9 @@ config GENERIC_HARDIRQS_NO__DO_IRQ
 config ARCH_SUPPORTS_AOUT
 	def_bool y
 
+config ARCH_SUPPORTS_OPROFILE
+	def_bool y
+
 #
 # Select some configuration options automatically based on user selections.
 #
diff -puN arch/parisc/Kconfig~add-arch_supports_oprofile arch/parisc/Kconfig
--- a/arch/parisc/Kconfig~add-arch_supports_oprofile
+++ a/arch/parisc/Kconfig
@@ -72,6 +72,9 @@ config IRQ_PER_CPU
 config ARCH_SUPPORTS_AOUT
 	def_bool y
 
+config ARCH_SUPPORTS_OPROFILE
+	def_bool y
+
 # unless you want to implement ACPI on PA-RISC ... ;-)
 config PM
 	bool
diff -puN arch/powerpc/Kconfig~add-arch_supports_oprofile arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~add-arch_supports_oprofile
+++ a/arch/powerpc/Kconfig
@@ -166,6 +166,9 @@ config PPC_OF_PLATFORM_PCI
 	depends on PPC64 # not supported on 32 bits yet
 	default n
 
+config ARCH_SUPPORTS_OPROFILE
+	def_bool y
+
 source "init/Kconfig"
 
 source "arch/powerpc/platforms/Kconfig"
diff -puN arch/ppc/Kconfig~add-arch_supports_oprofile arch/ppc/Kconfig
--- a/arch/ppc/Kconfig~add-arch_supports_oprofile
+++ a/arch/ppc/Kconfig
@@ -72,6 +72,9 @@ config GENERIC_BUG
 	default y
 	depends on BUG
 
+config ARCH_SUPPORTS_OPROFILE
+	def_bool y
+
 source "init/Kconfig"
 
 menu "Processor"
diff -puN arch/s390/Kconfig~add-arch_supports_oprofile arch/s390/Kconfig
--- a/arch/s390/Kconfig~add-arch_supports_oprofile
+++ a/arch/s390/Kconfig
@@ -55,6 +55,9 @@ mainmenu "Linux Kernel Configuration"
 config S390
 	def_bool y
 
+config ARCH_SUPPORTS_OPROFILE
+	def_bool y
+
 source "init/Kconfig"
 
 menu "Base setup"
diff -puN arch/sh/Kconfig~add-arch_supports_oprofile arch/sh/Kconfig
--- a/arch/sh/Kconfig~add-arch_supports_oprofile
+++ a/arch/sh/Kconfig
@@ -96,6 +96,9 @@ config ARCH_NO_VIRT_TO_BUS
 config ARCH_SUPPORTS_AOUT
 	def_bool y
 
+config ARCH_SUPPORTS_OPROFILE
+	def_bool y
+
 source "init/Kconfig"
 
 menu "System type"
diff -puN arch/sh64/Kconfig~add-arch_supports_oprofile arch/sh64/Kconfig
--- a/arch/sh64/Kconfig~add-arch_supports_oprofile
+++ a/arch/sh64/Kconfig
@@ -61,6 +61,9 @@ config ARCH_NO_VIRT_TO_BUS
 config ARCH_SUPPORTS_AOUT
 	def_bool y
 
+config ARCH_SUPPORTS_OPROFILE
+	def_bool y
+
 source init/Kconfig
 
 menu "System type"
diff -puN arch/sparc/Kconfig~add-arch_supports_oprofile arch/sparc/Kconfig
--- a/arch/sparc/Kconfig~add-arch_supports_oprofile
+++ a/arch/sparc/Kconfig
@@ -30,6 +30,9 @@ config OF
 config ARCH_SUPPORTS_AOUT
 	def_bool y
 
+config ARCH_SUPPORTS_OPROFILE
+	def_bool y
+
 source "init/Kconfig"
 
 menu "General machine setup"
diff -puN arch/sparc64/Kconfig~add-arch_supports_oprofile arch/sparc64/Kconfig
--- a/arch/sparc64/Kconfig~add-arch_supports_oprofile
+++ a/arch/sparc64/Kconfig
@@ -79,6 +79,9 @@ config GENERIC_HARDIRQS_NO__DO_IRQ
 config ARCH_SUPPORTS_AOUT
 	def_bool y
 
+config ARCH_SUPPORTS_OPROFILE
+	def_bool y
+
 choice
 	prompt "Kernel page size"
 	default SPARC64_PAGE_SIZE_8KB
diff -puN arch/x86/Kconfig~add-arch_supports_oprofile arch/x86/Kconfig
--- a/arch/x86/Kconfig~add-arch_supports_oprofile
+++ a/arch/x86/Kconfig
@@ -171,6 +171,10 @@ config X86_TRAMPOLINE
 
 config KTIME_SCALAR
 	def_bool X86_32
+
+config ARCH_SUPPORTS_OPROFILE
+	def_bool y
+
 source "init/Kconfig"
 
 menu "Processor type and features"
diff -puN kernel/Kconfig.instrumentation~add-arch_supports_oprofile kernel/Kconfig.instrumentation
--- a/kernel/Kconfig.instrumentation~add-arch_supports_oprofile
+++ a/kernel/Kconfig.instrumentation
@@ -21,7 +21,7 @@ config PROFILING
 config OPROFILE
 	tristate "OProfile system profiling (EXPERIMENTAL)"
 	depends on PROFILING
-	depends on ALPHA || ARM || BLACKFIN || X86_32 || IA64 || M32R || MIPS || PARISC || PPC || S390 || SUPERH || SPARC || X86_64
+	depends on ARCH_SUPPORTS_OPROFILE
 	help
 	  OProfile is a profiling system capable of profiling the
 	  whole system, include the kernel, kernel modules, libraries,
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
add-arch_supports_oprofile.patch
add-arch_supports_kprobes.patch
move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig.patch
