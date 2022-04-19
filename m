Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F26ABC43217
	for <mm-commits@archiver.kernel.org>; Tue, 19 Apr 2022 00:26:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240351AbiDSA2q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 18 Apr 2022 20:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240371AbiDSA2p (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 18 Apr 2022 20:28:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB36C237E0
        for <mm-commits@vger.kernel.org>; Mon, 18 Apr 2022 17:26:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B5D7B81123
        for <mm-commits@vger.kernel.org>; Tue, 19 Apr 2022 00:26:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48394C385A7;
        Tue, 19 Apr 2022 00:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650327962;
        bh=tb0+BBdb7c4gE60UHMIroPT79NTBgFqPSyo1dvM7U04=;
        h=Date:To:From:Subject:From;
        b=FGlx1BzJlcWGSlDDadTspcc2WlvoclZ/Zq6lLepMVvV0GFBDAj2kCciPziCQ6JCH8
         sJfD+k6P500g/JPdZqd29A7eM5C/K+Pi6u1A/HN3A388YrLLEo0i8XgHdPG5lzqn7S
         rL5BvsfR+7SpuS41D4t9cAGJia3T5zgq9PzoEME8=
Date:   Mon, 18 Apr 2022 17:26:01 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        ryabinin.a.a@gmail.com, glider@google.com, dvyukov@google.com,
        catalin.marinas@arm.com, andreyknvl@gmail.com,
        vincenzo.frascino@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kasan-fix-hw-tags-enablement-when-kunit-tests-are-disabled.patch removed from -mm tree
Message-Id: <20220419002602.48394C385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: fix hw tags enablement when KUNIT tests are disabled
has been removed from the -mm tree.  Its filename was
     kasan-fix-hw-tags-enablement-when-kunit-tests-are-disabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: kasan: fix hw tags enablement when KUNIT tests are disabled

Kasan enables hw tags via kasan_enable_tagging() which based on the mode
passed via kernel command line selects the correct hw backend. 
kasan_enable_tagging() is meant to be invoked indirectly via the cpu
features framework of the architectures that support these backends. 
Currently the invocation of this function is guarded by
CONFIG_KASAN_KUNIT_TEST which allows the enablement of the correct backend
only when KUNIT tests are enabled in the kernel.

This inconsistency was introduced in commit:

  ed6d74446cbf ("kasan: test: support async (again) and asymm modes for HW_TAGS")

... and prevents to enable MTE on arm64 when KUNIT tests for kasan hw_tags are
disabled.

Fix the issue making sure that the CONFIG_KASAN_KUNIT_TEST guard does not
prevent the correct invocation of kasan_enable_tagging().

Link: https://lkml.kernel.org/r/20220408124323.10028-1-vincenzo.frascino@arm.com
Fixes: ed6d74446cbf ("kasan: test: support async (again) and asymm modes for HW_TAGS")
Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/hw_tags.c |    5 +++--
 mm/kasan/kasan.h   |   10 ++++++----
 2 files changed, 9 insertions(+), 6 deletions(-)

--- a/mm/kasan/hw_tags.c~kasan-fix-hw-tags-enablement-when-kunit-tests-are-disabled
+++ a/mm/kasan/hw_tags.c
@@ -336,8 +336,6 @@ void __kasan_poison_vmalloc(const void *
 
 #endif
 
-#if IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
-
 void kasan_enable_tagging(void)
 {
 	if (kasan_arg_mode == KASAN_ARG_MODE_ASYNC)
@@ -347,6 +345,9 @@ void kasan_enable_tagging(void)
 	else
 		hw_enable_tagging_sync();
 }
+
+#if IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
+
 EXPORT_SYMBOL_GPL(kasan_enable_tagging);
 
 void kasan_force_async_fault(void)
--- a/mm/kasan/kasan.h~kasan-fix-hw-tags-enablement-when-kunit-tests-are-disabled
+++ a/mm/kasan/kasan.h
@@ -355,25 +355,27 @@ static inline const void *arch_kasan_set
 #define hw_set_mem_tag_range(addr, size, tag, init) \
 			arch_set_mem_tag_range((addr), (size), (tag), (init))
 
+void kasan_enable_tagging(void);
+
 #else /* CONFIG_KASAN_HW_TAGS */
 
 #define hw_enable_tagging_sync()
 #define hw_enable_tagging_async()
 #define hw_enable_tagging_asymm()
 
+static inline void kasan_enable_tagging(void) { }
+
 #endif /* CONFIG_KASAN_HW_TAGS */
 
 #if defined(CONFIG_KASAN_HW_TAGS) && IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
 
-void kasan_enable_tagging(void);
 void kasan_force_async_fault(void);
 
-#else /* CONFIG_KASAN_HW_TAGS || CONFIG_KASAN_KUNIT_TEST */
+#else /* CONFIG_KASAN_HW_TAGS && CONFIG_KASAN_KUNIT_TEST */
 
-static inline void kasan_enable_tagging(void) { }
 static inline void kasan_force_async_fault(void) { }
 
-#endif /* CONFIG_KASAN_HW_TAGS || CONFIG_KASAN_KUNIT_TEST */
+#endif /* CONFIG_KASAN_HW_TAGS && CONFIG_KASAN_KUNIT_TEST */
 
 #ifdef CONFIG_KASAN_SW_TAGS
 u8 kasan_random_tag(void);
_

Patches currently in -mm which might be from vincenzo.frascino@arm.com are


