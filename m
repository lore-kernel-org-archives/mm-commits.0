Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0042C3261
	for <mm-commits@vger.kernel.org>; Tue, 31 Mar 2026 00:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774917791; cv=none; b=sHsHyM2XTkhFOtu6hJgpwlC4DfKyJAp33+Axw2F1fYp4jbChMGGj2Q1ENxUqt41AU1rE9rfoPOIzyQLYzNTtY9TQuypBywR8E/AFNFY4JfJzbzkNFL/WOI5xBLXNqRyTJ0yJTqGmOua+hqD30Jo4kbg5jzKZShvFmaXcOPMeQmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774917791; c=relaxed/simple;
	bh=/5REoUmla8V9gp2zC1CaMHSVmr8mRxiGSacT8yGxcQ8=;
	h=Date:To:From:Subject:Message-Id; b=qwi6H39NBhLc2xQihg1jWcEMszhIQliSnoo0N+/HsEH3fOwoNwh/RV3eHyvDSyNJmgW7iuPGSOICWL9oZUqIpcsvbDt8gG9mXfqbby3dalHQzjCuDEuX0cu/Tjp7s3rkfsD0iokTvQrJDtTZk2t/u/6mmmn9CsbvpKZtCApbU70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OSmKjmV8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OSmKjmV8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F752C4CEF7;
	Tue, 31 Mar 2026 00:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774917791;
	bh=/5REoUmla8V9gp2zC1CaMHSVmr8mRxiGSacT8yGxcQ8=;
	h=Date:To:From:Subject:From;
	b=OSmKjmV88FPqLUYSlJ9PtA3atFVRoyrvSjsdDS1o16XjhGUMsFbyRlbJqkcnONDwo
	 xcIlvoBGaPJPCnR4hDkaobUid5V8rqw67HLHt4jdySvIyNTym9eCDGtYQb+Smlgs3f
	 1ci8fHSlfgsuOzBR8x0+qt7nLwiQR94Wq+78W+2U=
Date: Mon, 30 Mar 2026 17:43:10 -0700
To: mm-commits@vger.kernel.org,wei.liu@kernel.org,viro@zeniv.linux.org.uk,vigneshr@ti.com,vbabka@kernel.org,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,richard@nod.at,pfalcato@suse.de,miquel.raynal@bootlin.com,mhocko@suse.com,mcoquelin.stm32@gmail.com,martin.petersen@oracle.com,marc.dionne@auristor.com,longli@microsoft.com,liam.howlett@oracle.com,kys@microsoft.com,jannh@google.com,jack@suse.cz,haiyangz@microsoft.com,gregkh@linuxfoundation.org,dhowells@redhat.com,decui@microsoft.com,david@kernel.org,corbet@lwn.net,clemens@ladisch.de,brauner@kernel.org,bostroesser@gmail.com,arnd@arndb.de,alexandre.torgue@foss.st.com,alexander.shishkin@linux.intel.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-have-mmap_action_complete-handle-the-rmap-lock-and-unmap.patch removed from -mm tree
Message-Id: <20260331004311.0F752C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: have mmap_action_complete() handle the rmap lock and unmap
has been removed from the -mm tree.  Its filename was
     mm-have-mmap_action_complete-handle-the-rmap-lock-and-unmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: mm: have mmap_action_complete() handle the rmap lock and unmap
Date: Fri, 20 Mar 2026 22:39:33 +0000

Rather than have the callers handle this both the rmap lock release and
unmapping the VMA on error, handle it within the mmap_action_complete()
logic where it makes sense to, being careful not to unlock twice.

This simplifies the logic and makes it harder to make mistake with this,
while retaining correct behaviour with regard to avoiding deadlocks.

Also replace the call_action_complete() function with a direct invocation
of mmap_action_complete() as the abstraction is no longer required.

Also update the VMA tests to reflect this change.

Link: https://lkml.kernel.org/r/8d1ee8ebd3542d006a47e8382fb80cf5b57ecf10.1774045440.git.ljs@kernel.org
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Bodo Stroesser <bostroesser@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Dexuan Cui <decui@microsoft.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: K. Y. Srinivasan <kys@microsoft.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Long Li <longli@microsoft.com>
Cc: Marc Dionne <marc.dionne@auristor.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Richard Weinberger <richard@nod.at>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vignesh Raghavendra <vigneshr@ti.com>
Cc: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h                   |   19 +++++++++++++
 mm/util.c                       |   41 +++++++++++++-----------------
 mm/vma.c                        |   26 -------------------
 tools/testing/vma/include/dup.h |    8 -----
 4 files changed, 40 insertions(+), 54 deletions(-)

--- a/mm/internal.h~mm-have-mmap_action_complete-handle-the-rmap-lock-and-unmap
+++ a/mm/internal.h
@@ -1863,6 +1863,25 @@ static inline int io_remap_pfn_range_pre
 	return 0;
 }
 
