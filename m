Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8CC0C05027
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:54:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbjBJAx6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:53:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231171AbjBJAxo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:53:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB1C56E982
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:53:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56A6661BA2
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:53:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE64AC433EF;
        Fri, 10 Feb 2023 00:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990381;
        bh=xP7COBjXTJQwPcv709AdWsxOapEz8OvJCWnLCo3VmUI=;
        h=Date:To:From:Subject:From;
        b=L/kdhyPvd+f42uLaaaoBYom4llIWg3ZjqpGdJDz3UUHNoOAzi4S1i+jv6dWwvOnMk
         FFzYDPENdG/Tg6wrQ4rUBFUzAYqU+kbj6qekBZkCx1QgN9QMrZSHEbvD7+BOLNkiCT
         Upkwv9DYE1LUHYpR+kn7HN8jAghq5Y1i1RxSJTBc=
Date:   Thu, 09 Feb 2023 16:53:01 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] nommu-convert-nommu-to-using-the-vma-iterator.patch removed from -mm tree
Message-Id: <20230210005301.AE64AC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: nommu: convert nommu to using the vma iterator
has been removed from the -mm tree.  Its filename was
     nommu-convert-nommu-to-using-the-vma-iterator.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: nommu: convert nommu to using the vma iterator
Date: Fri, 20 Jan 2023 11:26:28 -0500

Gain type safety in nommu by using the vma_iterator and not the maple tree
directly.

Link: https://lkml.kernel.org/r/20230120162650.984577-28-Liam.Howlett@oracle.com
Signed-off-by: Liam R.  Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |   79 ++++++++++++++++++++-------------------------------
 1 file changed, 31 insertions(+), 48 deletions(-)

--- a/mm/nommu.c~nommu-convert-nommu-to-using-the-vma-iterator
+++ a/mm/nommu.c
@@ -544,19 +544,6 @@ static void put_nommu_region(struct vm_r
 	__put_nommu_region(region);
 }
 
