Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DB46C001DC
	for <mm-commits@archiver.kernel.org>; Sat, 24 Jun 2023 00:00:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231226AbjFXAAk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Jun 2023 20:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231840AbjFXAAV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jun 2023 20:00:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F88F2693
        for <mm-commits@vger.kernel.org>; Fri, 23 Jun 2023 17:00:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D7CF615F3
        for <mm-commits@vger.kernel.org>; Sat, 24 Jun 2023 00:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9097BC433C8;
        Sat, 24 Jun 2023 00:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687564819;
        bh=V+0B3ZXFzFaAD34AJHL1OOLYvOXKS999OMh8T+v2EA8=;
        h=Date:To:From:Subject:From;
        b=YlXdJwR6CKHHD8w9MRZbrME8M1Y9Q7d3NwSe1xDbA93BB8iVCiXzq9COhQYG4/4GI
         H6Lxvld4QBxIXSN/TnevdXyi7TFBsHmVyELk4NCDse87+4zMWWDXur7G32AfBaFwsO
         NLHlJ0cDA+qoAvcH7CZRxF6z1r/rgn8mBYEQgs5s=
Date:   Fri, 23 Jun 2023 17:00:19 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] i915-convert-shmem_sg_free_table-to-use-a-folio_batch.patch removed from -mm tree
Message-Id: <20230624000019.9097BC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: i915: convert shmem_sg_free_table() to use a folio_batch
has been removed from the -mm tree.  Its filename was
     i915-convert-shmem_sg_free_table-to-use-a-folio_batch.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: i915: convert shmem_sg_free_table() to use a folio_batch
Date: Wed, 21 Jun 2023 17:45:48 +0100

Remove a few hidden compound_head() calls by converting the returned page
to a folio once and using the folio APIs.  We also only increment the
refcount on the folio once instead of once for each page.  Ideally, we
would have a for_each_sgt_folio macro, but until then this will do.

Link: https://lkml.kernel.org/r/20230621164557.3510324-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/gem/i915_gem_shmem.c |   55 +++++++++++---------
 1 file changed, 31 insertions(+), 24 deletions(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c~i915-convert-shmem_sg_free_table-to-use-a-folio_batch
+++ a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
@@ -19,13 +19,13 @@
 #include "i915_trace.h"
 
 /*
- * Move pages to appropriate lru and release the pagevec, decrementing the
- * ref count of those pages.
+ * Move folios to appropriate lru and release the batch, decrementing the
+ * ref count of those folios.
  */
-static void check_release_pagevec(struct pagevec *pvec)
+static void check_release_folio_batch(struct folio_batch *fbatch)
 {
-	check_move_unevictable_pages(pvec);
-	__pagevec_release(pvec);
+	check_move_unevictable_folios(fbatch);
+	__folio_batch_release(fbatch);
 	cond_resched();
 }
 
@@ -33,24 +33,29 @@ void shmem_sg_free_table(struct sg_table
 			 bool dirty, bool backup)
 {
 	struct sgt_iter sgt_iter;
-	struct pagevec pvec;
+	struct folio_batch fbatch;
+	struct folio *last = NULL;
 	struct page *page;
 
 	mapping_clear_unevictable(mapping);
 
-	pagevec_init(&pvec);
+	folio_batch_init(&fbatch);
 	for_each_sgt_page(page, sgt_iter, st) {
-		if (dirty)
-			set_page_dirty(page);
+		struct folio *folio = page_folio(page);
 
+		if (folio == last)
+			continue;
+		last = folio;
+		if (dirty)
+			folio_mark_dirty(folio);
 		if (backup)
-			mark_page_accessed(page);
+			folio_mark_accessed(folio);
 
-		if (!pagevec_add(&pvec, page))
-			check_release_pagevec(&pvec);
+		if (!folio_batch_add(&fbatch, folio))
+			check_release_folio_batch(&fbatch);
 	}
-	if (pagevec_count(&pvec))
-		check_release_pagevec(&pvec);
+	if (fbatch.nr)
+		check_release_folio_batch(&fbatch);
 
 	sg_free_table(st);
 }
@@ -63,8 +68,7 @@ int shmem_sg_alloc_table(struct drm_i915
 	unsigned int page_count; /* restricted by sg_alloc_table */
 	unsigned long i;
 	struct scatterlist *sg;
-	struct page *page;
-	unsigned long last_pfn = 0;	/* suppress gcc warning */
+	unsigned long next_pfn = 0;	/* suppress gcc warning */
 	gfp_t noreclaim;
 	int ret;
 
@@ -95,6 +99,7 @@ int shmem_sg_alloc_table(struct drm_i915
 	sg = st->sgl;
 	st->nents = 0;
 	for (i = 0; i < page_count; i++) {
+		struct folio *folio;
 		const unsigned int shrink[] = {
 			I915_SHRINK_BOUND | I915_SHRINK_UNBOUND,
 			0,
@@ -103,12 +108,12 @@ int shmem_sg_alloc_table(struct drm_i915
 
 		do {
 			cond_resched();
-			page = shmem_read_mapping_page_gfp(mapping, i, gfp);
-			if (!IS_ERR(page))
+			folio = shmem_read_folio_gfp(mapping, i, gfp);
+			if (!IS_ERR(folio))
 				break;
 
 			if (!*s) {
-				ret = PTR_ERR(page);
+				ret = PTR_ERR(folio);
 				goto err_sg;
 			}
 
@@ -147,19 +152,21 @@ int shmem_sg_alloc_table(struct drm_i915
 
 		if (!i ||
 		    sg->length >= max_segment ||
-		    page_to_pfn(page) != last_pfn + 1) {
+		    folio_pfn(folio) != next_pfn) {
 			if (i)
 				sg = sg_next(sg);
 
 			st->nents++;
-			sg_set_page(sg, page, PAGE_SIZE, 0);
+			sg_set_folio(sg, folio, folio_size(folio), 0);
 		} else {
-			sg->length += PAGE_SIZE;
+			/* XXX: could overflow? */
+			sg->length += folio_size(folio);
 		}
-		last_pfn = page_to_pfn(page);
+		next_pfn = folio_pfn(folio) + folio_nr_pages(folio);
+		i += folio_nr_pages(folio) - 1;
 
 		/* Check that the i965g/gm workaround works. */
-		GEM_BUG_ON(gfp & __GFP_DMA32 && last_pfn >= 0x00100000UL);
+		GEM_BUG_ON(gfp & __GFP_DMA32 && next_pfn >= 0x00100000UL);
 	}
 	if (sg) /* loop terminated early; short sg table */
 		sg_mark_end(sg);
_

Patches currently in -mm which might be from willy@infradead.org are