+/*
+ * When we succeed an mmap action or just before we unmap a VMA on error, we
+ * need to ensure any rmap lock held is released. On unmap it's required to
+ * avoid a deadlock.
+ */
+static inline void maybe_rmap_unlock_action(struct vm_area_struct *vma,
+		struct mmap_action *action)
+{
+	struct file *file;
+
+	if (!action->hide_from_rmap_until_complete)
+		return;
+
+	VM_WARN_ON_ONCE(vma_is_anonymous(vma));
+	file = vma->vm_file;
+	i_mmap_unlock_write(file->f_mapping);
+	action->hide_from_rmap_until_complete = false;
+}
+
 #ifdef CONFIG_MMU_NOTIFIER
 static inline bool clear_flush_young_ptes_notify(struct vm_area_struct *vma,
 		unsigned long addr, pte_t *ptep, unsigned int nr)
--- a/mm/util.c~mm-have-mmap_action_complete-handle-the-rmap-lock-and-unmap
+++ a/mm/util.c
@@ -1219,13 +1219,7 @@ int compat_vma_mmap(struct file *file, s
 	action->hide_from_rmap_until_complete = false;
 
 	set_vma_from_desc(vma, &desc);
-	err = mmap_action_complete(vma, action);
-	if (err) {
-		const size_t len = vma_pages(vma) << PAGE_SHIFT;
-
-		do_munmap(current->mm, vma->vm_start, len, NULL);
-	}
-	return err;
+	return mmap_action_complete(vma, action);
 }
 EXPORT_SYMBOL(compat_vma_mmap);
 
@@ -1320,26 +1314,30 @@ again:
 static int mmap_action_finish(struct vm_area_struct *vma,
 			      struct mmap_action *action, int err)
 {
+	size_t len;
+
+	if (!err && action->success_hook)
+		err = action->success_hook(vma);
+
+	/* do_munmap() might take rmap lock, so release if held. */
+	maybe_rmap_unlock_action(vma, action);
+	if (!err)
+		return 0;
+
 	/*
 	 * If an error occurs, unmap the VMA altogether and return an error. We
 	 * only clear the newly allocated VMA, since this function is only
 	 * invoked if we do NOT merge, so we only clean up the VMA we created.
 	 */
-	if (err) {
-		if (action->error_hook) {
-			/* We may want to filter the error. */
-			err = action->error_hook(err);
-
-			/* The caller should not clear the error. */
-			VM_WARN_ON_ONCE(!err);
-		}
-		return err;
+	len = vma_pages(vma) << PAGE_SHIFT;
+	do_munmap(current->mm, vma->vm_start, len, NULL);
+	if (action->error_hook) {
+		/* We may want to filter the error. */
+		err = action->error_hook(err);
+		/* The caller should not clear the error. */
+		VM_WARN_ON_ONCE(!err);
 	}
-
-	if (action->success_hook)
-		return action->success_hook(vma);
-
-	return 0;
+	return err;
 }
 
 #ifdef CONFIG_MMU
@@ -1377,7 +1375,6 @@ EXPORT_SYMBOL(mmap_action_prepare);
  */
 int mmap_action_complete(struct vm_area_struct *vma,
 			 struct mmap_action *action)
-
 {
 	int err = 0;
 
--- a/mm/vma.c~mm-have-mmap_action_complete-handle-the-rmap-lock-and-unmap
+++ a/mm/vma.c
@@ -2729,30 +2729,6 @@ static bool can_set_ksm_flags_early(stru
 	return false;
 }
 
-static int call_action_complete(struct mmap_state *map,
-				struct mmap_action *action,
-				struct vm_area_struct *vma)
-{
-	int err;
-
-	err = mmap_action_complete(vma, action);
-
-	/* If we held the file rmap we need to release it. */
-	if (action->hide_from_rmap_until_complete) {
-		struct file *file = vma->vm_file;
-
-		i_mmap_unlock_write(file->f_mapping);
-	}
-
-	if (err) {
-		const size_t len = vma_pages(vma) << PAGE_SHIFT;
-
-		do_munmap(current->mm, vma->vm_start, len, NULL);
-	}
-
-	return err;
-}
-
 static unsigned long __mmap_region(struct file *file, unsigned long addr,
 		unsigned long len, vma_flags_t vma_flags,
 		unsigned long pgoff, struct list_head *uf)
@@ -2804,7 +2780,7 @@ static unsigned long __mmap_region(struc
 	__mmap_complete(&map, vma);
 
 	if (have_mmap_prepare && allocated_new) {
-		error = call_action_complete(&map, &desc.action, vma);
+		error = mmap_action_complete(vma, &desc.action);
 
 		if (error)
 			return error;
--- a/tools/testing/vma/include/dup.h~mm-have-mmap_action_complete-handle-the-rmap-lock-and-unmap
+++ a/tools/testing/vma/include/dup.h
@@ -1300,13 +1300,7 @@ static inline int compat_vma_mmap(struct
 	action->hide_from_rmap_until_complete = false;
 
 	set_vma_from_desc(vma, &desc);
-	err = mmap_action_complete(vma, action);
-	if (err) {
-		const size_t len = vma_pages(vma) << PAGE_SHIFT;
-
-		do_munmap(current->mm, vma->vm_start, len, NULL);
-	}
-	return err;
+	return mmap_action_complete(vma, action);
 }
 
 static inline void vma_iter_init(struct vma_iterator *vmi,
_

Patches currently in -mm which might be from ljs@kernel.org are

maintainers-update-mglru-entry-to-reflect-current-status.patch
selftests-mm-add-merge-test-for-partial-msealed-range.patch

