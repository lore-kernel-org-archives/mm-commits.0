Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 100E8C4321E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:00:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbiLAAAm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:00:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbiLAAAZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:00:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C6F5ADD3
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:00:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E2B4B81D83
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F26AC433D6;
        Thu,  1 Dec 2022 00:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852822;
        bh=lCRaygbrmOch4YAnXPBDKM0fINRBdA9w+AYYgWhsxZQ=;
        h=Date:To:From:Subject:From;
        b=s+YPJjVmEY+yS5TxrpGjgz407QAaenkGkyN0kEPmZMMaK/9ycIh1w1aIbopLfpt5x
         ypiY2IBvuoDsl/Eb6LpfKt9Uwr8r+scg/GRFO97iYqJe4Dweq4L+0nT+PbAdZguqCb
         Jj0QcmmNhZWKCfv182gkqYw9dJzvs28nj3tlezPk=
Date:   Wed, 30 Nov 2022 16:00:21 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vincenzo.frascino@arm.com, vbabka@suse.cz, rientjes@google.com,
        elver@google.com, andreyknvl@gmail.com, anders.roxell@linaro.org,
        keescook@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mempool-do-not-use-ksize-for-poisoning.patch removed from -mm tree
Message-Id: <20221201000022.1F26AC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mempool: do not use ksize() for poisoning
has been removed from the -mm tree.  Its filename was
     mempool-do-not-use-ksize-for-poisoning.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: mempool: do not use ksize() for poisoning
Date: Fri, 28 Oct 2022 08:53:01 -0700

Nothing appears to be using ksize() within the kmalloc-backed mempools
except the mempool poisoning logic.  Use the actual pool size instead of
the ksize() to avoid needing any special handling of the memory as needed
by KASAN, UBSAN_BOUNDS, nor FORTIFY_SOURCE.

[vbabka@suse.cz: for slab mempools pool_data is not object size]
  Link: https://lkml.kernel.org/r/13c4bd6e-09d3-efce-43a5-5a99be8bc96b@suse.cz
Link: https://lkml.kernel.org/r/20221028154823.you.615-kees@kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
  Link: https://lore.kernel.org/lkml/f4fc52c4-7c18-1d76-0c7a-4058ea2486b9@suse.cz/
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Reported-by: Anders Roxell <anders.roxell@linaro.org>
  Link: https://lore.kernel.org/all/20221031105514.GB69385@mutt/
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempool.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/mm/mempool.c~mempool-do-not-use-ksize-for-poisoning
+++ a/mm/mempool.c
@@ -57,8 +57,10 @@ static void __check_element(mempool_t *p
 static void check_element(mempool_t *pool, void *element)
 {
 	/* Mempools backed by slab allocator */
-	if (pool->free == mempool_free_slab || pool->free == mempool_kfree) {
-		__check_element(pool, element, ksize(element));
+	if (pool->free == mempool_kfree) {
+		__check_element(pool, element, (size_t)pool->pool_data);
+	} else if (pool->free == mempool_free_slab) {
+		__check_element(pool, element, kmem_cache_size(pool->pool_data));
 	} else if (pool->free == mempool_free_pages) {
 		/* Mempools backed by page allocator */
 		int order = (int)(long)pool->pool_data;
@@ -80,8 +82,10 @@ static void __poison_element(void *eleme
 static void poison_element(mempool_t *pool, void *element)
 {
 	/* Mempools backed by slab allocator */
-	if (pool->alloc == mempool_alloc_slab || pool->alloc == mempool_kmalloc) {
-		__poison_element(element, ksize(element));
+	if (pool->alloc == mempool_kmalloc) {
+		__poison_element(element, (size_t)pool->pool_data);
+	} else if (pool->alloc == mempool_alloc_slab) {
+		__poison_element(element, kmem_cache_size(pool->pool_data));
 	} else if (pool->alloc == mempool_alloc_pages) {
 		/* Mempools backed by page allocator */
 		int order = (int)(long)pool->pool_data;
@@ -111,8 +115,10 @@ static __always_inline void kasan_poison
 
 static void kasan_unpoison_element(mempool_t *pool, void *element)
 {
-	if (pool->alloc == mempool_alloc_slab || pool->alloc == mempool_kmalloc)
-		kasan_unpoison_range(element, __ksize(element));
+	if (pool->alloc == mempool_kmalloc)
+		kasan_unpoison_range(element, (size_t)pool->pool_data);
+	else if (pool->alloc == mempool_alloc_slab)
+		kasan_unpoison_range(element, kmem_cache_size(pool->pool_data));
 	else if (pool->alloc == mempool_alloc_pages)
 		kasan_unpoison_pages(element, (unsigned long)pool->pool_data,
 				     false);
_

Patches currently in -mm which might be from keescook@chromium.org are


