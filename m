From: akpm@linux-foundation.org
Subject: [merged] rapidio-integrate-rio_switch-into-rio_dev.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:08:52 -0800
Message-ID: <201101132011.p0DKBXNP030183@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55604 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933708Ab1AMUNA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:13:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, galak@kernel.crashing.org, leoli@freescale.com, micha@neli.hopto.org, mporter@kernel.crashing.org, thomas.moll@sysgo.com, mm-commits@vger.kernel.org


The patch titled
     rapidio: integrate rio_switch into rio_dev
has been removed from the -mm tree.  Its filename was
     rapidio-integrate-rio_switch-into-rio_dev.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rapidio: integrate rio_switch into rio_dev
From: Alexandre Bounine <alexandre.bounine@idt.com>

Convert RIO switches device structures (rio_dev + rio_switch) into a
single allocation unit.

This change is based on the fact that RIO switches are using common RIO
device objects anyway.  Allocating RIO switch objects as RIO devices with
added space for switch information simplifies handling of RIO switch
devices.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Thomas Moll <thomas.moll@sysgo.com>
Cc: Micha Nelissen <micha@neli.hopto.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio-scan.c  |   59 +++++++++++++-----------
 drivers/rapidio/rio-sysfs.c |    4 -
 include/linux/rio.h         |   82 +++++++++++++++++-----------------
 3 files changed, 75 insertions(+), 70 deletions(-)

diff -puN drivers/rapidio/rio-scan.c~rapidio-integrate-rio_switch-into-rio_dev drivers/rapidio/rio-scan.c
--- a/drivers/rapidio/rio-scan.c~rapidio-integrate-rio_switch-into-rio_dev
+++ a/drivers/rapidio/rio-scan.c
@@ -378,12 +378,30 @@ static struct rio_dev __devinit *rio_set
 	struct rio_dev *rdev;
 	struct rio_switch *rswitch = NULL;
 	int result, rdid;
+	size_t size;
+	u32 swpinfo = 0;
 
-	rdev = kzalloc(sizeof(struct rio_dev), GFP_KERNEL);
+	size = sizeof(struct rio_dev);
+	if (rio_mport_read_config_32(port, destid, hopcount,
+				     RIO_PEF_CAR, &result))
+		return NULL;
+
+	if (result & (RIO_PEF_SWITCH | RIO_PEF_MULTIPORT)) {
+		rio_mport_read_config_32(port, destid, hopcount,
+					 RIO_SWP_INFO_CAR, &swpinfo);
+		if (result & RIO_PEF_SWITCH) {
+			size += (RIO_GET_TOTAL_PORTS(swpinfo) *
+				sizeof(rswitch->nextdev[0])) + sizeof(*rswitch);
+		}
+	}
+
+	rdev = kzalloc(size, GFP_KERNEL);
 	if (!rdev)
 		return NULL;
 
 	rdev->net = net;
+	rdev->pef = result;
+	rdev->swpinfo = swpinfo;
 	rio_mport_read_config_32(port, destid, hopcount, RIO_DEV_ID_CAR,
 				 &result);
 	rdev->did = result >> 16;
@@ -397,8 +415,6 @@ static struct rio_dev __devinit *rio_set
 	rio_mport_read_config_32(port, destid, hopcount, RIO_ASM_INFO_CAR,
 				 &result);
 	rdev->asm_rev = result >> 16;
-	rio_mport_read_config_32(port, destid, hopcount, RIO_PEF_CAR,
-				 &rdev->pef);
 	if (rdev->pef & RIO_PEF_EXT_FEATURES) {
 		rdev->efptr = result & 0xffff;
 		rdev->phys_efptr = rio_mport_get_physefb(port, 0, destid,
@@ -408,11 +424,6 @@ static struct rio_dev __devinit *rio_set
 						hopcount, RIO_EFB_ERR_MGMNT);
 	}
 
