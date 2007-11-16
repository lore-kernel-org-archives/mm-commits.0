From: akpm@linux-foundation.org
Subject: - add-arch_supports_kprobes.patch removed from -mm tree
Date: Thu, 15 Nov 2007 18:09:01 -0800
Message-ID: <200711160209.lAG291sJ027187@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49162 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759923AbXKPCJL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 21:09:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, linux-arch@vger.kernel.org, sam@ravnborg.org, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Add ARCH_SUPPORTS_KPROBES
has been removed from the -mm tree.  Its filename was
     add-arch_supports_kprobes.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Add ARCH_SUPPORTS_KPROBES
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

 arch/avr32/Kconfig             |    3 +++
 arch/ia64/Kconfig              |    3 +++
 arch/powerpc/Kconfig           |    3 +++
 arch/ppc/Kconfig               |    3 +++
 arch/s390/Kconfig              |    3 +++
 arch/sparc64/Kconfig           |    3 +++
 arch/x86/Kconfig               |    3 +++
 kernel/Kconfig.instrumentation |    2 +-
 8 files changed, 22 insertions(+), 1 deletion(-)

diff -puN arch/avr32/Kconfig~add-arch_supports_kprobes arch/avr32/Kconfig
--- a/arch/avr32/Kconfig~add-arch_supports_kprobes
+++ a/arch/avr32/Kconfig
@@ -70,6 +70,9 @@ config GENERIC_BUG
 config ARCH_SUPPORTS_AOUT
 	def_bool y
 
+config ARCH_SUPPORTS_KPROBES
+	def_bool y
+
 source "init/Kconfig"
 
 menu "System Type and features"
diff -puN arch/ia64/Kconfig~add-arch_supports_kprobes arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~add-arch_supports_kprobes
+++ a/arch/ia64/Kconfig
@@ -105,6 +105,9 @@ config ARCH_SUPPORTS_AOUT
 config ARCH_SUPPORTS_OPROFILE
 	def_bool y
 
+config ARCH_SUPPORTS_KPROBES
+	def_bool y
+
 choice
 	prompt "System type"
 	default IA64_GENERIC
diff -puN arch/powerpc/Kconfig~add-arch_supports_kprobes arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~add-arch_supports_kprobes
+++ a/arch/powerpc/Kconfig
@@ -169,6 +169,9 @@ config PPC_OF_PLATFORM_PCI
 config ARCH_SUPPORTS_OPROFILE
 	def_bool y
 
+config ARCH_SUPPORTS_KPROBES
+	def_bool y
+
 source "init/Kconfig"
 
 source "arch/powerpc/platforms/Kconfig"
diff -puN arch/ppc/Kconfig~add-arch_supports_kprobes arch/ppc/Kconfig
--- a/arch/ppc/Kconfig~add-arch_supports_kprobes
+++ a/arch/ppc/Kconfig
@@ -75,6 +75,9 @@ config GENERIC_BUG
 config ARCH_SUPPORTS_OPROFILE
 	def_bool y
 
+config ARCH_SUPPORTS_KPROBES
+	def_bool y
+
 source "init/Kconfig"
 
 menu "Processor"
diff -puN arch/s390/Kconfig~add-arch_supports_kprobes arch/s390/Kconfig
--- a/arch/s390/Kconfig~add-arch_supports_kprobes
+++ a/arch/s390/Kconfig
@@ -58,6 +58,9 @@ config S390
 config ARCH_SUPPORTS_OPROFILE
 	def_bool y
 
+config ARCH_SUPPORTS_KPROBES
+	def_bool y
+
 source "init/Kconfig"
 
 menu "Base setup"
diff -puN arch/sparc64/Kconfig~add-arch_supports_kprobes arch/sparc64/Kconfig
--- a/arch/sparc64/Kconfig~add-arch_supports_kprobes
+++ a/arch/sparc64/Kconfig
@@ -82,6 +82,9 @@ config ARCH_SUPPORTS_AOUT
 config ARCH_SUPPORTS_OPROFILE
 	def_bool y
 
+config ARCH_SUPPORTS_KPROBES
+	def_bool y
+
 choice
 	prompt "Kernel page size"
 	default SPARC64_PAGE_SIZE_8KB
diff -puN arch/x86/Kconfig~add-arch_supports_kprobes arch/x86/Kconfig
--- a/arch/x86/Kconfig~add-arch_supports_kprobes
+++ a/arch/x86/Kconfig
@@ -175,6 +175,9 @@ config KTIME_SCALAR
 config ARCH_SUPPORTS_OPROFILE
 	def_bool y
 
+config ARCH_SUPPORTS_KPROBES
+	def_bool y
+
 source "init/Kconfig"
 
 menu "Processor type and features"
diff -puN kernel/Kconfig.instrumentation~add-arch_supports_kprobes kernel/Kconfig.instrumentation
--- a/kernel/Kconfig.instrumentation~add-arch_supports_kprobes
+++ a/kernel/Kconfig.instrumentation
@@ -32,7 +32,7 @@ config OPROFILE
 config KPROBES
 	bool "Kprobes"
 	depends on KALLSYMS && MODULES
-	depends on X86_32 || IA64 || PPC || S390 || SPARC64 || X86_64 || AVR32
+	depends on ARCH_SUPPORTS_KPROBES
 	help
 	  Kprobes allows you to trap at almost any kernel address and
 	  execute a callback function.  register_kprobe() establishes
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
add-arch_supports_kprobes.patch
move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig.patch
