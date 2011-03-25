From: akpm@linux-foundation.org
Subject: [merged] memcg-convert-uncharge-batching-from-bytes-to-page-granularity.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:24:59 -0700
Message-ID: <201103250724.p2P7OrcF025971@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44531 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933773Ab1CYHZB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:25:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: convert uncharge batching from bytes to page granularity
has been removed from the -mm tree.  Its filename was
     memcg-convert-uncharge-batching-from-bytes-to-page-granularity.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: convert uncharge batching from bytes to page granularity
From: Johannes Weiner <hannes@cmpxchg.org>

We never uncharge subpage quantities.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    4 ++--
 mm/memcontrol.c       |   18 ++++++++++--------
 2 files changed, 12 insertions(+), 10 deletions(-)

diff -puN include/linux/sched.h~memcg-convert-uncharge-batching-from-bytes-to-page-granularity include/linux/sched.h
--- a/include/linux/sched.h~memcg-convert-uncharge-batching-from-bytes-to-page-granularity
+++ a/include/linux/sched.h
@@ -1524,8 +1524,8 @@ struct task_struct {
 	struct memcg_batch_info {
 		int do_batch;	/* incremented when batch uncharge started */
 		struct mem_cgroup *memcg; /* target memcg of uncharge */
-		unsigned long bytes; 		/* uncharged usage */
-		unsigned long memsw_bytes; /* uncharged mem+swap usage */
+		unsigned long nr_pages;	/* uncharged usage */
+		unsigned long memsw_nr_pages; /* uncharged mem+swap usage */
 	} memcg_batch;
 #endif
 };
diff -puN mm/memcontrol.c~memcg-convert-uncharge-batching-from-bytes-to-page-granularity mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-convert-uncharge-batching-from-bytes-to-page-granularity
+++ a/mm/memcontrol.c
@@ -2579,9 +2579,9 @@ __do_uncharge(struct mem_cgroup *mem, co
 	if (batch->memcg != mem)
 		goto direct_uncharge;
 	/* remember freed charge and uncharge it later */
-	batch->bytes += PAGE_SIZE;
+	batch->nr_pages++;
 	if (uncharge_memsw)
-		batch->memsw_bytes += PAGE_SIZE;
+		batch->memsw_nr_pages++;
 	return;
 direct_uncharge:
 	res_counter_uncharge(&mem->res, page_size);
@@ -2708,8 +2708,8 @@ void mem_cgroup_uncharge_start(void)
 	/* We can do nest. */
 	if (current->memcg_batch.do_batch == 1) {
 		current->memcg_batch.memcg = NULL;
-		current->memcg_batch.bytes = 0;
-		current->memcg_batch.memsw_bytes = 0;
+		current->memcg_batch.nr_pages = 0;
+		current->memcg_batch.memsw_nr_pages = 0;
 	}
 }
 
@@ -2730,10 +2730,12 @@ void mem_cgroup_uncharge_end(void)
 	 * This "batch->memcg" is valid without any css_get/put etc...
 	 * bacause we hide charges behind us.
 	 */
-	if (batch->bytes)
-		res_counter_uncharge(&batch->memcg->res, batch->bytes);
-	if (batch->memsw_bytes)
-		res_counter_uncharge(&batch->memcg->memsw, batch->memsw_bytes);
+	if (batch->nr_pages)
+		res_counter_uncharge(&batch->memcg->res,
+				     batch->nr_pages * PAGE_SIZE);
+	if (batch->memsw_nr_pages)
+		res_counter_uncharge(&batch->memcg->memsw,
+				     batch->memsw_nr_pages * PAGE_SIZE);
 	memcg_oom_recover(batch->memcg);
 	/* forget this pointer (for sanity check) */
 	batch->memcg = NULL;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-add-vm-counters-for-transparent-hugepages.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-add-dirty-page-accounting-infrastructure.patch
memcg-add-kernel-calls-for-memcg-dirty-page-stats.patch
memcg-add-dirty-limits-to-mem_cgroup.patch
memcg-add-cgroupfs-interface-to-memcg-dirty-limits.patch
memcg-add-dirty-limiting-routines.patch
memcg-check-memcg-dirty-limits-in-page-writeback.patch
memcg-make-background-writeback-memcg-aware.patch

