From: akpm@linux-foundation.org
Subject: + add-arch_supports_oprofile.patch added to -mm tree
Date: Fri, 16 Nov 2007 15:03:46 -0800
Message-ID: <200711162303.lAGN3kws008015@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41888 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758422AbXKPXF0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Nov 2007 18:05:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, ananth@in.ibm.com, linux-arch@vger.kernel.org, sam@ravnborg.org, torvalds@linux-foundation.org


The patch titled
     Add ARCH_SUPPORTS_OPROFILE
has been added to the -mm tree.  Its filename is
     add-arch_supports_oprofile.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

- Use ARCH_HAS_* instead of ARCH_SUPPORTS).
- Use a select ARCH_HAS_*

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/Kconfig             |    1 +
 arch/arm/Kconfig               |    1 +
 arch/blackfin/Kconfig          |    1 +
 arch/ia64/Kconfig              |    1 +
 arch/m32r/Kconfig              |    1 +
 arch/mips/Kconfig              |    1 +
 arch/parisc/Kconfig            |    1 +
 arch/powerpc/Kconfig           |    1 +
 arch/ppc/Kconfig               |    1 +
 arch/s390/Kconfig              |    1 +
 arch/sh/Kconfig                |    1 +
 arch/sh64/Kconfig              |    1 +
 arch/sparc/Kconfig             |    1 +
 arch/sparc64/Kconfig           |    1 +
 arch/x86/Kconfig               |    1 +
 kernel/Kconfig.instrumentation |    5 ++++-
 16 files changed, 19 insertions(+), 1 deletion(-)

diff -puN arch/alpha/Kconfig~add-arch_supports_oprofile arch/alpha/Kconfig
--- a/arch/alpha/Kconfig~add-arch_supports_oprofile
+++ a/arch/alpha/Kconfig
@@ -5,6 +5,7 @@
 config ALPHA
 	bool
 	default y
+	select ARCH_HAS_OPROFILE
 	help
 	  The Alpha is a 64-bit general-purpose processor designed and
 	  marketed by the Digital Equipment Corporation of blessed memory,
diff -puN arch/arm/Kconfig~add-arch_supports_oprofile arch/arm/Kconfig
--- a/arch/arm/Kconfig~add-arch_supports_oprofile
+++ a/arch/arm/Kconfig
@@ -10,6 +10,7 @@ config ARM
 	default y
 	select RTC_LIB
 	select SYS_SUPPORTS_APM_EMULATION
+	select ARCH_HAS_OPROFILE
 	help
 	  The ARM series is a line of low-power-consumption RISC chip designs
 	  licensed by ARM Ltd and targeted at embedded applications and
diff -puN arch/blackfin/Kconfig~add-arch_supports_oprofile arch/blackfin/Kconfig
--- a/arch/blackfin/Kconfig~add-arch_supports_oprofile
+++ a/arch/blackfin/Kconfig
@@ -24,6 +24,7 @@ config RWSEM_XCHGADD_ALGORITHM
 config BLACKFIN
 	bool
 	default y
+	select ARCH_HAS_OPROFILE
 
 config ZONE_DMA
 	bool
diff -puN arch/ia64/Kconfig~add-arch_supports_oprofile arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~add-arch_supports_oprofile
+++ a/arch/ia64/Kconfig
@@ -15,6 +15,7 @@ config IA64
 	select ACPI if (!IA64_HP_SIM)
 	select PM if (!IA64_HP_SIM)
 	select ARCH_SUPPORTS_MSI
+	select ARCH_HAS_OPROFILE
 	default y
 	help
 	  The Itanium Processor Family is Intel's 64-bit successor to
diff -puN arch/m32r/Kconfig~add-arch_supports_oprofile arch/m32r/Kconfig
--- a/arch/m32r/Kconfig~add-arch_supports_oprofile
+++ a/arch/m32r/Kconfig
@@ -8,6 +8,7 @@ mainmenu "Linux/M32R Kernel Configuratio
 config M32R
 	bool
 	default y
+	select ARCH_HAS_OPROFILE
 
 config SBUS
 	bool
diff -puN arch/mips/Kconfig~add-arch_supports_oprofile arch/mips/Kconfig
--- a/arch/mips/Kconfig~add-arch_supports_oprofile
+++ a/arch/mips/Kconfig
@@ -1,6 +1,7 @@
 config MIPS
 	bool
 	default y
+	select ARCH_HAS_OPROFILE
 	# Horrible source of confusion.  Die, die, die ...
 	select EMBEDDED
 	select RTC_LIB
diff -puN arch/parisc/Kconfig~add-arch_supports_oprofile arch/parisc/Kconfig
--- a/arch/parisc/Kconfig~add-arch_supports_oprofile
+++ a/arch/parisc/Kconfig
@@ -7,6 +7,7 @@ mainmenu "Linux/PA-RISC Kernel Configura
 
 config PARISC
 	def_bool y
