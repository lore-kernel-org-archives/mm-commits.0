Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 718EDC2D0E4
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 22:05:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EFE823B98
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 22:05:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbgLRWFO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Dec 2020 17:05:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:38866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726459AbgLRWFO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Dec 2020 17:05:14 -0500
Date:   Fri, 18 Dec 2020 14:04:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608329073;
        bh=t0cd2hZ+0IGmC6YZOXAl7iIEiMiy2IvhFrjitqSK3sE=;
        h=From:To:Subject:In-Reply-To:From;
        b=JD2nX6kf2s7J+qvRqRVc3K/A4yGGM1m/+FHdiIeXL5hQ1YV3hLIXxa3goCnz63117
         k5QWLx6fcQMJIBIfWoljggdOgMKC95ZxCNhx/WrynG4JPfV2l4GtBKXrV0cakyJJ/C
         BdOpPHEWOBh1iNNrkJ36+4mcizFJdI4sUfLboNcA=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, Branislav.Rankov@arm.com,
        catalin.marinas@arm.com, dvyukov@google.com, elver@google.com,
        eugenis@google.com, glider@google.com, gor@linux.ibm.com,
        kevin.brodsky@arm.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  [patch 57/78] kasan: introduce set_alloc_info
Message-ID: <20201218220432.y4LBUB0SU%akpm@linux-foundation.org>
In-Reply-To: <20201218140046.497484741326828e5b5d46ec@linux-foundation.org>
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
