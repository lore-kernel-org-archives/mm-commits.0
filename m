Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E04FC433E6
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:22:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6317F64F30
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:22:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbhBZBWT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:22:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:53344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230010AbhBZBVF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:21:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A2A364EE4;
        Fri, 26 Feb 2021 01:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302425;
        bh=rmXR++pRs00CfbhKXr47y1G7u3aOztuwanuB78Nzi78=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ljyL5ew92BgP+rXehPwOD203fZug68X98PKY0VUuogztYCKQSW9CV6YIt6MQ45jgL
         +TDz6I+sr6VnI5i8K7rHq9+stmHQ2NDLRUhvQOFWLel+gf1WWyjslyEElpa6SgKlDn
         W5batGJgY5IHKqtQErn3yOlPfGVaCTeMoXZUEduo=
Date:   Thu, 25 Feb 2021 17:20:23 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, Branislav.Rankov@arm.com,
        catalin.marinas@arm.com, dvyukov@google.com, elver@google.com,
        eugenis@google.com, glider@google.com, kevin.brodsky@arm.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, pcc@google.com,
        torvalds@linux-foundation.org, vincenzo.frascino@arm.com,
        will.deacon@arm.com
Subject:  [patch 077/118] kasan, mm: optimize krealloc poisoning
Message-ID: <20210226012023.nlDQicTs8%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan, mm: optimize krealloc poisoning

Currently, krealloc() always calls ksize(), which unpoisons the whole
object including the redzone.  This is inefficient, as kasan_krealloc()
repoisons the redzone for objects that fit into the same buffer.

This patch changes krealloc() instrumentation to use uninstrumented
__ksize() that doesn't unpoison the memory.  Instead, kasan_kreallos() is
changed to unpoison the memory excluding the redzone.

For objects that don't fit into the old allocation, this patch disables
KASAN accessibility checks when copying memory into a new object instead
of unpoisoning it.

Link: https://lkml.kernel.org/r/9bef90327c9cb109d736c40115684fd32f49e6b0.1612546384.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
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

 mm/kasan/common.c |   12 ++++++++++--
 mm/slab_common.c  |   20 ++++++++++++++------
 2 files changed, 24 insertions(+), 8 deletions(-)

--- a/mm/kasan/common.c~kasan-mm-optimize-krealloc-poisoning
+++ a/mm/kasan/common.c
@@ -476,7 +476,7 @@ static void *____kasan_kmalloc(struct km
 
 	/*
 	 * The object has already been unpoisoned by kasan_slab_alloc() for
-	 * kmalloc() or by ksize() for krealloc().
+	 * kmalloc() or by kasan_krealloc() for krealloc().
 	 */
 
 	/*
@@ -526,7 +526,7 @@ void * __must_check __kasan_kmalloc_larg
 
 	/*
 	 * The object has already been unpoisoned by kasan_alloc_pages() for
-	 * alloc_pages() or by ksize() for krealloc().
+	 * alloc_pages() or by kasan_krealloc() for krealloc().
 	 */
 
 	/*
@@ -554,8 +554,16 @@ void * __must_check __kasan_krealloc(con
 	if (unlikely(object == ZERO_SIZE_PTR))
 		return (void *)object;
 
+	/*
+	 * Unpoison the object's data.
+	 * Part of it might already have been unpoisoned, but it's unknown
+	 * how big that part is.
+	 */
+	kasan_unpoison(object, size);
+
 	page = virt_to_head_page(object);
 
+	/* Piggy-back on kmalloc() instrumentation to poison the redzone. */
 	if (unlikely(!PageSlab(page)))
 		return __kasan_kmalloc_large(object, size, flags);
 	else
--- a/mm/slab_common.c~kasan-mm-optimize-krealloc-poisoning
+++ a/mm/slab_common.c
@@ -1136,19 +1136,27 @@ static __always_inline void *__do_kreall
 	void *ret;
 	size_t ks;
 
-	if (likely(!ZERO_OR_NULL_PTR(p)) && !kasan_check_byte(p))
-		return NULL;
-
-	ks = ksize(p);
+	/* Don't use instrumented ksize to allow precise KASAN poisoning. */
+	if (likely(!ZERO_OR_NULL_PTR(p))) {
+		if (!kasan_check_byte(p))
+			return NULL;
+		ks = kfence_ksize(p) ?: __ksize(p);
+	} else
+		ks = 0;
 
+	/* If the object still fits, repoison it precisely. */
 	if (ks >= new_size) {
 		p = kasan_krealloc((void *)p, new_size, flags);
 		return (void *)p;
 	}
 
 	ret = kmalloc_track_caller(new_size, flags);
-	if (ret && p)
-		memcpy(ret, p, ks);
+	if (ret && p) {
+		/* Disable KASAN checks as the object's redzone is accessed. */
+		kasan_disable_current();
+		memcpy(ret, kasan_reset_tag(p), ks);
+		kasan_enable_current();
+	}
 
 	return ret;
 }
_
