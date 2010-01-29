From: akpm@linux-foundation.org
Subject: + mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-fix.patch added to -mm tree
Date: Fri, 29 Jan 2010 15:14:44 -0800
Message-ID: <201001292314.o0TNEiun015641@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46829 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754667Ab0A2XPD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Jan 2010 18:15:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, riel@redhat.com


The patch titled
     mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-fix
has been added to the -mm tree.  Its filename is
     mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
zlib-make-new-optimized-inflate-endian-independent-checkpatch-fixes.patch
ibmphp-read-the-length-of-ebda-and-map-entire-ebda-region-fix.patch
pci-update-pci_set_vga_state-to-call-arch-functions-fix.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present-checkpatch-fixes.patch
cpufreq-ondemand-independent-max-speed-for-nice-threads-with-nice_max_freq-fix.patch
drivers-gpu-drm-radeon-radeon_combiosc-fix-warning.patch
drivers-media-video-pmsc-needs-versionh.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
jffs2-avoid-using-c-keyword-new-in-userspace-visible-header.patch
3x59x-fix-pci-resource-management.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage-checkpatch-fixes.patch
mm-add-lowmem-detection-logic-fix.patch
mm-count-lowmem-rss-checkpatch-fixes.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
mm-remove-function-free_hot_page-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory-fix.patch
include-linux-fsh-convert-fmode_-constants-to-hex.patch
mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
uml-linec-avoid-null-pointer-dereference-simplify.patch
resources-introduce-generic-page_is_ram-fix.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
notify_change-callers-must-hold-i_mutex.patch

