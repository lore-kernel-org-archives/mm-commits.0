From: akpm@linux-foundation.org
Subject: + proc-pid-smaps-after-swapout-swapin-private-dirty-mappings-are-reported-clean-checkpatch-fixes.patch added to -mm tree
Date: Tue, 14 Sep 2010 11:43:34 -0700
Message-ID: <201009141843.o8EIhYnb011717@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57464 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752508Ab0INSoJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Sep 2010 14:44:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, knikanth@suse.de, mpm@selenic.com


The patch titled
     proc-pid-smaps-after-swapout-swapin-private-dirty-mappings-are-reported-clean-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     proc-pid-smaps-after-swapout-swapin-private-dirty-mappings-are-reported-clean-checkpatch-fixes.patch

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
Subject: proc-pid-smaps-after-swapout-swapin-private-dirty-mappings-are-reported-clean-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#54: FILE: fs/proc/task_mmu.c:376:
+			if (pte_dirty(ptent) || (vma->vm_file && PageAnon(page)))

total: 0 errors, 1 warnings, 12 lines checked

./patches/proc-pid-smaps-after-swapout-swapin-private-dirty-mappings-are-reported-clean.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Matt Mackall <mpm@selenic.com>
Cc: Nikanth Karthikesan <knikanth@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/task_mmu.c~proc-pid-smaps-after-swapout-swapin-private-dirty-mappings-are-reported-clean-checkpatch-fixes fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~proc-pid-smaps-after-swapout-swapin-private-dirty-mappings-are-reported-clean-checkpatch-fixes
+++ a/fs/proc/task_mmu.c
@@ -373,7 +373,7 @@ static int smaps_pte_range(pmd_t *pmd, u
 			 * File-backed pages, now anonymous are dirty
 			 * with respect to the file.
 			 */
-			if (pte_dirty(ptent) || (vma->vm_file && PageAnon(page)))
+			if (pte_dirty(ptent) || vma->vm_file && PageAnon(page))
 				mss->private_dirty += PAGE_SIZE;
 			else
 				mss->private_clean += PAGE_SIZE;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
fs-inodec-work-around-bug.patch
i-need-old-gcc.patch
efifb-support-the-efi-framebuffer-on-more-apple-hardware-checkpatch-fixes.patch
proc-pid-smaps-after-swapout-swapin-private-dirty-mappings-are-reported-clean-checkpatch-fixes.patch
mm-vmap-area-cache.patch
parport-prevent-arm-boards-frmo-crashing-when-cups-is-loaded-fix.patch
gcc-46-btrfs-clean-up-unused-variables-bugs.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
sctp-prevent-reading-out-of-bounds-memory-cleanup.patch
serial-add-sc16is7x2-driver-checkpatch-fixes.patch
security-add-const-to-security_task_setscheduler.patch
sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch
usb-storage-add-new-no_read_disc_info-quirk-fix.patch
mm.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix-fix.patch
oom-rewrite-error-handling-for-oom_adj-and-oom_score_adj-tunables.patch
oom-fix-locking-for-oom_adj-and-oom_score_adj.patch
mm-only-build-per-node-scan_unevictable-functions-when-numa-is-enabled-cleanup.patch
memory-hotplug-unify-is_removable-and-offline-detection-code-checkpatch-fixes.patch
writeback-add-nr_dirtied-and-nr_written-to-proc-vmstat-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
kernelh-add-minmax3-macros-fix.patch
include-linux-kernelh-add-__must_check-to-strict_strto.patch
scripts-get_maintainerpl-add-git-blame-rolestats-authored-lines-information.patch
list-remove-explicit-list-prefetches-for-most-cases-checkpatch-fixes.patch
sdhci-support-10-bit-divided-clock-mode-for-spec-30-checkpatch-fixes.patch
mmc_test-move-files-from-sysfs-to-debugfs-checkpatch-fixes.patch
mmc-move-regulator-handling-closer-to-core-v3-fix.patch
sdhci-get-rid-of-card-detect-work-fix.patch
checkpatch-returning-errno-typically-should-be-negative.patch
select-rename-estimate_accuracy-to-select_estimate_accuracy.patch
cgroup_freezer-update_freezer_state-does-incorrect-state-transitions-checkpatch-fixes.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2-checkpatch-fixes.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
pps-add-async-pps-event-handler-fix.patch
memstick-add-driver-for-ricoh-r5c592-card-reader-cleanups.patch
kernel-resourcec-handle-reinsertion-of-an-already-inserted-resource.patch
vfs-add-super-operation-writeback_inodes-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4-export-find_get_pages.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch

