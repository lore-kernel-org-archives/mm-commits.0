Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94F7BA34
	for <mm-commits@vger.kernel.org>; Sat, 24 Aug 2024 01:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724464706; cv=none; b=JgIeI33wXkfelBsMGyCtvC9Q9V87nnvQXW8jw63MrAQLnkFudCoukGAq5qTDk42O++IivqnULFJ5UAy7UDxGKrnDSkVQ/ADsaVMWObpglYElyDBK+kHnDo3J3EDA4oAMtSD9HdAJbI9pHbRn3VGbN3ArRnCasH67mknguDrpX00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724464706; c=relaxed/simple;
	bh=VAUrtcZblmzurJwjfpLe6AgtlRCWkHYxVFOQ9jTkmd8=;
	h=Date:To:From:Subject:Message-Id; b=OMNWKgawPPWyUfnmcxQT5KSXwgUIIIGiXYm1xkajDiWKj+6qm6GBzylmzbScUA79FfwLOxXyZ0IMMv73c3YPWFqurXIbTnotH4tlg2LjFo5OzitiuyEgTwgRL7UUGrLzUXKH9jgEwDN5CBd/CsdOTGT8boMvJxIlnKryqG38lxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wDfI9Gss; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wDfI9Gss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C9AC32786;
	Sat, 24 Aug 2024 01:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724464706;
	bh=VAUrtcZblmzurJwjfpLe6AgtlRCWkHYxVFOQ9jTkmd8=;
	h=Date:To:From:Subject:From;
	b=wDfI9Gss63do7f8tcMQvvOo+TS0VJyo4P25w7Ekb27dKKm8wUKC0LTOQ7f+4+rius
	 l9HTHV76de6OUcQpqlPdfF/7Zvwjn9BWG7xnQEIscQjtPcBQ1t5QEl0+lpAiB/NAhk
	 1vSWF79MpgsxvWO4gt/f/Q7esxpkYDxSDPUOyKqE=
Date: Fri, 23 Aug 2024 18:58:25 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,spasswolf@web.de,sidhartha.kumar@oracle.com,paul@paul-moore.com,paulmck@kernel.org,olsajiri@gmail.com,lstoakes@gmail.com,lorenzo.stoakes@oracle.com,kees@kernel.org,Liam.Howlett@Oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-reposition-vma-iterator-in-mmap_region.patch added to mm-unstable branch
Message-Id: <20240824015826.17C9AC32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mmap: reposition vma iterator in mmap_region()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-reposition-vma-iterator-in-mmap_region.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-reposition-vma-iterator-in-mmap_region.patch

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
Subject: mm/mmap: reposition vma iterator in mmap_region()
Date: Thu, 22 Aug 2024 15:25:33 -0400

Instead of moving (or leaving) the vma iterator pointing at the previous
vma, leave it pointing at the insert location.  Pointing the vma iterator
at the insert location allows for a cleaner walk of the vma tree for
MAP_FIXED and the no expansion cases.

The vma_prev() call in the case of merging the previous vma is equivalent
to vma_iter_prev_range(), since the vma iterator will be pointing to the
location just before the previous vma.

This change needs to export abort_munmap_vmas() from mm/vma.

Link: https://lkml.kernel.org/r/20240822192543.3359552-12-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Bert Karwatzki <spasswolf@web.de>
Cc: Jiri Olsa <olsajiri@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   38 ++++++++++++++++++++++----------------
 mm/vma.c  |   16 ----------------
 mm/vma.h  |   16 ++++++++++++++++
 3 files changed, 38 insertions(+), 32 deletions(-)

--- a/mm/mmap.c~mm-mmap-reposition-vma-iterator-in-mmap_region
+++ a/mm/mmap.c
@@ -1400,21 +1400,22 @@ unsigned long mmap_region(struct file *f
 		mas_init(&mas_detach, &mt_detach, /* addr = */ 0);
 		/* Prepare to unmap any existing mapping in the area */
 		if (vms_gather_munmap_vmas(&vms, &mas_detach))
-			return -ENOMEM;
+			goto gather_failed;
 
 		/* Remove any existing mappings from the vma tree */
 		if (vma_iter_clear_gfp(&vmi, addr, end, GFP_KERNEL))
-			return -ENOMEM;
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
@@ -1427,11 +1428,8 @@ unsigned long mmap_region(struct file *f
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
@@ -1452,19 +1450,21 @@ unsigned long mmap_region(struct file *f
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
@@ -1625,6 +1625,12 @@ unacct_error:
 		vm_unacct_memory(charged);
 	validate_mm(mm);
 	return error;
+
+clear_tree_failed:
+	abort_munmap_vmas(&mas_detach);
+gather_failed:
+	validate_mm(mm);
+	return -ENOMEM;
 }
 
 static int __vm_munmap(unsigned long start, size_t len, bool unlock)
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

maple_tree-remove-rcu_read_lock-from-mt_validate.patch
mm-vma-correctly-position-vma_iterator-in-__split_vma.patch
mm-vma-introduce-abort_munmap_vmas.patch
mm-vma-introduce-vmi_complete_munmap_vmas.patch
mm-vma-extract-the-gathering-of-vmas-from-do_vmi_align_munmap.patch
mm-vma-introduce-vma_munmap_struct-for-use-in-munmap-operations.patch
mm-vma-change-munmap-to-use-vma_munmap_struct-for-accounting-and-surrounding-vmas.patch
mm-vma-change-munmap-to-use-vma_munmap_struct-for-accounting-and-surrounding-vmas-fix.patch
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

