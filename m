From: akpm@linux-foundation.org
Subject: [folded] mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-fix.patch removed from -mm tree
Date: Fri, 05 Mar 2010 13:19:31 -0800
Message-ID: <201003052119.o25LJVh1028190@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39380 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752462Ab0CEVTt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Mar 2010 16:19:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-fix
has been removed from the -mm tree.  Its filename was
     mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-fix.patch

This patch was dropped because it was folded into mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c           |    2 +-
 mm/memory-failure.c |    5 +++--
 mm/mmap.c           |    3 +--
 mm/rmap.c           |    9 +++++----
 4 files changed, 10 insertions(+), 9 deletions(-)

diff -puN fs/exec.c~mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-fix fs/exec.c
--- a/fs/exec.c~mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-fix
+++ a/fs/exec.c
@@ -549,7 +549,7 @@ static int shift_arg_pages(struct vm_are
 	tlb_finish_mmu(tlb, new_end, old_end);
 
 	/*
-	 * shrink the vma to just the new range.  always succeeds.
+	 * Shrink the vma to just the new range.  Always succeeds.
 	 */
 	vma_adjust(vma, new_start, new_end, vma->vm_pgoff, NULL);
 
diff -puN mm/memory-failure.c~mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-fix mm/memory-failure.c
--- a/mm/memory-failure.c~mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-fix
+++ a/mm/memory-failure.c
@@ -375,7 +375,6 @@ static void collect_procs_anon(struct pa
 			      struct to_kill **tkc)
 {
 	struct vm_area_struct *vma;
-	struct anon_vma_chain *vmac;
 	struct task_struct *tsk;
 	struct anon_vma *av;
 
@@ -384,9 +383,11 @@ static void collect_procs_anon(struct pa
 	if (av == NULL)	/* Not actually mapped anymore */
 		goto out;
 	for_each_process (tsk) {
+		struct anon_vma_chain *vmac;
+
 		if (!task_early_kill(tsk))
 			continue;
-		list_for_each_entry (vmac, &av->head, same_anon_vma) {
+		list_for_each_entry(vmac, &av->head, same_anon_vma) {
 			vma = vmac->vma;
 			if (!page_mapped_in_vma(page, vma))
 				continue;
diff -puN mm/mmap.c~mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-fix mm/mmap.c
--- a/mm/mmap.c~mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-fix
+++ a/mm/mmap.c
@@ -542,8 +542,7 @@ again:			remove_next = 1 + (end > next->
 	}
 
 	/*
-	 * When changing only vma->vm_end, we don't really need
-	 * anon_vma lock.
+	 * When changing only vma->vm_end, we don't really need anon_vma lock.
 	 */
 	if (vma->anon_vma && (insert || importer || start != vma->vm_start))
 		anon_vma = vma->anon_vma;
diff -puN mm/rmap.c~mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-fix mm/rmap.c
--- a/mm/rmap.c~mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-fix
+++ a/mm/rmap.c
@@ -331,17 +331,18 @@ vma_address(struct page *page, struct vm
 		/* page should be within @vma mapping range */
 		return -EFAULT;
 	}
-	if (unlikely(vma->vm_flags & VM_LOCK_RMAP))
+	if (unlikely(vma->vm_flags & VM_LOCK_RMAP)) {
 		/*
-		 * This VMA is being unlinked or not yet linked into the
+		 * This VMA is being unlinked or is not yet linked into the
 		 * VMA tree.  Do not try to follow this rmap.  This race
-		 * condition can result in page_referenced ignoring a
-		 * reference or try_to_unmap failing to unmap a page.
+		 * condition can result in page_referenced() ignoring a
+		 * reference or in try_to_unmap() failing to unmap a page.
 		 * The VMA cannot be freed under us because we hold the
 		 * anon_vma->lock, which the munmap code takes while
 		 * unlinking the anon_vmas from the VMA.
 		 */
 		return -EFAULT;
+	}
 	return address;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
bitops-rename-for_each_bit-to-for_each_set_bit.patch
mm-avoid-false-sharing-of-mm_counter.patch
mm-count-swap-usage.patch
vmscan-check-high-watermark-after-shrink-zone.patch
mm-remove-function-free_hot_page.patch
mm-restore-zone-all_unreclaimable-to-independence-word.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory.patch
include-linux-fsh-convert-fmode_-constants-to-hex.patch
mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue.patch
mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-fix.patch
mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume.patch
uml-linec-avoid-null-pointer-dereference-simplify.patch
lib-more-scalable-list_sort-fix.patch
fs-compat_ioctlc-suppress-two-warnings.patch
sdio-introduce-api-for-special-power-management-features-fix.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix.patch
gpio-pca953xc-add-interrupt-handling-capability.patch
gpio-pca953xc-add-interrupt-handling-capability-fix.patch
gpio-cs5535-gpio-fix-input-direction.patch

