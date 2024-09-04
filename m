Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2060178C90
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423569; cv=none; b=erNy5yOrX6EdROsHVqyKEbljkw0Po0sanreNrVzInqoTUeL/8z2GAM2dgf0qVU1DkjrFb6GJ2P+/b5badg/J1JrRt/S+J9ISXpkeyz2WGxdYvtcHHaU/U2aBP0L/TcN1qLuPfj8GTwKSKfIN6se89Leu6NmFFGgv8BgvMOGUdeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423569; c=relaxed/simple;
	bh=/jZQLZaR5OrT+YTVXQUCvxStfoxswzYe6gQtcWBXrQc=;
	h=Date:To:From:Subject:Message-Id; b=qxpQC+3PyKDtFlyu8kLMBTyEqoWEnhL3FzO02Wh/kXjGVpMJWsK8Tw3INFSuW6guHJfG4hg+QjJioR3ikkoJadeXnmTkUJeDb76HObdHK7J/ECAHoACEh2lk6W5cDLXlg2ecDouKvrKdZai3pWnA/g9GSspN0IN9eAX3JVISTL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GlBhL8/w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GlBhL8/w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 821CAC4CEC2;
	Wed,  4 Sep 2024 04:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423568;
	bh=/jZQLZaR5OrT+YTVXQUCvxStfoxswzYe6gQtcWBXrQc=;
	h=Date:To:From:Subject:From;
	b=GlBhL8/wGc/OsmsIKL6jBwGLjUKmtfe34Ov7Id+2DFVNZu8qHkH0Dak1gfl5OYivw
	 JWMlG4WatB7+HSnqfBCOOlsP9hvxoohcdksLA7YXdWqY2ptljWgR9qQiR/CRAl6Bl/
	 lzoTe3QJWv2IQ4td6xLHr+xDQD3xpByJMYjcFet4=
Date: Tue, 03 Sep 2024 21:19:28 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,spasswolf@web.de,sidhartha.kumar@oracle.com,paul@paul-moore.com,paulmck@kernel.org,olsajiri@gmail.com,lstoakes@gmail.com,lorenzo.stoakes@oracle.com,kees@kernel.org,jeffxu@chromium.org,broonie@kernel.org,Liam.Howlett@Oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-change-failure-of-map_fixed-to-restoring-the-gap-on-failure.patch removed from -mm tree
Message-Id: <20240904041928.821CAC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: change failure of MAP_FIXED to restoring the gap on failure
has been removed from the -mm tree.  Its filename was
     mm-change-failure-of-map_fixed-to-restoring-the-gap-on-failure.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[lorenzo.stoakes@oracle.com: fix off-by-one error in vms_abort_munmap_vmas()]
  Link: https://lkml.kernel.org/r/52ee7eb3-955c-4ade-b5f0-28fed8ba3d0b@lucifer.local
Link: https://lkml.kernel.org/r/20240830040101.822209-16-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
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
+	mas_set_range(mas, vms->start, vms->end - 1);
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


