Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4F80C433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:05:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbiJCVFb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiJCVEs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:04:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E462EA1A0
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:04:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D79A3610E7
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:04:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33EF0C433D6;
        Mon,  3 Oct 2022 21:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831085;
        bh=D4M6v5q/pe62h+UEokvvDGDVCvk9uwdDEQgMojHUlOI=;
        h=Date:To:From:Subject:From;
        b=yHscRVBrzawnNsNTLsnNMaDpN4VVE0XfUNMxOVfkxCHwLYzg8gTDnyI37bYHQN9zh
         jBAEUAJxxdvYCyuJWYgDGSudz6gNlEe9Q/pXRN/daFlKRcmwAmYjovKY72obmPKrEO
         RChYIWSkk5OEywp6jl9YmjVzI+q8h8h2M/ZHVaoA=
Date:   Mon, 03 Oct 2022 14:04:44 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] shmem-convert-shmem_replace_page-to-use-folios-throughout.patch removed from -mm tree
Message-Id: <20221003210445.33EF0C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: shmem: convert shmem_replace_page() to use folios throughout
has been removed from the -mm tree.  Its filename was
     shmem-convert-shmem_replace_page-to-use-folios-throughout.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: shmem: convert shmem_replace_page() to use folios throughout
Date: Fri, 2 Sep 2022 20:46:04 +0100

Introduce folio_set_swap_entry() to abstract how both folio->private and
swp_entry_t work.  Use swap_address_space() directly instead of
indirecting through folio_mapping().  Include an assertion that the old
folio is not large as we only allocate a single-page folio to replace it. 
Use folio_put_refs() instead of calling folio_put() twice.

Link: https://lkml.kernel.org/r/20220902194653.1739778-9-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    5 ++
 mm/shmem.c           |   69 +++++++++++++++++++----------------------
 2 files changed, 38 insertions(+), 36 deletions(-)

--- a/include/linux/swap.h~shmem-convert-shmem_replace_page-to-use-folios-throughout
+++ a/include/linux/swap.h
@@ -355,6 +355,11 @@ static inline swp_entry_t folio_swap_ent
 	return entry;
 }
 
+static inline void folio_set_swap_entry(struct folio *folio, swp_entry_t entry)
+{
+	folio->private = (void *)entry.val;
+}
+
 /* linux/mm/workingset.c */
 void workingset_age_nonresident(struct lruvec *lruvec, unsigned long nr_pages);
 void *workingset_eviction(struct folio *folio, struct mem_cgroup *target_memcg);
--- a/mm/shmem.c~shmem-convert-shmem_replace_page-to-use-folios-throughout
+++ a/mm/shmem.c
@@ -1560,12 +1560,6 @@ static struct folio *shmem_alloc_folio(g
 	return folio;
 }
 
-static struct page *shmem_alloc_page(gfp_t gfp,
-			struct shmem_inode_info *info, pgoff_t index)
-{
-	return &shmem_alloc_folio(gfp, info, index)->page;
-}
-
 static struct folio *shmem_alloc_and_acct_folio(gfp_t gfp, struct inode *inode,
 		pgoff_t index, bool huge)
 {
@@ -1617,51 +1611,49 @@ static bool shmem_should_replace_folio(s
 static int shmem_replace_page(struct page **pagep, gfp_t gfp,
 				struct shmem_inode_info *info, pgoff_t index)
 {
-	struct page *oldpage, *newpage;
 	struct folio *old, *new;
 	struct address_space *swap_mapping;
 	swp_entry_t entry;
 	pgoff_t swap_index;
 	int error;
 
-	oldpage = *pagep;
-	entry.val = page_private(oldpage);
+	old = page_folio(*pagep);
+	entry = folio_swap_entry(old);
 	swap_index = swp_offset(entry);
-	swap_mapping = page_mapping(oldpage);
+	swap_mapping = swap_address_space(entry);
 
 	/*
 	 * We have arrived here because our zones are constrained, so don't
 	 * limit chance of success by further cpuset and node constraints.
 	 */
 	gfp &= ~GFP_CONSTRAINT_MASK;
-	newpage = shmem_alloc_page(gfp, info, index);
-	if (!newpage)
+	VM_BUG_ON_FOLIO(folio_test_large(old), old);
+	new = shmem_alloc_folio(gfp, info, index);
+	if (!new)
 		return -ENOMEM;
 
-	get_page(newpage);
-	copy_highpage(newpage, oldpage);
-	flush_dcache_page(newpage);
-
-	__SetPageLocked(newpage);
-	__SetPageSwapBacked(newpage);
-	SetPageUptodate(newpage);
-	set_page_private(newpage, entry.val);
-	SetPageSwapCache(newpage);
+	folio_get(new);
+	folio_copy(new, old);
+	flush_dcache_folio(new);
+
+	__folio_set_locked(new);
+	__folio_set_swapbacked(new);
+	folio_mark_uptodate(new);
+	folio_set_swap_entry(new, entry);
+	folio_set_swapcache(new);
 
 	/*
 	 * Our caller will very soon move newpage out of swapcache, but it's
 	 * a nice clean interface for us to replace oldpage by newpage there.
 	 */
 	xa_lock_irq(&swap_mapping->i_pages);
-	error = shmem_replace_entry(swap_mapping, swap_index, oldpage, newpage);
+	error = shmem_replace_entry(swap_mapping, swap_index, old, new);
 	if (!error) {
-		old = page_folio(oldpage);
-		new = page_folio(newpage);
 		mem_cgroup_migrate(old, new);
-		__inc_lruvec_page_state(newpage, NR_FILE_PAGES);
-		__inc_lruvec_page_state(newpage, NR_SHMEM);
-		__dec_lruvec_page_state(oldpage, NR_FILE_PAGES);
-		__dec_lruvec_page_state(oldpage, NR_SHMEM);
+		__lruvec_stat_mod_folio(new, NR_FILE_PAGES, 1);
+		__lruvec_stat_mod_folio(new, NR_SHMEM, 1);
+		__lruvec_stat_mod_folio(old, NR_FILE_PAGES, -1);
+		__lruvec_stat_mod_folio(old, NR_SHMEM, -1);
 	}
 	xa_unlock_irq(&swap_mapping->i_pages);
 
@@ -1671,18 +1663,17 @@ static int shmem_replace_page(struct pag
 		 * both PageSwapCache and page_private after getting page lock;
 		 * but be defensive.  Reverse old to newpage for clear and free.
 		 */
-		oldpage = newpage;
+		old = new;
 	} else {
-		lru_cache_add(newpage);
-		*pagep = newpage;
+		folio_add_lru(new);
+		*pagep = &new->page;
 	}
 
-	ClearPageSwapCache(oldpage);
-	set_page_private(oldpage, 0);
+	folio_clear_swapcache(old);
+	old->private = NULL;
 
-	unlock_page(oldpage);
-	put_page(oldpage);
-	put_page(oldpage);
+	folio_unlock(old);
+	folio_put_refs(old, 2);
 	return error;
 }
 
@@ -2383,6 +2374,12 @@ static struct inode *shmem_get_inode(str
 }
 
 #ifdef CONFIG_USERFAULTFD
+static struct page *shmem_alloc_page(gfp_t gfp,
+			struct shmem_inode_info *info, pgoff_t index)
+{
+	return &shmem_alloc_folio(gfp, info, index)->page;
+}
+
 int shmem_mfill_atomic_pte(struct mm_struct *dst_mm,
 			   pmd_t *dst_pmd,
 			   struct vm_area_struct *dst_vma,
_

Patches currently in -mm which might be from willy@infradead.org are


