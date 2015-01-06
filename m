From: akpm@linux-foundation.org
Subject: [folded-merged]
 task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss-fix.patch removed from -mm tree
Date: Tue, 06 Jan 2015 13:57:16 -0800
Message-ID: <54ac5a3c.CltQrAK8rXc+k/hl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42927 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336AbbAFV5R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2015 16:57:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bhelgaas@google.com, petrcermak@chromium.org, primiano@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss-fix
has been removed from the -mm tree.  Its filename was
     task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss-fix.patch

This patch was dropped because it was folded into task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss-fix

clarify behaviour in documentation

Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Petr Cermak <petrcermak@chromium.org>
Cc: Primiano Tucci <primiano@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    3 ++-
 fs/proc/task_mmu.c                 |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN Documentation/filesystems/proc.txt~task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss-fix Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss-fix
+++ a/Documentation/filesystems/proc.txt
@@ -488,7 +488,8 @@ To clear the bits for the file mapped pa
 To clear the soft-dirty bit
     > echo 4 > /proc/PID/clear_refs
 
-To reset the peak resident set size ("high water mark")
+To reset the peak resident set size ("high water mark") to the process's
+current value:
     > echo 5 > /proc/PID/clear_refs
 
 Any other value written to /proc/PID/clear_refs will have no effect.
diff -puN fs/proc/task_mmu.c~task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss-fix fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss-fix
+++ a/fs/proc/task_mmu.c
@@ -866,7 +866,7 @@ static ssize_t clear_refs_write(struct f
 		if (type == CLEAR_REFS_MM_HIWATER_RSS) {
 			/*
 			 * Writing 5 to /proc/pid/clear_refs resets the peak
-			 * resident set size.
+			 * resident set size to this mm's current rss value.
 			 */
 			down_write(&mm->mmap_sem);
 			reset_mm_hiwater_rss(mm);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-prevent-endless-growth-of-anon_vma-hierarchy-fix.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed-checkpatch-fixes.patch
fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch
mm.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
cma-fix-cmas-page-number-is-substructed-twice-in-__zone_watermark_ok-fix.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss.patch
lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch
hexdump-makes-it-return-amount-of-bytes-placed-in-buffer-fix.patch
fs-befs-linuxvfsc-remove-unnecessary-casting-fix.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

