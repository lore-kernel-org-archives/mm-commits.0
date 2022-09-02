Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E43DC6FA8B
	for <mm-commits@archiver.kernel.org>; Fri,  2 Sep 2022 23:26:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbiIBX0b (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Sep 2022 19:26:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbiIBX02 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Sep 2022 19:26:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB7BEAF0CA
        for <mm-commits@vger.kernel.org>; Fri,  2 Sep 2022 16:26:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC956B82E03
        for <mm-commits@vger.kernel.org>; Fri,  2 Sep 2022 23:26:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E76C433C1;
        Fri,  2 Sep 2022 23:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662161183;
        bh=rfUZIha2d90x5ggT1/VEHeRgZ1Lk97+f0keUS476sWk=;
        h=Date:To:From:Subject:From;
        b=MgCe2DuEudppFN+jzwWYJw4cGBPQxArzjKbM56WWciqGXzL+ORfuQmEenfnW5KHww
         eKfKsID474hwGxhNS9VslX/2vkBpGJ3q1TNwwcKuanig9tpZUx21IxeuMfkVRTY8V1
         2GxZhKDsI2yUqVxyW1DxtnzoIIUq0OLw9jvIflKs=
Date:   Fri, 02 Sep 2022 16:26:22 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + shmem-convert-shmem_replace_page-to-use-folios-throughout.patch added to mm-unstable branch
Message-Id: <20220902232623.62E76C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: convert shmem_replace_page() to use folios throughout
has been added to the -mm mm-unstable branch.  Its filename is
     shmem-convert-shmem_replace_page-to-use-folios-throughout.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/shmem-convert-shmem_replace_page-to-use-folios-throughout.patch

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

tools-fix-compilation-after-gfp_typesh-split.patch
mm-fix-vm_bug_on-in-__delete_from_swap_cache.patch
vmscan-check-folio_test_private-not-folio_get_private.patch
support-highmem-pages-in-vmap_pages_range_noflush.patch
mm-add-vma-iterator.patch
mmap-use-the-vma-iterator-in-count_vma_pages_range.patch
proc-remove-vma-rbtree-use-from-nommu.patch
arm64-remove-mmap-linked-list-from-vdso.patch
parisc-remove-mmap-linked-list-from-cache-handling.patch
powerpc-remove-mmap-linked-list-walks.patch
s390-remove-vma-linked-list-walks.patch
x86-remove-vma-linked-list-walks.patch
xtensa-remove-vma-linked-list-walks.patch
cxl-remove-vma-linked-list-walk.patch
optee-remove-vma-linked-list-walk.patch
um-remove-vma-linked-list-walk.patch
coredump-remove-vma-linked-list-walk.patch
exec-use-vma-iterator-instead-of-linked-list.patch
fs-proc-task_mmu-stop-using-linked-list-and-highest_vm_end.patch
acct-use-vma-iterator-instead-of-linked-list.patch
perf-use-vma-iterator.patch
sched-use-maple-tree-iterator-to-walk-vmas.patch
fork-use-vma-iterator.patch
mm-khugepaged-stop-using-vma-linked-list.patch
mm-ksm-use-vma-iterators-instead-of-vma-linked-list.patch
mm-mlock-use-vma-iterator-and-maple-state-instead-of-vma-linked-list.patch
mm-pagewalk-use-vma_find-instead-of-vma-linked-list.patch
i915-use-the-vma-iterator.patch
nommu-remove-uses-of-vma-linked-list.patch
mm-vmscan-fix-a-lot-of-comments.patch
mm-add-the-first-tail-page-to-struct-folio.patch
mm-reimplement-folio_order-and-folio_nr_pages.patch
mm-add-split_folio.patch
mm-add-folio_add_lru_vma.patch
shmem-convert-shmem_writepage-to-use-a-folio-throughout.patch
shmem-convert-shmem_delete_from_page_cache-to-take-a-folio.patch
shmem-convert-shmem_replace_page-to-use-folios-throughout.patch
mm-swapfile-remove-page_swapcount.patch
mm-swapfile-convert-try_to_free_swap-to-folio_free_swap.patch
mm-swap-convert-__read_swap_cache_async-to-use-a-folio.patch
mm-swap-convert-add_to_swap_cache-to-take-a-folio.patch
mm-swap-convert-put_swap_page-to-put_swap_folio.patch
mm-convert-do_swap_page-to-use-a-folio.patch
mm-convert-do_swap_pages-swapcache-variable-to-a-folio.patch
memcg-convert-mem_cgroup_swapin_charge_page-to-mem_cgroup_swapin_charge_folio.patch
shmem-convert-shmem_mfill_atomic_pte-to-use-a-folio.patch
shmem-convert-shmem_replace_page-to-shmem_replace_folio.patch
swap-add-swap_cache_get_folio.patch
shmem-eliminate-struct-page-from-shmem_swapin_folio.patch
shmem-convert-shmem_getpage_gfp-to-shmem_get_folio_gfp.patch
shmem-convert-shmem_fault-to-use-shmem_get_folio_gfp.patch
shmem-convert-shmem_read_mapping_page_gfp-to-use-shmem_get_folio_gfp.patch
shmem-add-shmem_get_folio.patch
shmem-convert-shmem_get_partial_folio-to-use-shmem_get_folio.patch
shmem-convert-shmem_write_begin-to-use-shmem_get_folio.patch
shmem-convert-shmem_file_read_iter-to-use-shmem_get_folio.patch
shmem-convert-shmem_fallocate-to-use-a-folio.patch
shmem-convert-shmem_symlink-to-use-a-folio.patch
shmem-convert-shmem_get_link-to-use-a-folio.patch
khugepaged-call-shmem_get_folio.patch
userfaultfd-convert-mcontinue_atomic_pte-to-use-a-folio.patch
shmem-remove-shmem_getpage.patch
swapfile-convert-try_to_unuse-to-use-a-folio.patch
swapfile-convert-__try_to_reclaim_swap-to-use-a-folio.patch
swapfile-convert-unuse_pte_range-to-use-a-folio.patch
mm-convert-do_swap_page-to-use-swap_cache_get_folio.patch
mm-remove-lookup_swap_cache.patch
swap_state-convert-free_swap_cache-to-use-a-folio.patch
swap-convert-swap_writepage-to-use-a-folio.patch
mm-convert-do_wp_page-to-use-a-folio.patch
huge_memory-convert-do_huge_pmd_wp_page-to-use-a-folio.patch
madvise-convert-madvise_free_pte_range-to-use-a-folio.patch
uprobes-use-folios-more-widely-in-__replace_page.patch
ksm-use-a-folio-in-replace_page.patch
mm-convert-do_swap_page-to-use-folio_free_swap.patch
memcg-convert-mem_cgroup_swap_full-to-take-a-folio.patch
mm-remove-try_to_free_swap.patch
rmap-convert-page_move_anon_rmap-to-use-a-folio.patch
migrate-convert-__unmap_and_move-to-use-folios.patch
migrate-convert-unmap_and_move_huge_page-to-use-folios.patch
huge_memory-convert-split_huge_page_to_list-to-use-a-folio.patch
huge_memory-convert-unmap_page-to-unmap_folio.patch
mm-convert-page_get_anon_vma-to-folio_get_anon_vma.patch
rmap-remove-page_unlock_anon_vma_read.patch
uprobes-use-new_folio-in-__replace_page.patch
mm-convert-lock_page_or_retry-to-folio_lock_or_retry.patch

