From: akpm@linux-foundation.org
Subject: [merged] media-video-cx23888-driver-ported-to-new-kfifo-api.patch removed from -mm tree
Date: Wed, 23 Dec 2009 12:58:59 -0800
Message-ID: <200912232058.nBNKwxq7021203@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52487 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755394AbZLWU7Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Dec 2009 15:59:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stefani@seibold.net, awalls@radix.net, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     media video cx23888 driver: ported to new kfifo API
has been removed from the -mm tree.  Its filename was
     media-video-cx23888-driver-ported-to-new-kfifo-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: media video cx23888 driver: ported to new kfifo API
From: Stefani Seibold <stefani@seibold.net>

Fix the cx23888 driver to use the new kfifo API.  Using kfifo_reset() may
result in a possible race conditions.  This patch fix it by using spinlock
around the kfifo_reset() function.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Reviewed-by: Andy Walls <awalls@radix.net>
Acked-by: Andy Walls <awalls@radix.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/cx23885/cx23888-ir.c |   44 +++++++++------------
 1 file changed, 19 insertions(+), 25 deletions(-)

diff -puN drivers/media/video/cx23885/cx23888-ir.c~media-video-cx23888-driver-ported-to-new-kfifo-api drivers/media/video/cx23885/cx23888-ir.c
--- a/drivers/media/video/cx23885/cx23888-ir.c~media-video-cx23888-driver-ported-to-new-kfifo-api
+++ a/drivers/media/video/cx23885/cx23888-ir.c
@@ -124,15 +124,12 @@ struct cx23888_ir_state {
 	atomic_t rxclk_divider;
 	atomic_t rx_invert;
 
-	struct kfifo *rx_kfifo;
+	struct kfifo rx_kfifo;
 	spinlock_t rx_kfifo_lock;
 
 	struct v4l2_subdev_ir_parameters tx_params;
 	struct mutex tx_params_lock;
 	atomic_t txclk_divider;
-
-	struct kfifo *tx_kfifo;
-	spinlock_t tx_kfifo_lock;
 };
 
 static inline struct cx23888_ir_state *to_state(struct v4l2_subdev *sd)
@@ -522,6 +519,7 @@ static int cx23888_ir_irq_handler(struct
 {
 	struct cx23888_ir_state *state = to_state(sd);
 	struct cx23885_dev *dev = state->dev;
+	unsigned long flags;
 
 	u32 cntrl = cx23888_ir_read4(dev, CX23888_IR_CNTRL_REG);
 	u32 irqen = cx23888_ir_read4(dev, CX23888_IR_IRQEN_REG);
@@ -594,8 +592,9 @@ static int cx23888_ir_irq_handler(struct
 			if (i == 0)
 				break;
 			j = i * sizeof(u32);
-			k = kfifo_put(state->rx_kfifo,
-				      (unsigned char *) rx_data, j);
+			k = kfifo_in_locked(&state->rx_kfifo,
+				      (unsigned char *) rx_data, j,
+				      &state->rx_kfifo_lock);
 			if (k != j)
 				kror++; /* rx_kfifo over run */
 		}
@@ -631,8 +630,11 @@ static int cx23888_ir_irq_handler(struct
 		cx23888_ir_write4(dev, CX23888_IR_CNTRL_REG, cntrl);
 		*handled = true;
 	}
-	if (kfifo_len(state->rx_kfifo) >= CX23888_IR_RX_KFIFO_SIZE / 2)
+
+	spin_lock_irqsave(&state->rx_kfifo_lock, flags);
+	if (kfifo_len(&state->rx_kfifo) >= CX23888_IR_RX_KFIFO_SIZE / 2)
 		events |= V4L2_SUBDEV_IR_RX_FIFO_SERVICE_REQ;
+	spin_unlock_irqrestore(&state->rx_kfifo_lock, flags);
 
 	if (events)
 		v4l2_subdev_notify(sd, V4L2_SUBDEV_IR_RX_NOTIFY, &events);
@@ -657,7 +659,7 @@ static int cx23888_ir_rx_read(struct v4l
 		return 0;
 	}
 
-	n = kfifo_get(state->rx_kfifo, buf, n);
+	n = kfifo_out_locked(&state->rx_kfifo, buf, n, &state->rx_kfifo_lock);
 
 	n /= sizeof(u32);
 	*num = n * sizeof(u32);
@@ -785,7 +787,12 @@ static int cx23888_ir_rx_s_parameters(st
 	o->interrupt_enable = p->interrupt_enable;
 	o->enable = p->enable;
 	if (p->enable) {
-		kfifo_reset(state->rx_kfifo);
+		unsigned long flags;
+
+		spin_lock_irqsave(&state->rx_kfifo_lock, flags);
+		kfifo_reset(&state->rx_kfifo);
+		/* reset tx_fifo too if there is one... */
+		spin_unlock_irqrestore(&state->rx_kfifo_lock, flags);
 		if (p->interrupt_enable)
 			irqenable_rx(dev, IRQEN_RSE | IRQEN_RTE | IRQEN_ROE);
 		control_rx_enable(dev, p->enable);
@@ -892,7 +899,6 @@ static int cx23888_ir_tx_s_parameters(st
 	o->interrupt_enable = p->interrupt_enable;
 	o->enable = p->enable;
 	if (p->enable) {
-		kfifo_reset(state->tx_kfifo);
 		if (p->interrupt_enable)
 			irqenable_tx(dev, IRQEN_TSE);
 		control_tx_enable(dev, p->enable);
@@ -1168,18 +1174,8 @@ int cx23888_ir_probe(struct cx23885_dev 
 		return -ENOMEM;
 
 	spin_lock_init(&state->rx_kfifo_lock);
-	state->rx_kfifo = kfifo_alloc(CX23888_IR_RX_KFIFO_SIZE, GFP_KERNEL,
-				      &state->rx_kfifo_lock);
-	if (state->rx_kfifo == NULL)
-		return -ENOMEM;
-
-	spin_lock_init(&state->tx_kfifo_lock);
-	state->tx_kfifo = kfifo_alloc(CX23888_IR_TX_KFIFO_SIZE, GFP_KERNEL,
-				      &state->tx_kfifo_lock);
-	if (state->tx_kfifo == NULL) {
-		kfifo_free(state->rx_kfifo);
+	if (kfifo_alloc(&state->rx_kfifo, CX23888_IR_RX_KFIFO_SIZE, GFP_KERNEL))
 		return -ENOMEM;
-	}
 
 	state->dev = dev;
 	state->id = V4L2_IDENT_CX23888_IR;
@@ -1211,8 +1207,7 @@ int cx23888_ir_probe(struct cx23885_dev 
 		       sizeof(struct v4l2_subdev_ir_parameters));
 		v4l2_subdev_call(sd, ir, tx_s_parameters, &default_params);
 	} else {
-		kfifo_free(state->rx_kfifo);
-		kfifo_free(state->tx_kfifo);
+		kfifo_free(&state->rx_kfifo);
 	}
 	return ret;
 }
@@ -1231,8 +1226,7 @@ int cx23888_ir_remove(struct cx23885_dev
 
 	state = to_state(sd);
 	v4l2_device_unregister_subdev(sd);
-	kfifo_free(state->rx_kfifo);
-	kfifo_free(state->tx_kfifo);
+	kfifo_free(&state->rx_kfifo);
 	kfree(state);
 	/* Nothing more to free() as state held the actual v4l2_subdev object */
 	return 0;
_

Patches currently in -mm which might be from stefani@seibold.net are

origin.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch

