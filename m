From: akpm@linux-foundation.org
Subject: + memcg-make-oom_lock-0-and-1-based-rather-than-coutner.patch added to -mm tree
Date: Mon, 22 Aug 2011 15:51:24 -0700
Message-ID: <201108222251.p7MMpOZm011432@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42621 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753957Ab1HVWwC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Aug 2011 18:52:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jweiner@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz


The patch titled
     memcg: fix hierarchical oom locking
has been added to the -mm tree.  Its filename is
     memcg-make-oom_lock-0-and-1-based-rather-than-coutner.patch

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
Subject: memcg: fix hierarchical oom locking
From: Johannes Weiner <jweiner@redhat.com>

Commit 79dfdac ("memcg: make oom_lock 0 and 1 based rather than counter")
tried to oom lock the hierarchy and roll back upon encountering an already
locked memcg.

The code is confused when it comes to detecting a locked memcg, though, so
it would fail and rollback after locking one memcg and encountering an
unlocked second one.

The result is that oom-locking hierarchies fails unconditionally and that
every oom killer invocation simply goes to sleep on the oom waitqueue
forever.  The tasks practically hang forever without anyone intervening,
possibly holding locks that trip up unrelated tasks, too.

Signed-off-by: Johannes Weiner <jweiner@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff -puN mm/memcontrol.c~memcg-make-oom_lock-0-and-1-based-rather-than-coutner mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-make-oom_lock-0-and-1-based-rather-than-coutner
+++ a/mm/memcontrol.c
@@ -1842,29 +1842,23 @@ static int mem_cgroup_hierarchical_recla
  */
 static bool mem_cgroup_oom_lock(struct mem_cgroup *mem)
 {
-	int lock_count = -1;
 	struct mem_cgroup *iter, *failed = NULL;
 	bool cond = true;
 
 	for_each_mem_cgroup_tree_cond(iter, mem, cond) {
-		bool locked = iter->oom_lock;
-
-		iter->oom_lock = true;
-		if (lock_count == -1)
-			lock_count = iter->oom_lock;
-		else if (lock_count != locked) {
+		if (iter->oom_lock) {
 			/*
 			 * this subtree of our hierarchy is already locked
 			 * so we cannot give a lock.
 			 */
-			lock_count = 0;
 			failed = iter;
 			cond = false;
-		}
+		} else
+			iter->oom_lock = true;
 	}
 
 	if (!failed)
-		goto done;
+		return true;
 
 	/*
 	 * OK, we failed to lock the whole subtree so we have to clean up
@@ -1878,8 +1872,7 @@ static bool mem_cgroup_oom_lock(struct m
 		}
 		iter->oom_lock = false;
 	}
-done:
-	return lock_count;
+	return false;
 }
 
 /*
_

Patches currently in -mm which might be from jweiner@redhat.com are

memcg-pin-execution-to-current-cpu-while-draining-stock.patch
memcg-make-oom_lock-0-and-1-based-rather-than-coutner.patch
linux-next.patch
mm-vmscan-fix-force-scanning-small-targets-without-swap.patch
mm-vmscan-fix-force-scanning-small-targets-without-swap-fix.patch
mm-vmscan-drop-nr_force_scan-from-get_scan_count.patch
mm-vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch
mm-vmscan-remove-dead-code-related-to-lumpy-reclaim-waiting-on-pages-under-writeback.patch
xfs-warn-if-direct-reclaim-tries-to-writeback-pages.patch
ext4-warn-if-direct-reclaim-tries-to-writeback-pages.patch
mm-vmscan-do-not-writeback-filesystem-pages-in-kswapd-except-in-high-priority.patch
mm-vmscan-throttle-reclaim-if-encountering-too-many-dirty-pages-under-writeback.patch
mm-vmscan-immediately-reclaim-end-of-lru-dirty-pages-when-writeback-completes.patch
memcg-remove-unneeded-preempt_disable.patch

