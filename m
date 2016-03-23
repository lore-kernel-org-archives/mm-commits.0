From: akpm@linux-foundation.org
Subject: [merged] rapidio-add-core-mport-removal-support.patch removed
 from -mm tree
Date: Wed, 23 Mar 2016 10:41:37 -0700
Message-ID: <56f2d551.DgpXKOx43Z/mkhTH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59220 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756589AbcCWRli (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 13:41:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, a-jacquiot@ti.com, andre.van.herk@prodrive-technologies.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: add core mport removal support
has been removed from the -mm tree.  Its filename was
     rapidio-add-core-mport-removal-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio: add core mport removal support

Add common mport removal support functions into the RapidIO subsystem core.

Changes to the existing mport registration process have been made to avoid
race conditions with active subsystem interfaces immediately after mport
device registration: part of initialization code from rio_register_mport()
have been moved into separate function rio_mport_initialize() to allow to
perform mport registration as the final step of setup process.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio.c |   98 ++++++++++++++++++++++++++++++++--------
 drivers/rapidio/rio.h |    2 
 include/linux/rio.h   |   18 +++++++
 3 files changed, 98 insertions(+), 20 deletions(-)

diff -puN drivers/rapidio/rio.c~rapidio-add-core-mport-removal-support drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-add-core-mport-removal-support
+++ a/drivers/rapidio/rio.c
@@ -149,6 +149,7 @@ int rio_add_device(struct rio_dev *rdev)
 {
 	int err;
 
+	atomic_set(&rdev->state, RIO_DEVICE_RUNNING);
 	err = device_register(&rdev->dev);
 	if (err)
 		return err;
@@ -172,13 +173,15 @@ EXPORT_SYMBOL_GPL(rio_add_device);
 /*
  * rio_del_device - removes a RIO device from the device model
  * @rdev: RIO device
+ * @state: device state to set during removal process
  *
  * Removes the RIO device to the kernel device list and subsystem's device list.
  * Clears sysfs entries for the removed device.
  */
-void rio_del_device(struct rio_dev *rdev)
+void rio_del_device(struct rio_dev *rdev, enum rio_device_state state)
 {
 	pr_debug("RIO: %s: removing %s\n", __func__, rio_name(rdev));
+	atomic_set(&rdev->state, state);
 	spin_lock(&rio_global_list_lock);
 	list_del(&rdev->global_list);
 	if (rdev->net) {
@@ -2010,32 +2013,28 @@ static int rio_get_hdid(int index)
 	return hdid[index];
 }
 
-int rio_register_mport(struct rio_mport *port)
+int rio_mport_initialize(struct rio_mport *mport)
 {
-	struct rio_scan_node *scan = NULL;
-	int res = 0;
-
 	if (next_portid >= RIO_MAX_MPORTS) {
 		pr_err("RIO: reached specified max number of mports\n");
-		return 1;
+		return -ENODEV;
 	}
 
-	port->id = next_portid++;
-	port->host_deviceid = rio_get_hdid(port->id);
-	port->nscan = NULL;
+	atomic_set(&mport->state, RIO_DEVICE_INITIALIZING);
+	mport->id = next_portid++;
+	mport->host_deviceid = rio_get_hdid(mport->id);
+	mport->nscan = NULL;
 
-	dev_set_name(&port->dev, "rapidio%d", port->id);
-	port->dev.class = &rio_mport_class;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rio_mport_initialize);
 
-	res = device_register(&port->dev);
-	if (res)
-		dev_err(&port->dev, "RIO: mport%d registration failed ERR=%d\n",
-			port->id, res);
-	else
-		dev_dbg(&port->dev, "RIO: mport%d registered\n", port->id);
+int rio_register_mport(struct rio_mport *port)
+{
+	struct rio_scan_node *scan = NULL;
+	int res = 0;
 
 	mutex_lock(&rio_mport_list_lock);
-	list_add_tail(&port->node, &rio_mports);
 
 	/*
 	 * Check if there are any registered enumeration/discovery operations
@@ -2049,12 +2048,73 @@ int rio_register_mport(struct rio_mport
 				break;
 		}
 	}
+
+	list_add_tail(&port->node, &rio_mports);
 	mutex_unlock(&rio_mport_list_lock);
 
+	dev_set_name(&port->dev, "rapidio%d", port->id);
+	port->dev.class = &rio_mport_class;
+	atomic_set(&port->state, RIO_DEVICE_RUNNING);
+
+	res = device_register(&port->dev);
+	if (res)
+		dev_err(&port->dev, "RIO: mport%d registration failed ERR=%d\n",
+			port->id, res);
+	else
+		dev_dbg(&port->dev, "RIO: registered mport%d\n", port->id);
+
+	return res;
+}
+EXPORT_SYMBOL_GPL(rio_register_mport);
+
+static int rio_mport_cleanup_callback(struct device *dev, void *data)
+{
+	struct rio_dev *rdev = to_rio_dev(dev);
+
+	if (dev->bus == &rio_bus_type)
+		rio_del_device(rdev, RIO_DEVICE_SHUTDOWN);
+	return 0;
+}
+
+static int rio_net_remove_children(struct rio_net *net)
+{
+	/*
+	 * Unregister all RapidIO devices residing on this net (this will
+	 * invoke notification of registered subsystem interfaces as well).
+	 */
+	device_for_each_child(&net->dev, NULL, rio_mport_cleanup_callback);
+	return 0;
+}
+
+int rio_unregister_mport(struct rio_mport *port)
+{
 	pr_debug("RIO: %s %s id=%d\n", __func__, port->name, port->id);
+
+	/* Transition mport to the SHUTDOWN state */
+	if (atomic_cmpxchg(&port->state,
+			   RIO_DEVICE_RUNNING,
+			   RIO_DEVICE_SHUTDOWN) != RIO_DEVICE_RUNNING) {
+		pr_err("RIO: %s unexpected state transition for mport %s\n",
+			__func__, port->name);
+	}
+
+	if (port->net && port->net->hport == port) {
+		rio_net_remove_children(port->net);
+		rio_free_net(port->net);
+	}
+
+	/*
+	 * Unregister all RapidIO devices attached to this mport (this will
+	 * invoke notification of registered subsystem interfaces as well).
+	 */
+	mutex_lock(&rio_mport_list_lock);
+	list_del(&port->node);
+	mutex_unlock(&rio_mport_list_lock);
+	device_unregister(&port->dev);
+
 	return 0;
 }
-EXPORT_SYMBOL_GPL(rio_register_mport);
+EXPORT_SYMBOL_GPL(rio_unregister_mport);
 
 EXPORT_SYMBOL_GPL(rio_local_get_device_id);
 EXPORT_SYMBOL_GPL(rio_get_device);
diff -puN drivers/rapidio/rio.h~rapidio-add-core-mport-removal-support drivers/rapidio/rio.h
--- a/drivers/rapidio/rio.h~rapidio-add-core-mport-removal-support
+++ a/drivers/rapidio/rio.h
@@ -43,7 +43,7 @@ extern struct rio_net *rio_alloc_net(str
 extern int rio_add_net(struct rio_net *net);
 extern void rio_free_net(struct rio_net *net);
 extern int rio_add_device(struct rio_dev *rdev);
-extern void rio_del_device(struct rio_dev *rdev);
+extern void rio_del_device(struct rio_dev *rdev, enum rio_device_state state);
 extern int rio_enable_rx_tx_port(struct rio_mport *port, int local, u16 destid,
 				 u8 hopcount, u8 port_num);
 extern int rio_register_scan(int mport_id, struct rio_scan *scan_ops);
diff -puN include/linux/rio.h~rapidio-add-core-mport-removal-support include/linux/rio.h
--- a/include/linux/rio.h~rapidio-add-core-mport-removal-support
+++ a/include/linux/rio.h
@@ -137,6 +137,13 @@ struct rio_switch_ops {
 	int (*em_handle) (struct rio_dev *dev, u8 swport);
 };
 
+enum rio_device_state {
+	RIO_DEVICE_INITIALIZING,
+	RIO_DEVICE_RUNNING,
+	RIO_DEVICE_GONE,
+	RIO_DEVICE_SHUTDOWN,
+};
+
 /**
  * struct rio_dev - RIO device info
  * @global_list: Node in list of all RIO devices
@@ -165,6 +172,7 @@ struct rio_switch_ops {
  * @destid: Network destination ID (or associated destid for switch)
  * @hopcount: Hopcount to this device
  * @prev: Previous RIO device connected to the current one
+ * @state: device state
  * @rswitch: struct rio_switch (if valid for this device)
  */
 struct rio_dev {
@@ -194,6 +202,7 @@ struct rio_dev {
 	u16 destid;
 	u8 hopcount;
 	struct rio_dev *prev;
+	atomic_t state;
 	struct rio_switch rswitch[0];	/* RIO switch info */
 };
 
@@ -255,6 +264,7 @@ enum rio_phy_type {
  * @priv: Master port private data
  * @dma: DMA device associated with mport
  * @nscan: RapidIO network enumeration/discovery operations
+ * @state: mport device state
  */
 struct rio_mport {
 	struct list_head dbells;	/* list of doorbell events */
@@ -283,8 +293,14 @@ struct rio_mport {
 	struct dma_device	dma;
 #endif
 	struct rio_scan *nscan;
+	atomic_t state;
 };
 
+static inline int rio_mport_is_running(struct rio_mport *mport)
+{
+	return atomic_read(&mport->state) == RIO_DEVICE_RUNNING;
+}
+
 /*
  * Enumeration/discovery control flags
  */
@@ -525,7 +541,9 @@ struct rio_scan_node {
 };
 
 /* Architecture and hardware-specific functions */
+extern int rio_mport_initialize(struct rio_mport *);
 extern int rio_register_mport(struct rio_mport *);
+extern int rio_unregister_mport(struct rio_mport *);
 extern int rio_open_inb_mbox(struct rio_mport *, void *, int, int);
 extern void rio_close_inb_mbox(struct rio_mport *, int);
 extern int rio_open_outb_mbox(struct rio_mport *, void *, int, int);
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are


