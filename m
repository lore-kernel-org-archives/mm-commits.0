From: akpm@linux-foundation.org
Subject: [merged] rapidio-add-global-inbound-port-write-interfaces.patch
 removed from -mm tree
Date: Wed, 23 Mar 2016 10:41:54 -0700
Message-ID: <56f2d562.904JFDpGIdzOQEdp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59246 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756476AbcCWRlz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 13:41:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, a-jacquiot@ti.com, andre.van.herk@prodrive-technologies.com, mporter@kernel.crashing.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: add global inbound port write interfaces
has been removed from the -mm tree.  Its filename was
     rapidio-add-global-inbound-port-write-interfaces.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio: add global inbound port write interfaces

Add new Port Write handler registration interfaces that attach PW handlers
to local mport device objects.  This is different from old interface that
attaches PW callback to individual RapidIO device.  The new interfaces are
intended for use for common event handling (e.g.  hot-plug notifications)
while the old interface is available for individual device drivers.

This patch is based on patch proposed by Andre van Herk but preserves
existing per-device interface and adds lock protection for list handling.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/sysdev/fsl_rio.c    |    1 
 arch/powerpc/sysdev/fsl_rio.h    |    1 
 arch/powerpc/sysdev/fsl_rmu.c    |   16 ++-
 drivers/rapidio/devices/tsi721.c |   24 ----
 drivers/rapidio/rio.c            |  142 ++++++++++++++++++++++++-----
 include/linux/rio.h              |    2 
 include/linux/rio_drv.h          |    9 +
 7 files changed, 144 insertions(+), 51 deletions(-)

