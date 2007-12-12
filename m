From: akpm@linux-foundation.org
Subject: + add-have_oprofile.patch added to -mm tree
Date: Tue, 11 Dec 2007 21:39:00 -0800
Message-ID: <200712120539.lBC5d09a027834@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40509 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753457AbXLLFlb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 00:41:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, akpm@linux-foundation.org, ananth@in.ibm.com, dhowells@redhat.com, hskinnemoen@atmel.com, jdike@addtoit.com, sam@ravnborg.org


The patch titled
     Add HAVE_OPROFILE
has been added to the -mm tree.  Its filename is
     add-have_oprofile.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add HAVE_OPROFILE
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

Changelog :

- Moving to HAVE_*.
- Add AVR32 oprofile.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/Kconfig             |    1 +
 arch/arm/Kconfig               |    1 +
 arch/avr32/Kconfig             |    1 +
 arch/blackfin/Kconfig          |    1 +
 arch/ia64/Kconfig              |    1 +
 arch/m32r/Kconfig              |    1 +
 arch/mips/Kconfig              |    1 +
 arch/parisc/Kconfig            |    1 +
 arch/powerpc/Kconfig           |    1 +
 arch/ppc/Kconfig               |    1 +
 arch/s390/Kconfig              |    1 +
 arch/sh/Kconfig                |    1 +
 arch/sparc/Kconfig             |    1 +
 arch/sparc64/Kconfig           |    1 +
 arch/x86/Kconfig               |    1 +
 kernel/Kconfig.instrumentation |    7 +++++--
 16 files changed, 20 insertions(+), 2 deletions(-)

diff -puN arch/alpha/Kconfig~add-have_oprofile arch/alpha/Kconfig
--- a/arch/alpha/Kconfig~add-have_oprofile
+++ a/arch/alpha/Kconfig
@@ -5,6 +5,7 @@
 config ALPHA
 	bool
 	default y
+	select HAVE_OPROFILE
 	help
 	  The Alpha is a 64-bit general-purpose processor designed and
 	  marketed by the Digital Equipment Corporation of blessed memory,
diff -puN arch/arm/Kconfig~add-have_oprofile arch/arm/Kconfig
--- a/arch/arm/Kconfig~add-have_oprofile
+++ a/arch/arm/Kconfig
@@ -10,6 +10,7 @@ config ARM
 	default y
 	select RTC_LIB
 	select SYS_SUPPORTS_APM_EMULATION
+	select HAVE_OPROFILE
 	help
 	  The ARM series is a line of low-power-consumption RISC chip designs
 	  licensed by ARM Ltd and targeted at embedded applications and
diff -puN arch/avr32/Kconfig~add-have_oprofile arch/avr32/Kconfig
--- a/arch/avr32/Kconfig~add-have_oprofile
+++ a/arch/avr32/Kconfig
@@ -10,6 +10,7 @@ config AVR32
 	# With EMBEDDED=n, we get lots of stuff automatically selected
 	# that we usually don't need on AVR32.
 	select EMBEDDED
+	select HAVE_OPROFILE
 	help
 	  AVR32 is a high-performance 32-bit RISC microprocessor core,
 	  designed for cost-sensitive embedded applications, with particular
diff -puN arch/blackfin/Kconfig~add-have_oprofile arch/blackfin/Kconfig
--- a/arch/blackfin/Kconfig~add-have_oprofile
+++ a/arch/blackfin/Kconfig
@@ -24,6 +24,7 @@ config RWSEM_XCHGADD_ALGORITHM
 config BLACKFIN
 	bool
 	default y
+	select HAVE_OPROFILE
 
 config ZONE_DMA
 	bool
diff -puN arch/ia64/Kconfig~add-have_oprofile arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~add-have_oprofile
+++ a/arch/ia64/Kconfig
@@ -15,6 +15,7 @@ config IA64
 	select ACPI if (!IA64_HP_SIM)
 	select PM if (!IA64_HP_SIM)
 	select ARCH_SUPPORTS_MSI
+	select HAVE_OPROFILE
 	default y
 	help
 	  The Itanium Processor Family is Intel's 64-bit successor to
diff -puN arch/m32r/Kconfig~add-have_oprofile arch/m32r/Kconfig
--- a/arch/m32r/Kconfig~add-have_oprofile
+++ a/arch/m32r/Kconfig
@@ -8,6 +8,7 @@ mainmenu "Linux/M32R Kernel Configuratio
 config M32R
 	bool
 	default y
+	select HAVE_OPROFILE
 
 config SBUS
 	bool
diff -puN arch/mips/Kconfig~add-have_oprofile arch/mips/Kconfig
--- a/arch/mips/Kconfig~add-have_oprofile
+++ a/arch/mips/Kconfig
@@ -1,6 +1,7 @@
 config MIPS
 	bool
 	default y
