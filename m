From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 16/25] kernel: set USER_DS in kthread_use_mm
Date: Wed, 10 Jun 2020 18:42:10 -0700
Message-ID: <20200611014210.3tbO0fWBm%akpm@linux-foundation.org>
References: <20200610184053.3fa7368ab80e23bfd44de71f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726163AbgFKBmM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Jun 2020 21:42:12 -0400
In-Reply-To: <20200610184053.3fa7368ab80e23bfd44de71f@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alexander.deucher@amd.com, axboe@kernel.dk, balbi@kernel.org, Felix.Kuehling@amd.com, gregkh@linuxfoundation.org, hch@lst.de, jasowang@redhat.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, mst@redhat.com, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, zhenyuw@linux.intel.com, zhi.a.wang@intel.com

From: Christoph Hellwig <hch@lst.de>
Subject: kernel: set USER_DS in kthread_use_mm

Some architectures like arm64 and s390 require USER_DS to be set for
kernel threads to access user address space, which is the whole purpose of
kthread_use_mm, but other like x86 don't.  That has lead to a huge mess
where some callers are fixed up once they are tested on said
architectures, while others linger around and yet other like io_uring try
to do "clever" optimizations for what usually is just a trivial asignment
to a member in the thread_struct for most architectures.

Make kthread_use_mm set USER_DS, and kthread_unuse_mm restore to the
previous value instead.

Link: http://lkml.kernel.org/r/20200404094101.672954-7-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Tested-by: Jens Axboe <axboe@kernel.dk>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Felipe Balbi <balbi@kernel.org>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
Cc: Zhi Wang <zhi.a.wang@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/function/f_fs.c |    4 ----
 drivers/vhost/vhost.c              |    3 ---
 fs/io-wq.c                         |    8 ++------
 fs/io_uring.c                      |    4 ----
 kernel/kthread.c                   |    6 ++++++
 5 files changed, 8 insertions(+), 17 deletions(-)

--- a/drivers/usb/gadget/function/f_fs.c~kernel-set-user_ds-in-kthread_use_mm
+++ a/drivers/usb/gadget/function/f_fs.c
@@ -824,13 +824,9 @@ static void ffs_user_copy_worker(struct
 	bool kiocb_has_eventfd = io_data->kiocb->ki_flags & IOCB_EVENTFD;
 
 	if (io_data->read && ret > 0) {
-		mm_segment_t oldfs = get_fs();
-
-		set_fs(USER_DS);
 		kthread_use_mm(io_data->mm);
 		ret = ffs_copy_to_iter(io_data->buf, ret, &io_data->data);
 		kthread_unuse_mm(io_data->mm);
-		set_fs(oldfs);
 	}
 
 	io_data->kiocb->ki_complete(io_data->kiocb, ret, ret);
--- a/drivers/vhost/vhost.c~kernel-set-user_ds-in-kthread_use_mm
+++ a/drivers/vhost/vhost.c
@@ -329,9 +329,7 @@ static int vhost_worker(void *data)
 	struct vhost_dev *dev = data;
 	struct vhost_work *work, *work_next;
 	struct llist_node *node;
-	mm_segment_t oldfs = get_fs();
 
-	set_fs(USER_DS);
 	kthread_use_mm(dev->mm);
 
 	for (;;) {
@@ -361,7 +359,6 @@ static int vhost_worker(void *data)
 		}
 	}
 	kthread_unuse_mm(dev->mm);
-	set_fs(oldfs);
 	return 0;
 }
 
--- a/fs/io_uring.c~kernel-set-user_ds-in-kthread_use_mm
+++ a/fs/io_uring.c
@@ -5989,15 +5989,12 @@ static int io_sq_thread(void *data)
 {
 	struct io_ring_ctx *ctx = data;
 	const struct cred *old_cred;
-	mm_segment_t old_fs;
 	DEFINE_WAIT(wait);
 	unsigned long timeout;
 	int ret = 0;
 
 	complete(&ctx->sq_thread_comp);
 
-	old_fs = get_fs();
-	set_fs(USER_DS);
 	old_cred = override_creds(ctx->creds);
 
 	timeout = jiffies + ctx->sq_thread_idle;
@@ -6102,7 +6099,6 @@ static int io_sq_thread(void *data)
 	if (current->task_works)
 		task_work_run();
 
-	set_fs(old_fs);
 	io_sq_thread_drop_mm(ctx);
 	revert_creds(old_cred);
 
--- a/fs/io-wq.c~kernel-set-user_ds-in-kthread_use_mm
+++ a/fs/io-wq.c
@@ -169,7 +169,6 @@ static bool __io_worker_unuse(struct io_
 			dropped_lock = true;
 		}
 		__set_current_state(TASK_RUNNING);
-		set_fs(KERNEL_DS);
 		kthread_unuse_mm(worker->mm);
 		mmput(worker->mm);
 		worker->mm = NULL;
@@ -421,14 +420,11 @@ static void io_wq_switch_mm(struct io_wo
 		mmput(worker->mm);
 		worker->mm = NULL;
 	}
-	if (!work->mm) {
-		set_fs(KERNEL_DS);
+	if (!work->mm)
 		return;
-	}
+
 	if (mmget_not_zero(work->mm)) {
 		kthread_use_mm(work->mm);
-		if (!worker->mm)
-			set_fs(USER_DS);
 		worker->mm = work->mm;
 		/* hang on to this mm */
 		work->mm = NULL;
--- a/kernel/kthread.c~kernel-set-user_ds-in-kthread_use_mm
+++ a/kernel/kthread.c
@@ -52,6 +52,7 @@ struct kthread {
 	unsigned long flags;
 	unsigned int cpu;
 	void *data;
+	mm_segment_t oldfs;
 	struct completion parked;
 	struct completion exited;
 #ifdef CONFIG_BLK_CGROUP
@@ -1235,6 +1236,9 @@ void kthread_use_mm(struct mm_struct *mm
 
 	if (active_mm != mm)
 		mmdrop(active_mm);
+
+	to_kthread(tsk)->oldfs = get_fs();
+	set_fs(USER_DS);
 }
 EXPORT_SYMBOL_GPL(kthread_use_mm);
 
@@ -1249,6 +1253,8 @@ void kthread_unuse_mm(struct mm_struct *
 	WARN_ON_ONCE(!(tsk->flags & PF_KTHREAD));
 	WARN_ON_ONCE(!tsk->mm);
 
+	set_fs(to_kthread(tsk)->oldfs);
+
 	task_lock(tsk);
 	sync_mm_rss(mm);
 	tsk->mm = NULL;
_
