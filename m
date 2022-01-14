Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F0D2C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:05:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbiANWFA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:05:00 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46620 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiANWE7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:04:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3958061FF0
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:04:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DBFEC36AE5;
        Fri, 14 Jan 2022 22:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642197898;
        bh=wqBPSDc1Kr3I6HWzV5gdSwjzmr5IF5sRGfh2s8Cn7ug=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=OCQ65dIBNAsYsgKAGcLhEOZGgKUvl41UUivXn2bzS6w+abV+K6dTFTpQf2MpKDDIf
         xNmBy+tBflDpHKOxer+YWOi4j6gjT9a+bU0MzaCzRKYFJv3glj2dCam+qhk12C3wnQ
         oDAnoc1XYrn6buudtMuLXirUFMMFQyh4Iu3PBPpE=
Date:   Fri, 14 Jan 2022 14:04:57 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@gmail.com, cl@linux.com,
        dvyukov@google.com, elver@google.com, glider@google.com,
        iamjoonsoo.kim@lge.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, ryabinin.a.a@gmail.com,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 038/146] kasan: test: add test case for
 double-kmem_cache_destroy()
Message-ID: <20220114220457.lZG7Lp8OI%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
