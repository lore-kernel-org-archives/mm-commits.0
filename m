From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-memcg-avoid-oom-notification-when-current-needs-access-to-memory-reserves.patch removed from -mm tree
Date: Tue, 07 Jan 2014 16:26:17 -0800
Message-ID: <52cc9b29.XWs9YCuCVp321FXD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60777 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168AbaAHA0S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jan 2014 19:26:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, ebiederm@xmission.com, rientjes@google.com

Subject: [to-be-updated] mm-memcg-avoid-oom-notification-when-current-needs-access-to-memory-reserves.patch removed from -mm tree
To: rientjes@google.com,ebiederm@xmission.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 07 Jan 2014 16:26:17 -0800


The patch titled
     Subject: mm, memcg: avoid oom notification when current needs access to memory reserves
has been removed from the -mm tree.  Its filename was
     mm-memcg-avoid-oom-notification-when-current-needs-access-to-memory-reserves.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, memcg: avoid oom notification when current needs access to memory reserves

When current has a pending SIGKILL or is already in the exit path, it only
needs access to memory reserves to fully exit.  In that sense, the memcg
is not actually oom for current, it simply needs to bypass memory charges
to exit and free its memory, which is guarantee itself that memory will be
freed.

We only want to notify userspace for actionable oom conditions where
something needs to be done (and all oom handling can already be deferred
to userspace through this method by disabling the memcg oom killer with
memory.oom_control), not simply when a memcg has reached its limit, which
would actually have to happen before memcg reclaim actually frees memory
for charges.

Signed-off-by: David Rientjes <rientjes@google.com>
Reported-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-avoid-oom-notification-when-current-needs-access-to-memory-reserves mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-avoid-oom-notification-when-current-needs-access-to-memory-reserves
+++ a/mm/memcontrol.c
@@ -1783,16 +1783,6 @@ static void mem_cgroup_out_of_memory(str
 	unsigned int points = 0;
 	struct task_struct *chosen = NULL;
 
-	/*
-	 * If current has a pending SIGKILL or is exiting, then automatically
-	 * select it.  The goal is to allow it to allocate so that it may
-	 * quickly exit and free its memory.
-	 */
-	if (fatal_signal_pending(current) || current->flags & PF_EXITING) {
-		set_thread_flag(TIF_MEMDIE);
-		return;
-	}
-
 	check_panic_on_oom(CONSTRAINT_MEMCG, gfp_mask, order, NULL);
 	totalpages = mem_cgroup_get_limit(memcg) >> PAGE_SHIFT ? : 1;
 	for_each_mem_cgroup_tree(iter, memcg) {
@@ -2243,6 +2233,16 @@ bool mem_cgroup_oom_synchronize(bool han
 	if (!handle)
 		goto cleanup;
 
+	/*
+	 * If current has a pending SIGKILL or is exiting, then automatically
+	 * select it.  The goal is to allow it to allocate so that it may
+	 * quickly exit and free its memory.
+	 */
+	if (fatal_signal_pending(current) || current->flags & PF_EXITING) {
+		set_thread_flag(TIF_MEMDIE);
+		goto cleanup;
+	}
+
 	owait.memcg = memcg;
 	owait.wait.flags = 0;
 	owait.wait.func = memcg_oom_wake_function;
_

Patches currently in -mm which might be from rientjes@google.com are

mm-remove-bug_on-from-mlock_vma_page.patch
arch-x86-mm-sratc-skip-numa_no_node-while-parsing-slit.patch
arch-x86-mm-sratc-skip-numa_no_node-while-parsing-slit-fix.patch
mm-mempolicy-remove-unneeded-functions-for-uma-configs.patch
mm-show_mem-remove-show_mem_filter_page_count.patch
mm-show_mem-remove-show_mem_filter_page_count-fix.patch
introduce-for_each_thread-to-replace-the-buggy-while_each_thread.patch
oom_kill-change-oom_killc-to-use-for_each_thread.patch
oom_kill-has_intersects_mems_allowed-needs-rcu_read_lock.patch
oom_kill-add-rcu_read_lock-into-find_lock_task_mm.patch
mm-page_alloc-allow-__gfp_nofail-to-allocate-below-watermarks-after-reclaim.patch
lib-show_memc-show-num_poisoned_pages-when-oom.patch
memcg-oom-lock-mem_cgroup_print_oom_info.patch
mm-page_alloc-warn-for-non-blockable-__gfp_nofail-allocation-failure.patch
fs-proc-pagec-add-pageanon-check-to-surely-detect-thp.patch
checkpatch-add-warning-of-future-__gfp_nofail-use.patch
linux-next.patch

