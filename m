Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A375DC433F5
	for <mm-commits@archiver.kernel.org>; Tue,  5 Oct 2021 22:24:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86E6B610E5
	for <mm-commits@archiver.kernel.org>; Tue,  5 Oct 2021 22:24:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbhJEW0c (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Oct 2021 18:26:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:38040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229831AbhJEW0c (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 5 Oct 2021 18:26:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0686C6108F;
        Tue,  5 Oct 2021 22:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633472681;
        bh=hfMWH2p2nCE54YSlYNCSJfsEaaZ+b6Jxpt6ROkOTRxE=;
        h=Date:From:To:Subject:From;
        b=XpKeThB+YRzNE1gafc5e2sO3ddH0cNCNTlTjdgg6FrDlHJ6xQ6D6s0ECu61rioqAw
         mQeK3/dsnXFa0flEajvaDsW8vdl27CB9uiovW6l0gSpLsWeJJGttRau4AW+ZF6XYXc
         PdofcXrVVJvKvOiR0ZURPoT639AYuBBJSL8nlYhQ=
Date:   Tue, 05 Oct 2021 15:24:40 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, aryabinin@virtuozzo.com,
        branislav.rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, lorenzo.pieralisi@arm.com,
        mm-commits@vger.kernel.org, suzuki.poulose@arm.com,
        vincenzo.frascino@arm.com, will@kernel.org
Subject:  + arm64-mte-add-asymmetric-mode-support.patch added to
 -mm tree
Message-ID: <20211005222440.yIRpejGl2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: mte: add asymmetric mode support
has been added to the -mm tree.  Its filename is
     arm64-mte-add-asymmetric-mode-support.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arm64-mte-add-asymmetric-mode-support.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arm64-mte-add-asymmetric-mode-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: arm64: mte: add asymmetric mode support

MTE provides an asymmetric mode for detecting tag exceptions.  In
particular, when such a mode is present, the CPU triggers a fault on a tag
mismatch during a load operation and asynchronously updates a register
when a tag mismatch is detected during a store operation.

Add support for MTE asymmetric mode.

Note: If the CPU does not support MTE asymmetric mode the kernel falls
back on synchronous mode which is the default for kasan=on.

Link: https://lkml.kernel.org/r/20211004202253.27857-5-vincenzo.frascino@arm.com
Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <branislav.rankov@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Marco Elver <elver@google.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/memory.h    |    1 
 arch/arm64/include/asm/mte-kasan.h |    5 ++++
 arch/arm64/kernel/mte.c            |   33 ++++++++++++++++++++++++++-
 3 files changed, 38 insertions(+), 1 deletion(-)

--- a/arch/arm64/include/asm/memory.h~arm64-mte-add-asymmetric-mode-support
+++ a/arch/arm64/include/asm/memory.h
@@ -243,6 +243,7 @@ static inline const void *__tag_set(cons
 #ifdef CONFIG_KASAN_HW_TAGS
 #define arch_enable_tagging_sync()		mte_enable_kernel_sync()
 #define arch_enable_tagging_async()		mte_enable_kernel_async()
+#define arch_enable_tagging_asymm()		mte_enable_kernel_asymm()
 #define arch_force_async_tag_fault()		mte_check_tfsr_exit()
 #define arch_get_random_tag()			mte_get_random_tag()
 #define arch_get_mem_tag(addr)			mte_get_mem_tag(addr)
--- a/arch/arm64/include/asm/mte-kasan.h~arm64-mte-add-asymmetric-mode-support
+++ a/arch/arm64/include/asm/mte-kasan.h
@@ -130,6 +130,7 @@ static inline void mte_set_mem_tag_range
 
 void mte_enable_kernel_sync(void);
 void mte_enable_kernel_async(void);
+void mte_enable_kernel_asymm(void);
 
 #else /* CONFIG_ARM64_MTE */
 
@@ -161,6 +162,10 @@ static inline void mte_enable_kernel_asy
 {
 }
 
+static inline void mte_enable_kernel_asymm(void)
+{
+}
+
 #endif /* CONFIG_ARM64_MTE */
 
 #endif /* __ASSEMBLY__ */
--- a/arch/arm64/kernel/mte.c~arm64-mte-add-asymmetric-mode-support
+++ a/arch/arm64/kernel/mte.c
@@ -26,7 +26,12 @@
 static DEFINE_PER_CPU_READ_MOSTLY(u64, mte_tcf_preferred);
 
 #ifdef CONFIG_KASAN_HW_TAGS
-/* Whether the MTE asynchronous mode is enabled. */
+/*
+ * The MTE asynchronous and asymmetric mode have the same
+ * behavior for the store operations.
+ *
+ * Whether the MTE asynchronous or asymmetric mode is enabled.
+ */
 DEFINE_STATIC_KEY_FALSE(mte_async_mode);
 EXPORT_SYMBOL_GPL(mte_async_mode);
 #endif
@@ -137,6 +142,32 @@ void mte_enable_kernel_async(void)
 	if (!system_uses_mte_async_mode())
 		static_branch_enable(&mte_async_mode);
 }
+
+void mte_enable_kernel_asymm(void)
+{
+	if (cpus_have_cap(ARM64_MTE_ASYMM)) {
+		__mte_enable_kernel("asymmetric", SCTLR_ELx_TCF_ASYMM);
+
+		/*
+		 * MTE asymm mode behaves as async mode for store
+		 * operations. The mode is set system wide by the
+		 * first PE that executes this function.
+		 *
+		 * Note: If in future KASAN acquires a runtime switching
+		 * mode in between sync and async, this strategy needs
+		 * to be reviewed.
+		 */
+		if (!system_uses_mte_async_mode())
+			static_branch_enable(&mte_async_mode);
+	} else {
+		/*
+		 * If the CPU does not support MTE asymmetric mode the
+		 * kernel falls back on synchronous mode which is the
+		 * default for kasan=on.
+		 */
+		mte_enable_kernel_sync();
+	}
+}
 #endif
 
 #ifdef CONFIG_KASAN_HW_TAGS
_

Patches currently in -mm which might be from vincenzo.frascino@arm.com are

kasan-remove-duplicate-of-kasan_flag_async.patch
arm64-mte-bitfield-definitions-for-asymm-mte.patch
arm64-mte-cpu-feature-detection-for-asymm-mte.patch
arm64-mte-add-asymmetric-mode-support.patch
kasan-extend-kasan-mode-kernel-parameter.patch

