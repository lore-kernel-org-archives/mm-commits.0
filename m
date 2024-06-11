Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5212C249E5
	for <mm-commits@vger.kernel.org>; Tue, 11 Jun 2024 18:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718130424; cv=none; b=S1B+pPeJzhcO/7XjlMayCYFgRDSy6Cu7R62f6zxUoN2rOsvGNB/UUlI2hjtB9Lvu1LqS/yHmFwz0ZpzwfXUGGSVfN0VX3dWD7ntXrq8h4A8ym+/YTZOjCfQDxNEzlcrHaChePJkwq4wVpAdf4SGoDsCLj8/cClNh4WiWiHWFwwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718130424; c=relaxed/simple;
	bh=N9rj5MzDcjgnGwCi72WKo/EUhbTYiRsuS7melj+giHE=;
	h=Date:To:From:Subject:Message-Id; b=oT2vTTgmOJgA27XAQiSSUCNBQMHlQ0pRXwqdrZ0Achu8NPjvtuwIFj7TaH/1vyAFpnHYkGuUmw5397RQtgYCRQlioUqSi3ebDWvOTAcqUKM2weyno0tgK9dHPONNJbRghQn6aGRfkwcP8Lfn1NGsBtDzjMsu+LL200Ap+FW0QIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Rr9Vj3R+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Rr9Vj3R+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2A87C2BD10;
	Tue, 11 Jun 2024 18:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718130423;
	bh=N9rj5MzDcjgnGwCi72WKo/EUhbTYiRsuS7melj+giHE=;
	h=Date:To:From:Subject:From;
	b=Rr9Vj3R+IBoBc3UOZonojToWuaiGFLWATiDMSqyzUea7gPoBjmTjYyq4yfscfD6BO
	 G3xy6F8vLtX7fY4JAbFVRqcTeSWrtck8JbhmhFgi758Z3wnr23rEDtGFooXhsaTTzB
	 +R8I2pzgR8betVJej4udCZFEyW7QAYBDVdOcbRxA=
Date: Tue, 11 Jun 2024 11:27:03 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,lstoakes@gmail.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-extract-the-gathering-of-vmas-from-do_vmi_align_munmap.patch added to mm-unstable branch
Message-Id: <20240611182703.D2A87C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mmap: extract the gathering of vmas from do_vmi_align_munmap()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-extract-the-gathering-of-vmas-from-do_vmi_align_munmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-extract-the-gathering-of-vmas-from-do_vmi_align_munmap.patch

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
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: mm/mmap: extract the gathering of vmas from do_vmi_align_munmap()
Date: Tue, 11 Jun 2024 14:01:56 -0400

Create vmi_gather_munmap_vmas() to handle the gathering of vmas into a
detached maple tree for removal later.  Part of the gathering is the
splitting of vmas that span the boundary.

Link: https://lkml.kernel.org/r/20240611180200.711239-5-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   82 ++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 58 insertions(+), 24 deletions(-)

--- a/mm/mmap.c~mm-mmap-extract-the-gathering-of-vmas-from-do_vmi_align_munmap
+++ a/mm/mmap.c
@@ -2656,32 +2656,29 @@ vmi_complete_munmap_vmas(struct vma_iter
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
  *
- * Return: 0 on success and drops the lock if so directed, error and leaves the
- * lock held otherwise.
+ * Return: 0 on success
  */
 static int
-do_vmi_align_munmap(struct vma_iterator *vmi, struct vm_area_struct *vma,
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
@@ -2720,15 +2717,14 @@ do_vmi_align_munmap(struct vma_iterator
 				goto end_split_failed;
 		}
 		vma_start_write(next);
-		mas_set(&mas_detach, count);
-		error = mas_store_gfp(&mas_detach, next, GFP_KERNEL);
+		mas_set(mas_detach, count++);
+		if (next->vm_flags & VM_LOCKED)
+			*locked_vm += vma_pages(next);
+
+		error = mas_store_gfp(mas_detach, next, GFP_KERNEL);
 		if (error)
 			goto munmap_gather_failed;
 		vma_mark_detached(next, true);
-		if (next->vm_flags & VM_LOCKED)
-			locked_vm += vma_pages(next);
-
-		count++;
 		if (unlikely(uf)) {
 			/*
 			 * If userfaultfd_unmap_prep returns an error the vmas
@@ -2753,7 +2749,7 @@ do_vmi_align_munmap(struct vma_iterator
 #if defined(CONFIG_DEBUG_VM_MAPLE_TREE)
 	/* Make sure no VMAs are about to be lost. */
 	{
-		MA_STATE(test, &mt_detach, 0, 0);
+		MA_STATE(test, mas_detach->tree, 0, 0);
 		struct vm_area_struct *vma_mas, *vma_test;
 		int test_count = 0;
 
@@ -2773,6 +2769,48 @@ do_vmi_align_munmap(struct vma_iterator
 	while (vma_iter_addr(vmi) > start)
 		vma_iter_prev_range(vmi);
 
+	return 0;
+
+userfaultfd_error:
+munmap_gather_failed:
+end_split_failed:
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
+static int
+do_vmi_align_munmap(struct vma_iterator *vmi, struct vm_area_struct *vma,
+		    struct mm_struct *mm, unsigned long start,
+		    unsigned long end, struct list_head *uf, bool unlock)
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
@@ -2783,12 +2821,8 @@ do_vmi_align_munmap(struct vma_iterator
 	return 0;
 
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

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

mm-mmap-correctly-position-vma_iterator-in-__split_vma.patch
mm-mmap-introduce-abort_munmap_vmas.patch
mm-mmap-introduce-vmi_complete_munmap_vmas.patch
mm-mmap-extract-the-gathering-of-vmas-from-do_vmi_align_munmap.patch
mm-mmap-introduce-vma_munmap_struct-for-use-in-munmap-operations.patch
mm-mmap-change-munmap-to-use-vma_munmap_struct-for-accounting-and-surrounding-vmas.patch
mm-mmap-extract-validate_mm-from-vma_complete.patch
mm-mmap-use-split-munmap-calls-for-map_fixed.patch

