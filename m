Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7D9DC433EF
	for <mm-commits@archiver.kernel.org>; Thu,  7 Oct 2021 01:14:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B94DA611AE
	for <mm-commits@archiver.kernel.org>; Thu,  7 Oct 2021 01:14:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbhJGBQP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Oct 2021 21:16:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:43334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230252AbhJGBQP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 6 Oct 2021 21:16:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF13D61177;
        Thu,  7 Oct 2021 01:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633569262;
        bh=vmGU4rXcbLgr8yLlwqVoWYU2o9s7z2ByS7ooPeIF46w=;
        h=Date:From:To:Subject:From;
        b=wsnhrxYzM9czprX0HRUhdE9q7EpeMQyPKnS09/IBwl84R0eyyGy8L9SsziPfn/pYz
         VwJkMZzowZP6eTtiI+siHFQseTiedU7UkVuMyopiAvxsWoD/hzwR+2Gj6oPH5Rvnrp
         taxyCrGVHAZ8BAdAHSMOxj83AIKi2zf9EbkRPLsw=
Date:   Wed, 06 Oct 2021 18:14:21 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, aryabinin@virtuozzo.com,
        branislav.rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, lorenzo.pieralisi@arm.com,
        mm-commits@vger.kernel.org, suzuki.poulose@arm.com,
        vincenzo.frascino@arm.com, will@kernel.org
Subject:  [alternative-merged]
 arm64-mte-add-asymmetric-mode-support.patch removed from -mm tree
Message-ID: <20211007011421.-3zW6kRhz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: mte: add asymmetric mode support
has been removed from the -mm tree.  Its filename was
     arm64-mte-add-asymmetric-mode-support.patch

This patch was dropped because an alternative patch was merged

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

kasan-extend-kasan-mode-kernel-parameter.patch

