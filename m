From: akpm@linux-foundation.org
Subject: - memcg-protect-prev_priority.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:49:25 -0800
Message-ID: <200901082249.n08MnP73028709@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44906 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762824AbZAHWuF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:50:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, balbir@in.ibm.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: protect prev_priority
has been removed from the -mm tree.  Its filename was
     memcg-protect-prev_priority.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: protect prev_priority
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Currently, mem_cgroup doesn't have own lock and almost its member doesn't
need.  (e.g.  mem_cgroup->info is protected by zone lock, mem_cgroup->stat
is per cpu variable)

However, there is one explict exception.  mem_cgroup->prev_priorit need
lock, but doesn't protect.  Luckly, this is NOT bug because prev_priority
isn't used for current reclaim code.

However, we plan to use prev_priority future again.  Therefore, fixing is
better.

In addition, we plan to reuse this lock for another member.  Then
"reclaim_param_lock" name is better than "prev_priority_lock".

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-protect-prev_priority mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-protect-prev_priority
+++ a/mm/memcontrol.c
@@ -144,6 +144,11 @@ struct mem_cgroup {
 	 */
 	struct mem_cgroup_lru_info info;
 
+	/*
+	  protect against reclaim related member.
+	*/
+	spinlock_t reclaim_param_lock;
+
 	int	prev_priority;	/* for recording reclaim priority */
 
 	/*
@@ -400,18 +405,28 @@ int mem_cgroup_calc_mapped_ratio(struct 
  */
 int mem_cgroup_get_reclaim_priority(struct mem_cgroup *mem)
 {
-	return mem->prev_priority;
+	int prev_priority;
+
+	spin_lock(&mem->reclaim_param_lock);
+	prev_priority = mem->prev_priority;
+	spin_unlock(&mem->reclaim_param_lock);
+
+	return prev_priority;
 }
 
 void mem_cgroup_note_reclaim_priority(struct mem_cgroup *mem, int priority)
 {
+	spin_lock(&mem->reclaim_param_lock);
 	if (priority < mem->prev_priority)
 		mem->prev_priority = priority;
+	spin_unlock(&mem->reclaim_param_lock);
 }
 
 void mem_cgroup_record_reclaim_priority(struct mem_cgroup *mem, int priority)
 {
+	spin_lock(&mem->reclaim_param_lock);
 	mem->prev_priority = priority;
+	spin_unlock(&mem->reclaim_param_lock);
 }
 
 int mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg, struct zone *zone)
@@ -2076,6 +2091,7 @@ mem_cgroup_create(struct cgroup_subsys *
 	}
 	mem_cgroup_set_inactive_ratio(mem);
 	mem->last_scanned_child = NULL;
+	spin_lock_init(&mem->reclaim_param_lock);
 
 	return &mem->css;
 free_out:
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
getrusage-fill-ru_maxrss-value.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
ia64-implement-interrupt-enabling-rwlocks.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

