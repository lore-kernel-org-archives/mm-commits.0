From: akpm@linux-foundation.org
Subject: [merged] rapidio-use-device-lists-handling-on-per-net-basis.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:20:38 -0700
Message-ID: <20121005202038.B04EC1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:60401 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab2JEUUj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:20:39 -0400
Received: by mail-qa0-f74.google.com with SMTP id a16so94742qae.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:20:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, leoli@freescale.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: use device lists handling on per-net basis
has been removed from the -mm tree.  Its filename was
     rapidio-use-device-lists-handling-on-per-net-basis.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio: use device lists handling on per-net basis

Modify handling of device lists to resolve issues caused by using single
global list of RIO devices during enumeration/discovery.  The most common
sign of existing issue is incorrect contents of switch routing tables in
systems with multiple mport controllers while single-port configuration
performs as expected.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio-scan.c |   60 ++++++++++++++++++-----------------
 include/linux/rio.h        |    1 
 2 files changed, 32 insertions(+), 29 deletions(-)

diff -puN drivers/rapidio/rio-scan.c~rapidio-use-device-lists-handling-on-per-net-basis drivers/rapidio/rio-scan.c
--- a/drivers/rapidio/rio-scan.c~rapidio-use-device-lists-handling-on-per-net-basis
+++ a/drivers/rapidio/rio-scan.c
@@ -38,7 +38,6 @@
 #include "rio.h"
 
 LIST_HEAD(rio_devices);
-static LIST_HEAD(rio_switches);
 
 static void rio_init_em(struct rio_dev *rdev);
 
