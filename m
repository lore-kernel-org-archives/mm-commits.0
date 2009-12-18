From: akpm@linux-foundation.org
Subject: + media-video-cx23888-driver-ported-to-new-kfifo-api-fix.patch added to -mm tree
Date: Fri, 18 Dec 2009 14:30:05 -0800
Message-ID: <200912182230.nBIMU6aI022264@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49485 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751020AbZLRWa7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Dec 2009 17:30:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stefani@seibold.net, awalls@radix.net, mchehab@infradead.org


The patch titled
     media video cx23888 driver: fix possible races using new kfifo_API kfifo_reset()
has been added to the -mm tree.  Its filename is
     media-video-cx23888-driver-ported-to-new-kfifo-api-fix.patch

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
Subject: media video cx23888 driver: fix possible races using new kfifo_API kfifo_reset()
From: Stefani Seibold <stefani@seibold.net>

Fix the cx23888 driver to use the new kfifo API.  Using kfifo_reset() may
result in a possible race conditions.  This patch fix it by using spinlock
around the kfifo_reset() function.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Andy Walls <awalls@radix.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/cx23885/cx23888-ir.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN drivers/media/video/cx23885/cx23888-ir.c~media-video-cx23888-driver-ported-to-new-kfifo-api-fix drivers/media/video/cx23885/cx23888-ir.c
--- a/drivers/media/video/cx23885/cx23888-ir.c~media-video-cx23888-driver-ported-to-new-kfifo-api-fix
+++ a/drivers/media/video/cx23885/cx23888-ir.c
@@ -519,6 +519,7 @@ static int cx23888_ir_irq_handler(struct
 {
 	struct cx23888_ir_state *state = to_state(sd);
 	struct cx23885_dev *dev = state->dev;
+	unsigned long flags;
 
 	u32 cntrl = cx23888_ir_read4(dev, CX23888_IR_CNTRL_REG);
 	u32 irqen = cx23888_ir_read4(dev, CX23888_IR_IRQEN_REG);
@@ -629,8 +630,11 @@ static int cx23888_ir_irq_handler(struct
 		cx23888_ir_write4(dev, CX23888_IR_CNTRL_REG, cntrl);
 		*handled = true;
 	}
+
+	spin_lock_irqsave(&state->rx_kfifo_lock, flags);
 	if (kfifo_len(&state->rx_kfifo) >= CX23888_IR_RX_KFIFO_SIZE / 2)
 		events |= V4L2_SUBDEV_IR_RX_FIFO_SERVICE_REQ;
+	spin_unlock_irqrestore(&state->rx_kfifo_lock, flags);
 
 	if (events)
 		v4l2_subdev_notify(sd, V4L2_SUBDEV_IR_RX_NOTIFY, &events);
@@ -783,7 +787,12 @@ static int cx23888_ir_rx_s_parameters(st
 	o->interrupt_enable = p->interrupt_enable;
 	o->enable = p->enable;
 	if (p->enable) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&state->rx_kfifo_lock, flags);
 		kfifo_reset(&state->rx_kfifo);
+		/* reset tx_fifo too if there is one... */
+		spin_unlock_irqrestore(&state->rx_kfifo_lock, flags);
 		if (p->interrupt_enable)
 			irqenable_rx(dev, IRQEN_RSE | IRQEN_RTE | IRQEN_ROE);
 		control_rx_enable(dev, p->enable);
_

Patches currently in -mm which might be from stefani@seibold.net are

kfifo-move-struct-kfifo-in-place.patch
kfifo-move-struct-kfifo-in-place-fix.patch
kfifo-move-out-spinlock.patch
kfifo-cleanup-namespace.patch
kfifo-rename-kfifo_put-into-kfifo_in-and-kfifo_get-into-kfifo_out.patch
kfifo-fix-warn_unused_result.patch
kfifo-add-define_kfifo-and-friends-add-very-tiny-functions.patch
kfifo-add-define_kfifo-and-friends-add-very-tiny-functions-fix.patch
kfifo-add-kfifo_skip-kfifo_from_user-and-kfifo_to_user.patch
kfifo-add-record-handling-functions.patch
kfifo-add-record-handling-functions-fix.patch
media-video-cx23888-driver-ported-to-new-kfifo-api.patch
media-video-cx23888-driver-ported-to-new-kfifo-api-fix.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch

