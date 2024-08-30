Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 936A11BFE11
	for <mm-commits@vger.kernel.org>; Fri, 30 Aug 2024 22:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725055894; cv=none; b=JggbCzzeTUbu34oiXTNKcDaBnyvX79JA7HLRRMEHIvd7PDNxouy8gbn/I7BK2bmHewRhlU0f6diIR8HT+YAeCwO0dQpwzitifV6t7LeqeJMeA6mgPZOBTTGb6MHtTXV7rjvKVzJXNYxiGOrnRQnL9YImf0Hn4fEJGZPkd0NCaz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725055894; c=relaxed/simple;
	bh=ihW4vEbo3bOqCHhBmmHv42n+uo1wOr3cmXvLAs0QeiA=;
	h=Date:To:From:Subject:Message-Id; b=WJ4QYgMploz8zpSZgzfFLgv2h9OIGED4Xd61ymjaYCuzscVhLKIew8IpRG/tynfkDqMPKeA84XDhas7rkdksFusPQL/p4EFDNG7a9tOrcCerOYpOFpiE0RR/BzT5iorDlYS/ph8WyX/d5q3g7yXbS/t8jXfTGNbufQgiv1IcPPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ekcWUUu+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ekcWUUu+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16D2CC4CEC2;
	Fri, 30 Aug 2024 22:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725055894;
	bh=ihW4vEbo3bOqCHhBmmHv42n+uo1wOr3cmXvLAs0QeiA=;
	h=Date:To:From:Subject:From;
	b=ekcWUUu+VjJKVnuNg1pEdZjtN35E54jBXj9Ra7VCgVcw+Nzozcp1olPPV+cR9pGid
	 0e/pT233ukPIcoVqThd6YOfqJfvME3HkMFQwl/wG2B65vXqSd6KfKjQ5qbjaQUBDKD
	 /RGLIx541BCY4oW+LRa1oYBhxge3dIjpu8PoSyd8=
Date: Fri, 30 Aug 2024 15:11:33 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,spasswolf@web.de,sidhartha.kumar@oracle.com,paul@paul-moore.com,paulmck@kernel.org,olsajiri@gmail.com,lstoakes@gmail.com,lorenzo.stoakes@oracle.com,kees@kernel.org,jeffxu@chromium.org,broonie@kernel.org,Liam.Howlett@Oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ipc-shm-mm-drop-do_vma_munmap.patch added to mm-unstable branch
Message-Id: <20240830221134.16D2CC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ipc/shm, mm: drop do_vma_munmap()
has been added to the -mm mm-unstable branch.  Its filename is
     ipc-shm-mm-drop-do_vma_munmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ipc-shm-mm-drop-do_vma_munmap.patch

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
Subject: ipc/shm, mm: drop do_vma_munmap()
Date: Fri, 30 Aug 2024 00:00:58 -0400

The do_vma_munmap() wrapper existed for callers that didn't have a vma
iterator and needed to check the vma mseal status prior to calling the
underlying munmap().  All callers now use a vma iterator and since the
mseal check has been moved to do_vmi_align_munmap() and the vmas are
aligned, this function can just be called instead.

do_vmi_align_munmap() can no longer be static as ipc/shm is using it and
it is exported via the mm.h header.

Link: https://lkml.kernel.org/r/20240830040101.822209-19-Liam.Howlett@oracle.com
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

 include/linux/mm.h |    6 +++---
 ipc/shm.c          |    8 ++++----
 mm/mmap.c          |   33 ++++++---------------------------
 mm/vma.c           |   12 ++++++------
 mm/vma.h           |    4 +---
 5 files changed, 20 insertions(+), 43 deletions(-)

