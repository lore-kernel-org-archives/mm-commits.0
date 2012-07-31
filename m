From: akpm@linux-foundation.org
Subject: [merged] atomic64_test-simplify-the-ifdef-for-atomic64_dec_if_positive-test.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:51:25 -0700
Message-ID: <20120731185125.D09F510007F@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:42024 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756325Ab2GaSv1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:51:27 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4679387obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:51:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, benh@kernel.crashing.org, linux@arm.linux.org.uk, paulus@samba.org, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     Subject: atomic64_test: simplify the #ifdef for atomic64_dec_if_positive() test
has been removed from the -mm tree.  Its filename was
     atomic64_test-simplify-the-ifdef-for-atomic64_dec_if_positive-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: atomic64_test: simplify the #ifdef for atomic64_dec_if_positive() test

Introduce CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE and use this instead
of the multitude of #if defined() checks in atomic64_test.c

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig     |    1 +
 arch/mips/Kconfig    |    1 +
 arch/powerpc/Kconfig |    1 +
 arch/s390/Kconfig    |    1 +
 arch/x86/Kconfig     |    1 +
 lib/Kconfig          |    3 +++
 lib/atomic64_test.c  |    5 ++---
 7 files changed, 10 insertions(+), 3 deletions(-)

diff -puN arch/arm/Kconfig~atomic64_test-simplify-the-ifdef-for-atomic64_dec_if_positive-test arch/arm/Kconfig
--- a/arch/arm/Kconfig~atomic64_test-simplify-the-ifdef-for-atomic64_dec_if_positive-test
+++ a/arch/arm/Kconfig
@@ -11,6 +11,7 @@ config ARM
 	select RTC_LIB
 	select SYS_SUPPORTS_APM_EMULATION
 	select GENERIC_ATOMIC64 if (CPU_V6 || !CPU_32v6K || !AEABI)
+	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select HAVE_OPROFILE if (HAVE_PERF_EVENTS)
 	select HAVE_ARCH_JUMP_LABEL if !XIP_KERNEL
 	select HAVE_ARCH_KGDB
diff -puN arch/mips/Kconfig~atomic64_test-simplify-the-ifdef-for-atomic64_dec_if_positive-test arch/mips/Kconfig
--- a/arch/mips/Kconfig~atomic64_test-simplify-the-ifdef-for-atomic64_dec_if_positive-test
+++ a/arch/mips/Kconfig
@@ -20,6 +20,7 @@ config MIPS
 	select ARCH_BINFMT_ELF_RANDOMIZE_PIE
 	select RTC_LIB if !MACH_LOONGSON
 	select GENERIC_ATOMIC64 if !64BIT
+	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select HAVE_DMA_ATTRS
 	select HAVE_DMA_API_DEBUG
 	select HAVE_GENERIC_HARDIRQS
diff -puN arch/powerpc/Kconfig~atomic64_test-simplify-the-ifdef-for-atomic64_dec_if_positive-test arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~atomic64_test-simplify-the-ifdef-for-atomic64_dec_if_positive-test
+++ a/arch/powerpc/Kconfig
@@ -115,6 +115,7 @@ config PPC
 	select HAVE_OPROFILE
 	select HAVE_SYSCALL_WRAPPERS if PPC64
 	select GENERIC_ATOMIC64 if PPC32
+	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
 	select HAVE_REGS_AND_STACK_ACCESS_API
diff -puN arch/s390/Kconfig~atomic64_test-simplify-the-ifdef-for-atomic64_dec_if_positive-test arch/s390/Kconfig
--- a/arch/s390/Kconfig~atomic64_test-simplify-the-ifdef-for-atomic64_dec_if_positive-test
+++ a/arch/s390/Kconfig
@@ -85,6 +85,7 @@ config S390
 	select HAVE_ARCH_MUTEX_CPU_RELAX
 	select HAVE_ARCH_JUMP_LABEL if !MARCH_G5
 	select ARCH_SAVE_PAGE_KEYS if HIBERNATION
+	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select HAVE_MEMBLOCK
 	select HAVE_MEMBLOCK_NODE_MAP
 	select HAVE_CMPXCHG_LOCAL
diff -puN arch/x86/Kconfig~atomic64_test-simplify-the-ifdef-for-atomic64_dec_if_positive-test arch/x86/Kconfig
--- a/arch/x86/Kconfig~atomic64_test-simplify-the-ifdef-for-atomic64_dec_if_positive-test
+++ a/arch/x86/Kconfig
@@ -70,6 +70,7 @@ config X86
 	select HAVE_ARCH_JUMP_LABEL
 	select HAVE_TEXT_POKE_SMP
 	select HAVE_GENERIC_HARDIRQS
+	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select SPARSE_IRQ
 	select GENERIC_FIND_FIRST_BIT
 	select GENERIC_IRQ_PROBE
diff -puN lib/Kconfig~atomic64_test-simplify-the-ifdef-for-atomic64_dec_if_positive-test lib/Kconfig
--- a/lib/Kconfig~atomic64_test-simplify-the-ifdef-for-atomic64_dec_if_positive-test
+++ a/lib/Kconfig
@@ -340,6 +340,9 @@ config NLATTR
 config GENERIC_ATOMIC64
        bool
 
+config ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
+	def_bool y if GENERIC_ATOMIC64
+
 config LRU_CACHE
 	tristate
 
diff -puN lib/atomic64_test.c~atomic64_test-simplify-the-ifdef-for-atomic64_dec_if_positive-test lib/atomic64_test.c
--- a/lib/atomic64_test.c~atomic64_test-simplify-the-ifdef-for-atomic64_dec_if_positive-test
+++ a/lib/atomic64_test.c
@@ -114,8 +114,7 @@ static __init int test_atomic64(void)
 	r += one;
 	BUG_ON(v.counter != r);
 
-#if defined(CONFIG_X86) || defined(CONFIG_MIPS) || defined(CONFIG_PPC) || \
-    defined(CONFIG_S390) || defined(_ASM_GENERIC_ATOMIC64_H) || defined(CONFIG_ARM)
+#ifdef CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	INIT(onestwos);
 	BUG_ON(atomic64_dec_if_positive(&v) != (onestwos - 1));
 	r -= one;
@@ -129,7 +128,7 @@ static __init int test_atomic64(void)
 	BUG_ON(atomic64_dec_if_positive(&v) != (-one - one));
 	BUG_ON(v.counter != r);
 #else
-#warning Please implement atomic64_dec_if_positive for your architecture, and add it to the IF above
+#warning Please implement atomic64_dec_if_positive for your architecture and select the above Kconfig symbol
 #endif
 
 	INIT(onestwos);
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

origin.patch
linux-next.patch

