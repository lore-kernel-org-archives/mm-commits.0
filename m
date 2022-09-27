Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1F03C6FA82
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:56:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbiI0C4M (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:56:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbiI0Cy0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:54:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9A43192B9
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:50:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01EFBB81985
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:49:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2529C433C1;
        Tue, 27 Sep 2022 02:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246997;
        bh=dVqhSf48pC264Xs0vScxizaUYYp47VCuOAQ3EvJVmC0=;
        h=Date:To:From:Subject:From;
        b=SdQ0I+olbEEkkq24ypRAQR1SbuKl6vYaGYJO6QB6VQ4BYQZVg1IPLfifvS5wJZ7us
         7pcB7GD2icr+mA8VyF7lPmjpNiGfXKMEi8U2CPcSyJZCxfAMxppw9u2c4ol+IuYNrv
         WeGnz2A0LuJE++VinoTMiyuxekCQ1RehO1uTEQBQ=
Date:   Mon, 26 Sep 2022 19:49:57 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, will@kernel.org,
        vbabka@suse.cz, svens@linux.ibm.com, sj@kernel.org,
        Liam.Howlett@Oracle.com, dhowells@redhat.com, david@redhat.com,
        dave@stgolabs.net, catalin.marinas@arm.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] nommu-remove-uses-of-vma-linked-list.patch removed from -mm tree
Message-Id: <20220927024957.B2529C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: nommu: remove uses of VMA linked list
has been removed from the -mm tree.  Its filename was
     nommu-remove-uses-of-vma-linked-list.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: nommu: remove uses of VMA linked list
Date: Tue, 6 Sep 2022 19:49:05 +0000

Use the maple tree or VMA iterator instead.  This is faster and will allow
us to shrink the VMA.

Link: https://lkml.kernel.org/r/20220906194824.2110408-66-Liam.Howlett@oracle.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Yu Zhao <yuzhao@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |  146 ++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 109 insertions(+), 37 deletions(-)

--- a/mm/nommu.c~nommu-remove-uses-of-vma-linked-list
+++ a/mm/nommu.c
@@ -557,26 +557,14 @@ void vma_mas_remove(struct vm_area_struc
 	mas_store_prealloc(mas, NULL);
 }
 
