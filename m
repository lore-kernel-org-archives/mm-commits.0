Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51E16C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 15 Apr 2022 02:13:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346792AbiDOCQK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 14 Apr 2022 22:16:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346914AbiDOCQF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Apr 2022 22:16:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D036E3190A
        for <mm-commits@vger.kernel.org>; Thu, 14 Apr 2022 19:13:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 666156221D
        for <mm-commits@vger.kernel.org>; Fri, 15 Apr 2022 02:13:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC941C385A5;
        Fri, 15 Apr 2022 02:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649988817;
        bh=EfxUkKFZzWkmoYV6d36EtWBG7TfddY7SyrUEmRqbwxw=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=HMaxL6ChH2BQWWhrTJgpaZ/sGz0NU61fjVwtA1EBjmby/ybV5FL3ngKk1TNdlTlaX
         IZL4QiwsOVrODLMmzjq3LNmMg4tBLE4/tzHRh9AMZGBOo+9Z22eXeTXE6S0szlU7qE
         q71otZh4qgk2q/91DBo7cokoTOZHb4cLDjcdIcFw=
Date:   Thu, 14 Apr 2022 19:13:37 -0700
To:     will@kernel.org, ryabinin.a.a@gmail.com, glider@google.com,
        dvyukov@google.com, catalin.marinas@arm.com, andreyknvl@gmail.com,
        vincenzo.frascino@arm.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220414191240.9f86d15a3e3afd848a9839a6@linux-foundation.org>
Subject: [patch 05/14] kasan: fix hw tags enablement when KUNIT tests are disabled
Message-Id: <20220415021337.BC941C385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
