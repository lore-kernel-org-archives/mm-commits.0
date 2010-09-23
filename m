From: akpm@linux-foundation.org
Subject: + memcg-generic-filestat-update-interface.patch added to -mm tree
Date: Thu, 23 Sep 2010 14:40:55 -0700
Message-ID: <201009232140.o8NLetXc020627@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51396 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754195Ab0IWVvH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Sep 2010 17:51:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, gthelen@google.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: generic filestat update interface
has been added to the -mm tree.  Its filename is
     memcg-generic-filestat-update-interface.patch

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
Subject: memcg: generic filestat update interface
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

This patch extracts the core logic from mem_cgroup_update_file_mapped() as
mem_cgroup_update_file_stat() and adds a wrapper.

As a planned future update, memory cgroup has to count dirty pages to
implement dirty_ratio/limit.  And more, the number of dirty pages is
required to kick flusher thread to start writeback.  (Now, no kick.)

This patch is preparation for it and makes other statistics implementation
clearer.  Just a clean up.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Reviewed-by: Greg Thelen <gthelen@google.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff -puN mm/memcontrol.c~memcg-generic-filestat-update-interface mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-generic-filestat-update-interface
+++ a/mm/memcontrol.c
@@ -1575,7 +1575,8 @@ bool mem_cgroup_handle_oom(struct mem_cg
  * small, we check MEM_CGROUP_ON_MOVE percpu value and detect there are
  * possibility of race condition. If there is, we take a lock.
  */
-void mem_cgroup_update_file_mapped(struct page *page, int val)
+
+static void mem_cgroup_update_file_stat(struct page *page, int idx, int val)
 {
 	struct mem_cgroup *mem;
 	struct page_cgroup *pc = lookup_page_cgroup(page);
@@ -1597,13 +1598,18 @@ void mem_cgroup_update_file_mapped(struc
 		if (!mem || !PageCgroupUsed(pc))
 			goto out;
 	}
-	if (val > 0) {
-		this_cpu_inc(mem->stat->count[MEM_CGROUP_STAT_FILE_MAPPED]);
-		SetPageCgroupFileMapped(pc);
-	} else {
-		this_cpu_dec(mem->stat->count[MEM_CGROUP_STAT_FILE_MAPPED]);
-		if (!page_mapped(page)) /* for race between dec->inc counter */
+
+	this_cpu_add(mem->stat->count[idx], val);
+
+	switch (idx) {
+	case MEM_CGROUP_STAT_FILE_MAPPED:
+		if (val > 0)
+			SetPageCgroupFileMapped(pc);
+		else if (!page_mapped(page))
 			ClearPageCgroupFileMapped(pc);
+		break;
+	default:
+		BUG();
 	}
 
 out:
@@ -1613,6 +1619,11 @@ out:
 	return;
 }
 
+void mem_cgroup_update_file_mapped(struct page *page, int val)
+{
+	mem_cgroup_update_file_stat(page, MEM_CGROUP_STAT_FILE_MAPPED, val);
+}
+
 /*
  * size of first charge trial. "32" comes from vmscan.c's magic value.
  * TODO: maybe necessary to use big numbers in big irons.
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
memcg-cpu-hotplug-aware-quick-acount_move-detection.patch
memcg-cpu-hotplug-aware-quick-acount_move-detection-checkpatch-fixes.patch
memcg-generic-filestat-update-interface.patch

