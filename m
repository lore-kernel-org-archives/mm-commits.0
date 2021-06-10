Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E9FFC48BD1
	for <mm-commits@archiver.kernel.org>; Thu, 10 Jun 2021 20:35:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40C5361412
	for <mm-commits@archiver.kernel.org>; Thu, 10 Jun 2021 20:35:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbhFJUg5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 10 Jun 2021 16:36:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:38016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229941AbhFJUg4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 10 Jun 2021 16:36:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B54461287;
        Thu, 10 Jun 2021 20:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623357284;
        bh=Vkl87isZ3iwhvbYIhucJzzE4kw1cV3BOx8fjX2CM1C8=;
        h=Date:From:To:Subject:From;
        b=iaHAiyQa9dbog28lLf/mY9rfDqi6jtzo6WQut9LzON1R8m3M4G7P2RZafzSnNhUnk
         nU8fVwOWHr7p10iBooAqCksq95nnF0Mov0GFsws2Ilq9HWCLv9dpTHuBoq2w7eZ9j/
         XraQ6SQ9b12zfbGcx9d+s3uuqlXyOMdb5+zTH1sc=
Date:   Thu, 10 Jun 2021 13:34:44 -0700
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, chris@chrisdown.name, hannes@cmpxchg.org,
        mhocko@suse.com, ming.lei@redhat.com, mm-commits@vger.kernel.org,
        schatzberg.dan@gmail.com, shakeelb@google.com, tj@kernel.org
Subject:  + loop-use-worker-per-cgroup-instead-of-kworker.patch
 added to -mm tree
Message-ID: <20210610203444._mtS4mRkC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: loop: use worker per cgroup instead of kworker
has been added to the -mm tree.  Its filename is
     loop-use-worker-per-cgroup-instead-of-kworker.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/loop-use-worker-per-cgroup-instead-of-kworker.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/loop-use-worker-per-cgroup-instead-of-kworker.patch

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
Subject: loop: use worker per cgroup instead of kworker

Patch series "Charge loop device i/o to issuing cgroup", v14.

The loop device runs all i/o to the backing file on a separate kworker
thread which results in all i/o being charged to the root cgroup.  This
allows a loop device to be used to trivially bypass resource limits and
other policy.  This patch series fixes this gap in accounting.

A simple script to demonstrate this behavior on cgroupv2 machine:

'''
#!/bin/bash
set -e

CGROUP=/sys/fs/cgroup/test.slice
LOOP_DEV=/dev/loop0

if [[ ! -d $CGROUP ]]
then
    sudo mkdir $CGROUP
fi

grep oom_kill $CGROUP/memory.events

# Set a memory limit, write more than that limit to tmpfs -> OOM kill
sudo unshare -m bash -c "
echo \$\$ > $CGROUP/cgroup.procs;
echo 0 > $CGROUP/memory.swap.max;
echo 64M > $CGROUP/memory.max;
mount -t tmpfs -o size=512m tmpfs /tmp;
dd if=/dev/zero of=/tmp/file bs=1M count=256" || true

grep oom_kill $CGROUP/memory.events

# Set a memory limit, write more than that limit through loopback
# device -> no OOM kill
sudo unshare -m bash -c "
echo \$\$ > $CGROUP/cgroup.procs;
echo 0 > $CGROUP/memory.swap.max;
echo 64M > $CGROUP/memory.max;
mount -t tmpfs -o size=512m tmpfs /tmp;
truncate -s 512m /tmp/backing_file
losetup $LOOP_DEV /tmp/backing_file
dd if=/dev/zero of=$LOOP_DEV bs=1M count=256;
losetup -D $LOOP_DEV" || true

grep oom_kill $CGROUP/memory.events
'''

Naively charging cgroups could result in priority inversions through the
single kworker thread in the case where multiple cgroups are
reading/writing to the same loop device.  This patch series does some
minor modification to the loop driver so that each cgroup can make forward
progress independently to avoid this inversion.

With this patch series applied, the above script triggers OOM kills when
writing through the loop device as expected.


This patch (of 3):

Existing uses of loop device may have multiple cgroups reading/writing to
the same device.  Simply charging resources for I/O to the backing file
could result in priority inversion where one cgroup gets synchronously
blocked, holding up all other I/O to the loop device.

In order to avoid this priority inversion, we use a single workqueue where
each work item is a "struct loop_worker" which contains a queue of struct
loop_cmds to issue.  The loop device maintains a tree mapping blk css_id
-> loop_worker.  This allows each cgroup to independently make forward
progress issuing I/O to the backing file.

There is also a single queue for I/O associated with the rootcg which can
be used in cases of extreme memory shortage where we cannot allocate a
loop_worker.

