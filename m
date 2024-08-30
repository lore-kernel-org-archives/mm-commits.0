Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30A7174EFC
	for <mm-commits@vger.kernel.org>; Fri, 30 Aug 2024 22:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725055862; cv=none; b=IbIm4nfU2+SZNEkoQSfU33mt5b8ek6d+EpDtoBpmNIsR6Dt0/zLfxERlzOk7floLaZTdmCnv9iTw3jsLqDK9K7gPDtgGJcBN1xgHNesaBRhAKP5+qbNIHIj/bGc4p8FuMNfCl2pTYZi/UUwd/umnlEzNrMwdPLL8R2DYOJiX+60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725055862; c=relaxed/simple;
	bh=har2MKBKZ8/yb1a0JIEw7o9QNRfbSYILVxrBqzfR/cM=;
	h=Date:To:From:Subject:Message-Id; b=fM5ShBul5vgCiOTbxV2AKQ4q4Jus0gpbopSt+QO5xUDQJh6mPTgVoEm5KSe5mN5qlSMCf2Q6eO8RKzbFJG7H4k7ZQLXlc/Z3Lz5BhKZt2aMTWOjDnWNeqdFWdrG8SAGvuRvh+g/ijujQ+ky3Nyex+c8qIeXhHRjHNmpDxzsfweQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2uMfNrf5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2uMfNrf5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 648CEC4CEC2;
	Fri, 30 Aug 2024 22:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725055861;
	bh=har2MKBKZ8/yb1a0JIEw7o9QNRfbSYILVxrBqzfR/cM=;
	h=Date:To:From:Subject:From;
	b=2uMfNrf5ZRtr9nAw/sT6vgWjhYUS3cs+qLVwOJjJ8WjT07R46vknufrXhRwOfGIPC
	 WaIwWduWrvh548Qh5ESTzUZ2SmRVfHMEEqRCklGSdOUP2caENrbez/2FP+eFhcbxsF
	 e/h6Qab5cYRXAwW32hiCRfjR05DlPQmL3bfmVzYg=
Date: Fri, 30 Aug 2024 15:11:00 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,spasswolf@web.de,sidhartha.kumar@oracle.com,paul@paul-moore.com,paulmck@kernel.org,olsajiri@gmail.com,lstoakes@gmail.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,kees@kernel.org,jeffxu@chromium.org,broonie@kernel.org,Liam.Howlett@Oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-introduce-vma_munmap_struct-for-use-in-munmap-operations.patch added to mm-unstable branch
Message-Id: <20240830221101.648CEC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vma: introduce vma_munmap_struct for use in munmap operations
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vma-introduce-vma_munmap_struct-for-use-in-munmap-operations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-introduce-vma_munmap_struct-for-use-in-munmap-operations.patch

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
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm/vma: introduce vma_munmap_struct for use in munmap operations
Date: Fri, 30 Aug 2024 00:00:45 -0400

Use a structure to pass along all the necessary information and counters
involved in removing vmas from the mm_struct.

Update vmi_ function names to vms_ to indicate the first argument type
change.

Link: https://lkml.kernel.org/r/20240830040101.822209-6-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Bert Karwatzki <spasswolf@web.de>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Jiri Olsa <olsajiri@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |  140 ++++++++++++++++++++++++++++-------------------------
 mm/vma.h |   16 ++++++
 2 files changed, 90 insertions(+), 66 deletions(-)

