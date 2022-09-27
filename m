Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A30FC07E9D
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:54:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbiI0CyR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbiI0Cwj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:52:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA18CCE0
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:49:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 75803615B9
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:49:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CABEDC433B5;
        Tue, 27 Sep 2022 02:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246980;
        bh=+y0NplVUVzOko9pJslmCbav+4SHPRd4wDJveQ18MwkQ=;
        h=Date:To:From:Subject:From;
        b=JsZtPoDyUmmN5wGcW/yTneeG4tiCsMJtM1lJiTECZckRAZ89bP4CksothqPx0NaUb
         Ib3Nqcn+CuI71Yw6B7vlG5q0wra73uH4g5xr/L4tDmEOltJrdh8jdeONLN5HjsJBsB
         OQ93edYGeeMWX2kqF6EhBhWLzX7kSSmcqgFdiX0o=
Date:   Mon, 26 Sep 2022 19:49:40 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, will@kernel.org,
        vbabka@suse.cz, svens@linux.ibm.com, sj@kernel.org,
        Liam.Howlett@oracle.com, dhowells@redhat.com, david@redhat.com,
        dave@stgolabs.net, catalin.marinas@arm.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-stop-using-vma-linked-list.patch removed from -mm tree
Message-Id: <20220927024940.CABEDC433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/khugepaged: stop using vma linked list
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-stop-using-vma-linked-list.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/khugepaged: stop using vma linked list
Date: Tue, 6 Sep 2022 19:49:00 +0000

Use vma iterator & find_vma() instead of vma linked list.

Link: https://lkml.kernel.org/r/20220906194824.2110408-53-Liam.Howlett@oracle.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Tested-by: Yu Zhao <yuzhao@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++--
 mm/khugepaged.c  |    9 ++++++---
 2 files changed, 8 insertions(+), 5 deletions(-)

--- a/mm/huge_memory.c~mm-khugepaged-stop-using-vma-linked-list
+++ a/mm/huge_memory.c
@@ -2341,11 +2341,11 @@ void vma_adjust_trans_huge(struct vm_are
 	split_huge_pmd_if_needed(vma, end);
 
 	/*
-	 * If we're also updating the vma->vm_next->vm_start,
+	 * If we're also updating the next vma vm_start,
 	 * check if we need to split it.
 	 */
 	if (adjust_next > 0) {
-		struct vm_area_struct *next = vma->vm_next;
+		struct vm_area_struct *next = find_vma(vma->vm_mm, vma->vm_end);
 		unsigned long nstart = next->vm_start;
 		nstart += adjust_next;
 		split_huge_pmd_if_needed(next, nstart);
--- a/mm/khugepaged.c~mm-khugepaged-stop-using-vma-linked-list
+++ a/mm/khugepaged.c
@@ -2050,6 +2050,7 @@ static unsigned int khugepaged_scan_mm_s
 	__releases(&khugepaged_mm_lock)
 	__acquires(&khugepaged_mm_lock)
 {
+	struct vma_iterator vmi;
 	struct mm_slot *mm_slot;
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
@@ -2078,11 +2079,13 @@ static unsigned int khugepaged_scan_mm_s
 	vma = NULL;
 	if (unlikely(!mmap_read_trylock(mm)))
 		goto breakouterloop_mmap_lock;
-	if (likely(!hpage_collapse_test_exit(mm)))
-		vma = find_vma(mm, khugepaged_scan.address);
 
 	progress++;
-	for (; vma; vma = vma->vm_next) {
+	if (unlikely(hpage_collapse_test_exit(mm)))
+		goto breakouterloop;
+
+	vma_iter_init(&vmi, mm, khugepaged_scan.address);
+	for_each_vma(vmi, vma) {
 		unsigned long hstart, hend;
 
 		cond_resched();
_

Patches currently in -mm which might be from willy@infradead.org are

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

