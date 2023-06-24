Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF742C0015E
	for <mm-commits@archiver.kernel.org>; Sat, 24 Jun 2023 00:00:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbjFXAAq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Jun 2023 20:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231841AbjFXAAW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jun 2023 20:00:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 544932706
        for <mm-commits@vger.kernel.org>; Fri, 23 Jun 2023 17:00:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3393061584
        for <mm-commits@vger.kernel.org>; Sat, 24 Jun 2023 00:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B512C433C0;
        Sat, 24 Jun 2023 00:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687564820;
        bh=MW56oCObuJhoPndthecovWlRL/x7p2dAd1mfkf7eIBI=;
        h=Date:To:From:Subject:From;
        b=nXNnzhM6JrqXO2yrulXs9IihP8ogrfdqOtrMF5XEzncTU5zWYLKmqYmsxfB+UifR9
         NECVUaEOM8JR74hvWNVIhpbVqtxzQbTNAaBCQqWbGb6FvbbhTZufN8aNo/qQYlQpq2
         iBSuQzXxlK1XZUkksV8L8oL42H98efn3FD03gy14=
Date:   Fri, 23 Jun 2023 17:00:20 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] drm-convert-drm_gem_put_pages-to-use-a-folio_batch.patch removed from -mm tree
Message-Id: <20230624000020.8B512C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: drm: convert drm_gem_put_pages() to use a folio_batch
has been removed from the -mm tree.  Its filename was
     drm-convert-drm_gem_put_pages-to-use-a-folio_batch.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


