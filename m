Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88129C147
	for <mm-commits@vger.kernel.org>; Sat, 24 Aug 2024 01:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724464718; cv=none; b=Gv6b7ybDeNsLwlNoXNGCwoXViQzRWr4uZiFtHBDek6BaioYTAPy+2vTLIBP8VMyCzynrh3krpXb3SjO1LU1B/CKdRvI1FIFQMgX5fD7n8PCWs+jDVRBunfHlE9na8w+oHN2tjjfy5OOiaDf3qLkC1Mqi0c5oHlZCnWDJ4Y115CE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724464718; c=relaxed/simple;
	bh=o9sCxmfh9fXDS/Yky9vca41hz1AhLv6qBskZwpY0dsM=;
	h=Date:To:From:Subject:Message-Id; b=QrNZtpi3WlUZexHH02pmXpcxJWUXqUuRWPohtNEyadTbWe86m3HwihqY3H7+bratBkXRJCfT5jKgCZzi4/Rk4mJ2e3wRJkcvK8HmIOlpjOeIbewkGkk1B798rPoLxjinNf8hZ482trt6L8wMZcrsJXxjWmchVQJqUhmlGgfjflU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d1pdNlzw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d1pdNlzw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0236AC32786;
	Sat, 24 Aug 2024 01:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724464718;
	bh=o9sCxmfh9fXDS/Yky9vca41hz1AhLv6qBskZwpY0dsM=;
	h=Date:To:From:Subject:From;
	b=d1pdNlzwvt4dr8T7gIccdhx5W6EOykhtRchukPg15F0y7yY2M6Gvl8GiyIZxQgAOZ
	 qZWKe95YujtygcCHTSkHMXz0x3nx4CB8h0ASV89dnNQT0a9bh6MGGUKi+8rwj35Zij
	 QmErmYpQe7Nr5t85491TmcH5rxoUQn1BA/QgDQqA=
Date: Fri, 23 Aug 2024 18:58:37 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,spasswolf@web.de,sidhartha.kumar@oracle.com,paul@paul-moore.com,paulmck@kernel.org,olsajiri@gmail.com,lstoakes@gmail.com,lorenzo.stoakes@oracle.com,kees@kernel.org,Liam.Howlett@Oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-change-failure-of-map_fixed-to-restoring-the-gap-on-failure.patch added to mm-unstable branch
Message-Id: <20240824015838.0236AC32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: change failure of MAP_FIXED to restoring the gap on failure
has been added to the -mm mm-unstable branch.  Its filename is
     mm-change-failure-of-map_fixed-to-restoring-the-gap-on-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-change-failure-of-map_fixed-to-restoring-the-gap-on-failure.patch

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
Subject: mm: change failure of MAP_FIXED to restoring the gap on failure
Date: Thu, 22 Aug 2024 15:25:37 -0400

Prior to call_mmap(), the vmas that will be replaced need to clear the way
for what may happen in the call_mmap().  This clean up work includes
clearing the ptes and calling the close() vm_ops.  Some users do more
setup than can be restored by calling the vm_ops open() function.  It is
safer to store the gap in the vma tree in these cases.

That is to say that the failure scenario that existed before the MAP_FIXED
gap exposure is restored as it is safer than trying to undo a partial
mapping.

Since abort_munmap_vmas() is only reattaching vmas with this change, the
function is renamed to reattach_vmas().

There is also a secondary failure that may occur if there is not enough
memory to store the gap.  In this case, the vmas are reattached and
resources freed.  If the system cannot complete the call_mmap() and fails
to allocate with GFP_KERNEL, then the system will print a warning about
the failure.

Link: https://lkml.kernel.org/r/20240822192543.3359552-16-Liam.Howlett@oracle.com
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

 mm/mmap.c |    3 --
 mm/vma.c  |    4 +-
 mm/vma.h  |   78 +++++++++++++++++++++++++++++++++++++---------------
 3 files changed, 59 insertions(+), 26 deletions(-)

--- a/mm/mmap.c~mm-change-failure-of-map_fixed-to-restoring-the-gap-on-failure
+++ a/mm/mmap.c
@@ -1622,8 +1622,7 @@ unacct_error:
 		vm_unacct_memory(charged);
 
 abort_munmap:
-	if (vms.nr_pages)
-		abort_munmap_vmas(&mas_detach, vms.closed_vm_ops);
+	vms_abort_munmap_vmas(&vms, &mas_detach);
 	validate_mm(mm);
 	return error;
 }
--- a/mm/vma.c~mm-change-failure-of-map_fixed-to-restoring-the-gap-on-failure
+++ a/mm/vma.c
@@ -883,7 +883,7 @@ userfaultfd_error:
 munmap_gather_failed:
 end_split_failed:
 modify_vma_failed:
-	abort_munmap_vmas(mas_detach, /* closed = */ false);
+	reattach_vmas(mas_detach);
 start_split_failed:
 map_count_exceeded:
 	return error;
