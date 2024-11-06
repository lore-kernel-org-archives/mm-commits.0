Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5450B824A3;
	Wed,  6 Nov 2024 00:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854223; cv=none; b=QRLWicv1I2GKQuHslhioTT/ajgP0WnbmgHpj8aca/K5foGXyTZNtwB92sAt+nP5i80Km5DvB7lYvxlYuVmle1U+HbmdpWUcWEa7V0JizXGG5VODf2FegZsLQPst7PDdEs2CfYbOzBmPDkxwdiRobcgzdJBne8TGMhP6anipwfHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854223; c=relaxed/simple;
	bh=das6WBUBb2JwG3SdObm7GzZIP7A6KnlWCX7EZj1c2tc=;
	h=Date:To:From:Subject:Message-Id; b=qJlJ991w2bo5Btf78CzJhmNwdvqRBJFdB5xMP0J9VrIoWYWbWSTjOaRIdgw+gnrwxSfu92OGeLObrkd7XCUqZzxC4eaOts98wx527QRwoEPBmxgSfwCwTPa6Q/18/xs3+mMmx+T3NvZ8vfkcjOj6GsQWwQbwvc5EO+sWzaY0gAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GmYaA+yM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GmYaA+yM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF8EC4CECF;
	Wed,  6 Nov 2024 00:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854222;
	bh=das6WBUBb2JwG3SdObm7GzZIP7A6KnlWCX7EZj1c2tc=;
	h=Date:To:From:Subject:From;
	b=GmYaA+yMGrW8eZBKRv/ZhLv6qsKzlydVvmIDeJH58px+7oMSZXnvX7NC1Jx6L1nYs
	 cgogSdbwEvbiow4WON5qaUyMJIQIPN6wpUl1mPg9jze9/HKvelRGEc8y3+6SI+nq5X
	 /jSgoRdkK3R78BADTzI7H0GhD3A4gXtHsY0ZsGrg=
Date: Tue, 05 Nov 2024 16:50:22 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@suse.cz,torvalds@linux-foundation.org,stable@vger.kernel.org,peterx@redhat.com,Liam.Howlett@oracle.com,jannh@google.com,James.Bottomley@HansenPartnership.com,deller@gmx.de,davem@davemloft.net,catalin.marinas@arm.com,broonie@kernel.org,andreas@gaisler.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-unconditionally-close-vmas-on-error.patch removed from -mm tree
Message-Id: <20241106005022.BDF8EC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: unconditionally close VMAs on error
has been removed from the -mm tree.  Its filename was
     mm-unconditionally-close-vmas-on-error.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: unconditionally close VMAs on error
Date: Tue, 29 Oct 2024 18:11:45 +0000

Incorrect invocation of VMA callbacks when the VMA is no longer in a
consistent state is bug prone and risky to perform.

With regards to the important vm_ops->close() callback We have gone to
great lengths to try to track whether or not we ought to close VMAs.

Rather than doing so and risking making a mistake somewhere, instead
unconditionally close and reset vma->vm_ops to an empty dummy operations
set with a NULL .close operator.

We introduce a new function to do so - vma_close() - and simplify existing
vms logic which tracked whether we needed to close or not.

This simplifies the logic, avoids incorrect double-calling of the .close()
callback and allows us to update error paths to simply call vma_close()
unconditionally - making VMA closure idempotent.

Link: https://lkml.kernel.org/r/28e89dda96f68c505cb6f8e9fc9b57c3e9f74b42.1730224667.git.lorenzo.stoakes@oracle.com
Fixes: deb0f6562884 ("mm/mmap: undo ->mmap() when arch_validate_flags() fails")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: Jann Horn <jannh@google.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Jann Horn <jannh@google.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Helge Deller <deller@gmx.de>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Will Deacon <will@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |   18 ++++++++++++++++++
 mm/mmap.c     |    5 ++---
 mm/nommu.c    |    3 +--
 mm/vma.c      |   14 +++++---------
 mm/vma.h      |    4 +---
 5 files changed, 27 insertions(+), 17 deletions(-)

--- a/mm/internal.h~mm-unconditionally-close-vmas-on-error
+++ a/mm/internal.h
@@ -135,6 +135,24 @@ static inline int mmap_file(struct file
 	return err;
 }
 
+/*
+ * If the VMA has a close hook then close it, and since closing it might leave
+ * it in an inconsistent state which makes the use of any hooks suspect, clear
+ * them down by installing dummy empty hooks.
+ */
+static inline void vma_close(struct vm_area_struct *vma)
+{
+	if (vma->vm_ops && vma->vm_ops->close) {
+		vma->vm_ops->close(vma);
+
+		/*
+		 * The mapping is in an inconsistent state, and no further hooks
+		 * may be invoked upon it.
+		 */
+		vma->vm_ops = &vma_dummy_vm_ops;
+	}
+}
+
 #ifdef CONFIG_MMU
 
 /* Flags for folio_pte_batch(). */
--- a/mm/mmap.c~mm-unconditionally-close-vmas-on-error
+++ a/mm/mmap.c
@@ -1573,8 +1573,7 @@ expanded:
 	return addr;
 
 close_and_free_vma:
