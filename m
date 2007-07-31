From: akpm@linux-foundation.org
Subject: - usb-fix-a-bug-in-usb_start_wait_urb.patch removed from -mm tree
Date: Mon, 30 Jul 2007 23:33:40 -0700
Message-ID: <200707310633.l6V6Xe45019760@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36131 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752114AbXGaGea (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 02:34:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stern@rowland.harvard.edu, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     USB: fix a bug in usb_start_wait_urb
has been removed from the -mm tree.  Its filename was
     usb-fix-a-bug-in-usb_start_wait_urb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: USB: fix a bug in usb_start_wait_urb
From: Alan Stern <stern@rowland.harvard.edu>

This patch (as941) fixes a bug recently added to the USB synchronous API. 
The status of a completed URB must be preserved separately across a
completion callback.  Also, the actual_length value isn't available until
after the URB has fully completed.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/core/message.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff -puN drivers/usb/core/message.c~usb-fix-a-bug-in-usb_start_wait_urb drivers/usb/core/message.c
--- a/drivers/usb/core/message.c~usb-fix-a-bug-in-usb_start_wait_urb
+++ a/drivers/usb/core/message.c
@@ -18,9 +18,17 @@
 #include "hcd.h"	/* for usbcore internals */
 #include "usb.h"
 
+struct api_context {
+	struct completion	done;
+	int			status;
+};
+
 static void usb_api_blocking_completion(struct urb *urb)
 {
-	complete((struct completion *)urb->context);
+	struct api_context *ctx = urb->context;
+
+	ctx->status = urb->status;
+	complete(&ctx->done);
 }
 
 
@@ -32,20 +40,21 @@ static void usb_api_blocking_completion(
  */
 static int usb_start_wait_urb(struct urb *urb, int timeout, int *actual_length)
 { 
-	struct completion done;
+	struct api_context ctx;
 	unsigned long expire;
 	int retval;
-	int status = urb->status;
 
-	init_completion(&done); 	
-	urb->context = &done;
+	init_completion(&ctx.done);
+	urb->context = &ctx;
 	urb->actual_length = 0;
 	retval = usb_submit_urb(urb, GFP_NOIO);
 	if (unlikely(retval))
 		goto out;
 
 	expire = timeout ? msecs_to_jiffies(timeout) : MAX_SCHEDULE_TIMEOUT;
-	if (!wait_for_completion_timeout(&done, expire)) {
+	if (!wait_for_completion_timeout(&ctx.done, expire)) {
+		usb_kill_urb(urb);
+		retval = (ctx.status == -ENOENT ? -ETIMEDOUT : ctx.status);
 
 		dev_dbg(&urb->dev->dev,
 			"%s timed out on ep%d%s len=%d/%d\n",
@@ -54,11 +63,8 @@ static int usb_start_wait_urb(struct urb
 			usb_pipein(urb->pipe) ? "in" : "out",
 			urb->actual_length,
 			urb->transfer_buffer_length);
-
-		usb_kill_urb(urb);
-		retval = status == -ENOENT ? -ETIMEDOUT : status;
 	} else
-		retval = status;
+		retval = ctx.status;
 out:
 	if (actual_length)
 		*actual_length = urb->actual_length;
_

Patches currently in -mm which might be from stern@rowland.harvard.edu are

origin.patch
nikon-d50-is-an-unusual-device.patch
