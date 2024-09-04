Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E4978C93
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423563; cv=none; b=RlMtmhJsyWlnIKMePlixwXDpDGcM5F5cw/Q1qRPFl3kM1Ww2SPlKuMpx7OsiREkIFqjnNVMGM6ftwHzjXr3ZDYy/6eGDzGVip295ry6A/Z9vwjQwz6H8OMF9Jas6CzTZntRAAAn6wDIF8Zg6ckaZ1AbP/SsFIWMSzvYBKO9pwmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423563; c=relaxed/simple;
	bh=n3ykt1wk9uhh2Ru+XsqHm0dOHxGEbO/HohPEI/njXtw=;
	h=Date:To:From:Subject:Message-Id; b=AhIo+e/wQ0w4qDC0oporCWwlHrbajB2vay4UHkjsgLPxbhtrF9N5q52t12Yjg8O3xhMIKXbEn85AOUpYfSLrzDVUYRKfNg4ca7Qk6wn1w58v17VRd1nGTJVEn2Mpfi7WNHMSuSdKdGg0gmDD5hdnR7ERs17+FtIYeO4QzWqF27Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ua35HCuO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ua35HCuO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9811C4CEC2;
	Wed,  4 Sep 2024 04:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423562;
	bh=n3ykt1wk9uhh2Ru+XsqHm0dOHxGEbO/HohPEI/njXtw=;
	h=Date:To:From:Subject:From;
	b=ua35HCuO2J24WysB3wNd0WJeDHiaRb58BrWzTfNwTXu/gRgr/bWWeJxnfvr27nTIE
	 VeEKwhvjVJO82eNhOyczW2n0dSe57gWrH/rSgXLBuuInJ3rQuBdPzSbMf2yPt++JxW
	 FNUu3lp64tKI2mxOK1U949KtcILIt2LduzqrAJ8c=
Date: Tue, 03 Sep 2024 21:19:22 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,spasswolf@web.de,sidhartha.kumar@oracle.com,paul@paul-moore.com,paulmck@kernel.org,olsajiri@gmail.com,lstoakes@gmail.com,lorenzo.stoakes@oracle.com,kees@kernel.org,jeffxu@chromium.org,broonie@kernel.org,Liam.Howlett@Oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-reposition-vma-iterator-in-mmap_region.patch removed from -mm tree
Message-Id: <20240904041922.D9811C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mmap: reposition vma iterator in mmap_region()
has been removed from the -mm tree.  Its filename was
     mm-mmap-reposition-vma-iterator-in-mmap_region.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm/mmap: reposition vma iterator in mmap_region()
Date: Fri, 30 Aug 2024 00:00:51 -0400

Instead of moving (or leaving) the vma iterator pointing at the previous
vma, leave it pointing at the insert location.  Pointing the vma iterator
at the insert location allows for a cleaner walk of the vma tree for
MAP_FIXED and the no expansion cases.

The vma_prev() call in the case of merging the previous vma is equivalent
to vma_iter_prev_range(), since the vma iterator will be pointing to the
location just before the previous vma.

This change needs to export abort_munmap_vmas() from mm/vma.

Link: https://lkml.kernel.org/r/20240830040101.822209-12-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
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

 mm/mmap.c |   40 +++++++++++++++++++++++-----------------
 mm/vma.c  |   16 ----------------
 mm/vma.h  |   16 ++++++++++++++++
 3 files changed, 39 insertions(+), 33 deletions(-)

