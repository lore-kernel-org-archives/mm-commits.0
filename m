From: akpm@linux-foundation.org
Subject: +
 fix-offset2lib-issue-for-x86-arm-powerpc-and-mips-fix-fix-2.patch added to
 -mm tree
Date: Thu, 26 Feb 2015 15:34:39 -0800
Message-ID: <54efad8f.S2cQa5VLp0zRUxEA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60508 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932355AbbBZXek (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Feb 2015 18:34:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, benh@kernel.crashing.org, catalin.marinas@arm.com, hecmargi@upv.es, hpa@zytor.com, iripoll@upv.es, keescook@chromium.org, mingo@kernel.org, ralf@linux-mips.org, rmk@arm.linux.org.uk, tglx@linutronix.de, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fix-offset2lib-issue-for-x86-arm-powerpc-and-mips-fix-fix-2
has been added to the -mm tree.  Its filename is
     fix-offset2lib-issue-for-x86-arm-powerpc-and-mips-fix-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fix-offset2lib-issue-for-x86-arm-powerpc-and-mips-fix-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fix-offset2lib-issue-for-x86-arm-powerpc-and-mips-fix-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fix-offset2lib-issue-for-x86-arm-powerpc-and-mips-fix-fix-2

Create and use ARCH_HAVE_ELF_ASLR.

There are probably lots of other places which should use this.

Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Hector Marco Gisbert <hecmargi@upv.es>
Cc: Hector Marco-Gisbert <hecmargi@upv.es>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Ismael Ripoll <iripoll@upv.es>
Cc: Kees Cook <keescook@chromium.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig     |    1 +
 arch/arm64/Kconfig   |    1 +
 arch/mips/Kconfig    |    1 +
 arch/powerpc/Kconfig |    1 +
 arch/x86/Kconfig     |    1 +
 fs/Kconfig           |    3 +++
 fs/binfmt_elf.c      |   11 ++---------
 7 files changed, 10 insertions(+), 9 deletions(-)

diff -puN arch/arm/Kconfig~fix-offset2lib-issue-for-x86-arm-powerpc-and-mips-fix-fix-2 arch/arm/Kconfig
--- a/arch/arm/Kconfig~fix-offset2lib-issue-for-x86-arm-powerpc-and-mips-fix-fix-2
+++ a/arch/arm/Kconfig
@@ -5,6 +5,7 @@ config ARM
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_HAVE_CUSTOM_GPIO_H
 	select ARCH_HAS_GCOV_PROFILE_ALL
+	select ARCH_HAVE_ELF_ASLR
 	select ARCH_MIGHT_HAVE_PC_PARPORT
 	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_USE_BUILTIN_BSWAP
diff -puN arch/arm64/Kconfig~fix-offset2lib-issue-for-x86-arm-powerpc-and-mips-fix-fix-2 arch/arm64/Kconfig
--- a/arch/arm64/Kconfig~fix-offset2lib-issue-for-x86-arm-powerpc-and-mips-fix-fix-2
+++ a/arch/arm64/Kconfig
@@ -9,6 +9,7 @@ config ARM64
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARCH_WANT_COMPAT_IPC_PARSE_VERSION
 	select ARCH_WANT_FRAME_POINTERS
+	select ARCH_HAVE_ELF_ASLR
 	select ARM_AMBA
 	select ARM_ARCH_TIMER
 	select ARM_GIC
diff -puN arch/mips/Kconfig~fix-offset2lib-issue-for-x86-arm-powerpc-and-mips-fix-fix-2 arch/mips/Kconfig
--- a/arch/mips/Kconfig~fix-offset2lib-issue-for-x86-arm-powerpc-and-mips-fix-fix-2
+++ a/arch/mips/Kconfig
@@ -39,6 +39,7 @@ config MIPS
 	select HAVE_MEMBLOCK
 	select HAVE_MEMBLOCK_NODE_MAP
 	select ARCH_DISCARD_MEMBLOCK
+	select ARCH_HAVE_ELF_ASLR
 	select GENERIC_SMP_IDLE_THREAD
 	select BUILDTIME_EXTABLE_SORT
 	select GENERIC_CLOCKEVENTS
diff -puN arch/powerpc/Kconfig~fix-offset2lib-issue-for-x86-arm-powerpc-and-mips-fix-fix-2 arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~fix-offset2lib-issue-for-x86-arm-powerpc-and-mips-fix-fix-2
+++ a/arch/powerpc/Kconfig
@@ -97,6 +97,7 @@ config PPC
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select SYSCTL_EXCEPTION_TRACE
 	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select ARCH_HAVE_ELF_ASLR
 	select VIRT_TO_BUS if !PPC64
 	select HAVE_IDE
 	select HAVE_IOREMAP_PROT
diff -puN arch/x86/Kconfig~fix-offset2lib-issue-for-x86-arm-powerpc-and-mips-fix-fix-2 arch/x86/Kconfig
--- a/arch/x86/Kconfig~fix-offset2lib-issue-for-x86-arm-powerpc-and-mips-fix-fix-2
+++ a/arch/x86/Kconfig
@@ -28,6 +28,7 @@ config X86
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_MIGHT_HAVE_PC_PARPORT
 	select ARCH_MIGHT_HAVE_PC_SERIO
+	select ARCH_HAVE_ELF_ASLR
 	select HAVE_AOUT if X86_32
 	select HAVE_UNSTABLE_SCHED_CLOCK
 	select ARCH_SUPPORTS_NUMA_BALANCING if X86_64
diff -puN fs/Kconfig~fix-offset2lib-issue-for-x86-arm-powerpc-and-mips-fix-fix-2 fs/Kconfig
--- a/fs/Kconfig~fix-offset2lib-issue-for-x86-arm-powerpc-and-mips-fix-fix-2
+++ a/fs/Kconfig
@@ -50,6 +50,9 @@ config FS_DAX
 
 endif # BLOCK
 
+config ARCH_HAVE_ELF_ASLR
+	bool
+
 # Posix ACL utility routines
 #
 # Note: Posix ACLs can be implemented without these helpers.  Never use
diff -puN fs/binfmt_elf.c~fix-offset2lib-issue-for-x86-arm-powerpc-and-mips-fix-fix-2 fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~fix-offset2lib-issue-for-x86-arm-powerpc-and-mips-fix-fix-2
+++ a/fs/binfmt_elf.c
@@ -2301,15 +2301,7 @@ out:
 
 #endif		/* CONFIG_ELF_CORE */
 
-/* Not all architectures implement mmap_rnd() */
-unsigned long __weak mmap_rnd(void)
-{
-}
-
-/*
- * Not all architectures use randomize_et_dyn(), but there doesn't seem to be
- * a compile-time way of avoiding its generation.
- */
+#ifdef ARCH_HAVE_ELF_ASLR
 unsigned long randomize_et_dyn(unsigned long base)
 {
 	unsigned long ret;
@@ -2320,6 +2312,7 @@ unsigned long randomize_et_dyn(unsigned
 	ret = base + mmap_rnd();
 	return max(ret, base);
 }
+#endif
 
 static int __init init_elf_binfmt(void)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
kernel-sysc-fix-uname26-for-40-fix.patch
mm.patch
mm-cma-release-trigger-checkpatch-fixes.patch
mm-cma-allocation-trigger-fix.patch
mm-compaction-enhance-compaction-finish-condition-fix.patch
page_writeback-cleanup-mess-around-cancel_dirty_page-checkpatch-fixes.patch
mm-hide-per-cpu-lists-in-output-of-show_mem-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mips-rename-brk_rnd-to-mmap_rnd.patch
fix-offset2lib-issue-for-x86-arm-powerpc-and-mips-fix.patch
fix-offset2lib-issue-for-x86-arm-powerpc-and-mips-fix-fix.patch
fix-offset2lib-issue-for-x86-arm-powerpc-and-mips-fix-fix-2.patch
kernel-conditionally-support-non-root-users-groups-and-capabilities-checkpatch-fixes.patch
lib-find__bit-reimplementation-fix.patch
binfmt_misc-simplify-entry_status-fix.patch
fs-fat-remove-unnecessary-includes-fix.patch
kconfig-use-macros-which-are-already-defined-fix.patch
linux-next.patch
linux-next-rejects.patch
lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

