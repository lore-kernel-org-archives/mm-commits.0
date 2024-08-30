Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D171BFE11
	for <mm-commits@vger.kernel.org>; Fri, 30 Aug 2024 22:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725055887; cv=none; b=hV9/b/Uio2J0UO5CURuSFmhDUMl63X1REjG9jsETyfM1znrr1f5goXmR4TIa53gAi/L2t1/Dwey8zi8KZeKHGE4BUjff38DFhFMnw+NCUYCZTs8q/hfX0hfZET+e9NzTOcUOvk95JhAYCttytKWkWpTIfjuTYvXlJEhR+jIFi8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725055887; c=relaxed/simple;
	bh=iVRSKRTJtJcZhGqucjw55jv/VIwJ/ZHPGnhsl5/dLGo=;
	h=Date:To:From:Subject:Message-Id; b=efXFDjttOK9fz1NDDFQou+5keJArixY83DyMumBQ2UEJmmKVRuzJO+5DNQhDQ/zBpS2vcOUmEwLy5kPAyj7e/HxRB5STe9Zg0cEZv8nU4r2gUdoDkNLDWO5kF9JtyOac6YsFZXkix00HDXLq4hNaGG2ldmK3LRtlir4XLmdkDi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m+iwXMFK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m+iwXMFK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E12EC4CEC6;
	Fri, 30 Aug 2024 22:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725055887;
	bh=iVRSKRTJtJcZhGqucjw55jv/VIwJ/ZHPGnhsl5/dLGo=;
	h=Date:To:From:Subject:From;
	b=m+iwXMFKWBPmIgDgsXtZhl/P/H+b7aiYnUxJHgPPKNmjAJsMyZrl1Sr4k99COn/6a
	 7z1tlDP1C2b9x+XPH9/JzyE1q3FwU6EG7bmO0nbPTgUxaU1KhrTW+XmMQ/XptugjbP
	 QKA8iQp7Uxx4sA/ea22aVdAbqeWgx9EbxPu5GVbg=
Date: Fri, 30 Aug 2024 15:11:26 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,spasswolf@web.de,sidhartha.kumar@oracle.com,paul@paul-moore.com,paulmck@kernel.org,olsajiri@gmail.com,lstoakes@gmail.com,lorenzo.stoakes@oracle.com,kees@kernel.org,jeffxu@chromium.org,broonie@kernel.org,Liam.Howlett@Oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-change-failure-of-map_fixed-to-restoring-the-gap-on-failure.patch added to mm-unstable branch
Message-Id: <20240830221127.2E12EC4CEC6@smtp.kernel.org>
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
Date: Fri, 30 Aug 2024 00:00:55 -0400

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

Link: https://lkml.kernel.org/r/20240830040101.822209-16-Liam.Howlett@oracle.com
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

 mm/mmap.c |    3 -
 mm/vma.c  |    4 +-
 mm/vma.h  |   80 +++++++++++++++++++++++++++++++++++++---------------
 3 files changed, 61 insertions(+), 26 deletions(-)

--- a/mm/mmap.c~mm-change-failure-of-map_fixed-to-restoring-the-gap-on-failure
+++ a/mm/mmap.c
@@ -1623,8 +1623,7 @@ unacct_error:
 		vm_unacct_memory(charged);
 
 abort_munmap:
-	if (vms.nr_pages)
-		abort_munmap_vmas(&mas_detach, vms.closed_vm_ops);
+	vms_abort_munmap_vmas(&vms, &mas_detach);
 gather_failed:
 	validate_mm(mm);
 	return error;
--- a/mm/vma.c~mm-change-failure-of-map_fixed-to-restoring-the-gap-on-failure
+++ a/mm/vma.c
@@ -878,7 +878,7 @@ userfaultfd_error:
 munmap_gather_failed:
 end_split_failed:
 modify_vma_failed:
-	abort_munmap_vmas(mas_detach, /* closed = */ false);
+	reattach_vmas(mas_detach);
 start_split_failed:
 map_count_exceeded:
 	return error;
@@ -923,7 +923,7 @@ int do_vmi_align_munmap(struct vma_itera
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
 #ifdef CONFIG_MMU
 /*
  * init_vma_munmap() - Initializer wrapper for vma_munmap_struct
@@ -129,24 +145,60 @@ void vms_clean_up_area(struct vma_munmap
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
+	struct ma_state *mas = &vms->vmi->mas;
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
+	mas_set_range(mas, vms->start, vms->end);
+	if (unlikely(mas_store_gfp(mas, NULL, GFP_KERNEL))) {
+		pr_warn_once("%s: (%d) Unable to abort munmap() operation\n",
+			     current->comm, current->pid);
+		/* Leaving vmas detached and in-tree may hamper recovery */
+		reattach_vmas(mas_detach);
+	} else {
+		/* Clean up the insertion of the unfortunate gap */
+		vms_complete_munmap_vmas(vms, mas_detach);
+	}
+}
+
 int
 do_vmi_align_munmap(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		    struct mm_struct *mm, unsigned long start,
@@ -299,22 +351,6 @@ static inline struct vm_area_struct *vma
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

