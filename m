Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D18D07D06E
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104003; cv=none; b=Ys1rs0YmZ9+n0wyTxY7NJ3qeOMDCHQcX7eclD/XC79m8P9qDaEP050tR3o3FH5YmGenYhe+8ZtfaDFnl0PPmZRDh6UE1vrYhumubq6HqLeJAebqeToXAYPFF2wIvfLv/AfghyfilPnrA5f6aA4WWmaGe/VW1c2qzeBfr301z3+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104003; c=relaxed/simple;
	bh=D4yrchVD5kqB2cKgYdRNsxfLnRNcI+SkyW7mUabf+J0=;
	h=Date:To:From:Subject:Message-Id; b=dchYpGB0CGnJvmulC9qw4Bmzn0jsQuO1e3ZKZQS0YZ4kt5SXSx97Q4HKFjQG7oHk4+taFtc96FuN97kNvCC+izD2AtUEWeY5vOxZfPfWjbHtdE/gxHA2lIx6puA9J/yhtFfdKcr6QtnrhqUn5NaPw8xAGrN5b5+iEsLfCwP9JcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1BUD40Ri; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1BUD40Ri"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4DC7C113CD;
	Fri, 26 Apr 2024 04:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104003;
	bh=D4yrchVD5kqB2cKgYdRNsxfLnRNcI+SkyW7mUabf+J0=;
	h=Date:To:From:Subject:From;
	b=1BUD40Ri3I2deVRiaO7y8srZ5L4IQOKQrqvqA66DfdIrZK3C6xMHCIjUFRyY+LDvy
	 EgWNRQ3H0DZ1i+NvqhsiwtQyqP2OcggyJvaPXz8pPlU5snQKGA7fJEeIbPwLqP4GZl
	 NwLVZi54Wj6LcdvEPPddD0XT4av23RoGCOpKYsCE=
Date: Thu, 25 Apr 2024 21:00:03 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,lstoakes@gmail.com,Liam.Howlett@oracle.com,deller@gmx.de,yajun.deng@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-convert-all-mas-except-mas_detach-to-vma-iterator.patch removed from -mm tree
Message-Id: <20240426040003.A4DC7C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mmap: convert all mas except mas_detach to vma iterator
has been removed from the -mm tree.  Its filename was
     mm-mmap-convert-all-mas-except-mas_detach-to-vma-iterator.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yajun Deng <yajun.deng@linux.dev>
Subject: mm/mmap: convert all mas except mas_detach to vma iterator
Date: Mon, 25 Mar 2024 14:32:58 +0800

There are two types of iterators mas and vmi in the current code.  If the
maple tree comes from the mm structure, we can use the vma iterator. 
Avoid using mas directly as possible.

Keep using mas for the mt_detach tree, since it doesn't come from the mm
structure.

Remove as many uses of mas as possible, but we will still have a few that
must be passed through in unmap_vmas() and free_pgtables().

Also introduce vma_iter_reset, vma_iter_{prev, next}_range_limit and
vma_iter_area_{lowest, highest} helper functions for using the vma
interator.

Link: https://lkml.kernel.org/r/20240325063258.1437618-1-yajun.deng@linux.dev
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
Tested-by: Helge Deller <deller@gmx.de>	[parisc]
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |   29 ++++++++++++
 mm/mmap.c     |  113 +++++++++++++++++++++++-------------------------
 2 files changed, 85 insertions(+), 57 deletions(-)

--- a/mm/internal.h~mm-mmap-convert-all-mas-except-mas_detach-to-vma-iterator
+++ a/mm/internal.h
@@ -1254,6 +1254,35 @@ static inline void vma_iter_config(struc
 	__mas_set_range(&vmi->mas, index, last - 1);
 }
 
