From: akpm@linux-foundation.org
Subject: + atomic64_test-simplify-the-ifdef-for-atomic64_dec_if_positive-test.patch added to -mm tree
Date: Wed, 18 Jul 2012 15:11:36 -0700
Message-ID: <20120718221136.AC72D100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:60062 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043Ab2GRWLi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jul 2012 18:11:38 -0400
Received: by vcqp1 with SMTP id p1so223879vcq.1
        for <mm-commits@vger.kernel.org>; Wed, 18 Jul 2012 15:11:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: catalin.marinas@arm.com, benh@kernel.crashing.org, linux@arm.linux.org.uk, paulus@samba.org, ralf@linux-mips.org


The patch titled
     Subject: atomic64_test: simplify the #ifdef for atomic64_dec_if_positive() test
has been added to the -mm tree.  Its filename is
     atomic64_test-simplify-the-ifdef-for-atomic64_dec_if_positive-test.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -121,6 +121,7 @@ config S390
 	select GENERIC_TIME_VSYSCALL
 	select GENERIC_CLOCKEVENTS
 	select KTIME_SCALAR if 32BIT
+	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 
 config SCHED_OMIT_FRAME_POINTER
 	def_bool y
diff -puN arch/x86/Kconfig~atomic64_test-simplify-the-ifdef-for-atomic64_dec_if_positive-test arch/x86/Kconfig
--- a/arch/x86/Kconfig~atomic64_test-simplify-the-ifdef-for-atomic64_dec_if_positive-test
+++ a/arch/x86/Kconfig
@@ -95,6 +95,7 @@ config X86
 	select KTIME_SCALAR if X86_32
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
+	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 
 config INSTRUCTION_DECODER
 	def_bool (KPROBES || PERF_EVENTS || UPROBES)
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
Subject: Subject: atomic64_test: simplify the #ifdef for atomic64_dec_if_positive() test

Patches currently in -mm which might be from catalin.marinas@arm.com are

linux-next.patch
atomic64_test-simplify-the-ifdef-for-atomic64_dec_if_positive-test.patch
ipc-add-compat_shmlba-support.patch
ipc-allow-compat-ipc-version-field-parsing-if-arch_want_old_compat_ipc.patch
ipc-compat-use-signed-size_t-types-for-msgsnd-and-msgrcv.patch
ipc-use-kconfig-options-for-__arch_want_ipc_parse_version.patch
sysctl-suppress-kmemleak-messages.patch