--- a/mm/vma.c~mm-vma-introduce-vma_munmap_struct-for-use-in-munmap-operations
+++ a/mm/vma.c
@@ -81,6 +81,32 @@ static void init_multi_vma_prep(struct v
 }
 
 /*
+ * init_vma_munmap() - Initializer wrapper for vma_munmap_struct
+ * @vms: The vma munmap struct
+ * @vmi: The vma iterator
+ * @vma: The first vm_area_struct to munmap
+ * @start: The aligned start address to munmap
+ * @end: The aligned end address to munmap
+ * @uf: The userfaultfd list_head
+ * @unlock: Unlock after the operation.  Only unlocked on success
+ */
+static inline void init_vma_munmap(struct vma_munmap_struct *vms,
+		struct vma_iterator *vmi, struct vm_area_struct *vma,
+		unsigned long start, unsigned long end, struct list_head *uf,
+		bool unlock)
+{
+	vms->vmi = vmi;
+	vms->vma = vma;
+	vms->mm = vma->vm_mm;
+	vms->start = start;
+	vms->end = end;
+	vms->unlock = unlock;
+	vms->uf = uf;
+	vms->vma_count = 0;
+	vms->nr_pages = vms->locked_vm = 0;
+}
+
+/*
  * Return true if we can merge this (vm_flags,anon_vma,file,vm_pgoff)
  * in front of (at a lower virtual address and file offset than) the vma.
  *
@@ -685,81 +711,62 @@ static inline void abort_munmap_vmas(str
 }
 
 /*
- * vmi_complete_munmap_vmas() - Finish the munmap() operation
- * @vmi: The vma iterator
- * @vma: The first vma to be munmapped
- * @mm: The mm struct
- * @start: The start address
- * @end: The end address
- * @unlock: Unlock the mm or not
- * @mas_detach: them maple state of the detached vma maple tree
- * @locked_vm: The locked_vm count in the detached vmas
+ * vms_complete_munmap_vmas() - Finish the munmap() operation
+ * @vms: The vma munmap struct
+ * @mas_detach: The maple state of the detached vmas
  *
- * This function updates the mm_struct, unmaps the region, frees the resources
+ * This updates the mm_struct, unmaps the region, frees the resources
  * used for the munmap() and may downgrade the lock - if requested.  Everything
  * needed to be done once the vma maple tree is updated.
  */
-static void
-vmi_complete_munmap_vmas(struct vma_iterator *vmi, struct vm_area_struct *vma,
-		struct mm_struct *mm, unsigned long start, unsigned long end,
-		bool unlock, struct ma_state *mas_detach,
-		unsigned long locked_vm)
+static void vms_complete_munmap_vmas(struct vma_munmap_struct *vms,
+		struct ma_state *mas_detach)
 {
 	struct vm_area_struct *prev, *next;
-	int count;
+	struct mm_struct *mm;
 
-	count = mas_detach->index + 1;
-	mm->map_count -= count;
-	mm->locked_vm -= locked_vm;
-	if (unlock)
+	mm = vms->mm;
+	mm->map_count -= vms->vma_count;
+	mm->locked_vm -= vms->locked_vm;
+	if (vms->unlock)
 		mmap_write_downgrade(mm);
 
-	prev = vma_iter_prev_range(vmi);
-	next = vma_next(vmi);
+	prev = vma_iter_prev_range(vms->vmi);
+	next = vma_next(vms->vmi);
 	if (next)
-		vma_iter_prev_range(vmi);
+		vma_iter_prev_range(vms->vmi);
 
 	/*
 	 * We can free page tables without write-locking mmap_lock because VMAs
 	 * were isolated before we downgraded mmap_lock.
 	 */
 	mas_set(mas_detach, 1);
-	unmap_region(mm, mas_detach, vma, prev, next, start, end, count,
-		     !unlock);
+	unmap_region(mm, mas_detach, vms->vma, prev, next, vms->start, vms->end,
+		     vms->vma_count, !vms->unlock);
 	/* Statistics and freeing VMAs */
 	mas_set(mas_detach, 0);
 	remove_mt(mm, mas_detach);
 	validate_mm(mm);
-	if (unlock)
+	if (vms->unlock)
 		mmap_read_unlock(mm);
 
 	__mt_destroy(mas_detach->tree);
 }
 
 /*
- * vmi_gather_munmap_vmas() - Put all VMAs within a range into a maple tree
+ * vms_gather_munmap_vmas() - Put all VMAs within a range into a maple tree
  * for removal at a later date.  Handles splitting first and last if necessary
  * and marking the vmas as isolated.
  *
- * @vmi: The vma iterator
- * @vma: The starting vm_area_struct
- * @mm: The mm_struct
- * @start: The aligned start address to munmap.
- * @end: The aligned end address to munmap.
- * @uf: The userfaultfd list_head
+ * @vms: The vma munmap struct
  * @mas_detach: The maple state tracking the detached tree
- * @locked_vm: a pointer to store the VM_LOCKED pages count.
  *
  * Return: 0 on success, -EPERM on mseal vmas, -ENOMEM otherwise
  */
