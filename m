From: akpm@linux-foundation.org
Subject: + rapidio-add-switch-locking-during-discovery.patch added to -mm tree
Date: Mon, 12 Apr 2010 20:55:50 -0400
Message-ID: <201004130357.o3D3vSEp011276@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37084 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751819Ab0DMD5r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Apr 2010 23:57:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexandre.bounine@idt.com, galak@kernel.crashing.org, leoli@freescale.com, mporter@kernel.crashing.org, thomas.moll@sysgo.com


The patch titled
     rapidio: add switch locking during discovery
has been added to the -mm tree.  Its filename is
     rapidio-add-switch-locking-during-discovery.patch

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
Subject: rapidio: add switch locking during discovery
From: Alexandre Bounine <alexandre.bounine@idt.com>

Add switch access locking during RapidIO discovery.  Access lock is
required when reading switch routing table contents due to indexed
mechanism of RT addressing.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Tested-by: Thomas Moll <thomas.moll@sysgo.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio-scan.c |  164 ++++++++++++++++++++++++++++++-----
 1 file changed, 144 insertions(+), 20 deletions(-)

diff -puN drivers/rapidio/rio-scan.c~rapidio-add-switch-locking-during-discovery drivers/rapidio/rio-scan.c
--- a/drivers/rapidio/rio-scan.c~rapidio-add-switch-locking-during-discovery
+++ a/drivers/rapidio/rio-scan.c
@@ -457,12 +457,87 @@ rio_sport_is_active(struct rio_mport *po
 }
 
 /**
+ * rio_lock_device - Acquires host device lock for specified device
+ * @port: Master port to send transaction
+ * @destid: Destination ID for device/switch
+ * @hopcount: Hopcount to reach switch
+ * @wait_ms: Max wait time in msec (0 = no timeout)
+ *
+ * Attepts to acquire host device lock for specified device
+ * Returns 0 if device lock acquired or EINVAL if timeout expires.
+ */
+static int
+rio_lock_device(struct rio_mport *port, u16 destid, u8 hopcount, int wait_ms)
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
+
+/**
+ * rio_unlock_device - Releases host device lock for specified device
+ * @port: Master port to send transaction
+ * @destid: Destination ID for device/switch
+ * @hopcount: Hopcount to reach switch
+ *
+ * Returns 0 if device lock released or EINVAL if fails.
+ */
+static int
+rio_unlock_device(struct rio_mport *port, u16 destid, u8 hopcount)
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
+
+/**
  * rio_route_add_entry- Add a route entry to a switch routing table
  * @mport: Master port to send transaction
  * @rswitch: Switch device
  * @table: Routing table ID
  * @route_destid: Destination ID to be routed
  * @route_port: Port number to be routed
+ * @lock: lock switch device flag
  *
  * Calls the switch specific add_entry() method to add a route entry
  * on a switch. The route table can be specified using the @table
@@ -471,12 +546,26 @@ rio_sport_is_active(struct rio_mport *po
  * %RIO_GLOBAL_TABLE in @table. Returns %0 on success or %-EINVAL
  * on failure.
  */
