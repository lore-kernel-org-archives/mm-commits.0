Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAC4EEC8
	for <mm-commits@vger.kernel.org>; Sat, 24 Aug 2024 01:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724464712; cv=none; b=Qri7C66deQS64HHWaOe6mdfq0e9POSQSq6NsYaPNMGh1XRHCXBon34eRb2/Yrhcz15jf0XrQp8JrkQUhkewIbydLiRMoIC7qe6tihhUeaWbD9142ShEPa0lf92SrHsoyNbUWff0EgDzKRGj44fyOK2werCCRV5N+btboZH1yPKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724464712; c=relaxed/simple;
	bh=klnD2MN6k8AmJp+lQ/oN9eqe7xSbHxvrgihx2S4PmpU=;
	h=Date:To:From:Subject:Message-Id; b=sDhJ5eIq7BRKpU+Mj+IKFc4cqY7T1XNGgqLJP5CS83vlyOuy2sncOk2pE4kWoFG0G93m7lG663RA4zPxtINM3GzC5zzAYCqE8SYGNOBUeYgV35MU0bWARO4nyUZWtiSXgl6RocEmO2tpt0cdJ7XgWgg6b3BOylmbdRoh6n1S+u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dfjsLruB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dfjsLruB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AB7FC32786;
	Sat, 24 Aug 2024 01:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724464712;
	bh=klnD2MN6k8AmJp+lQ/oN9eqe7xSbHxvrgihx2S4PmpU=;
	h=Date:To:From:Subject:From;
	b=dfjsLruBovZn1pocTF0b/4KHeeu2Izenw/ISEpOYKCprt12I79D6Ks/smCqy0o0Mr
	 abS8aH1+HYpCPrYFIHz8Jkt5NY2QiPrqV6KoEqvbqD1WIZ4h7Nh2epHfSZWmQLz4lU
	 o4gfRIQKCGe9PIisEBNo3wccrrERvRFV9j/OASUU=
Date: Fri, 23 Aug 2024 18:58:31 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,spasswolf@web.de,sidhartha.kumar@oracle.com,paul@paul-moore.com,paulmck@kernel.org,olsajiri@gmail.com,lstoakes@gmail.com,lorenzo.stoakes@oracle.com,kees@kernel.org,Liam.Howlett@Oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-clean-up-unmap_region-argument-list.patch added to mm-unstable branch
Message-Id: <20240824015832.4AB7FC32786@smtp.kernel.org>
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
Date: Thu, 22 Aug 2024 15:25:35 -0400

With the only caller to unmap_region() being the error path of
mmap_region(), the argument list can be significantly reduced.

Link: https://lkml.kernel.org/r/20240822192543.3359552-14-Liam.Howlett@oracle.com
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

 mm/mmap.c |    3 +--
 mm/vma.c  |   17 ++++++++---------
 mm/vma.h  |    6 ++----
 3 files changed, 11 insertions(+), 15 deletions(-)

--- a/mm/mmap.c~mm-clean-up-unmap_region-argument-list
+++ a/mm/mmap.c
@@ -1613,8 +1613,7 @@ unmap_and_free_vma:
 
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
@@ -147,10 +147,8 @@ int do_vmi_munmap(struct vma_iterator *v
 
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

