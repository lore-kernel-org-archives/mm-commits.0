Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C807C07E9D
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:53:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbiI0Cxx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbiI0Cvg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:51:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 844B361B2E
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:49:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25A58B81919
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:49:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D69ECC433D7;
        Tue, 27 Sep 2022 02:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246955;
        bh=7GOuSgHmMN66WQZ3RKNAaygpWW7R2QRjXPAXsHGFJb4=;
        h=Date:To:From:Subject:From;
        b=z0qqbpHCy6apL8faoDxSWzgMS862O0BE21RQq/emO91MAe0lepFT1Tgcml38qxCqI
         USbC7b04NAQrUl2vSCaMwgFBxMLbbWVjc+gItaX+Txmc40T6HF391LCGQMsCvTw3Hq
         rSv3fjKYnMzFQh5GabMqQk9hNBWInYZ0jMZppEAQ=
Date:   Mon, 26 Sep 2022 19:49:15 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, will@kernel.org,
        vbabka@suse.cz, svens@linux.ibm.com, sj@kernel.org,
        Liam.Howlett@Oracle.com, dhowells@redhat.com, david@redhat.com,
        dave@stgolabs.net, catalin.marinas@arm.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] powerpc-remove-mmap-linked-list-walks.patch removed from -mm tree
Message-Id: <20220927024915.D69ECC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: powerpc: remove mmap linked list walks
has been removed from the -mm tree.  Its filename was
     powerpc-remove-mmap-linked-list-walks.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: powerpc: remove mmap linked list walks
Date: Tue, 6 Sep 2022 19:48:53 +0000

Use the VMA iterator instead.

Link: https://lkml.kernel.org/r/20220906194824.2110408-34-Liam.Howlett@oracle.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Tested-by: Yu Zhao <yuzhao@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/vdso.c              |    6 +++---
 arch/powerpc/mm/book3s32/tlb.c          |   11 ++++++-----
 arch/powerpc/mm/book3s64/subpage_prot.c |   13 ++-----------
 3 files changed, 11 insertions(+), 19 deletions(-)

--- a/arch/powerpc/kernel/vdso.c~powerpc-remove-mmap-linked-list-walks
+++ a/arch/powerpc/kernel/vdso.c
@@ -113,18 +113,18 @@ struct vdso_data *arch_get_vdso_data(voi
 int vdso_join_timens(struct task_struct *task, struct time_namespace *ns)
 {
 	struct mm_struct *mm = task->mm;
+	VMA_ITERATOR(vmi, mm, 0);
 	struct vm_area_struct *vma;
 
 	mmap_read_lock(mm);
-
-	for (vma = mm->mmap; vma; vma = vma->vm_next) {
+	for_each_vma(vmi, vma) {
 		unsigned long size = vma->vm_end - vma->vm_start;
 
 		if (vma_is_special_mapping(vma, &vvar_spec))
 			zap_page_range(vma, vma->vm_start, size);
 	}
-
 	mmap_read_unlock(mm);
+
 	return 0;
 }
 
--- a/arch/powerpc/mm/book3s32/tlb.c~powerpc-remove-mmap-linked-list-walks
+++ a/arch/powerpc/mm/book3s32/tlb.c
@@ -81,14 +81,15 @@ EXPORT_SYMBOL(hash__flush_range);
 void hash__flush_tlb_mm(struct mm_struct *mm)
 {
 	struct vm_area_struct *mp;
+	VMA_ITERATOR(vmi, mm, 0);
 
 	/*
-	 * It is safe to go down the mm's list of vmas when called
-	 * from dup_mmap, holding mmap_lock.  It would also be safe from
-	 * unmap_region or exit_mmap, but not from vmtruncate on SMP -
-	 * but it seems dup_mmap is the only SMP case which gets here.
+	 * It is safe to iterate the vmas when called from dup_mmap,
+	 * holding mmap_lock.  It would also be safe from unmap_region
+	 * or exit_mmap, but not from vmtruncate on SMP - but it seems
+	 * dup_mmap is the only SMP case which gets here.
 	 */
-	for (mp = mm->mmap; mp != NULL; mp = mp->vm_next)
+	for_each_vma(vmi, mp)
 		hash__flush_range(mp->vm_mm, mp->vm_start, mp->vm_end);
 }
 EXPORT_SYMBOL(hash__flush_tlb_mm);
--- a/arch/powerpc/mm/book3s64/subpage_prot.c~powerpc-remove-mmap-linked-list-walks
+++ a/arch/powerpc/mm/book3s64/subpage_prot.c
@@ -149,24 +149,15 @@ static void subpage_mark_vma_nohuge(stru
 				    unsigned long len)
 {
 	struct vm_area_struct *vma;
+	VMA_ITERATOR(vmi, mm, addr);
 
 	/*
 	 * We don't try too hard, we just mark all the vma in that range
 	 * VM_NOHUGEPAGE and split them.
 	 */
-	vma = find_vma(mm, addr);
-	/*
-	 * If the range is in unmapped range, just return
-	 */
-	if (vma && ((addr + len) <= vma->vm_start))
-		return;
-
-	while (vma) {
-		if (vma->vm_start >= (addr + len))
-			break;
+	for_each_vma_range(vmi, vma, addr + len) {
 		vma->vm_flags |= VM_NOHUGEPAGE;
 		walk_page_vma(vma, &subpage_walk_ops, NULL);
-		vma = vma->vm_next;
 	}
 }
 #else
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

