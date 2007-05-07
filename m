From: akpm@linux-foundation.org
Subject: - ps3av-thread-updates.patch removed from -mm tree
Date: Mon, 07 May 2007 00:00:09 -0700
Message-ID: <200705070700.l47709tn020991@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53805 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754094AbXEGHAt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 03:00:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, benh@kernel.crashing.org, hch@lst.de, jsimmons@infradead.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     ps3av: thread updates
has been removed from the -mm tree.  Its filename was
     ps3av-thread-updates.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -440,7 +440,7 @@ static int ps3av_set_videomode(void)
 	ps3av_set_av_video_mute(PS3AV_CMD_MUTE_ON);
 
 	/* wake up ps3avd to do the actual video mode setting */
-	up(&ps3av.ping);
+	queue_work(ps3av.wq, &ps3av.work);
 
 	return 0;
 }
@@ -515,18 +515,10 @@ static void ps3av_set_videomode_cont(u32
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
@@ -725,7 +717,7 @@ int ps3av_set_video_mode(u32 id, int boo
 	}
 
 	/* set videomode */
-	down(&ps3av.pong);
+	wait_for_completion(&ps3av.done);
 	ps3av.ps3av_mode_old = ps3av.ps3av_mode;
 	ps3av.ps3av_mode = id;
 	if (ps3av_set_videomode())
@@ -881,12 +873,16 @@ static int ps3av_probe(struct ps3_vuart_
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
@@ -926,6 +922,8 @@ static int ps3av_remove(struct ps3_vuart
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
fbdev-avoid-vertical-overflow-when-making-space-for-the-logo.patch
fbdev-fb_do_show_logo-updates.patch
fbdev-correct-image-offsets-when-rotating-logo.patch