@@ -928,7 +928,7 @@ int do_vmi_align_munmap(struct vma_itera
 	return 0;
 
 clear_tree_failed:
-	abort_munmap_vmas(&mas_detach, /* closed = */ false);
+	reattach_vmas(&mas_detach);
 gather_failed:
 	validate_mm(mm);
 	return error;
--- a/mm/vma.h~mm-change-failure-of-map_fixed-to-restoring-the-gap-on-failure
+++ a/mm/vma.h
@@ -82,6 +82,22 @@ int vma_expand(struct vma_iterator *vmi,
 int vma_shrink(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	       unsigned long start, unsigned long end, pgoff_t pgoff);
 
+static inline int vma_iter_store_gfp(struct vma_iterator *vmi,
+			struct vm_area_struct *vma, gfp_t gfp)
+
+{
+	if (vmi->mas.status != ma_start &&
+	    ((vmi->mas.index > vma->vm_start) || (vmi->mas.last < vma->vm_start)))
+		vma_iter_invalidate(vmi);
+
+	__mas_set_range(&vmi->mas, vma->vm_start, vma->vm_end - 1);
+	mas_store_gfp(&vmi->mas, vma, gfp);
+	if (unlikely(mas_is_err(&vmi->mas)))
+		return -ENOMEM;
+
+	return 0;
+}
+
 /*
  * init_vma_munmap() - Initializer wrapper for vma_munmap_struct
  * @vms: The vma munmap struct
@@ -127,24 +143,58 @@ void vms_clean_up_area(struct vma_munmap
 		struct ma_state *mas_detach, bool mm_wr_locked);
 
 /*
- * abort_munmap_vmas - Undo any munmap work and free resources
+ * reattach_vmas() - Undo any munmap work and free resources
+ * @mas_detach: The maple state with the detached maple tree
  *
  * Reattach any detached vmas and free up the maple tree used to track the vmas.
  */
-static inline void abort_munmap_vmas(struct ma_state *mas_detach, bool closed)
+static inline void reattach_vmas(struct ma_state *mas_detach)
 {
 	struct vm_area_struct *vma;
 
 	mas_set(mas_detach, 0);
-	mas_for_each(mas_detach, vma, ULONG_MAX) {
+	mas_for_each(mas_detach, vma, ULONG_MAX)
 		vma_mark_detached(vma, false);
-		if (closed && vma->vm_ops && vma->vm_ops->open)
-			vma->vm_ops->open(vma);
-	}
 
 	__mt_destroy(mas_detach->tree);
 }
 
+/*
+ * vms_abort_munmap_vmas() - Undo as much as possible from an aborted munmap()
+ * operation.
+ * @vms: The vma unmap structure
+ * @mas_detach: The maple state with the detached maple tree
+ *
+ * Reattach any detached vmas, free up the maple tree used to track the vmas.
+ * If that's not possible because the ptes are cleared (and vm_ops->closed() may
+ * have been called), then a NULL is written over the vmas and the vmas are
+ * removed (munmap() completed).
+ */
+static inline void vms_abort_munmap_vmas(struct vma_munmap_struct *vms,
+		struct ma_state *mas_detach)
+{
+	if (!vms->nr_pages)
+		return;
+
+	if (vms->clear_ptes)
+		return reattach_vmas(mas_detach);
+
+	/*
+	 * Aborting cannot just call the vm_ops open() because they are often
+	 * not symmetrical and state data has been lost.  Resort to the old
+	 * failure method of leaving a gap where the MAP_FIXED mapping failed.
+	 */
+	if (unlikely(vma_iter_store_gfp(vms->vmi, NULL, GFP_KERNEL))) {
+		pr_warn_once("%s: (%d) Unable to abort munmap() operation\n",
+			     current->comm, current->pid);
+		/* Leaving vmas detached and in-tree may hamper recovery */
+		reattach_vmas(mas_detach);
+	} else {
+		/* Clean up the insertion of unfortunate the gap */
+		vms_complete_munmap_vmas(vms, mas_detach);
+	}
+}
+
 int
 do_vmi_align_munmap(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		    struct mm_struct *mm, unsigned long start,
@@ -297,22 +347,6 @@ static inline struct vm_area_struct *vma
 	return mas_prev(&vmi->mas, min);
 }
 
-static inline int vma_iter_store_gfp(struct vma_iterator *vmi,
-			struct vm_area_struct *vma, gfp_t gfp)
-{
-	if (vmi->mas.status != ma_start &&
-	    ((vmi->mas.index > vma->vm_start) || (vmi->mas.last < vma->vm_start)))
-		vma_iter_invalidate(vmi);
-
-	__mas_set_range(&vmi->mas, vma->vm_start, vma->vm_end - 1);
-	mas_store_gfp(&vmi->mas, vma, gfp);
-	if (unlikely(mas_is_err(&vmi->mas)))
-		return -ENOMEM;
-
-	return 0;
-}
-
-
 /*
  * These three helpers classifies VMAs for virtual memory accounting.
  */
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