--- a/include/linux/mm.h~ipc-shm-mm-drop-do_vma_munmap
+++ a/include/linux/mm.h
@@ -3287,14 +3287,14 @@ extern unsigned long do_mmap(struct file
 extern int do_vmi_munmap(struct vma_iterator *vmi, struct mm_struct *mm,
 			 unsigned long start, size_t len, struct list_head *uf,
 			 bool unlock);
+int do_vmi_align_munmap(struct vma_iterator *vmi, struct vm_area_struct *vma,
+		    struct mm_struct *mm, unsigned long start,
+		    unsigned long end, struct list_head *uf, bool unlock);
 extern int do_munmap(struct mm_struct *, unsigned long, size_t,
 		     struct list_head *uf);
 extern int do_madvise(struct mm_struct *mm, unsigned long start, size_t len_in, int behavior);
 
 #ifdef CONFIG_MMU
-extern int do_vma_munmap(struct vma_iterator *vmi, struct vm_area_struct *vma,
-			 unsigned long start, unsigned long end,
-			 struct list_head *uf, bool unlock);
 extern int __mm_populate(unsigned long addr, unsigned long len,
 			 int ignore_errors);
 static inline void mm_populate(unsigned long addr, unsigned long len)
--- a/ipc/shm.c~ipc-shm-mm-drop-do_vma_munmap
+++ a/ipc/shm.c
@@ -1778,8 +1778,8 @@ long ksys_shmdt(char __user *shmaddr)
 			 */
 			file = vma->vm_file;
 			size = i_size_read(file_inode(vma->vm_file));
-			do_vma_munmap(&vmi, vma, vma->vm_start, vma->vm_end,
-				      NULL, false);
+			do_vmi_align_munmap(&vmi, vma, mm, vma->vm_start,
+					    vma->vm_end, NULL, false);
 			/*
 			 * We discovered the size of the shm segment, so
 			 * break out of here and fall through to the next
@@ -1803,8 +1803,8 @@ long ksys_shmdt(char __user *shmaddr)
 		if ((vma->vm_ops == &shm_vm_ops) &&
 		    ((vma->vm_start - addr)/PAGE_SIZE == vma->vm_pgoff) &&
 		    (vma->vm_file == file)) {
-			do_vma_munmap(&vmi, vma, vma->vm_start, vma->vm_end,
-				      NULL, false);
+			do_vmi_align_munmap(&vmi, vma, mm, vma->vm_start,
+					    vma->vm_end, NULL, false);
 		}
 
 		vma = vma_next(&vmi);
--- a/mm/mmap.c~ipc-shm-mm-drop-do_vma_munmap
+++ a/mm/mmap.c
@@ -169,11 +169,12 @@ SYSCALL_DEFINE1(brk, unsigned long, brk)
 			goto out; /* mapping intersects with an existing non-brk vma. */
 		/*
 		 * mm->brk must be protected by write mmap_lock.
-		 * do_vma_munmap() will drop the lock on success,  so update it
-		 * before calling do_vma_munmap().
+		 * do_vmi_align_munmap() will drop the lock on success,  so
+		 * update it before calling do_vma_munmap().
 		 */
 		mm->brk = brk;
-		if (do_vma_munmap(&vmi, brkvma, newbrk, oldbrk, &uf, true))
+		if (do_vmi_align_munmap(&vmi, brkvma, mm, newbrk, oldbrk, &uf,
+					/* unlock = */ true))
 			goto out;
 
 		goto success_unlocked;
@@ -1479,9 +1480,9 @@ cannot_expand:
 		vma->vm_file = get_file(file);
 		/*
 		 * call_mmap() may map PTE, so ensure there are no existing PTEs
-		 * call the vm_ops close function if one exists.
+		 * and call the vm_ops close function if one exists.
 		 */
-		vms_clean_up_area(&vms, &mas_detach, true);
+		vms_clean_up_area(&vms, &mas_detach);
 		error = call_mmap(file, vma);
 		if (error)
 			goto unmap_and_free_vma;
@@ -1745,28 +1746,6 @@ out:
 }
 
 /*
- * do_vma_munmap() - Unmap a full or partial vma.
- * @vmi: The vma iterator pointing at the vma
- * @vma: The first vma to be munmapped
- * @start: the start of the address to unmap
- * @end: The end of the address to unmap
- * @uf: The userfaultfd list_head
- * @unlock: Drop the lock on success
- *
- * unmaps a VMA mapping when the vma iterator is already in position.
- * Does not handle alignment.
- *
- * Return: 0 on success drops the lock of so directed, error on failure and will
- * still hold the lock.
- */
-int do_vma_munmap(struct vma_iterator *vmi, struct vm_area_struct *vma,
-		unsigned long start, unsigned long end, struct list_head *uf,
-		bool unlock)
-{
-	return do_vmi_align_munmap(vmi, vma, vma->vm_mm, start, end, uf, unlock);
-}
-
-/*
  * do_brk_flags() - Increase the brk vma if the flags match.
  * @vmi: The vma iterator
  * @addr: The start address
--- a/mm/vma.c~ipc-shm-mm-drop-do_vma_munmap
+++ a/mm/vma.c
@@ -658,8 +658,8 @@ static inline void vms_clear_ptes(struct
 	 */
 	mas_set(mas_detach, 1);
 	lru_add_drain();
