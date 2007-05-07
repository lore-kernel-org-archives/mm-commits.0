From: akpm@linux-foundation.org
Subject: - ps3fb-thread-updates.patch removed from -mm tree
Date: Mon, 07 May 2007 00:00:04 -0700
Message-ID: <200705070700.l47704Os020984@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40902 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754113AbXEGHAw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 03:00:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, benh@kernel.crashing.org, hch@lst.de, jsimmons@infradead.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     ps3fb: thread updates
has been removed from the -mm tree.  Its filename was
     ps3fb-thread-updates.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ps3fb: thread updates
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

ps3fb: Replace the kernel_thread by a proper kthread.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Christoph Hellwig <hch@lst.de>
Acked-by: James Simmons <jsimmons@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/ps3fb.c |   41 +++++++++++++++++++++++++++++++---------
 1 files changed, 32 insertions(+), 9 deletions(-)

diff -puN drivers/video/ps3fb.c~ps3fb-thread-updates drivers/video/ps3fb.c
--- a/drivers/video/ps3fb.c~ps3fb-thread-updates
+++ a/drivers/video/ps3fb.c
@@ -32,6 +32,8 @@
 #include <linux/ioctl.h>
 #include <linux/notifier.h>
 #include <linux/reboot.h>
+#include <linux/kthread.h>
+#include <linux/freezer.h>
 
 #include <asm/uaccess.h>
 #include <linux/fb.h>
@@ -129,7 +131,6 @@ struct ps3fb_priv {
 	u64 context_handle, memory_handle;
 	void *xdr_ea;
 	struct gpu_driver_info *dinfo;
-	struct semaphore sem;
 	u32 res_index;
 
 	u64 vblank_count;	/* frame count */
@@ -139,6 +140,8 @@ struct ps3fb_priv {
 	atomic_t ext_flip;	/* on/off flip with vsync */
 	atomic_t f_count;	/* fb_open count */
 	int is_blanked;
+	int is_kicked;
+	struct task_struct *task;
 };
 static struct ps3fb_priv ps3fb;
 
@@ -805,11 +808,14 @@ static int ps3fb_ioctl(struct fb_info *i
 
 static int ps3fbd(void *arg)
 {
-	daemonize("ps3fbd");
-	for (;;) {
-		down(&ps3fb.sem);
-		if (atomic_read(&ps3fb.ext_flip) == 0)
+	while (!kthread_should_stop()) {
+		try_to_freeze();
+		set_current_state(TASK_INTERRUPTIBLE);
+		if (ps3fb.is_kicked) {
+			ps3fb.is_kicked = 0;
 			ps3fb_sync(0);	/* single buffer */
+		}
+		schedule();
 	}
 	return 0;
 }
@@ -830,8 +836,11 @@ static irqreturn_t ps3fb_vsync_interrupt
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
 
@@ -968,6 +977,7 @@ static int __init ps3fb_probe(struct pla
 	u64 xdr_lpar;
 	int status;
 	unsigned long offset;
+	struct task_struct *task;
 
 	/* get gpu context handle */
 	status = lv1_gpu_memory_allocate(DDR_SIZE, 0, 0, 0, 0,
@@ -1050,9 +1060,18 @@ static int __init ps3fb_probe(struct pla
 	       "fb%d: PS3 frame buffer device, using %ld KiB of video memory\n",
 	       info->node, ps3fb_videomemory.size >> 10);
 
-	kernel_thread(ps3fbd, info, CLONE_KERNEL);
+	task = kthread_run(ps3fbd, info, "ps3fbd");
+	if (IS_ERR(task)) {
+		retval = PTR_ERR(task);
+		goto err_unregister_framebuffer;
+	}
+
+	ps3fb.task = task;
+
 	return 0;
 
+err_unregister_framebuffer:
+	unregister_framebuffer(info);
 err_fb_dealloc:
 	fb_dealloc_cmap(&info->cmap);
 err_framebuffer_release:
@@ -1083,6 +1102,11 @@ void ps3fb_cleanup(void)
 {
 	int status;
 
+	if (ps3fb.task) {
+		struct task_struct *task = ps3fb.task;
+		ps3fb.task = NULL;
+		kthread_stop(task);
+	}
 	if (ps3fb.irq_no) {
 		free_irq(ps3fb.irq_no, ps3fb.dev);
 		ps3_free_irq(ps3fb.irq_no);
@@ -1195,7 +1219,6 @@ static int __init ps3fb_init(void)
 
 	atomic_set(&ps3fb.f_count, -1);	/* fbcon opens ps3fb */
 	atomic_set(&ps3fb.ext_flip, 0);	/* for flip with vsync */
-	init_MUTEX(&ps3fb.sem);
 	init_waitqueue_head(&ps3fb.wait_vsync);
 	ps3fb.num_frames = 1;
 
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

origin.patch
fbdev-avoid-vertical-overflow-when-making-space-for-the-logo.patch
fbdev-fb_do_show_logo-updates.patch
fbdev-correct-image-offsets-when-rotating-logo.patch