-	if (file && !vms.closed_vm_ops && vma->vm_ops && vma->vm_ops->close)
-		vma->vm_ops->close(vma);
+	vma_close(vma);
 
 	if (file || vma->vm_file) {
 unmap_and_free_vma:
@@ -1934,7 +1933,7 @@ void exit_mmap(struct mm_struct *mm)
 	do {
 		if (vma->vm_flags & VM_ACCOUNT)
 			nr_accounted += vma_pages(vma);
-		remove_vma(vma, /* unreachable = */ true, /* closed = */ false);
+		remove_vma(vma, /* unreachable = */ true);
 		count++;
 		cond_resched();
 		vma = vma_next(&vmi);
--- a/mm/nommu.c~mm-unconditionally-close-vmas-on-error
+++ a/mm/nommu.c
@@ -589,8 +589,7 @@ static int delete_vma_from_mm(struct vm_
  */
 static void delete_vma(struct mm_struct *mm, struct vm_area_struct *vma)
 {
-	if (vma->vm_ops && vma->vm_ops->close)
-		vma->vm_ops->close(vma);
+	vma_close(vma);
 	if (vma->vm_file)
 		fput(vma->vm_file);
 	put_nommu_region(vma->vm_region);
--- a/mm/vma.c~mm-unconditionally-close-vmas-on-error
+++ a/mm/vma.c
@@ -323,11 +323,10 @@ static bool can_vma_merge_right(struct v
 /*
  * Close a vm structure and free it.
  */
-void remove_vma(struct vm_area_struct *vma, bool unreachable, bool closed)
+void remove_vma(struct vm_area_struct *vma, bool unreachable)
 {
 	might_sleep();
-	if (!closed && vma->vm_ops && vma->vm_ops->close)
-		vma->vm_ops->close(vma);
+	vma_close(vma);
 	if (vma->vm_file)
 		fput(vma->vm_file);
 	mpol_put(vma_policy(vma));
@@ -1115,9 +1114,7 @@ void vms_clean_up_area(struct vma_munmap
 	vms_clear_ptes(vms, mas_detach, true);
 	mas_set(mas_detach, 0);
 	mas_for_each(mas_detach, vma, ULONG_MAX)
-		if (vma->vm_ops && vma->vm_ops->close)
-			vma->vm_ops->close(vma);
-	vms->closed_vm_ops = true;
+		vma_close(vma);
 }
 
 /*
@@ -1160,7 +1157,7 @@ void vms_complete_munmap_vmas(struct vma
 	/* Remove and clean up vmas */
 	mas_set(mas_detach, 0);
 	mas_for_each(mas_detach, vma, ULONG_MAX)
-		remove_vma(vma, /* = */ false, vms->closed_vm_ops);
+		remove_vma(vma, /* unreachable = */ false);
 
 	vm_unacct_memory(vms->nr_accounted);
 	validate_mm(mm);
@@ -1684,8 +1681,7 @@ struct vm_area_struct *copy_vma(struct v
 	return new_vma;
 
 out_vma_link:
-	if (new_vma->vm_ops && new_vma->vm_ops->close)
-		new_vma->vm_ops->close(new_vma);
+	vma_close(new_vma);
 
 	if (new_vma->vm_file)
 		fput(new_vma->vm_file);
--- a/mm/vma.h~mm-unconditionally-close-vmas-on-error
+++ a/mm/vma.h
@@ -42,7 +42,6 @@ struct vma_munmap_struct {
 	int vma_count;                  /* Number of vmas that will be removed */
 	bool unlock;                    /* Unlock after the munmap */
 	bool clear_ptes;                /* If there are outstanding PTE to be cleared */
-	bool closed_vm_ops;		/* call_mmap() was encountered, so vmas may be closed */
 	/* 1 byte hole */
 	unsigned long nr_pages;         /* Number of pages being removed */
 	unsigned long locked_vm;        /* Number of locked pages */
@@ -198,7 +197,6 @@ static inline void init_vma_munmap(struc
 	vms->unmap_start = FIRST_USER_ADDRESS;
 	vms->unmap_end = USER_PGTABLES_CEILING;
 	vms->clear_ptes = false;
-	vms->closed_vm_ops = false;
 }
 #endif
 
@@ -269,7 +267,7 @@ int do_vmi_munmap(struct vma_iterator *v
 		  unsigned long start, size_t len, struct list_head *uf,
 		  bool unlock);
 
-void remove_vma(struct vm_area_struct *vma, bool unreachable, bool closed);
+void remove_vma(struct vm_area_struct *vma, bool unreachable);
 
 void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
 		struct vm_area_struct *prev, struct vm_area_struct *next);
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

selftests-mm-add-pkey_sighandler_xx-hugetlb_dio-to-gitignore.patch
mm-refactor-mm_access-to-not-return-null.patch
mm-madvise-unrestrict-process_madvise-for-current-process.patch
maple_tree-do-not-hash-pointers-on-dump-in-debug-mode.patch
tools-testing-fix-phys_addr_t-size-on-64-bit-systems.patch
tools-testing-add-additional-vma_internalh-stubs.patch
mm-isolate-mmap-internal-logic-to-mm-vmac.patch
mm-refactor-__mmap_region.patch
mm-remove-unnecessary-reset-state-logic-on-merge-new-vma.patch
mm-defer-second-attempt-at-merge-on-mmap.patch
mm-pagewalk-add-the-ability-to-install-ptes.patch
mm-add-pte_marker_guard-pte-marker.patch
mm-madvise-implement-lightweight-guard-page-mechanism.patch
tools-testing-update-tools-uapi-header-for-mman-commonh.patch
selftests-mm-add-self-tests-for-guard-page-feature.patch
mm-remove-unnecessary-page_table_lock-on-stack-expansion.patch

