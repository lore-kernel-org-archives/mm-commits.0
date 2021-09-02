Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE732C433FE
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:53:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 986E5610A2
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:53:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347444AbhIBVy3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:54:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:47986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347806AbhIBVyS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:54:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B71161158;
        Thu,  2 Sep 2021 21:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619599;
        bh=4iThxtf6UxSJ54eOI+FLasiEG/cjFhofl0Dy7oziQUA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=fIgkNlkXQK1CRqh5mO/kPFFMv5TSHU6utVjWOjVnLa4Lx/s4Q3S7PO9aNYRqJU/M1
         ux4aYkz0tXLVkA5h7K+Xmn0JyB5ETatTyInKsfFSbOf6M+UFSiahiSRdJFNZbFOtjv
         Tkh/nJ+rN6xrJrv9y7nfgYBJZahuONucLOVmOiek=
Date:   Thu, 02 Sep 2021 14:53:18 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hannes@cmpxchg.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 063/212] mm: remove irqsave/restore locking from
 contexts with irqs enabled
Message-ID: <20210902215318.a1GBOex0s%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: remove irqsave/restore locking from contexts with irqs enabled

The page cache deletion paths all have interrupts enabled, so no need to
use irqsafe/irqrestore locking variants.

They used to have irqs disabled by the memcg lock added in commit
c4843a7593a9 ("memcg: add per cgroup dirty page accounting"), but that has
since been replaced by memcg taking the page lock instead, commit
0a31bc97c80c ("mm: memcontrol: rewrite uncharge AP").

Link: https://lkml.kernel.org/r/20210614211904.14420-1-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c  |   15 ++++++---------
 mm/truncate.c |    8 +++-----
 mm/vmscan.c   |    9 ++++-----
 3 files changed, 13 insertions(+), 19 deletions(-)