The locking for the tree and queues is fairly heavy handed - we acquire a
per-loop-device spinlock any time either is accessed.  The existing
implementation serializes all I/O through a single thread anyways, so I
don't believe this is any worse.

[colin.king@canonical.com: fixes]
Link: https://lkml.kernel.org/r/20210610173944.1203706-1-schatzberg.dan@gmail.com
Link: https://lkml.kernel.org/r/20210610173944.1203706-2-schatzberg.dan@gmail.com
Signed-off-by: Dan Schatzberg <schatzberg.dan@gmail.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Acked-by: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/loop.c |  209 +++++++++++++++++++++++++++++++++++------
 drivers/block/loop.h |   12 +-
 2 files changed, 187 insertions(+), 34 deletions(-)

--- a/drivers/block/loop.c~loop-use-worker-per-cgroup-instead-of-kworker
+++ a/drivers/block/loop.c
@@ -71,7 +71,6 @@
 #include <linux/writeback.h>
 #include <linux/completion.h>
 #include <linux/highmem.h>
-#include <linux/kthread.h>
 #include <linux/splice.h>
 #include <linux/sysfs.h>
 #include <linux/miscdevice.h>
@@ -84,6 +83,8 @@
 
 #include <linux/uaccess.h>
 
+#define LOOP_IDLE_WORKER_TIMEOUT (60 * HZ)
+
 static DEFINE_IDR(loop_index_idr);
 static DEFINE_MUTEX(loop_ctl_mutex);
 
@@ -921,27 +922,95 @@ static void loop_config_discard(struct l
 	q->limits.discard_alignment = 0;
 }
 
-static void loop_unprepare_queue(struct loop_device *lo)
+struct loop_worker {
+	struct rb_node rb_node;
+	struct work_struct work;
+	struct list_head cmd_list;
+	struct list_head idle_list;
+	struct loop_device *lo;
+	struct cgroup_subsys_state *css;
+	unsigned long last_ran_at;
+};
+
+static void loop_workfn(struct work_struct *work);
+static void loop_rootcg_workfn(struct work_struct *work);
+static void loop_free_idle_workers(struct timer_list *timer);
+
+#ifdef CONFIG_BLK_CGROUP
+static inline int queue_on_root_worker(struct cgroup_subsys_state *css)
 {
-	kthread_flush_worker(&lo->worker);
-	kthread_stop(lo->worker_task);
+	return !css || css == blkcg_root_css;
 }
-
-static int loop_kthread_worker_fn(void *worker_ptr)
+#else
+static inline int queue_on_root_worker(struct cgroup_subsys_state *css)
 {
-	current->flags |= PF_LOCAL_THROTTLE | PF_MEMALLOC_NOIO;
-	return kthread_worker_fn(worker_ptr);
+	return !css;
 }
+#endif
 
-static int loop_prepare_queue(struct loop_device *lo)
+static void loop_queue_work(struct loop_device *lo, struct loop_cmd *cmd)
 {
-	kthread_init_worker(&lo->worker);
-	lo->worker_task = kthread_run(loop_kthread_worker_fn,
-			&lo->worker, "loop%d", lo->lo_number);
-	if (IS_ERR(lo->worker_task))
-		return -ENOMEM;
-	set_user_nice(lo->worker_task, MIN_NICE);
-	return 0;
+	struct rb_node **node = &(lo->worker_tree.rb_node), *parent = NULL;
+	struct loop_worker *cur_worker, *worker = NULL;
+	struct work_struct *work;
+	struct list_head *cmd_list;
+
+	spin_lock_irq(&lo->lo_work_lock);
+
+	if (queue_on_root_worker(cmd->css))
+		goto queue_work;
+
+	node = &lo->worker_tree.rb_node;
+
+	while (*node) {
+		parent = *node;
+		cur_worker = container_of(*node, struct loop_worker, rb_node);
+		if (cur_worker->css == cmd->css) {
+			worker = cur_worker;
+			break;
+		} else if ((long)cur_worker->css < (long)cmd->css) {
+			node = &(*node)->rb_left;
+		} else {
+			node = &(*node)->rb_right;
+		}
+	}
+	if (worker)
+		goto queue_work;
+
+	worker = kzalloc(sizeof(struct loop_worker), GFP_NOWAIT | __GFP_NOWARN);
+	/*
+	 * In the event we cannot allocate a worker, just queue on the
+	 * rootcg worker
+	 */
+	if (!worker)
+		goto queue_work;
+
+	worker->css = cmd->css;
+	css_get(worker->css);
+	INIT_WORK(&worker->work, loop_workfn);
+	INIT_LIST_HEAD(&worker->cmd_list);
+	INIT_LIST_HEAD(&worker->idle_list);
+	worker->lo = lo;
+	rb_link_node(&worker->rb_node, parent, node);
+	rb_insert_color(&worker->rb_node, &lo->worker_tree);
+queue_work:
+	if (worker) {
+		/*
+		 * We need to remove from the idle list here while
+		 * holding the lock so that the idle timer doesn't
+		 * free the worker
+		 */
+		if (!list_empty(&worker->idle_list))
+			list_del_init(&worker->idle_list);
+		work = &worker->work;
+		cmd_list = &worker->cmd_list;
+	} else {
+		work = &lo->rootcg_work;
+		cmd_list = &lo->rootcg_cmd_list;
+	}
+	list_add_tail(&cmd->list_entry, cmd_list);
+	queue_work(lo->workqueue, work);
+	spin_unlock_irq(&lo->lo_work_lock);
 }
 
 static void loop_update_rotational(struct loop_device *lo)
