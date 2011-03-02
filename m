From: akpm@linux-foundation.org
Subject: + rapidio-add-architecture-specific-callbacks.patch added to -mm tree
Date: Tue, 01 Mar 2011 17:18:35 -0800
Message-ID: <201103020118.p221IZ3Y010788@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42148 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757694Ab1CBBTC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Mar 2011 20:19:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexandre.bounine@idt.com, benh@kernel.crashing.org, galak@kernel.crashing.org, leoli@freescale.com, micha@neli.hopto.org, mporter@kernel.crashing.org, thomas.moll@sysgo.com


The patch titled
     rapidio: add architecture specific callbacks
has been added to the -mm tree.  Its filename is
     rapidio-add-architecture-specific-callbacks.patch

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
Subject: rapidio: add architecture specific callbacks
From: Alexandre Bounine <alexandre.bounine@idt.com>

This set of patches eliminates RapidIO dependency on PowerPC architecture
and makes it available to other architectures (x86 and MIPS).  It also
enables support of new platform independent RapidIO controllers such as
PCI-to-SRIO and PCI Express-to-SRIO.



This patch:

Extend number of mport callback functions to eliminate direct linking of
architecture specific mport operations.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Thomas Moll <thomas.moll@sysgo.com>
Cc: Micha Nelissen <micha@neli.hopto.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/sysdev/fsl_rio.c |   52 ++++++++++++++++----------------
 drivers/rapidio/rio.c         |   38 ++++++++++++++++-------
 include/linux/rio.h           |   23 +++++++++++---
 include/linux/rio_drv.h       |    7 ++--
 4 files changed, 75 insertions(+), 45 deletions(-)

diff -puN arch/powerpc/sysdev/fsl_rio.c~rapidio-add-architecture-specific-callbacks arch/powerpc/sysdev/fsl_rio.c
--- a/arch/powerpc/sysdev/fsl_rio.c~rapidio-add-architecture-specific-callbacks
+++ a/arch/powerpc/sysdev/fsl_rio.c
@@ -482,7 +482,7 @@ fsl_rio_config_write(struct rio_mport *m
 }
 
 /**
- * rio_hw_add_outb_message - Add message to the MPC85xx outbound message queue
+ * fsl_add_outb_message - Add message to the MPC85xx outbound message queue
  * @mport: Master port with outbound message queue
  * @rdev: Target of outbound message
  * @mbox: Outbound mailbox
@@ -492,8 +492,8 @@ fsl_rio_config_write(struct rio_mport *m
  * Adds the @buffer message to the MPC85xx outbound message queue. Returns
  * %0 on success or %-EINVAL on failure.
  */
