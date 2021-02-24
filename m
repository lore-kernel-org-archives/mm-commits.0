Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 768A3C433E6
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:07:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3208064EC4
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:07:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235366AbhBXUHz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:07:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:59436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235175AbhBXUHU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:07:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91DAD64F0D;
        Wed, 24 Feb 2021 20:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197160;
        bh=A0KJ2LuKmPONcOAAtAP2Ry7eDDPAfY7KJPBJ9DDrR1g=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=xvq9jup1WpRfys/tZaV7HgIK1E04kr8ZRaD0Pm1xipTJUNL5KiCkeyf0Y2kE3rXi6
         hY0yDQ4iQeIGAQ5ZbJNQT/1ePSI0js4Xijb6YdSNq9/lLnlfVQXZzKm/kSCOSugIcs
         MJ9jgDhe5PTRIZjiNY1WoMFVcGIqsg/bvRC3dDgE=
Date:   Wed, 24 Feb 2021 12:05:59 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, Branislav.Rankov@arm.com,
        catalin.marinas@arm.com, dvyukov@google.com, elver@google.com,
        eugenis@google.com, glider@google.com, kevin.brodsky@arm.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, pcc@google.com,
        torvalds@linux-foundation.org, vincenzo.frascino@arm.com,
        will.deacon@arm.com
Subject:  [patch 099/173] kasan: add a test for
 kmem_cache_alloc/free_bulk
Message-ID: <20210224200559.eIGHFvuuh%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: add a test for kmem_cache_alloc/free_bulk

Add a test for kmem_cache_alloc/free_bulk to make sure there are no
false-positives when these functions are used.

Link: https://linux-review.googlesource.com/id/I2a8bf797aecf81baeac61380c567308f319e263d
Link: https://lkml.kernel.org/r/418122ebe4600771ac81e9ca6eab6740cf8dcfa1.1610733117.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |   38 +++++++++++++++++++++++++++++++++-----
 1 file changed, 33 insertions(+), 5 deletions(-)

--- a/lib/test_kasan.c~kasan-add-a-test-for-kmem_cache_alloc-free_bulk
+++ a/lib/test_kasan.c
@@ -479,10 +479,11 @@ static void kmem_cache_oob(struct kunit
 {
 	char *p;
 	size_t size = 200;
-	struct kmem_cache *cache = kmem_cache_create("test_cache",
-						size, 0,
-						0, NULL);
+	struct kmem_cache *cache;
+
+	cache = kmem_cache_create("test_cache", size, 0, 0, NULL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, cache);
+
 	p = kmem_cache_alloc(cache, GFP_KERNEL);
 	if (!p) {
 		kunit_err(test, "Allocation failed: %s\n", __func__);
@@ -491,11 +492,12 @@ static void kmem_cache_oob(struct kunit
 	}
 
 	KUNIT_EXPECT_KASAN_FAIL(test, *p = p[size + OOB_TAG_OFF]);
+
 	kmem_cache_free(cache, p);
 	kmem_cache_destroy(cache);
 }
 
-static void memcg_accounted_kmem_cache(struct kunit *test)
+static void kmem_cache_accounted(struct kunit *test)
 {
 	int i;
 	char *p;
@@ -522,6 +524,31 @@ free_cache:
 	kmem_cache_destroy(cache);
 }
 
+static void kmem_cache_bulk(struct kunit *test)
+{
+	struct kmem_cache *cache;
+	size_t size = 200;
+	char *p[10];
+	bool ret;
+	int i;
+
+	cache = kmem_cache_create("test_cache", size, 0, 0, NULL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, cache);
+
+	ret = kmem_cache_alloc_bulk(cache, GFP_KERNEL, ARRAY_SIZE(p), (void **)&p);
+	if (!ret) {
+		kunit_err(test, "Allocation failed: %s\n", __func__);
+		kmem_cache_destroy(cache);
+		return;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(p); i++)
+		p[i][0] = p[i][size - 1] = 42;
+
+	kmem_cache_free_bulk(cache, ARRAY_SIZE(p), (void **)&p);
+	kmem_cache_destroy(cache);
+}
+
 static char global_array[10];
 
 static void kasan_global_oob(struct kunit *test)
@@ -961,7 +988,8 @@ static struct kunit_case kasan_kunit_tes
 	KUNIT_CASE(kfree_via_page),
 	KUNIT_CASE(kfree_via_phys),
 	KUNIT_CASE(kmem_cache_oob),
-	KUNIT_CASE(memcg_accounted_kmem_cache),
+	KUNIT_CASE(kmem_cache_accounted),
+	KUNIT_CASE(kmem_cache_bulk),
 	KUNIT_CASE(kasan_global_oob),
 	KUNIT_CASE(kasan_stack_oob),
 	KUNIT_CASE(kasan_alloca_oob_left),
_
