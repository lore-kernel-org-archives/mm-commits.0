Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD7B2AE84
	for <mm-commits@vger.kernel.org>; Fri, 30 Aug 2024 22:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725055897; cv=none; b=Yxi0Mh6FhBZkO6Ar1WOPb3oN5WHJMTBMTFUDrFa+tae1SsyVLirnPXNEKaTBvwP/T7ojVgFf7DbrQA5zpO4DkfaMZgYru4D644ynFAeYNoVsojj5K0CZtxnNXKm4aVxHKBzp4eNlEMPSh5N2n88yL5kVTfTDEKQvBRIf4M03DNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725055897; c=relaxed/simple;
	bh=2lgBSKtd6ZOvttCGm4eBCqzcY2keo0f44qbMhOPax8o=;
	h=Date:To:From:Subject:Message-Id; b=OPUogyS2hq8jl0Y7CSVHUa8ott2MuuK8rkms1DT1rd+7r7m2N0iYNM5XcNPugyilnuN9nooZJy5cTkPOk2LLMBg2WJ/2c7VuSIkhUU/JYpr/g7XmGD6KLJbFh1rz4sp8uNz3ORfCKJPNgxmuBgOrF041dUhaB1d1zY80TzBBOpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OX+XmBwC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OX+XmBwC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5956C4CEC2;
	Fri, 30 Aug 2024 22:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725055897;
	bh=2lgBSKtd6ZOvttCGm4eBCqzcY2keo0f44qbMhOPax8o=;
	h=Date:To:From:Subject:From;
	b=OX+XmBwC2AW7k71FvDFEteFUtEhMJrQNYDWKkjPCyfr9KFZcD+G525q1IwpCdV1or
	 EC79UjkSA7nsDOPb65l0jFcV1y4IfZiORKHdvKEHbAywpA1TNtldyT4Koc74380rEs
	 YZlgoma1AmyXhkGeJL0FU62oFQODYA5ibTqAVBOs=
Date: Fri, 30 Aug 2024 15:11:37 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,spasswolf@web.de,sidhartha.kumar@oracle.com,paul@paul-moore.com,paulmck@kernel.org,olsajiri@gmail.com,lstoakes@gmail.com,lorenzo.stoakes@oracle.com,kees@kernel.org,jeffxu@chromium.org,broonie@kernel.org,Liam.Howlett@Oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-may_expand_vm-check-in-mmap_region.patch added to mm-unstable branch
Message-Id: <20240830221137.A5956C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: move may_expand_vm() check in mmap_region()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-move-may_expand_vm-check-in-mmap_region.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-move-may_expand_vm-check-in-mmap_region.patch

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
Subject: mm: move may_expand_vm() check in mmap_region()
Date: Fri, 30 Aug 2024 00:00:59 -0400

The may_expand_vm() check requires the count of the pages within the
munmap range.  Since this is needed for accounting and obtained later, the
reodering of ma_expand_vm() to later in the call stack, after the vma
munmap struct (vms) is initialised and the gather stage is potentially
run, will allow for a single loop over the vmas.  The gather sage does not
commit any work and so everything can be undone in the case of a failure.

The MAP_FIXED page count is available after the vms_gather_munmap_vmas()
call, so use it instead of looping over the vmas twice.

Link: https://lkml.kernel.org/r/20240830040101.822209-20-Liam.Howlett@oracle.com
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

 mm/mmap.c |   15 ++++-----------
 mm/vma.c  |   21 ---------------------
 mm/vma.h  |    3 ---
 3 files changed, 4 insertions(+), 35 deletions(-)

--- a/mm/mmap.c~mm-move-may_expand_vm-check-in-mmap_region
+++ a/mm/mmap.c
@@ -1376,17 +1376,6 @@ unsigned long mmap_region(struct file *f
 	pgoff_t vm_pgoff;
 	int error = -ENOMEM;
 	VMA_ITERATOR(vmi, mm, addr);
-	unsigned long nr_pages, nr_accounted;
-
-	nr_pages = count_vma_pages_range(mm, addr, end, &nr_accounted);
-
-	/*
-	 * Check against address space limit.
-	 * MAP_FIXED may remove pages of mappings that intersects with requested
-	 * mapping. Account for the pages it would unmap.
-	 */
-	if (!may_expand_vm(mm, vm_flags, pglen - nr_pages))
-		return -ENOMEM;
 
 	/* Find the first overlapping VMA */
 	vma = vma_find(&vmi, end);
@@ -1410,6 +1399,10 @@ unsigned long mmap_region(struct file *f
 			vma_iter_next_range(&vmi);
 	}
 
+	/* Check against address space limit. */
+	if (!may_expand_vm(mm, vm_flags, pglen - vms.nr_pages))
+		goto abort_munmap;
+
 	/*
 	 * Private writable mapping: check memory availability
 	 */
--- a/mm/vma.c~mm-move-may_expand_vm-check-in-mmap_region
+++ a/mm/vma.c
@@ -1640,27 +1640,6 @@ bool vma_wants_writenotify(struct vm_are
 	return vma_fs_can_writeback(vma);
 }
 
-unsigned long count_vma_pages_range(struct mm_struct *mm,
-		unsigned long addr, unsigned long end,
-		unsigned long *nr_accounted)
-{
-	VMA_ITERATOR(vmi, mm, addr);
-	struct vm_area_struct *vma;
-	unsigned long nr_pages = 0;
-
-	*nr_accounted = 0;
-	for_each_vma_range(vmi, vma, end) {
-		unsigned long vm_start = max(addr, vma->vm_start);
-		unsigned long vm_end = min(end, vma->vm_end);
-
-		nr_pages += PHYS_PFN(vm_end - vm_start);
-		if (vma->vm_flags & VM_ACCOUNT)
-			*nr_accounted += PHYS_PFN(vm_end - vm_start);
-	}
-
-	return nr_pages;
-}
-
 static DEFINE_MUTEX(mm_all_locks_mutex);
 
 static void vm_lock_anon_vma(struct mm_struct *mm, struct anon_vma *anon_vma)
--- a/mm/vma.h~mm-move-may_expand_vm-check-in-mmap_region
+++ a/mm/vma.h
@@ -319,9 +319,6 @@ bool vma_wants_writenotify(struct vm_are
 
 int mm_take_all_locks(struct mm_struct *mm);
 void mm_drop_all_locks(struct mm_struct *mm);
-unsigned long count_vma_pages_range(struct mm_struct *mm,
-				    unsigned long addr, unsigned long end,
-				    unsigned long *nr_accounted);
 
 static inline bool vma_wants_manual_pte_write_upgrade(struct vm_area_struct *vma)
 {
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

