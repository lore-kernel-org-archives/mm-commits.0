From: akpm@linux-foundation.org
Subject: [merged]
 rapidio-add-enumeration-discovery-start-from-user-space.patch removed from
 -mm tree
Date: Tue, 28 May 2013 12:36:35 -0700
Message-ID: <51a50743.rMt8CeaOHpNWAJNl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60370 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754929Ab3E1Tgg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 May 2013 15:36:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mporter@kernel.crashing.org, micha.nelissen@Prodrive.nl, leoli@freescale.com, galak@kernel.crashing.org, andre.van.herk@Prodrive.nl, alexandre.bounine@idt.com

Subject: [merged] rapidio-add-enumeration-discovery-start-from-user-space.patch removed from -mm tree
To: alexandre.bounine@idt.com,andre.van.herk@Prodrive.nl,galak@kernel.crashing.org,leoli@freescale.com,micha.nelissen@Prodrive.nl,mporter@kernel.crashing.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 May 2013 12:36:35 -0700


The patch titled
     Subject: rapidio: add enumeration/discovery start from user space
has been removed from the -mm tree.  Its filename was
     rapidio-add-enumeration-discovery-start-from-user-space.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio: add enumeration/discovery start from user space

Add RapidIO enumeration/discovery start from user space.  User space start
allows to defer RapidIO fabric scan until the moment when all
participating endpoints are initialized avoiding mandatory synchronized
start of all endpoints (which may be challenging in systems with large
number of RapidIO endpoints).

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Andre van Herk <andre.van.herk@Prodrive.nl>
Cc: Micha Nelissen <micha.nelissen@Prodrive.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio-driver.c |    1 
 drivers/rapidio/rio-scan.c   |   24 +++++++++++++++--
 drivers/rapidio/rio-sysfs.c  |   45 +++++++++++++++++++++++++++++++++
 drivers/rapidio/rio.c        |   28 +++++++++++++++++++-
 drivers/rapidio/rio.h        |    2 +
 include/linux/rio.h          |    9 +++++-
 6 files changed, 102 insertions(+), 7 deletions(-)

diff -puN drivers/rapidio/rio-driver.c~rapidio-add-enumeration-discovery-start-from-user-space drivers/rapidio/rio-driver.c
--- a/drivers/rapidio/rio-driver.c~rapidio-add-enumeration-discovery-start-from-user-space
+++ a/drivers/rapidio/rio-driver.c
@@ -207,6 +207,7 @@ struct bus_type rio_bus_type = {
 	.name = "rapidio",
 	.match = rio_match_bus,
 	.dev_attrs = rio_dev_attrs,
+	.bus_attrs = rio_bus_attrs,
 	.probe = rio_device_probe,
 	.remove = rio_device_remove,
 };
