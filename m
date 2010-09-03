From: akpm@linux-foundation.org
Subject: + mm-page-allocator-update-free-page-counters-after-pages-are-placed-on-the-free-list-fix.patch added to -mm tree
Date: Fri, 03 Sep 2010 16:01:24 -0700
Message-ID: <201009032301.o83N1O2M017716@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36024 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752871Ab0ICXC0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Sep 2010 19:02:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, cl@linux.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, riel@redhat.com


The patch titled
     mm-page-allocator-update-free-page-counters-after-pages-are-placed-on-the-free-list-fix
has been added to the -mm tree.  Its filename is
     mm-page-allocator-update-free-page-counters-after-pages-are-placed-on-the-free-list-fix.patch

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
Subject: mm-page-allocator-update-free-page-counters-after-pages-are-placed-on-the-free-list-fix
From: Andrew Morton <akpm@linux-foundation.org>

avoid modifying incoming args

Cc: Christoph Lameter <cl@linux.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/page_alloc.c~mm-page-allocator-update-free-page-counters-after-pages-are-placed-on-the-free-list-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page-allocator-update-free-page-counters-after-pages-are-placed-on-the-free-list-fix
+++ a/mm/page_alloc.c
@@ -588,13 +588,13 @@ static void free_pcppages_bulk(struct zo
 {
 	int migratetype = 0;
 	int batch_free = 0;
-	int freed = count;
+	int to_free = count;
 
 	spin_lock(&zone->lock);
 	zone->all_unreclaimable = 0;
 	zone->pages_scanned = 0;
 
-	while (count) {
+	while (to_free) {
 		struct page *page;
 		struct list_head *list;
 
@@ -619,9 +619,9 @@ static void free_pcppages_bulk(struct zo
 			/* MIGRATE_MOVABLE list may include MIGRATE_RESERVEs */
 			__free_one_page(page, zone, 0, page_private(page));
 			trace_mm_page_pcpu_drain(page, 0, page_private(page));
-		} while (--count && --batch_free && !list_empty(list));
+		} while (--to_free && --batch_free && !list_empty(list));
 	}
-	__mod_zone_page_state(zone, NR_FREE_PAGES, freed);
+	__mod_zone_page_state(zone, NR_FREE_PAGES, count);
 	spin_unlock(&zone->lock);
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
fs-inodec-work-around-bug.patch
i-need-old-gcc.patch
cgroups-fix-api-thinko-fix.patch
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
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
kernelh-add-minmax3-macros-fix.patch
include-linux-kernelh-add-__must_check-to-strict_strto.patch
sdhci-support-10-bit-divided-clock-mode-for-spec-30-checkpatch-fixes.patch
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

