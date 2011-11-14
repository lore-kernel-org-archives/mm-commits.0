From: akpm@linux-foundation.org
Subject: + mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes-checkpatch-fixes.patch added to -mm tree
Date: Mon, 14 Nov 2011 15:23:14 -0800
Message-ID: <201111142323.pAENNEX5030844@wpaz21.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:49151 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab1KNXXR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Nov 2011 18:23:17 -0500
Received: by qyd20 with SMTP id 20so314642qyd.1
        for <mm-commits@vger.kernel.org>; Mon, 14 Nov 2011 15:23:16 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, mgorman@suse.de


The patch titled
     Subject: mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes-checkpatch-fixes.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes-checkpatch-fixes

Cc: Mel Gorman <mgorman@suse.de>

WARNING: line over 80 characters
#42: FILE: mm/page_alloc.c:3464:
+			/* Blocks with reserved pages will never free, skip them. */

WARNING: line over 80 characters
#61: FILE: mm/page_alloc.c:3477:
+				set_pageblock_migratetype(page, MIGRATE_RESERVE);

WARNING: line over 80 characters
#62: FILE: mm/page_alloc.c:3478:
+				move_freepages_block(zone, page, MIGRATE_RESERVE);

total: 0 errors, 3 warnings, 44 lines checked

./patches/mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <>
---

 mm/page_alloc.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes-checkpatch-fixes mm/page_alloc.c
--- a/mm/page_alloc.c~mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes-checkpatch-fixes
+++ a/mm/page_alloc.c
@@ -3461,7 +3461,10 @@ static void setup_zone_migrate_reserve(s
 
 		/* Only test what is necessary when the reserves are not met */
 		if (reserve > 0) {
-			/* Blocks with reserved pages will never free, skip them. */
+			/*
+			 * Blocks with reserved pages will never free, skip
+			 * them.
+			 */
 			block_end_pfn = min(pfn + pageblock_nr_pages, end_pfn);
 			if (pageblock_is_reserved(pfn, block_end_pfn))
 				continue;
@@ -3474,8 +3477,10 @@ static void setup_zone_migrate_reserve(s
 
 			/* Suitable for reserving if this block is movable */
 			if (block_migratetype == MIGRATE_MOVABLE) {
-				set_pageblock_migratetype(page, MIGRATE_RESERVE);
-				move_freepages_block(zone, page, MIGRATE_RESERVE);
+				set_pageblock_migratetype(page,
+							MIGRATE_RESERVE);
+				move_freepages_block(zone, page,
+							MIGRATE_RESERVE);
 				reserve--;
 				continue;
 			}
_
Subject: Subject: mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes-checkpatch-fixes

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
mrst-battery-fixes-fix.patch
x86-reduce-clock-calibration-time-during-slave-cpu-startup-fix.patch
drivers-net-ethernet-oki-semi-pch_gbe-pch_gbeh-remove-unused-macro-pr_fmt.patch
debugobjects-extend-to-assert-that-an-object-is-initialized.patch
kernel-timerc-use-debugobjects-to-catch-deletion-of-uninitialized-timers.patch
drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements.patch
mm.patch
vmscan-use-atomic-long-for-shrinker-batching-fix.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-avoid-livelock-on-__gfp_fs-allocations-fix.patch
mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes-checkpatch-fixes.patch
include-linux-securityh-fix-security_inode_init_security-arg.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes.patch
cgroup-fix-task-counter-common-ancestor-logic-checkpatch-fixes.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned-checkpatch-fixes.patch
procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes.patch
workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-fix.patch
kexec-remove-kmsg_dump_kexec.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

