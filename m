From: akpm@osdl.org
Subject: + rapidio-fix-multi-switch-enumeration.patch added to -mm tree
Date: Thu, 01 Feb 2007 14:38:15 -0800
Message-ID: <200702012238.l11McF1M024992@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45112 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932861AbXBAWio (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Feb 2007 17:38:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Alexandre.Bounine@tundra.com, alexandreb@tundra.com, mporter@kernel.crashing.org


The patch titled
     rapidio: fix multi-switch enumeration
has been added to the -mm tree.  Its filename is
     rapidio-fix-multi-switch-enumeration.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rapidio: fix multi-switch enumeration
From: "Alexandre Bounine" <Alexandre.Bounine@tundra.com>

This patch contains two fixes for RapisIO enumeration logic:

1. Fix enumeration in configurations with multiple switches. The patch adds:

   a. Enumeration of an empty switch.  Empty switch is a switch that
      does not have any endpoint devices attached to it (except host device
      or previous switch in a chain).  New code assigns a phony destination
      ID associated with the switch and sets up corresponding routes.

   b. Adds a second pass to the enumeration to setup routes to
      devices discovered after switch was scanned.

2. Fix enumeration failure when riohdid parameter has non-zero value. 
   Current version fails to setup response path to the host when it has
   destination ID other that 0.

Signed-off-by: Alexandre Bounine <alexandreb@tundra.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/rapidio/rio-scan.c |  118 +++++++++++++++++++++++++----------
 include/linux/rio.h        |    1 
 2 files changed, 88 insertions(+), 31 deletions(-)

diff -puN drivers/rapidio/rio-scan.c~rapidio-fix-multi-switch-enumeration drivers/rapidio/rio-scan.c
--- a/drivers/rapidio/rio-scan.c~rapidio-fix-multi-switch-enumeration
+++ a/drivers/rapidio/rio-scan.c
@@ -326,14 +326,17 @@ static struct rio_dev *rio_setup_device(
 	rio_mport_read_config_32(port, destid, hopcount, RIO_DST_OPS_CAR,
 				 &rdev->dst_ops);
 
-	if (rio_device_has_destid(port, rdev->src_ops, rdev->dst_ops)
-	    && do_enum) {
-		rio_set_device_id(port, destid, hopcount, next_destid);
-		rdev->destid = next_destid++;
-		if (next_destid == port->host_deviceid)
-			next_destid++;
+	if (rio_device_has_destid(port, rdev->src_ops, rdev->dst_ops)) {
+		if (do_enum) {
+			rio_set_device_id(port, destid, hopcount, next_destid);
+			rdev->destid = next_destid++;
+			if (next_destid == port->host_deviceid)
+				next_destid++;
+		} else
+			rdev->destid = rio_get_device_id(port, destid, hopcount);
 	} else
-		rdev->destid = rio_get_device_id(port, destid, hopcount);
+		/* Switch device has an associated destID */
+		rdev->destid = RIO_INVALID_DESTID;
 
 	/* If a PE has both switch and other functions, show it as a switch */
 	if (rio_is_switch(rdev)) {
@@ -347,7 +350,7 @@ static struct rio_dev *rio_setup_device(
 		}
 		rswitch->switchid = next_switchid;
 		rswitch->hopcount = hopcount;
-		rswitch->destid = 0xffff;
+		rswitch->destid = destid;
 		/* Initialize switch route table */
 		for (rdid = 0; rdid < RIO_MAX_ROUTE_ENTRIES; rdid++)
 			rswitch->route_table[rdid] = RIO_INVALID_ROUTE;
@@ -422,7 +425,7 @@ rio_sport_is_active(struct rio_mport *po
 /**
  * rio_route_add_entry- Add a route entry to a switch routing table
  * @mport: Master port to send transaction
- * @rdev: Switch device
+ * @rswitch: Switch device
  * @table: Routing table ID
  * @route_destid: Destination ID to be routed
  * @route_port: Port number to be routed
@@ -434,18 +437,18 @@ rio_sport_is_active(struct rio_mport *po
  * %RIO_GLOBAL_TABLE in @table. Returns %0 on success or %-EINVAL
  * on failure.
  */
-static int rio_route_add_entry(struct rio_mport *mport, struct rio_dev *rdev,
+static int rio_route_add_entry(struct rio_mport *mport, struct rio_switch *rswitch,
 			       u16 table, u16 route_destid, u8 route_port)
 {
-	return rdev->rswitch->add_entry(mport, rdev->rswitch->destid,
-					rdev->rswitch->hopcount, table,
+	return rswitch->add_entry(mport, rswitch->destid,
+					rswitch->hopcount, table,
 					route_destid, route_port);
 }
 
 /**
  * rio_route_get_entry- Read a route entry in a switch routing table
  * @mport: Master port to send transaction
- * @rdev: Switch device
+ * @rswitch: Switch device
  * @table: Routing table ID
  * @route_destid: Destination ID to be routed
  * @route_port: Pointer to read port number into
@@ -458,11 +461,11 @@ static int rio_route_add_entry(struct ri
  * on failure.
  */
 static int
-rio_route_get_entry(struct rio_mport *mport, struct rio_dev *rdev, u16 table,
+rio_route_get_entry(struct rio_mport *mport, struct rio_switch *rswitch, u16 table,
 		    u16 route_destid, u8 * route_port)
 {
-	return rdev->rswitch->get_entry(mport, rdev->rswitch->destid,
-					rdev->rswitch->hopcount, table,
+	return rswitch->get_entry(mport, rswitch->destid,
+					rswitch->hopcount, table,
 					route_destid, route_port);
 }
 
@@ -552,6 +555,8 @@ static int rio_enum_peer(struct rio_net 
 	int port_num;
 	int num_ports;
 	int cur_destid;
+	int sw_destid;
+	int sw_inport;
 	struct rio_dev *rdev;
 	u16 destid;
 	int tmp;
@@ -594,15 +599,17 @@ static int rio_enum_peer(struct rio_net 
 
 	if (rio_is_switch(rdev)) {
 		next_switchid++;
+		sw_inport = rio_get_swpinfo_inport(port, RIO_ANY_DESTID, hopcount);
+		rio_route_add_entry(port, rdev->rswitch, RIO_GLOBAL_TABLE,
+				    port->host_deviceid, sw_inport);
+		rdev->rswitch->route_table[port->host_deviceid] = sw_inport;
 
 		for (destid = 0; destid < next_destid; destid++) {
-			rio_route_add_entry(port, rdev, RIO_GLOBAL_TABLE,
-					    destid, rio_get_swpinfo_inport(port,
-									   RIO_ANY_DESTID,
-									   hopcount));
-			rdev->rswitch->route_table[destid] =
-			    rio_get_swpinfo_inport(port, RIO_ANY_DESTID,
-						   hopcount);
+			if (destid == port->host_deviceid)
+				continue;
+			rio_route_add_entry(port, rdev->rswitch, RIO_GLOBAL_TABLE,
+					    destid, sw_inport);
+			rdev->rswitch->route_table[destid] = sw_inport;
 		}
 
 		num_ports =
@@ -610,9 +617,9 @@ static int rio_enum_peer(struct rio_net 
 		pr_debug(
 		    "RIO: found %s (vid %4.4x did %4.4x) with %d ports\n",
 		    rio_name(rdev), rdev->vid, rdev->did, num_ports);
+		sw_destid = next_destid;
 		for (port_num = 0; port_num < num_ports; port_num++) {
-			if (rio_get_swpinfo_inport
-			    (port, RIO_ANY_DESTID, hopcount) == port_num)
+			if (sw_inport == port_num)
 				continue;
 
 			cur_destid = next_destid;
@@ -622,7 +629,7 @@ static int rio_enum_peer(struct rio_net 
 				pr_debug(
 				    "RIO: scanning device on port %d\n",
 				    port_num);
-				rio_route_add_entry(port, rdev,
+				rio_route_add_entry(port, rdev->rswitch,
 						    RIO_GLOBAL_TABLE,
 						    RIO_ANY_DESTID, port_num);
 
@@ -633,7 +640,9 @@ static int rio_enum_peer(struct rio_net 
 				if (next_destid > cur_destid) {
 					for (destid = cur_destid;
 					     destid < next_destid; destid++) {
-						rio_route_add_entry(port, rdev,
+						if (destid == port->host_deviceid)
+							continue;
+						rio_route_add_entry(port, rdev->rswitch,
 								    RIO_GLOBAL_TABLE,
 								    destid,
 								    port_num);
@@ -641,10 +650,18 @@ static int rio_enum_peer(struct rio_net 
 						    route_table[destid] =
 						    port_num;
 					}
-					rdev->rswitch->destid = cur_destid;
 				}
 			}
 		}
+
+		/* Check for empty switch */
+		if (next_destid == sw_destid) {
+			next_destid++;
+			if (next_destid == port->host_deviceid)
+				next_destid++;
+		}
+
+		rdev->rswitch->destid = sw_destid;
 	} else
 		pr_debug("RIO: found %s (vid %4.4x did %4.4x)\n",
 		    rio_name(rdev), rdev->vid, rdev->did);
@@ -721,7 +738,7 @@ rio_disc_peer(struct rio_net *net, struc
 				    port_num);
 				for (ndestid = 0; ndestid < RIO_ANY_DESTID;
 				     ndestid++) {
-					rio_route_get_entry(port, rdev,
+					rio_route_get_entry(port, rdev->rswitch,
 							    RIO_GLOBAL_TABLE,
 							    ndestid,
 							    &route_port);
@@ -798,6 +815,44 @@ static struct rio_net __devinit *rio_all
 }
 
 /**
+ * rio_update_route_tables- Updates route tables in switches
+ * @port: Master port associated with the RIO network
+ *
+ * For each enumerated device, ensure that each switch in a system
+ * has correct routing entries. Add routes for devices that where
+ * unknown dirung the first enumeration pass through the switch.
+ */
+static void rio_update_route_tables(struct rio_mport *port)
+{
+	struct rio_dev *rdev;
+	struct rio_switch *rswitch;
+	u8 sport;
+	u16 destid;
+
+	list_for_each_entry(rdev, &rio_devices, global_list) {
+
+		destid = (rio_is_switch(rdev))?rdev->rswitch->destid:rdev->destid;
+
+		list_for_each_entry(rswitch, &rio_switches, node) {
+
+			if (rio_is_switch(rdev)	&& (rdev->rswitch == rswitch))
+				continue;
+
+			if (RIO_INVALID_ROUTE == rswitch->route_table[destid]) {
+
+				sport = rio_get_swpinfo_inport(port,
+						rswitch->destid, rswitch->hopcount);
+
+				if (rswitch->add_entry)	{
+					rio_route_add_entry(port, rswitch, RIO_GLOBAL_TABLE, destid, sport);
+					rswitch->route_table[destid] = sport;
+				}
+			}
+		}
+	}
+}
+
+/**
  * rio_enum_mport- Start enumeration through a master port
  * @mport: Master port to send transactions
  *
@@ -838,6 +893,7 @@ int rio_enum_mport(struct rio_mport *mpo
 			rc = -EBUSY;
 			goto out;
 		}
+		rio_update_route_tables(mport);
 		rio_clear_locks(mport);
 	} else {
 		printk(KERN_INFO "RIO: master port %d link inactive\n",
@@ -865,8 +921,8 @@ static void rio_build_route_tables(void)
 	    if (rio_is_switch(rdev))
 		for (i = 0; i < RIO_MAX_ROUTE_ENTRIES; i++) {
 			if (rio_route_get_entry
-			    (rdev->net->hport, rdev, RIO_GLOBAL_TABLE, i,
-			     &sport) < 0)
+			    (rdev->net->hport, rdev->rswitch, RIO_GLOBAL_TABLE,
+			     i, &sport) < 0)
 				continue;
 			rdev->rswitch->route_table[i] = sport;
 		}
diff -puN include/linux/rio.h~rapidio-fix-multi-switch-enumeration include/linux/rio.h
--- a/include/linux/rio.h~rapidio-fix-multi-switch-enumeration
+++ a/include/linux/rio.h
@@ -25,6 +25,7 @@
 
 #define RIO_ANY_DESTID		0xff
 #define RIO_NO_HOPCOUNT		-1
+#define RIO_INVALID_DESTID	0xffff
 
 #define RIO_MAX_MPORT_RESOURCES	16
 #define RIO_MAX_DEV_RESOURCES	16
_

Patches currently in -mm which might be from Alexandre.Bounine@tundra.com are

rapidio-fix-multi-switch-enumeration.patch