-void vma_mas_store(struct vm_area_struct *vma, struct ma_state *mas)
-{
-	mas_set_range(mas, vma->vm_start, vma->vm_end - 1);
-	mas_store_prealloc(mas, vma);
-}
-
-void vma_mas_remove(struct vm_area_struct *vma, struct ma_state *mas)
-{
-	mas->index = vma->vm_start;
-	mas->last = vma->vm_end - 1;
-	mas_store_prealloc(mas, NULL);
-}
-
 static void setup_vma_to_mm(struct vm_area_struct *vma, struct mm_struct *mm)
 {
 	vma->vm_mm = mm;
@@ -574,13 +561,13 @@ static void setup_vma_to_mm(struct vm_ar
 }
 
 /*
- * mas_add_vma_to_mm() - Maple state variant of add_mas_to_mm().
- * @mas: The maple state with preallocations.
+ * vmi_add_vma_to_mm() - VMA Iterator variant of add_vmi_to_mm().
+ * @vmi: The VMA iterator
  * @mm: The mm_struct
  * @vma: The vma to add
  *
  */
-static void mas_add_vma_to_mm(struct ma_state *mas, struct mm_struct *mm,
+static void vmi_add_vma_to_mm(struct vma_iterator *vmi, struct mm_struct *mm,
 			      struct vm_area_struct *vma)
 {
 	BUG_ON(!vma->vm_region);
@@ -589,7 +576,7 @@ static void mas_add_vma_to_mm(struct ma_
 	mm->map_count++;
 
 	/* add the VMA to the tree */
-	vma_mas_store(vma, mas);
+	vma_iter_store(vmi, vma);
 }
 
 /*
@@ -600,14 +587,14 @@ static void mas_add_vma_to_mm(struct ma_
  */
 static int add_vma_to_mm(struct mm_struct *mm, struct vm_area_struct *vma)
 {
-	MA_STATE(mas, &mm->mm_mt, vma->vm_start, vma->vm_end);
+	VMA_ITERATOR(vmi, mm, vma->vm_start);
 
-	if (mas_preallocate(&mas, GFP_KERNEL)) {
+	if (vma_iter_prealloc(&vmi)) {
 		pr_warn("Allocation of vma tree for process %d failed\n",
 		       current->pid);
 		return -ENOMEM;
 	}
-	mas_add_vma_to_mm(&mas, mm, vma);
+	vmi_add_vma_to_mm(&vmi, mm, vma);
 	return 0;
 }
 
@@ -626,14 +613,15 @@ static void cleanup_vma_from_mm(struct v
 		i_mmap_unlock_write(mapping);
 	}
 }
+
 /*
  * delete a VMA from its owning mm_struct and address space
  */
 static int delete_vma_from_mm(struct vm_area_struct *vma)
 {
-	MA_STATE(mas, &vma->vm_mm->mm_mt, 0, 0);
+	VMA_ITERATOR(vmi, vma->vm_mm, vma->vm_start);
 
-	if (mas_preallocate(&mas, GFP_KERNEL)) {
+	if (vma_iter_prealloc(&vmi)) {
 		pr_warn("Allocation of vma tree for process %d failed\n",
 		       current->pid);
 		return -ENOMEM;
@@ -641,10 +629,9 @@ static int delete_vma_from_mm(struct vm_
 	cleanup_vma_from_mm(vma);
 
 	/* remove from the MM's tree and list */
-	vma_mas_remove(vma, &mas);
+	vma_iter_clear(&vmi, vma->vm_start, vma->vm_end);
 	return 0;
 }
-
 /*
  * destroy a VMA record
  */
@@ -675,9 +662,9 @@ EXPORT_SYMBOL(find_vma_intersection);
  */
 struct vm_area_struct *find_vma(struct mm_struct *mm, unsigned long addr)
 {
-	MA_STATE(mas, &mm->mm_mt, addr, addr);
+	VMA_ITERATOR(vmi, mm, addr);
 
-	return mas_walk(&mas);
+	return vma_iter_load(&vmi);
 }
 EXPORT_SYMBOL(find_vma);
 
@@ -709,9 +696,9 @@ static struct vm_area_struct *find_vma_e
 {
 	struct vm_area_struct *vma;
 	unsigned long end = addr + len;
-	MA_STATE(mas, &mm->mm_mt, addr, addr);
+	VMA_ITERATOR(vmi, mm, addr);
 
-	vma = mas_walk(&mas);
+	vma = vma_iter_load(&vmi);
 	if (!vma)
 		return NULL;
 	if (vma->vm_start != addr)
@@ -1062,7 +1049,7 @@ unsigned long do_mmap(struct file *file,
 	vm_flags_t vm_flags;
 	unsigned long capabilities, result;
 	int ret;
-	MA_STATE(mas, &current->mm->mm_mt, 0, 0);
+	VMA_ITERATOR(vmi, current->mm, 0);
 
 	*populate = 0;
 
@@ -1091,8 +1078,8 @@ unsigned long do_mmap(struct file *file,
 	if (!vma)
 		goto error_getting_vma;
 
-	if (mas_preallocate(&mas, GFP_KERNEL))
-		goto error_maple_preallocate;
+	if (vma_iter_prealloc(&vmi))
+		goto error_vma_iter_prealloc;
 
 	region->vm_usage = 1;
 	region->vm_flags = vm_flags;
@@ -1234,7 +1221,7 @@ unsigned long do_mmap(struct file *file,
 	current->mm->total_vm += len >> PAGE_SHIFT;
 
 share:
-	mas_add_vma_to_mm(&mas, current->mm, vma);
+	vmi_add_vma_to_mm(&vmi, current->mm, vma);
 
 	/* we flush the region from the icache only when the first executable
 	 * mapping of it is made  */
@@ -1250,7 +1237,7 @@ share:
 error_just_free:
 	up_write(&nommu_region_sem);
 error:
-	mas_destroy(&mas);
+	vma_iter_free(&vmi);
 	if (region->vm_file)
 		fput(region->vm_file);
 	kmem_cache_free(vm_region_jar, region);
@@ -1278,7 +1265,7 @@ error_getting_region:
 	show_free_areas(0, NULL);
 	return -ENOMEM;
 
-error_maple_preallocate:
+error_vma_iter_prealloc:
 	kmem_cache_free(vm_region_jar, region);
 	vm_area_free(vma);
 	pr_warn("Allocation of vma tree for process %d failed\n", current->pid);
@@ -1344,20 +1331,18 @@ SYSCALL_DEFINE1(old_mmap, struct mmap_ar
  * split a vma into two pieces at address 'addr', a new vma is allocated either
  * for the first part or the tail.
  */
-int split_vma(struct mm_struct *mm, struct vm_area_struct *vma,
-	      unsigned long addr, int new_below)
+int vmi_split_vma(struct vma_iterator *vmi, struct mm_struct *mm,
+		  struct vm_area_struct *vma, unsigned long addr, int new_below)
 {
 	struct vm_area_struct *new;
 	struct vm_region *region;
 	unsigned long npages;
-	MA_STATE(mas, &mm->mm_mt, vma->vm_start, vma->vm_end);
 
 	/* we're only permitted to split anonymous regions (these should have
 	 * only a single usage on the region) */
 	if (vma->vm_file)
 		return -ENOMEM;
 
-	mm = vma->vm_mm;
 	if (mm->map_count >= sysctl_max_map_count)
 		return -ENOMEM;
 
@@ -1369,10 +1354,10 @@ int split_vma(struct mm_struct *mm, stru
 	if (!new)
 		goto err_vma_dup;
 
-	if (mas_preallocate(&mas, GFP_KERNEL)) {
+	if (vma_iter_prealloc(vmi)) {
 		pr_warn("Allocation of vma tree for process %d failed\n",
 			current->pid);
-		goto err_mas_preallocate;
+		goto err_vmi_preallocate;
 	}
 
 	/* most fields are the same, copy all, and then fixup */
@@ -1406,13 +1391,11 @@ int split_vma(struct mm_struct *mm, stru
 
 	setup_vma_to_mm(vma, mm);
 	setup_vma_to_mm(new, mm);
-	mas_set_range(&mas, vma->vm_start, vma->vm_end - 1);
-	mas_store(&mas, vma);
-	vma_mas_store(new, &mas);
+	vma_iter_store(vmi, new);
 	mm->map_count++;
 	return 0;
 
-err_mas_preallocate:
+err_vmi_preallocate:
 	vm_area_free(new);
 err_vma_dup:
 	kmem_cache_free(vm_region_jar, region);
@@ -1466,7 +1449,7 @@ static int shrink_vma(struct mm_struct *
  */
 int do_munmap(struct mm_struct *mm, unsigned long start, size_t len, struct list_head *uf)
 {
-	MA_STATE(mas, &mm->mm_mt, start, start);
+	VMA_ITERATOR(vmi, mm, start);
 	struct vm_area_struct *vma;
 	unsigned long end;
 	int ret = 0;
@@ -1478,7 +1461,7 @@ int do_munmap(struct mm_struct *mm, unsi
 	end = start + len;
 
 	/* find the first potentially overlapping VMA */
-	vma = mas_find(&mas, end - 1);
+	vma = vma_find(&vmi, end);
 	if (!vma) {
 		static int limit;
 		if (limit < 5) {
@@ -1497,7 +1480,7 @@ int do_munmap(struct mm_struct *mm, unsi
 				return -EINVAL;
 			if (end == vma->vm_end)
 				goto erase_whole_vma;
-			vma = mas_next(&mas, end - 1);
+			vma = vma_find(&vmi, end);
 		} while (vma);
 		return -EINVAL;
 	} else {
@@ -1511,7 +1494,7 @@ int do_munmap(struct mm_struct *mm, unsi
 		if (end != vma->vm_end && offset_in_page(end))
 			return -EINVAL;
 		if (start != vma->vm_start && end != vma->vm_end) {
-			ret = split_vma(mm, vma, start, 1);
+			ret = vmi_split_vma(&vmi, mm, vma, start, 1);
 			if (ret < 0)
 				return ret;
 		}
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


