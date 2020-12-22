Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0525C433E6
	for <mm-commits@archiver.kernel.org>; Tue, 22 Dec 2020 20:02:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0BEB20867
	for <mm-commits@archiver.kernel.org>; Tue, 22 Dec 2020 20:02:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725782AbgLVUCz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Dec 2020 15:02:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:46068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725913AbgLVUCz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Dec 2020 15:02:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D087B2313C;
        Tue, 22 Dec 2020 20:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608667359;
        bh=t0cd2hZ+0IGmC6YZOXAl7iIEiMiy2IvhFrjitqSK3sE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ScF+l/yplvCw8J6GYIozS3M10rS9uhPqH+MkBnZOJXbdpUrAo41PW58wqmYAYal9k
         NVPh5N+TuMNNneV70sSI8aReCnZNytoQrBGzwPdBHOntuzLCV4RwSrbBv81gFaAnJC
         BK1cQxDGV0YCK/EGVnWQJe77ng6rB/1gJ1dfnDYs=
Date:   Tue, 22 Dec 2020 12:02:38 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, Branislav.Rankov@arm.com,
        catalin.marinas@arm.com, dvyukov@google.com, elver@google.com,
        eugenis@google.com, glider@google.com, gor@linux.ibm.com,
        kevin.brodsky@arm.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  [patch 44/60] kasan: introduce set_alloc_info
Message-ID: <20201222200238.37xoLOd-R%akpm@linux-foundation.org>
In-Reply-To: <20201222115844.d30aaef7df6f5b120d3e0c3d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: introduce set_alloc_info

Add set_alloc_info() helper and move kasan_set_track() into it. This will
simplify the code for one of the upcoming changes.

No functional changes.

Link: https://lkml.kernel.org/r/b2393e8f1e311a70fc3aaa2196461b6acdee7d21.1606162397.git.andreyknvl@google.com
Link: https://linux-review.googlesource.com/id/I0316193cbb4ecc9b87b7c2eee0dd79f8ec908c1a
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Tested-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/common.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/kasan/common.c~kasan-introduce-set_alloc_info
+++ a/mm/kasan/common.c
@@ -323,6 +323,11 @@ bool kasan_slab_free(struct kmem_cache *
 	return __kasan_slab_free(cache, object, ip, true);
 }
 
+static void set_alloc_info(struct kmem_cache *cache, void *object, gfp_t flags)
+{
+	kasan_set_track(&kasan_get_alloc_meta(cache, object)->alloc_track, flags);
+}
+
 static void *__kasan_kmalloc(struct kmem_cache *cache, const void *object,
 				size_t size, gfp_t flags, bool keep_tag)
 {
@@ -350,7 +355,7 @@ static void *__kasan_kmalloc(struct kmem
 		     KASAN_KMALLOC_REDZONE);
 
 	if (cache->flags & SLAB_KASAN)
-		kasan_set_track(&kasan_get_alloc_meta(cache, object)->alloc_track, flags);
+		set_alloc_info(cache, (void *)object, flags);
 
 	return set_tag(object, tag);
 }
_
