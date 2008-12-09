From: akpm@linux-foundation.org
Subject: - fbcon-fix-workqueue-shutdown.patch removed from -mm tree
Date: Mon, 08 Dec 2008 16:30:54 -0800
Message-ID: <200812090030.mB90UtpZ014555@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41273 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753763AbYLIAbV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Dec 2008 19:31:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geoffrey.levand@am.sony.com, geert@linux-m68k.org, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     fbcon: fix workqueue shutdown
has been removed from the -mm tree.  Its filename was
     fbcon-fix-workqueue-shutdown.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbcon: fix workqueue shutdown
From: Geoff Levand <geoffrey.levand@am.sony.com>

Add a call to cancel_work_sync() in fbcon_exit() to cancel any pending
work in the fbcon workqueue.  Also, change the assignment of the workqueue
function info->queue.func from NULL to fb_flashcursor(), and add a
corresponding check in fb_flashcursor() to exit immediately if the
variable fbcon_has_exited is set.

The current implementation of fbcon_exit() sets the fbcon workqueue
function info->queue.func to NULL, but does not assure that there is no
work pending when it does so.  On occasion, depending on system timing,
there will still be pending work in the queue when fbcon_exit() is called.
 This results in a null pointer deference when run_workqueue() tries to
call the queue's work function.

Fixes errors on shutdown similar to these:

  Console: switching to colour dummy device 80x25
  Unable to handle kernel paging request for data at address 0x00000000

Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/fbcon.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff -puN drivers/video/console/fbcon.c~fbcon-fix-workqueue-shutdown drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~fbcon-fix-workqueue-shutdown
+++ a/drivers/video/console/fbcon.c
@@ -394,13 +394,19 @@ static void fbcon_update_softback(struct
 
 static void fb_flashcursor(struct work_struct *work)
 {
-	struct fb_info *info = container_of(work, struct fb_info, queue);
-	struct fbcon_ops *ops = info->fbcon_par;
+	struct fb_info *info;
+	struct fbcon_ops *ops;
 	struct display *p;
 	struct vc_data *vc = NULL;
 	int c;
 	int mode;
 
+	if (fbcon_has_exited)
+		return;
+
+	info = container_of(work, struct fb_info, queue);
+	ops = info->fbcon_par;
+
 	acquire_console_sem();
 	if (ops && ops->currcon != -1)
 		vc = vc_cons[ops->currcon].d;
@@ -3531,12 +3537,18 @@ static void fbcon_exit(void)
 	softback_buf = 0UL;
 
 	for (i = 0; i < FB_MAX; i++) {
+		int pending;
+
 		mapped = 0;
 		info = registered_fb[i];
 
 		if (info == NULL)
 			continue;
 
+		pending = cancel_work_sync(&info->queue);
+		DPRINTK("fbcon: %s pending work\n", (pending ? "canceled" :
+			"no"));
+
 		for (j = first_fb_vc; j <= last_fb_vc; j++) {
 			if (con2fb_map[j] == i)
 				mapped = 1;
@@ -3555,9 +3567,6 @@ static void fbcon_exit(void)
 				kfree(info->fbcon_par);
 				info->fbcon_par = NULL;
 			}