+static inline void vma_iter_reset(struct vma_iterator *vmi)
+{
+	mas_reset(&vmi->mas);
+}
+
+static inline
+struct vm_area_struct *vma_iter_prev_range_limit(struct vma_iterator *vmi, unsigned long min)
+{
+	return mas_prev_range(&vmi->mas, min);
+}
+
+static inline
+struct vm_area_struct *vma_iter_next_range_limit(struct vma_iterator *vmi, unsigned long max)
+{
+	return mas_next_range(&vmi->mas, max);
+}
+
+static inline int vma_iter_area_lowest(struct vma_iterator *vmi, unsigned long min,
+				       unsigned long max, unsigned long size)
+{
+	return mas_empty_area(&vmi->mas, min, max - 1, size);
+}
+
+static inline int vma_iter_area_highest(struct vma_iterator *vmi, unsigned long min,
+					unsigned long max, unsigned long size)
+{
+	return mas_empty_area_rev(&vmi->mas, min, max - 1, size);
+}
+
 /*
  * VMA Iterator functions shared between nommu and mmap
  */
--- a/mm/mmap.c~mm-mmap-convert-all-mas-except-mas_detach-to-vma-iterator
+++ a/mm/mmap.c
@@ -1114,21 +1114,21 @@ static struct anon_vma *reusable_anon_vm
  */
 struct anon_vma *find_mergeable_anon_vma(struct vm_area_struct *vma)
 {
-	MA_STATE(mas, &vma->vm_mm->mm_mt, vma->vm_end, vma->vm_end);
 	struct anon_vma *anon_vma = NULL;
 	struct vm_area_struct *prev, *next;
+	VMA_ITERATOR(vmi, vma->vm_mm, vma->vm_end);
 
 	/* Try next first. */
-	next = mas_walk(&mas);
+	next = vma_iter_load(&vmi);
 	if (next) {
 		anon_vma = reusable_anon_vma(next, vma, next);
 		if (anon_vma)
 			return anon_vma;
 	}
 
-	prev = mas_prev(&mas, 0);
+	prev = vma_prev(&vmi);
 	VM_BUG_ON_VMA(prev != vma, vma);
-	prev = mas_prev(&mas, 0);
+	prev = vma_prev(&vmi);
 	/* Try prev next. */
 	if (prev)
 		anon_vma = reusable_anon_vma(prev, prev, vma);
@@ -1576,8 +1576,7 @@ static unsigned long unmapped_area(struc
 	unsigned long length, gap;
 	unsigned long low_limit, high_limit;
 	struct vm_area_struct *tmp;
-
-	MA_STATE(mas, &current->mm->mm_mt, 0, 0);
+	VMA_ITERATOR(vmi, current->mm, 0);
 
 	/* Adjust search length to account for worst case alignment overhead */
 	length = info->length + info->align_mask;
@@ -1589,23 +1588,23 @@ static unsigned long unmapped_area(struc
 		low_limit = mmap_min_addr;
 	high_limit = info->high_limit;
 retry:
-	if (mas_empty_area(&mas, low_limit, high_limit - 1, length))
+	if (vma_iter_area_lowest(&vmi, low_limit, high_limit, length))
 		return -ENOMEM;
 
-	gap = mas.index;
+	gap = vma_iter_addr(&vmi);
 	gap += (info->align_offset - gap) & info->align_mask;
-	tmp = mas_next(&mas, ULONG_MAX);
+	tmp = vma_next(&vmi);
 	if (tmp && (tmp->vm_flags & VM_STARTGAP_FLAGS)) { /* Avoid prev check if possible */
 		if (vm_start_gap(tmp) < gap + length - 1) {
 			low_limit = tmp->vm_end;
-			mas_reset(&mas);
+			vma_iter_reset(&vmi);
 			goto retry;
 		}
 	} else {
-		tmp = mas_prev(&mas, 0);
+		tmp = vma_prev(&vmi);
 		if (tmp && vm_end_gap(tmp) > gap) {
 			low_limit = vm_end_gap(tmp);
-			mas_reset(&mas);
+			vma_iter_reset(&vmi);
 			goto retry;
 		}
 	}
@@ -1628,8 +1627,8 @@ static unsigned long unmapped_area_topdo
 	unsigned long length, gap, gap_end;
 	unsigned long low_limit, high_limit;
 	struct vm_area_struct *tmp;
+	VMA_ITERATOR(vmi, current->mm, 0);
 
-	MA_STATE(mas, &current->mm->mm_mt, 0, 0);
 	/* Adjust search length to account for worst case alignment overhead */
 	length = info->length + info->align_mask;
 	if (length < info->length)
@@ -1640,24 +1639,24 @@ static unsigned long unmapped_area_topdo
 		low_limit = mmap_min_addr;
 	high_limit = info->high_limit;
 retry:
-	if (mas_empty_area_rev(&mas, low_limit, high_limit - 1, length))
+	if (vma_iter_area_highest(&vmi, low_limit, high_limit, length))
 		return -ENOMEM;
 
-	gap = mas.last + 1 - info->length;
+	gap = vma_iter_end(&vmi) - info->length;
 	gap -= (gap - info->align_offset) & info->align_mask;
-	gap_end = mas.last;
-	tmp = mas_next(&mas, ULONG_MAX);
+	gap_end = vma_iter_end(&vmi);
+	tmp = vma_next(&vmi);
 	if (tmp && (tmp->vm_flags & VM_STARTGAP_FLAGS)) { /* Avoid prev check if possible */
-		if (vm_start_gap(tmp) <= gap_end) {
+		if (vm_start_gap(tmp) < gap_end) {
 			high_limit = vm_start_gap(tmp);
-			mas_reset(&mas);
+			vma_iter_reset(&vmi);
 			goto retry;
 		}
 	} else {
-		tmp = mas_prev(&mas, 0);
+		tmp = vma_prev(&vmi);
 		if (tmp && vm_end_gap(tmp) > gap) {
 			high_limit = tmp->vm_start;
-			mas_reset(&mas);
+			vma_iter_reset(&vmi);
 			goto retry;
 		}
 	}
@@ -1912,12 +1911,12 @@ find_vma_prev(struct mm_struct *mm, unsi
 			struct vm_area_struct **pprev)
 {
 	struct vm_area_struct *vma;
-	MA_STATE(mas, &mm->mm_mt, addr, addr);
+	VMA_ITERATOR(vmi, mm, addr);
 
-	vma = mas_walk(&mas);
-	*pprev = mas_prev(&mas, 0);
+	vma = vma_iter_load(&vmi);
+	*pprev = vma_prev(&vmi);
 	if (!vma)
-		vma = mas_next(&mas, ULONG_MAX);
+		vma = vma_next(&vmi);
 	return vma;
 }
 
@@ -1971,7 +1970,7 @@ static int expand_upwards(struct vm_area
 	struct vm_area_struct *next;
 	unsigned long gap_addr;
 	int error = 0;
-	MA_STATE(mas, &mm->mm_mt, vma->vm_start, address);
+	VMA_ITERATOR(vmi, mm, vma->vm_start);
 
 	if (!(vma->vm_flags & VM_GROWSUP))
 		return -EFAULT;
@@ -1997,15 +1996,15 @@ static int expand_upwards(struct vm_area
 	}
 
 	if (next)
-		mas_prev_range(&mas, address);
+		vma_iter_prev_range_limit(&vmi, address);
 
-	__mas_set_range(&mas, vma->vm_start, address - 1);
-	if (mas_preallocate(&mas, vma, GFP_KERNEL))
+	vma_iter_config(&vmi, vma->vm_start, address);
+	if (vma_iter_prealloc(&vmi, vma))
 		return -ENOMEM;
 
 	/* We must make sure the anon_vma is allocated. */
 	if (unlikely(anon_vma_prepare(vma))) {
-		mas_destroy(&mas);
+		vma_iter_free(&vmi);
 		return -ENOMEM;
 	}
 
@@ -2045,7 +2044,7 @@ static int expand_upwards(struct vm_area
 				anon_vma_interval_tree_pre_update_vma(vma);
 				vma->vm_end = address;
 				/* Overwrite old entry in mtree. */
-				mas_store_prealloc(&mas, vma);
+				vma_iter_store(&vmi, vma);
 				anon_vma_interval_tree_post_update_vma(vma);
 				spin_unlock(&mm->page_table_lock);
 
@@ -2054,7 +2053,7 @@ static int expand_upwards(struct vm_area
 		}
 	}
 	anon_vma_unlock_write(vma->anon_vma);
-	mas_destroy(&mas);
+	vma_iter_free(&vmi);
 	validate_mm(mm);
 	return error;
 }
@@ -2067,9 +2066,9 @@ static int expand_upwards(struct vm_area
 int expand_downwards(struct vm_area_struct *vma, unsigned long address)
 {
 	struct mm_struct *mm = vma->vm_mm;
-	MA_STATE(mas, &mm->mm_mt, vma->vm_start, vma->vm_start);
 	struct vm_area_struct *prev;
 	int error = 0;
+	VMA_ITERATOR(vmi, mm, vma->vm_start);
 
 	if (!(vma->vm_flags & VM_GROWSDOWN))
 		return -EFAULT;
@@ -2079,7 +2078,7 @@ int expand_downwards(struct vm_area_stru
 		return -EPERM;
 
 	/* Enforce stack_guard_gap */
-	prev = mas_prev(&mas, 0);
+	prev = vma_prev(&vmi);
 	/* Check that both stack segments have the same anon_vma? */
 	if (prev) {
 		if (!(prev->vm_flags & VM_GROWSDOWN) &&
@@ -2089,15 +2088,15 @@ int expand_downwards(struct vm_area_stru
 	}
 
 	if (prev)
-		mas_next_range(&mas, vma->vm_start);
+		vma_iter_next_range_limit(&vmi, vma->vm_start);
 
-	__mas_set_range(&mas, address, vma->vm_end - 1);
-	if (mas_preallocate(&mas, vma, GFP_KERNEL))
+	vma_iter_config(&vmi, address, vma->vm_end);
+	if (vma_iter_prealloc(&vmi, vma))
 		return -ENOMEM;
 
 	/* We must make sure the anon_vma is allocated. */
 	if (unlikely(anon_vma_prepare(vma))) {
-		mas_destroy(&mas);
+		vma_iter_free(&vmi);
 		return -ENOMEM;
 	}
 
@@ -2138,7 +2137,7 @@ int expand_downwards(struct vm_area_stru
 				vma->vm_start = address;
 				vma->vm_pgoff -= grow;
 				/* Overwrite old entry in mtree. */
-				mas_store_prealloc(&mas, vma);
+				vma_iter_store(&vmi, vma);
 				anon_vma_interval_tree_post_update_vma(vma);
 				spin_unlock(&mm->page_table_lock);
 
@@ -2147,7 +2146,7 @@ int expand_downwards(struct vm_area_stru
 		}
 	}
 	anon_vma_unlock_write(vma->anon_vma);
-	mas_destroy(&mas);
+	vma_iter_free(&vmi);
 	validate_mm(mm);
 	return error;
 }
@@ -3242,7 +3241,7 @@ void exit_mmap(struct mm_struct *mm)
 	struct mmu_gather tlb;
 	struct vm_area_struct *vma;
 	unsigned long nr_accounted = 0;
-	MA_STATE(mas, &mm->mm_mt, 0, 0);
+	VMA_ITERATOR(vmi, mm, 0);
 	int count = 0;
 
 	/* mm's last user has gone, and its about to be pulled down */
@@ -3251,7 +3250,7 @@ void exit_mmap(struct mm_struct *mm)
 	mmap_read_lock(mm);
 	arch_exit_mmap(mm);
 
-	vma = mas_find(&mas, ULONG_MAX);
+	vma = vma_next(&vmi);
 	if (!vma || unlikely(xa_is_zero(vma))) {
 		/* Can happen if dup_mmap() received an OOM */
 		mmap_read_unlock(mm);
@@ -3264,7 +3263,7 @@ void exit_mmap(struct mm_struct *mm)
 	tlb_gather_mmu_fullmm(&tlb, mm);
 	/* update_hiwater_rss(mm) here? but nobody should be looking */
 	/* Use ULONG_MAX here to ensure all VMAs in the mm are unmapped */
-	unmap_vmas(&tlb, &mas, vma, 0, ULONG_MAX, ULONG_MAX, false);
+	unmap_vmas(&tlb, &vmi.mas, vma, 0, ULONG_MAX, ULONG_MAX, false);
 	mmap_read_unlock(mm);
 
 	/*
@@ -3274,8 +3273,8 @@ void exit_mmap(struct mm_struct *mm)
 	set_bit(MMF_OOM_SKIP, &mm->flags);
 	mmap_write_lock(mm);
 	mt_clear_in_rcu(&mm->mm_mt);
-	mas_set(&mas, vma->vm_end);
-	free_pgtables(&tlb, &mas, vma, FIRST_USER_ADDRESS,
+	vma_iter_set(&vmi, vma->vm_end);
+	free_pgtables(&tlb, &vmi.mas, vma, FIRST_USER_ADDRESS,
 		      USER_PGTABLES_CEILING, true);
 	tlb_finish_mmu(&tlb);
 
@@ -3284,14 +3283,14 @@ void exit_mmap(struct mm_struct *mm)
 	 * enabled, without holding any MM locks besides the unreachable
 	 * mmap_write_lock.
 	 */
-	mas_set(&mas, vma->vm_end);
+	vma_iter_set(&vmi, vma->vm_end);
 	do {
 		if (vma->vm_flags & VM_ACCOUNT)
 			nr_accounted += vma_pages(vma);
 		remove_vma(vma, true);
 		count++;
 		cond_resched();
-		vma = mas_find(&mas, ULONG_MAX);
+		vma = vma_next(&vmi);
 	} while (vma && likely(!xa_is_zero(vma)));
 
 	BUG_ON(count != mm->map_count);
@@ -3713,7 +3712,7 @@ int mm_take_all_locks(struct mm_struct *
 {
 	struct vm_area_struct *vma;
 	struct anon_vma_chain *avc;
-	MA_STATE(mas, &mm->mm_mt, 0, 0);
+	VMA_ITERATOR(vmi, mm, 0);
 
 	mmap_assert_write_locked(mm);
 
@@ -3725,14 +3724,14 @@ int mm_take_all_locks(struct mm_struct *
 	 * being written to until mmap_write_unlock() or mmap_write_downgrade()
 	 * is reached.
 	 */
-	mas_for_each(&mas, vma, ULONG_MAX) {
+	for_each_vma(vmi, vma) {
 		if (signal_pending(current))
 			goto out_unlock;
 		vma_start_write(vma);
 	}
 
-	mas_set(&mas, 0);
-	mas_for_each(&mas, vma, ULONG_MAX) {
+	vma_iter_init(&vmi, mm, 0);
+	for_each_vma(vmi, vma) {
 		if (signal_pending(current))
 			goto out_unlock;
 		if (vma->vm_file && vma->vm_file->f_mapping &&
@@ -3740,8 +3739,8 @@ int mm_take_all_locks(struct mm_struct *
 			vm_lock_mapping(mm, vma->vm_file->f_mapping);
 	}
 
-	mas_set(&mas, 0);
-	mas_for_each(&mas, vma, ULONG_MAX) {
+	vma_iter_init(&vmi, mm, 0);
+	for_each_vma(vmi, vma) {
 		if (signal_pending(current))
 			goto out_unlock;
 		if (vma->vm_file && vma->vm_file->f_mapping &&
@@ -3749,8 +3748,8 @@ int mm_take_all_locks(struct mm_struct *
 			vm_lock_mapping(mm, vma->vm_file->f_mapping);
 	}
 
-	mas_set(&mas, 0);
-	mas_for_each(&mas, vma, ULONG_MAX) {
+	vma_iter_init(&vmi, mm, 0);
+	for_each_vma(vmi, vma) {
 		if (signal_pending(current))
 			goto out_unlock;
 		if (vma->anon_vma)
@@ -3809,12 +3808,12 @@ void mm_drop_all_locks(struct mm_struct
 {
 	struct vm_area_struct *vma;
 	struct anon_vma_chain *avc;
-	MA_STATE(mas, &mm->mm_mt, 0, 0);
+	VMA_ITERATOR(vmi, mm, 0);
 
 	mmap_assert_write_locked(mm);
 	BUG_ON(!mutex_is_locked(&mm_all_locks_mutex));
 
-	mas_for_each(&mas, vma, ULONG_MAX) {
+	for_each_vma(vmi, vma) {
 		if (vma->anon_vma)
 			list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
 				vm_unlock_anon_vma(avc->anon_vma);
_

Patches currently in -mm which might be from yajun.deng@linux.dev are