-static int
-vmi_gather_munmap_vmas(struct vma_iterator *vmi, struct vm_area_struct *vma,
-		    struct mm_struct *mm, unsigned long start,
-		    unsigned long end, struct list_head *uf,
-		    struct ma_state *mas_detach, unsigned long *locked_vm)
+static int vms_gather_munmap_vmas(struct vma_munmap_struct *vms,
+		struct ma_state *mas_detach)
 {
 	struct vm_area_struct *next = NULL;
-	int count = 0;
 	int error = -ENOMEM;
 
 	/*
@@ -771,23 +778,24 @@ vmi_gather_munmap_vmas(struct vma_iterat
 	 */
 
 	/* Does it split the first one? */
-	if (start > vma->vm_start) {
+	if (vms->start > vms->vma->vm_start) {
 
 		/*
 		 * Make sure that map_count on return from munmap() will
 		 * not exceed its limit; but let map_count go just above
 		 * its limit temporarily, to help free resources as expected.
 		 */
-		if (end < vma->vm_end && mm->map_count >= sysctl_max_map_count)
+		if (vms->end < vms->vma->vm_end &&
+		    vms->mm->map_count >= sysctl_max_map_count)
 			goto map_count_exceeded;
 
 		/* Don't bother splitting the VMA if we can't unmap it anyway */
-		if (!can_modify_vma(vma)) {
+		if (!can_modify_vma(vms->vma)) {
 			error = -EPERM;
 			goto start_split_failed;
 		}
 
-		if (__split_vma(vmi, vma, start, 1))
+		if (__split_vma(vms->vmi, vms->vma, vms->start, 1))
 			goto start_split_failed;
 	}
 
@@ -795,7 +803,7 @@ vmi_gather_munmap_vmas(struct vma_iterat
 	 * Detach a range of VMAs from the mm. Using next as a temp variable as
 	 * it is always overwritten.
 	 */
-	next = vma;
+	next = vms->vma;
 	do {
 		if (!can_modify_vma(next)) {
 			error = -EPERM;
@@ -803,20 +811,20 @@ vmi_gather_munmap_vmas(struct vma_iterat
 		}
 
 		/* Does it split the end? */
-		if (next->vm_end > end) {
-			if (__split_vma(vmi, next, end, 0))
+		if (next->vm_end > vms->end) {
+			if (__split_vma(vms->vmi, next, vms->end, 0))
 				goto end_split_failed;
 		}
 		vma_start_write(next);
-		mas_set(mas_detach, count++);
+		mas_set(mas_detach, vms->vma_count++);
 		if (mas_store_gfp(mas_detach, next, GFP_KERNEL))
 			goto munmap_gather_failed;
 
 		vma_mark_detached(next, true);
 		if (next->vm_flags & VM_LOCKED)
-			*locked_vm += vma_pages(next);
+			vms->locked_vm += vma_pages(next);
 
-		if (unlikely(uf)) {
+		if (unlikely(vms->uf)) {
 			/*
 			 * If userfaultfd_unmap_prep returns an error the vmas
 			 * will remain split, but userland will get a
@@ -826,14 +834,15 @@ vmi_gather_munmap_vmas(struct vma_iterat
 			 * split, despite we could. This is unlikely enough
 			 * failure that it's not worth optimizing it for.
 			 */
-			if (userfaultfd_unmap_prep(next, start, end, uf))
+			if (userfaultfd_unmap_prep(next, vms->start, vms->end,
+						   vms->uf))
 				goto userfaultfd_error;
 		}
 #ifdef CONFIG_DEBUG_VM_MAPLE_TREE
-		BUG_ON(next->vm_start < start);
-		BUG_ON(next->vm_start > end);
+		BUG_ON(next->vm_start < vms->start);
+		BUG_ON(next->vm_start > vms->end);
 #endif
-	} for_each_vma_range(*vmi, next, end);
+	} for_each_vma_range(*(vms->vmi), next, vms->end);
 
 #if defined(CONFIG_DEBUG_VM_MAPLE_TREE)
 	/* Make sure no VMAs are about to be lost. */
@@ -842,21 +851,21 @@ vmi_gather_munmap_vmas(struct vma_iterat
 		struct vm_area_struct *vma_mas, *vma_test;
 		int test_count = 0;
 
-		vma_iter_set(vmi, start);
+		vma_iter_set(vms->vmi, vms->start);
 		rcu_read_lock();
-		vma_test = mas_find(&test, count - 1);
-		for_each_vma_range(*vmi, vma_mas, end) {
+		vma_test = mas_find(&test, vms->vma_count - 1);
+		for_each_vma_range(*(vms->vmi), vma_mas, vms->end) {
 			BUG_ON(vma_mas != vma_test);
 			test_count++;
-			vma_test = mas_next(&test, count - 1);
+			vma_test = mas_next(&test, vms->vma_count - 1);
 		}
 		rcu_read_unlock();
-		BUG_ON(count != test_count);
+		BUG_ON(vms->vma_count != test_count);
 	}
 #endif
 
-	while (vma_iter_addr(vmi) > start)
-		vma_iter_prev_range(vmi);
+	while (vma_iter_addr(vms->vmi) > vms->start)
+		vma_iter_prev_range(vms->vmi);
 
 	return 0;
 
@@ -892,11 +901,11 @@ int do_vmi_align_munmap(struct vma_itera
 	MA_STATE(mas_detach, &mt_detach, 0, 0);
 	mt_init_flags(&mt_detach, vmi->mas.tree->ma_flags & MT_FLAGS_LOCK_MASK);
 	mt_on_stack(mt_detach);
+	struct vma_munmap_struct vms;
 	int error;
-	unsigned long locked_vm = 0;
 
-	error = vmi_gather_munmap_vmas(vmi, vma, mm, start, end, uf,
-				       &mas_detach, &locked_vm);
+	init_vma_munmap(&vms, vmi, vma, start, end, uf, unlock);
+	error = vms_gather_munmap_vmas(&vms, &mas_detach);
 	if (error)
 		goto gather_failed;
 
@@ -905,8 +914,7 @@ int do_vmi_align_munmap(struct vma_itera
 		goto clear_tree_failed;
 
 	/* Point of no return */
-	vmi_complete_munmap_vmas(vmi, vma, mm, start, end, unlock, &mas_detach,
-				 locked_vm);
+	vms_complete_munmap_vmas(&vms, &mas_detach);
 	return 0;
 
 clear_tree_failed:
--- a/mm/vma.h~mm-vma-introduce-vma_munmap_struct-for-use-in-munmap-operations
+++ a/mm/vma.h
@@ -26,6 +26,22 @@ struct unlink_vma_file_batch {
 	struct vm_area_struct *vmas[8];
 };
 
+/*
+ * vma munmap operation
+ */
+struct vma_munmap_struct {
+	struct vma_iterator *vmi;
+	struct mm_struct *mm;
+	struct vm_area_struct *vma;     /* The first vma to munmap */
+	struct list_head *uf;           /* Userfaultfd list_head */
+	unsigned long start;            /* Aligned start addr (inclusive) */
+	unsigned long end;              /* Aligned end addr (exclusive) */
+	int vma_count;                  /* Number of vmas that will be removed */
+	unsigned long nr_pages;         /* Number of pages being removed */
+	unsigned long locked_vm;        /* Number of locked pages */
+	bool unlock;                    /* Unlock after the munmap */
+};
+
 #ifdef CONFIG_DEBUG_VM_MAPLE_TREE
 void validate_mm(struct mm_struct *mm);
 #else
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are

maple_tree-remove-rcu_read_lock-from-mt_validate.patch
mm-vma-correctly-position-vma_iterator-in-__split_vma.patch
mm-vma-introduce-abort_munmap_vmas.patch
mm-vma-introduce-vmi_complete_munmap_vmas.patch
mm-vma-extract-the-gathering-of-vmas-from-do_vmi_align_munmap.patch
mm-vma-introduce-vma_munmap_struct-for-use-in-munmap-operations.patch
mm-vma-change-munmap-to-use-vma_munmap_struct-for-accounting-and-surrounding-vmas.patch
mm-vma-extract-validate_mm-from-vma_complete.patch
mm-vma-inline-munmap-operation-in-mmap_region.patch
mm-vma-expand-mmap_region-munmap-call.patch
mm-vma-support-vma-==-null-in-init_vma_munmap.patch
mm-mmap-reposition-vma-iterator-in-mmap_region.patch
mm-vma-track-start-and-end-for-munmap-in-vma_munmap_struct.patch
mm-clean-up-unmap_region-argument-list.patch
mm-mmap-avoid-zeroing-vma-tree-in-mmap_region.patch
mm-change-failure-of-map_fixed-to-restoring-the-gap-on-failure.patch
mm-mmap-use-phys_pfn-in-mmap_region.patch
mm-mmap-use-vms-accounted-pages-in-mmap_region.patch
ipc-shm-mm-drop-do_vma_munmap.patch
mm-move-may_expand_vm-check-in-mmap_region.patch
mm-vma-drop-incorrect-comment-from-vms_gather_munmap_vmas.patch
mm-vmah-optimise-vma_munmap_struct.patch

