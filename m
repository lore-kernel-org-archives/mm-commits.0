From: akpm@linux-foundation.org
Subject: + memcg-coalesce-charging-via-percpu-storage-fix-2.patch added to -mm tree
Date: Thu, 15 Oct 2009 18:03:42 -0700
Message-ID: <200910160103.n9G13gCp010610@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49589 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758863AbZJPBEf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Oct 2009 21:04:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nishimura@mxp.nes.nec.co.jp, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     memcg: don't do INIT_WORK() repeatedly against the same work_struct
has been added to the -mm tree.  Its filename is
     memcg-coalesce-charging-via-percpu-storage-fix-2.patch

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
Subject: memcg: don't do INIT_WORK() repeatedly against the same work_struct
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

Don't do INIT_WORK() repeatedly against the same work_struct.  It can
actually lead to a BUG.

Just do it once in initialization.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN mm/memcontrol.c~memcg-coalesce-charging-via-percpu-storage-fix-2 mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-coalesce-charging-via-percpu-storage-fix-2
+++ a/mm/memcontrol.c
@@ -1349,8 +1349,8 @@ static void drain_all_stock_async(void)
 	/* This function is for scheduling "drain" in asynchronous way.
 	 * The result of "drain" is not directly handled by callers. Then,
 	 * if someone is calling drain, we don't have to call drain more.
-	 * Anyway, work_pending() will catch if there is a race. We just do
-	 * loose check here.
+	 * Anyway, WORK_STRUCT_PENDING check in queue_work_on() will catch if
+	 * there is a race. We just do loose check here.
 	 */
 	if (atomic_read(&memcg_drain_count))
 		return;
@@ -1359,9 +1359,6 @@ static void drain_all_stock_async(void)
 	get_online_cpus();
 	for_each_online_cpu(cpu) {
 		struct memcg_stock_pcp *stock = &per_cpu(memcg_stock, cpu);
-		if (work_pending(&stock->work))
-			continue;
-		INIT_WORK(&stock->work, drain_local_stock);
 		schedule_work_on(cpu, &stock->work);
 	}
  	put_online_cpus();
@@ -3327,11 +3324,17 @@ mem_cgroup_create(struct cgroup_subsys *
 
 	/* root ? */
 	if (cont->parent == NULL) {
+		int cpu;
 		enable_swap_cgroup();
 		parent = NULL;
 		root_mem_cgroup = mem;
 		if (mem_cgroup_soft_limit_tree_init())
 			goto free_out;
+		for_each_possible_cpu(cpu) {
+			struct memcg_stock_pcp *stock =
+						&per_cpu(memcg_stock, cpu);
+			INIT_WORK(&stock->work, drain_local_stock);
+		}
 		hotcpu_notifier(memcg_stock_cpu_callback, 0);
 
 	} else {
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

memcg-coalesce-uncharge-during-unmap-truncate.patch
memcg-coalesce-charging-via-percpu-storage.patch
memcg-coalesce-charging-via-percpu-storage-fix.patch
memcg-coalesce-charging-via-percpu-storage-fix-2.patch

