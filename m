From: akpm@linux-foundation.org
Subject: + rapidio-convert-switch-drivers-to-modules.patch added to -mm
 tree
Date: Fri, 28 Jun 2013 14:19:33 -0700
Message-ID: <51cdfde5.dGFW/0jAULE7yO1l%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51727 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab3F1VTe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Jun 2013 17:19:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stef.van.os@Prodrive.nl, mporter@kernel.crashing.org, micha.nelissen@Prodrive.nl, leoli@freescale.com, jdelvare@suse.de, galak@kernel.crashing.org, andre.van.herk@Prodrive.nl, alexandre.bounine@idt.com

Subject: + rapidio-convert-switch-drivers-to-modules.patch added to -mm tree
To: alexandre.bounine@idt.com,andre.van.herk@Prodrive.nl,galak@kernel.crashing.org,jdelvare@suse.de,leoli@freescale.com,micha.nelissen@Prodrive.nl,mporter@kernel.crashing.org,stef.van.os@Prodrive.nl
From: akpm@linux-foundation.org
Date: Fri, 28 Jun 2013 14:19:33 -0700


The patch titled
     Subject: rapidio: convert switch drivers to modules
has been added to the -mm tree.  Its filename is
     rapidio-convert-switch-drivers-to-modules.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio: convert switch drivers to modules

Rework RapidIO switch drivers to add an option to build them as loadable
kernel modules.

This patch removes RapidIO-specific vmlinux section and converts switch
drivers to be compatible with LDM driver registration method.  To simplify
registration of device-specific callback routines this patch introduces
rio_switch_ops data structure.  The sw_sysfs() callback is removed from
the list of device-specific operations because under the new structure its
functions can be handled by switch driver's probe() and remove() routines.

If a specific switch device driver is not loaded the RapidIO subsystem
core will use default standard-based operations to configure a switch. 
Because the current implementation of RapidIO enumeration/discovery method
relies on availability of device-specific operations for error management,
switch device drivers must be loaded before the RapidIO
enumeration/discovery starts.

This patch also moves several common routines from enumeration/discovery
module into the RapidIO core code to make switch-specific operations
accessible to all components of RapidIO subsystem.

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

 drivers/rapidio/Kconfig             |    5 
 drivers/rapidio/rio-scan.c          |  171 ---------------
 drivers/rapidio/rio-sysfs.c         |    4 
 drivers/rapidio/rio.c               |  286 +++++++++++++++++++++-----
 drivers/rapidio/rio.h               |   41 ---
 drivers/rapidio/switches/Kconfig    |   12 -
 drivers/rapidio/switches/idt_gen2.c |   96 +++++++-
 drivers/rapidio/switches/idtcps.c   |   84 ++++++-
 drivers/rapidio/switches/tsi568.c   |   71 +++++-
 drivers/rapidio/switches/tsi57x.c   |   79 ++++++-
 include/asm-generic/vmlinux.lds.h   |    7 
 include/linux/rio.h                 |   51 ++--
 12 files changed, 565 insertions(+), 342 deletions(-)

diff -puN drivers/rapidio/Kconfig~rapidio-convert-switch-drivers-to-modules drivers/rapidio/Kconfig
--- a/drivers/rapidio/Kconfig~rapidio-convert-switch-drivers-to-modules
+++ a/drivers/rapidio/Kconfig
@@ -67,4 +67,9 @@ config RAPIDIO_ENUM_BASIC
 
 endchoice
 
+menu "RapidIO Switch drivers"
+	depends on RAPIDIO
+
 source "drivers/rapidio/switches/Kconfig"
