From: akpm@linux-foundation.org
Subject: + ps3av-thread-updates.patch added to -mm tree
Date: Thu, 15 Feb 2007 16:59:53 -0800
Message-ID: <200702160059.l1G0xreW014848@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41545 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422995AbXBPBAe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 20:00:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Geert.Uytterhoeven@sonycom.com, benh@kernel.crashing.org, hch@lst.de, jsimmons@infradead.org, paulus@samba.org


The patch titled
     ps3av: thread updates
has been added to the -mm tree.  Its filename is
     ps3av-thread-updates.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ps3av: thread updates
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

ps3av: Replace the kernel_thread and the ping pong semaphores by a
singlethread workqueue and a completion.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Christoph Hellwig <hch@lst.de>
Acked-by: James Simmons <jsimmons@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ps3/ps3av.c         |   30 ++++++++++++++----------------
 include/asm-powerpc/ps3av.h |    5 +++--
 2 files changed, 17 insertions(+), 18 deletions(-)

diff -puN drivers/ps3/ps3av.c~ps3av-thread-updates drivers/ps3/ps3av.c
--- a/drivers/ps3/ps3av.c~ps3av-thread-updates
+++ a/drivers/ps3/ps3av.c
@@ -438,7 +438,7 @@ static int ps3av_set_videomode(void)
 	ps3av_set_av_video_mute(PS3AV_CMD_MUTE_ON);
 
 	/* wake up ps3avd to do the actual video mode setting */
-	up(&ps3av.ping);
+	queue_work(ps3av.wq, &ps3av.work);
 
 	return 0;
 }
@@ -513,18 +513,10 @@ static void ps3av_set_videomode_cont(u32
 	ps3av_set_av_video_mute(PS3AV_CMD_MUTE_OFF);
 }
 
-static int ps3avd(void *p)
+static void ps3avd(struct work_struct *work)
 {
-	struct ps3av *info = p;
-
-	daemonize("ps3avd");
-	while (1) {
-		down(&info->ping);
-		ps3av_set_videomode_cont(info->ps3av_mode,
-					 info->ps3av_mode_old);
-		up(&info->pong);
-	}
-	return 0;
+	ps3av_set_videomode_cont(ps3av.ps3av_mode, ps3av.ps3av_mode_old);
+	complete(&ps3av.done);
 }
 
 static int ps3av_vid2table_id(int vid)
@@ -723,7 +715,7 @@ int ps3av_set_video_mode(u32 id, int boo
 	}
 
 	/* set videomode */
-	down(&ps3av.pong);
+	wait_for_completion(&ps3av.done);
 	ps3av.ps3av_mode_old = ps3av.ps3av_mode;
 	ps3av.ps3av_mode = id;
 	if (ps3av_set_videomode())
@@ -879,12 +871,16 @@ static int ps3av_probe(struct ps3_vuart_
 	memset(&ps3av, 0, sizeof(ps3av));
 
 	init_MUTEX(&ps3av.sem);
-	init_MUTEX_LOCKED(&ps3av.ping);
-	init_MUTEX(&ps3av.pong);
 	mutex_init(&ps3av.mutex);
 	ps3av.ps3av_mode = 0;
 	ps3av.dev = dev;
-	kernel_thread(ps3avd, &ps3av, CLONE_KERNEL);
+
+	INIT_WORK(&ps3av.work, ps3avd);
+	init_completion(&ps3av.done);
+	complete(&ps3av.done);
+	ps3av.wq = create_singlethread_workqueue("ps3avd");
+	if (!ps3av.wq)
+		return -ENOMEM;
 
 	ps3av.available = 1;
 	switch (ps3_os_area_get_av_multi_out()) {
@@ -924,6 +920,8 @@ static int ps3av_remove(struct ps3_vuart
 {
 	if (ps3av.available) {
 		ps3av_cmd_fin();
+		if (ps3av.wq)
+			destroy_workqueue(ps3av.wq);
 		ps3av.available = 0;
 	}
 
diff -puN include/asm-powerpc/ps3av.h~ps3av-thread-updates include/asm-powerpc/ps3av.h
--- a/include/asm-powerpc/ps3av.h~ps3av-thread-updates
+++ a/include/asm-powerpc/ps3av.h
@@ -646,8 +646,9 @@ struct ps3av_pkt_avb_param {
 struct ps3av {
 	int available;
 	struct semaphore sem;
-	struct semaphore ping;
-	struct semaphore pong;
+	struct work_struct work;
+	struct completion done;
+	struct workqueue_struct *wq;
 	struct mutex mutex;
 	int open_count;
 	struct ps3_vuart_port_device *dev;
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

origin.patch
ps3fb-thread-updates.patch
ps3av-thread-updates.patch
ps3fb-kill-superfluous-zero-initializations.patch
ps3av-misc-updates.patch
