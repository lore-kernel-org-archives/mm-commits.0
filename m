From: Andrew Morton <akpm@linux-foundation.org>
Subject: + loop-charge-i-o-to-mem-and-blk-cg.patch added to -mm
 tree
Date: Mon, 24 Feb 2020 14:55:46 -0800
Message-ID: <20200224225546.ya056X1tB%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726651AbgBXWzs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 Feb 2020 17:55:48 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axboe@kernel.dk, chris@chrisdown.name, guro@fb.com, hannes@cmpxchg.org, hughd@google.com, lizefan@huawei.com, mhocko@kernel.org, mm-commits@vger.kernel.org, schatzberg.dan@gmail.com, shakeelb@google.com, tglx@linutronix.de, tj@kernel.org, vdavydov.dev@gmail.com, yang.shi@linux.alibaba.com


The patch titled
     Subject: loop: charge i/o to mem and blk cg
has been added to the -mm tree.  Its filename is
     loop-charge-i-o-to-mem-and-blk-cg.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/loop-charge-i-o-to-mem-and-blk-cg.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/loop-charge-i-o-to-mem-and-blk-cg.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Schatzberg <schatzberg.dan@gmail.com>
Subject: loop: charge i/o to mem and blk cg

The current code only associates with the existing blkcg when aio is used
to access the backing file.  This patch covers all types of i/o to the
backing file and also associates the memcg so if the backing file is on
tmpfs, memory is charged appropriately.

This patch also exports cgroup_get_e_css so it can be used by the loop
module.

Link: http://lkml.kernel.org/r/206afee596c3f30c05b31ae5fc8b7f5d58863dc0.1582581887.git.schatzberg.dan@gmail.com
Signed-off-by: Dan Schatzberg <schatzberg.dan@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chris Down <chris@chrisdown.name>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/loop.c       |   59 ++++++++++++++++++++++-------------
 drivers/block/loop.h       |    3 +
 include/linux/memcontrol.h |    6 +++
 kernel/cgroup/cgroup.c     |    1 
 4 files changed, 47 insertions(+), 22 deletions(-)

--- a/drivers/block/loop.c~loop-charge-i-o-to-mem-and-blk-cg
+++ a/drivers/block/loop.c
@@ -77,6 +77,7 @@
 #include <linux/uio.h>
 #include <linux/ioprio.h>
 #include <linux/blk-cgroup.h>
+#include <linux/sched/mm.h>
 
 #include "loop.h"
 
