Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69CCDC2B9F4
	for <mm-commits@archiver.kernel.org>; Mon, 14 Jun 2021 22:00:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54C62611AB
	for <mm-commits@archiver.kernel.org>; Mon, 14 Jun 2021 22:00:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbhFNWDA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Jun 2021 18:03:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:38552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230230AbhFNWC6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Jun 2021 18:02:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72245611AB;
        Mon, 14 Jun 2021 22:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623708041;
        bh=Qs99sTZhX058DYHKo5h9Cbdxh0Sz2SL+KVx0thHWZp0=;
        h=Date:From:To:Subject:From;
        b=cOgllGSt/OOYU8bHoNuKGgn+k4dzSV4MLzCXy9O40mD/RwSaHm+2OCDtGA1TVnjS4
         cXp9jWIfZ3DgXvm2c37wVugMTltm2KXz9CgWn+sXqDT+QayrOTtpmsYIgwhJzvAcrm
         Zpd2tI44Ce7E13Jw7uciNJMSM/9ssiLGY1NvjFso=
Date:   Mon, 14 Jun 2021 15:00:40 -0700
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, mm-commits@vger.kernel.org
Subject:  +
 mm-remove-irqsave-restore-locking-from-contexts-with-irqs-enabled.patch
 added to -mm tree
Message-ID: <20210614220040.b5gS07NaD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove irqsave/restore locking from contexts with irqs enabled
has been added to the -mm tree.  Its filename is
     mm-remove-irqsave-restore-locking-from-contexts-with-irqs-enabled.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-remove-irqsave-restore-locking-from-contexts-with-irqs-enabled.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-irqsave-restore-locking-from-contexts-with-irqs-enabled.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -1049,14 +1049,13 @@ static pageout_t pageout(struct page *pa
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
@@ -1097,7 +1096,7 @@ static int __remove_mapping(struct addre
 		if (reclaimed && !mapping_exiting(mapping))
 			shadow = workingset_eviction(page, target_memcg);
 		__delete_from_swap_cache(page, swap, shadow);
-		xa_unlock_irqrestore(&mapping->i_pages, flags);
+		xa_unlock_irq(&mapping->i_pages);
 		put_swap_page(page, swap);
 	} else {
 		void (*freepage)(struct page *);
@@ -1123,7 +1122,7 @@ static int __remove_mapping(struct addre
 		    !mapping_exiting(mapping) && !dax_mapping(mapping))
 			shadow = workingset_eviction(page, target_memcg);
 		__delete_from_page_cache(page, shadow);
-		xa_unlock_irqrestore(&mapping->i_pages, flags);
+		xa_unlock_irq(&mapping->i_pages);
 
 		if (freepage != NULL)
 			freepage(page);
@@ -1132,7 +1131,7 @@ static int __remove_mapping(struct addre
 	return 1;
 
 cannot_free:
-	xa_unlock_irqrestore(&mapping->i_pages, flags);
+	xa_unlock_irq(&mapping->i_pages);
 	return 0;
 }
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-remove-irqsave-restore-locking-from-contexts-with-irqs-enabled.patch
fs-drop_caches-fix-skipping-over-shadow-cache-inodes.patch
fs-inode-count-invalidated-shadow-pages-in-pginodesteal.patch
vfs-keep-inodes-with-page-cache-off-the-inode-shrinker-lru.patch

