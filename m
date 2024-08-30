Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB2761BF7E7
	for <mm-commits@vger.kernel.org>; Fri, 30 Aug 2024 22:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725055881; cv=none; b=VKIdW6P6fHQs2UwcSTzuFyAbdVCDOT/z2i6U6PTh1/kZqQBi18x3Z6tPg65e8jxyDyX+RRBZW0zNClLowNZTd4ilTkZYTfAw6k6vJu4+tQSBLj2ZjwT1olZreslKmhmvQ4deKzHN2mw460z90QVz+MkP9KEitD0XtoUuXpEl7JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725055881; c=relaxed/simple;
	bh=0KxIWEZp3QBULCKL1bXfiBihjzVlfJlTg1GNcHIyep8=;
	h=Date:To:From:Subject:Message-Id; b=vCEb9+Y0p2dbQe9934q9bkbO16H7114Vqk8D0QjEOzfM9OGUd2mWtF+r/kU40M2N5wEP8mEzW1/DYGnOQ9tYdUy9WGFTkCEIw99nwIFQ3QpGTNF16KcV/K72ilJKVpbE5Z46cPPJVU+TzgwWiWsDJ49ocOAntUQQDMeDYD4WzJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w7AGeReL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w7AGeReL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55257C4CEC2;
	Fri, 30 Aug 2024 22:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725055881;
	bh=0KxIWEZp3QBULCKL1bXfiBihjzVlfJlTg1GNcHIyep8=;
	h=Date:To:From:Subject:From;
	b=w7AGeReLD6V0YBOL+/GEtFDtfkjS1edNn3+ojb8oVF+AAFI0lIpebYdnG+UqrAhSo
	 JL54fKjTXxC4QGjG+7J3Tsnc6WGmwoeQvcPh12nDmCVxxYKuFnNHsE6GAEQuRXcWcr
	 HpObKUxogkNRVAJpXda4sdBYvCVJr+oCGMiND7h8=
Date: Fri, 30 Aug 2024 15:11:20 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,spasswolf@web.de,sidhartha.kumar@oracle.com,paul@paul-moore.com,paulmck@kernel.org,olsajiri@gmail.com,lstoakes@gmail.com,lorenzo.stoakes@oracle.com,kees@kernel.org,jeffxu@chromium.org,broonie@kernel.org,Liam.Howlett@Oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-clean-up-unmap_region-argument-list.patch added to mm-unstable branch
Message-Id: <20240830221121.55257C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: clean up unmap_region() argument list
has been added to the -mm mm-unstable branch.  Its filename is
     mm-clean-up-unmap_region-argument-list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-clean-up-unmap_region-argument-list.patch

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
Subject: mm: clean up unmap_region() argument list
Date: Fri, 30 Aug 2024 00:00:53 -0400

With the only caller to unmap_region() being the error path of
mmap_region(), the argument list can be significantly reduced.

Link: https://lkml.kernel.org/r/20240830040101.822209-14-Liam.Howlett@oracle.com
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

 mm/mmap.c |    3 +--
 mm/vma.c  |   17 ++++++++---------
 mm/vma.h  |    6 ++----
 3 files changed, 11 insertions(+), 15 deletions(-)

--- a/mm/mmap.c~mm-clean-up-unmap_region-argument-list
+++ a/mm/mmap.c
@@ -1615,8 +1615,7 @@ unmap_and_free_vma:
 
 		vma_iter_set(&vmi, vma->vm_end);
 		/* Undo any partial mapping done by a device driver. */
-		unmap_region(mm, &vmi.mas, vma, prev, next, vma->vm_start,
-			     vma->vm_end, vma->vm_end, true);
+		unmap_region(&vmi.mas, vma, prev, next);
 	}
 	if (writable_file_mapping)
 		mapping_unmap_writable(file->f_mapping);
--- a/mm/vma.c~mm-clean-up-unmap_region-argument-list
+++ a/mm/vma.c
@@ -155,22 +155,21 @@ void remove_vma(struct vm_area_struct *v
  *
  * Called with the mm semaphore held.
  */
-void unmap_region(struct mm_struct *mm, struct ma_state *mas,
-		struct vm_area_struct *vma, struct vm_area_struct *prev,
-		struct vm_area_struct *next, unsigned long start,
-		unsigned long end, unsigned long tree_end, bool mm_wr_locked)
+void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
+		struct vm_area_struct *prev, struct vm_area_struct *next)
 {
+	struct mm_struct *mm = vma->vm_mm;
 	struct mmu_gather tlb;
-	unsigned long mt_start = mas->index;
 
 	lru_add_drain();
 	tlb_gather_mmu(&tlb, mm);
 	update_hiwater_rss(mm);
-	unmap_vmas(&tlb, mas, vma, start, end, tree_end, mm_wr_locked);
-	mas_set(mas, mt_start);
+	unmap_vmas(&tlb, mas, vma, vma->vm_start, vma->vm_end, vma->vm_end,
+		   /* mm_wr_locked = */ true);
+	mas_set(mas, vma->vm_end);
 	free_pgtables(&tlb, mas, vma, prev ? prev->vm_end : FIRST_USER_ADDRESS,
-				 next ? next->vm_start : USER_PGTABLES_CEILING,
-				 mm_wr_locked);
+		      next ? next->vm_start : USER_PGTABLES_CEILING,
+		      /* mm_wr_locked = */ true);
 	tlb_finish_mmu(&tlb);
 }
 
--- a/mm/vma.h~mm-clean-up-unmap_region-argument-list
+++ a/mm/vma.h
@@ -149,10 +149,8 @@ int do_vmi_munmap(struct vma_iterator *v
 
 void remove_vma(struct vm_area_struct *vma, bool unreachable);
 
-void unmap_region(struct mm_struct *mm, struct ma_state *mas,
-		struct vm_area_struct *vma, struct vm_area_struct *prev,
-		struct vm_area_struct *next, unsigned long start,
-		unsigned long end, unsigned long tree_end, bool mm_wr_locked);
+void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
+		struct vm_area_struct *prev, struct vm_area_struct *next);
 
 /* Required by mmap_region(). */
 bool
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

