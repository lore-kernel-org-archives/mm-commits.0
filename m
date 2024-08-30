Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D31891BC9FB
	for <mm-commits@vger.kernel.org>; Fri, 30 Aug 2024 22:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725055859; cv=none; b=p8MehviFz36KuCh38jF6elouDRSwK2yFKGlfNJS6hxF+Oa78sm1cdu1I65mraZ7AYY7p6Vn4VO/j3XE1e7LIy7AxXb6UbNmAZfiY5vSJwRa2xCnjvsHrOachVPoECKLfS9XOXAKVgcasfH1saji7Rpqj/LbGXnYA9eLCiL7b37c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725055859; c=relaxed/simple;
	bh=+s8OSAJFGTHtGONGTcEBh767pcNSMXcrb94cSvEoTyo=;
	h=Date:To:From:Subject:Message-Id; b=WtyiiHD1sewlnvZPhZaJ2ehmee0XiKpMlu5dGE0sBc4/RFgIDYelwS7nPxz9QgTpYxVGAuD2kZwoQ/5UCsjBUhBJTNqZQngOu1DqbnVwDDM2Re0/NjOgd+Mo0pKh9K9LmD2pTbUCU9FZuuPY/sTPOf5fW/L2W6ZZx8VF4yqSCCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p/nnmtMP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p/nnmtMP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49BFEC4CEC2;
	Fri, 30 Aug 2024 22:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725055859;
	bh=+s8OSAJFGTHtGONGTcEBh767pcNSMXcrb94cSvEoTyo=;
	h=Date:To:From:Subject:From;
	b=p/nnmtMPTpbPGW+OtYUQurly5KdaHnCBMUAFzuKJ19HWXsmXRamHLlHhfvp1w5cIl
	 OjtwcEQSaNtkke5epvQuMqsckwaBnlPQfbkgdr6vMCICiXGHpsTKIGyA0XYB9eQuJl
	 6KFJVyoFRzUEt1IRa0/oRT11ksXoN3QOO6fwfcIQ=
Date: Fri, 30 Aug 2024 15:10:58 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,spasswolf@web.de,sidhartha.kumar@oracle.com,paul@paul-moore.com,paulmck@kernel.org,olsajiri@gmail.com,lstoakes@gmail.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,kees@kernel.org,jeffxu@chromium.org,broonie@kernel.org,Liam.Howlett@Oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-extract-the-gathering-of-vmas-from-do_vmi_align_munmap.patch added to mm-unstable branch
Message-Id: <20240830221059.49BFEC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vma: extract the gathering of vmas from do_vmi_align_munmap()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vma-extract-the-gathering-of-vmas-from-do_vmi_align_munmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-extract-the-gathering-of-vmas-from-do_vmi_align_munmap.patch

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
Subject: mm/vma: extract the gathering of vmas from do_vmi_align_munmap()
Date: Fri, 30 Aug 2024 00:00:44 -0400

Create vmi_gather_munmap_vmas() to handle the gathering of vmas into a
detached maple tree for removal later.  Part of the gathering is the
splitting of vmas that span the boundary.

Link: https://lkml.kernel.org/r/20240830040101.822209-5-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
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
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |   95 ++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 62 insertions(+), 33 deletions(-)

--- a/mm/vma.c~mm-vma-extract-the-gathering-of-vmas-from-do_vmi_align_munmap
+++ a/mm/vma.c
@@ -737,32 +737,30 @@ vmi_complete_munmap_vmas(struct vma_iter
 }
 
 /*
- * do_vmi_align_munmap() - munmap the aligned region from @start to @end.
+ * vmi_gather_munmap_vmas() - Put all VMAs within a range into a maple tree
+ * for removal at a later date.  Handles splitting first and last if necessary
+ * and marking the vmas as isolated.
+ *
  * @vmi: The vma iterator
  * @vma: The starting vm_area_struct
  * @mm: The mm_struct
  * @start: The aligned start address to munmap.
  * @end: The aligned end address to munmap.
  * @uf: The userfaultfd list_head
- * @unlock: Set to true to drop the mmap_lock.  unlocking only happens on
- * success.
+ * @mas_detach: The maple state tracking the detached tree
+ * @locked_vm: a pointer to store the VM_LOCKED pages count.
  *
- * Return: 0 on success and drops the lock if so directed, error and leaves the
- * lock held otherwise.
+ * Return: 0 on success, -EPERM on mseal vmas, -ENOMEM otherwise
  */
