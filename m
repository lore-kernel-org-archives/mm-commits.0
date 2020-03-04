From: akpm@linux-foundation.org
Subject: [to-be-updated]
 loop-use-worker-per-cgroup-instead-of-kworker.patch removed from -mm tree
Date: Tue, 03 Mar 2020 16:26:59 -0800
Message-ID: <20200304002659.KG1wgzGQ8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727762AbgCDA1C (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Mar 2020 19:27:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axboe@kernel.dk, chris@chrisdown.name, guro@fb.com, hannes@cmpxchg.org, hughd@google.com, lizefan@huawei.com, mhocko@kernel.org, mm-commits@vger.kernel.org, schatzberg.dan@gmail.com, shakeelb@google.com, tglx@linutronix.de, tj@kernel.org, vdavydov.dev@gmail.com, yang.shi@linux.alibaba.com


The patch titled
     Subject: loop: use worker per cgroup instead of kworker
has been removed from the -mm tree.  Its filename was
     loop-use-worker-per-cgroup-instead-of-kworker.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Dan Schatzberg <schatzberg.dan@gmail.com>
Subject: loop: use worker per cgroup instead of kworker

Patch series "Charge loop device i/o to issuing cgroup", v3.

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

The locking for the tree and queues is fairly heavy handed - we acquire
the per-loop-device spinlock any time either is accessed.  The existing
implementation serializes all I/O through a single thread anyways, so I
don't believe this is any worse.

[dan.carpenter@oracle.com: fix IS_ERR() vs NULL bugs in loop_prepare_queue()]
  Link: http://lkml.kernel.org/r/20200228172136.h5dvwvrg5yfywxss@kili.mountain
[schatzberg.dan@gmail.com: fix irq lock ordering bug]
  Link: http://lkml.kernel.org/r/20200228161847.28107-1-schatzberg.dan@gmail.com
Link: http://lkml.kernel.org/r/eab018412a0c9feb573d757b1bbd5f58b33e2a8d.1582581887.git.schatzberg.dan@gmail.com
Signed-off-by: Dan Schatzberg <schatzberg.dan@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/loop.c |  215 +++++++++++++++++++++++++++++++++++------
 drivers/block/loop.h |   11 +-
 2 files changed, 195 insertions(+), 31 deletions(-)

--- a/drivers/block/loop.c~loop-use-worker-per-cgroup-instead-of-kworker
+++ a/drivers/block/loop.c
@@ -70,7 +70,6 @@
 #include <linux/writeback.h>
 #include <linux/completion.h>
 #include <linux/highmem.h>
-#include <linux/kthread.h>
 #include <linux/splice.h>
 #include <linux/sysfs.h>
 #include <linux/miscdevice.h>
@@ -83,6 +82,8 @@
 
 #include <linux/uaccess.h>
 
+#define LOOP_IDLE_WORKER_TIMEOUT (60 * HZ)
+
 static DEFINE_IDR(loop_index_idr);
 static DEFINE_MUTEX(loop_ctl_mutex);
 
@@ -775,12 +776,18 @@ static ssize_t loop_attr_backing_file_sh
 {
 	ssize_t ret;
 	char *p = NULL;
+	struct file *filp = NULL;
 
 	spin_lock_irq(&lo->lo_lock);
 	if (lo->lo_backing_file)
-		p = file_path(lo->lo_backing_file, buf, PAGE_SIZE - 1);
+		filp = get_file(lo->lo_backing_file);
 	spin_unlock_irq(&lo->lo_lock);
 
+	if (filp) {
+		p = file_path(filp, buf, PAGE_SIZE - 1);
+		fput(filp);
+	}
+
 	if (IS_ERR_OR_NULL(p))
 		ret = PTR_ERR(p);
 	else {
@@ -891,27 +898,100 @@ static void loop_config_discard(struct l
 
 static void loop_unprepare_queue(struct loop_device *lo)
 {
-	kthread_flush_worker(&lo->worker);
-	kthread_stop(lo->worker_task);
-}
-
-static int loop_kthread_worker_fn(void *worker_ptr)
-{
-	current->flags |= PF_LESS_THROTTLE | PF_MEMALLOC_NOIO;
-	return kthread_worker_fn(worker_ptr);
+	destroy_workqueue(lo->workqueue);
 }
 
 static int loop_prepare_queue(struct loop_device *lo)
 {
-	kthread_init_worker(&lo->worker);
-	lo->worker_task = kthread_run(loop_kthread_worker_fn,
-			&lo->worker, "loop%d", lo->lo_number);
-	if (IS_ERR(lo->worker_task))
+	lo->workqueue = alloc_workqueue("loop%d",
+					WQ_UNBOUND | WQ_FREEZABLE |
+					WQ_MEM_RECLAIM,
+					lo->lo_number);
+	if (!lo->workqueue)
 		return -ENOMEM;
-	set_user_nice(lo->worker_task, MIN_NICE);
+
 	return 0;
 }
 
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
+static void loop_queue_work(struct loop_device *lo, struct loop_cmd *cmd)
+{
+	struct rb_node **node = &(lo->worker_tree.rb_node), *parent = NULL;
+	struct loop_worker *cur_worker, *worker = NULL;
+	struct work_struct *work;
+	struct list_head *cmd_list;
+
+	spin_lock_irq(&lo->lo_lock);
+
+	if (!cmd->css)
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
+	spin_unlock_irq(&lo->lo_lock);
+}
+
 static void loop_update_rotational(struct loop_device *lo)
 {
 	struct file *file = lo->lo_backing_file;
@@ -993,6 +1073,12 @@ static int loop_set_fd(struct loop_devic
 
 	set_device_ro(bdev, (lo_flags & LO_FLAGS_READ_ONLY) != 0);
 
+	INIT_WORK(&lo->rootcg_work, loop_rootcg_workfn);
+	INIT_LIST_HEAD(&lo->rootcg_cmd_list);
+	INIT_LIST_HEAD(&lo->idle_worker_list);
+	lo->worker_tree = RB_ROOT;
+	timer_setup(&lo->timer, loop_free_idle_workers,
+		TIMER_DEFERRABLE);
 	lo->use_dio = false;
 	lo->lo_device = bdev;
 	lo->lo_flags = lo_flags;
@@ -1101,6 +1187,7 @@ static int __loop_clr_fd(struct loop_dev
 	int err = 0;
 	bool partscan = false;
 	int lo_number;
+	struct loop_worker *pos, *worker;
 
 	mutex_lock(&loop_ctl_mutex);
 	if (WARN_ON_ONCE(lo->lo_state != Lo_rundown)) {
@@ -1117,9 +1204,28 @@ static int __loop_clr_fd(struct loop_dev
 	/* freeze request queue during the transition */
 	blk_mq_freeze_queue(lo->lo_queue);
 
+	/*
+	 * Ordering here is a bit tricky:
+	 *
+	 * 1) flush/destroy workqueue without lock held so outstanding
+	 * I/O is issued and all active workers go idle
+	 *
+	 * 2) Grab lock, free all idle workers
+	 *
+	 * 3) unlock, del_timer_sync so if timer raced it will be a no-op
+	 */
+	loop_unprepare_queue(lo);
 	spin_lock_irq(&lo->lo_lock);
 	lo->lo_backing_file = NULL;
+	list_for_each_entry_safe(worker, pos, &lo->idle_worker_list,
+				idle_list) {
+		list_del(&worker->idle_list);
+		rb_erase(&worker->rb_node, &lo->worker_tree);
+		css_put(worker->css);
+		kfree(worker);
+	}
 	spin_unlock_irq(&lo->lo_lock);
+	del_timer_sync(&lo->timer);
 
 	loop_release_xfer(lo);
 	lo->transfer = NULL;
@@ -1154,7 +1260,6 @@ static int __loop_clr_fd(struct loop_dev
 
 	partscan = lo->lo_flags & LO_FLAGS_PARTSCAN && bdev;
 	lo_number = lo->lo_number;
-	loop_unprepare_queue(lo);
 out_unlock:
 	mutex_unlock(&loop_ctl_mutex);
 	if (partscan) {
@@ -1932,7 +2037,7 @@ static blk_status_t loop_queue_rq(struct
 	} else
 #endif
 		cmd->css = NULL;
-	kthread_queue_work(&lo->worker, &cmd->work);
+	loop_queue_work(lo, cmd);
 
 	return BLK_STS_OK;
 }
@@ -1958,26 +2063,82 @@ static void loop_handle_cmd(struct loop_
 	}
 }
 
-static void loop_queue_work(struct kthread_work *work)
+static void loop_set_timer(struct loop_device *lo)
 {
-	struct loop_cmd *cmd =
-		container_of(work, struct loop_cmd, work);
+	timer_reduce(&lo->timer, jiffies + LOOP_IDLE_WORKER_TIMEOUT);
+}
+
+static void loop_process_work(struct loop_worker *worker,
+			struct list_head *cmd_list, struct loop_device *lo)
+{
+	int orig_flags = current->flags;
+	struct loop_cmd *cmd;
+
+	current->flags |= PF_LESS_THROTTLE | PF_MEMALLOC_NOIO;
+	spin_lock_irq(&lo->lo_lock);
+	while (!list_empty(cmd_list)) {
+		cmd = container_of(
+			cmd_list->next, struct loop_cmd, list_entry);
+		list_del(cmd_list->next);
+		spin_unlock_irq(&lo->lo_lock);
+
+		loop_handle_cmd(cmd);
+		cond_resched();
+
+		spin_lock_irq(&lo->lo_lock);
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
+	spin_unlock_irq(&lo->lo_lock);
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
+	spin_lock_irq(&lo->lo_lock);
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
+	spin_unlock_irq(&lo->lo_lock);
 }
 
 static const struct blk_mq_ops loop_mq_ops = {
 	.queue_rq       = loop_queue_rq,
-	.init_request	= loop_init_request,
 	.complete	= lo_complete_rq,
 };
 
--- a/drivers/block/loop.h~loop-use-worker-per-cgroup-instead-of-kworker
+++ a/drivers/block/loop.h
@@ -14,7 +14,6 @@
 #include <linux/blk-mq.h>
 #include <linux/spinlock.h>
 #include <linux/mutex.h>
-#include <linux/kthread.h>
 #include <uapi/linux/loop.h>
 
 /* Possible states of device */
@@ -54,8 +53,12 @@ struct loop_device {
 
 	spinlock_t		lo_lock;
 	int			lo_state;
-	struct kthread_worker	worker;
-	struct task_struct	*worker_task;
+	struct workqueue_struct *workqueue;
+	struct work_struct      rootcg_work;
+	struct list_head        rootcg_cmd_list;
+	struct list_head        idle_worker_list;
+	struct rb_root          worker_tree;
+	struct timer_list       timer;
 	bool			use_dio;
 	bool			sysfs_inited;
 
@@ -65,7 +68,7 @@ struct loop_device {
 };
 
 struct loop_cmd {
-	struct kthread_work work;
+	struct list_head list_entry;
 	bool use_aio; /* use AIO interface to handle I/O */
 	atomic_t ref; /* only for aio */
 	long ret;
_

Patches currently in -mm which might be from schatzberg.dan@gmail.com are

mm-charge-active-memcg-when-no-mm-is-set.patch
loop-charge-i-o-to-mem-and-blk-cg.patch
