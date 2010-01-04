From: akpm@linux-foundation.org
Subject: + drivers-video-omap2-dss-rfbic-port-to-new-kfifo-api.patch added to -mm tree
Date: Mon, 04 Jan 2010 15:07:20 -0800
Message-ID: <201001042307.o04N7KaB023799@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56201 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753484Ab0ADXHl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jan 2010 18:07:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stefani@seibold.net, greg@kroah.com, tomi.valkeinen@nokia.com


The patch titled
     drivers/video/omap2/dss/rfbi.c: port to new kfifo API
has been added to the -mm tree.  Its filename is
     drivers-video-omap2-dss-rfbic-port-to-new-kfifo-api.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/video/omap2/dss/rfbi.c: port to new kfifo API
From: Stefani Seibold <stefani@seibold.net>

Port drivers/video/omap2/dss/rfbi.c to the new kfifo API.  This should be
the last one.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
Cc: Tomi Valkeinen <tomi.valkeinen@nokia.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/omap2/dss/rfbi.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff -puN drivers/video/omap2/dss/rfbi.c~drivers-video-omap2-dss-rfbic-port-to-new-kfifo-api drivers/video/omap2/dss/rfbi.c
--- a/drivers/video/omap2/dss/rfbi.c~drivers-video-omap2-dss-rfbic-port-to-new-kfifo-api
+++ a/drivers/video/omap2/dss/rfbi.c
@@ -120,7 +120,7 @@ static struct {
 
 	struct omap_dss_device *dssdev[2];
 
-	struct kfifo      *cmd_fifo;
+	struct kfifo      cmd_fifo;
 	spinlock_t        cmd_lock;
 	struct completion cmd_done;
 	atomic_t          cmd_fifo_full;
@@ -1013,8 +1013,9 @@ static void process_cmd_fifo(void)
 	while (true) {
 		spin_lock_irqsave(rfbi.cmd_fifo->lock, flags);
 
-		len = __kfifo_get(rfbi.cmd_fifo, (unsigned char *)&p,
-				  sizeof(struct update_param));
+		len = kfifo_out_locked(&rfbi.cmd_fifo, (unsigned char *)&p,
+				  sizeof(struct update_param),
+				  &rfbi.cmd_lock);
 		if (len == 0) {
 			DSSDBG("nothing more in fifo\n");
 			atomic_set(&rfbi.cmd_pending, 0);
@@ -1053,8 +1054,7 @@ static void rfbi_push_cmd(struct update_
 		int available;
 
 		spin_lock_irqsave(rfbi.cmd_fifo->lock, flags);
-		available = RFBI_CMD_FIFO_LEN_BYTES -
-			__kfifo_len(rfbi.cmd_fifo);
+		available = kfifo_avail(&rfbi.cmd_fifo);
 
 /*		DSSDBG("%d bytes left in fifo\n", available); */
 		if (available < sizeof(struct update_param)) {
@@ -1066,8 +1066,9 @@ static void rfbi_push_cmd(struct update_
 			continue;
 		}
 
-		ret = __kfifo_put(rfbi.cmd_fifo, (unsigned char *)p,
-				  sizeof(struct update_param));
+		ret = kfifo_in_locked(&rfbi.cmd_fifo, (unsigned char *)p,
+				  sizeof(struct update_param),
+				  &rfbi.cmd_lock);
 /*		DSSDBG("pushed %d bytes\n", ret);*/
 
 		spin_unlock_irqrestore(rfbi.cmd_fifo->lock, flags);
@@ -1157,9 +1158,7 @@ int rfbi_init(void)
 	u32 l;
 
 	spin_lock_init(&rfbi.cmd_lock);
-	rfbi.cmd_fifo = kfifo_alloc(RFBI_CMD_FIFO_LEN_BYTES, GFP_KERNEL,
-				    &rfbi.cmd_lock);
-	if (IS_ERR(rfbi.cmd_fifo))
+	if (kfifo_alloc(&rfbi.cmd_fifo, RFBI_CMD_FIFO_LEN_BYTES, GFP_KERNEL))
 		return -ENOMEM;
 
 	init_completion(&rfbi.cmd_done);
@@ -1196,7 +1195,7 @@ void rfbi_exit(void)
 {
 	DSSDBG("rfbi_exit\n");
 
-	kfifo_free(rfbi.cmd_fifo);
+	kfifo_free(&rfbi.cmd_fifo);
 
 	iounmap(rfbi.base);
 }
_

Patches currently in -mm which might be from stefani@seibold.net are

drivers-video-omap2-dss-rfbic-port-to-new-kfifo-api.patch
kfifo-use-void-pointers-for-user-buffers.patch
kfifo-make-kfifo_in-atomic.patch
kfifo-sanitize-_user-error-handling.patch
kfifo-add-kfifo_out_peek.patch
kfifo-add-kfifo_initialized.patch
kfifo-document-everywhere-that-size-has-to-be-power-of-two.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch

