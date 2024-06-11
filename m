Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70DDC74267
	for <mm-commits@vger.kernel.org>; Tue, 11 Jun 2024 18:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718130422; cv=none; b=DhFnS2h4JbtdUvzy/hwR1JS19I6F6JwtgcxLOOdSHsy39NZDoIYecfiyi+BoKOCLFz1tYMeC+xmFqLkr//6q7KGXWiQy6g+klD+aGLBWBpiXG29mbiNzLcOQKEJdDkDicQBoBSLqLuw/G/Kf/vAnv+bi5KRLIKAPetZgtdlI++4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718130422; c=relaxed/simple;
	bh=H3b3RA+J1cK07IdlP1IzCfmtwXcOMi8FfSC6498w+PU=;
	h=Date:To:From:Subject:Message-Id; b=bpvX+NKytT5lAjlE1FpIc0nrCtx6B+8Oyg5WlptWQQOwDS45g/493aJV81+pTElK5sihbnluXBqZMhKpC9f2svo3ls7+zxQ0NmgOJd2GornEv8O7SnBKPSqNKrrZeV7Tkv3RyF6SH6bCCTosm81SLy8eb7wMc1WtXfvVjn9EFwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kmLCs3Cp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kmLCs3Cp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2F4BC2BD10;
	Tue, 11 Jun 2024 18:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718130422;
	bh=H3b3RA+J1cK07IdlP1IzCfmtwXcOMi8FfSC6498w+PU=;
	h=Date:To:From:Subject:From;
	b=kmLCs3Cp/BuaZCXYYN0fSrbLIHBma4riRBuTcn6OEGTevpYFJ06AOAeKDhW64L0Dk
	 gjNcc6NWvzDqf5Dn8tWAnVnHZQFUVoEVnJsqlxyACGeGIya+skEi/BxJrOAwQmXXbg
	 kf9kMFD7uwhyMnIq37xxhmPz+N0z2IH+KpXZQXRE=
Date: Tue, 11 Jun 2024 11:27:01 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,lstoakes@gmail.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-introduce-vmi_complete_munmap_vmas.patch added to mm-unstable branch
Message-Id: <20240611182701.F2F4BC2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mmap: introduce vmi_complete_munmap_vmas()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-introduce-vmi_complete_munmap_vmas.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-introduce-vmi_complete_munmap_vmas.patch

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
Subject: mm/mmap: introduce vmi_complete_munmap_vmas()
Date: Tue, 11 Jun 2024 14:01:55 -0400

Extract all necessary operations that need to be completed after the vma
maple tree is updated from a munmap() operation.  Extracting this makes
the later patch in the series easier to understand.

Link: https://lkml.kernel.org/r/20240611180200.711239-4-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   79 ++++++++++++++++++++++++++++++++++------------------
 1 file changed, 53 insertions(+), 26 deletions(-)

--- a/mm/mmap.c~mm-mmap-introduce-vmi_complete_munmap_vmas
+++ a/mm/mmap.c
@@ -2606,6 +2606,56 @@ static inline void abort_munmap_vmas(str
 }
 
 /*
+ * vmi_complete_munmap_vmas() - Finish the munmap() operation
+ * @vmi: The vma iterator
+ * @start: The start address
+ * @end: The end address
+ * @unlock: Unlock the mm or not
+ * @mas_detach: them maple state of the detached vma maple tree
+ * @locked_vm: The locked_vm count in the detached vmas
+ *
+ * This function updates the mm_struct, unmaps the region, frees the resources
+ * used for the munmap() and may downgrade the lock - if requested.  Everything
+ * needed to be done once the vma maple tree is updated.
+ */
+static void
+vmi_complete_munmap_vmas(struct vma_iterator *vmi, struct vm_area_struct *vma,
+		struct mm_struct *mm, unsigned long start,
+		unsigned long end, bool unlock, struct ma_state *mas_detach,
+		unsigned long locked_vm)
+{
+	struct vm_area_struct *prev, *next;
+	int count;
+
+	count = mas_detach->index + 1;
+	mm->map_count -= count;
+	mm->locked_vm -= locked_vm;
+	if (unlock)
+		mmap_write_downgrade(mm);
+
+	prev = vma_iter_prev_range(vmi);
+	next = vma_next(vmi);
+	if (next)
+		vma_iter_prev_range(vmi);
+
+	/*
+	 * We can free page tables without write-locking mmap_lock because VMAs
+	 * were isolated before we downgraded mmap_lock.
+	 */
+	mas_set(mas_detach, 1);
+	unmap_region(mm, mas_detach, vma, prev, next, start, end, count,
+		     !unlock);
+	/* Statistics and freeing VMAs */
+	mas_set(mas_detach, 0);
+	remove_mt(mm, mas_detach);
+	validate_mm(mm);
+	if (unlock)
+		mmap_read_unlock(mm);
+
+	__mt_destroy(mas_detach->tree);
+}
+
+/*
  * do_vmi_align_munmap() - munmap the aligned region from @start to @end.
  * @vmi: The vma iterator
  * @vma: The starting vm_area_struct
@@ -2624,7 +2674,7 @@ do_vmi_align_munmap(struct vma_iterator
 		    struct mm_struct *mm, unsigned long start,
 		    unsigned long end, struct list_head *uf, bool unlock)
 {
-	struct vm_area_struct *prev, *next = NULL;
+	struct vm_area_struct *next = NULL;
 	struct maple_tree mt_detach;
 	int count = 0;
 	int error = -ENOMEM;
@@ -2728,31 +2778,8 @@ do_vmi_align_munmap(struct vma_iterator
 		goto clear_tree_failed;
 
 	/* Point of no return */
-	mm->locked_vm -= locked_vm;
-	mm->map_count -= count;
-	if (unlock)
-		mmap_write_downgrade(mm);
-
-	prev = vma_iter_prev_range(vmi);
-	next = vma_next(vmi);
-	if (next)
-		vma_iter_prev_range(vmi);
-
-	/*
-	 * We can free page tables without write-locking mmap_lock because VMAs
-	 * were isolated before we downgraded mmap_lock.
-	 */
-	mas_set(&mas_detach, 1);
-	unmap_region(mm, &mas_detach, vma, prev, next, start, end, count,
-		     !unlock);
-	/* Statistics and freeing VMAs */
-	mas_set(&mas_detach, 0);
-	remove_mt(mm, &mas_detach);
-	validate_mm(mm);
-	if (unlock)
-		mmap_read_unlock(mm);
-
-	__mt_destroy(&mt_detach);
+	vmi_complete_munmap_vmas(vmi, vma, mm, start, end, unlock, &mas_detach,
+				 locked_vm);
 	return 0;
 
 clear_tree_failed:
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