+	select HAVE_OPROFILE if !MIPS_MT_SMTC
 	# Horrible source of confusion.  Die, die, die ...
 	select EMBEDDED
 	select RTC_LIB
diff -puN arch/parisc/Kconfig~add-have_oprofile arch/parisc/Kconfig
--- a/arch/parisc/Kconfig~add-have_oprofile
+++ a/arch/parisc/Kconfig
@@ -7,6 +7,7 @@ mainmenu "Linux/PA-RISC Kernel Configura
 
 config PARISC
 	def_bool y
+	select HAVE_OPROFILE
 	help
 	  The PA-RISC microprocessor is designed by Hewlett-Packard and used
 	  in many of their workstations & servers (HP9000 700 and 800 series,
diff -puN arch/powerpc/Kconfig~add-have_oprofile arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~add-have_oprofile
+++ a/arch/powerpc/Kconfig
@@ -79,6 +79,7 @@ config ARCH_NO_VIRT_TO_BUS
 config PPC
 	bool
 	default y
+	select HAVE_OPROFILE
 
 config EARLY_PRINTK
 	bool
diff -puN arch/ppc/Kconfig~add-have_oprofile arch/ppc/Kconfig
--- a/arch/ppc/Kconfig~add-have_oprofile
+++ a/arch/ppc/Kconfig
@@ -42,6 +42,7 @@ config GENERIC_CALIBRATE_DELAY
 config PPC
 	bool
 	default y
+	select HAVE_OPROFILE
 
 config PPC32
 	bool
diff -puN arch/s390/Kconfig~add-have_oprofile arch/s390/Kconfig
--- a/arch/s390/Kconfig~add-have_oprofile
+++ a/arch/s390/Kconfig
@@ -51,6 +51,7 @@ mainmenu "Linux Kernel Configuration"
 
 config S390
 	def_bool y
+	select HAVE_OPROFILE
 
 source "init/Kconfig"
 
diff -puN arch/sh/Kconfig~add-have_oprofile arch/sh/Kconfig
--- a/arch/sh/Kconfig~add-have_oprofile
+++ a/arch/sh/Kconfig
@@ -8,6 +8,7 @@ mainmenu "Linux/SuperH Kernel Configurat
 config SUPERH
 	def_bool y
 	select EMBEDDED
+	select HAVE_OPROFILE
 	help
 	  The SuperH is a RISC processor targeted for use in embedded systems
 	  and consumer electronics; it was also used in the Sega Dreamcast
diff -puN arch/sparc/Kconfig~add-have_oprofile arch/sparc/Kconfig
--- a/arch/sparc/Kconfig~add-have_oprofile
+++ a/arch/sparc/Kconfig
@@ -63,6 +63,7 @@ config NR_CPUS
 config SPARC
 	bool
 	default y
+	select HAVE_OPROFILE
 
 # Identify this as a Sparc32 build
 config SPARC32
diff -puN arch/sparc64/Kconfig~add-have_oprofile arch/sparc64/Kconfig
--- a/arch/sparc64/Kconfig~add-have_oprofile
+++ a/arch/sparc64/Kconfig
@@ -8,6 +8,7 @@ mainmenu "Linux/UltraSPARC Kernel Config
 config SPARC
 	bool
 	default y
+	select HAVE_OPROFILE
 
 config SPARC64
 	bool
diff -puN arch/x86/Kconfig~add-have_oprofile arch/x86/Kconfig
--- a/arch/x86/Kconfig~add-have_oprofile
+++ a/arch/x86/Kconfig
@@ -18,6 +18,7 @@ config X86_64
 ### Arch settings
 config X86
 	def_bool y
+	select HAVE_OPROFILE
 
 config GENERIC_TIME
 	def_bool y
diff -puN kernel/Kconfig.instrumentation~add-have_oprofile kernel/Kconfig.instrumentation
--- a/kernel/Kconfig.instrumentation~add-have_oprofile
+++ a/kernel/Kconfig.instrumentation
@@ -20,8 +20,8 @@ config PROFILING
 
 config OPROFILE
 	tristate "OProfile system profiling (EXPERIMENTAL)"
-	depends on PROFILING && !UML
-	depends on ARCH_SUPPORTS_OPROFILE || ALPHA || ARM || BLACKFIN || IA64 || M32R || PARISC || PPC || S390 || SUPERH || SPARC
+	depends on PROFILING
+	depends on HAVE_OPROFILE
 	help
 	  OProfile is a profiling system capable of profiling the
 	  whole system, include the kernel, kernel modules, libraries,
@@ -29,6 +29,9 @@ config OPROFILE
 
 	  If unsure, say N.
 
+config HAVE_OPROFILE
+	def_bool n
+
 config KPROBES
 	bool "Kprobes"
 	depends on KALLSYMS && MODULES && !UML
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
