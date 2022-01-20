Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 449B0C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:24:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237208AbiATVYg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:24:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377816AbiATVY3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:24:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD12C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:24:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E28D60C78
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:24:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CDDBC340E0;
        Thu, 20 Jan 2022 21:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642713867;
        bh=6d03HukqjYF6w/m5CWQgxaUWxto4NpNVTDJmosuwNg4=;
        h=Date:From:To:Subject:From;
        b=xHqibsPnSo7B0rfzvKSB6w1yxDZneRn8qYZaeHDCST9geGgs2cffit80JhrMmU7aL
         rwO/HKlyWHN0sFMWNplrMyw9sKztVHIid2jFtrgkruN64iuD4rsewT5Fcw9/8qgUxW
         4UtOuW5nH99OD7bNd58hvfll82TvrefxBB61vCuY=
Date:   Thu, 20 Jan 2022 13:24:27 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, cl@linux.com, dvyukov@google.com,
        elver@google.com, glider@google.com, iamjoonsoo.kim@lge.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, ryabinin.a.a@gmail.com, vbabka@suse.cz
Subject:  [merged]
 kasan-test-add-test-case-for-double-kmem_cache_destroy.patch removed from
 -mm tree
Message-ID: <20220120212427.vvO6fWCEQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: test: add test case for double-kmem_cache_destroy()
has been removed from the -mm tree.  Its filename was
     kasan-test-add-test-case-for-double-kmem_cache_destroy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: kasan: test: add test case for double-kmem_cache_destroy()

Add a test case for double-kmem_cache_destroy() detection.

Link: https://lkml.kernel.org/r/20211119142219.1519617-2-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/lib/test_kasan.c~kasan-test-add-test-case-for-double-kmem_cache_destroy
+++ a/lib/test_kasan.c
@@ -866,6 +866,16 @@ static void kmem_cache_invalid_free(stru
 	kmem_cache_destroy(cache);
 }
 
+static void kmem_cache_double_destroy(struct kunit *test)
+{
+	struct kmem_cache *cache;
+
+	cache = kmem_cache_create("test_cache", 200, 0, 0, NULL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, cache);
+	kmem_cache_destroy(cache);
+	KUNIT_EXPECT_KASAN_FAIL(test, kmem_cache_destroy(cache));
+}
+
 static void kasan_memchr(struct kunit *test)
 {
 	char *ptr;
@@ -1185,6 +1195,7 @@ static struct kunit_case kasan_kunit_tes
 	KUNIT_CASE(ksize_uaf),
 	KUNIT_CASE(kmem_cache_double_free),
 	KUNIT_CASE(kmem_cache_invalid_free),
+	KUNIT_CASE(kmem_cache_double_destroy),
 	KUNIT_CASE(kasan_memchr),
 	KUNIT_CASE(kasan_memcmp),
 	KUNIT_CASE(kasan_strings),
_

Patches currently in -mm which might be from elver@google.com are

lib-stackdepot-always-do-filter_irq_stacks-in-stack_depot_save.patch

