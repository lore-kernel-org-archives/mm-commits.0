From: akpm@linux-foundation.org
Subject: + vmscan-recalculate-lru_pages-on-each-priority.patch added to -mm tree
Date: Wed, 30 Jun 2010 16:04:21 -0700
Message-ID: <201006302304.o5UN4L2e031797@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60964 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754477Ab0F3XEm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jun 2010 19:04:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, hannes@cmpxchg.org, minchan.kim@gmail.com, riel@redhat.com


The patch titled
     vmscan: recalculate lru_pages on each priority
has been added to the -mm tree.  Its filename is
     vmscan-recalculate-lru_pages-on-each-priority.patch

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
Subject: vmscan: recalculate lru_pages on each priority
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

shrink_zones() need relatively long time and lru_pages can change
dramatically during shrink_zones().  So lru_pages should be recalculated
for each priority.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff -puN mm/vmscan.c~vmscan-recalculate-lru_pages-on-each-priority mm/vmscan.c
--- a/mm/vmscan.c~vmscan-recalculate-lru_pages-on-each-priority
+++ a/mm/vmscan.c
@@ -1785,7 +1785,6 @@ static unsigned long do_try_to_free_page
 	bool all_unreclaimable;
 	unsigned long total_scanned = 0;
 	struct reclaim_state *reclaim_state = current->reclaim_state;
-	unsigned long lru_pages = 0;
 	struct zoneref *z;
 	struct zone *zone;
 	enum zone_type high_zoneidx = gfp_zone(sc->gfp_mask);
@@ -1796,18 +1795,6 @@ static unsigned long do_try_to_free_page
 
 	if (scanning_global_lru(sc))
 		count_vm_event(ALLOCSTALL);
-	/*
-	 * mem_cgroup will not do shrink_slab.
-	 */
-	if (scanning_global_lru(sc)) {
-		for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
-
-			if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
-				continue;
-
-			lru_pages += zone_reclaimable_pages(zone);
-		}
-	}
 
 	for (priority = DEF_PRIORITY; priority >= 0; priority--) {
 		sc->nr_scanned = 0;
@@ -1819,6 +1806,14 @@ static unsigned long do_try_to_free_page
 		 * over limit cgroups
 		 */
 		if (scanning_global_lru(sc)) {
+			unsigned long lru_pages = 0;
+			for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
+				if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
+					continue;
+
+				lru_pages += zone_reclaimable_pages(zone);
+			}
+
 			shrink_slab(sc->nr_scanned, sc->gfp_mask, lru_pages);
 			if (reclaim_state) {
 				sc->nr_reclaimed += reclaim_state->reclaimed_slab;
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

mempolicy-fix-dangling-reference-to-tmpfs-superblock-mpol.patch
acpi-fix-unused-function-warning.patch
mm-use-memdup_user.patch
oom-check-pf_kthread-instead-of-mm-to-skip-kthreads.patch
oom-pf_exiting-check-should-take-mm-into-account.patch
oom-introduce-find_lock_task_mm-to-fix-mm-false-positives.patch
oom-dump_tasks-use-find_lock_task_mm-too.patch
oom-improve-commentary-in-dump_tasks.patch
oom-dump_tasks-use-find_lock_task_mm-too-dump_tasks-use-find_lock_task_mm-too-fix.patch
oom-give-current-access-to-memory-reserves-if-it-has-been-killed.patch
oom-avoid-sending-exiting-tasks-a-sigkill.patch
oom-filter-tasks-not-sharing-the-same-cpuset.patch
oom-sacrifice-child-with-highest-badness-score-for-parent.patch
oom-sacrifice-child-with-highest-badness-score-for-parent-protect-dereferencing-of-tasks-comm.patch
oom-sacrifice-child-with-highest-badness-score-for-parent-fix.patch
oom-select-task-from-tasklist-for-mempolicy-ooms.patch
oom-select-task-from-tasklist-for-mempolicy-ooms-add-has_intersects_mems_allowed-uma-variant.patch
oom-select-task-from-tasklist-for-mempolicy-ooms-introduce-find_lock_task_mm-to-fix-mm-false-positives-fix.patch
oom-enable-oom-tasklist-dump-by-default.patch
oom-avoid-oom-killer-for-lowmem-allocations.patch
oom-extract-panic-helper-function.patch
oom-remove-special-handling-for-pagefault-ooms.patch
oom-move-sysctl-declarations-to-oomh.patch
mm-rename-try_set_zone_oom-to-try_set_zonelist_oom.patch
oom-remove-constraint-argument-from-select_bad_process-and-__out_of_memory.patch
oom-fold-__out_of_memory-into-out_of_memory.patch
mm-use-for_each_online_cpu-in-vmstat.patch
mempolicy-reduce-stack-size-of-migrate_pages.patch
mempolicy-reduce-stack-size-of-migrate_pages-fix.patch
vmscan-zone_reclaim-dont-call-disable_swap_token.patch
vmscan-recalculate-lru_pages-on-each-priority.patch
reiser4.patch