+	select ARCH_HAS_OPROFILE
 	help
 	  The PA-RISC microprocessor is designed by Hewlett-Packard and used
 	  in many of their workstations & servers (HP9000 700 and 800 series,
diff -puN arch/powerpc/Kconfig~add-arch_supports_oprofile arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~add-arch_supports_oprofile
+++ a/arch/powerpc/Kconfig
@@ -79,6 +79,7 @@ config ARCH_NO_VIRT_TO_BUS
 config PPC
 	bool
 	default y
+	select ARCH_HAS_OPROFILE
 
 config EARLY_PRINTK
 	bool
diff -puN arch/ppc/Kconfig~add-arch_supports_oprofile arch/ppc/Kconfig
--- a/arch/ppc/Kconfig~add-arch_supports_oprofile
+++ a/arch/ppc/Kconfig
@@ -45,6 +45,7 @@ config ARCH_SUPPORTS_AOUT
 config PPC
 	bool
 	default y
+	select ARCH_HAS_OPROFILE
 
 config PPC32
 	bool
diff -puN arch/s390/Kconfig~add-arch_supports_oprofile arch/s390/Kconfig
--- a/arch/s390/Kconfig~add-arch_supports_oprofile
+++ a/arch/s390/Kconfig
@@ -54,6 +54,7 @@ mainmenu "Linux Kernel Configuration"
 
 config S390
 	def_bool y
+	select ARCH_HAS_OPROFILE
 
 source "init/Kconfig"
 
diff -puN arch/sh/Kconfig~add-arch_supports_oprofile arch/sh/Kconfig
--- a/arch/sh/Kconfig~add-arch_supports_oprofile
+++ a/arch/sh/Kconfig
@@ -9,6 +9,7 @@ config SUPERH
 	bool
 	default y
 	select EMBEDDED
+	select ARCH_HAS_OPROFILE
 	help
 	  The SuperH is a RISC processor targeted for use in embedded systems
 	  and consumer electronics; it was also used in the Sega Dreamcast
diff -puN arch/sh64/Kconfig~add-arch_supports_oprofile arch/sh64/Kconfig
--- a/arch/sh64/Kconfig~add-arch_supports_oprofile
+++ a/arch/sh64/Kconfig
@@ -8,6 +8,7 @@ mainmenu "Linux/SH64 Kernel Configuratio
 config SUPERH
 	bool
 	default y
+	select ARCH_HAS_OPROFILE
 
 config SUPERH64
 	bool
diff -puN arch/sparc/Kconfig~add-arch_supports_oprofile arch/sparc/Kconfig
--- a/arch/sparc/Kconfig~add-arch_supports_oprofile
+++ a/arch/sparc/Kconfig
@@ -66,6 +66,7 @@ config NR_CPUS
 config SPARC
 	bool
 	default y
+	select ARCH_HAS_OPROFILE
 
 # Identify this as a Sparc32 build
 config SPARC32
diff -puN arch/sparc64/Kconfig~add-arch_supports_oprofile arch/sparc64/Kconfig
--- a/arch/sparc64/Kconfig~add-arch_supports_oprofile
+++ a/arch/sparc64/Kconfig
@@ -8,6 +8,7 @@ mainmenu "Linux/UltraSPARC Kernel Config
 config SPARC
 	bool
 	default y
+	select ARCH_HAS_OPROFILE
 
 config SPARC64
 	bool
diff -puN arch/x86/Kconfig~add-arch_supports_oprofile arch/x86/Kconfig
--- a/arch/x86/Kconfig~add-arch_supports_oprofile
+++ a/arch/x86/Kconfig
@@ -19,6 +19,7 @@ config X86_64
 config X86
 	bool
 	default y
+	select ARCH_HAS_OPROFILE
 
 config GENERIC_TIME
 	bool
diff -puN kernel/Kconfig.instrumentation~add-arch_supports_oprofile kernel/Kconfig.instrumentation
--- a/kernel/Kconfig.instrumentation~add-arch_supports_oprofile
+++ a/kernel/Kconfig.instrumentation
@@ -21,7 +21,7 @@ config PROFILING
 config OPROFILE
 	tristate "OProfile system profiling (EXPERIMENTAL)"
 	depends on PROFILING
-	depends on ALPHA || ARM || BLACKFIN || X86_32 || IA64 || M32R || MIPS || PARISC || PPC || S390 || SUPERH || SPARC || X86_64
+	depends on ARCH_HAS_OPROFILE
 	help
 	  OProfile is a profiling system capable of profiling the
 	  whole system, include the kernel, kernel modules, libraries,
@@ -29,6 +29,9 @@ config OPROFILE
 
 	  If unsure, say N.
 
+config ARCH_HAS_OPROFILE
+	def_bool n
+
 config KPROBES
 	bool "Kprobes"
 	depends on KALLSYMS && MODULES
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