--- a/mm/filemap.c~mm-remove-irqsave-restore-locking-from-contexts-with-irqs-enabled
+++ a/mm/filemap.c
@@ -258,12 +258,11 @@ static void page_cache_free_page(struct
 void delete_from_page_cache(struct page *page)
 {
 	struct address_space *mapping = page_mapping(page);
-	unsigned long flags;
 
 	BUG_ON(!PageLocked(page));
-	xa_lock_irqsave(&mapping->i_pages, flags);
+	xa_lock_irq(&mapping->i_pages);
 	__delete_from_page_cache(page, NULL);
-	xa_unlock_irqrestore(&mapping->i_pages, flags);
+	xa_unlock_irq(&mapping->i_pages);
 
 	page_cache_free_page(mapping, page);
 }
@@ -335,19 +334,18 @@ void delete_from_page_cache_batch(struct
 				  struct pagevec *pvec)
 {
 	int i;
-	unsigned long flags;
 
 	if (!pagevec_count(pvec))
 		return;
 
-	xa_lock_irqsave(&mapping->i_pages, flags);
+	xa_lock_irq(&mapping->i_pages);
 	for (i = 0; i < pagevec_count(pvec); i++) {
 		trace_mm_filemap_delete_from_page_cache(pvec->pages[i]);
 
 		unaccount_page_cache_page(mapping, pvec->pages[i]);
 	}
 	page_cache_delete_batch(mapping, pvec);
-	xa_unlock_irqrestore(&mapping->i_pages, flags);
+	xa_unlock_irq(&mapping->i_pages);
 
 	for (i = 0; i < pagevec_count(pvec); i++)
 		page_cache_free_page(mapping, pvec->pages[i]);
@@ -821,7 +819,6 @@ void replace_page_cache_page(struct page
 	void (*freepage)(struct page *) = mapping->a_ops->freepage;
 	pgoff_t offset = old->index;
 	XA_STATE(xas, &mapping->i_pages, offset);
-	unsigned long flags;
 
 	VM_BUG_ON_PAGE(!PageLocked(old), old);
 	VM_BUG_ON_PAGE(!PageLocked(new), new);
@@ -833,7 +830,7 @@ void replace_page_cache_page(struct page
 
 	mem_cgroup_migrate(old, new);
 
-	xas_lock_irqsave(&xas, flags);
+	xas_lock_irq(&xas);
 	xas_store(&xas, new);
 
 	old->mapping = NULL;
@@ -846,7 +843,7 @@ void replace_page_cache_page(struct page
 		__dec_lruvec_page_state(old, NR_SHMEM);
 	if (PageSwapBacked(new))
 		__inc_lruvec_page_state(new, NR_SHMEM);
-	xas_unlock_irqrestore(&xas, flags);
+	xas_unlock_irq(&xas);
 	if (freepage)
 		freepage(old);
 	put_page(old);
--- a/mm/truncate.c~mm-remove-irqsave-restore-locking-from-contexts-with-irqs-enabled
+++ a/mm/truncate.c
@@ -560,21 +560,19 @@ void invalidate_mapping_pagevec(struct a
 static int
 invalidate_complete_page2(struct address_space *mapping, struct page *page)
 {
-	unsigned long flags;
-
 	if (page->mapping != mapping)
 		return 0;
 
 	if (page_has_private(page) && !try_to_release_page(page, GFP_KERNEL))
 		return 0;
 
-	xa_lock_irqsave(&mapping->i_pages, flags);
+	xa_lock_irq(&mapping->i_pages);
 	if (PageDirty(page))
 		goto failed;
 
 	BUG_ON(page_has_private(page));
 	__delete_from_page_cache(page, NULL);
-	xa_unlock_irqrestore(&mapping->i_pages, flags);
+	xa_unlock_irq(&mapping->i_pages);
 
 	if (mapping->a_ops->freepage)
 		mapping->a_ops->freepage(page);
@@ -582,7 +580,7 @@ invalidate_complete_page2(struct address
 	put_page(page);	/* pagecache ref */
 	return 1;
 failed:
-	xa_unlock_irqrestore(&mapping->i_pages, flags);
+	xa_unlock_irq(&mapping->i_pages);
 	return 0;
 }
 
--- a/mm/vmscan.c~mm-remove-irqsave-restore-locking-from-contexts-with-irqs-enabled
+++ a/mm/vmscan.c
@@ -1052,14 +1052,13 @@ static pageout_t pageout(struct page *pa
 static int __remove_mapping(struct address_space *mapping, struct page *page,
 			    bool reclaimed, struct mem_cgroup *target_memcg)
 {
-	unsigned long flags;
 	int refcount;
 	void *shadow = NULL;
 
 	BUG_ON(!PageLocked(page));
 	BUG_ON(mapping != page_mapping(page));
 
-	xa_lock_irqsave(&mapping->i_pages, flags);
+	xa_lock_irq(&mapping->i_pages);
 	/*
 	 * The non racy check for a busy page.
 	 *
@@ -1100,7 +1099,7 @@ static int __remove_mapping(struct addre
 		if (reclaimed && !mapping_exiting(mapping))
 			shadow = workingset_eviction(page, target_memcg);
 		__delete_from_swap_cache(page, swap, shadow);
-		xa_unlock_irqrestore(&mapping->i_pages, flags);
+		xa_unlock_irq(&mapping->i_pages);
 		put_swap_page(page, swap);
 	} else {
 		void (*freepage)(struct page *);
@@ -1126,7 +1125,7 @@ static int __remove_mapping(struct addre
 		    !mapping_exiting(mapping) && !dax_mapping(mapping))
 			shadow = workingset_eviction(page, target_memcg);
 		__delete_from_page_cache(page, shadow);
-		xa_unlock_irqrestore(&mapping->i_pages, flags);
+		xa_unlock_irq(&mapping->i_pages);
 
 		if (freepage != NULL)
 			freepage(page);
@@ -1135,7 +1134,7 @@ static int __remove_mapping(struct addre
 	return 1;
 
 cannot_free:
-	xa_unlock_irqrestore(&mapping->i_pages, flags);
+	xa_unlock_irq(&mapping->i_pages);
 	return 0;
 }
 
_
