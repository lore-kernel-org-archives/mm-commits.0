From: akpm@linux-foundation.org
Subject: + ps3fb-thread-updates.patch added to -mm tree
Date: Thu, 15 Feb 2007 16:59:51 -0800
Message-ID: <200702160059.l1G0xpJK014841@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41540 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422984AbXBPBA2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 20:00:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Geert.Uytterhoeven@sonycom.com, benh@kernel.crashing.org, hch@lst.de, jsimmons@infradead.org, paulus@samba.org


The patch titled
     ps3fb: thread updates
has been added to the -mm tree.  Its filename is
     ps3fb-thread-updates.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

 drivers/video/ps3fb.c |   29 +++++++++++++++++++++++------
 1 files changed, 23 insertions(+), 6 deletions(-)

diff -puN drivers/video/ps3fb.c~ps3fb-thread-updates drivers/video/ps3fb.c
--- a/drivers/video/ps3fb.c~ps3fb-thread-updates
+++ a/drivers/video/ps3fb.c
@@ -32,6 +32,8 @@
 #include <linux/ioctl.h>
 #include <linux/notifier.h>
 #include <linux/reboot.h>
+#include <linux/freezer.h>
+#include <linux/kthread.h>
 
 #include <asm/uaccess.h>
 #include <linux/fb.h>
@@ -139,6 +141,7 @@ struct ps3fb_priv {
 	atomic_t ext_flip;	/* on/off flip with vsync */
 	atomic_t f_count;	/* fb_open count */
 	int is_blanked;
+	struct task_struct *task;
 };
 static struct ps3fb_priv ps3fb;
 
@@ -805,12 +808,14 @@ static int ps3fb_ioctl(struct fb_info *i
 
 static int ps3fbd(void *arg)
 {
-	daemonize("ps3fbd");
-	for (;;) {
-		down(&ps3fb.sem);
-		if (atomic_read(&ps3fb.ext_flip) == 0)
+	int error;
+
+	do {
+		try_to_freeze();
+		error = down_interruptible(&ps3fb.sem);
+		if (!error && !atomic_read(&ps3fb.ext_flip))
 			ps3fb_sync(0);	/* single buffer */
-	}
+	} while (!kthread_should_stop());
 	return 0;
 }
 
@@ -1050,9 +1055,17 @@ static int __init ps3fb_probe(struct pla
 	       "fb%d: PS3 frame buffer device, using %ld KiB of video memory\n",
 	       info->node, ps3fb_videomemory.size >> 10);
 
-	kernel_thread(ps3fbd, info, CLONE_KERNEL);
+	ps3fb.task = kthread_run(ps3fbd, info, "ps3fbd");
+	if (IS_ERR(ps3fb.task)) {
+		retval = PTR_ERR(ps3fb.task);
+		ps3fb.task = NULL;
+		goto err_unregister_framebuffer;
+	}
+
 	return 0;
 
+err_unregister_framebuffer:
+	unregister_framebuffer(info);
 err_fb_dealloc:
 	fb_dealloc_cmap(&info->cmap);
 err_framebuffer_release:
@@ -1083,6 +1096,10 @@ void ps3fb_cleanup(void)
 {
 	int status;
 
+	if (ps3fb.task) {
+		kthread_stop(ps3fb.task);
+		ps3fb.task = NULL;
+	}
 	if (ps3fb.irq_no) {
 		free_irq(ps3fb.irq_no, ps3fb.dev);
 		ps3_free_irq(ps3fb.irq_no);
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

origin.patch
ps3fb-thread-updates.patch
ps3av-thread-updates.patch
ps3fb-kill-superfluous-zero-initializations.patch
ps3av-misc-updates.patch
