Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 372786AFAE
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423553; cv=none; b=OpgFK6TNsE/CkY0ivsHtodLZ2HTJ9x0IEEUQvrzs67J59Mjzhv2O4/nHISbU9SRPq9fryD3JMSb6AgnI7LeesMUKkrV2ndDD7TeCAkSSZ7UKhA8L/nu6nVkS9oJORSM3YwnVKerI6oWG1bg7vx2+Fnzh/WjJmpWRgXKzHndgJyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423553; c=relaxed/simple;
	bh=fRcHdkx0NguiqaBl0Zm+mRKW0+AdnWO4SbnSeZI28kw=;
	h=Date:To:From:Subject:Message-Id; b=rHkCxQ9bCzMP0Vk8aLJAvJIZcZS+WkmV8ELKtRxOr/8ljrh/cyUJsk9dLiMIoCQjfPMAHTzEjlK3T81ASXqO3PgwqLgQAfsQ3m8Xtl/9mBE+ipB1R9jbafoFWs7KMXTuAHsUpCsSbJsyzRZbtKKvdEgnmO34UlSOJhV/5HVJ73Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lBXcOi89; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lBXcOi89"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C1BEC4CEC2;
	Wed,  4 Sep 2024 04:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423553;
	bh=fRcHdkx0NguiqaBl0Zm+mRKW0+AdnWO4SbnSeZI28kw=;
	h=Date:To:From:Subject:From;
	b=lBXcOi89Dtp4Cahsfub4dNQ+8SE1w+sGQzDiWkiOYNGmNkL9gNEEnphyShZY4YBWz
	 Yp8pbz9P3X3e35iM0fBHfAQ6AZykCN3UShzKKaogCwtPKFDCnVdkKOcqeG155mYu3k
	 Llc9STcnhWrkwLoeJz/JdLuCGOr83wLBOCrrFpjM=
Date: Tue, 03 Sep 2024 21:19:12 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,spasswolf@web.de,sidhartha.kumar@oracle.com,paul@paul-moore.com,paulmck@kernel.org,olsajiri@gmail.com,lstoakes@gmail.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,kees@kernel.org,jeffxu@chromium.org,broonie@kernel.org,Liam.Howlett@Oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vma-extract-the-gathering-of-vmas-from-do_vmi_align_munmap.patch removed from -mm tree
Message-Id: <20240904041913.0C1BEC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: extract the gathering of vmas from do_vmi_align_munmap()
has been removed from the -mm tree.  Its filename was
     mm-vma-extract-the-gathering-of-vmas-from-do_vmi_align_munmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