-	if (rdev->pef & (RIO_PEF_SWITCH | RIO_PEF_MULTIPORT)) {
-		rio_mport_read_config_32(port, destid, hopcount,
-					 RIO_SWP_INFO_CAR, &rdev->swpinfo);
-	}
-
 	rio_mport_read_config_32(port, destid, hopcount, RIO_SRC_OPS_CAR,
 				 &rdev->src_ops);
 	rio_mport_read_config_32(port, destid, hopcount, RIO_DST_OPS_CAR,
@@ -449,12 +460,7 @@ static struct rio_dev __devinit *rio_set
 
 	/* If a PE has both switch and other functions, show it as a switch */
 	if (rio_is_switch(rdev)) {
-		rswitch = kzalloc(sizeof(*rswitch) +
-				  RIO_GET_TOTAL_PORTS(rdev->swpinfo) *
-				  sizeof(rswitch->nextdev[0]),
-				  GFP_KERNEL);
-		if (!rswitch)
-			goto cleanup;
+		rswitch = rdev->rswitch;
 		rswitch->switchid = next_switchid;
 		rswitch->port_ok = 0;
 		rswitch->route_table = kzalloc(sizeof(u8)*
@@ -466,15 +472,13 @@ static struct rio_dev __devinit *rio_set
 		for (rdid = 0; rdid < RIO_MAX_ROUTE_ENTRIES(port->sys_size);
 				rdid++)
 			rswitch->route_table[rdid] = RIO_INVALID_ROUTE;
-		rdev->rswitch = rswitch;
-		rswitch->rdev = rdev;
 		dev_set_name(&rdev->dev, "%02x:s:%04x", rdev->net->id,
-			     rdev->rswitch->switchid);
+			     rswitch->switchid);
 		rio_switch_init(rdev, do_enum);
 
-		if (do_enum && rdev->rswitch->clr_table)
-			rdev->rswitch->clr_table(port, destid, hopcount,
-						 RIO_GLOBAL_TABLE);
+		if (do_enum && rswitch->clr_table)
+			rswitch->clr_table(port, destid, hopcount,
+					   RIO_GLOBAL_TABLE);
 
 		list_add_tail(&rswitch->node, &rio_switches);
 
@@ -510,10 +514,9 @@ static struct rio_dev __devinit *rio_set
 	return rdev;
 
 cleanup:
-	if (rswitch) {
+	if (rswitch->route_table)
 		kfree(rswitch->route_table);
-		kfree(rswitch);
-	}
+
 	kfree(rdev);
 	return NULL;
 }
@@ -1072,7 +1075,7 @@ static struct rio_net __devinit *rio_all
  */
 static void rio_update_route_tables(struct rio_mport *port)
 {
-	struct rio_dev *rdev;
+	struct rio_dev *rdev, *swrdev;
 	struct rio_switch *rswitch;
 	u8 sport;
 	u16 destid;
@@ -1087,14 +1090,16 @@ static void rio_update_route_tables(stru
 				continue;
 
 			if (RIO_INVALID_ROUTE == rswitch->route_table[destid]) {
+				swrdev = sw_to_rio_dev(rswitch);
+
 				/* Skip if destid ends in empty switch*/
-				if (rswitch->rdev->destid == destid)
+				if (swrdev->destid == destid)
 					continue;
 
-				sport = RIO_GET_PORT_NUM(rswitch->rdev->swpinfo);
+				sport = RIO_GET_PORT_NUM(swrdev->swpinfo);
 
 				if (rswitch->add_entry)	{
-					rio_route_add_entry(rswitch->rdev,
+					rio_route_add_entry(swrdev,
 						RIO_GLOBAL_TABLE, destid,
 						sport, 0);
 					rswitch->route_table[destid] = sport;
diff -puN drivers/rapidio/rio-sysfs.c~rapidio-integrate-rio_switch-into-rio_dev drivers/rapidio/rio-sysfs.c
--- a/drivers/rapidio/rio-sysfs.c~rapidio-integrate-rio_switch-into-rio_dev
+++ a/drivers/rapidio/rio-sysfs.c
@@ -217,7 +217,7 @@ int rio_create_sysfs_dev_files(struct ri
 
 	err = device_create_bin_file(&rdev->dev, &rio_config_attr);
 
-	if (!err && rdev->rswitch) {
+	if (!err && (rdev->pef & RIO_PEF_SWITCH)) {
 		err = device_create_file(&rdev->dev, &dev_attr_routes);
 		if (!err && rdev->rswitch->sw_sysfs)
 			err = rdev->rswitch->sw_sysfs(rdev, RIO_SW_SYSFS_CREATE);
@@ -239,7 +239,7 @@ int rio_create_sysfs_dev_files(struct ri
 void rio_remove_sysfs_dev_files(struct rio_dev *rdev)
 {
 	device_remove_bin_file(&rdev->dev, &rio_config_attr);
-	if (rdev->rswitch) {
+	if (rdev->pef & RIO_PEF_SWITCH) {
 		device_remove_file(&rdev->dev, &dev_attr_routes);
 		if (rdev->rswitch->sw_sysfs)
 			rdev->rswitch->sw_sysfs(rdev, RIO_SW_SYSFS_REMOVE);
diff -puN include/linux/rio.h~rapidio-integrate-rio_switch-into-rio_dev include/linux/rio.h
--- a/include/linux/rio.h~rapidio-integrate-rio_switch-into-rio_dev
+++ a/include/linux/rio.h
@@ -71,9 +71,47 @@ extern struct device rio_bus;
 extern struct list_head rio_devices;	/* list of all devices */
 
 struct rio_mport;
+struct rio_dev;
 union rio_pw_msg;
 
 /**
+ * struct rio_switch - RIO switch info
+ * @node: Node in global list of switches
+ * @switchid: Switch ID that is unique across a network
+ * @route_table: Copy of switch routing table
+ * @port_ok: Status of each port (one bit per port) - OK=1 or UNINIT=0
+ * @add_entry: Callback for switch-specific route add function
+ * @get_entry: Callback for switch-specific route get function
+ * @clr_table: Callback for switch-specific clear route table function
+ * @set_domain: Callback for switch-specific domain setting function
+ * @get_domain: Callback for switch-specific domain get function
+ * @em_init: Callback for switch-specific error management init function
+ * @em_handle: Callback for switch-specific error management handler function
+ * @sw_sysfs: Callback that initializes switch-specific sysfs attributes
+ * @nextdev: Array of per-port pointers to the next attached device
+ */
+struct rio_switch {
+	struct list_head node;
+	u16 switchid;
+	u8 *route_table;
+	u32 port_ok;
+	int (*add_entry) (struct rio_mport *mport, u16 destid, u8 hopcount,
+			  u16 table, u16 route_destid, u8 route_port);
+	int (*get_entry) (struct rio_mport *mport, u16 destid, u8 hopcount,
+			  u16 table, u16 route_destid, u8 *route_port);
+	int (*clr_table) (struct rio_mport *mport, u16 destid, u8 hopcount,
+			  u16 table);
+	int (*set_domain) (struct rio_mport *mport, u16 destid, u8 hopcount,
+			   u8 sw_domain);
+	int (*get_domain) (struct rio_mport *mport, u16 destid, u8 hopcount,
+			   u8 *sw_domain);
+	int (*em_init) (struct rio_dev *dev);
+	int (*em_handle) (struct rio_dev *dev, u8 swport);
+	int (*sw_sysfs) (struct rio_dev *dev, int create);
+	struct rio_dev *nextdev[0];
+};
+
+/**
  * struct rio_dev - RIO device info
  * @global_list: Node in list of all RIO devices
  * @net_list: Node in list of RIO devices in a network
@@ -93,7 +131,6 @@ union rio_pw_msg;
  * @phys_efptr: RIO device extended features pointer
  * @em_efptr: RIO Error Management features pointer
  * @dma_mask: Mask of bits of RIO address this device implements
- * @rswitch: Pointer to &struct rio_switch if valid for this device
  * @driver: Driver claiming this device
  * @dev: Device model device
  * @riores: RIO resources this device owns
@@ -101,6 +138,7 @@ union rio_pw_msg;
  * @destid: Network destination ID (or associated destid for switch)
  * @hopcount: Hopcount to this device
  * @prev: Previous RIO device connected to the current one
+ * @rswitch: struct rio_switch (if valid for this device)
  */
 struct rio_dev {
 	struct list_head global_list;	/* node in list of all RIO devices */
@@ -121,7 +159,6 @@ struct rio_dev {
 	u32 phys_efptr;
 	u32 em_efptr;
 	u64 dma_mask;
-	struct rio_switch *rswitch;	/* RIO switch info */
 	struct rio_driver *driver;	/* RIO driver claiming this device */
 	struct device dev;	/* LDM device structure */
 	struct resource riores[RIO_MAX_DEV_RESOURCES];
@@ -129,11 +166,13 @@ struct rio_dev {
 	u16 destid;
 	u8 hopcount;
 	struct rio_dev *prev;
+	struct rio_switch rswitch[0];	/* RIO switch info */
 };
 
 #define rio_dev_g(n) list_entry(n, struct rio_dev, global_list)
 #define rio_dev_f(n) list_entry(n, struct rio_dev, net_list)
 #define	to_rio_dev(n) container_of(n, struct rio_dev, dev)
+#define sw_to_rio_dev(n) container_of(n, struct rio_dev, rswitch[0])
 
 /**
  * struct rio_msg - RIO message event
@@ -226,45 +265,6 @@ struct rio_net {
 #define RIO_SW_SYSFS_CREATE	1	/* Create switch attributes */
 #define RIO_SW_SYSFS_REMOVE	0	/* Remove switch attributes */
 
-/**
- * struct rio_switch - RIO switch info
- * @node: Node in global list of switches
- * @rdev: Associated RIO device structure
- * @switchid: Switch ID that is unique across a network
- * @route_table: Copy of switch routing table
- * @port_ok: Status of each port (one bit per port) - OK=1 or UNINIT=0
- * @add_entry: Callback for switch-specific route add function
- * @get_entry: Callback for switch-specific route get function
- * @clr_table: Callback for switch-specific clear route table function
- * @set_domain: Callback for switch-specific domain setting function
- * @get_domain: Callback for switch-specific domain get function
- * @em_init: Callback for switch-specific error management initialization function
- * @em_handle: Callback for switch-specific error management handler function
- * @sw_sysfs: Callback that initializes switch-specific sysfs attributes
- * @nextdev: Array of per-port pointers to the next attached device
- */
-struct rio_switch {
-	struct list_head node;
-	struct rio_dev *rdev;
-	u16 switchid;
-	u8 *route_table;
-	u32 port_ok;
-	int (*add_entry) (struct rio_mport * mport, u16 destid, u8 hopcount,
-			  u16 table, u16 route_destid, u8 route_port);
-	int (*get_entry) (struct rio_mport * mport, u16 destid, u8 hopcount,
-			  u16 table, u16 route_destid, u8 * route_port);
-	int (*clr_table) (struct rio_mport *mport, u16 destid, u8 hopcount,
-			  u16 table);
-	int (*set_domain) (struct rio_mport *mport, u16 destid, u8 hopcount,
-			   u8 sw_domain);
-	int (*get_domain) (struct rio_mport *mport, u16 destid, u8 hopcount,
-			   u8 *sw_domain);
-	int (*em_init) (struct rio_dev *dev);
-	int (*em_handle) (struct rio_dev *dev, u8 swport);
-	int (*sw_sysfs) (struct rio_dev *dev, int create);
-	struct rio_dev *nextdev[0];
-};
