Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36C1FC07E9D
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:51:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbiI0Cvm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:51:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbiI0Ctk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:49:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A12E6AA06
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:48:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12780B80DA7
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:48:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA9BBC43470;
        Tue, 27 Sep 2022 02:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246923;
        bh=g8vVT98cU0Y4VxsHfdxqZcWHw7iNChpYjjyAu3/26K0=;
        h=Date:To:From:Subject:From;
        b=DY3sMQzp+5+waMCZHVrozgvkMcQsRYjrlMOMjIVcU2/cLl/MF08mGc9iff7I21x4W
         vjZT8Rnuo5gLQJuRhbt/uuACwnqzBTx5w7D5PVjoSaTGRSq/N2l+7DUMb2AvKKFATr
         1fyrUEm9UtOHy5/jdjyXruSNYbpOr/Xi4JXDe8Qs=
Date:   Mon, 26 Sep 2022 19:48:43 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, will@kernel.org,
        vbabka@suse.cz, svens@linux.ibm.com, sj@kernel.org,
        Liam.Howlett@Oracle.com, dhowells@redhat.com, david@redhat.com,
        dave@stgolabs.net, catalin.marinas@arm.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-vma-iterator.patch removed from -mm tree
Message-Id: <20220927024843.AA9BBC43470@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: add VMA iterator
has been removed from the -mm tree.  Its filename was
     mm-add-vma-iterator.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: add VMA iterator
Date: Tue, 6 Sep 2022 19:48:46 +0000

This thin layer of abstraction over the maple tree state is for iterating
over VMAs.  You can go forwards, go backwards or ask where the iterator
is.  Rename the existing vma_next() to __vma_next() -- it will be removed
by the end of this series.

Link: https://lkml.kernel.org/r/20220906194824.2110408-10-Liam.Howlett@oracle.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Tested-by: Yu Zhao <yuzhao@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Howells <dhowells@redhat.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h       |   32 ++++++++++++++++++++++++++++++++
 include/linux/mm_types.h |   21 +++++++++++++++++++++
 mm/mmap.c                |   10 +++++-----
 3 files changed, 58 insertions(+), 5 deletions(-)

--- a/include/linux/mm.h~mm-add-vma-iterator
+++ a/include/linux/mm.h
@@ -661,6 +661,38 @@ static inline bool vma_is_accessible(str
 	return vma->vm_flags & VM_ACCESS_FLAGS;
 }
 
+static inline
+struct vm_area_struct *vma_find(struct vma_iterator *vmi, unsigned long max)
+{
+	return mas_find(&vmi->mas, max);
+}
+
+static inline struct vm_area_struct *vma_next(struct vma_iterator *vmi)
+{
+	/*
+	 * Uses vma_find() to get the first VMA when the iterator starts.
+	 * Calling mas_next() could skip the first entry.
+	 */
+	return vma_find(vmi, ULONG_MAX);
+}
+
+static inline struct vm_area_struct *vma_prev(struct vma_iterator *vmi)
+{
+	return mas_prev(&vmi->mas, 0);
+}
+
+static inline unsigned long vma_iter_addr(struct vma_iterator *vmi)
+{
+	return vmi->mas.index;
+}
+
+#define for_each_vma(__vmi, __vma)					\
+	while (((__vma) = vma_next(&(__vmi))) != NULL)
+
+/* The MM code likes to work with exclusive end addresses */
+#define for_each_vma_range(__vmi, __vma, __end)				\
+	while (((__vma) = vma_find(&(__vmi), (__end) - 1)) != NULL)
+
 #ifdef CONFIG_SHMEM
 /*
  * The vma_is_shmem is not inline because it is used only by slow
--- a/include/linux/mm_types.h~mm-add-vma-iterator
+++ a/include/linux/mm_types.h
@@ -777,6 +777,27 @@ static inline void lru_gen_use_mm(struct
 
 #endif /* CONFIG_LRU_GEN */
 
+struct vma_iterator {
+	struct ma_state mas;
+};
+
+#define VMA_ITERATOR(name, __mm, __addr)				\
+	struct vma_iterator name = {					\
+		.mas = {						\
+			.tree = &(__mm)->mm_mt,				\
+			.index = __addr,				\
+			.node = MAS_START,				\
+		},							\
+	}
+
+static inline void vma_iter_init(struct vma_iterator *vmi,
+		struct mm_struct *mm, unsigned long addr)
+{
+	vmi->mas.tree = &mm->mm_mt;
+	vmi->mas.index = addr;
+	vmi->mas.node = MAS_START;
+}
+
 struct mmu_gather;
 extern void tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm);
 extern void tlb_gather_mmu_fullmm(struct mmu_gather *tlb, struct mm_struct *mm);
--- a/mm/mmap.c~mm-add-vma-iterator
+++ a/mm/mmap.c
@@ -586,7 +586,7 @@ static int find_vma_links(struct mm_stru
 }
 
 /*
- * vma_next() - Get the next VMA.
+ * __vma_next() - Get the next VMA.
  * @mm: The mm_struct.
  * @vma: The current vma.
  *
@@ -594,7 +594,7 @@ static int find_vma_links(struct mm_stru
  *
  * Returns: The next VMA after @vma.
  */
-static inline struct vm_area_struct *vma_next(struct mm_struct *mm,
+static inline struct vm_area_struct *__vma_next(struct mm_struct *mm,
 					 struct vm_area_struct *vma)
 {
 	if (!vma)
@@ -1291,7 +1291,7 @@ struct vm_area_struct *vma_merge(struct
 	if (vm_flags & VM_SPECIAL)
 		return NULL;
 
-	next = vma_next(mm, prev);
+	next = __vma_next(mm, prev);
 	area = next;
 	if (area && area->vm_end == end)		/* cases 6, 7, 8 */
 		next = next->vm_next;
@@ -2843,7 +2843,7 @@ static void unmap_region(struct mm_struc
 		struct vm_area_struct *vma, struct vm_area_struct *prev,
 		unsigned long start, unsigned long end)
 {
-	struct vm_area_struct *next = vma_next(mm, prev);
+	struct vm_area_struct *next = __vma_next(mm, prev);
 	struct mmu_gather tlb;
 
 	lru_add_drain();
@@ -3051,7 +3051,7 @@ int __do_munmap(struct mm_struct *mm, un
 		if (error)
 			goto split_failed;
 	}
-	vma = vma_next(mm, prev);
+	vma = __vma_next(mm, prev);
 
 	if (unlikely(uf)) {
 		/*
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