-	tlb_gather_mmu(&tlb, vms->mm);
-	update_hiwater_rss(vms->mm);
+	tlb_gather_mmu(&tlb, vms->vma->vm_mm);
+	update_hiwater_rss(vms->vma->vm_mm);
 	unmap_vmas(&tlb, mas_detach, vms->vma, vms->start, vms->end,
 		   vms->vma_count, mm_wr_locked);
 
@@ -672,14 +672,14 @@ static inline void vms_clear_ptes(struct
 }
 
 void vms_clean_up_area(struct vma_munmap_struct *vms,
-		struct ma_state *mas_detach, bool mm_wr_locked)
+		struct ma_state *mas_detach)
 {
 	struct vm_area_struct *vma;
 
 	if (!vms->nr_pages)
 		return;
 
-	vms_clear_ptes(vms, mas_detach, mm_wr_locked);
+	vms_clear_ptes(vms, mas_detach, true);
 	mas_set(mas_detach, 0);
 	mas_for_each(mas_detach, vma, ULONG_MAX)
 		if (vma->vm_ops && vma->vm_ops->close)
@@ -702,7 +702,7 @@ void vms_complete_munmap_vmas(struct vma
 	struct vm_area_struct *vma;
 	struct mm_struct *mm;
 
-	mm = vms->mm;
+	mm = current->mm;
 	mm->map_count -= vms->vma_count;
 	mm->locked_vm -= vms->locked_vm;
 	if (vms->unlock)
@@ -770,7 +770,7 @@ int vms_gather_munmap_vmas(struct vma_mu
 		 * its limit temporarily, to help free resources as expected.
 		 */
 		if (vms->end < vms->vma->vm_end &&
-		    vms->mm->map_count >= sysctl_max_map_count)
+		    vms->vma->vm_mm->map_count >= sysctl_max_map_count)
 			goto map_count_exceeded;
 
 		/* Don't bother splitting the VMA if we can't unmap it anyway */
--- a/mm/vma.h~ipc-shm-mm-drop-do_vma_munmap
+++ a/mm/vma.h
@@ -31,7 +31,6 @@ struct unlink_vma_file_batch {
  */
 struct vma_munmap_struct {
 	struct vma_iterator *vmi;
-	struct mm_struct *mm;
 	struct vm_area_struct *vma;     /* The first vma to munmap */
 	struct vm_area_struct *prev;    /* vma before the munmap area */
 	struct vm_area_struct *next;    /* vma after the munmap area */
@@ -114,7 +113,6 @@ static inline void init_vma_munmap(struc
 		unsigned long start, unsigned long end, struct list_head *uf,
 		bool unlock)
 {
-	vms->mm = current->mm;
 	vms->vmi = vmi;
 	vms->vma = vma;
 	if (vma) {
@@ -142,7 +140,7 @@ void vms_complete_munmap_vmas(struct vma
 		struct ma_state *mas_detach);
 
 void vms_clean_up_area(struct vma_munmap_struct *vms,
-		struct ma_state *mas_detach, bool mm_wr_locked);
+		struct ma_state *mas_detach);
 
 /*
  * reattach_vmas() - Undo any munmap work and free resources
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

