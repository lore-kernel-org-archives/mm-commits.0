Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2151CEB64DC
	for <mm-commits@archiver.kernel.org>; Wed, 21 Jun 2023 20:14:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbjFUUO0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Jun 2023 16:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjFUUOY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Jun 2023 16:14:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B088719B7
        for <mm-commits@vger.kernel.org>; Wed, 21 Jun 2023 13:14:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45344616CD
        for <mm-commits@vger.kernel.org>; Wed, 21 Jun 2023 20:14:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9886CC433C8;
        Wed, 21 Jun 2023 20:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687378456;
        bh=dAEu1OSfrTU/SFvcjDXDK0vK745HKCU+5vQ/7rUz0J8=;
        h=Date:To:From:Subject:From;
        b=nDl3G9MsMYzv+lX16gMKfKCMVEGr86SQxmWgvYEs+5EbM8xmPluumYfbdfPp9ns5T
         6de1bZtMbwRXPSf960SyxW6FhH5glN+KPd1I7RiKmRpjb9a7Kfo1QcnOirSjp+7VSJ
         vXaf+bUzdfaIRBXZjoPuk21vHcdWfrgVx0SE0gTo=
Date:   Wed, 21 Jun 2023 13:14:15 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + i915-convert-shmem_sg_free_table-to-use-a-folio_batch.patch added to mm-unstable branch
Message-Id: <20230621201416.9886CC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: i915: convert shmem_sg_free_table() to use a folio_batch
has been added to the -mm mm-unstable branch.  Its filename is
     i915-convert-shmem_sg_free_table-to-use-a-folio_batch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/i915-convert-shmem_sg_free_table-to-use-a-folio_batch.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

afs-convert-pagevec-to-folio_batch-in-afs_extend_writeback.patch
mm-add-__folio_batch_release.patch
scatterlist-add-sg_set_folio.patch
i915-convert-shmem_sg_free_table-to-use-a-folio_batch.patch
drm-convert-drm_gem_put_pages-to-use-a-folio_batch.patch
mm-remove-check_move_unevictable_pages.patch
pagevec-rename-fbatch_count.patch
i915-convert-i915_gpu_error-to-use-a-folio_batch.patch
net-convert-sunrpc-from-pagevec-to-folio_batch.patch
mm-remove-struct-pagevec.patch
mm-rename-invalidate_mapping_pagevec-to-mapping_try_invalidate.patch
mm-remove-references-to-pagevec.patch
mm-remove-unnecessary-pagevec-includes.patch

