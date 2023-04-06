Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1133BC7619A
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:45:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234965AbjDFCou (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234487AbjDFCoY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:44:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 312D18690
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:44:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC6AA64266
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:44:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BDBAC433D2;
        Thu,  6 Apr 2023 02:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749062;
        bh=MuvIGLwViy293hhi3A1MXz1thpoi8xjeY2zS6mrh4BI=;
        h=Date:To:From:Subject:From;
        b=0U0USDR2IorYwad3qk3WuGLni14HEZOBfM2CGweKQCDMomH/sErIU0BT60ke4RSS3
         /mnQfO/i02Rx6mBp9HEF+l09D1JUCUmMaDy3qR8FWsEWFVY4o5zkBnZ1QnfCA1Zo+m
         GaiWZqPmTvdevc+SivjulTejkMff4vI7XC9gmNDs=
Date:   Wed, 05 Apr 2023 19:44:21 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        vincenzo.frascino@arm.com, ryabinin.a.a@gmail.com, pcc@google.com,
        ouyangweizhao@zeku.com, glider@google.com, eugenis@google.com,
        elver@google.com, dvyukov@google.com, catalin.marinas@arm.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-arm64-rename-tagging-related-routines.patch removed from -mm tree
Message-Id: <20230406024422.1BDBAC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kasan, arm64: rename tagging-related routines
has been removed from the -mm tree.  Its filename was
     kasan-arm64-rename-tagging-related-routines.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan, arm64: rename tagging-related routines
Date: Sat, 11 Mar 2023 00:43:30 +0100

Rename arch_enable_tagging_sync/async/asymm to
arch_enable_tag_checks_sync/async/asymm, as the new name better reflects
their function.

Also rename kasan_enable_tagging to kasan_enable_hw_tags for the same
reason.

Link: https://lkml.kernel.org/r/069ef5b77715c1ac8d69b186725576c32b149491.1678491668.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Weizhao Ouyang <ouyangweizhao@zeku.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/memory.h |    6 +++---
 mm/kasan/hw_tags.c              |   12 ++++++------
 mm/kasan/kasan.h                |   10 +++++-----
 mm/kasan/kasan_test.c           |    2 +-
 4 files changed, 15 insertions(+), 15 deletions(-)

--- a/arch/arm64/include/asm/memory.h~kasan-arm64-rename-tagging-related-routines
+++ a/arch/arm64/include/asm/memory.h
@@ -261,9 +261,9 @@ static inline const void *__tag_set(cons
 }
 
 #ifdef CONFIG_KASAN_HW_TAGS
-#define arch_enable_tagging_sync()		mte_enable_kernel_sync()
-#define arch_enable_tagging_async()		mte_enable_kernel_async()
-#define arch_enable_tagging_asymm()		mte_enable_kernel_asymm()
+#define arch_enable_tag_checks_sync()		mte_enable_kernel_sync()
+#define arch_enable_tag_checks_async()		mte_enable_kernel_async()
+#define arch_enable_tag_checks_asymm()		mte_enable_kernel_asymm()
 #define arch_force_async_tag_fault()		mte_check_tfsr_exit()
 #define arch_get_random_tag()			mte_get_random_tag()
 #define arch_get_mem_tag(addr)			mte_get_mem_tag(addr)
--- a/mm/kasan/hw_tags.c~kasan-arm64-rename-tagging-related-routines
+++ a/mm/kasan/hw_tags.c
@@ -205,7 +205,7 @@ void kasan_init_hw_tags_cpu(void)
 	 * Enable async or asymm modes only when explicitly requested
 	 * through the command line.
 	 */
-	kasan_enable_tagging();
+	kasan_enable_hw_tags();
 }
 
 /* kasan_init_hw_tags() is called once on boot CPU. */
@@ -373,19 +373,19 @@ void __kasan_poison_vmalloc(const void *
 
 #endif
 
-void kasan_enable_tagging(void)
+void kasan_enable_hw_tags(void)
 {
 	if (kasan_arg_mode == KASAN_ARG_MODE_ASYNC)
-		hw_enable_tagging_async();
+		hw_enable_tag_checks_async();
 	else if (kasan_arg_mode == KASAN_ARG_MODE_ASYMM)
-		hw_enable_tagging_asymm();
+		hw_enable_tag_checks_asymm();
 	else
-		hw_enable_tagging_sync();
+		hw_enable_tag_checks_sync();
 }
 
 #if IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
 
-EXPORT_SYMBOL_GPL(kasan_enable_tagging);
+EXPORT_SYMBOL_GPL(kasan_enable_hw_tags);
 
 void kasan_force_async_fault(void)
 {
--- a/mm/kasan/kasan.h~kasan-arm64-rename-tagging-related-routines
+++ a/mm/kasan/kasan.h
@@ -395,20 +395,20 @@ static inline const void *arch_kasan_set
 
 #ifdef CONFIG_KASAN_HW_TAGS
 
-#define hw_enable_tagging_sync()		arch_enable_tagging_sync()
-#define hw_enable_tagging_async()		arch_enable_tagging_async()
-#define hw_enable_tagging_asymm()		arch_enable_tagging_asymm()
+#define hw_enable_tag_checks_sync()		arch_enable_tag_checks_sync()
+#define hw_enable_tag_checks_async()		arch_enable_tag_checks_async()
+#define hw_enable_tag_checks_asymm()		arch_enable_tag_checks_asymm()
 #define hw_force_async_tag_fault()		arch_force_async_tag_fault()
 #define hw_get_random_tag()			arch_get_random_tag()
 #define hw_get_mem_tag(addr)			arch_get_mem_tag(addr)
 #define hw_set_mem_tag_range(addr, size, tag, init) \
 			arch_set_mem_tag_range((addr), (size), (tag), (init))
 
-void kasan_enable_tagging(void);
+void kasan_enable_hw_tags(void);
 
 #else /* CONFIG_KASAN_HW_TAGS */
 
-static inline void kasan_enable_tagging(void) { }
+static inline void kasan_enable_hw_tags(void) { }
 
 #endif /* CONFIG_KASAN_HW_TAGS */
 
--- a/mm/kasan/kasan_test.c~kasan-arm64-rename-tagging-related-routines
+++ a/mm/kasan/kasan_test.c
@@ -148,7 +148,7 @@ static void kasan_test_exit(struct kunit
 	    kasan_sync_fault_possible()) {				\
 		if (READ_ONCE(test_status.report_found) &&		\
 		    !READ_ONCE(test_status.async_fault))		\
-			kasan_enable_tagging();				\
+			kasan_enable_hw_tags();				\
 		migrate_enable();					\
 	}								\
 	WRITE_ONCE(test_status.report_found, false);			\
_

Patches currently in -mm which might be from andreyknvl@google.com are

kcov-improve-documentation.patch
kcov-improve-documentation-v2.patch
kcov-improve-documentation-v3.patch

