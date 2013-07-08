From: akpm@linux-foundation.org
Subject: [merged] rapidio-update-enumerator-registration-mechanism.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:36:39 -0700
Message-ID: <51db14c7.Vo7792j8LP0fP1gD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51695 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab3GHTgk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:36:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stef.van.os@Prodrive.nl, mporter@kernel.crashing.org, micha.nelissen@Prodrive.nl, leoli@freescale.com, jdelvare@suse.de, galak@kernel.crashing.org, andre.van.herk@Prodrive.nl, alexandre.bounine@idt.com

Subject: [merged] rapidio-update-enumerator-registration-mechanism.patch removed from -mm tree
To: alexandre.bounine@idt.com,andre.van.herk@Prodrive.nl,galak@kernel.crashing.org,jdelvare@suse.de,leoli@freescale.com,micha.nelissen@Prodrive.nl,mporter@kernel.crashing.org,stef.van.os@Prodrive.nl,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:36:39 -0700


The patch titled
     Subject: rapidio: update enumerator registration mechanism
has been removed from the -mm tree.  Its filename was
     rapidio-update-enumerator-registration-mechanism.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio: update enumerator registration mechanism

Update enumeration/discovery method registration mechanism to allow
loading enumeration/discovery methods before all mports are registered.

Existing statically linked RapidIO subsystem expects that all available
RapidIO mport devices are initialized and registered before the
enumeration/discovery method is registered.  Switching to loadable mport
device drivers creates situation when mport device driver can be loaded
after enumeration/discovery method is attached (e.g., loadable mport
driver in a system with statically linked RapidIO core and enumerator). 
This also will happen in a system with hot-pluggable RapidIO controllers.

To remove the dependency on the initialization/registration order this
patch introduces enumeration/discovery registration mechanism that
supports arbitrary registration order of mports and enumerator/discovery
methods.

The following registration rules are implemented:
- only one enumeration/discovery method can be registered for given mport ID
  (including RIO_MPORT_ANY);
- when new enumeration/discovery methods tries to attach to the registered mport
  device, method with matching mport ID will replace a default method previously
  registered for given mport (if any);
- enumeration/discovery method with target ID=RIO_MPORT_ANY will be attached
  only to mports that do not have another enumerator attached to them;
- when new mport device is registered with RapidIO subsystem, registration
  routine searches for the enumeration/discovery method with the best matching
  mport ID;

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Andre van Herk <andre.van.herk@Prodrive.nl>
Cc: Micha Nelissen <micha.nelissen@Prodrive.nl>
Cc: Stef van Os <stef.van.os@Prodrive.nl>
Cc: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio-scan.c  |    1 
 drivers/rapidio/rio-sysfs.c |   17 ---
 drivers/rapidio/rio.c       |  176 ++++++++++++++++++++++++++++------
 drivers/rapidio/rio.h       |    3 
 include/linux/rio.h         |   15 ++
 5 files changed, 164 insertions(+), 48 deletions(-)

diff -puN drivers/rapidio/rio-scan.c~rapidio-update-enumerator-registration-mechanism drivers/rapidio/rio-scan.c
--- a/drivers/rapidio/rio-scan.c~rapidio-update-enumerator-registration-mechanism
+++ a/drivers/rapidio/rio-scan.c
@@ -1162,6 +1162,7 @@ bail:
 }
 
 static struct rio_scan rio_scan_ops = {
+	.owner = THIS_MODULE,
 	.enumerate = rio_enum_mport,
 	.discover = rio_disc_mport,
 };
