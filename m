From: akpm@linux-foundation.org
Subject: + memory-hotplug-unify-is_removable-and-offline-detection-code-checkpatch-fixes.patch added to -mm tree
Date: Tue, 07 Sep 2010 14:06:17 -0700
Message-ID: <201009072106.o87L6HAG006180@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35957 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751795Ab0IGVHG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Sep 2010 17:07:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     memory-hotplug-unify-is_removable-and-offline-detection-code-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     memory-hotplug-unify-is_removable-and-offline-detection-code-checkpatch-fixes.patch

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
Subject: memory-hotplug-unify-is_removable-and-offline-detection-code-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: code indent should use tabs where possible
#91: FILE: mm/page_alloc.c:5290:
+ ^I * If ZONE_MOVABLE, the zone never contains immobile pages$

WARNING: please, no space before tabs
#91: FILE: mm/page_alloc.c:5290:
+ ^I * If ZONE_MOVABLE, the zone never contains immobile pages$

WARNING: please, no space for starting a line, 
				excluding comments
#91: FILE: mm/page_alloc.c:5290:
+ ^I * If ZONE_MOVABLE, the zone never contains immobile pages$

ERROR: code indent should use tabs where possible
#92: FILE: mm/page_alloc.c:5291:
+ ^I */$

WARNING: please, no space before tabs
#92: FILE: mm/page_alloc.c:5291:
+ ^I */$

WARNING: please, no space for starting a line, 
				excluding comments
#92: FILE: mm/page_alloc.c:5291:
+ ^I */$

ERROR: space required after that ',' (ctx:WxV)
#183: FILE: mm/page_alloc.c:5377:
+	if(__count_immobile_pages(zone ,page, arg.pages_found))
 	                               ^

ERROR: space required before the open parenthesis '('
#183: FILE: mm/page_alloc.c:5377:
+	if(__count_immobile_pages(zone ,page, arg.pages_found))

total: 4 errors, 4 warnings, 149 lines checked

./patches/memory-hotplug-unify-is_removable-and-offline-detection-code.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~memory-hotplug-unify-is_removable-and-offline-detection-code-checkpatch-fixes mm/page_alloc.c
--- a/mm/page_alloc.c~memory-hotplug-unify-is_removable-and-offline-detection-code-checkpatch-fixes
+++ a/mm/page_alloc.c
@@ -5287,8 +5287,8 @@ __count_immobile_pages(struct zone *zone
 	unsigned long pfn, iter, found;
 	/*
 	 * For avoiding noise data, lru_add_drain_all() should be called
- 	 * If ZONE_MOVABLE, the zone never contains immobile pages
- 	 */
+	 * If ZONE_MOVABLE, the zone never contains immobile pages
+	 */
 	if (zone_idx(zone) == ZONE_MOVABLE)
 		return true;
 
@@ -5374,7 +5374,7 @@ int set_migratetype_isolate(struct page 
 	 * FIXME: Now, memory hotplug doesn't call shrink_slab() by itself.
 	 * We just check MOVABLE pages.
 	 */
-	if(__count_immobile_pages(zone ,page, arg.pages_found))
+	if (__count_immobile_pages(zone, page, arg.pages_found))
 		ret = 0;
 
 	/*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
fs-inodec-work-around-bug.patch
i-need-old-gcc.patch
cgroups-fix-api-thinko-fix.patch
vmstat-update-zone-stat-threshold-when-onlining-a-cpu.patch
mm-page-allocator-update-free-page-counters-after-pages-are-placed-on-the-free-list-fix.patch
mm-vmap-area-cache.patch
drivers-gpu-drm-i915-intel_overlayc-needs-seq_fileh.patch
parport-prevent-arm-boards-frmo-crashing-when-cups-is-loaded-fix.patch
gcc-46-btrfs-clean-up-unused-variables-bugs.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
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
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
kernelh-add-minmax3-macros-fix.patch
include-linux-kernelh-add-__must_check-to-strict_strto.patch
sdhci-support-10-bit-divided-clock-mode-for-spec-30-checkpatch-fixes.patch
mmc-make-id-freq-configurable-checkpatch-fixes.patch
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