-int
-do_vmi_align_munmap(struct vma_iterator *vmi, struct vm_area_struct *vma,
+static int
+vmi_gather_munmap_vmas(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		    struct mm_struct *mm, unsigned long start,
-		    unsigned long end, struct list_head *uf, bool unlock)
+		    unsigned long end, struct list_head *uf,
+		    struct ma_state *mas_detach, unsigned long *locked_vm)
 {
 	struct vm_area_struct *next = NULL;
-	struct maple_tree mt_detach;
 	int count = 0;
 	int error = -ENOMEM;
-	unsigned long locked_vm = 0;
-	MA_STATE(mas_detach, &mt_detach, 0, 0);
-	mt_init_flags(&mt_detach, vmi->mas.tree->ma_flags & MT_FLAGS_LOCK_MASK);
-	mt_on_stack(mt_detach);
 
 	/*
 	 * If we need to split any vma, do it now to save pain later.
@@ -789,8 +787,7 @@ do_vmi_align_munmap(struct vma_iterator
 			goto start_split_failed;
 		}
 
-		error = __split_vma(vmi, vma, start, 1);
-		if (error)
+		if (__split_vma(vmi, vma, start, 1))
 			goto start_split_failed;
 	}
 
@@ -807,20 +804,18 @@ do_vmi_align_munmap(struct vma_iterator
 
 		/* Does it split the end? */
 		if (next->vm_end > end) {
-			error = __split_vma(vmi, next, end, 0);
-			if (error)
+			if (__split_vma(vmi, next, end, 0))
 				goto end_split_failed;
 		}
 		vma_start_write(next);
-		mas_set(&mas_detach, count);
-		error = mas_store_gfp(&mas_detach, next, GFP_KERNEL);
-		if (error)
+		mas_set(mas_detach, count++);
+		if (mas_store_gfp(mas_detach, next, GFP_KERNEL))
 			goto munmap_gather_failed;
+
 		vma_mark_detached(next, true);
 		if (next->vm_flags & VM_LOCKED)
-			locked_vm += vma_pages(next);
+			*locked_vm += vma_pages(next);
 
-		count++;
 		if (unlikely(uf)) {
 			/*
 			 * If userfaultfd_unmap_prep returns an error the vmas
@@ -831,9 +826,7 @@ do_vmi_align_munmap(struct vma_iterator
 			 * split, despite we could. This is unlikely enough
 			 * failure that it's not worth optimizing it for.
 			 */
-			error = userfaultfd_unmap_prep(next, start, end, uf);
-
-			if (error)
+			if (userfaultfd_unmap_prep(next, start, end, uf))
 				goto userfaultfd_error;
 		}
 #ifdef CONFIG_DEBUG_VM_MAPLE_TREE
@@ -845,7 +838,7 @@ do_vmi_align_munmap(struct vma_iterator
 #if defined(CONFIG_DEBUG_VM_MAPLE_TREE)
 	/* Make sure no VMAs are about to be lost. */
 	{
-		MA_STATE(test, &mt_detach, 0, 0);
+		MA_STATE(test, mas_detach->tree, 0, 0);
 		struct vm_area_struct *vma_mas, *vma_test;
 		int test_count = 0;
 
@@ -865,6 +858,48 @@ do_vmi_align_munmap(struct vma_iterator
 	while (vma_iter_addr(vmi) > start)
 		vma_iter_prev_range(vmi);
 
+	return 0;
+
+userfaultfd_error:
+munmap_gather_failed:
+end_split_failed:
+modify_vma_failed:
+	abort_munmap_vmas(mas_detach);
+start_split_failed:
+map_count_exceeded:
+	return error;
+}
+
+/*
+ * do_vmi_align_munmap() - munmap the aligned region from @start to @end.
+ * @vmi: The vma iterator
+ * @vma: The starting vm_area_struct
+ * @mm: The mm_struct
+ * @start: The aligned start address to munmap.
+ * @end: The aligned end address to munmap.
+ * @uf: The userfaultfd list_head
+ * @unlock: Set to true to drop the mmap_lock.  unlocking only happens on
+ * success.
+ *
+ * Return: 0 on success and drops the lock if so directed, error and leaves the
+ * lock held otherwise.
+ */
+int do_vmi_align_munmap(struct vma_iterator *vmi, struct vm_area_struct *vma,
+		struct mm_struct *mm, unsigned long start, unsigned long end,
+		struct list_head *uf, bool unlock)
+{
+	struct maple_tree mt_detach;
+	MA_STATE(mas_detach, &mt_detach, 0, 0);
+	mt_init_flags(&mt_detach, vmi->mas.tree->ma_flags & MT_FLAGS_LOCK_MASK);
+	mt_on_stack(mt_detach);
+	int error;
+	unsigned long locked_vm = 0;
+
+	error = vmi_gather_munmap_vmas(vmi, vma, mm, start, end, uf,
+				       &mas_detach, &locked_vm);
+	if (error)
+		goto gather_failed;
+
 	error = vma_iter_clear_gfp(vmi, start, end, GFP_KERNEL);
 	if (error)
 		goto clear_tree_failed;
@@ -872,17 +907,11 @@ do_vmi_align_munmap(struct vma_iterator
 	/* Point of no return */
 	vmi_complete_munmap_vmas(vmi, vma, mm, start, end, unlock, &mas_detach,
 				 locked_vm);
-
 	return 0;
 
-modify_vma_failed:
 clear_tree_failed:
-userfaultfd_error:
-munmap_gather_failed:
-end_split_failed:
 	abort_munmap_vmas(&mas_detach);
-start_split_failed:
-map_count_exceeded:
+gather_failed:
 	validate_mm(mm);
 	return error;
 }
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

