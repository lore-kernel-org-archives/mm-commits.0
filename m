From: akpm@linux-foundation.org
Subject: - ps3fb-thread-updates-update.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:05:57 -0800
Message-ID: <200703060205.l2625vMI008886@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46850 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965702AbXCFCGV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:06:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, mm-commits@vger.kernel.org


The patch titled
     ps3fb: thread updates
has been removed from the -mm tree.  Its filename was
     ps3fb-thread-updates-update.patch

This patch was dropped because it was folded into ps3fb-thread-updates.patch

------------------------------------------------------
Subject: ps3fb: thread updates
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

ps3fb: Replace the kernel_thread by a proper kthread, which sleeps on a
waitqueue_head.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/ps3fb.c |   40 ++++++++++++++++++++++++----------------
 1 files changed, 24 insertions(+), 16 deletions(-)

diff -puN drivers/video/ps3fb.c~ps3fb-thread-updates-update drivers/video/ps3fb.c
--- a/drivers/video/ps3fb.c~ps3fb-thread-updates-update
+++ a/drivers/video/ps3fb.c
@@ -131,7 +131,6 @@ struct ps3fb_priv {
 	u64 context_handle, memory_handle;
 	void *xdr_ea;
 	struct gpu_driver_info *dinfo;
-	struct semaphore sem;
 	u32 res_index;
 
 	u64 vblank_count;	/* frame count */
@@ -141,6 +140,7 @@ struct ps3fb_priv {
 	atomic_t ext_flip;	/* on/off flip with vsync */
 	atomic_t f_count;	/* fb_open count */
 	int is_blanked;
+	int is_kicked;
 	struct task_struct *task;
 };
 static struct ps3fb_priv ps3fb;
@@ -808,14 +808,17 @@ static int ps3fb_ioctl(struct fb_info *i
 
 static int ps3fbd(void *arg)
 {
-	int error;
+	DEFINE_WAIT(wait);
+	DECLARE_WAIT_QUEUE_HEAD(wq);
 
-	do {
-		try_to_freeze();
-		error = down_interruptible(&ps3fb.sem);
-		if (!error && !atomic_read(&ps3fb.ext_flip))
-			ps3fb_sync(0);	/* single buffer */
-	} while (!kthread_should_stop());
+	while (!kthread_should_stop()) {
+		prepare_to_wait(&wq, &wait, TASK_INTERRUPTIBLE);
+		if (!ps3fb.is_kicked)
+			schedule();
+		finish_wait(&wq, &wait);
+		ps3fb.is_kicked = 0;
+		ps3fb_sync(0);	/* single buffer */
+	}
 	return 0;
 }
 
@@ -835,8 +838,11 @@ static irqreturn_t ps3fb_vsync_interrupt
 	if (v1 & (1 << GPU_INTR_STATUS_VSYNC_1)) {
 		/* VSYNC */
 		ps3fb.vblank_count = head->vblank_count;
-		if (!ps3fb.is_blanked)
-			up(&ps3fb.sem);
+		if (ps3fb.task && !ps3fb.is_blanked &&
+		    !atomic_read(&ps3fb.ext_flip)) {
+			ps3fb.is_kicked = 1;
+			wake_up_process(ps3fb.task);
+		}
 		wake_up_interruptible(&ps3fb.wait_vsync);
 	}
 
@@ -973,6 +979,7 @@ static int __init ps3fb_probe(struct pla
 	u64 xdr_lpar;
 	int status;
 	unsigned long offset;
+	struct task_struct *task;
 
 	/* get gpu context handle */
 	status = lv1_gpu_memory_allocate(DDR_SIZE, 0, 0, 0, 0,
@@ -1055,13 +1062,14 @@ static int __init ps3fb_probe(struct pla
 	       "fb%d: PS3 frame buffer device, using %ld KiB of video memory\n",
 	       info->node, ps3fb_videomemory.size >> 10);
 
-	ps3fb.task = kthread_run(ps3fbd, info, "ps3fbd");
-	if (IS_ERR(ps3fb.task)) {
-		retval = PTR_ERR(ps3fb.task);
-		ps3fb.task = NULL;
+	task = kthread_run(ps3fbd, info, "ps3fbd");
+	if (IS_ERR(task)) {
+		retval = PTR_ERR(task);
 		goto err_unregister_framebuffer;
 	}
 
+	ps3fb.task = task;
+
 	return 0;
 
 err_unregister_framebuffer:
@@ -1097,8 +1105,9 @@ void ps3fb_cleanup(void)
 	int status;
 
 	if (ps3fb.task) {
-		kthread_stop(ps3fb.task);
+		struct task_struct *task = ps3fb.task;
 		ps3fb.task = NULL;
+		kthread_stop(task);
 	}
 	if (ps3fb.irq_no) {
 		free_irq(ps3fb.irq_no, ps3fb.dev);
@@ -1212,7 +1221,6 @@ static int __init ps3fb_init(void)
 
 	atomic_set(&ps3fb.f_count, -1);	/* fbcon opens ps3fb */
 	atomic_set(&ps3fb.ext_flip, 0);	/* for flip with vsync */
-	init_MUTEX(&ps3fb.sem);
 	init_waitqueue_head(&ps3fb.wait_vsync);
 	ps3fb.num_frames = 1;
 
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

origin.patch
ps3fb-thread-updates.patch
ps3fb-thread-updates-update.patch
ps3fb-thread-updates-2.patch
ps3fb-thread-updates-42.patch
ps3av-thread-updates.patch
ps3fb-kill-superfluous-zero-initializations.patch
ps3fb-atomic-fixes.patch
ps3av-misc-updates.patch
