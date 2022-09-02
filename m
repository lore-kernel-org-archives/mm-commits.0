Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46AB2C54EE9
	for <mm-commits@archiver.kernel.org>; Fri,  2 Sep 2022 23:26:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbiIBX0s (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Sep 2022 19:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbiIBX0c (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Sep 2022 19:26:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B8D39CCC0
        for <mm-commits@vger.kernel.org>; Fri,  2 Sep 2022 16:26:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B077B82E02
        for <mm-commits@vger.kernel.org>; Fri,  2 Sep 2022 23:26:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B70DAC433C1;
        Fri,  2 Sep 2022 23:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662161187;
        bh=WZcKy2V2Jgluoq8W6DpdBVYKKnH6RYmXs1S1Env8gVs=;
        h=Date:To:From:Subject:From;
        b=qsgV52tsMta4l0/ROMkAEsNLY3dKxmSLmfTTPcHWLmrpzI4Ss0sKxvLwKqTah0JhB
         35HXi3fO7MhRulF3psXN5q37FeFsKiDcvNRiuVae2KuCMEzoLMUIu9mrRYuoF2qJk7
         qfrF4QMLNV6BfU9hjgMdgYVVbD1cQ1i37RMZfQv0=
Date:   Fri, 02 Sep 2022 16:26:27 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swapfile-convert-try_to_free_swap-to-folio_free_swap.patch added to mm-unstable branch
Message-Id: <20220902232627.B70DAC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swapfile: convert try_to_free_swap() to folio_free_swap()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swapfile-convert-try_to_free_swap-to-folio_free_swap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swapfile-convert-try_to_free_swap-to-folio_free_swap.patch

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
Subject: mm/swapfile: convert try_to_free_swap() to folio_free_swap()
Date: Fri, 2 Sep 2022 20:46:06 +0100

Add kernel-doc for folio_free_swap() and make it return bool.  Add a
try_to_free_swap() compatibility wrapper.

Link: https://lkml.kernel.org/r/20220902194653.1739778-11-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    6 ++++++
 mm/folio-compat.c    |    7 +++++++
 mm/swapfile.c        |   32 ++++++++++++++++++--------------
 mm/vmscan.c          |    2 +-
 4 files changed, 32 insertions(+), 15 deletions(-)

--- a/include/linux/swap.h~mm-swapfile-convert-try_to_free_swap-to-folio_free_swap
+++ a/include/linux/swap.h
@@ -490,6 +490,7 @@ static inline long get_nr_swap_pages(voi
 
 extern void si_swapinfo(struct sysinfo *);
 swp_entry_t folio_alloc_swap(struct folio *folio);
+bool folio_free_swap(struct folio *folio);
 extern void put_swap_page(struct page *page, swp_entry_t entry);
 extern swp_entry_t get_swap_page_of_type(int);
 extern int get_swap_pages(int n, swp_entry_t swp_entries[], int entry_size);
@@ -606,6 +607,11 @@ static inline swp_entry_t folio_alloc_sw
 	return entry;
 }
 
+static inline bool folio_free_swap(struct folio *folio)
+{
+	return false;
+}
+
 static inline int add_swap_extent(struct swap_info_struct *sis,
 				  unsigned long start_page,
 				  unsigned long nr_pages, sector_t start_block)
--- a/mm/folio-compat.c~mm-swapfile-convert-try_to_free_swap-to-folio_free_swap
+++ a/mm/folio-compat.c
@@ -146,3 +146,10 @@ void putback_lru_page(struct page *page)
 {
 	folio_putback_lru(page_folio(page));
 }
+
+#ifdef CONFIG_SWAP
+int try_to_free_swap(struct page *page)
+{
+	return folio_free_swap(page_folio(page));
+}
+#endif
--- a/mm/swapfile.c~mm-swapfile-convert-try_to_free_swap-to-folio_free_swap
+++ a/mm/swapfile.c
@@ -1567,43 +1567,47 @@ static bool folio_swapped(struct folio *
 	return swap_page_trans_huge_swapped(si, entry);
 }
 
-/*
- * If swap is getting full, or if there are no more mappings of this page,
- * then try_to_free_swap is called to free its swap space.
+/**
+ * folio_free_swap() - Free the swap space used for this folio.
+ * @folio: The folio to remove.
+ *
+ * If swap is getting full, or if there are no more mappings of this folio,
+ * then call folio_free_swap to free its swap space.
+ *
+ * Return: true if we were able to release the swap space.
  */
-int try_to_free_swap(struct page *page)
+bool folio_free_swap(struct folio *folio)
 {
-	struct folio *folio = page_folio(page);
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 
 	if (!folio_test_swapcache(folio))
-		return 0;
+		return false;
 	if (folio_test_writeback(folio))
-		return 0;
+		return false;
 	if (folio_swapped(folio))
-		return 0;
+		return false;
 
 	/*
 	 * Once hibernation has begun to create its image of memory,
-	 * there's a danger that one of the calls to try_to_free_swap()
+	 * there's a danger that one of the calls to folio_free_swap()
 	 * - most probably a call from __try_to_reclaim_swap() while
 	 * hibernation is allocating its own swap pages for the image,
 	 * but conceivably even a call from memory reclaim - will free
-	 * the swap from a page which has already been recorded in the
-	 * image as a clean swapcache page, and then reuse its swap for
+	 * the swap from a folio which has already been recorded in the
+	 * image as a clean swapcache folio, and then reuse its swap for
 	 * another page of the image.  On waking from hibernation, the
-	 * original page might be freed under memory pressure, then
+	 * original folio might be freed under memory pressure, then
 	 * later read back in from swap, now with the wrong data.
 	 *
 	 * Hibernation suspends storage while it is writing the image
 	 * to disk so check that here.
 	 */
 	if (pm_suspended_storage())
-		return 0;
+		return false;
 
 	delete_from_swap_cache(folio);
 	folio_set_dirty(folio);
-	return 1;
+	return true;
 }
 
 /*
--- a/mm/vmscan.c~mm-swapfile-convert-try_to_free_swap-to-folio_free_swap
+++ a/mm/vmscan.c
@@ -2050,7 +2050,7 @@ activate_locked:
 		if (folio_test_swapcache(folio) &&
 		    (mem_cgroup_swap_full(&folio->page) ||
 		     folio_test_mlocked(folio)))
-			try_to_free_swap(&folio->page);
+			folio_free_swap(folio);
 		VM_BUG_ON_FOLIO(folio_test_active(folio), folio);
 		if (!folio_test_mlocked(folio)) {
 			int type = folio_is_file_lru(folio);
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

