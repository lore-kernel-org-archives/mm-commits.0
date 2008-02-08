From: akpm@linux-foundation.org
Subject: - memcgroup-fix-zone-isolation-oom.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:03:56 -0800
Message-ID: <200802080803.m1883bIH014137@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43402 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758313AbYBHIZW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:25:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, a.p.zijlstra@chello.nl, balbir@linux.vnet.ibm.com, dev@sw.ru, ebiederm@xmission.com, herbert@13thfloor.at, menage@google.com, nickpiggin@yahoo.com.au, rientjes@googl


The patch titled
     memcgroup: fix zone isolation OOM
has been removed from the -mm tree.  Its filename was
     memcgroup-fix-zone-isolation-oom.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcgroup: fix zone isolation OOM
From: Hugh Dickins <hugh@veritas.com>

mem_cgroup_charge_common shows a tendency to OOM without good reason, when
a memhog goes well beyond its rss limit but with plenty of swap available. 
Seen on x86 but not on PowerPC; seen when the next patch omits swapcache
from memcgroup, but we presume it can happen without.

mem_cgroup_isolate_pages is not quite satisfying reclaim's criteria for OOM
avoidance.  Already it has to scan beyond the nr_to_scan limit when it
finds a !LRU page or an active page when handling inactive or an inactive
page when handling active.  It needs to do exactly the same when it finds a
page from the wrong zone (the x86 tests had two zones, the PowerPC tests
had only one).

Don't increment scan and then decrement it in these cases, just move the
incrementation down.  Fix recent off-by-one when checking against
nr_to_scan.  Cut out "Check if the meta page went away from under us",
presumably left over from early debugging: no amount of such checks could
save us if this list really were being updated without locking.

This change does make the unlimited scan while holding two spinlocks
even worse - bad for latency and bad for containment; but that's a
separate issue which is better left to be fixed a little later.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Pavel Emelianov <xemul@openvz.org>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Kirill Korotaev <dev@sw.ru>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: David Rientjes <rientjes@google.com>
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff -puN mm/memcontrol.c~memcgroup-fix-zone-isolation-oom mm/memcontrol.c
--- a/mm/memcontrol.c~memcgroup-fix-zone-isolation-oom
+++ a/mm/memcontrol.c
@@ -260,24 +260,20 @@ unsigned long mem_cgroup_isolate_pages(u
 	spin_lock(&mem_cont->lru_lock);
 	scan = 0;
 	list_for_each_entry_safe_reverse(pc, tmp, src, lru) {
-		if (scan++ > nr_to_scan)
+		if (scan >= nr_to_scan)
 			break;
 		page = pc->page;
 		VM_BUG_ON(!pc);
 
-		if (unlikely(!PageLRU(page))) {
-			scan--;
+		if (unlikely(!PageLRU(page)))
 			continue;
-		}
 
 		if (PageActive(page) && !active) {
 			__mem_cgroup_move_lists(pc, true);
-			scan--;
 			continue;
 		}
 		if (!PageActive(page) && active) {
 			__mem_cgroup_move_lists(pc, false);
-			scan--;
 			continue;
 		}
 
@@ -288,13 +284,8 @@ unsigned long mem_cgroup_isolate_pages(u
 		if (page_zone(page) != z)
 			continue;
 
-		/*
-		 * Check if the meta page went away from under us
-		 */
-		if (!list_empty(&pc->lru))
-			list_move(&pc->lru, &pc_list);
-		else
-			continue;
+		scan++;
+		list_move(&pc->lru, &pc_list);
 
 		if (__isolate_lru_page(page, mode) == 0) {
 			list_move(&page->lru, dst);
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
git-unionfs.patch
git-x86.patch
r-o-bind-mounts-track-number-of-mount-writers.patch
mount-options-fix-tmpfs.patch
mount-options-fix-tmpfs-fix.patch
add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix-2.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
prio_tree-debugging-patch.patch
