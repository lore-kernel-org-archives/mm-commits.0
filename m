Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ACC7C11F6B
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:38:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53D5761D06
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:38:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231743AbhF2Ckt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:40:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:33240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231719AbhF2Cks (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:40:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41B9E61A2B;
        Tue, 29 Jun 2021 02:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934302;
        bh=p8nWmsh0L7iFn+uqFggyb86s92TdWxIhi5BSTuMNshM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Oy7nz9mOOteM1mFO+MCDnZkoW1XtOl+ElPVBlIpUVfkHIS0tW8XA8QBa06fB4w+Gz
         smZvMiHE9oBckSGDXZNX37zia8yn6NPoDkavrCIQZMmzMrBD5jjmQtaDF4mJLMXrIN
         5qT6SOuIq78RVeltkqRkdS0nl4PTzjGJhbc2BkaI=
Date:   Mon, 28 Jun 2021 19:38:21 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, axboe@kernel.dk, chris@chrisdown.name,
        hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@suse.com,
        ming.lei@redhat.com, mm-commits@vger.kernel.org,
        schatzberg.dan@gmail.com, shakeelb@google.com, tj@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 096/192] loop: charge i/o to mem and blk cg
Message-ID: <20210629023821.6LESjMCz_%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Dan Schatzberg <schatzberg.dan@gmail.com>
Subject: loop: charge i/o to mem and blk cg

The current code only associates with the existing blkcg when aio is used
to access the backing file.  This patch covers all types of i/o to the
backing file and also associates the memcg so if the backing file is on
tmpfs, memory is charged appropriately.

This patch also exports cgroup_get_e_css and int_active_memcg so it can be
used by the loop module.

Link: https://lkml.kernel.org/r/20210610173944.1203706-4-schatzberg.dan@gmail.com
Signed-off-by: Dan Schatzberg <schatzberg.dan@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Jens Axboe <axboe@kernel.dk>
Cc: Chris Down <chris@chrisdown.name>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/loop.c       |   61 +++++++++++++++++++++++------------
 drivers/block/loop.h       |    3 +
 include/linux/memcontrol.h |    6 +++
 kernel/cgroup/cgroup.c     |    1 
 mm/memcontrol.c            |    1 
 5 files changed, 51 insertions(+), 21 deletions(-)

--- a/drivers/block/loop.c~loop-charge-i-o-to-mem-and-blk-cg
+++ a/drivers/block/loop.c
@@ -78,6 +78,7 @@
 #include <linux/uio.h>
 #include <linux/ioprio.h>
 #include <linux/blk-cgroup.h>
+#include <linux/sched/mm.h>
 
 #include "loop.h"
 
