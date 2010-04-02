From: akpm@linux-foundation.org
Subject: + mm-revert-vmscan-get_scan_ratio-cleanup.patch added to -mm tree
Date: Fri, 02 Apr 2010 16:56:07 -0700
Message-ID: <201004022356.o32Nu77J012308@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55776 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751498Ab0DBX4Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Apr 2010 19:56:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com, shaohua.li@intel.com


The patch titled
     mm: revert "vmscan: get_scan_ratio() cleanup"
has been added to the -mm tree.  Its filename is
     mm-revert-vmscan-get_scan_ratio-cleanup.patch

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
Subject: mm: revert "vmscan: get_scan_ratio() cleanup"
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Shaohua Li reported his tmpfs streaming I/O test can lead to make oom. 
The test uses a 6G tmpfs in a system with 3G memory.  In the tmpfs, there
are 6 copies of kernel source and the test does kbuild for each copy.  His
investigation shows the test has a lot of rotated anon pages and quite few
file pages, so get_scan_ratio calculates percent[0] (i.e.  scanning
percent for anon) to be zero.  Actually the percent[0] shoule be a big
value, but our calculation round it to zero.

Although before commit 84b18490 ("vmscan: get_scan_ratio() cleanup") , we
have the same problem too.  But the old logic can rescue percent[0]==0
case only when priority==0.  It had hided the real issue.  I didn't think
merely streaming io can makes percent[0]==0 && priority==0 situation.  but
I was wrong.

So, definitely we have to fix such tmpfs streaming io issue.  but anyway I
revert the regression commit at first.

This reverts commit 84b18490d1f1bc7ed5095c929f78bc002eb70f26.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reported-by: Shaohua Li <shaohua.li@intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff -puN mm/vmscan.c~mm-revert-vmscan-get_scan_ratio-cleanup mm/vmscan.c
--- a/mm/vmscan.c~mm-revert-vmscan-get_scan_ratio-cleanup
+++ a/mm/vmscan.c
@@ -1535,13 +1535,6 @@ static void get_scan_ratio(struct zone *
 	unsigned long ap, fp;
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
 
-	/* If we have no swap space, do not bother scanning anon pages. */
-	if (!sc->may_swap || (nr_swap_pages <= 0)) {
-		percent[0] = 0;
-		percent[1] = 100;
-		return;
-	}
-
 	anon  = zone_nr_lru_pages(zone, sc, LRU_ACTIVE_ANON) +
 		zone_nr_lru_pages(zone, sc, LRU_INACTIVE_ANON);
 	file  = zone_nr_lru_pages(zone, sc, LRU_ACTIVE_FILE) +
@@ -1639,20 +1632,22 @@ static void shrink_zone(int priority, st
 	unsigned long nr_reclaimed = sc->nr_reclaimed;
 	unsigned long nr_to_reclaim = sc->nr_to_reclaim;
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
+	int noswap = 0;
 
-	get_scan_ratio(zone, sc, percent);
+	/* If we have no swap space, do not bother scanning anon pages. */
+	if (!sc->may_swap || (nr_swap_pages <= 0)) {
+		noswap = 1;
+		percent[0] = 0;
+		percent[1] = 100;
+	} else
+		get_scan_ratio(zone, sc, percent);
 
 	for_each_evictable_lru(l) {
 		int file = is_file_lru(l);
 		unsigned long scan;
 
-		if (percent[file] == 0) {
-			nr[l] = 0;
-			continue;
-		}
-
 		scan = zone_nr_lru_pages(zone, sc, l);
-		if (priority) {
+		if (priority || noswap) {
 			scan >>= priority;
 			scan = (scan * percent[file]) / 100;
 		}
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

mm-revert-vmscan-get_scan_ratio-cleanup.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
mm-remove-return-value-of-putback_lru_pages.patch
mempolicy-remove-redundant-code.patch
oom-filter-tasks-not-sharing-the-same-cpuset.patch
oom-sacrifice-child-with-highest-badness-score-for-parent.patch
oom-select-task-from-tasklist-for-mempolicy-ooms.patch
oom-remove-special-handling-for-pagefault-ooms.patch
oom-badness-heuristic-rewrite.patch
oom-deprecate-oom_adj-tunable.patch
oom-replace-sysctls-with-quick-mode.patch
oom-avoid-oom-killer-for-lowmem-allocations.patch
oom-remove-unnecessary-code-and-cleanup.patch
oom-default-to-killing-current-for-pagefault-ooms.patch
oom-avoid-race-for-oom-killed-tasks-detaching-mm-prior-to-exit.patch
oom-hold-tasklist_lock-when-dumping-tasks.patch
oom-give-current-access-to-memory-reserves-if-it-has-been-killed.patch
oom-avoid-sending-exiting-tasks-a-sigkill.patch
oom-clean-up-oom_kill_task.patch
oom-clean-up-oom_badness.patch
mempolicy-dont-call-mpol_set_nodemask-when-no_context.patch
mempolicy-lose-unnecessary-loop-variable-in-mpol_parse_str.patch
mempolicy-rename-policy_types-and-cleanup-initialization.patch
mempolicy-factor-mpol_shared_policy_init-return-paths.patch
mempolicy-document-cpuset-interaction-with-tmpfs-mpol-mount-option.patch
proc-cleanup-remove-unused-assignments.patch
reiser4.patch

