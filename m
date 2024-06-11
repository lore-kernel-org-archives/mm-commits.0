Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A29A249E5
	for <mm-commits@vger.kernel.org>; Tue, 11 Jun 2024 18:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718130428; cv=none; b=DX2spA/Fqs+VdbSXUqLmDj8/IJ1gM2z9XyIoLW2BAi3vRHyvKDCziow35GEm/pQ33NFteDQ10fAKzsTWmPEZxPvlapDM/tZ1/GD+K+QFtO6w9KS0zoVA7BL9EEgaXrcFS6TNL5xp/EH4atBHD1XdIeYUl6H3TuNZa1HK6vG1fe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718130428; c=relaxed/simple;
	bh=E7oWUuC3K2pOTY1zTKujUUx66+OKbEaf1UFTZmiaJPI=;
	h=Date:To:From:Subject:Message-Id; b=I2aXUtC1826eEAyFoDyCD9ONeG3fTdftHR0xaPIc/6i4dr0vpu/0jIosN0R6q7x/WaA15FBE5fyTYnSJASNvbGm4z7BVntj2uBVtnIooI1jL4W/7ZKdqJSjcOYJMAX9IdhEIelA6USRCAiRTB6w47pVkwVD9VQ38F0G4/MqKPeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aKF1phmh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aKF1phmh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B44DC2BD10;
	Tue, 11 Jun 2024 18:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718130428;
	bh=E7oWUuC3K2pOTY1zTKujUUx66+OKbEaf1UFTZmiaJPI=;
	h=Date:To:From:Subject:From;
	b=aKF1phmh7OsH6mds+C2YF0SW0oGnQPcTlRzKYmX1tHEu5Auk4aUJKZAd9P5+fuuHL
	 eWUdTS+PTOV4qAJIsjO/DSYoS3gxGXWZl+87tYPb2YtfwEMnQptgpcsAPfTbmnBD27
	 nmG5y2uLJA+qZxiOKkl1qqbB4PBzmC/zLOEhWqHg=
Date: Tue, 11 Jun 2024 11:27:07 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,lstoakes@gmail.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-change-munmap-to-use-vma_munmap_struct-for-accounting-and-surrounding-vmas.patch added to mm-unstable branch
Message-Id: <20240611182708.3B44DC2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mmap: change munmap to use vma_munmap_struct() for accounting and surrounding vmas
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-change-munmap-to-use-vma_munmap_struct-for-accounting-and-surrounding-vmas.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-change-munmap-to-use-vma_munmap_struct-for-accounting-and-surrounding-vmas.patch

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
Subject: mm/mmap: change munmap to use vma_munmap_struct() for accounting and surrounding vmas
Date: Tue, 11 Jun 2024 14:01:58 -0400

Clean up the code by changing the munmap operation to use a structure for
the accounting and munmap variables.

Since remove_mt() is only called in one location and the contents will be
reduce to almost nothing.  The remains of the function can be added to
vms_complete_munmap_vmas().

Link: https://lkml.kernel.org/r/20240611180200.711239-7-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    6 +++
 mm/mmap.c     |   88 ++++++++++++++++++++++++++----------------------
 2 files changed, 54 insertions(+), 40 deletions(-)

--- a/mm/internal.h~mm-mmap-change-munmap-to-use-vma_munmap_struct-for-accounting-and-surrounding-vmas
+++ a/mm/internal.h
@@ -1477,12 +1477,18 @@ struct vma_munmap_struct {
 	struct vma_iterator *vmi;
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;	/* The first vma to munmap */
+	struct vm_area_struct *next;	/* vma after the munmap area */
+	struct vm_area_struct *prev;    /* vma before the munmap area */
 	struct list_head *uf;		/* Userfaultfd list_head */
 	unsigned long start;		/* Aligned start addr */
 	unsigned long end;		/* Aligned end addr */
 	int vma_count;			/* Number of vmas that will be removed */
 	unsigned long nr_pages;		/* Number of pages being removed */
 	unsigned long locked_vm;	/* Number of locked pages */
+	unsigned long nr_accounted;	/* Number of VM_ACCOUNT pages */
+	unsigned long exec_vm;
+	unsigned long stack_vm;
+	unsigned long data_vm;
 	bool unlock;			/* Unlock after the munmap */
 };
 
--- a/mm/mmap.c~mm-mmap-change-munmap-to-use-vma_munmap_struct-for-accounting-and-surrounding-vmas
+++ a/mm/mmap.c
@@ -523,7 +523,8 @@ static inline void init_vma_munmap(struc
 	vms->unlock = unlock;
 	vms->uf = uf;
 	vms->vma_count = 0;
-	vms->nr_pages = vms->locked_vm = 0;
+	vms->nr_pages = vms->locked_vm = vms->nr_accounted = 0;
+	vms->exec_vm = vms->stack_vm = vms->data_vm = 0;
 }
 
 /*
@@ -2389,30 +2390,6 @@ success:
 }
 
 /*
- * Ok - we have the memory areas we should free on a maple tree so release them,
- * and do the vma updates.
- *
- * Called with the mm semaphore held.
- */
-static inline void remove_mt(struct mm_struct *mm, struct ma_state *mas)
-{
-	unsigned long nr_accounted = 0;
-	struct vm_area_struct *vma;
-
-	/* Update high watermark before we lower total_vm */
-	update_hiwater_vm(mm);
-	mas_for_each(mas, vma, ULONG_MAX) {
-		long nrpages = vma_pages(vma);
-
-		if (vma->vm_flags & VM_ACCOUNT)
-			nr_accounted += nrpages;
-		vm_stat_account(mm, vma->vm_flags, -nrpages);
-		remove_vma(vma, false);
-	}
-	vm_unacct_memory(nr_accounted);
-}
-
-/*
  * Get rid of page table information in the indicated region.
  *
  * Called with the mm semaphore held.
@@ -2630,16 +2607,20 @@ static inline void abort_munmap_vmas(str
 	__mt_destroy(mas_detach->tree);
 }
 
+static inline void vms_vm_stat_account(struct vma_munmap_struct *vms);
 /*
  * vms_complete_munmap_vmas() - Finish the munmap() operation
  * @vms: The vma munmap struct
  * @mas_detach: The maple state of the detached vmas
+ *
+ * This function updates the mm_struct, unmaps the region, frees the resources
+ * used for the munmap() and may downgrade the lock - if requested.  Everything
+ * needed to be done once the vma maple tree is updated.
  */
