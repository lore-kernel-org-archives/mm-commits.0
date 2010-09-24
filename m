From: akpm@linux-foundation.org
Subject: + memcg-cpu-hotplug-aware-percpu-count-updates-fix.patch added to -mm tree
Date: Fri, 24 Sep 2010 11:57:42 -0700
Message-ID: <201009241857.o8OIvgS1018719@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51823 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754319Ab0IXS5u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Sep 2010 14:57:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg-cpu-hotplug-aware-percpu-count-updates-fix
has been added to the -mm tree.  Its filename is
     memcg-cpu-hotplug-aware-percpu-count-updates-fix.patch

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
Subject: memcg-cpu-hotplug-aware-percpu-count-updates-fix
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

memcg-use-for_each_mem_cgroup.patch's function mem_cgroup_start_loop() is
wrong because it always scan IDs larger than ROOT of sub-tree.
(This works well in small test..)

css_get_next() scans IDs larger than given number. Then...

Assume a tree like this.

	Root(id=1)--A(id=2)
		  |
		  --B(id=3)--C(id=4)
			   |
			   --D(id=5)

In above case, searching all cgroup under "B" works well because
all IDs larger than B will be visited. (3->4->5)

Here, rmdir "A" and mkdir "E" under "B".

       Root(id=1)--B(id=3)--C(id=4)
			  |
			  --D(id=5)
			  |
			  --E(id=2) /* reuse freed ID */

E's ID is smaller than B's. So, all scan should be started from 1.
The routine will visit (2->3->4->5).

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff -puN mm/memcontrol.c~memcg-cpu-hotplug-aware-percpu-count-updates-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-cpu-hotplug-aware-percpu-count-updates-fix
+++ a/mm/memcontrol.c
@@ -697,12 +697,28 @@ static struct mem_cgroup *try_get_mem_cg
 /* The caller has to guarantee "mem" exists before calling this */
 static struct mem_cgroup *mem_cgroup_start_loop(struct mem_cgroup *mem)
 {
-	if (mem && css_tryget(&mem->css))
-		return mem;
-	if (!mem)
-		return root_mem_cgroup; /*css_put/get against root is ignored*/
+	struct cgroup_subsys_state *css;
+	int found;
 
-	return NULL;
+	if (!mem) /* ROOT cgroup has the smallest ID */
+		return root_mem_cgroup; /*css_put/get against root is ignored*/
+	if (!mem->use_hierarchy) {
+		if (css_tryget(&mem->css))
+			return mem;
+		return NULL;
+	}
+	rcu_read_lock();
+	/*
+	 * searching a memory cgroup which has the smallest ID under given
+	 * ROOT cgroup. (ID >= 1)
+	 */
+	css = css_get_next(&mem_cgroup_subsys, 1, &mem->css, &found);
+	if (css && css_tryget(css))
+		mem = container_of(css, struct mem_cgroup, css);
+	else
+		mem = NULL;
+	rcu_read_unlock();
+	return mem;
 }
 
 static struct mem_cgroup *mem_cgroup_get_next(struct mem_cgroup *iter,
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos-fix.patch
oom-add-per-mm-oom-disable-count.patch
oom-add-per-mm-oom-disable-count-protect-oom_disable_count-with-task_lock-in-fork.patch
oom-add-per-mm-oom-disable-count-use-old_mm-for-oom_disable_count-in-exec.patch
oom-avoid-killing-a-task-if-a-thread-sharing-its-mm-cannot-be-killed.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix-fix.patch
oom-rewrite-error-handling-for-oom_adj-and-oom_score_adj-tunables.patch
oom-fix-locking-for-oom_adj-and-oom_score_adj.patch
memory-hotplug-fix-notifiers-return-value-check.patch
memory-hotplug-unify-is_removable-and-offline-detection-code.patch
memory-hotplug-unify-is_removable-and-offline-detection-code-checkpatch-fixes.patch
tracing-vmscan-add-trace-events-for-lru-list-shrinking.patch
writeback-account-for-time-spent-congestion_waited.patch
vmscan-synchronous-lumpy-reclaim-should-not-call-congestion_wait.patch
vmscan-narrow-the-scenarios-lumpy-reclaim-uses-synchrounous-reclaim.patch
vmscan-remove-dead-code-in-shrink_inactive_list.patch
vmscan-isolated_lru_pages-stop-neighbour-search-if-neighbour-cannot-be-isolated.patch
writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis.patch
writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis-or-if-significant-congestion-is-not-being-encountered-in-the-current-zone.patch
writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis-or-if-significant-congestion-is-not-being-encounted-in-the-current-zone-fix.patch
memcg-fix-race-in-file_mapped-accouting-flag-management.patch
memcg-avoid-lock-in-updating-file_mapped-was-fix-race-in-file_mapped-accouting-flag-management.patch
memcg-use-for_each_mem_cgroup.patch
memcg-cpu-hotplug-aware-percpu-count-updates.patch
memcg-cpu-hotplug-aware-percpu-count-updates-fix.patch
memcg-cpu-hotplug-aware-quick-acount_move-detection.patch
memcg-cpu-hotplug-aware-quick-acount_move-detection-checkpatch-fixes.patch
memcg-generic-filestat-update-interface.patch