@@ -104,14 +103,15 @@ static void rio_local_set_device_id(stru
 
 /**
  * rio_clear_locks- Release all host locks and signal enumeration complete
- * @port: Master port to issue transaction
+ * @net: RIO network to run on
  *
  * Marks the component tag CSR on each device with the enumeration
  * complete flag. When complete, it then release the host locks on
  * each device. Returns 0 on success or %-EINVAL on failure.
  */
-static int rio_clear_locks(struct rio_mport *port)
+static int rio_clear_locks(struct rio_net *net)
 {
+	struct rio_mport *port = net->hport;
 	struct rio_dev *rdev;
 	u32 result;
 	int ret = 0;
@@ -126,7 +126,7 @@ static int rio_clear_locks(struct rio_mp
 		       result);
 		ret = -EINVAL;
 	}
-	list_for_each_entry(rdev, &rio_devices, global_list) {
+	list_for_each_entry(rdev, &net->devices, net_list) {
 		rio_write_config_32(rdev, RIO_HOST_DID_LOCK_CSR,
 				    port->host_deviceid);
 		rio_read_config_32(rdev, RIO_HOST_DID_LOCK_CSR, &result);
@@ -479,7 +479,7 @@ static struct rio_dev __devinit *rio_set
 			rswitch->clr_table(port, destid, hopcount,
 					   RIO_GLOBAL_TABLE);
 
-		list_add_tail(&rswitch->node, &rio_switches);
+		list_add_tail(&rswitch->node, &net->switches);
 
 	} else {
 		if (do_enum)
@@ -1058,6 +1058,7 @@ static struct rio_net __devinit *rio_all
 	if (net) {
 		INIT_LIST_HEAD(&net->node);
 		INIT_LIST_HEAD(&net->devices);
+		INIT_LIST_HEAD(&net->switches);
 		INIT_LIST_HEAD(&net->mports);
 		list_add_tail(&port->nnode, &net->mports);
 		net->hport = port;
@@ -1068,24 +1069,24 @@ static struct rio_net __devinit *rio_all
 
 /**
  * rio_update_route_tables- Updates route tables in switches
- * @port: Master port associated with the RIO network
+ * @net: RIO network to run update on
  *
  * For each enumerated device, ensure that each switch in a system
  * has correct routing entries. Add routes for devices that where
  * unknown dirung the first enumeration pass through the switch.
  */
-static void rio_update_route_tables(struct rio_mport *port)
+static void rio_update_route_tables(struct rio_net *net)
 {
 	struct rio_dev *rdev, *swrdev;
 	struct rio_switch *rswitch;
 	u8 sport;
 	u16 destid;
 
-	list_for_each_entry(rdev, &rio_devices, global_list) {
+	list_for_each_entry(rdev, &net->devices, net_list) {
 
 		destid = rdev->destid;
 
-		list_for_each_entry(rswitch, &rio_switches, node) {
+		list_for_each_entry(rswitch, &net->switches, node) {
 
 			if (rio_is_switch(rdev)	&& (rdev->rswitch == rswitch))
 				continue;
@@ -1181,12 +1182,12 @@ int __devinit rio_enum_mport(struct rio_
 			printk(KERN_INFO
 			       "RIO: master port %d device has lost enumeration to a remote host\n",
 			       mport->id);
-			rio_clear_locks(mport);
+			rio_clear_locks(net);
 			rc = -EBUSY;
 			goto out;
 		}
-		rio_update_route_tables(mport);
-		rio_clear_locks(mport);
+		rio_update_route_tables(net);
+		rio_clear_locks(net);
 		rio_pw_enable(mport, 1);
 	} else {
 		printk(KERN_INFO "RIO: master port %d link inactive\n",
@@ -1200,33 +1201,34 @@ int __devinit rio_enum_mport(struct rio_
 
 /**
  * rio_build_route_tables- Generate route tables from switch route entries
+ * @net: RIO network to run route tables scan on
  *
  * For each switch device, generate a route table by copying existing
  * route entries from the switch.
  */
-static void rio_build_route_tables(void)
+static void rio_build_route_tables(struct rio_net *net)
 {
+	struct rio_switch *rswitch;
 	struct rio_dev *rdev;
 	int i;
 	u8 sport;
 
-	list_for_each_entry(rdev, &rio_devices, global_list)
-		if (rio_is_switch(rdev)) {
-			rio_lock_device(rdev->net->hport, rdev->destid,
-					rdev->hopcount, 1000);
-			for (i = 0;
-			     i < RIO_MAX_ROUTE_ENTRIES(rdev->net->hport->sys_size);
-			     i++) {
-				if (rio_route_get_entry(rdev,
-					RIO_GLOBAL_TABLE, i, &sport, 0) < 0)
-					continue;
-				rdev->rswitch->route_table[i] = sport;
-			}
+	list_for_each_entry(rswitch, &net->switches, node) {
+		rdev = sw_to_rio_dev(rswitch);
 
-			rio_unlock_device(rdev->net->hport,
-					  rdev->destid,
-					  rdev->hopcount);
+		rio_lock_device(net->hport, rdev->destid,
+				rdev->hopcount, 1000);
+		for (i = 0;
+		     i < RIO_MAX_ROUTE_ENTRIES(net->hport->sys_size);
+		     i++) {
+			if (rio_route_get_entry(rdev, RIO_GLOBAL_TABLE,
+						i, &sport, 0) < 0)
+				continue;
+			rswitch->route_table[i] = sport;
 		}
+
+		rio_unlock_device(net->hport, rdev->destid, rdev->hopcount);
+	}
 }
 
 /**
@@ -1284,7 +1286,7 @@ enum_done:
 			goto bail;
 		}
 
-		rio_build_route_tables();
+		rio_build_route_tables(net);
 	}
 
 	return 0;
diff -puN include/linux/rio.h~rapidio-use-device-lists-handling-on-per-net-basis include/linux/rio.h
--- a/include/linux/rio.h~rapidio-use-device-lists-handling-on-per-net-basis
+++ a/include/linux/rio.h
@@ -275,6 +275,7 @@ struct rio_mport {
 struct rio_net {
 	struct list_head node;	/* node in list of networks */
 	struct list_head devices;	/* list of devices in this net */
+	struct list_head switches;	/* list of switches in this net */
 	struct list_head mports;	/* list of ports accessing net */
 	struct rio_mport *hport;	/* primary port for accessing net */
 	unsigned char id;	/* RIO network ID */
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

origin.patch

