Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41E3AC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:43:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234028AbiCYWpG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234027AbiCYWoi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:44:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9510820C2FD
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:43:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE98461582
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:43:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D90C34110;
        Fri, 25 Mar 2022 22:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248181;
        bh=JZUmsjbdtk/BgQXztgFH5asZoYgTs7MfzGjugl9UIfI=;
        h=Date:To:From:Subject:From;
        b=O0xj13bvTwfDaI5tRcPFvMsw1dxpdGuH5hwUuuAFLRyKxq/iFG2r42lQWvKxxmjxX
         JspcE1NhnJ3zpJ59o/uX5YolUx1zYWko5B/ynIY5PD51wvykdOUzPbWaxv1t+WY2Zz
         0CTFVPU8gil0Bfrr6JY9X+Tw5M550cgzoagoHM0E=
Date:   Fri, 25 Mar 2022 15:43:00 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kasan-move-and-hide-kasan_save_enable-restore_multi_shot.patch removed from -mm tree
Message-Id: <20220325224301.52D90C34110@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: move and hide kasan_save_enable/restore_multi_shot
has been removed from the -mm tree.  Its filename was
     kasan-move-and-hide-kasan_save_enable-restore_multi_shot.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: move and hide kasan_save_enable/restore_multi_shot

- Move kasan_save_enable/restore_multi_shot() declarations to
  mm/kasan/kasan.h, as there is no need for them to be visible outside
  of KASAN implementation.

- Only define and export these functions when KASAN tests are enabled.

- Move their definitions closer to other test-related code in report.c.

Link: https://lkml.kernel.org/r/6ba637333b78447f027d775f2d55ab1a40f63c99.1646237226.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |    4 ----
 mm/kasan/kasan.h      |    7 +++++++
 mm/kasan/report.c     |   30 +++++++++++++++++-------------
 3 files changed, 24 insertions(+), 17 deletions(-)

--- a/include/linux/kasan.h~kasan-move-and-hide-kasan_save_enable-restore_multi_shot
+++ a/include/linux/kasan.h
@@ -267,10 +267,6 @@ static __always_inline bool kasan_check_
 	return true;
 }
 
-
-bool kasan_save_enable_multi_shot(void);
-void kasan_restore_multi_shot(bool enabled);
-
 #else /* CONFIG_KASAN */
 
 static inline slab_flags_t kasan_never_merge(void)
--- a/mm/kasan/kasan.h~kasan-move-and-hide-kasan_save_enable-restore_multi_shot
+++ a/mm/kasan/kasan.h
@@ -492,6 +492,13 @@ static inline bool kasan_arch_is_ready(v
 #error kasan_arch_is_ready only works in KASAN generic outline mode!
 #endif
 
+#if IS_ENABLED(CONFIG_KASAN_KUNIT_TEST) || IS_ENABLED(CONFIG_KASAN_MODULE_TEST)
+
+bool kasan_save_enable_multi_shot(void);
+void kasan_restore_multi_shot(bool enabled);
+
+#endif
+
 /*
  * Exported functions for interfaces called from assembly or from generated
  * code. Declarations here to avoid warning about missing declarations.
--- a/mm/kasan/report.c~kasan-move-and-hide-kasan_save_enable-restore_multi_shot
+++ a/mm/kasan/report.c
@@ -64,19 +64,6 @@ static int __init early_kasan_fault(char
 }
 early_param("kasan.fault", early_kasan_fault);
 
-bool kasan_save_enable_multi_shot(void)
-{
-	return test_and_set_bit(KASAN_BIT_MULTI_SHOT, &kasan_flags);
-}
-EXPORT_SYMBOL_GPL(kasan_save_enable_multi_shot);
-
-void kasan_restore_multi_shot(bool enabled)
-{
-	if (!enabled)
-		clear_bit(KASAN_BIT_MULTI_SHOT, &kasan_flags);
-}
-EXPORT_SYMBOL_GPL(kasan_restore_multi_shot);
-
 static int __init kasan_set_multi_shot(char *str)
 {
 	set_bit(KASAN_BIT_MULTI_SHOT, &kasan_flags);
@@ -109,6 +96,23 @@ static bool report_enabled(void)
 	return !test_and_set_bit(KASAN_BIT_REPORTED, &kasan_flags);
 }
 
+#if IS_ENABLED(CONFIG_KASAN_KUNIT_TEST) || IS_ENABLED(CONFIG_KASAN_MODULE_TEST)
+
+bool kasan_save_enable_multi_shot(void)
+{
+	return test_and_set_bit(KASAN_BIT_MULTI_SHOT, &kasan_flags);
+}
+EXPORT_SYMBOL_GPL(kasan_save_enable_multi_shot);
+
+void kasan_restore_multi_shot(bool enabled)
+{
+	if (!enabled)
+		clear_bit(KASAN_BIT_MULTI_SHOT, &kasan_flags);
+}
+EXPORT_SYMBOL_GPL(kasan_restore_multi_shot);
+
+#endif
+
 #if IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
 static void update_kunit_status(bool sync)
 {
_

Patches currently in -mm which might be from andreyknvl@google.com are

stacktrace-add-interface-based-on-shadow-call-stack.patch
arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks.patch
arm64-implement-stack_trace_save_shadow.patch
kasan-use-stack_trace_save_shadow.patch