-
 static void vms_complete_munmap_vmas(struct vma_munmap_struct *vms,
 		struct ma_state *mas_detach)
 {
-	struct vm_area_struct *prev, *next;
+	struct vm_area_struct *vma;
 	struct mm_struct *mm;
 
 	mm = vms->mm;
@@ -2648,21 +2629,21 @@ static void vms_complete_munmap_vmas(str
 	if (vms->unlock)
 		mmap_write_downgrade(mm);
 
-	prev = vma_iter_prev_range(vms->vmi);
-	next = vma_next(vms->vmi);
-	if (next)
-		vma_iter_prev_range(vms->vmi);
-
 	/*
 	 * We can free page tables without write-locking mmap_lock because VMAs
 	 * were isolated before we downgraded mmap_lock.
 	 */
 	mas_set(mas_detach, 1);
-	unmap_region(mm, mas_detach, vms->vma, prev, next, vms->start, vms->end,
-		     vms->vma_count, !vms->unlock);
-	/* Statistics and freeing VMAs */
+	unmap_region(mm, mas_detach, vms->vma, vms->prev, vms->next,
+		     vms->start, vms->end, vms->vma_count, !vms->unlock);
+	/* Update high watermark before we lower total_vm */
+	update_hiwater_vm(mm);
+	vms_vm_stat_account(vms);
 	mas_set(mas_detach, 0);
-	remove_mt(mm, mas_detach);
+	mas_for_each(mas_detach, vma, ULONG_MAX)
+		remove_vma(vma, false);
+
+	vm_unacct_memory(vms->nr_accounted);
 	validate_mm(mm);
 	if (vms->unlock)
 		mmap_read_unlock(mm);
@@ -2710,13 +2691,14 @@ static int vms_gather_munmap_vmas(struct
 		if (error)
 			goto start_split_failed;
 	}
+	vms->prev = vma_prev(vms->vmi);
 
 	/*
 	 * Detach a range of VMAs from the mm. Using next as a temp variable as
 	 * it is always overwritten.
 	 */
-	next = vms->vma;
-	do {
+	for_each_vma_range(*(vms->vmi), next, vms->end) {
+		long nrpages;
 		/* Does it split the end? */
 		if (next->vm_end > vms->end) {
 			error = __split_vma(vms->vmi, next, vms->end, 0);
@@ -2725,8 +2707,21 @@ static int vms_gather_munmap_vmas(struct
 		}
 		vma_start_write(next);
 		mas_set(mas_detach, vms->vma_count++);
+		nrpages = vma_pages(next);
+
+		vms->nr_pages += nrpages;
 		if (next->vm_flags & VM_LOCKED)
-			vms->locked_vm += vma_pages(next);
+			vms->locked_vm += nrpages;
+
+		if (next->vm_flags & VM_ACCOUNT)
+			vms->nr_accounted += nrpages;
+
+		if (is_exec_mapping(next->vm_flags))
+			vms->exec_vm += nrpages;
+		else if (is_stack_mapping(next->vm_flags))
+			vms->stack_vm += nrpages;
+		else if (is_data_mapping(next->vm_flags))
+			vms->data_vm += nrpages;
 
 		error = mas_store_gfp(mas_detach, next, GFP_KERNEL);
 		if (error)
@@ -2752,7 +2747,9 @@ static int vms_gather_munmap_vmas(struct
 		BUG_ON(next->vm_start < vms->start);
 		BUG_ON(next->vm_start > vms->end);
 #endif
-	} for_each_vma_range(*(vms->vmi), next, vms->end);
+	}
+
+	vms->next = vma_next(vms->vmi);
 
 #if defined(CONFIG_DEBUG_VM_MAPLE_TREE)
 	/* Make sure no VMAs are about to be lost. */
@@ -3673,6 +3670,17 @@ void vm_stat_account(struct mm_struct *m
 		mm->data_vm += npages;
 }
 
+/* Accounting for munmap */
+static inline void vms_vm_stat_account(struct vma_munmap_struct *vms)
+{
+	struct mm_struct *mm = vms->mm;
+
+	WRITE_ONCE(mm->total_vm, READ_ONCE(mm->total_vm) - vms->nr_pages);
+	mm->exec_vm -= vms->exec_vm;
+	mm->stack_vm -= vms->stack_vm;
+	mm->data_vm -= vms->data_vm;
+}
+
 static vm_fault_t special_mapping_fault(struct vm_fault *vmf);
 
 /*
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

