Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF2FFC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:43:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234010AbiCYWor (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:44:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233967AbiCYWo0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:44:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2360820C1B9
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:42:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1438B82A1C
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:42:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7258DC340ED;
        Fri, 25 Mar 2022 22:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248168;
        bh=0Icc8d/l4iKR2nZHsE85s9ffNPD9GkylXe90e2y+Yf8=;
        h=Date:To:From:Subject:From;
        b=yjdbo6yAW5zn1wJgQi2/dQ65Zf6G1zFzMr+bxX0SaRhI6Lh0mg8FS0QRR2KOvKoUK
         eo/NEpQCdm99zY9tM+KkeSOFz1NBs8q9J1os0rrwYMGAjWI3MHhzKb04asc6xIjJ89
         88J4QPIDDc0L46rDAReEoJfLdjM/Lclwg2R4gY00=
Date:   Fri, 25 Mar 2022 15:42:47 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kasan-check-config_kasan_kunit_test-instead-of-config_kunit.patch removed from -mm tree
Message-Id: <20220325224248.7258DC340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: check CONFIG_KASAN_KUNIT_TEST instead of CONFIG_KUNIT
has been removed from the -mm tree.  Its filename was
     kasan-check-config_kasan_kunit_test-instead-of-config_kunit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: check CONFIG_KASAN_KUNIT_TEST instead of CONFIG_KUNIT

Check the more specific CONFIG_KASAN_KUNIT_TEST config option when
defining things related to KUnit-compatible KASAN tests instead of
CONFIG_KUNIT.

Also put the kunit_kasan_status definition next to the definitons of other
KASAN-related structs.

Link: https://lkml.kernel.org/r/223592d38d2a601a160a3b2b3d5a9f9090350e62.1646237226.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.h  |   18 ++++++++----------
 mm/kasan/report.c |    2 +-
 2 files changed, 9 insertions(+), 11 deletions(-)

--- a/mm/kasan/kasan.h~kasan-check-config_kasan_kunit_test-instead-of-config_kunit
+++ a/mm/kasan/kasan.h
@@ -7,16 +7,6 @@
 #include <linux/kfence.h>
 #include <linux/stackdepot.h>
 
-#if IS_ENABLED(CONFIG_KUNIT)
-
-/* Used in KUnit-compatible KASAN tests. */
-struct kunit_kasan_status {
-	bool report_found;
-	bool sync_fault;
-};
-
-#endif
-
 #ifdef CONFIG_KASAN_HW_TAGS
 
 #include <linux/static_key.h>
@@ -224,6 +214,14 @@ struct kasan_free_meta {
 #endif
 };
 
+#if IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
+/* Used in KUnit-compatible KASAN tests. */
+struct kunit_kasan_status {
+	bool report_found;
+	bool sync_fault;
+};
+#endif
+
 struct kasan_alloc_meta *kasan_get_alloc_meta(struct kmem_cache *cache,
 						const void *object);
 #ifdef CONFIG_KASAN_GENERIC
--- a/mm/kasan/report.c~kasan-check-config_kasan_kunit_test-instead-of-config_kunit
+++ a/mm/kasan/report.c
@@ -356,7 +356,7 @@ static bool report_enabled(void)
 	return !test_and_set_bit(KASAN_BIT_REPORTED, &kasan_flags);
 }
 
-#if IS_ENABLED(CONFIG_KUNIT)
+#if IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
 static void update_kunit_status(bool sync)
 {
 	struct kunit *test;
_

Patches currently in -mm which might be from andreyknvl@google.com are

stacktrace-add-interface-based-on-shadow-call-stack.patch
arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks.patch
arm64-implement-stack_trace_save_shadow.patch
kasan-use-stack_trace_save_shadow.patch

