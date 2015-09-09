From: akpm@linux-foundation.org
Subject: [merged]
 mm-oom-pass-an-oom-order-of-1-when-triggered-by-sysrq.patch removed from
 -mm tree
Date: Wed, 09 Sep 2015 12:44:18 -0700
Message-ID: <55f08c12.+qL0fg59vlqqDKE5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38948 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803AbbIIToU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:44:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, mhocko@suse.cz, sergey.senozhatsky.work@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: pass an oom order of -1 when triggered by sysrq
has been removed from the -mm tree.  Its filename was
     mm-oom-pass-an-oom-order-of-1-when-triggered-by-sysrq.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, oom: pass an oom order of -1 when triggered by sysrq

The force_kill member of struct oom_control isn't needed if an order of -1
is used instead.  This is the same as order == -1 in struct
compact_control which requires full memory compaction.

This patch introduces no functional change.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/sysrq.c |    3 +--
 include/linux/oom.h |    1 -
 mm/memcontrol.c     |    1 -
 mm/oom_kill.c       |    5 ++---
 mm/page_alloc.c     |    1 -
 5 files changed, 3 insertions(+), 8 deletions(-)

diff -puN drivers/tty/sysrq.c~mm-oom-pass-an-oom-order-of-1-when-triggered-by-sysrq drivers/tty/sysrq.c
--- a/drivers/tty/sysrq.c~mm-oom-pass-an-oom-order-of-1-when-triggered-by-sysrq
+++ a/drivers/tty/sysrq.c
@@ -358,8 +358,7 @@ static void moom_callback(struct work_st
 		.zonelist = node_zonelist(first_memory_node, gfp_mask),
 		.nodemask = NULL,
 		.gfp_mask = gfp_mask,
-		.order = 0,
-		.force_kill = true,
+		.order = -1,
 	};
 
 	mutex_lock(&oom_lock);
diff -puN include/linux/oom.h~mm-oom-pass-an-oom-order-of-1-when-triggered-by-sysrq include/linux/oom.h
--- a/include/linux/oom.h~mm-oom-pass-an-oom-order-of-1-when-triggered-by-sysrq
+++ a/include/linux/oom.h
@@ -17,7 +17,6 @@ struct oom_control {
 	nodemask_t	*nodemask;
 	gfp_t		gfp_mask;
 	int		order;
-	bool		force_kill;
 };
 
 /*
diff -puN mm/memcontrol.c~mm-oom-pass-an-oom-order-of-1-when-triggered-by-sysrq mm/memcontrol.c
--- a/mm/memcontrol.c~mm-oom-pass-an-oom-order-of-1-when-triggered-by-sysrq
+++ a/mm/memcontrol.c
@@ -1550,7 +1550,6 @@ static void mem_cgroup_out_of_memory(str
 		.nodemask = NULL,
 		.gfp_mask = gfp_mask,
 		.order = order,
-		.force_kill = false,
 	};
 	struct mem_cgroup *iter;
 	unsigned long chosen_points = 0;
diff -puN mm/oom_kill.c~mm-oom-pass-an-oom-order-of-1-when-triggered-by-sysrq mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-pass-an-oom-order-of-1-when-triggered-by-sysrq
+++ a/mm/oom_kill.c
@@ -265,7 +265,7 @@ enum oom_scan_t oom_scan_process_thread(
 	 * Don't allow any other task to have access to the reserves.
 	 */
 	if (test_tsk_thread_flag(task, TIF_MEMDIE)) {
-		if (!oc->force_kill)
+		if (oc->order != -1)
 			return OOM_SCAN_ABORT;
 	}
 	if (!task->mm)
@@ -278,7 +278,7 @@ enum oom_scan_t oom_scan_process_thread(
 	if (oom_task_origin(task))
 		return OOM_SCAN_SELECT;
 
-	if (task_will_free_mem(task) && !oc->force_kill)
+	if (task_will_free_mem(task) && oc->order != -1)
 		return OOM_SCAN_ABORT;
 
 	return OOM_SCAN_OK;
@@ -718,7 +718,6 @@ void pagefault_out_of_memory(void)
 		.nodemask = NULL,
 		.gfp_mask = 0,
 		.order = 0,
-		.force_kill = false,
 	};
 
 	if (mem_cgroup_oom_synchronize(true))
diff -puN mm/page_alloc.c~mm-oom-pass-an-oom-order-of-1-when-triggered-by-sysrq mm/page_alloc.c
--- a/mm/page_alloc.c~mm-oom-pass-an-oom-order-of-1-when-triggered-by-sysrq
+++ a/mm/page_alloc.c
@@ -2698,7 +2698,6 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 		.nodemask = ac->nodemask,
 		.gfp_mask = gfp_mask,
 		.order = order,
-		.force_kill = false,
 	};
 	struct page *page;
 
_

Patches currently in -mm which might be from rientjes@google.com are


