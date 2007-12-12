From: akpm@linux-foundation.org
Subject: + add-have_kprobes.patch added to -mm tree
Date: Tue, 11 Dec 2007 21:39:02 -0800
Message-ID: <200712120539.lBC5d2HV027845@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35440 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753116AbXLLFl1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 00:41:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, ananth@in.ibm.com, dhowells@redhat.com, jdike@addtoit.com, sam@ravnborg.org


The patch titled
     Add HAVE_KPROBES
has been added to the -mm tree.  Its filename is
     add-have_kprobes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add HAVE_KPROBES
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

        config KPROBES_SUPPORT
                def_bool y

instead, which is a bit denser.

We seem to use both kinds of syntax for these things, but this is really
what "def_bool" is there for...

- Use HAVE_KPROBES
- Use a select

- Yet another update :

Moving to HAVE_* now.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/Kconfig             |    1 +
 arch/ia64/Kconfig              |    1 +
 arch/powerpc/Kconfig           |    1 +
 arch/ppc/Kconfig               |    1 +
 arch/s390/Kconfig              |    1 +
 arch/sparc64/Kconfig           |    1 +
 arch/x86/Kconfig               |    1 +
 kernel/Kconfig.instrumentation |    7 +++++--
 8 files changed, 12 insertions(+), 2 deletions(-)

diff -puN arch/avr32/Kconfig~add-have_kprobes arch/avr32/Kconfig
--- a/arch/avr32/Kconfig~add-have_kprobes
+++ a/arch/avr32/Kconfig
@@ -11,6 +11,7 @@ config AVR32
 	# that we usually don't need on AVR32.
 	select EMBEDDED
 	select HAVE_OPROFILE
+	select HAVE_KPROBES
 	help
 	  AVR32 is a high-performance 32-bit RISC microprocessor core,
 	  designed for cost-sensitive embedded applications, with particular
diff -puN arch/ia64/Kconfig~add-have_kprobes arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~add-have_kprobes
+++ a/arch/ia64/Kconfig
@@ -16,6 +16,7 @@ config IA64
 	select PM if (!IA64_HP_SIM)
 	select ARCH_SUPPORTS_MSI
 	select HAVE_OPROFILE
+	select HAVE_KPROBES
 	default y
 	help
 	  The Itanium Processor Family is Intel's 64-bit successor to
diff -puN arch/powerpc/Kconfig~add-have_kprobes arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~add-have_kprobes
+++ a/arch/powerpc/Kconfig
@@ -80,6 +80,7 @@ config PPC
 	bool
 	default y
 	select HAVE_OPROFILE
+	select HAVE_KPROBES
 
 config EARLY_PRINTK
 	bool
diff -puN arch/ppc/Kconfig~add-have_kprobes arch/ppc/Kconfig
--- a/arch/ppc/Kconfig~add-have_kprobes
+++ a/arch/ppc/Kconfig
@@ -43,6 +43,7 @@ config PPC
 	bool
 	default y
 	select HAVE_OPROFILE
+	select HAVE_KPROBES
 
 config PPC32
 	bool
diff -puN arch/s390/Kconfig~add-have_kprobes arch/s390/Kconfig
--- a/arch/s390/Kconfig~add-have_kprobes
+++ a/arch/s390/Kconfig
@@ -52,6 +52,7 @@ mainmenu "Linux Kernel Configuration"
 config S390
 	def_bool y
 	select HAVE_OPROFILE
+	select HAVE_KPROBES
 
 source "init/Kconfig"
 
diff -puN arch/sparc64/Kconfig~add-have_kprobes arch/sparc64/Kconfig
--- a/arch/sparc64/Kconfig~add-have_kprobes
+++ a/arch/sparc64/Kconfig
@@ -9,6 +9,7 @@ config SPARC
 	bool
 	default y
 	select HAVE_OPROFILE
+	select HAVE_KPROBES
 
 config SPARC64
 	bool
diff -puN arch/x86/Kconfig~add-have_kprobes arch/x86/Kconfig
--- a/arch/x86/Kconfig~add-have_kprobes
+++ a/arch/x86/Kconfig
@@ -19,6 +19,7 @@ config X86_64
 config X86
 	def_bool y
 	select HAVE_OPROFILE
+	select HAVE_KPROBES
 
 config GENERIC_TIME
 	def_bool y
diff -puN kernel/Kconfig.instrumentation~add-have_kprobes kernel/Kconfig.instrumentation
--- a/kernel/Kconfig.instrumentation~add-have_kprobes
+++ a/kernel/Kconfig.instrumentation
@@ -34,8 +34,8 @@ config HAVE_OPROFILE
 
 config KPROBES
 	bool "Kprobes"
-	depends on KALLSYMS && MODULES && !UML
-	depends on X86_32 || IA64 || PPC || S390 || SPARC64 || X86_64 || AVR32
+	depends on KALLSYMS && MODULES
+	depends on HAVE_KPROBES
 	help
 	  Kprobes allows you to trap at almost any kernel address and
 	  execute a callback function.  register_kprobe() establishes
@@ -43,6 +43,9 @@ config KPROBES
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".
 
+config HAVE_KPROBES
+	def_bool n
+
 config MARKERS
 	bool "Activate markers"
 	help
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