-static int rio_route_add_entry(struct rio_mport *mport, struct rio_switch *rswitch,
-			       u16 table, u16 route_destid, u8 route_port)
+static int
+rio_route_add_entry(struct rio_mport *mport, struct rio_switch *rswitch,
+		    u16 table, u16 route_destid, u8 route_port, int lock)
 {
-	return rswitch->add_entry(mport, rswitch->destid,
+	int rc;
+
+	if (lock) {
+		rc = rio_lock_device(mport, rswitch->destid,
+				     rswitch->hopcount, 1000);
+		if (rc)
+			return rc;
+	}
+
+	rc = rswitch->add_entry(mport, rswitch->destid,
 					rswitch->hopcount, table,
 					route_destid, route_port);
+	if (lock)
+		rio_unlock_device(mport, rswitch->destid, rswitch->hopcount);
+
+	return rc;
 }
 
 /**
@@ -486,6 +575,7 @@ static int rio_route_add_entry(struct ri
  * @table: Routing table ID
  * @route_destid: Destination ID to be routed
  * @route_port: Pointer to read port number into
+ * @lock: lock switch device flag
  *
  * Calls the switch specific get_entry() method to read a route entry
  * in a switch. The route table can be specified using the @table
@@ -496,11 +586,24 @@ static int rio_route_add_entry(struct ri
  */
 static int
 rio_route_get_entry(struct rio_mport *mport, struct rio_switch *rswitch, u16 table,
-		    u16 route_destid, u8 * route_port)
+		    u16 route_destid, u8 *route_port, int lock)
 {
-	return rswitch->get_entry(mport, rswitch->destid,
+	int rc;
+
+	if (lock) {
+		rc = rio_lock_device(mport, rswitch->destid,
+				     rswitch->hopcount, 1000);
+		if (rc)
+			return rc;
+	}
+
+	rc = rswitch->get_entry(mport, rswitch->destid,
 					rswitch->hopcount, table,
 					route_destid, route_port);
+	if (lock)
+		rio_unlock_device(mport, rswitch->destid, rswitch->hopcount);
+
+	return rc;
 }
 
 /**
@@ -640,14 +743,14 @@ static int __devinit rio_enum_peer(struc
 		sw_inport = rio_get_swpinfo_inport(port,
 				RIO_ANY_DESTID(port->sys_size), hopcount);
 		rio_route_add_entry(port, rdev->rswitch, RIO_GLOBAL_TABLE,
-				    port->host_deviceid, sw_inport);
+				    port->host_deviceid, sw_inport, 0);
 		rdev->rswitch->route_table[port->host_deviceid] = sw_inport;
 
 		for (destid = 0; destid < next_destid; destid++) {
 			if (destid == port->host_deviceid)
 				continue;
 			rio_route_add_entry(port, rdev->rswitch, RIO_GLOBAL_TABLE,
-					    destid, sw_inport);
+					    destid, sw_inport, 0);
 			rdev->rswitch->route_table[destid] = sw_inport;
 		}
 
@@ -673,7 +776,7 @@ static int __devinit rio_enum_peer(struc
 				rio_route_add_entry(port, rdev->rswitch,
 						RIO_GLOBAL_TABLE,
 						RIO_ANY_DESTID(port->sys_size),
-						port_num);
+						port_num, 0);
 
 				if (rio_enum_peer(net, port, hopcount + 1) < 0)
 					return -1;
@@ -687,7 +790,8 @@ static int __devinit rio_enum_peer(struc
 						rio_route_add_entry(port, rdev->rswitch,
 								    RIO_GLOBAL_TABLE,
 								    destid,
-								    port_num);
+								    port_num,
+								    0);
 						rdev->rswitch->
 						    route_table[destid] =
 						    port_num;
@@ -778,17 +882,21 @@ rio_disc_peer(struct rio_net *net, struc
 				pr_debug(
 				    "RIO: scanning device on port %d\n",
 				    port_num);
+
+				rio_lock_device(port, destid, hopcount, 1000);
+
 				for (ndestid = 0;
 				     ndestid < RIO_ANY_DESTID(port->sys_size);
 				     ndestid++) {
 					rio_route_get_entry(port, rdev->rswitch,
 							    RIO_GLOBAL_TABLE,
 							    ndestid,
-							    &route_port);
+							    &route_port, 0);
 					if (route_port == port_num)
 						break;
 				}
 
+				rio_unlock_device(port, destid, hopcount);
 				if (rio_disc_peer
 				    (net, port, ndestid, hopcount + 1) < 0)
 					return -1;
@@ -889,7 +997,9 @@ static void rio_update_route_tables(stru
 						rswitch->destid, rswitch->hopcount);
 
 				if (rswitch->add_entry)	{
-					rio_route_add_entry(port, rswitch, RIO_GLOBAL_TABLE, destid, sport);
+					rio_route_add_entry(port, rswitch,
+						RIO_GLOBAL_TABLE, destid,
+						sport, 0);
 					rswitch->route_table[destid] = sport;
 				}
 			}
@@ -963,15 +1073,22 @@ static void rio_build_route_tables(void)
 	u8 sport;
 
 	list_for_each_entry(rdev, &rio_devices, global_list)
-	    if (rio_is_switch(rdev))
-		for (i = 0;
-		     i < RIO_MAX_ROUTE_ENTRIES(rdev->net->hport->sys_size);
-		     i++) {
-			if (rio_route_get_entry
-			    (rdev->net->hport, rdev->rswitch, RIO_GLOBAL_TABLE,
-			     i, &sport) < 0)
-				continue;
-			rdev->rswitch->route_table[i] = sport;
+		if (rio_is_switch(rdev)) {
+			rio_lock_device(rdev->net->hport, rdev->rswitch->destid,
+					rdev->rswitch->hopcount, 1000);
+			for (i = 0;
+			     i < RIO_MAX_ROUTE_ENTRIES(rdev->net->hport->sys_size);
+			     i++) {
+				if (rio_route_get_entry
+				    (rdev->net->hport, rdev->rswitch,
+				     RIO_GLOBAL_TABLE, i, &sport, 0) < 0)
+					continue;
+				rdev->rswitch->route_table[i] = sport;
+			}
+
+			rio_unlock_device(rdev->net->hport,
+					  rdev->rswitch->destid,
+					  rdev->rswitch->hopcount);
 		}
 }
 
@@ -1030,6 +1147,13 @@ int __devinit rio_disc_mport(struct rio_
 		del_timer_sync(&rio_enum_timer);
 
 		pr_debug("done\n");
+
+		/* Read DestID assigned by enumerator */
+		rio_local_read_config_32(mport, RIO_DID_CSR,
+					 &mport->host_deviceid);
+		mport->host_deviceid = RIO_GET_DID(mport->sys_size,
+						   mport->host_deviceid);
+
 		if (rio_disc_peer(net, mport, RIO_ANY_DESTID(mport->sys_size),
 					0) < 0) {
 			printk(KERN_INFO
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

rapidio-add-idt-cps-tsi-switches.patch
rapidio-add-switch-locking-during-discovery.patch
rapidio-add-port-write-handling-for-em.patch
rapidio-powerpc-85xx-add-port-write-message-handler-for-srio-port.patch
rapidio-powerpc-85xx-add-mchk-handler-for-srio-port.patch