diff -puN arch/powerpc/sysdev/fsl_rio.c~rapidio-add-global-inbound-port-write-interfaces arch/powerpc/sysdev/fsl_rio.c
--- a/arch/powerpc/sysdev/fsl_rio.c~rapidio-add-global-inbound-port-write-interfaces
+++ a/arch/powerpc/sysdev/fsl_rio.c
@@ -726,6 +726,7 @@ int fsl_rio_setup(struct platform_device
 		fsl_rio_inbound_mem_init(priv);
 
 		dbell->mport[i] = port;
+		pw->mport[i] = port;
 
 		if (rio_register_mport(port)) {
 			release_resource(&port->iores);
diff -puN arch/powerpc/sysdev/fsl_rio.h~rapidio-add-global-inbound-port-write-interfaces arch/powerpc/sysdev/fsl_rio.h
--- a/arch/powerpc/sysdev/fsl_rio.h~rapidio-add-global-inbound-port-write-interfaces
+++ a/arch/powerpc/sysdev/fsl_rio.h
@@ -97,6 +97,7 @@ struct fsl_rio_dbell {
 };
 
 struct fsl_rio_pw {
+	struct rio_mport *mport[MAX_PORT_NUM];
 	struct device *dev;
 	struct rio_pw_regs __iomem *pw_regs;
 	struct rio_port_write_msg port_write_msg;
diff -puN arch/powerpc/sysdev/fsl_rmu.c~rapidio-add-global-inbound-port-write-interfaces arch/powerpc/sysdev/fsl_rmu.c
--- a/arch/powerpc/sysdev/fsl_rmu.c~rapidio-add-global-inbound-port-write-interfaces
+++ a/arch/powerpc/sysdev/fsl_rmu.c
@@ -481,14 +481,14 @@ pw_done:
 static void fsl_pw_dpc(struct work_struct *work)
 {
 	struct fsl_rio_pw *pw = container_of(work, struct fsl_rio_pw, pw_work);
-	u32 msg_buffer[RIO_PW_MSG_SIZE/sizeof(u32)];
+	union rio_pw_msg msg_buffer;
+	int i;
 
 	/*
 	 * Process port-write messages
 	 */
-	while (kfifo_out_spinlocked(&pw->pw_fifo, (unsigned char *)msg_buffer,
+	while (kfifo_out_spinlocked(&pw->pw_fifo, (unsigned char *)&msg_buffer,
 			 RIO_PW_MSG_SIZE, &pw->pw_fifo_lock)) {
-		/* Process one message */
 #ifdef DEBUG_PW
 		{
 		u32 i;
@@ -496,15 +496,19 @@ static void fsl_pw_dpc(struct work_struc
 		for (i = 0; i < RIO_PW_MSG_SIZE/sizeof(u32); i++) {
 			if ((i%4) == 0)
 				pr_debug("\n0x%02x: 0x%08x", i*4,
-					 msg_buffer[i]);
+					 msg_buffer.raw[i]);
 			else
-				pr_debug(" 0x%08x", msg_buffer[i]);
+				pr_debug(" 0x%08x", msg_buffer.raw[i]);
 		}
 		pr_debug("\n");
 		}
 #endif
 		/* Pass the port-write message to RIO core for processing */
-		rio_inb_pwrite_handler((union rio_pw_msg *)msg_buffer);
+		for (i = 0; i < MAX_PORT_NUM; i++) {
+			if (pw->mport[i])
+				rio_inb_pwrite_handler(pw->mport[i],
+						       &msg_buffer);
+		}
 	}
 }
 
diff -puN drivers/rapidio/devices/tsi721.c~rapidio-add-global-inbound-port-write-interfaces drivers/rapidio/devices/tsi721.c
--- a/drivers/rapidio/devices/tsi721.c~rapidio-add-global-inbound-port-write-interfaces
+++ a/drivers/rapidio/devices/tsi721.c
@@ -36,8 +36,6 @@
 
 #include "tsi721.h"
 
-#define DEBUG_PW	/* Inbound Port-Write debugging */
-
 static void tsi721_omsg_handler(struct tsi721_device *priv, int ch);
 static void tsi721_imsg_handler(struct tsi721_device *priv, int ch);
 
@@ -282,30 +280,15 @@ static void tsi721_pw_dpc(struct work_st
 {
 	struct tsi721_device *priv = container_of(work, struct tsi721_device,
 						    pw_work);
-	u32 msg_buffer[RIO_PW_MSG_SIZE/sizeof(u32)]; /* Use full size PW message
-							buffer for RIO layer */
+	union rio_pw_msg pwmsg;
 
 	/*
 	 * Process port-write messages
 	 */
-	while (kfifo_out_spinlocked(&priv->pw_fifo, (unsigned char *)msg_buffer,
+	while (kfifo_out_spinlocked(&priv->pw_fifo, (unsigned char *)&pwmsg,
 			 TSI721_RIO_PW_MSG_SIZE, &priv->pw_fifo_lock)) {
-		/* Process one message */
-#ifdef DEBUG_PW
-		{
-		u32 i;
-		pr_debug("%s : Port-Write Message:", __func__);
-		for (i = 0; i < RIO_PW_MSG_SIZE/sizeof(u32); ) {
-			pr_debug("0x%02x: %08x %08x %08x %08x", i*4,
-				msg_buffer[i], msg_buffer[i + 1],
-				msg_buffer[i + 2], msg_buffer[i + 3]);
-			i += 4;
-		}
-		pr_debug("\n");
-		}
-#endif
 		/* Pass the port-write message to RIO core for processing */
-		rio_inb_pwrite_handler((union rio_pw_msg *)msg_buffer);
+		rio_inb_pwrite_handler(&priv->mport, &pwmsg);
 	}
 }
 
@@ -2702,6 +2685,7 @@ static void tsi721_remove(struct pci_dev
 
 	tsi721_disable_ints(priv);
 	tsi721_free_irq(priv);
+	flush_scheduled_work();
 	rio_unregister_mport(&priv->mport);
 
 	tsi721_unregister_dma(priv);
diff -puN drivers/rapidio/rio.c~rapidio-add-global-inbound-port-write-interfaces drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-add-global-inbound-port-write-interfaces
+++ a/drivers/rapidio/rio.c
@@ -30,6 +30,20 @@
 
 #include "rio.h"
 
+/*
+ * struct rio_pwrite - RIO portwrite event
+ * @node:    Node in list of doorbell events
+ * @pwcback: Doorbell event callback
+ * @context: Handler specific context to pass on event
+ */
+struct rio_pwrite {
+	struct list_head node;
+
+	int (*pwcback)(struct rio_mport *mport, void *context,
+		       union rio_pw_msg *msg, int step);
+	void *context;
+};
+
 MODULE_DESCRIPTION("RapidIO Subsystem Core");
 MODULE_AUTHOR("Matt Porter <mporter@kernel.crashing.org>");
 MODULE_AUTHOR("Alexandre Bounine <alexandre.bounine@idt.com>");
@@ -514,7 +528,71 @@ int rio_release_outb_dbell(struct rio_de
 }
 
 /**
- * rio_request_inb_pwrite - request inbound port-write message service
+ * rio_add_mport_pw_handler - add port-write message handler into the list
+ *                            of mport specific pw handlers
+ * @mport:   RIO master port to bind the portwrite callback
+ * @context: Handler specific context to pass on event
+ * @pwcback: Callback to execute when portwrite is received
+ *
+ * Returns 0 if the request has been satisfied.
+ */
+int rio_add_mport_pw_handler(struct rio_mport *mport, void *context,
+			     int (*pwcback)(struct rio_mport *mport,
+			     void *context, union rio_pw_msg *msg, int step))
+{
+	int rc = 0;
+	struct rio_pwrite *pwrite;
+
+	pwrite = kzalloc(sizeof(struct rio_pwrite), GFP_KERNEL);
+	if (!pwrite) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	pwrite->pwcback = pwcback;
+	pwrite->context = context;
+	mutex_lock(&mport->lock);
+	list_add_tail(&pwrite->node, &mport->pwrites);
+	mutex_unlock(&mport->lock);
+out:
+	return rc;
+}
+EXPORT_SYMBOL_GPL(rio_add_mport_pw_handler);
+
+/**
+ * rio_del_mport_pw_handler - remove port-write message handler from the list
+ *                            of mport specific pw handlers
+ * @mport:   RIO master port to bind the portwrite callback
+ * @context: Registered handler specific context to pass on event
+ * @pwcback: Registered callback function
+ *
+ * Returns 0 if the request has been satisfied.
+ */
+int rio_del_mport_pw_handler(struct rio_mport *mport, void *context,
+			     int (*pwcback)(struct rio_mport *mport,
+			     void *context, union rio_pw_msg *msg, int step))
+{
+	int rc = -EINVAL;
+	struct rio_pwrite *pwrite;
+
+	mutex_lock(&mport->lock);
+	list_for_each_entry(pwrite, &mport->pwrites, node) {
+		if (pwrite->pwcback == pwcback && pwrite->context == context) {
+			list_del(&pwrite->node);
+			kfree(pwrite);
+			rc = 0;
+			break;
+		}
+	}
+	mutex_unlock(&mport->lock);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(rio_del_mport_pw_handler);
+
+/**
+ * rio_request_inb_pwrite - request inbound port-write message service for
+ *                          specific RapidIO device
  * @rdev: RIO device to which register inbound port-write callback routine
  * @pwcback: Callback routine to execute when port-write is received
  *
@@ -539,6 +617,7 @@ EXPORT_SYMBOL_GPL(rio_request_inb_pwrite
 
 /**
  * rio_release_inb_pwrite - release inbound port-write message service
+ *                          associated with specific RapidIO device
  * @rdev: RIO device which registered for inbound port-write callback
  *
  * Removes callback from the rio_dev structure. Returns 0 if the request
@@ -1002,52 +1081,66 @@ rd_err:
 }
 
 /**
- * rio_inb_pwrite_handler - process inbound port-write message
+ * rio_inb_pwrite_handler - inbound port-write message handler
+ * @mport:  mport device associated with port-write
  * @pw_msg: pointer to inbound port-write message
  *
  * Processes an inbound port-write message. Returns 0 if the request
  * has been satisfied.
  */
-int rio_inb_pwrite_handler(union rio_pw_msg *pw_msg)
+int rio_inb_pwrite_handler(struct rio_mport *mport, union rio_pw_msg *pw_msg)
 {
 	struct rio_dev *rdev;
 	u32 err_status, em_perrdet, em_ltlerrdet;
 	int rc, portnum;
-
-	rdev = rio_get_comptag((pw_msg->em.comptag & RIO_CTAG_UDEVID), NULL);
-	if (rdev == NULL) {
-		/* Device removed or enumeration error */
-		pr_debug("RIO: %s No matching device for CTag 0x%08x\n",
-			__func__, pw_msg->em.comptag);
-		return -EIO;
-	}
-
-	pr_debug("RIO: Port-Write message from %s\n", rio_name(rdev));
+	struct rio_pwrite *pwrite;
 
 #ifdef DEBUG_PW
 	{
-	u32 i;
-	for (i = 0; i < RIO_PW_MSG_SIZE/sizeof(u32);) {
+		u32 i;
+
+		pr_debug("%s: PW to mport_%d:\n", __func__, mport->id);
+		for (i = 0; i < RIO_PW_MSG_SIZE / sizeof(u32); i = i + 4) {
 			pr_debug("0x%02x: %08x %08x %08x %08x\n",
-				 i*4, pw_msg->raw[i], pw_msg->raw[i + 1],
-				 pw_msg->raw[i + 2], pw_msg->raw[i + 3]);
-			i += 4;
-	}
+				i * 4, pw_msg->raw[i], pw_msg->raw[i + 1],
+				pw_msg->raw[i + 2], pw_msg->raw[i + 3]);
+		}
 	}
 #endif
 
-	/* Call an external service function (if such is registered
-	 * for this device). This may be the service for endpoints that send
-	 * device-specific port-write messages. End-point messages expected
-	 * to be handled completely by EP specific device driver.
+	rdev = rio_get_comptag((pw_msg->em.comptag & RIO_CTAG_UDEVID), NULL);
+	if (rdev) {
+		pr_debug("RIO: Port-Write message from %s\n", rio_name(rdev));
+	} else {
+		pr_debug("RIO: %s No matching device for CTag 0x%08x\n",
+			__func__, pw_msg->em.comptag);
+	}
+
+	/* Call a device-specific handler (if it is registered for the device).
+	 * This may be the service for endpoints that send device-specific
+	 * port-write messages. End-point messages expected to be handled
+	 * completely by EP specific device driver.
 	 * For switches rc==0 signals that no standard processing required.
 	 */
-	if (rdev->pwcback != NULL) {
+	if (rdev && rdev->pwcback) {
 		rc = rdev->pwcback(rdev, pw_msg, 0);
 		if (rc == 0)
 			return 0;
 	}
 
+	mutex_lock(&mport->lock);
+	list_for_each_entry(pwrite, &mport->pwrites, node)
+		pwrite->pwcback(mport, pwrite->context, pw_msg, 0);
+	mutex_unlock(&mport->lock);
+
+	if (!rdev)
+		return 0;
+
+	/*
+	 * FIXME: The code below stays as it was before for now until we decide
+	 * how to do default PW handling in combination with per-mport callbacks
+	 */
+
 	portnum = pw_msg->em.is_port & 0xFF;
 
 	/* Check if device and route to it are functional:
@@ -2060,6 +2153,7 @@ int rio_mport_initialize(struct rio_mpor
 	mport->nscan = NULL;
 	mutex_init(&mport->lock);
 	mport->pwe_refcnt = 0;
+	INIT_LIST_HEAD(&mport->pwrites);
 
 	return 0;
 }
diff -puN include/linux/rio.h~rapidio-add-global-inbound-port-write-interfaces include/linux/rio.h
--- a/include/linux/rio.h~rapidio-add-global-inbound-port-write-interfaces
+++ a/include/linux/rio.h
@@ -245,6 +245,7 @@ enum rio_phy_type {
 /**
  * struct rio_mport - RIO master port info
  * @dbells: List of doorbell events
+ * @pwrites: List of portwrite events
  * @node: Node in global list of master ports
  * @nnode: Node in network list of master ports
  * @net: RIO net this mport is attached to
@@ -270,6 +271,7 @@ enum rio_phy_type {
  */
 struct rio_mport {
 	struct list_head dbells;	/* list of doorbell events */
+	struct list_head pwrites;	/* list of portwrite events */
 	struct list_head node;	/* node in global list of ports */
 	struct list_head nnode;	/* node in net list of ports */
 	struct rio_net *net;	/* RIO net this mport is attached to */
diff -puN include/linux/rio_drv.h~rapidio-add-global-inbound-port-write-interfaces include/linux/rio_drv.h
--- a/include/linux/rio_drv.h~rapidio-add-global-inbound-port-write-interfaces
+++ a/include/linux/rio_drv.h
@@ -374,7 +374,14 @@ extern void rio_unmap_inb_region(struct
 extern int rio_request_inb_pwrite(struct rio_dev *,
 			int (*)(struct rio_dev *, union rio_pw_msg*, int));
 extern int rio_release_inb_pwrite(struct rio_dev *);
-extern int rio_inb_pwrite_handler(union rio_pw_msg *pw_msg);
+extern int rio_add_mport_pw_handler(struct rio_mport *mport, void *dev_id,
+			int (*pwcback)(struct rio_mport *mport, void *dev_id,
+			union rio_pw_msg *msg, int step));
+extern int rio_del_mport_pw_handler(struct rio_mport *mport, void *dev_id,
+			int (*pwcback)(struct rio_mport *mport, void *dev_id,
+			union rio_pw_msg *msg, int step));
+extern int rio_inb_pwrite_handler(struct rio_mport *mport,
+				  union rio_pw_msg *pw_msg);
 extern void rio_pw_enable(struct rio_mport *mport, int enable);
 
 /* LDM support */
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are