-/*
- * add a VMA into a process's mm_struct in the appropriate place in the list
- * and tree and add to the address space's page tree also if not an anonymous
- * page
- * - should be called with mm->mmap_lock held writelocked
- */
-static void add_vma_to_mm(struct mm_struct *mm, struct vm_area_struct *vma)
+static void setup_vma_to_mm(struct vm_area_struct *vma, struct mm_struct *mm)
 {
-	struct address_space *mapping;
-	struct vm_area_struct *prev;
-	MA_STATE(mas, &mm->mm_mt, vma->vm_start, vma->vm_end);
-
-	BUG_ON(!vma->vm_region);
-
 	mm->map_count++;
 	vma->vm_mm = mm;
 
 	/* add the VMA to the mapping */
 	if (vma->vm_file) {
-		mapping = vma->vm_file->f_mapping;
+		struct address_space *mapping = vma->vm_file->f_mapping;
 
 		i_mmap_lock_write(mapping);
 		flush_dcache_mmap_lock(mapping);
@@ -584,21 +572,52 @@ static void add_vma_to_mm(struct mm_stru
 		flush_dcache_mmap_unlock(mapping);
 		i_mmap_unlock_write(mapping);
 	}
+}
+
+/*
+ * mas_add_vma_to_mm() - Maple state variant of add_mas_to_mm().
+ * @mas: The maple state with preallocations.
+ * @mm: The mm_struct
+ * @vma: The vma to add
+ *
+ */
+static void mas_add_vma_to_mm(struct ma_state *mas, struct mm_struct *mm,
+			      struct vm_area_struct *vma)
+{
+	struct vm_area_struct *prev;
+
+	BUG_ON(!vma->vm_region);
 
-	prev = mas_prev(&mas, 0);
-	mas_reset(&mas);
+	setup_vma_to_mm(vma, mm);
+
+	prev = mas_prev(mas, 0);
+	mas_reset(mas);
 	/* add the VMA to the tree */
-	vma_mas_store(vma, &mas);
+	vma_mas_store(vma, mas);
 	__vma_link_list(mm, vma, prev);
 }
 
 /*
- * delete a VMA from its owning mm_struct and address space
+ * add a VMA into a process's mm_struct in the appropriate place in the list
+ * and tree and add to the address space's page tree also if not an anonymous
+ * page
+ * - should be called with mm->mmap_lock held writelocked
  */
-static void delete_vma_from_mm(struct vm_area_struct *vma)
+static int add_vma_to_mm(struct mm_struct *mm, struct vm_area_struct *vma)
 {
-	MA_STATE(mas, &vma->vm_mm->mm_mt, 0, 0);
+	MA_STATE(mas, &mm->mm_mt, vma->vm_start, vma->vm_end);
+
+	if (mas_preallocate(&mas, vma, GFP_KERNEL)) {
+		pr_warn("Allocation of vma tree for process %d failed\n",
+		       current->pid);
+		return -ENOMEM;
+	}
+	mas_add_vma_to_mm(&mas, mm, vma);
+	return 0;
+}
 
+static void cleanup_vma_from_mm(struct vm_area_struct *vma)
+{
 	vma->vm_mm->map_count--;
 	/* remove the VMA from the mapping */
 	if (vma->vm_file) {
@@ -611,10 +630,25 @@ static void delete_vma_from_mm(struct vm
 		flush_dcache_mmap_unlock(mapping);
 		i_mmap_unlock_write(mapping);
 	}
+}
+/*
+ * delete a VMA from its owning mm_struct and address space
+ */
+static int delete_vma_from_mm(struct vm_area_struct *vma)
+{
+	MA_STATE(mas, &vma->vm_mm->mm_mt, 0, 0);
+
+	if (mas_preallocate(&mas, vma, GFP_KERNEL)) {
+		pr_warn("Allocation of vma tree for process %d failed\n",
+		       current->pid);
+		return -ENOMEM;
+	}
+	cleanup_vma_from_mm(vma);
 
 	/* remove from the MM's tree and list */
 	vma_mas_remove(vma, &mas);
 	__vma_unlink_list(vma->vm_mm, vma);
+	return 0;
 }
 
 /*
@@ -1024,6 +1058,7 @@ unsigned long do_mmap(struct file *file,
 	vm_flags_t vm_flags;
 	unsigned long capabilities, result;
 	int ret;
+	MA_STATE(mas, &current->mm->mm_mt, 0, 0);
 
 	*populate = 0;
 
@@ -1042,6 +1077,7 @@ unsigned long do_mmap(struct file *file,
 	 * now know into VMA flags */
 	vm_flags = determine_vm_flags(file, prot, flags, capabilities);
 
+
 	/* we're going to need to record the mapping */
 	region = kmem_cache_zalloc(vm_region_jar, GFP_KERNEL);
 	if (!region)
@@ -1051,6 +1087,9 @@ unsigned long do_mmap(struct file *file,
 	if (!vma)
 		goto error_getting_vma;
 
+	if (mas_preallocate(&mas, vma, GFP_KERNEL))
+		goto error_maple_preallocate;
+
 	region->vm_usage = 1;
 	region->vm_flags = vm_flags;
 	region->vm_pgoff = pgoff;
@@ -1191,7 +1230,7 @@ unsigned long do_mmap(struct file *file,
 	current->mm->total_vm += len >> PAGE_SHIFT;
 
 share:
-	add_vma_to_mm(current->mm, vma);
+	mas_add_vma_to_mm(&mas, current->mm, vma);
 
 	/* we flush the region from the icache only when the first executable
 	 * mapping of it is made  */
@@ -1217,6 +1256,7 @@ error:
 
 sharing_violation:
 	up_write(&nommu_region_sem);
+	mas_destroy(&mas);
 	pr_warn("Attempt to share mismatched mappings\n");
 	ret = -EINVAL;
 	goto error;
@@ -1233,6 +1273,14 @@ error_getting_region:
 			len, current->pid);
 	show_free_areas(0, NULL);
 	return -ENOMEM;
+
+error_maple_preallocate:
+	kmem_cache_free(vm_region_jar, region);
+	vm_area_free(vma);
+	pr_warn("Allocation of vma tree for process %d failed\n", current->pid);
+	show_free_areas(0, NULL);
+	return -ENOMEM;
+
 }
 
 unsigned long ksys_mmap_pgoff(unsigned long addr, unsigned long len,
@@ -1298,6 +1346,7 @@ int split_vma(struct mm_struct *mm, stru
 	struct vm_area_struct *new;
 	struct vm_region *region;
 	unsigned long npages;
+	MA_STATE(mas, &mm->mm_mt, vma->vm_start, vma->vm_end);
 
 	/* we're only permitted to split anonymous regions (these should have
 	 * only a single usage on the region) */
@@ -1312,9 +1361,13 @@ int split_vma(struct mm_struct *mm, stru
 		return -ENOMEM;
 
 	new = vm_area_dup(vma);
-	if (!new) {
-		kmem_cache_free(vm_region_jar, region);
-		return -ENOMEM;
+	if (!new)
+		goto err_vma_dup;
+
+	if (mas_preallocate(&mas, vma, GFP_KERNEL)) {
+		pr_warn("Allocation of vma tree for process %d failed\n",
+			current->pid);
+		goto err_mas_preallocate;
 	}
 
 	/* most fields are the same, copy all, and then fixup */
@@ -1333,7 +1386,6 @@ int split_vma(struct mm_struct *mm, stru
 	if (new->vm_ops && new->vm_ops->open)
 		new->vm_ops->open(new);
 
-	delete_vma_from_mm(vma);
 	down_write(&nommu_region_sem);
 	delete_nommu_region(vma->vm_region);
 	if (new_below) {
@@ -1346,9 +1398,19 @@ int split_vma(struct mm_struct *mm, stru
 	add_nommu_region(vma->vm_region);
 	add_nommu_region(new->vm_region);
 	up_write(&nommu_region_sem);
-	add_vma_to_mm(mm, vma);
-	add_vma_to_mm(mm, new);
+
+	setup_vma_to_mm(vma, mm);
+	setup_vma_to_mm(new, mm);
+	mas_set_range(&mas, vma->vm_start, vma->vm_end - 1);
+	mas_store(&mas, vma);
+	vma_mas_store(new, &mas);
 	return 0;
+
+err_mas_preallocate:
+	vm_area_free(new);
+err_vma_dup:
+	kmem_cache_free(vm_region_jar, region);
+	return -ENOMEM;
 }
 
 /*
@@ -1363,12 +1425,14 @@ static int shrink_vma(struct mm_struct *
 
 	/* adjust the VMA's pointers, which may reposition it in the MM's tree
 	 * and list */
-	delete_vma_from_mm(vma);
+	if (delete_vma_from_mm(vma))
+		return -ENOMEM;
 	if (from > vma->vm_start)
 		vma->vm_end = from;
 	else
 		vma->vm_start = to;
-	add_vma_to_mm(mm, vma);
+	if (add_vma_to_mm(mm, vma))
+		return -ENOMEM;
 
 	/* cut the backing region down to size */
 	region = vma->vm_region;
@@ -1396,9 +1460,10 @@ static int shrink_vma(struct mm_struct *
  */
 int do_munmap(struct mm_struct *mm, unsigned long start, size_t len, struct list_head *uf)
 {
+	MA_STATE(mas, &mm->mm_mt, start, start);
 	struct vm_area_struct *vma;
 	unsigned long end;
-	int ret;
+	int ret = 0;
 
 	len = PAGE_ALIGN(len);
 	if (len == 0)
@@ -1407,7 +1472,7 @@ int do_munmap(struct mm_struct *mm, unsi
 	end = start + len;
 
 	/* find the first potentially overlapping VMA */
-	vma = find_vma(mm, start);
+	vma = mas_find(&mas, end - 1);
 	if (!vma) {
 		static int limit;
 		if (limit < 5) {
@@ -1426,7 +1491,7 @@ int do_munmap(struct mm_struct *mm, unsi
 				return -EINVAL;
 			if (end == vma->vm_end)
 				goto erase_whole_vma;
-			vma = vma->vm_next;
+			vma = mas_next(&mas, end - 1);
 		} while (vma);
 		return -EINVAL;
 	} else {
@@ -1448,9 +1513,10 @@ int do_munmap(struct mm_struct *mm, unsi
 	}
 
 erase_whole_vma:
-	delete_vma_from_mm(vma);
+	if (delete_vma_from_mm(vma))
+		ret = -ENOMEM;
 	delete_vma(mm, vma);
-	return 0;
+	return ret;
 }
 
 int vm_munmap(unsigned long addr, size_t len)
@@ -1475,6 +1541,7 @@ SYSCALL_DEFINE2(munmap, unsigned long, a
  */
 void exit_mmap(struct mm_struct *mm)
 {
+	VMA_ITERATOR(vmi, mm, 0);
 	struct vm_area_struct *vma;
 
 	if (!mm)
@@ -1482,13 +1549,18 @@ void exit_mmap(struct mm_struct *mm)
 
 	mm->total_vm = 0;
 
-	while ((vma = mm->mmap)) {
-		mm->mmap = vma->vm_next;
-		delete_vma_from_mm(vma);
+	/*
+	 * Lock the mm to avoid assert complaining even though this is the only
+	 * user of the mm
+	 */
+	mmap_write_lock(mm);
+	for_each_vma(vmi, vma) {
+		cleanup_vma_from_mm(vma);
 		delete_vma(mm, vma);
 		cond_resched();
 	}
 	__mt_destroy(&mm->mm_mt);
+	mmap_write_unlock(mm);
 }
 
 int vm_brk(unsigned long addr, unsigned long len)
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