--- a/mm/mmap.c~mm-mmap-reposition-vma-iterator-in-mmap_region
+++ a/mm/mmap.c
@@ -1401,21 +1401,23 @@ unsigned long mmap_region(struct file *f
 		/* Prepare to unmap any existing mapping in the area */
 		error = vms_gather_munmap_vmas(&vms, &mas_detach);
 		if (error)
-			return error;
+			goto gather_failed;
 
 		/* Remove any existing mappings from the vma tree */
-		if (vma_iter_clear_gfp(&vmi, addr, end, GFP_KERNEL))
-			return -ENOMEM;
+		error = vma_iter_clear_gfp(&vmi, addr, end, GFP_KERNEL);
+		if (error)
+			goto clear_tree_failed;
 
 		/* Unmap any existing mapping in the area */
 		vms_complete_munmap_vmas(&vms, &mas_detach);
 		next = vms.next;
 		prev = vms.prev;
-		vma_prev(&vmi);
 		vma = NULL;
 	} else {
 		next = vma_next(&vmi);
 		prev = vma_prev(&vmi);
+		if (prev)
+			vma_iter_next_range(&vmi);
 	}
 
 	/*
@@ -1428,11 +1430,8 @@ unsigned long mmap_region(struct file *f
 		vm_flags |= VM_ACCOUNT;
 	}
 
-	if (vm_flags & VM_SPECIAL) {
-		if (prev)
-			vma_iter_next_range(&vmi);
+	if (vm_flags & VM_SPECIAL)
 		goto cannot_expand;
-	}
 
 	/* Attempt to expand an old mapping */
 	/* Check next */
@@ -1453,19 +1452,21 @@ unsigned long mmap_region(struct file *f
 		merge_start = prev->vm_start;
 		vma = prev;
 		vm_pgoff = prev->vm_pgoff;
-	} else if (prev) {
-		vma_iter_next_range(&vmi);
+		vma_prev(&vmi); /* Equivalent to going to the previous range */
 	}
 
-	/* Actually expand, if possible */
-	if (vma &&
-	    !vma_expand(&vmi, vma, merge_start, merge_end, vm_pgoff, next)) {
-		khugepaged_enter_vma(vma, vm_flags);
-		goto expanded;
+	if (vma) {
+		/* Actually expand, if possible */
+		if (!vma_expand(&vmi, vma, merge_start, merge_end, vm_pgoff, next)) {
+			khugepaged_enter_vma(vma, vm_flags);
+			goto expanded;
+		}
+
+		/* If the expand fails, then reposition the vma iterator */
+		if (unlikely(vma == prev))
+			vma_iter_set(&vmi, addr);
 	}
 
-	if (vma == prev)
-		vma_iter_set(&vmi, addr);
 cannot_expand:
 
 	/*
@@ -1624,6 +1625,11 @@ free_vma:
 unacct_error:
 	if (charged)
 		vm_unacct_memory(charged);
+
+clear_tree_failed:
+	if (vms.vma_count)
+		abort_munmap_vmas(&mas_detach);
+gather_failed:
 	validate_mm(mm);
 	return error;
 }
--- a/mm/vma.c~mm-mmap-reposition-vma-iterator-in-mmap_region
+++ a/mm/vma.c
@@ -647,22 +647,6 @@ again:
 }
 
 /*
- * abort_munmap_vmas - Undo any munmap work and free resources
- *
- * Reattach any detached vmas and free up the maple tree used to track the vmas.
- */
-static inline void abort_munmap_vmas(struct ma_state *mas_detach)
-{
-	struct vm_area_struct *vma;
-
-	mas_set(mas_detach, 0);
-	mas_for_each(mas_detach, vma, ULONG_MAX)
-		vma_mark_detached(vma, false);
-
-	__mt_destroy(mas_detach->tree);
-}
-
-/*
  * vms_complete_munmap_vmas() - Finish the munmap() operation
  * @vms: The vma munmap struct
  * @mas_detach: The maple state of the detached vmas
--- a/mm/vma.h~mm-mmap-reposition-vma-iterator-in-mmap_region
+++ a/mm/vma.h
@@ -116,6 +116,22 @@ int vms_gather_munmap_vmas(struct vma_mu
 void vms_complete_munmap_vmas(struct vma_munmap_struct *vms,
 		struct ma_state *mas_detach);
 
+/*
+ * abort_munmap_vmas - Undo any munmap work and free resources
+ *
+ * Reattach any detached vmas and free up the maple tree used to track the vmas.
+ */
+static inline void abort_munmap_vmas(struct ma_state *mas_detach)
+{
+	struct vm_area_struct *vma;
+
+	mas_set(mas_detach, 0);
+	mas_for_each(mas_detach, vma, ULONG_MAX)
+		vma_mark_detached(vma, false);
+
+	__mt_destroy(mas_detach->tree);
+}
+
 int
 do_vmi_align_munmap(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		    struct mm_struct *mm, unsigned long start,
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