+
+endmenu
diff -puN drivers/rapidio/rio-scan.c~rapidio-convert-switch-drivers-to-modules drivers/rapidio/rio-scan.c
--- a/drivers/rapidio/rio-scan.c~rapidio-convert-switch-drivers-to-modules
+++ a/drivers/rapidio/rio-scan.c
@@ -406,6 +406,7 @@ static struct rio_dev *rio_setup_device(
 		rio_mport_write_config_32(port, destid, hopcount,
 					  RIO_COMPONENT_TAG_CSR, next_comptag);
 		rdev->comp_tag = next_comptag++;
+		rdev->do_enum = true;
 	}  else {
 		rio_mport_read_config_32(port, destid, hopcount,
 					 RIO_COMPONENT_TAG_CSR,
@@ -434,6 +435,7 @@ static struct rio_dev *rio_setup_device(
 		rswitch = rdev->rswitch;
 		rswitch->switchid = rdev->comp_tag & RIO_CTAG_UDEVID;
 		rswitch->port_ok = 0;
+		spin_lock_init(&rswitch->lock);
 		rswitch->route_table = kzalloc(sizeof(u8)*
 					RIO_MAX_ROUTE_ENTRIES(port->sys_size),
 					GFP_KERNEL);
@@ -445,11 +447,9 @@ static struct rio_dev *rio_setup_device(
 			rswitch->route_table[rdid] = RIO_INVALID_ROUTE;
 		dev_set_name(&rdev->dev, "%02x:s:%04x", rdev->net->id,
 			     rswitch->switchid);
-		rio_switch_init(rdev, do_enum);
 
-		if (do_enum && rswitch->clr_table)
-			rswitch->clr_table(port, destid, hopcount,
-					   RIO_GLOBAL_TABLE);
+		if (do_enum)
+			rio_route_clr_table(rdev, RIO_GLOBAL_TABLE, 0);
 
 		list_add_tail(&rswitch->node, &net->switches);
 
@@ -533,156 +533,6 @@ rio_sport_is_active(struct rio_mport *po
 }
 
 /**
- * rio_lock_device - Acquires host device lock for specified device
- * @port: Master port to send transaction
- * @destid: Destination ID for device/switch
- * @hopcount: Hopcount to reach switch
- * @wait_ms: Max wait time in msec (0 = no timeout)
- *
- * Attepts to acquire host device lock for specified device
- * Returns 0 if device lock acquired or EINVAL if timeout expires.
- */
-static int
-rio_lock_device(struct rio_mport *port, u16 destid, u8 hopcount, int wait_ms)
-{
-	u32 result;
-	int tcnt = 0;
-
-	/* Attempt to acquire device lock */
-	rio_mport_write_config_32(port, destid, hopcount,
-				  RIO_HOST_DID_LOCK_CSR, port->host_deviceid);
-	rio_mport_read_config_32(port, destid, hopcount,
-				 RIO_HOST_DID_LOCK_CSR, &result);
-
-	while (result != port->host_deviceid) {
-		if (wait_ms != 0 && tcnt == wait_ms) {
-			pr_debug("RIO: timeout when locking device %x:%x\n",
-				destid, hopcount);
-			return -EINVAL;
-		}
-
-		/* Delay a bit */
-		mdelay(1);
-		tcnt++;
-		/* Try to acquire device lock again */
-		rio_mport_write_config_32(port, destid,
-			hopcount,
-			RIO_HOST_DID_LOCK_CSR,
-			port->host_deviceid);
-		rio_mport_read_config_32(port, destid,
-			hopcount,
-			RIO_HOST_DID_LOCK_CSR, &result);
-	}
-
-	return 0;
-}
-
-/**
- * rio_unlock_device - Releases host device lock for specified device
- * @port: Master port to send transaction
- * @destid: Destination ID for device/switch
- * @hopcount: Hopcount to reach switch
- *
- * Returns 0 if device lock released or EINVAL if fails.
- */
-static int
-rio_unlock_device(struct rio_mport *port, u16 destid, u8 hopcount)
-{
-	u32 result;
-
-	/* Release device lock */
-	rio_mport_write_config_32(port, destid,
-				  hopcount,
-				  RIO_HOST_DID_LOCK_CSR,
-				  port->host_deviceid);
-	rio_mport_read_config_32(port, destid, hopcount,
-		RIO_HOST_DID_LOCK_CSR, &result);
-	if ((result & 0xffff) != 0xffff) {
-		pr_debug("RIO: badness when releasing device lock %x:%x\n",
-			 destid, hopcount);
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-/**
- * rio_route_add_entry- Add a route entry to a switch routing table
- * @rdev: RIO device
- * @table: Routing table ID
- * @route_destid: Destination ID to be routed
- * @route_port: Port number to be routed
- * @lock: lock switch device flag
- *
- * Calls the switch specific add_entry() method to add a route entry
- * on a switch. The route table can be specified using the @table
- * argument if a switch has per port routing tables or the normal
- * use is to specific all tables (or the global table) by passing
- * %RIO_GLOBAL_TABLE in @table. Returns %0 on success or %-EINVAL
- * on failure.
- */
-static int
-rio_route_add_entry(struct rio_dev *rdev,
-		    u16 table, u16 route_destid, u8 route_port, int lock)
-{
-	int rc;
-
-	if (lock) {
-		rc = rio_lock_device(rdev->net->hport, rdev->destid,
-				     rdev->hopcount, 1000);
-		if (rc)
-			return rc;
-	}
-
-	rc = rdev->rswitch->add_entry(rdev->net->hport, rdev->destid,
-				      rdev->hopcount, table,
-				      route_destid, route_port);
-	if (lock)
-		rio_unlock_device(rdev->net->hport, rdev->destid,
-				  rdev->hopcount);
-
-	return rc;
-}
-
-/**
- * rio_route_get_entry- Read a route entry in a switch routing table
- * @rdev: RIO device
- * @table: Routing table ID
- * @route_destid: Destination ID to be routed
- * @route_port: Pointer to read port number into
- * @lock: lock switch device flag
- *
- * Calls the switch specific get_entry() method to read a route entry
- * in a switch. The route table can be specified using the @table
- * argument if a switch has per port routing tables or the normal
- * use is to specific all tables (or the global table) by passing
- * %RIO_GLOBAL_TABLE in @table. Returns %0 on success or %-EINVAL
- * on failure.
- */
-static int
-rio_route_get_entry(struct rio_dev *rdev, u16 table,
-		    u16 route_destid, u8 *route_port, int lock)
-{
-	int rc;
-
-	if (lock) {
-		rc = rio_lock_device(rdev->net->hport, rdev->destid,
-				     rdev->hopcount, 1000);
-		if (rc)
-			return rc;
-	}
-
-	rc = rdev->rswitch->get_entry(rdev->net->hport, rdev->destid,
-				      rdev->hopcount, table,
-				      route_destid, route_port);
-	if (lock)
-		rio_unlock_device(rdev->net->hport, rdev->destid,
-				  rdev->hopcount);
-
-	return rc;
-}
-
-/**
  * rio_get_host_deviceid_lock- Reads the Host Device ID Lock CSR on a device
  * @port: Master port to send transaction
  * @hopcount: Number of hops to the device
@@ -1094,12 +944,9 @@ static void rio_update_route_tables(stru
 
 				sport = RIO_GET_PORT_NUM(swrdev->swpinfo);
 
-				if (rswitch->add_entry)	{
-					rio_route_add_entry(swrdev,
-						RIO_GLOBAL_TABLE, destid,
-						sport, 0);
-					rswitch->route_table[destid] = sport;
-				}
+				rio_route_add_entry(swrdev, RIO_GLOBAL_TABLE,
+						    destid, sport, 0);
+				rswitch->route_table[destid] = sport;
 			}
 		}
 	}
@@ -1115,8 +962,8 @@ static void rio_update_route_tables(stru
 static void rio_init_em(struct rio_dev *rdev)
 {
 	if (rio_is_switch(rdev) && (rdev->em_efptr) &&
-	    (rdev->rswitch->em_init)) {
-		rdev->rswitch->em_init(rdev);
+	    rdev->rswitch->ops && rdev->rswitch->ops->em_init) {
+		rdev->rswitch->ops->em_init(rdev);
 	}
 }
 
diff -puN drivers/rapidio/rio-sysfs.c~rapidio-convert-switch-drivers-to-modules drivers/rapidio/rio-sysfs.c
--- a/drivers/rapidio/rio-sysfs.c~rapidio-convert-switch-drivers-to-modules
+++ a/drivers/rapidio/rio-sysfs.c
@@ -257,8 +257,6 @@ int rio_create_sysfs_dev_files(struct ri
 		err |= device_create_file(&rdev->dev, &dev_attr_routes);
 		err |= device_create_file(&rdev->dev, &dev_attr_lnext);
 		err |= device_create_file(&rdev->dev, &dev_attr_hopcount);
-		if (!err && rdev->rswitch->sw_sysfs)
-			err = rdev->rswitch->sw_sysfs(rdev, RIO_SW_SYSFS_CREATE);
 	}
 
 	if (err)
@@ -281,8 +279,6 @@ void rio_remove_sysfs_dev_files(struct r
 		device_remove_file(&rdev->dev, &dev_attr_routes);
 		device_remove_file(&rdev->dev, &dev_attr_lnext);
 		device_remove_file(&rdev->dev, &dev_attr_hopcount);
-		if (rdev->rswitch->sw_sysfs)
-			rdev->rswitch->sw_sysfs(rdev, RIO_SW_SYSFS_REMOVE);
 	}
 }
 
diff -puN drivers/rapidio/rio.c~rapidio-convert-switch-drivers-to-modules drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-convert-switch-drivers-to-modules
+++ a/drivers/rapidio/rio.c
@@ -7,7 +7,6 @@
  *
  * Copyright 2009 Integrated Device Technology, Inc.
  * Alex Bounine <alexandre.bounine@idt.com>
- * - Added Port-Write/Error Management initialization and handling
  *
  * This program is free software; you can redistribute  it and/or modify it
  * under  the terms of  the GNU General  Public License as published by the
@@ -580,44 +579,6 @@ int rio_set_port_lockout(struct rio_dev
 EXPORT_SYMBOL_GPL(rio_set_port_lockout);
 
 /**
- * rio_switch_init - Sets switch operations for a particular vendor switch
- * @rdev: RIO device
- * @do_enum: Enumeration/Discovery mode flag
- *
- * Searches the RIO switch ops table for known switch types. If the vid
- * and did match a switch table entry, then call switch initialization
- * routine to setup switch-specific routines.
- */
-void rio_switch_init(struct rio_dev *rdev, int do_enum)
-{
-	struct rio_switch_ops *cur = __start_rio_switch_ops;
-	struct rio_switch_ops *end = __end_rio_switch_ops;
-
-	while (cur < end) {
-		if ((cur->vid == rdev->vid) && (cur->did == rdev->did)) {
-			pr_debug("RIO: calling init routine for %s\n",
-				 rio_name(rdev));
-			cur->init_hook(rdev, do_enum);
-			break;
-		}
-		cur++;
-	}
-
-	if ((cur >= end) && (rdev->pef & RIO_PEF_STD_RT)) {
-		pr_debug("RIO: adding STD routing ops for %s\n",
-			rio_name(rdev));
-		rdev->rswitch->add_entry = rio_std_route_add_entry;
-		rdev->rswitch->get_entry = rio_std_route_get_entry;
-		rdev->rswitch->clr_table = rio_std_route_clr_table;
-	}
-
-	if (!rdev->rswitch->add_entry || !rdev->rswitch->get_entry)
-		printk(KERN_ERR "RIO: missing routing ops for %s\n",
-		       rio_name(rdev));
-}
-EXPORT_SYMBOL_GPL(rio_switch_init);
-
-/**
  * rio_enable_rx_tx_port - enable input receiver and output transmitter of
  * given port
  * @port: Master port associated with the RIO network
@@ -970,8 +931,8 @@ int rio_inb_pwrite_handler(union rio_pw_
 	/*
 	 * Process the port-write notification from switch
 	 */
-	if (rdev->rswitch->em_handle)
-		rdev->rswitch->em_handle(rdev, portnum);
+	if (rdev->rswitch->ops && rdev->rswitch->ops->em_handle)
+		rdev->rswitch->ops->em_handle(rdev, portnum);
 
 	rio_read_config_32(rdev,
 			rdev->phys_efptr + RIO_PORT_N_ERR_STS_CSR(portnum),
@@ -1207,8 +1168,9 @@ struct rio_dev *rio_get_device(u16 vid,
  * @route_destid: destID entry in the RT
  * @route_port: destination port for specified destID
  */
-int rio_std_route_add_entry(struct rio_mport *mport, u16 destid, u8 hopcount,
-		       u16 table, u16 route_destid, u8 route_port)
+static int
+rio_std_route_add_entry(struct rio_mport *mport, u16 destid, u8 hopcount,
+			u16 table, u16 route_destid, u8 route_port)
 {
 	if (table == RIO_GLOBAL_TABLE) {
 		rio_mport_write_config_32(mport, destid, hopcount,
@@ -1234,8 +1196,9 @@ int rio_std_route_add_entry(struct rio_m
  * @route_destid: destID entry in the RT
  * @route_port: returned destination port for specified destID
  */
-int rio_std_route_get_entry(struct rio_mport *mport, u16 destid, u8 hopcount,
-		       u16 table, u16 route_destid, u8 *route_port)
+static int
+rio_std_route_get_entry(struct rio_mport *mport, u16 destid, u8 hopcount,
+			u16 table, u16 route_destid, u8 *route_port)
 {
 	u32 result;
 
@@ -1259,8 +1222,9 @@ int rio_std_route_get_entry(struct rio_m
  * @hopcount: Number of switch hops to the device
  * @table: routing table ID (global or port-specific)
  */
-int rio_std_route_clr_table(struct rio_mport *mport, u16 destid, u8 hopcount,
-		       u16 table)
+static int
+rio_std_route_clr_table(struct rio_mport *mport, u16 destid, u8 hopcount,
+			u16 table)
 {
 	u32 max_destid = 0xff;
 	u32 i, pef, id_inc = 1, ext_cfg = 0;
@@ -1301,6 +1265,234 @@ int rio_std_route_clr_table(struct rio_m
 	return 0;
 }
 
+/**
+ * rio_lock_device - Acquires host device lock for specified device
+ * @port: Master port to send transaction
+ * @destid: Destination ID for device/switch
+ * @hopcount: Hopcount to reach switch
+ * @wait_ms: Max wait time in msec (0 = no timeout)
+ *
+ * Attepts to acquire host device lock for specified device
+ * Returns 0 if device lock acquired or EINVAL if timeout expires.
+ */
+int rio_lock_device(struct rio_mport *port, u16 destid,
+		    u8 hopcount, int wait_ms)
+{
+	u32 result;
+	int tcnt = 0;
+
+	/* Attempt to acquire device lock */
+	rio_mport_write_config_32(port, destid, hopcount,
+				  RIO_HOST_DID_LOCK_CSR, port->host_deviceid);
+	rio_mport_read_config_32(port, destid, hopcount,
+				 RIO_HOST_DID_LOCK_CSR, &result);
+
+	while (result != port->host_deviceid) {
+		if (wait_ms != 0 && tcnt == wait_ms) {
+			pr_debug("RIO: timeout when locking device %x:%x\n",
+				destid, hopcount);
+			return -EINVAL;
+		}
+
+		/* Delay a bit */
+		mdelay(1);
+		tcnt++;
+		/* Try to acquire device lock again */
+		rio_mport_write_config_32(port, destid,
+			hopcount,
+			RIO_HOST_DID_LOCK_CSR,
+			port->host_deviceid);
+		rio_mport_read_config_32(port, destid,
+			hopcount,
+			RIO_HOST_DID_LOCK_CSR, &result);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rio_lock_device);
+
+/**
+ * rio_unlock_device - Releases host device lock for specified device
+ * @port: Master port to send transaction
+ * @destid: Destination ID for device/switch
+ * @hopcount: Hopcount to reach switch
+ *
+ * Returns 0 if device lock released or EINVAL if fails.
+ */
+int rio_unlock_device(struct rio_mport *port, u16 destid, u8 hopcount)
+{
+	u32 result;
+
+	/* Release device lock */
+	rio_mport_write_config_32(port, destid,
+				  hopcount,
+				  RIO_HOST_DID_LOCK_CSR,
+				  port->host_deviceid);
+	rio_mport_read_config_32(port, destid, hopcount,
+		RIO_HOST_DID_LOCK_CSR, &result);
+	if ((result & 0xffff) != 0xffff) {
+		pr_debug("RIO: badness when releasing device lock %x:%x\n",
+			 destid, hopcount);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rio_unlock_device);
+
+/**
+ * rio_route_add_entry- Add a route entry to a switch routing table
+ * @rdev: RIO device
+ * @table: Routing table ID
+ * @route_destid: Destination ID to be routed
+ * @route_port: Port number to be routed
+ * @lock: apply a hardware lock on switch device flag (1=lock, 0=no_lock)
+ *
+ * If available calls the switch specific add_entry() method to add a route
+ * entry into a switch routing table. Otherwise uses standard RT update method
+ * as defined by RapidIO specification. A specific routing table can be selected
+ * using the @table argument if a switch has per port routing tables or
+ * the standard (or global) table may be used by passing
+ * %RIO_GLOBAL_TABLE in @table.
+ *
+ * Returns %0 on success or %-EINVAL on failure.
+ */
+int rio_route_add_entry(struct rio_dev *rdev,
+			u16 table, u16 route_destid, u8 route_port, int lock)
+{
+	int rc = -EINVAL;
+	struct rio_switch_ops *ops = rdev->rswitch->ops;
+
+	if (lock) {
+		rc = rio_lock_device(rdev->net->hport, rdev->destid,
+				     rdev->hopcount, 1000);
+		if (rc)
+			return rc;
+	}
+
+	spin_lock(&rdev->rswitch->lock);
+
+	if (ops == NULL || ops->add_entry == NULL) {
+		rc = rio_std_route_add_entry(rdev->net->hport, rdev->destid,
+					     rdev->hopcount, table,
+					     route_destid, route_port);
+	} else if (try_module_get(ops->owner)) {
+		rc = ops->add_entry(rdev->net->hport, rdev->destid,
+				    rdev->hopcount, table, route_destid,
+				    route_port);
+		module_put(ops->owner);
+	}
+
+	spin_unlock(&rdev->rswitch->lock);
+
+	if (lock)
+		rio_unlock_device(rdev->net->hport, rdev->destid,
+				  rdev->hopcount);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(rio_route_add_entry);
+
+/**
+ * rio_route_get_entry- Read an entry from a switch routing table
+ * @rdev: RIO device
+ * @table: Routing table ID
+ * @route_destid: Destination ID to be routed
+ * @route_port: Pointer to read port number into
+ * @lock: apply a hardware lock on switch device flag (1=lock, 0=no_lock)
+ *
+ * If available calls the switch specific get_entry() method to fetch a route
+ * entry from a switch routing table. Otherwise uses standard RT read method
+ * as defined by RapidIO specification. A specific routing table can be selected
+ * using the @table argument if a switch has per port routing tables or
+ * the standard (or global) table may be used by passing
+ * %RIO_GLOBAL_TABLE in @table.
+ *
+ * Returns %0 on success or %-EINVAL on failure.
+ */
+int rio_route_get_entry(struct rio_dev *rdev, u16 table,
+			u16 route_destid, u8 *route_port, int lock)
+{
+	int rc = -EINVAL;
+	struct rio_switch_ops *ops = rdev->rswitch->ops;
+
+	if (lock) {
+		rc = rio_lock_device(rdev->net->hport, rdev->destid,
+				     rdev->hopcount, 1000);
+		if (rc)
+			return rc;
+	}
+
+	spin_lock(&rdev->rswitch->lock);
+
+	if (ops == NULL || ops->get_entry == NULL) {
+		rc = rio_std_route_get_entry(rdev->net->hport, rdev->destid,
+					     rdev->hopcount, table,
+					     route_destid, route_port);
+	} else if (try_module_get(ops->owner)) {
+		rc = ops->get_entry(rdev->net->hport, rdev->destid,
+				    rdev->hopcount, table, route_destid,
+				    route_port);
+		module_put(ops->owner);
+	}
+
+	spin_unlock(&rdev->rswitch->lock);
+
+	if (lock)
+		rio_unlock_device(rdev->net->hport, rdev->destid,
+				  rdev->hopcount);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(rio_route_get_entry);
+
+/**
+ * rio_route_clr_table - Clear a switch routing table
+ * @rdev: RIO device
+ * @table: Routing table ID
+ * @lock: apply a hardware lock on switch device flag (1=lock, 0=no_lock)
+ *
+ * If available calls the switch specific clr_table() method to clear a switch
+ * routing table. Otherwise uses standard RT write method as defined by RapidIO
+ * specification. A specific routing table can be selected using the @table
+ * argument if a switch has per port routing tables or the standard (or global)
+ * table may be used by passing %RIO_GLOBAL_TABLE in @table.
+ *
+ * Returns %0 on success or %-EINVAL on failure.
+ */
+int rio_route_clr_table(struct rio_dev *rdev, u16 table, int lock)
+{
+	int rc = -EINVAL;
+	struct rio_switch_ops *ops = rdev->rswitch->ops;
+
+	if (lock) {
+		rc = rio_lock_device(rdev->net->hport, rdev->destid,
+				     rdev->hopcount, 1000);
+		if (rc)
+			return rc;
+	}
+
+	spin_lock(&rdev->rswitch->lock);
+
+	if (ops == NULL || ops->clr_table == NULL) {
+		rc = rio_std_route_clr_table(rdev->net->hport, rdev->destid,
+					     rdev->hopcount, table);
+	} else if (try_module_get(ops->owner)) {
+		rc = ops->clr_table(rdev->net->hport, rdev->destid,
+				    rdev->hopcount, table);
+
+		module_put(ops->owner);
+	}
+
+	spin_unlock(&rdev->rswitch->lock);
+
+	if (lock)
+		rio_unlock_device(rdev->net->hport, rdev->destid,
+				  rdev->hopcount);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(rio_route_clr_table);
+
 #ifdef CONFIG_RAPIDIO_DMA_ENGINE
 
 static bool rio_chan_filter(struct dma_chan *chan, void *arg)
diff -puN drivers/rapidio/rio.h~rapidio-convert-switch-drivers-to-modules drivers/rapidio/rio.h
--- a/drivers/rapidio/rio.h~rapidio-convert-switch-drivers-to-modules
+++ a/drivers/rapidio/rio.h
@@ -28,18 +28,17 @@ extern u32 rio_mport_get_efb(struct rio_
 extern int rio_mport_chk_dev_access(struct rio_mport *mport, u16 destid,
 				    u8 hopcount);
 extern int rio_create_sysfs_dev_files(struct rio_dev *rdev);
-extern int rio_std_route_add_entry(struct rio_mport *mport, u16 destid,
-				   u8 hopcount, u16 table, u16 route_destid,
-				   u8 route_port);
-extern int rio_std_route_get_entry(struct rio_mport *mport, u16 destid,
-				   u8 hopcount, u16 table, u16 route_destid,
-				   u8 *route_port);
-extern int rio_std_route_clr_table(struct rio_mport *mport, u16 destid,
-				   u8 hopcount, u16 table);
+extern int rio_lock_device(struct rio_mport *port, u16 destid,
+			u8 hopcount, int wait_ms);
+extern int rio_unlock_device(struct rio_mport *port, u16 destid, u8 hopcount);
+extern int rio_route_add_entry(struct rio_dev *rdev,
+			u16 table, u16 route_destid, u8 route_port, int lock);
+extern int rio_route_get_entry(struct rio_dev *rdev, u16 table,
+			u16 route_destid, u8 *route_port, int lock);
+extern int rio_route_clr_table(struct rio_dev *rdev, u16 table, int lock);
 extern int rio_set_port_lockout(struct rio_dev *rdev, u32 pnum, int lock);
 extern struct rio_dev *rio_get_comptag(u32 comp_tag, struct rio_dev *from);
 extern int rio_add_device(struct rio_dev *rdev);
-extern void rio_switch_init(struct rio_dev *rdev, int do_enum);
 extern int rio_enable_rx_tx_port(struct rio_mport *port, int local, u16 destid,
 				 u8 hopcount, u8 port_num);
 extern int rio_register_scan(int mport_id, struct rio_scan *scan_ops);
@@ -51,29 +50,5 @@ extern struct rio_mport *rio_find_mport(
 extern struct device_attribute rio_dev_attrs[];
 extern struct bus_attribute rio_bus_attrs[];
 
-extern struct rio_switch_ops __start_rio_switch_ops[];
-extern struct rio_switch_ops __end_rio_switch_ops[];
-
-/* Helpers internal to the RIO core code */
-#define DECLARE_RIO_SWITCH_SECTION(section, name, vid, did, init_hook) \
-	static const struct rio_switch_ops __rio_switch_##name __used \
-	__section(section) = { vid, did, init_hook };
-
-/**
- * DECLARE_RIO_SWITCH_INIT - Registers switch initialization routine
- * @vid: RIO vendor ID
- * @did: RIO device ID
- * @init_hook: Callback that performs switch-specific initialization
- *
- * Manipulating switch route tables and error management in RIO
- * is switch specific. This registers a switch by vendor and device ID with
- * initialization callback for setting up switch operations and (if required)
- * hardware initialization. A &struct rio_switch_ops is initialized with
- * pointer to the init routine and placed into a RIO-specific kernel section.
- */
-#define DECLARE_RIO_SWITCH_INIT(vid, did, init_hook)		\
-	DECLARE_RIO_SWITCH_SECTION(.rio_switch_ops, vid##did, \
-			vid, did, init_hook)
-
 #define RIO_GET_DID(size, x)	(size ? (x & 0xffff) : ((x & 0x00ff0000) >> 16))
 #define RIO_SET_DID(size, x)	(size ? (x & 0xffff) : ((x & 0x000000ff) << 16))
diff -puN drivers/rapidio/switches/Kconfig~rapidio-convert-switch-drivers-to-modules drivers/rapidio/switches/Kconfig
--- a/drivers/rapidio/switches/Kconfig~rapidio-convert-switch-drivers-to-modules
+++ a/drivers/rapidio/switches/Kconfig
@@ -2,27 +2,23 @@
 # RapidIO switches configuration
 #
 config RAPIDIO_TSI57X
-	bool "IDT Tsi57x SRIO switches support"
-	depends on RAPIDIO
+	tristate "IDT Tsi57x SRIO switches support"
 	---help---
 	  Includes support for IDT Tsi57x family of serial RapidIO switches.
 
 config RAPIDIO_CPS_XX
-	bool "IDT CPS-xx SRIO switches support"
-	depends on RAPIDIO
+	tristate "IDT CPS-xx SRIO switches support"
 	---help---
 	  Includes support for IDT CPS-16/12/10/8 serial RapidIO switches.
 
 config RAPIDIO_TSI568
-	bool "Tsi568 SRIO switch support"
-	depends on RAPIDIO
+	tristate "Tsi568 SRIO switch support"
 	default n
 	---help---
 	  Includes support for IDT Tsi568 serial RapidIO switch.
 
 config RAPIDIO_CPS_GEN2
-	bool "IDT CPS Gen.2 SRIO switch support"
-	depends on RAPIDIO
+	tristate "IDT CPS Gen.2 SRIO switch support"
 	default n
 	---help---
 	  Includes support for ITD CPS Gen.2 serial RapidIO switches.
diff -puN drivers/rapidio/switches/idt_gen2.c~rapidio-convert-switch-drivers-to-modules drivers/rapidio/switches/idt_gen2.c
--- a/drivers/rapidio/switches/idt_gen2.c~rapidio-convert-switch-drivers-to-modules
+++ a/drivers/rapidio/switches/idt_gen2.c
@@ -15,6 +15,7 @@
 #include <linux/rio_drv.h>
 #include <linux/rio_ids.h>
 #include <linux/delay.h>
+#include <linux/module.h>
 
 #include <asm/page.h>
 #include "../rio.h"
@@ -389,12 +390,12 @@ idtg2_show_errlog(struct device *dev, st
 
 static DEVICE_ATTR(errlog, S_IRUGO, idtg2_show_errlog, NULL);
 
-static int idtg2_sysfs(struct rio_dev *rdev, int create)
+static int idtg2_sysfs(struct rio_dev *rdev, bool create)
 {
 	struct device *dev = &rdev->dev;
 	int err = 0;
 
-	if (create == RIO_SW_SYSFS_CREATE) {
+	if (create) {
 		/* Initialize sysfs entries */
 		err = device_create_file(dev, &dev_attr_errlog);
 		if (err)
@@ -405,29 +406,90 @@ static int idtg2_sysfs(struct rio_dev *r
 	return err;
 }
 
-static int idtg2_switch_init(struct rio_dev *rdev, int do_enum)
+static struct rio_switch_ops idtg2_switch_ops = {
+	.owner = THIS_MODULE,
+	.add_entry = idtg2_route_add_entry,
+	.get_entry = idtg2_route_get_entry,
+	.clr_table = idtg2_route_clr_table,
+	.set_domain = idtg2_set_domain,
+	.get_domain = idtg2_get_domain,
+	.em_init = idtg2_em_init,
+	.em_handle = idtg2_em_handler,
+};
+
+static int idtg2_probe(struct rio_dev *rdev, const struct rio_device_id *id)
 {
 	pr_debug("RIO: %s for %s\n", __func__, rio_name(rdev));
-	rdev->rswitch->add_entry = idtg2_route_add_entry;
-	rdev->rswitch->get_entry = idtg2_route_get_entry;
-	rdev->rswitch->clr_table = idtg2_route_clr_table;
-	rdev->rswitch->set_domain = idtg2_set_domain;
-	rdev->rswitch->get_domain = idtg2_get_domain;
-	rdev->rswitch->em_init = idtg2_em_init;
-	rdev->rswitch->em_handle = idtg2_em_handler;
-	rdev->rswitch->sw_sysfs = idtg2_sysfs;
 
-	if (do_enum) {
+	spin_lock(&rdev->rswitch->lock);
+
+	if (rdev->rswitch->ops) {
+		spin_unlock(&rdev->rswitch->lock);
+		return -EINVAL;
+	}
+
+	rdev->rswitch->ops = &idtg2_switch_ops;
+
+	if (rdev->do_enum) {
 		/* Ensure that default routing is disabled on startup */
 		rio_write_config_32(rdev,
 				    RIO_STD_RTE_DEFAULT_PORT, IDT_NO_ROUTE);
 	}
 
+	/* Create device-specific sysfs attributes */
+	idtg2_sysfs(rdev, true);
+
+	spin_unlock(&rdev->rswitch->lock);
 	return 0;
 }
 
-DECLARE_RIO_SWITCH_INIT(RIO_VID_IDT, RIO_DID_IDTCPS1848, idtg2_switch_init);
-DECLARE_RIO_SWITCH_INIT(RIO_VID_IDT, RIO_DID_IDTCPS1616, idtg2_switch_init);
-DECLARE_RIO_SWITCH_INIT(RIO_VID_IDT, RIO_DID_IDTVPS1616, idtg2_switch_init);
-DECLARE_RIO_SWITCH_INIT(RIO_VID_IDT, RIO_DID_IDTSPS1616, idtg2_switch_init);
-DECLARE_RIO_SWITCH_INIT(RIO_VID_IDT, RIO_DID_IDTCPS1432, idtg2_switch_init);
+static void idtg2_remove(struct rio_dev *rdev)
+{
+	pr_debug("RIO: %s for %s\n", __func__, rio_name(rdev));
+	spin_lock(&rdev->rswitch->lock);
+	if (rdev->rswitch->ops != &idtg2_switch_ops) {
+		spin_unlock(&rdev->rswitch->lock);
+		return;
+	}
+	rdev->rswitch->ops = NULL;
+
+	/* Remove device-specific sysfs attributes */
+	idtg2_sysfs(rdev, false);
+
+	spin_unlock(&rdev->rswitch->lock);
+}
+
+static struct rio_device_id idtg2_id_table[] = {
+	{RIO_DEVICE(RIO_DID_IDTCPS1848, RIO_VID_IDT)},
+	{RIO_DEVICE(RIO_DID_IDTCPS1616, RIO_VID_IDT)},
+	{RIO_DEVICE(RIO_DID_IDTVPS1616, RIO_VID_IDT)},
+	{RIO_DEVICE(RIO_DID_IDTSPS1616, RIO_VID_IDT)},
+	{RIO_DEVICE(RIO_DID_IDTCPS1432, RIO_VID_IDT)},
+	{ 0, }	/* terminate list */
+};
+
+static struct rio_driver idtg2_driver = {
+	.name = "idt_gen2",
+	.id_table = idtg2_id_table,
+	.probe = idtg2_probe,
+	.remove = idtg2_remove,
+};
+
+static int __init idtg2_init(void)
+{
+	return rio_register_driver(&idtg2_driver);
+}
+
+static void __exit idtg2_exit(void)
+{
+	pr_debug("RIO: %s\n", __func__);
+	rio_unregister_driver(&idtg2_driver);
+	pr_debug("RIO: %s done\n", __func__);
+}
+
+device_initcall(idtg2_init);
+module_exit(idtg2_exit);
+
+MODULE_DESCRIPTION("IDT CPS Gen.2 Serial RapidIO switch family driver");
+MODULE_AUTHOR("Integrated Device Technology, Inc.");
+MODULE_LICENSE("GPL");
diff -puN drivers/rapidio/switches/idtcps.c~rapidio-convert-switch-drivers-to-modules drivers/rapidio/switches/idtcps.c
--- a/drivers/rapidio/switches/idtcps.c~rapidio-convert-switch-drivers-to-modules
+++ a/drivers/rapidio/switches/idtcps.c
@@ -13,6 +13,7 @@
 #include <linux/rio.h>
 #include <linux/rio_drv.h>
 #include <linux/rio_ids.h>
+#include <linux/module.h>
 #include "../rio.h"
 
 #define CPS_DEFAULT_ROUTE	0xde
@@ -118,18 +119,31 @@ idtcps_get_domain(struct rio_mport *mpor
 	return 0;
 }
 
-static int idtcps_switch_init(struct rio_dev *rdev, int do_enum)
+static struct rio_switch_ops idtcps_switch_ops = {
+	.owner = THIS_MODULE,
+	.add_entry = idtcps_route_add_entry,
+	.get_entry = idtcps_route_get_entry,
+	.clr_table = idtcps_route_clr_table,
+	.set_domain = idtcps_set_domain,
+	.get_domain = idtcps_get_domain,
+	.em_init = NULL,
+	.em_handle = NULL,
+};
+
+static int idtcps_probe(struct rio_dev *rdev, const struct rio_device_id *id)
 {
 	pr_debug("RIO: %s for %s\n", __func__, rio_name(rdev));
-	rdev->rswitch->add_entry = idtcps_route_add_entry;
-	rdev->rswitch->get_entry = idtcps_route_get_entry;
-	rdev->rswitch->clr_table = idtcps_route_clr_table;
-	rdev->rswitch->set_domain = idtcps_set_domain;
-	rdev->rswitch->get_domain = idtcps_get_domain;
-	rdev->rswitch->em_init = NULL;
-	rdev->rswitch->em_handle = NULL;
 
-	if (do_enum) {
+	spin_lock(&rdev->rswitch->lock);
+
+	if (rdev->rswitch->ops) {
+		spin_unlock(&rdev->rswitch->lock);
+		return -EINVAL;
+	}
+
+	rdev->rswitch->ops = &idtcps_switch_ops;
+
+	if (rdev->do_enum) {
 		/* set TVAL = ~50us */
 		rio_write_config_32(rdev,
 			rdev->phys_efptr + RIO_PORT_LINKTO_CTL_CSR, 0x8e << 8);
@@ -138,12 +152,52 @@ static int idtcps_switch_init(struct rio
 				    RIO_STD_RTE_DEFAULT_PORT, CPS_NO_ROUTE);
 	}
 
+	spin_unlock(&rdev->rswitch->lock);
 	return 0;
 }
 
-DECLARE_RIO_SWITCH_INIT(RIO_VID_IDT, RIO_DID_IDTCPS6Q, idtcps_switch_init);
-DECLARE_RIO_SWITCH_INIT(RIO_VID_IDT, RIO_DID_IDTCPS8, idtcps_switch_init);
-DECLARE_RIO_SWITCH_INIT(RIO_VID_IDT, RIO_DID_IDTCPS10Q, idtcps_switch_init);
-DECLARE_RIO_SWITCH_INIT(RIO_VID_IDT, RIO_DID_IDTCPS12, idtcps_switch_init);
-DECLARE_RIO_SWITCH_INIT(RIO_VID_IDT, RIO_DID_IDTCPS16, idtcps_switch_init);
-DECLARE_RIO_SWITCH_INIT(RIO_VID_IDT, RIO_DID_IDT70K200, idtcps_switch_init);
+static void idtcps_remove(struct rio_dev *rdev)
+{
+	pr_debug("RIO: %s for %s\n", __func__, rio_name(rdev));
+	spin_lock(&rdev->rswitch->lock);
+	if (rdev->rswitch->ops != &idtcps_switch_ops) {
+		spin_unlock(&rdev->rswitch->lock);
+		return;
+	}
+	rdev->rswitch->ops = NULL;
+	spin_unlock(&rdev->rswitch->lock);
+}
+
+static struct rio_device_id idtcps_id_table[] = {
+	{RIO_DEVICE(RIO_DID_IDTCPS6Q, RIO_VID_IDT)},
+	{RIO_DEVICE(RIO_DID_IDTCPS8, RIO_VID_IDT)},
+	{RIO_DEVICE(RIO_DID_IDTCPS10Q, RIO_VID_IDT)},
+	{RIO_DEVICE(RIO_DID_IDTCPS12, RIO_VID_IDT)},
+	{RIO_DEVICE(RIO_DID_IDTCPS16, RIO_VID_IDT)},
+	{RIO_DEVICE(RIO_DID_IDT70K200, RIO_VID_IDT)},
+	{ 0, }	/* terminate list */
+};
+
+static struct rio_driver idtcps_driver = {
+	.name = "idtcps",
+	.id_table = idtcps_id_table,
+	.probe = idtcps_probe,
+	.remove = idtcps_remove,
+};
+
+static int __init idtcps_init(void)
+{
+	return rio_register_driver(&idtcps_driver);
+}
+
+static void __exit idtcps_exit(void)
+{
+	rio_unregister_driver(&idtcps_driver);
+}
+
+device_initcall(idtcps_init);
+module_exit(idtcps_exit);
+
+MODULE_DESCRIPTION("IDT CPS Gen.1 Serial RapidIO switch family driver");
+MODULE_AUTHOR("Integrated Device Technology, Inc.");
+MODULE_LICENSE("GPL");
diff -puN drivers/rapidio/switches/tsi568.c~rapidio-convert-switch-drivers-to-modules drivers/rapidio/switches/tsi568.c
--- a/drivers/rapidio/switches/tsi568.c~rapidio-convert-switch-drivers-to-modules
+++ a/drivers/rapidio/switches/tsi568.c
@@ -19,6 +19,7 @@
 #include <linux/rio_drv.h>
 #include <linux/rio_ids.h>
 #include <linux/delay.h>
+#include <linux/module.h>
 #include "../rio.h"
 
 /* Global (broadcast) route registers */
@@ -129,18 +130,70 @@ tsi568_em_init(struct rio_dev *rdev)
 	return 0;
 }
 
-static int tsi568_switch_init(struct rio_dev *rdev, int do_enum)
+static struct rio_switch_ops tsi568_switch_ops = {
+	.owner = THIS_MODULE,
+	.add_entry = tsi568_route_add_entry,
+	.get_entry = tsi568_route_get_entry,
+	.clr_table = tsi568_route_clr_table,
+	.set_domain = NULL,
+	.get_domain = NULL,
+	.em_init = tsi568_em_init,
+	.em_handle = NULL,
+};
+
+static int tsi568_probe(struct rio_dev *rdev, const struct rio_device_id *id)
 {
 	pr_debug("RIO: %s for %s\n", __func__, rio_name(rdev));
-	rdev->rswitch->add_entry = tsi568_route_add_entry;
-	rdev->rswitch->get_entry = tsi568_route_get_entry;
-	rdev->rswitch->clr_table = tsi568_route_clr_table;
-	rdev->rswitch->set_domain = NULL;
-	rdev->rswitch->get_domain = NULL;
-	rdev->rswitch->em_init = tsi568_em_init;
-	rdev->rswitch->em_handle = NULL;
 
+	spin_lock(&rdev->rswitch->lock);
+
+	if (rdev->rswitch->ops) {
+		spin_unlock(&rdev->rswitch->lock);
+		return -EINVAL;
+	}
+
+	rdev->rswitch->ops = &tsi568_switch_ops;
+	spin_unlock(&rdev->rswitch->lock);
 	return 0;
 }
 
-DECLARE_RIO_SWITCH_INIT(RIO_VID_TUNDRA, RIO_DID_TSI568, tsi568_switch_init);
+static void tsi568_remove(struct rio_dev *rdev)
+{
+	pr_debug("RIO: %s for %s\n", __func__, rio_name(rdev));
+	spin_lock(&rdev->rswitch->lock);
+	if (rdev->rswitch->ops != &tsi568_switch_ops) {
+		spin_unlock(&rdev->rswitch->lock);
+		return;
+	}
+	rdev->rswitch->ops = NULL;
+	spin_unlock(&rdev->rswitch->lock);
+}
+
+static struct rio_device_id tsi568_id_table[] = {
+	{RIO_DEVICE(RIO_DID_TSI568, RIO_VID_TUNDRA)},
+	{ 0, }	/* terminate list */
+};
+
+static struct rio_driver tsi568_driver = {
+	.name = "tsi568",
+	.id_table = tsi568_id_table,
+	.probe = tsi568_probe,
+	.remove = tsi568_remove,
+};
+
+static int __init tsi568_init(void)
+{
+	return rio_register_driver(&tsi568_driver);
+}
+
+static void __exit tsi568_exit(void)
+{
+	rio_unregister_driver(&tsi568_driver);
+}
+
+device_initcall(tsi568_init);
+module_exit(tsi568_exit);
+
+MODULE_DESCRIPTION("IDT Tsi568 Serial RapidIO switch driver");
+MODULE_AUTHOR("Integrated Device Technology, Inc.");
+MODULE_LICENSE("GPL");
diff -puN drivers/rapidio/switches/tsi57x.c~rapidio-convert-switch-drivers-to-modules drivers/rapidio/switches/tsi57x.c
--- a/drivers/rapidio/switches/tsi57x.c~rapidio-convert-switch-drivers-to-modules
+++ a/drivers/rapidio/switches/tsi57x.c
@@ -19,6 +19,7 @@
 #include <linux/rio_drv.h>
 #include <linux/rio_ids.h>
 #include <linux/delay.h>
+#include <linux/module.h>
 #include "../rio.h"
 
 /* Global (broadcast) route registers */
@@ -292,27 +293,79 @@ exit_es:
 	return 0;
 }
 
-static int tsi57x_switch_init(struct rio_dev *rdev, int do_enum)
+static struct rio_switch_ops tsi57x_switch_ops = {
+	.owner = THIS_MODULE,
+	.add_entry = tsi57x_route_add_entry,
+	.get_entry = tsi57x_route_get_entry,
+	.clr_table = tsi57x_route_clr_table,
+	.set_domain = tsi57x_set_domain,
+	.get_domain = tsi57x_get_domain,
+	.em_init = tsi57x_em_init,
+	.em_handle = tsi57x_em_handler,
+};
+
+static int tsi57x_probe(struct rio_dev *rdev, const struct rio_device_id *id)
 {
 	pr_debug("RIO: %s for %s\n", __func__, rio_name(rdev));
-	rdev->rswitch->add_entry = tsi57x_route_add_entry;
-	rdev->rswitch->get_entry = tsi57x_route_get_entry;
-	rdev->rswitch->clr_table = tsi57x_route_clr_table;
-	rdev->rswitch->set_domain = tsi57x_set_domain;
-	rdev->rswitch->get_domain = tsi57x_get_domain;
-	rdev->rswitch->em_init = tsi57x_em_init;
-	rdev->rswitch->em_handle = tsi57x_em_handler;
 
-	if (do_enum) {
+	spin_lock(&rdev->rswitch->lock);
+
+	if (rdev->rswitch->ops) {
+		spin_unlock(&rdev->rswitch->lock);
+		return -EINVAL;
+	}
+	rdev->rswitch->ops = &tsi57x_switch_ops;
+
+	if (rdev->do_enum) {
 		/* Ensure that default routing is disabled on startup */
 		rio_write_config_32(rdev, RIO_STD_RTE_DEFAULT_PORT,
 				    RIO_INVALID_ROUTE);
 	}
 
+	spin_unlock(&rdev->rswitch->lock);
 	return 0;
 }
 
-DECLARE_RIO_SWITCH_INIT(RIO_VID_TUNDRA, RIO_DID_TSI572, tsi57x_switch_init);
-DECLARE_RIO_SWITCH_INIT(RIO_VID_TUNDRA, RIO_DID_TSI574, tsi57x_switch_init);
-DECLARE_RIO_SWITCH_INIT(RIO_VID_TUNDRA, RIO_DID_TSI577, tsi57x_switch_init);
-DECLARE_RIO_SWITCH_INIT(RIO_VID_TUNDRA, RIO_DID_TSI578, tsi57x_switch_init);
+static void tsi57x_remove(struct rio_dev *rdev)
+{
+	pr_debug("RIO: %s for %s\n", __func__, rio_name(rdev));
+	spin_lock(&rdev->rswitch->lock);
+	if (rdev->rswitch->ops != &tsi57x_switch_ops) {
+		spin_unlock(&rdev->rswitch->lock);
+		return;
+	}
+	rdev->rswitch->ops = NULL;
+	spin_unlock(&rdev->rswitch->lock);
+}
+
+static struct rio_device_id tsi57x_id_table[] = {
+	{RIO_DEVICE(RIO_DID_TSI572, RIO_VID_TUNDRA)},
+	{RIO_DEVICE(RIO_DID_TSI574, RIO_VID_TUNDRA)},
+	{RIO_DEVICE(RIO_DID_TSI577, RIO_VID_TUNDRA)},
+	{RIO_DEVICE(RIO_DID_TSI578, RIO_VID_TUNDRA)},
+	{ 0, }	/* terminate list */
+};
+
+static struct rio_driver tsi57x_driver = {
+	.name = "tsi57x",
+	.id_table = tsi57x_id_table,
+	.probe = tsi57x_probe,
+	.remove = tsi57x_remove,
+};
+
+static int __init tsi57x_init(void)
+{
+	return rio_register_driver(&tsi57x_driver);
+}
+
+static void __exit tsi57x_exit(void)
+{
+	rio_unregister_driver(&tsi57x_driver);
+}
+
+device_initcall(tsi57x_init);
+module_exit(tsi57x_exit);
+
+MODULE_DESCRIPTION("IDT Tsi57x Serial RapidIO switch family driver");
+MODULE_AUTHOR("Integrated Device Technology, Inc.");
+MODULE_LICENSE("GPL");
diff -puN include/asm-generic/vmlinux.lds.h~rapidio-convert-switch-drivers-to-modules include/asm-generic/vmlinux.lds.h
--- a/include/asm-generic/vmlinux.lds.h~rapidio-convert-switch-drivers-to-modules
+++ a/include/asm-generic/vmlinux.lds.h
@@ -275,13 +275,6 @@
 		VMLINUX_SYMBOL(__end_builtin_fw) = .;			\
 	}								\
 									\
-	/* RapidIO route ops */						\
-	.rio_ops        : AT(ADDR(.rio_ops) - LOAD_OFFSET) {		\
-		VMLINUX_SYMBOL(__start_rio_switch_ops) = .;		\
-		*(.rio_switch_ops)					\
-		VMLINUX_SYMBOL(__end_rio_switch_ops) = .;		\
-	}								\
-									\
 	TRACEDATA							\
 									\
 	/* Kernel symbol table: Normal symbols */			\
diff -puN include/linux/rio.h~rapidio-convert-switch-drivers-to-modules include/linux/rio.h
--- a/include/linux/rio.h~rapidio-convert-switch-drivers-to-modules
+++ a/include/linux/rio.h
@@ -94,6 +94,23 @@ union rio_pw_msg;
  * @switchid: Switch ID that is unique across a network
  * @route_table: Copy of switch routing table
  * @port_ok: Status of each port (one bit per port) - OK=1 or UNINIT=0
+ * @ops: pointer to switch-specific operations
+ * @lock: lock to serialize operations updates
+ * @nextdev: Array of per-port pointers to the next attached device
+ */
+struct rio_switch {
+	struct list_head node;
+	u16 switchid;
+	u8 *route_table;
+	u32 port_ok;
+	struct rio_switch_ops *ops;
+	spinlock_t lock;
+	struct rio_dev *nextdev[0];
+};
+
+/**
+ * struct rio_switch_ops - Per-switch operations
+ * @owner: The module owner of this structure
  * @add_entry: Callback for switch-specific route add function
  * @get_entry: Callback for switch-specific route get function
  * @clr_table: Callback for switch-specific clear route table function
@@ -101,14 +118,12 @@ union rio_pw_msg;
  * @get_domain: Callback for switch-specific domain get function
  * @em_init: Callback for switch-specific error management init function
  * @em_handle: Callback for switch-specific error management handler function
- * @sw_sysfs: Callback that initializes switch-specific sysfs attributes
- * @nextdev: Array of per-port pointers to the next attached device
+ *
+ * Defines the operations that are necessary to initialize/control
+ * a particular RIO switch device.
  */
-struct rio_switch {
-	struct list_head node;
-	u16 switchid;
-	u8 *route_table;
-	u32 port_ok;
+struct rio_switch_ops {
+	struct module *owner;
 	int (*add_entry) (struct rio_mport *mport, u16 destid, u8 hopcount,
 			  u16 table, u16 route_destid, u8 route_port);
 	int (*get_entry) (struct rio_mport *mport, u16 destid, u8 hopcount,
@@ -121,8 +136,6 @@ struct rio_switch {
 			   u8 *sw_domain);
 	int (*em_init) (struct rio_dev *dev);
 	int (*em_handle) (struct rio_dev *dev, u8 swport);
-	int (*sw_sysfs) (struct rio_dev *dev, int create);
-	struct rio_dev *nextdev[0];
 };
 
 /**
@@ -130,6 +143,7 @@ struct rio_switch {
  * @global_list: Node in list of all RIO devices
  * @net_list: Node in list of RIO devices in a network
  * @net: Network this device is a part of
+ * @do_enum: Enumeration flag
  * @did: Device ID
  * @vid: Vendor ID
  * @device_rev: Device revision
@@ -158,6 +172,7 @@ struct rio_dev {
 	struct list_head global_list;	/* node in list of all RIO devices */
 	struct list_head net_list;	/* node in per net list */
 	struct rio_net *net;	/* RIO net this device resides in */
+	bool do_enum;
 	u16 did;
 	u16 vid;
 	u32 device_rev;
@@ -297,10 +312,6 @@ struct rio_net {
 	struct rio_id_table destid_table;  /* destID allocation table */
 };
 
-/* Definitions used by switch sysfs initialization callback */
-#define RIO_SW_SYSFS_CREATE	1	/* Create switch attributes */
-#define RIO_SW_SYSFS_REMOVE	0	/* Remove switch attributes */
-
 /* Low-level architecture-dependent routines */
 
 /**
@@ -400,20 +411,6 @@ struct rio_device_id {
 	u16 asm_did, asm_vid;
 };
 
-/**
- * struct rio_switch_ops - Per-switch operations
- * @vid: RIO vendor ID
- * @did: RIO device ID
- * @init_hook: Callback that performs switch device initialization
- *
- * Defines the operations that are necessary to initialize/control
- * a particular RIO switch device.
- */
-struct rio_switch_ops {
-	u16 vid, did;
-	int (*init_hook) (struct rio_dev *rdev, int do_enum);
-};