-int
-rio_hw_add_outb_message(struct rio_mport *mport, struct rio_dev *rdev, int mbox,
+static int
+fsl_add_outb_message(struct rio_mport *mport, struct rio_dev *rdev, int mbox,
 			void *buffer, size_t len)
 {
 	struct rio_priv *priv = mport->priv;
@@ -502,9 +502,8 @@ rio_hw_add_outb_message(struct rio_mport
 					+ priv->msg_tx_ring.tx_slot;
 	int ret = 0;
 
-	pr_debug
-	    ("RIO: rio_hw_add_outb_message(): destid %4.4x mbox %d buffer %8.8x len %8.8x\n",
-	     rdev->destid, mbox, (int)buffer, len);
+	pr_debug("RIO: fsl_add_outb_message(): destid %4.4x mbox %d buffer " \
+		 "%8.8x len %8.8x\n", rdev->destid, mbox, (int)buffer, len);
 
 	if ((len < 8) || (len > RIO_MAX_MSG_SIZE)) {
 		ret = -EINVAL;
@@ -554,8 +553,6 @@ rio_hw_add_outb_message(struct rio_mport
 	return ret;
 }
 
-EXPORT_SYMBOL_GPL(rio_hw_add_outb_message);
-
 /**
  * fsl_rio_tx_handler - MPC85xx outbound message interrupt handler
  * @irq: Linux interrupt number
@@ -600,7 +597,7 @@ fsl_rio_tx_handler(int irq, void *dev_in
 }
 
 /**
- * rio_open_outb_mbox - Initialize MPC85xx outbound mailbox
+ * fsl_open_outb_mbox - Initialize MPC85xx outbound mailbox
  * @mport: Master port implementing the outbound message unit
  * @dev_id: Device specific pointer to pass on event
  * @mbox: Mailbox to open
@@ -610,7 +607,8 @@ fsl_rio_tx_handler(int irq, void *dev_in
  * and enables the outbound message unit. Returns %0 on success and
  * %-EINVAL or %-ENOMEM on failure.
  */
-int rio_open_outb_mbox(struct rio_mport *mport, void *dev_id, int mbox, int entries)
+static int
+fsl_open_outb_mbox(struct rio_mport *mport, void *dev_id, int mbox, int entries)
 {
 	int i, j, rc = 0;
 	struct rio_priv *priv = mport->priv;
@@ -706,14 +704,14 @@ int rio_open_outb_mbox(struct rio_mport 
 }
 
 /**
- * rio_close_outb_mbox - Shut down MPC85xx outbound mailbox
+ * fsl_close_outb_mbox - Shut down MPC85xx outbound mailbox
  * @mport: Master port implementing the outbound message unit
  * @mbox: Mailbox to close
  *
  * Disables the outbound message unit, free all buffers, and
  * frees the outbound message interrupt.
  */
-void rio_close_outb_mbox(struct rio_mport *mport, int mbox)
+static void fsl_close_outb_mbox(struct rio_mport *mport, int mbox)
 {
 	struct rio_priv *priv = mport->priv;
 	/* Disable inbound message unit */
@@ -770,7 +768,7 @@ fsl_rio_rx_handler(int irq, void *dev_in
 }
 
 /**
- * rio_open_inb_mbox - Initialize MPC85xx inbound mailbox
+ * fsl_open_inb_mbox - Initialize MPC85xx inbound mailbox
  * @mport: Master port implementing the inbound message unit
  * @dev_id: Device specific pointer to pass on event
  * @mbox: Mailbox to open
@@ -780,7 +778,8 @@ fsl_rio_rx_handler(int irq, void *dev_in
  * and enables the inbound message unit. Returns %0 on success
  * and %-EINVAL or %-ENOMEM on failure.
  */
-int rio_open_inb_mbox(struct rio_mport *mport, void *dev_id, int mbox, int entries)
+static int
+fsl_open_inb_mbox(struct rio_mport *mport, void *dev_id, int mbox, int entries)
 {
 	int i, rc = 0;
 	struct rio_priv *priv = mport->priv;
@@ -844,14 +843,14 @@ int rio_open_inb_mbox(struct rio_mport *
 }
 
 /**
- * rio_close_inb_mbox - Shut down MPC85xx inbound mailbox
+ * fsl_close_inb_mbox - Shut down MPC85xx inbound mailbox
  * @mport: Master port implementing the inbound message unit
  * @mbox: Mailbox to close
  *
  * Disables the inbound message unit, free all buffers, and
  * frees the inbound message interrupt.
  */
-void rio_close_inb_mbox(struct rio_mport *mport, int mbox)
+static void fsl_close_inb_mbox(struct rio_mport *mport, int mbox)
 {
 	struct rio_priv *priv = mport->priv;
 	/* Disable inbound message unit */
@@ -866,7 +865,7 @@ void rio_close_inb_mbox(struct rio_mport
 }
 
 /**
- * rio_hw_add_inb_buffer - Add buffer to the MPC85xx inbound message queue
+ * fsl_add_inb_buffer - Add buffer to the MPC85xx inbound message queue
  * @mport: Master port implementing the inbound message unit
  * @mbox: Inbound mailbox number
  * @buf: Buffer to add to inbound queue
@@ -874,12 +873,12 @@ void rio_close_inb_mbox(struct rio_mport
  * Adds the @buf buffer to the MPC85xx inbound message queue. Returns
  * %0 on success or %-EINVAL on failure.
  */
-int rio_hw_add_inb_buffer(struct rio_mport *mport, int mbox, void *buf)
+static int fsl_add_inb_buffer(struct rio_mport *mport, int mbox, void *buf)
 {
 	int rc = 0;
 	struct rio_priv *priv = mport->priv;
 
-	pr_debug("RIO: rio_hw_add_inb_buffer(), msg_rx_ring.rx_slot %d\n",
+	pr_debug("RIO: fsl_add_inb_buffer(), msg_rx_ring.rx_slot %d\n",
 		 priv->msg_rx_ring.rx_slot);
 
 	if (priv->msg_rx_ring.virt_buffer[priv->msg_rx_ring.rx_slot]) {
@@ -898,17 +897,15 @@ int rio_hw_add_inb_buffer(struct rio_mpo
 	return rc;
 }
 
-EXPORT_SYMBOL_GPL(rio_hw_add_inb_buffer);
-
 /**
- * rio_hw_get_inb_message - Fetch inbound message from the MPC85xx message unit
+ * fsl_get_inb_message - Fetch inbound message from the MPC85xx message unit
  * @mport: Master port implementing the inbound message unit
  * @mbox: Inbound mailbox number
  *
  * Gets the next available inbound message from the inbound message queue.
  * A pointer to the message is returned on success or NULL on failure.
  */
-void *rio_hw_get_inb_message(struct rio_mport *mport, int mbox)
+static void *fsl_get_inb_message(struct rio_mport *mport, int mbox)
 {
 	struct rio_priv *priv = mport->priv;
 	u32 phys_buf, virt_buf;
@@ -945,8 +942,6 @@ void *rio_hw_get_inb_message(struct rio_
 	return buf;
 }
 
-EXPORT_SYMBOL_GPL(rio_hw_get_inb_message);
-
 /**
  * fsl_rio_dbell_handler - MPC85xx doorbell interrupt handler
  * @irq: Linux interrupt number
@@ -1431,6 +1426,13 @@ int fsl_rio_setup(struct platform_device
 	ops->cwrite = fsl_rio_config_write;
 	ops->dsend = fsl_rio_doorbell_send;
 	ops->pwenable = fsl_rio_pw_enable;
+	ops->open_outb_mbox = fsl_open_outb_mbox;
+	ops->open_inb_mbox = fsl_open_inb_mbox;
+	ops->close_outb_mbox = fsl_close_outb_mbox;
+	ops->close_inb_mbox = fsl_close_inb_mbox;
+	ops->add_outb_message = fsl_add_outb_message;
+	ops->add_inb_buffer = fsl_add_inb_buffer;
+	ops->get_inb_message = fsl_get_inb_message;
 
 	port = kzalloc(sizeof(struct rio_mport), GFP_KERNEL);
 	if (!port) {
diff -puN drivers/rapidio/rio.c~rapidio-add-architecture-specific-callbacks drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-add-architecture-specific-callbacks
+++ a/drivers/rapidio/rio.c
@@ -68,9 +68,13 @@ int rio_request_inb_mbox(struct rio_mpor
 			 void (*minb) (struct rio_mport * mport, void *dev_id, int mbox,
 				       int slot))
 {
-	int rc = 0;
+	int rc = -ENOSYS;
+	struct resource *res;
 
-	struct resource *res = kmalloc(sizeof(struct resource), GFP_KERNEL);
+	if (mport->ops->open_inb_mbox == NULL)
+		goto out;
+
+	res = kmalloc(sizeof(struct resource), GFP_KERNEL);
 
 	if (res) {
 		rio_init_mbox_res(res, mbox, mbox);
@@ -88,7 +92,7 @@ int rio_request_inb_mbox(struct rio_mpor
 		/* Hook the inbound message callback */
 		mport->inb_msg[mbox].mcback = minb;
 
-		rc = rio_open_inb_mbox(mport, dev_id, mbox, entries);
+		rc = mport->ops->open_inb_mbox(mport, dev_id, mbox, entries);
 	} else
 		rc = -ENOMEM;
 
@@ -106,10 +110,13 @@ int rio_request_inb_mbox(struct rio_mpor
  */
 int rio_release_inb_mbox(struct rio_mport *mport, int mbox)
 {
-	rio_close_inb_mbox(mport, mbox);
+	if (mport->ops->close_inb_mbox) {
+		mport->ops->close_inb_mbox(mport, mbox);
 
-	/* Release the mailbox resource */
-	return release_resource(mport->inb_msg[mbox].res);
+		/* Release the mailbox resource */
+		return release_resource(mport->inb_msg[mbox].res);
+	} else
+		return -ENOSYS;
 }
 
 /**
@@ -129,9 +136,13 @@ int rio_request_outb_mbox(struct rio_mpo
 			  int entries,
 			  void (*moutb) (struct rio_mport * mport, void *dev_id, int mbox, int slot))
 {
-	int rc = 0;
+	int rc = -ENOSYS;
+	struct resource *res;
 
-	struct resource *res = kmalloc(sizeof(struct resource), GFP_KERNEL);
+	if (mport->ops->open_outb_mbox == NULL)
+		goto out;
+
+	res = kmalloc(sizeof(struct resource), GFP_KERNEL);
 
 	if (res) {
 		rio_init_mbox_res(res, mbox, mbox);
@@ -149,7 +160,7 @@ int rio_request_outb_mbox(struct rio_mpo
 		/* Hook the inbound message callback */
 		mport->outb_msg[mbox].mcback = moutb;
 
-		rc = rio_open_outb_mbox(mport, dev_id, mbox, entries);
+		rc = mport->ops->open_outb_mbox(mport, dev_id, mbox, entries);
 	} else
 		rc = -ENOMEM;
 
@@ -167,10 +178,13 @@ int rio_request_outb_mbox(struct rio_mpo
  */
 int rio_release_outb_mbox(struct rio_mport *mport, int mbox)
 {
-	rio_close_outb_mbox(mport, mbox);
+	if (mport->ops->close_outb_mbox) {
+		mport->ops->close_outb_mbox(mport, mbox);
 
-	/* Release the mailbox resource */
-	return release_resource(mport->outb_msg[mbox].res);
+		/* Release the mailbox resource */
+		return release_resource(mport->outb_msg[mbox].res);
+	} else
+		return -ENOSYS;
 }
 
 /**
diff -puN include/linux/rio.h~rapidio-add-architecture-specific-callbacks include/linux/rio.h
--- a/include/linux/rio.h~rapidio-add-architecture-specific-callbacks
+++ a/include/linux/rio.h
@@ -241,7 +241,7 @@ struct rio_mport {
 	struct rio_msg inb_msg[RIO_MAX_MBOX];
 	struct rio_msg outb_msg[RIO_MAX_MBOX];
 	int host_deviceid;	/* Host device ID */
-	struct rio_ops *ops;	/* maintenance transaction functions */
+	struct rio_ops *ops;	/* low-level architecture-dependent routines */
 	unsigned char id;	/* port ID, unique among all ports */
 	unsigned char index;	/* port index, unique among all port
 				   interfaces of the same type */
@@ -285,6 +285,13 @@ struct rio_net {
  * @cwrite: Callback to perform network write of config space.
  * @dsend: Callback to send a doorbell message.
  * @pwenable: Callback to enable/disable port-write message handling.
+ * @open_outb_mbox: Callback to initialize outbound mailbox.
+ * @close_outb_mbox: Callback to shut down outbound mailbox.
+ * @open_inb_mbox: Callback to initialize inbound mailbox.
+ * @close_inb_mbox: Callback to	shut down inbound mailbox.
+ * @add_outb_message: Callback to add a message to an outbound mailbox queue.
+ * @add_inb_buffer: Callback to	add a buffer to an inbound mailbox queue.
+ * @get_inb_message: Callback to get a message from an inbound mailbox queue.
  */
 struct rio_ops {
 	int (*lcread) (struct rio_mport *mport, int index, u32 offset, int len,
@@ -297,6 +304,16 @@ struct rio_ops {
 			u8 hopcount, u32 offset, int len, u32 data);
 	int (*dsend) (struct rio_mport *mport, int index, u16 destid, u16 data);
 	int (*pwenable) (struct rio_mport *mport, int enable);
+	int (*open_outb_mbox)(struct rio_mport *mport, void *dev_id,
+			      int mbox, int entries);
+	void (*close_outb_mbox)(struct rio_mport *mport, int mbox);
+	int  (*open_inb_mbox)(struct rio_mport *mport, void *dev_id,
+			     int mbox, int entries);
+	void (*close_inb_mbox)(struct rio_mport *mport, int mbox);
+	int  (*add_outb_message)(struct rio_mport *mport, struct rio_dev *rdev,
+				 int mbox, void *buffer, size_t len);
+	int (*add_inb_buffer)(struct rio_mport *mport, int mbox, void *buf);
+	void *(*get_inb_message)(struct rio_mport *mport, int mbox);
 };
 
 #define RIO_RESOURCE_MEM	0x00000100
@@ -380,10 +397,6 @@ union rio_pw_msg {
 /* Architecture and hardware-specific functions */
 extern int rio_init_mports(void);
 extern void rio_register_mport(struct rio_mport *);
-extern int rio_hw_add_outb_message(struct rio_mport *, struct rio_dev *, int,
-				   void *, size_t);
-extern int rio_hw_add_inb_buffer(struct rio_mport *, int, void *);
-extern void *rio_hw_get_inb_message(struct rio_mport *, int);
 extern int rio_open_inb_mbox(struct rio_mport *, void *, int, int);
 extern void rio_close_inb_mbox(struct rio_mport *, int);
 extern int rio_open_outb_mbox(struct rio_mport *, void *, int, int);
diff -puN include/linux/rio_drv.h~rapidio-add-architecture-specific-callbacks include/linux/rio_drv.h
--- a/include/linux/rio_drv.h~rapidio-add-architecture-specific-callbacks
+++ a/include/linux/rio_drv.h
@@ -317,7 +317,8 @@ static inline int rio_add_outb_message(s
 				       struct rio_dev *rdev, int mbox,
 				       void *buffer, size_t len)
 {
-	return rio_hw_add_outb_message(mport, rdev, mbox, buffer, len);
+	return mport->ops->add_outb_message(mport, rdev, mbox,
+						   buffer, len);
 }
 
 extern int rio_request_inb_mbox(struct rio_mport *, void *, int, int,
@@ -336,7 +337,7 @@ extern int rio_release_inb_mbox(struct r
 static inline int rio_add_inb_buffer(struct rio_mport *mport, int mbox,
 				     void *buffer)
 {
-	return rio_hw_add_inb_buffer(mport, mbox, buffer);
+	return mport->ops->add_inb_buffer(mport, mbox, buffer);
 }
 
 /**
@@ -348,7 +349,7 @@ static inline int rio_add_inb_buffer(str
  */
 static inline void *rio_get_inb_message(struct rio_mport *mport, int mbox)
 {
-	return rio_hw_get_inb_message(mport, mbox);
+	return mport->ops->get_inb_message(mport, mbox);
 }
 
 /* Doorbell management */
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

origin.patch
rapidio-add-new-sysfs-attributes.patch
rapidio-add-new-sysfs-attributes-v2.patch
rapidio-add-rapidio-documentation.patch
rapidio-add-rapidio-documentation-v2.patch
rapidio-add-architecture-specific-callbacks.patch
rapidio-modify-configuration-to-support-pci-srio-controller.patch
rapidio-modify-subsystem-and-driver-initialization-sequence.patch
rapidio-modify-mport-id-assignment.patch
rapidio-remove-mport-resource-reservation-from-common-rio-code.patch