@@ -1127,12 +1196,23 @@ static int loop_configure(struct loop_de
 	    !file->f_op->write_iter)
 		lo->lo_flags |= LO_FLAGS_READ_ONLY;
 
-	error = loop_prepare_queue(lo);
-	if (error)
+	lo->workqueue = alloc_workqueue("loop%d",
+					WQ_UNBOUND | WQ_FREEZABLE,
+					0,
+					lo->lo_number);
+	if (!lo->workqueue) {
+		error = -ENOMEM;
 		goto out_unlock;
+	}
 
 	set_disk_ro(lo->lo_disk, (lo->lo_flags & LO_FLAGS_READ_ONLY) != 0);
 
+	INIT_WORK(&lo->rootcg_work, loop_rootcg_workfn);
+	INIT_LIST_HEAD(&lo->rootcg_cmd_list);
+	INIT_LIST_HEAD(&lo->idle_worker_list);
+	lo->worker_tree = RB_ROOT;
+	timer_setup(&lo->timer, loop_free_idle_workers,
+		TIMER_DEFERRABLE);
 	lo->use_dio = lo->lo_flags & LO_FLAGS_DIRECT_IO;
 	lo->lo_device = bdev;
 	lo->lo_backing_file = file;
@@ -1200,6 +1280,7 @@ static int __loop_clr_fd(struct loop_dev
 	int err = 0;
 	bool partscan = false;
 	int lo_number;
+	struct loop_worker *pos, *worker;
 
 	mutex_lock(&lo->lo_mutex);
 	if (WARN_ON_ONCE(lo->lo_state != Lo_rundown)) {
@@ -1219,6 +1300,18 @@ static int __loop_clr_fd(struct loop_dev
 	/* freeze request queue during the transition */
 	blk_mq_freeze_queue(lo->lo_queue);
 
+	destroy_workqueue(lo->workqueue);
+	spin_lock_irq(&lo->lo_work_lock);
+	list_for_each_entry_safe(worker, pos, &lo->idle_worker_list,
+				idle_list) {
+		list_del(&worker->idle_list);
+		rb_erase(&worker->rb_node, &lo->worker_tree);
+		css_put(worker->css);
+		kfree(worker);
+	}
+	spin_unlock_irq(&lo->lo_work_lock);
+	del_timer_sync(&lo->timer);
+
 	spin_lock_irq(&lo->lo_lock);
 	lo->lo_backing_file = NULL;
 	spin_unlock_irq(&lo->lo_lock);
@@ -1255,7 +1348,6 @@ static int __loop_clr_fd(struct loop_dev
 
 	partscan = lo->lo_flags & LO_FLAGS_PARTSCAN && bdev;
 	lo_number = lo->lo_number;
-	loop_unprepare_queue(lo);
 out_unlock:
 	mutex_unlock(&lo->lo_mutex);
 	if (partscan) {
@@ -2026,7 +2118,7 @@ static blk_status_t loop_queue_rq(struct
 	} else
 #endif
 		cmd->css = NULL;
-	kthread_queue_work(&lo->worker, &cmd->work);
+	loop_queue_work(lo, cmd);
 
 	return BLK_STS_OK;
 }
@@ -2056,26 +2148,82 @@ static void loop_handle_cmd(struct loop_
 	}
 }
 
-static void loop_queue_work(struct kthread_work *work)
+static void loop_set_timer(struct loop_device *lo)
+{
+	timer_reduce(&lo->timer, jiffies + LOOP_IDLE_WORKER_TIMEOUT);
+}
+
+static void loop_process_work(struct loop_worker *worker,
+			struct list_head *cmd_list, struct loop_device *lo)
 {
-	struct loop_cmd *cmd =
-		container_of(work, struct loop_cmd, work);
+	int orig_flags = current->flags;
+	struct loop_cmd *cmd;
+
+	current->flags |= PF_LOCAL_THROTTLE | PF_MEMALLOC_NOIO;
+	spin_lock_irq(&lo->lo_work_lock);
+	while (!list_empty(cmd_list)) {
+		cmd = container_of(
+			cmd_list->next, struct loop_cmd, list_entry);
+		list_del(cmd_list->next);
+		spin_unlock_irq(&lo->lo_work_lock);
+
+		loop_handle_cmd(cmd);
+		cond_resched();
+
+		spin_lock_irq(&lo->lo_work_lock);
+	}
 
-	loop_handle_cmd(cmd);
+	/*
+	 * We only add to the idle list if there are no pending cmds
+	 * *and* the worker will not run again which ensures that it
+	 * is safe to free any worker on the idle list
+	 */
+	if (worker && !work_pending(&worker->work)) {
+		worker->last_ran_at = jiffies;
+		list_add_tail(&worker->idle_list, &lo->idle_worker_list);
+		loop_set_timer(lo);
+	}
+	spin_unlock_irq(&lo->lo_work_lock);
+	current->flags = orig_flags;
 }
 
-static int loop_init_request(struct blk_mq_tag_set *set, struct request *rq,
-		unsigned int hctx_idx, unsigned int numa_node)
+static void loop_workfn(struct work_struct *work)
 {
-	struct loop_cmd *cmd = blk_mq_rq_to_pdu(rq);
+	struct loop_worker *worker =
+		container_of(work, struct loop_worker, work);
+	loop_process_work(worker, &worker->cmd_list, worker->lo);
+}
 
-	kthread_init_work(&cmd->work, loop_queue_work);
-	return 0;
+static void loop_rootcg_workfn(struct work_struct *work)
+{
+	struct loop_device *lo =
+		container_of(work, struct loop_device, rootcg_work);
+	loop_process_work(NULL, &lo->rootcg_cmd_list, lo);
+}
+
+static void loop_free_idle_workers(struct timer_list *timer)
+{
+	struct loop_device *lo = container_of(timer, struct loop_device, timer);
+	struct loop_worker *pos, *worker;
+
+	spin_lock_irq(&lo->lo_work_lock);
+	list_for_each_entry_safe(worker, pos, &lo->idle_worker_list,
+				idle_list) {
+		if (time_is_after_jiffies(worker->last_ran_at +
+						LOOP_IDLE_WORKER_TIMEOUT))
+			break;
+		list_del(&worker->idle_list);
+		rb_erase(&worker->rb_node, &lo->worker_tree);
+		css_put(worker->css);
+		kfree(worker);
+	}
+	if (!list_empty(&lo->idle_worker_list))
+		loop_set_timer(lo);
+	spin_unlock_irq(&lo->lo_work_lock);
 }
 
 static const struct blk_mq_ops loop_mq_ops = {
 	.queue_rq       = loop_queue_rq,
-	.init_request	= loop_init_request,
 	.complete	= lo_complete_rq,
 };
 
@@ -2164,6 +2312,7 @@ static int loop_add(struct loop_device *
 	mutex_init(&lo->lo_mutex);
 	lo->lo_number		= i;
 	spin_lock_init(&lo->lo_lock);
+	spin_lock_init(&lo->lo_work_lock);
 	disk->major		= LOOP_MAJOR;
 	disk->first_minor	= i << part_shift;
 	disk->fops		= &lo_fops;
--- a/drivers/block/loop.h~loop-use-worker-per-cgroup-instead-of-kworker
+++ a/drivers/block/loop.h
@@ -14,7 +14,6 @@
 #include <linux/blk-mq.h>
 #include <linux/spinlock.h>
 #include <linux/mutex.h>
-#include <linux/kthread.h>
 #include <uapi/linux/loop.h>
 
 /* Possible states of device */
@@ -54,8 +53,13 @@ struct loop_device {
 
 	spinlock_t		lo_lock;
 	int			lo_state;
-	struct kthread_worker	worker;
-	struct task_struct	*worker_task;
+	spinlock_t              lo_work_lock;
+	struct workqueue_struct *workqueue;
+	struct work_struct      rootcg_work;
+	struct list_head        rootcg_cmd_list;
+	struct list_head        idle_worker_list;
+	struct rb_root          worker_tree;
+	struct timer_list       timer;
 	bool			use_dio;
 	bool			sysfs_inited;
 
@@ -66,7 +70,7 @@ struct loop_device {
 };
 
 struct loop_cmd {
-	struct kthread_work work;
+	struct list_head list_entry;
 	bool use_aio; /* use AIO interface to handle I/O */
 	atomic_t ref; /* only for aio */
 	long ret;
_

Patches currently in -mm which might be from schatzberg.dan@gmail.com are

loop-use-worker-per-cgroup-instead-of-kworker.patch
mm-charge-active-memcg-when-no-mm-is-set.patch
loop-charge-i-o-to-mem-and-blk-cg.patch