@@ -516,8 +517,6 @@ static void lo_rw_aio_complete(struct ki
 {
 	struct loop_cmd *cmd = container_of(iocb, struct loop_cmd, iocb);
 
-	if (cmd->css)
-		css_put(cmd->css);
 	cmd->ret = ret;
 	lo_rw_aio_do_completion(cmd);
 }
@@ -578,8 +577,6 @@ static int lo_rw_aio(struct loop_device
 	cmd->iocb.ki_complete = lo_rw_aio_complete;
 	cmd->iocb.ki_flags = IOCB_DIRECT;
 	cmd->iocb.ki_ioprio = IOPRIO_PRIO_VALUE(IOPRIO_CLASS_NONE, 0);
-	if (cmd->css)
-		kthread_associate_blkcg(cmd->css);
 
 	if (rw == WRITE)
 		ret = call_write_iter(file, &cmd->iocb, &iter);
@@ -587,7 +584,6 @@ static int lo_rw_aio(struct loop_device
 		ret = call_read_iter(file, &cmd->iocb, &iter);
 
 	lo_rw_aio_do_completion(cmd);
-	kthread_associate_blkcg(NULL);
 
 	if (ret != -EIOCBQUEUED)
 		cmd->iocb.ki_complete(&cmd->iocb, ret, 0);
@@ -928,7 +924,7 @@ struct loop_worker {
 	struct list_head cmd_list;
 	struct list_head idle_list;
 	struct loop_device *lo;
-	struct cgroup_subsys_state *css;
+	struct cgroup_subsys_state *blkcg_css;
 	unsigned long last_ran_at;
 };
 
@@ -957,7 +953,7 @@ static void loop_queue_work(struct loop_
 
 	spin_lock_irq(&lo->lo_work_lock);
 
-	if (queue_on_root_worker(cmd->css))
+	if (queue_on_root_worker(cmd->blkcg_css))
 		goto queue_work;
 
 	node = &lo->worker_tree.rb_node;
@@ -965,10 +961,10 @@ static void loop_queue_work(struct loop_
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
@@ -980,13 +976,18 @@ static void loop_queue_work(struct loop_
 	worker = kzalloc(sizeof(struct loop_worker), GFP_NOWAIT | __GFP_NOWARN);
 	/*
 	 * In the event we cannot allocate a worker, just queue on the
-	 * rootcg worker
+	 * rootcg worker and issue the I/O as the rootcg
 	 */
-	if (!worker)
+	if (!worker) {
+		cmd->blkcg_css = NULL;
+		if (cmd->memcg_css)
+			css_put(cmd->memcg_css);
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
@@ -1306,7 +1307,7 @@ static int __loop_clr_fd(struct loop_dev
 				idle_list) {
 		list_del(&worker->idle_list);
 		rb_erase(&worker->rb_node, &lo->worker_tree);
-		css_put(worker->css);
+		css_put(worker->blkcg_css);
 		kfree(worker);
 	}
 	spin_unlock_irq(&lo->lo_work_lock);
@@ -2100,13 +2101,18 @@ static blk_status_t loop_queue_rq(struct
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
@@ -2118,13 +2124,28 @@ static void loop_handle_cmd(struct loop_
 	const bool write = op_is_write(req_op(rq));
 	struct loop_device *lo = rq->q->queuedata;
 	int ret = 0;
+	struct mem_cgroup *old_memcg = NULL;
 
 	if (write && (lo->lo_flags & LO_FLAGS_READ_ONLY)) {
 		ret = -EIO;
 		goto failed;
 	}
 
+	if (cmd->blkcg_css)
+		kthread_associate_blkcg(cmd->blkcg_css);
+	if (cmd->memcg_css)
+		old_memcg = set_active_memcg(
+			mem_cgroup_from_css(cmd->memcg_css));
+
 	ret = do_req_filebacked(lo, rq);
+
+	if (cmd->blkcg_css)
+		kthread_associate_blkcg(NULL);
+
+	if (cmd->memcg_css) {
+		set_active_memcg(old_memcg);
+		css_put(cmd->memcg_css);
+	}
  failed:
 	/* complete non-aio request */
 	if (!cmd->use_aio || ret) {
@@ -2203,7 +2224,7 @@ static void loop_free_idle_workers(struc
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
@@ -77,7 +77,8 @@ struct loop_cmd {
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
@@ -1230,6 +1230,12 @@ static inline struct mem_cgroup *get_mem
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
@@ -577,6 +577,7 @@ out_unlock:
 	rcu_read_unlock();
 	return css;
 }
+EXPORT_SYMBOL_GPL(cgroup_get_e_css);
 
 static void cgroup_get_live(struct cgroup *cgrp)
 {
--- a/mm/memcontrol.c~loop-charge-i-o-to-mem-and-blk-cg
+++ a/mm/memcontrol.c
@@ -78,6 +78,7 @@ struct mem_cgroup *root_mem_cgroup __rea
 
 /* Active memory cgroup to use from an interrupt context */
 DEFINE_PER_CPU(struct mem_cgroup *, int_active_memcg);
+EXPORT_PER_CPU_SYMBOL_GPL(int_active_memcg);
 
 /* Socket memory accounting disabled? */
 static bool cgroup_memory_nosocket;
_