diff -puN drivers/rapidio/rio-scan.c~rapidio-add-enumeration-discovery-start-from-user-space drivers/rapidio/rio-scan.c
--- a/drivers/rapidio/rio-scan.c~rapidio-add-enumeration-discovery-start-from-user-space
+++ a/drivers/rapidio/rio-scan.c
@@ -1134,19 +1134,30 @@ static void rio_pw_enable(struct rio_mpo
 /**
  * rio_enum_mport- Start enumeration through a master port
  * @mport: Master port to send transactions
+ * @flags: Enumeration control flags
  *
  * Starts the enumeration process. If somebody has enumerated our
  * master port device, then give up. If not and we have an active
  * link, then start recursive peer enumeration. Returns %0 if
  * enumeration succeeds or %-EBUSY if enumeration fails.
  */
-int rio_enum_mport(struct rio_mport *mport)
+int rio_enum_mport(struct rio_mport *mport, u32 flags)
 {
 	struct rio_net *net = NULL;
 	int rc = 0;
 
 	printk(KERN_INFO "RIO: enumerate master port %d, %s\n", mport->id,
 	       mport->name);
+
+	/*
+	 * To avoid multiple start requests (repeat enumeration is not supported
+	 * by this method) check if enumeration/discovery was performed for this
+	 * mport: if mport was added into the list of mports for a net exit
+	 * with error.
+	 */
+	if (mport->nnode.next || mport->nnode.prev)
+		return -EBUSY;
+
 	/* If somebody else enumerated our master port device, bail. */
 	if (rio_enum_host(mport) < 0) {
 		printk(KERN_INFO
@@ -1236,14 +1247,16 @@ static void rio_build_route_tables(struc
 /**
  * rio_disc_mport- Start discovery through a master port
  * @mport: Master port to send transactions
+ * @flags: discovery control flags
  *
  * Starts the discovery process. If we have an active link,
- * then wait for the signal that enumeration is complete.
+ * then wait for the signal that enumeration is complete (if wait
+ * is allowed).
  * When enumeration completion is signaled, start recursive
  * peer discovery. Returns %0 if discovery succeeds or %-EBUSY
  * on failure.
  */
-int rio_disc_mport(struct rio_mport *mport)
+int rio_disc_mport(struct rio_mport *mport, u32 flags)
 {
 	struct rio_net *net = NULL;
 	unsigned long to_end;
@@ -1253,6 +1266,11 @@ int rio_disc_mport(struct rio_mport *mpo
 
 	/* If master port has an active link, allocate net and discover peers */
 	if (rio_mport_is_active(mport)) {
+		if (rio_enum_complete(mport))
+			goto enum_done;
+		else if (flags & RIO_SCAN_ENUM_NO_WAIT)
+			return -EAGAIN;
+
 		pr_debug("RIO: wait for enumeration to complete...\n");
 
 		to_end = jiffies + CONFIG_RAPIDIO_DISC_TIMEOUT * HZ;
diff -puN drivers/rapidio/rio-sysfs.c~rapidio-add-enumeration-discovery-start-from-user-space drivers/rapidio/rio-sysfs.c
--- a/drivers/rapidio/rio-sysfs.c~rapidio-add-enumeration-discovery-start-from-user-space
+++ a/drivers/rapidio/rio-sysfs.c
@@ -285,3 +285,48 @@ void rio_remove_sysfs_dev_files(struct r
 			rdev->rswitch->sw_sysfs(rdev, RIO_SW_SYSFS_REMOVE);
 	}
 }
+
+static ssize_t bus_scan_store(struct bus_type *bus, const char *buf,
+				size_t count)
+{
+	long val;
+	struct rio_mport *port = NULL;
+	int rc;
+
+	if (kstrtol(buf, 0, &val) < 0)
+		return -EINVAL;
+
+	if (val == RIO_MPORT_ANY) {
+		rc = rio_init_mports();
+		goto exit;
+	}
+
+	if (val < 0 || val >= RIO_MAX_MPORTS)
+		return -EINVAL;
+
+	port = rio_find_mport((int)val);
+
+	if (!port) {
+		pr_debug("RIO: %s: mport_%d not available\n",
+			 __func__, (int)val);
+		return -EINVAL;
+	}
+
+	if (!port->nscan)
+		return -EINVAL;
+
+	if (port->host_deviceid >= 0)
+		rc = port->nscan->enumerate(port, 0);
+	else
+		rc = port->nscan->discover(port, RIO_SCAN_ENUM_NO_WAIT);
+exit:
+	if (!rc)
+		rc = count;
+
+	return rc;
+}
+
+struct bus_attribute rio_bus_attrs[] = {
+	__ATTR(scan, (S_IWUSR|S_IWGRP), NULL, bus_scan_store),
+	__ATTR_NULL
+};
diff -puN drivers/rapidio/rio.c~rapidio-add-enumeration-discovery-start-from-user-space drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-add-enumeration-discovery-start-from-user-space
+++ a/drivers/rapidio/rio.c
@@ -1383,6 +1383,30 @@ EXPORT_SYMBOL_GPL(rio_dma_prep_slave_sg)
 #endif /* CONFIG_RAPIDIO_DMA_ENGINE */
 
 /**
+ * rio_find_mport - find RIO mport by its ID
+ * @mport_id: number (ID) of mport device
+ *
+ * Given a RIO mport number, the desired mport is located
+ * in the global list of mports. If the mport is found, a pointer to its
+ * data structure is returned.  If no mport is found, %NULL is returned.
+ */
+struct rio_mport *rio_find_mport(int mport_id)
+{
+	struct rio_mport *port;
+
+	mutex_lock(&rio_mport_list_lock);
+	list_for_each_entry(port, &rio_mports, node) {
+		if (port->id == mport_id)
+			goto found;
+	}
+	port = NULL;
+found:
+	mutex_unlock(&rio_mport_list_lock);
+
+	return port;
+}
+
+/**
  * rio_register_scan - enumeration/discovery method registration interface
  * @mport_id: mport device ID for which fabric scan routine has to be set
  *            (RIO_MPORT_ANY = set for all available mports)
@@ -1475,7 +1499,7 @@ static void disc_work_handler(struct wor
 	work = container_of(_work, struct rio_disc_work, work);
 	pr_debug("RIO: discovery work for mport %d %s\n",
 		 work->mport->id, work->mport->name);
-	work->mport->nscan->discover(work->mport);
+	work->mport->nscan->discover(work->mport, 0);
 }
 
 int rio_init_mports(void)
@@ -1495,7 +1519,7 @@ int rio_init_mports(void)
 	list_for_each_entry(port, &rio_mports, node) {
 		if (port->host_deviceid >= 0) {
 			if (port->nscan)
-				port->nscan->enumerate(port);
+				port->nscan->enumerate(port, 0);
 		} else
 			n++;
 	}
diff -puN drivers/rapidio/rio.h~rapidio-add-enumeration-discovery-start-from-user-space drivers/rapidio/rio.h
--- a/drivers/rapidio/rio.h~rapidio-add-enumeration-discovery-start-from-user-space
+++ a/drivers/rapidio/rio.h
@@ -45,9 +45,11 @@ extern int rio_enable_rx_tx_port(struct
 extern int rio_register_scan(int mport_id, struct rio_scan *scan_ops);
 extern int rio_unregister_scan(int mport_id);
 extern void rio_attach_device(struct rio_dev *rdev);
+extern struct rio_mport *rio_find_mport(int mport_id);
 
 /* Structures internal to the RIO core code */
 extern struct device_attribute rio_dev_attrs[];
+extern struct bus_attribute rio_bus_attrs[];
 
 extern struct rio_switch_ops __start_rio_switch_ops[];
 extern struct rio_switch_ops __end_rio_switch_ops[];
diff -puN include/linux/rio.h~rapidio-add-enumeration-discovery-start-from-user-space include/linux/rio.h
--- a/include/linux/rio.h~rapidio-add-enumeration-discovery-start-from-user-space
+++ a/include/linux/rio.h
@@ -265,6 +265,11 @@ struct rio_mport {
 	struct rio_scan *nscan;
 };
 
+/*
+ * Enumeration/discovery control flags
+ */
+#define RIO_SCAN_ENUM_NO_WAIT	0x00000001 /* Do not wait for enum completed */
+
 struct rio_id_table {
 	u16 start;	/* logical minimal id */
 	u32 max;	/* max number of IDs in table */
@@ -467,8 +472,8 @@ static inline struct rio_mport *dma_to_m
  * @discover: Callback to perform RapidIO fabric discovery.
  */
 struct rio_scan {
-	int (*enumerate)(struct rio_mport *mport);
-	int (*discover)(struct rio_mport *mport);
+	int (*enumerate)(struct rio_mport *mport, u32 flags);
+	int (*discover)(struct rio_mport *mport, u32 flags);
 };
 
 /* Architecture and hardware-specific functions */
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

rapidio-switches-remove-tsi500-driver.patch