@@ -504,8 +505,6 @@ static void lo_rw_aio_complete(struct ki
 {
 	struct loop_cmd *cmd = container_of(iocb, struct loop_cmd, iocb);
 
-	if (cmd->css)
-		css_put(cmd->css);
 	cmd->ret = ret;
 	lo_rw_aio_do_completion(cmd);
 }
@@ -566,8 +565,6 @@ static int lo_rw_aio(struct loop_device
 	cmd->iocb.ki_complete = lo_rw_aio_complete;
 	cmd->iocb.ki_flags = IOCB_DIRECT;
 	cmd->iocb.ki_ioprio = IOPRIO_PRIO_VALUE(IOPRIO_CLASS_NONE, 0);
-	if (cmd->css)
-		kthread_associate_blkcg(cmd->css);
 
 	if (rw == WRITE)
 		ret = call_write_iter(file, &cmd->iocb, &iter);
@@ -575,7 +572,6 @@ static int lo_rw_aio(struct loop_device
 		ret = call_read_iter(file, &cmd->iocb, &iter);
 
 	lo_rw_aio_do_completion(cmd);
-	kthread_associate_blkcg(NULL);
 
 	if (ret != -EIOCBQUEUED)
 		cmd->iocb.ki_complete(&cmd->iocb, ret, 0);
@@ -913,7 +909,7 @@ struct loop_worker {
 	struct list_head cmd_list;
 	struct list_head idle_list;
 	struct loop_device *lo;
-	struct cgroup_subsys_state *css;
+	struct cgroup_subsys_state *blkcg_css;
 	unsigned long last_ran_at;
 };
 
@@ -930,7 +926,7 @@ static void loop_queue_work(struct loop_
 
 	spin_lock_irq(&lo->lo_lock);
 
-	if (!cmd->css)
+	if (!cmd->blkcg_css)
 		goto queue_work;
 
 	node = &lo->worker_tree.rb_node;
@@ -938,10 +934,10 @@ static void loop_queue_work(struct loop_
 	while (*node) {
 		parent = *node;
 		cur_worker = container_of(*node, struct loop_worker, rb_node);
-		if (cur_worker->css == cmd->css) {
+		if (cur_worker->blkcg_css == cmd->blkcg_css) {
 			worker = cur_worker;
 			break;
-		} else if ((long)cur_worker->css < (long)cmd->css) {
+		} else if ((long)cur_worker->blkcg_css < (long)cmd->blkcg_css) {
 			node = &(*node)->rb_left;
 		} else {
 			node = &(*node)->rb_right;
@@ -953,13 +949,16 @@ static void loop_queue_work(struct loop_
 	worker = kzalloc(sizeof(struct loop_worker), GFP_NOWAIT | __GFP_NOWARN);
 	/*
 	 * In the event we cannot allocate a worker, just queue on the
-	 * rootcg worker
+	 * rootcg worker and issue the I/O as the rootcg
 	 */
-	if (!worker)
+	if (!worker) {
+		cmd->blkcg_css = NULL;
+		cmd->memcg_css = NULL;
 		goto queue_work;
+	}
 
-	worker->css = cmd->css;
-	css_get(worker->css);
+	worker->blkcg_css = cmd->blkcg_css;
+	css_get(worker->blkcg_css);
 	INIT_WORK(&worker->work, loop_workfn);
 	INIT_LIST_HEAD(&worker->cmd_list);
 	INIT_LIST_HEAD(&worker->idle_list);
@@ -1215,7 +1214,7 @@ static int __loop_clr_fd(struct loop_dev
 				idle_list) {
 		list_del(&worker->idle_list);
 		rb_erase(&worker->rb_node, &lo->worker_tree);
-		css_put(worker->css);
+		css_put(worker->blkcg_css);
 		kfree(worker);
 	}
 	spin_unlock_irq(&lo->lo_lock);
@@ -2024,13 +2023,18 @@ static blk_status_t loop_queue_rq(struct
 	}
 
 	/* always use the first bio's css */
+	cmd->blkcg_css = NULL;
+	cmd->memcg_css = NULL;
 #ifdef CONFIG_BLK_CGROUP
-	if (cmd->use_aio && rq->bio && rq->bio->bi_blkg) {
-		cmd->css = &bio_blkcg(rq->bio)->css;
-		css_get(cmd->css);
-	} else
+	if (rq->bio && rq->bio->bi_blkg) {
+		cmd->blkcg_css = &bio_blkcg(rq->bio)->css;
+#ifdef CONFIG_MEMCG
+		cmd->memcg_css =
+			cgroup_get_e_css(cmd->blkcg_css->cgroup,
+					&memory_cgrp_subsys);
+#endif
+	}
 #endif
-		cmd->css = NULL;
 	loop_queue_work(lo, cmd);
 
 	return BLK_STS_OK;
@@ -2048,8 +2052,21 @@ static void loop_handle_cmd(struct loop_
 		goto failed;
 	}
 
+	if (cmd->blkcg_css)
+		kthread_associate_blkcg(cmd->blkcg_css);
+	if (cmd->memcg_css)
+		memalloc_use_memcg(mem_cgroup_from_css(cmd->memcg_css));
+
 	ret = do_req_filebacked(lo, rq);
- failed:
+
+	if (cmd->blkcg_css)
+		kthread_associate_blkcg(NULL);
+
+	if (cmd->memcg_css) {
+		memalloc_unuse_memcg();
+		css_put(cmd->memcg_css);
+	}
+failed:
 	/* complete non-aio request */
 	if (!cmd->use_aio || ret) {
 		cmd->ret = ret ? -EIO : 0;
@@ -2123,7 +2140,7 @@ static void loop_free_idle_workers(struc
 			break;
 		list_del(&worker->idle_list);
 		rb_erase(&worker->rb_node, &lo->worker_tree);
-		css_put(worker->css);
+		css_put(worker->blkcg_css);
 		kfree(worker);
 	}
 	if (!list_empty(&lo->idle_worker_list))
--- a/drivers/block/loop.h~loop-charge-i-o-to-mem-and-blk-cg
+++ a/drivers/block/loop.h
@@ -74,7 +74,8 @@ struct loop_cmd {
 	long ret;
 	struct kiocb iocb;
 	struct bio_vec *bvec;
-	struct cgroup_subsys_state *css;
+	struct cgroup_subsys_state *blkcg_css;
+	struct cgroup_subsys_state *memcg_css;
 };
 
 /* Support for loadable transfer modules */
--- a/include/linux/memcontrol.h~loop-charge-i-o-to-mem-and-blk-cg
+++ a/include/linux/memcontrol.h
@@ -922,6 +922,12 @@ static inline struct mem_cgroup *get_mem
 	return NULL;
 }
 
+static inline
+struct mem_cgroup *mem_cgroup_from_css(struct cgroup_subsys_state *css)
+{
+	return NULL;
+}
+
 static inline void mem_cgroup_put(struct mem_cgroup *memcg)
 {
 }
--- a/kernel/cgroup/cgroup.c~loop-charge-i-o-to-mem-and-blk-cg
+++ a/kernel/cgroup/cgroup.c
@@ -587,6 +587,7 @@ out_unlock:
 	rcu_read_unlock();
 	return css;
 }
+EXPORT_SYMBOL_GPL(cgroup_get_e_css);
 
 static void cgroup_get_live(struct cgroup *cgrp)
 {
_

Patches currently in -mm which might be from schatzberg.dan@gmail.com are

loop-use-worker-per-cgroup-instead-of-kworker.patch
mm-charge-active-memcg-when-no-mm-is-set.patch
loop-charge-i-o-to-mem-and-blk-cg.patch
