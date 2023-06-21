Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AD11EB64D7
	for <mm-commits@archiver.kernel.org>; Wed, 21 Jun 2023 20:14:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbjFUUOa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Jun 2023 16:14:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbjFUUOZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Jun 2023 16:14:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C5C61BCD
        for <mm-commits@vger.kernel.org>; Wed, 21 Jun 2023 13:14:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E05E616A2
        for <mm-commits@vger.kernel.org>; Wed, 21 Jun 2023 20:14:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67A4CC433C9;
        Wed, 21 Jun 2023 20:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687378458;
        bh=CMKMpN/A7iUY9dMmiYp4uXTSPGJ2StsobplvUsfi2cY=;
        h=Date:To:From:Subject:From;
        b=l72VAX2CurK2pI+tKmFmzUrSMb93XFxS6gK9zsalmk4s7HmKEYlXYLL/Hca6jzSFn
         EoV9ccRmV5qVbXLMyMmIsOPXWpEV+SgUaqsbv9qSTcbCKe1nnieOJDWuVa7H5ITeOr
         0wBWwE4ECAfZ8k1h368Ag6YEGNNtPMjDhaPSqtb4=
Date:   Wed, 21 Jun 2023 13:14:17 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + drm-convert-drm_gem_put_pages-to-use-a-folio_batch.patch added to mm-unstable branch
Message-Id: <20230621201418.67A4CC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: drm: convert drm_gem_put_pages() to use a folio_batch
has been added to the -mm mm-unstable branch.  Its filename is
     drm-convert-drm_gem_put_pages-to-use-a-folio_batch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drm-convert-drm_gem_put_pages-to-use-a-folio_batch.patch

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
Subject: drm: convert drm_gem_put_pages() to use a folio_batch
Date: Wed, 21 Jun 2023 17:45:49 +0100

Remove a few hidden compound_head() calls by converting the returned page
to a folio once and using the folio APIs.

Link: https://lkml.kernel.org/r/20230621164557.3510324-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_gem.c |   68 ++++++++++++++++++++----------------
 1 file changed, 39 insertions(+), 29 deletions(-)

--- a/drivers/gpu/drm/drm_gem.c~drm-convert-drm_gem_put_pages-to-use-a-folio_batch
+++ a/drivers/gpu/drm/drm_gem.c
@@ -496,13 +496,13 @@ int drm_gem_create_mmap_offset(struct dr
 EXPORT_SYMBOL(drm_gem_create_mmap_offset);
 
 /*
- * Move pages to appropriate lru and release the pagevec, decrementing the
- * ref count of those pages.
+ * Move folios to appropriate lru and release the folios, decrementing the
+ * ref count of those folios.
  */
-static void drm_gem_check_release_pagevec(struct pagevec *pvec)
+static void drm_gem_check_release_batch(struct folio_batch *fbatch)
 {
-	check_move_unevictable_pages(pvec);
-	__pagevec_release(pvec);
+	check_move_unevictable_folios(fbatch);
+	__folio_batch_release(fbatch);
 	cond_resched();
 }
 
@@ -534,10 +534,10 @@ static void drm_gem_check_release_pageve
 struct page **drm_gem_get_pages(struct drm_gem_object *obj)
 {
 	struct address_space *mapping;
-	struct page *p, **pages;
-	struct pagevec pvec;
-	int i, npages;
-
+	struct page **pages;
+	struct folio *folio;
+	struct folio_batch fbatch;
+	int i, j, npages;
 
 	if (WARN_ON(!obj->filp))
 		return ERR_PTR(-EINVAL);
@@ -559,11 +559,14 @@ struct page **drm_gem_get_pages(struct d
 
 	mapping_set_unevictable(mapping);
 
-	for (i = 0; i < npages; i++) {
-		p = shmem_read_mapping_page(mapping, i);
-		if (IS_ERR(p))
+	i = 0;
+	while (i < npages) {
+		folio = shmem_read_folio_gfp(mapping, i,
+				mapping_gfp_mask(mapping));
+		if (IS_ERR(folio))
 			goto fail;
-		pages[i] = p;
+		for (j = 0; j < folio_nr_pages(folio); j++, i++)
+			pages[i] = folio_file_page(folio, i);
 
 		/* Make sure shmem keeps __GFP_DMA32 allocated pages in the
 		 * correct region during swapin. Note that this requires
@@ -571,23 +574,26 @@ struct page **drm_gem_get_pages(struct d
 		 * so shmem can relocate pages during swapin if required.
 		 */
 		BUG_ON(mapping_gfp_constraint(mapping, __GFP_DMA32) &&
-				(page_to_pfn(p) >= 0x00100000UL));
+				(folio_pfn(folio) >= 0x00100000UL));
 	}
 
 	return pages;
 
 fail:
 	mapping_clear_unevictable(mapping);
-	pagevec_init(&pvec);
-	while (i--) {
-		if (!pagevec_add(&pvec, pages[i]))
-			drm_gem_check_release_pagevec(&pvec);
+	folio_batch_init(&fbatch);
+	j = 0;
+	while (j < i) {
+		struct folio *f = page_folio(pages[j]);
+		if (!folio_batch_add(&fbatch, f))
+			drm_gem_check_release_batch(&fbatch);
+		j += folio_nr_pages(f);
 	}
-	if (pagevec_count(&pvec))
-		drm_gem_check_release_pagevec(&pvec);
+	if (fbatch.nr)
+		drm_gem_check_release_batch(&fbatch);
 
 	kvfree(pages);
-	return ERR_CAST(p);
+	return ERR_CAST(folio);
 }
 EXPORT_SYMBOL(drm_gem_get_pages);
 
@@ -603,7 +609,7 @@ void drm_gem_put_pages(struct drm_gem_ob
 {
 	int i, npages;
 	struct address_space *mapping;
-	struct pagevec pvec;
+	struct folio_batch fbatch;
 
 	mapping = file_inode(obj->filp)->i_mapping;
 	mapping_clear_unevictable(mapping);
@@ -616,23 +622,27 @@ void drm_gem_put_pages(struct drm_gem_ob
 
 	npages = obj->size >> PAGE_SHIFT;
 
-	pagevec_init(&pvec);
+	folio_batch_init(&fbatch);
 	for (i = 0; i < npages; i++) {
+		struct folio *folio;
+
 		if (!pages[i])
 			continue;
+		folio = page_folio(pages[i]);
 
 		if (dirty)
-			set_page_dirty(pages[i]);
+			folio_mark_dirty(folio);
 
 		if (accessed)
-			mark_page_accessed(pages[i]);
+			folio_mark_accessed(folio);
 
 		/* Undo the reference we took when populating the table */
-		if (!pagevec_add(&pvec, pages[i]))
-			drm_gem_check_release_pagevec(&pvec);
+		if (!folio_batch_add(&fbatch, folio))
+			drm_gem_check_release_batch(&fbatch);
+		i += folio_nr_pages(folio) - 1;
 	}
-	if (pagevec_count(&pvec))
-		drm_gem_check_release_pagevec(&pvec);
+	if (folio_batch_count(&fbatch))
+		drm_gem_check_release_batch(&fbatch);
 
 	kvfree(pages);
 }
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