diff -puN drivers/rapidio/rio-sysfs.c~rapidio-update-enumerator-registration-mechanism drivers/rapidio/rio-sysfs.c
--- a/drivers/rapidio/rio-sysfs.c~rapidio-update-enumerator-registration-mechanism
+++ a/drivers/rapidio/rio-sysfs.c
@@ -286,7 +286,6 @@ static ssize_t bus_scan_store(struct bus
 				size_t count)
 {
 	long val;
-	struct rio_mport *port = NULL;
 	int rc;
 
 	if (kstrtol(buf, 0, &val) < 0)
@@ -300,21 +299,7 @@ static ssize_t bus_scan_store(struct bus
 	if (val < 0 || val >= RIO_MAX_MPORTS)
 		return -EINVAL;
 
-	port = rio_find_mport((int)val);
-
-	if (!port) {
-		pr_debug("RIO: %s: mport_%d not available\n",
-			 __func__, (int)val);
-		return -EINVAL;
-	}
-
-	if (!port->nscan)
-		return -EINVAL;
-
-	if (port->host_deviceid >= 0)
-		rc = port->nscan->enumerate(port, 0);
-	else
-		rc = port->nscan->discover(port, RIO_SCAN_ENUM_NO_WAIT);
+	rc = rio_mport_scan((int)val);
 exit:
 	if (!rc)
 		rc = count;
diff -puN drivers/rapidio/rio.c~rapidio-update-enumerator-registration-mechanism drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-update-enumerator-registration-mechanism
+++ a/drivers/rapidio/rio.c
@@ -34,6 +34,7 @@ static LIST_HEAD(rio_devices);
 static DEFINE_SPINLOCK(rio_global_list_lock);
 
 static LIST_HEAD(rio_mports);
+static LIST_HEAD(rio_scans);
 static DEFINE_MUTEX(rio_mport_list_lock);
 static unsigned char next_portid;
 static DEFINE_SPINLOCK(rio_mmap_lock);
@@ -1602,34 +1603,73 @@ found:
  * rio_register_scan - enumeration/discovery method registration interface
  * @mport_id: mport device ID for which fabric scan routine has to be set
  *            (RIO_MPORT_ANY = set for all available mports)
- * @scan_ops: enumeration/discovery control structure
+ * @scan_ops: enumeration/discovery operations structure
+ *
+ * Registers enumeration/discovery operations with RapidIO subsystem and
+ * attaches it to the specified mport device (or all available mports
+ * if RIO_MPORT_ANY is specified).
  *
- * Assigns enumeration or discovery method to the specified mport device (or all
- * available mports if RIO_MPORT_ANY is specified).
  * Returns error if the mport already has an enumerator attached to it.
- * In case of RIO_MPORT_ANY ignores ports with valid scan routines and returns
- * an error if was unable to find at least one available mport.
+ * In case of RIO_MPORT_ANY skips mports with valid scan routines (no error).
  */
 int rio_register_scan(int mport_id, struct rio_scan *scan_ops)
 {
 	struct rio_mport *port;
-	int rc = -EBUSY;
+	struct rio_scan_node *scan;
+	int rc = 0;
 
-	mutex_lock(&rio_mport_list_lock);
-	list_for_each_entry(port, &rio_mports, node) {
-		if (port->id == mport_id || mport_id == RIO_MPORT_ANY) {
-			if (port->nscan && mport_id == RIO_MPORT_ANY)
-				continue;
-			else if (port->nscan)
-				break;
+	pr_debug("RIO: %s for mport_id=%d\n", __func__, mport_id);
 
-			port->nscan = scan_ops;
-			rc = 0;
+	if ((mport_id != RIO_MPORT_ANY && mport_id >= RIO_MAX_MPORTS) ||
+	    !scan_ops)
+		return -EINVAL;
 
-			if (mport_id != RIO_MPORT_ANY)
-				break;
+	mutex_lock(&rio_mport_list_lock);
+
+	/*
+	 * Check if there is another enumerator already registered for
+	 * the same mport ID (including RIO_MPORT_ANY). Multiple enumerators
+	 * for the same mport ID are not supported.
+	 */
+	list_for_each_entry(scan, &rio_scans, node) {
+		if (scan->mport_id == mport_id) {
+			rc = -EBUSY;
+			goto err_out;
 		}
 	}
+
+	/*
+	 * Allocate and initialize new scan registration node.
+	 */
+	scan = kzalloc(sizeof(*scan), GFP_KERNEL);
+	if (!scan) {
+		rc = -ENOMEM;
+		goto err_out;
+	}
+
+	scan->mport_id = mport_id;
+	scan->ops = scan_ops;
+
+	/*
+	 * Traverse the list of registered mports to attach this new scan.
+	 *
+	 * The new scan with matching mport ID overrides any previously attached
+	 * scan assuming that old scan (if any) is the default one (based on the
+	 * enumerator registration check above).
+	 * If the new scan is the global one, it will be attached only to mports
+	 * that do not have their own individual operations already attached.
+	 */
+	list_for_each_entry(port, &rio_mports, node) {
+		if (port->id == mport_id) {
+			port->nscan = scan_ops;
+			break;
+		} else if (mport_id == RIO_MPORT_ANY && !port->nscan)
+			port->nscan = scan_ops;
+	}
+
+	list_add_tail(&scan->node, &rio_scans);
+
+err_out:
 	mutex_unlock(&rio_mport_list_lock);
 
 	return rc;
@@ -1639,30 +1679,81 @@ EXPORT_SYMBOL_GPL(rio_register_scan);
 /**
  * rio_unregister_scan - removes enumeration/discovery method from mport
  * @mport_id: mport device ID for which fabric scan routine has to be
- *            unregistered (RIO_MPORT_ANY = set for all available mports)
+ *            unregistered (RIO_MPORT_ANY = apply to all mports that use
+ *            the specified scan_ops)
+ * @scan_ops: enumeration/discovery operations structure
  *
  * Removes enumeration or discovery method assigned to the specified mport
- * device (or all available mports if RIO_MPORT_ANY is specified).
+ * device. If RIO_MPORT_ANY is specified, removes the specified operations from
+ * all mports that have them attached.
  */
-int rio_unregister_scan(int mport_id)
+int rio_unregister_scan(int mport_id, struct rio_scan *scan_ops)
 {
 	struct rio_mport *port;
+	struct rio_scan_node *scan;
+
+	pr_debug("RIO: %s for mport_id=%d\n", __func__, mport_id);
+
+	if (mport_id != RIO_MPORT_ANY && mport_id >= RIO_MAX_MPORTS)
+		return -EINVAL;
 
 	mutex_lock(&rio_mport_list_lock);
-	list_for_each_entry(port, &rio_mports, node) {
-		if (port->id == mport_id || mport_id == RIO_MPORT_ANY) {
-			if (port->nscan)
-				port->nscan = NULL;
-			if (mport_id != RIO_MPORT_ANY)
-				break;
+
+	list_for_each_entry(port, &rio_mports, node)
+		if (port->id == mport_id ||
+		    (mport_id == RIO_MPORT_ANY && port->nscan == scan_ops))
+			port->nscan = NULL;
+
+	list_for_each_entry(scan, &rio_scans, node)
+		if (scan->mport_id == mport_id) {
+			list_del(&scan->node);
+			kfree(scan);
 		}
-	}
+
 	mutex_unlock(&rio_mport_list_lock);
 
 	return 0;
 }
 EXPORT_SYMBOL_GPL(rio_unregister_scan);
 
+/**
+ * rio_mport_scan - execute enumeration/discovery on the specified mport
+ * @mport_id: number (ID) of mport device
+ */
+int rio_mport_scan(int mport_id)
+{
+	struct rio_mport *port = NULL;
+	int rc;
+
+	mutex_lock(&rio_mport_list_lock);
+	list_for_each_entry(port, &rio_mports, node) {
+		if (port->id == mport_id)
+			goto found;
+	}
+	mutex_unlock(&rio_mport_list_lock);
+	return -ENODEV;
+found:
+	if (!port->nscan) {
+		mutex_unlock(&rio_mport_list_lock);
+		return -EINVAL;
+	}
+
+	if (!try_module_get(port->nscan->owner)) {
+		mutex_unlock(&rio_mport_list_lock);
+		return -ENODEV;
+	}
+
+	mutex_unlock(&rio_mport_list_lock);
+
+	if (port->host_deviceid >= 0)
+		rc = port->nscan->enumerate(port, 0);
+	else
+		rc = port->nscan->discover(port, RIO_SCAN_ENUM_NO_WAIT);
+
+	module_put(port->nscan->owner);
+	return rc;
+}
+
 static void rio_fixup_device(struct rio_dev *dev)
 {
 }
@@ -1691,7 +1782,10 @@ static void disc_work_handler(struct wor
 	work = container_of(_work, struct rio_disc_work, work);
 	pr_debug("RIO: discovery work for mport %d %s\n",
 		 work->mport->id, work->mport->name);
-	work->mport->nscan->discover(work->mport, 0);
+	if (try_module_get(work->mport->nscan->owner)) {
+		work->mport->nscan->discover(work->mport, 0);
+		module_put(work->mport->nscan->owner);
+	}
 }
 
 int rio_init_mports(void)
@@ -1710,8 +1804,10 @@ int rio_init_mports(void)
 	mutex_lock(&rio_mport_list_lock);
 	list_for_each_entry(port, &rio_mports, node) {
 		if (port->host_deviceid >= 0) {
-			if (port->nscan)
+			if (port->nscan && try_module_get(port->nscan->owner)) {
 				port->nscan->enumerate(port, 0);
+				module_put(port->nscan->owner);
+			}
 		} else
 			n++;
 	}
@@ -1725,7 +1821,7 @@ int rio_init_mports(void)
 	 * for each of them. If the code below fails to allocate needed
 	 * resources, exit without error to keep results of enumeration
 	 * process (if any).
-	 * TODO: Implement restart of dicovery process for all or
+	 * TODO: Implement restart of discovery process for all or
 	 * individual discovering mports.
 	 */
 	rio_wq = alloc_workqueue("riodisc", 0, 0);
@@ -1751,9 +1847,9 @@ int rio_init_mports(void)
 			n++;
 		}
 	}
-	mutex_unlock(&rio_mport_list_lock);
 
 	flush_workqueue(rio_wq);
+	mutex_unlock(&rio_mport_list_lock);
 	pr_debug("RIO: destroy discovery workqueue\n");
 	destroy_workqueue(rio_wq);
 	kfree(work);
@@ -1784,6 +1880,8 @@ __setup("riohdid=", rio_hdid_setup);
 
 int rio_register_mport(struct rio_mport *port)
 {
+	struct rio_scan_node *scan = NULL;
+
 	if (next_portid >= RIO_MAX_MPORTS) {
 		pr_err("RIO: reached specified max number of mports\n");
 		return 1;
@@ -1792,9 +1890,25 @@ int rio_register_mport(struct rio_mport
 	port->id = next_portid++;
 	port->host_deviceid = rio_get_hdid(port->id);
 	port->nscan = NULL;
+
 	mutex_lock(&rio_mport_list_lock);
 	list_add_tail(&port->node, &rio_mports);
+
+	/*
+	 * Check if there are any registered enumeration/discovery operations
+	 * that have to be attached to the added mport.
+	 */
+	list_for_each_entry(scan, &rio_scans, node) {
+		if (port->id == scan->mport_id ||
+		    scan->mport_id == RIO_MPORT_ANY) {
+			port->nscan = scan->ops;
+			if (port->id == scan->mport_id)
+				break;
+		}
+	}
 	mutex_unlock(&rio_mport_list_lock);
+
+	pr_debug("RIO: %s %s id=%d\n", __func__, port->name, port->id);
 	return 0;
 }
 
diff -puN drivers/rapidio/rio.h~rapidio-update-enumerator-registration-mechanism drivers/rapidio/rio.h
--- a/drivers/rapidio/rio.h~rapidio-update-enumerator-registration-mechanism
+++ a/drivers/rapidio/rio.h
@@ -42,9 +42,10 @@ extern int rio_add_device(struct rio_dev
 extern int rio_enable_rx_tx_port(struct rio_mport *port, int local, u16 destid,
 				 u8 hopcount, u8 port_num);
 extern int rio_register_scan(int mport_id, struct rio_scan *scan_ops);
-extern int rio_unregister_scan(int mport_id);
+extern int rio_unregister_scan(int mport_id, struct rio_scan *scan_ops);
 extern void rio_attach_device(struct rio_dev *rdev);
 extern struct rio_mport *rio_find_mport(int mport_id);
+extern int rio_mport_scan(int mport_id);
 
 /* Structures internal to the RIO core code */
 extern struct device_attribute rio_dev_attrs[];
diff -puN include/linux/rio.h~rapidio-update-enumerator-registration-mechanism include/linux/rio.h
--- a/include/linux/rio.h~rapidio-update-enumerator-registration-mechanism
+++ a/include/linux/rio.h
@@ -465,14 +465,29 @@ static inline struct rio_mport *dma_to_m
 
 /**
  * struct rio_scan - RIO enumeration and discovery operations
+ * @owner: The module owner of this structure
  * @enumerate: Callback to perform RapidIO fabric enumeration.
  * @discover: Callback to perform RapidIO fabric discovery.
  */
 struct rio_scan {
+	struct module *owner;
 	int (*enumerate)(struct rio_mport *mport, u32 flags);
 	int (*discover)(struct rio_mport *mport, u32 flags);
 };
 
+/**
+ * struct rio_scan_node - list node to register RapidIO enumeration and
+ * discovery methods with RapidIO core.
+ * @mport_id: ID of an mport (net) serviced by this enumerator
+ * @node: node in global list of registered enumerators
+ * @ops: RIO enumeration and discovery operations
+ */
+struct rio_scan_node {
+	int mport_id;
+	struct list_head node;
+	struct rio_scan *ops;
+};
+
 /* Architecture and hardware-specific functions */
 extern int rio_register_mport(struct rio_mport *);
 extern int rio_open_inb_mbox(struct rio_mport *, void *, int, int);
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

origin.patch
linux-next.patch

