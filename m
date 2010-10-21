From: akpm@linux-foundation.org
Subject: + rapidio-use-common-destid-storage-for-endpoints-and-switches.patch added to -mm tree
Date: Thu, 21 Oct 2010 12:43:02 -0700
Message-ID: <201010211943.o9LJh2NA032084@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55918 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757199Ab0JUTpm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Oct 2010 15:45:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexandre.bounine@idt.com, galak@kernel.crashing.org, leoli@freescale.com, micha@neli.hopto.org, mporter@kernel.crashing.org, thomas.moll@sysgo.com


The patch titled
     rapidio: use common destid storage for endpoints and switches
has been added to the -mm tree.  Its filename is
     rapidio-use-common-destid-storage-for-endpoints-and-switches.patch

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
Subject: rapidio: use common destid storage for endpoints and switches
From: Alexandre Bounine <alexandre.bounine@idt.com>

Change code to use one storage location common for switches and endpoints.
This eliminates unnecessary device type checks during basic access
operations.  Logic that assigns destid to RIO devices stays unchanged - as
before, switches use an associated destid because they do not have their
own.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Thomas Moll <thomas.moll@sysgo.com>
Cc: Micha Nelissen <micha@neli.hopto.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio-scan.c          |   84 ++++++++++++-----------
 drivers/rapidio/rio.c               |   74 ++++++--------------
 drivers/rapidio/switches/idt_gen2.c |   93 ++++++++------------------
 drivers/rapidio/switches/idtcps.c   |    6 -
 drivers/rapidio/switches/tsi568.c   |   13 +--
 drivers/rapidio/switches/tsi57x.c   |   56 ++++++---------
 include/linux/rio.h                 |    8 --
 include/linux/rio_drv.h             |   72 +++-----------------
 8 files changed, 141 insertions(+), 265 deletions(-)

diff -puN drivers/rapidio/rio-scan.c~rapidio-use-common-destid-storage-for-endpoints-and-switches drivers/rapidio/rio-scan.c
--- a/drivers/rapidio/rio-scan.c~rapidio-use-common-destid-storage-for-endpoints-and-switches
+++ a/drivers/rapidio/rio-scan.c
@@ -437,9 +437,15 @@ static struct rio_dev __devinit *rio_set
 				next_destid++;
 		} else
 			rdev->destid = rio_get_device_id(port, destid, hopcount);
-	} else
-		/* Switch device has an associated destID */
-		rdev->destid = RIO_INVALID_DESTID;
+
+		rdev->hopcount = 0xff;
+	} else {
+		/* Switch device has an associated destID which
+		 * will be adjusted later
+		 */
+		rdev->destid = destid;
+		rdev->hopcount = hopcount;
+	}
 
 	/* If a PE has both switch and other functions, show it as a switch */
 	if (rio_is_switch(rdev)) {
@@ -450,8 +456,6 @@ static struct rio_dev __devinit *rio_set
 		if (!rswitch)
 			goto cleanup;
 		rswitch->switchid = next_switchid;
-		rswitch->hopcount = hopcount;
-		rswitch->destid = destid;
 		rswitch->port_ok = 0;
 		rswitch->route_table = kzalloc(sizeof(u8)*
 					RIO_MAX_ROUTE_ENTRIES(port->sys_size),
@@ -632,8 +636,7 @@ rio_unlock_device(struct rio_mport *port
 
 /**
  * rio_route_add_entry- Add a route entry to a switch routing table
- * @mport: Master port to send transaction
- * @rswitch: Switch device
+ * @rdev: RIO device
  * @table: Routing table ID
  * @route_destid: Destination ID to be routed
  * @route_port: Port number to be routed
@@ -647,31 +650,31 @@ rio_unlock_device(struct rio_mport *port
  * on failure.
  */
 static int
-rio_route_add_entry(struct rio_mport *mport, struct rio_switch *rswitch,
+rio_route_add_entry(struct rio_dev *rdev,
 		    u16 table, u16 route_destid, u8 route_port, int lock)
 {
 	int rc;
 
 	if (lock) {
-		rc = rio_lock_device(mport, rswitch->destid,
-				     rswitch->hopcount, 1000);
+		rc = rio_lock_device(rdev->net->hport, rdev->destid,
+				     rdev->hopcount, 1000);
 		if (rc)
 			return rc;
 	}
 
-	rc = rswitch->add_entry(mport, rswitch->destid,
-					rswitch->hopcount, table,
-					route_destid, route_port);
+	rc = rdev->rswitch->add_entry(rdev->net->hport, rdev->destid,
+				      rdev->hopcount, table,
+				      route_destid, route_port);
 	if (lock)
-		rio_unlock_device(mport, rswitch->destid, rswitch->hopcount);
+		rio_unlock_device(rdev->net->hport, rdev->destid,
+				  rdev->hopcount);
 
 	return rc;
 }
 
 /**
  * rio_route_get_entry- Read a route entry in a switch routing table
- * @mport: Master port to send transaction
- * @rswitch: Switch device
+ * @rdev: RIO device
  * @table: Routing table ID
  * @route_destid: Destination ID to be routed
  * @route_port: Pointer to read port number into
@@ -685,23 +688,24 @@ rio_route_add_entry(struct rio_mport *mp
  * on failure.
  */
 static int
-rio_route_get_entry(struct rio_mport *mport, struct rio_switch *rswitch, u16 table,
+rio_route_get_entry(struct rio_dev *rdev, u16 table,
 		    u16 route_destid, u8 *route_port, int lock)
 {
 	int rc;
 
 	if (lock) {
-		rc = rio_lock_device(mport, rswitch->destid,
-				     rswitch->hopcount, 1000);
+		rc = rio_lock_device(rdev->net->hport, rdev->destid,
+				     rdev->hopcount, 1000);
 		if (rc)
 			return rc;
 	}
 
-	rc = rswitch->get_entry(mport, rswitch->destid,
-					rswitch->hopcount, table,
-					route_destid, route_port);
+	rc = rdev->rswitch->get_entry(rdev->net->hport, rdev->destid,
+				      rdev->hopcount, table,
+				      route_destid, route_port);
 	if (lock)
-		rio_unlock_device(mport, rswitch->destid, rswitch->hopcount);
+		rio_unlock_device(rdev->net->hport, rdev->destid,
+				  rdev->hopcount);
 
 	return rc;
 }
@@ -811,14 +815,14 @@ static int __devinit rio_enum_peer(struc
 	if (rio_is_switch(rdev)) {
 		next_switchid++;
 		sw_inport = RIO_GET_PORT_NUM(rdev->swpinfo);
-		rio_route_add_entry(port, rdev->rswitch, RIO_GLOBAL_TABLE,
+		rio_route_add_entry(rdev, RIO_GLOBAL_TABLE,
 				    port->host_deviceid, sw_inport, 0);
 		rdev->rswitch->route_table[port->host_deviceid] = sw_inport;
 
 		for (destid = 0; destid < next_destid; destid++) {
 			if (destid == port->host_deviceid)
 				continue;
-			rio_route_add_entry(port, rdev->rswitch, RIO_GLOBAL_TABLE,
+			rio_route_add_entry(rdev, RIO_GLOBAL_TABLE,
 					    destid, sw_inport, 0);
 			rdev->rswitch->route_table[destid] = sw_inport;
 		}
@@ -850,8 +854,7 @@ static int __devinit rio_enum_peer(struc
 				    "RIO: scanning device on port %d\n",
 				    port_num);
 				rdev->rswitch->port_ok |= (1 << port_num);
-				rio_route_add_entry(port, rdev->rswitch,
-						RIO_GLOBAL_TABLE,
+				rio_route_add_entry(rdev, RIO_GLOBAL_TABLE,
 						RIO_ANY_DESTID(port->sys_size),
 						port_num, 0);
 
@@ -865,7 +868,7 @@ static int __devinit rio_enum_peer(struc
 					     destid < next_destid; destid++) {
 						if (destid == port->host_deviceid)
 							continue;
-						rio_route_add_entry(port, rdev->rswitch,
+						rio_route_add_entry(rdev,
 								    RIO_GLOBAL_TABLE,
 								    destid,
 								    port_num,
@@ -904,7 +907,7 @@ static int __devinit rio_enum_peer(struc
 				next_destid++;
 		}
 
-		rdev->rswitch->destid = sw_destid;
+		rdev->destid = sw_destid;
 	} else
 		pr_debug("RIO: found %s (vid %4.4x did %4.4x)\n",
 		    rio_name(rdev), rdev->vid, rdev->did);
@@ -958,7 +961,7 @@ rio_disc_peer(struct rio_net *net, struc
 		next_switchid++;
 
 		/* Associated destid is how we accessed this switch */
-		rdev->rswitch->destid = destid;
+		rdev->destid = destid;
 
 		pr_debug(
 		    "RIO: found %s (vid %4.4x did %4.4x) with %d ports\n",
@@ -981,7 +984,7 @@ rio_disc_peer(struct rio_net *net, struc
 				for (ndestid = 0;
 				     ndestid < RIO_ANY_DESTID(port->sys_size);
 				     ndestid++) {
-					rio_route_get_entry(port, rdev->rswitch,
+					rio_route_get_entry(rdev,
 							    RIO_GLOBAL_TABLE,
 							    ndestid,
 							    &route_port, 0);
@@ -1076,7 +1079,7 @@ static void rio_update_route_tables(stru
 
 	list_for_each_entry(rdev, &rio_devices, global_list) {
 
-		destid = (rio_is_switch(rdev))?rdev->rswitch->destid:rdev->destid;
+		destid = rdev->destid;
 
 		list_for_each_entry(rswitch, &rio_switches, node) {
 
@@ -1085,13 +1088,13 @@ static void rio_update_route_tables(stru
 
 			if (RIO_INVALID_ROUTE == rswitch->route_table[destid]) {
 				/* Skip if destid ends in empty switch*/
-				if (rswitch->destid == destid)
+				if (rswitch->rdev->destid == destid)
 					continue;
 
 				sport = RIO_GET_PORT_NUM(rswitch->rdev->swpinfo);
 
 				if (rswitch->add_entry)	{
-					rio_route_add_entry(port, rswitch,
+					rio_route_add_entry(rswitch->rdev,
 						RIO_GLOBAL_TABLE, destid,
 						sport, 0);
 					rswitch->route_table[destid] = sport;
@@ -1203,21 +1206,20 @@ static void rio_build_route_tables(void)
 
 	list_for_each_entry(rdev, &rio_devices, global_list)
 		if (rio_is_switch(rdev)) {
-			rio_lock_device(rdev->net->hport, rdev->rswitch->destid,
-					rdev->rswitch->hopcount, 1000);
+			rio_lock_device(rdev->net->hport, rdev->destid,
+					rdev->hopcount, 1000);
 			for (i = 0;
 			     i < RIO_MAX_ROUTE_ENTRIES(rdev->net->hport->sys_size);
 			     i++) {
-				if (rio_route_get_entry
-				    (rdev->net->hport, rdev->rswitch,
-				     RIO_GLOBAL_TABLE, i, &sport, 0) < 0)
+				if (rio_route_get_entry(rdev,
+					RIO_GLOBAL_TABLE, i, &sport, 0) < 0)
 					continue;
 				rdev->rswitch->route_table[i] = sport;
 			}
 
 			rio_unlock_device(rdev->net->hport,
-					  rdev->rswitch->destid,
-					  rdev->rswitch->hopcount);
+					  rdev->destid,
+					  rdev->hopcount);
 		}
 }
 
diff -puN drivers/rapidio/rio.c~rapidio-use-common-destid-storage-for-endpoints-and-switches drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-use-common-destid-storage-for-endpoints-and-switches
+++ a/drivers/rapidio/rio.c
@@ -471,16 +471,9 @@ exit:
  */
 int rio_set_port_lockout(struct rio_dev *rdev, u32 pnum, int lock)
 {
-	u8 hopcount = 0xff;
-	u16 destid = rdev->destid;
 	u32 regval;
 
-	if (rdev->rswitch) {
-		destid = rdev->rswitch->destid;
-		hopcount = rdev->rswitch->hopcount;
-	}
-
-	rio_mport_read_config_32(rdev->net->hport, destid, hopcount,
+	rio_read_config_32(rdev,
 				 rdev->phys_efptr + RIO_PORT_N_CTL_CSR(pnum),
 				 &regval);
 	if (lock)
@@ -488,7 +481,7 @@ int rio_set_port_lockout(struct rio_dev 
 	else
 		regval &= ~RIO_PORT_N_CTL_LOCKOUT;
 
-	rio_mport_write_config_32(rdev->net->hport, destid, hopcount,
+	rio_write_config_32(rdev,
 				  rdev->phys_efptr + RIO_PORT_N_CTL_CSR(pnum),
 				  regval);
 	return 0;
@@ -507,7 +500,7 @@ static int
 rio_chk_dev_route(struct rio_dev *rdev, struct rio_dev **nrdev, int *npnum)
 {
 	u32 result;
-	int p_port, dstid, rc = -EIO;
+	int p_port, rc = -EIO;
 	struct rio_dev *prev = NULL;
 
 	/* Find switch with failed RIO link */
@@ -522,9 +515,7 @@ rio_chk_dev_route(struct rio_dev *rdev, 
 	if (prev == NULL)
 		goto err_out;
 
-	dstid = (rdev->pef & RIO_PEF_SWITCH) ?
-			rdev->rswitch->destid : rdev->destid;
-	p_port = prev->rswitch->route_table[dstid];
+	p_port = prev->rswitch->route_table[rdev->destid];
 
 	if (p_port != RIO_INVALID_ROUTE) {
 		pr_debug("RIO: link failed on [%s]-P%d\n",
@@ -567,15 +558,8 @@ rio_mport_chk_dev_access(struct rio_mpor
  */
 static int rio_chk_dev_access(struct rio_dev *rdev)
 {
-	u8 hopcount = 0xff;
-	u16 destid = rdev->destid;
-
-	if (rdev->rswitch) {
-		destid = rdev->rswitch->destid;
-		hopcount = rdev->rswitch->hopcount;
-	}
-
-	return rio_mport_chk_dev_access(rdev->net->hport, destid, hopcount);
+	return rio_mport_chk_dev_access(rdev->net->hport,
+					rdev->destid, rdev->hopcount);
 }
 
 /**
@@ -588,23 +572,20 @@ static int rio_chk_dev_access(struct rio
 static int
 rio_get_input_status(struct rio_dev *rdev, int pnum, u32 *lnkresp)
 {
-	struct rio_mport *mport = rdev->net->hport;
-	u16 destid = rdev->rswitch->destid;
-	u8 hopcount = rdev->rswitch->hopcount;
 	u32 regval;
 	int checkcount;
 
 	if (lnkresp) {
 		/* Read from link maintenance response register
 		 * to clear valid bit */
-		rio_mport_read_config_32(mport, destid, hopcount,
+		rio_read_config_32(rdev,
 			rdev->phys_efptr + RIO_PORT_N_MNT_RSP_CSR(pnum),
 			&regval);
 		udelay(50);
 	}
 
 	/* Issue Input-status command */
-	rio_mport_write_config_32(mport, destid, hopcount,
+	rio_write_config_32(rdev,
 		rdev->phys_efptr + RIO_PORT_N_MNT_REQ_CSR(pnum),
 		RIO_MNT_REQ_CMD_IS);
 
@@ -615,7 +596,7 @@ rio_get_input_status(struct rio_dev *rde
 	checkcount = 3;
 	while (checkcount--) {
 		udelay(50);
-		rio_mport_read_config_32(mport, destid, hopcount,
+		rio_read_config_32(rdev,
 			rdev->phys_efptr + RIO_PORT_N_MNT_RSP_CSR(pnum),
 			&regval);
 		if (regval & RIO_PORT_N_MNT_RSP_RVAL) {
@@ -635,15 +616,12 @@ rio_get_input_status(struct rio_dev *rde
  */
 static int rio_clr_err_stopped(struct rio_dev *rdev, u32 pnum, u32 err_status)
 {
-	struct rio_mport *mport = rdev->net->hport;
-	u16 destid = rdev->rswitch->destid;
-	u8 hopcount = rdev->rswitch->hopcount;
 	struct rio_dev *nextdev = rdev->rswitch->nextdev[pnum];
 	u32 regval;
 	u32 far_ackid, far_linkstat, near_ackid;
 
 	if (err_status == 0)
-		rio_mport_read_config_32(mport, destid, hopcount,
+		rio_read_config_32(rdev,
 			rdev->phys_efptr + RIO_PORT_N_ERR_STS_CSR(pnum),
 			&err_status);
 
@@ -661,7 +639,7 @@ static int rio_clr_err_stopped(struct ri
 			 pnum, regval);
 		far_ackid = (regval & RIO_PORT_N_MNT_RSP_ASTAT) >> 5;
 		far_linkstat = regval & RIO_PORT_N_MNT_RSP_LSTAT;
-		rio_mport_read_config_32(mport, destid, hopcount,
+		rio_read_config_32(rdev,
 			rdev->phys_efptr + RIO_PORT_N_ACK_STS_CSR(pnum),
 			&regval);
 		pr_debug("RIO_EM: SP%d_ACK_STS_CSR=0x%08x\n", pnum, regval);
@@ -679,9 +657,8 @@ static int rio_clr_err_stopped(struct ri
 			/* Align near outstanding/outbound ackIDs with
 			 * far inbound.
 			 */
-			rio_mport_write_config_32(mport, destid,
-				hopcount, rdev->phys_efptr +
-					RIO_PORT_N_ACK_STS_CSR(pnum),
+			rio_write_config_32(rdev,
+				rdev->phys_efptr + RIO_PORT_N_ACK_STS_CSR(pnum),
 				(near_ackid << 24) |
 					(far_ackid << 8) | far_ackid);
 			/* Align far outstanding/outbound ackIDs with
@@ -698,7 +675,7 @@ static int rio_clr_err_stopped(struct ri
 				pr_debug("RIO_EM: Invalid nextdev pointer (NULL)\n");
 		}
 rd_err:
-		rio_mport_read_config_32(mport, destid, hopcount,
+		rio_read_config_32(rdev,
 			rdev->phys_efptr + RIO_PORT_N_ERR_STS_CSR(pnum),
 			&err_status);
 		pr_debug("RIO_EM: SP%d_ERR_STS_CSR=0x%08x\n", pnum, err_status);
@@ -710,7 +687,7 @@ rd_err:
 				     RIO_GET_PORT_NUM(nextdev->swpinfo), NULL);
 		udelay(50);
 
-		rio_mport_read_config_32(mport, destid, hopcount,
+		rio_read_config_32(rdev,
 			rdev->phys_efptr + RIO_PORT_N_ERR_STS_CSR(pnum),
 			&err_status);
 		pr_debug("RIO_EM: SP%d_ERR_STS_CSR=0x%08x\n", pnum, err_status);
@@ -730,9 +707,6 @@ rd_err:
 int rio_inb_pwrite_handler(union rio_pw_msg *pw_msg)
 {
 	struct rio_dev *rdev;
-	struct rio_mport *mport;
-	u8 hopcount;
-	u16 destid;
 	u32 err_status, em_perrdet, em_ltlerrdet;
 	int rc, portnum;
 
@@ -800,17 +774,13 @@ int rio_inb_pwrite_handler(union rio_pw_
 		return 0;
 	}
 
-	mport = rdev->net->hport;
-	destid = rdev->rswitch->destid;
-	hopcount = rdev->rswitch->hopcount;
-
 	/*
 	 * Process the port-write notification from switch
 	 */
 	if (rdev->rswitch->em_handle)
 		rdev->rswitch->em_handle(rdev, portnum);
 
-	rio_mport_read_config_32(mport, destid, hopcount,
+	rio_read_config_32(rdev,
 			rdev->phys_efptr + RIO_PORT_N_ERR_STS_CSR(portnum),
 			&err_status);
 	pr_debug("RIO_PW: SP%d_ERR_STS_CSR=0x%08x\n", portnum, err_status);
@@ -840,7 +810,7 @@ int rio_inb_pwrite_handler(union rio_pw_
 			rdev->rswitch->port_ok &= ~(1 << portnum);
 			rio_set_port_lockout(rdev, portnum, 1);
 
-			rio_mport_write_config_32(mport, destid, hopcount,
+			rio_write_config_32(rdev,
 				rdev->phys_efptr +
 					RIO_PORT_N_ACK_STS_CSR(portnum),
 				RIO_PORT_N_ACK_CLEAR);
@@ -851,28 +821,28 @@ int rio_inb_pwrite_handler(union rio_pw_
 		}
 	}
 
-	rio_mport_read_config_32(mport, destid, hopcount,
+	rio_read_config_32(rdev,
 		rdev->em_efptr + RIO_EM_PN_ERR_DETECT(portnum), &em_perrdet);
 	if (em_perrdet) {
 		pr_debug("RIO_PW: RIO_EM_P%d_ERR_DETECT=0x%08x\n",
 			 portnum, em_perrdet);
 		/* Clear EM Port N Error Detect CSR */
-		rio_mport_write_config_32(mport, destid, hopcount,
+		rio_write_config_32(rdev,
 			rdev->em_efptr + RIO_EM_PN_ERR_DETECT(portnum), 0);
 	}
 
-	rio_mport_read_config_32(mport, destid, hopcount,
+	rio_read_config_32(rdev,
 		rdev->em_efptr + RIO_EM_LTL_ERR_DETECT, &em_ltlerrdet);
 	if (em_ltlerrdet) {
 		pr_debug("RIO_PW: RIO_EM_LTL_ERR_DETECT=0x%08x\n",
 			 em_ltlerrdet);
 		/* Clear EM L/T Layer Error Detect CSR */
-		rio_mport_write_config_32(mport, destid, hopcount,
+		rio_write_config_32(rdev,
 			rdev->em_efptr + RIO_EM_LTL_ERR_DETECT, 0);
 	}
 
 	/* Clear remaining error bits and Port-Write Pending bit */
-	rio_mport_write_config_32(mport, destid, hopcount,
+	rio_write_config_32(rdev,
 			rdev->phys_efptr + RIO_PORT_N_ERR_STS_CSR(portnum),
 			err_status);
 
diff -puN drivers/rapidio/switches/idt_gen2.c~rapidio-use-common-destid-storage-for-endpoints-and-switches drivers/rapidio/switches/idt_gen2.c
--- a/drivers/rapidio/switches/idt_gen2.c~rapidio-use-common-destid-storage-for-endpoints-and-switches
+++ a/drivers/rapidio/switches/idt_gen2.c
@@ -209,9 +209,6 @@ idtg2_get_domain(struct rio_mport *mport
 static int
 idtg2_em_init(struct rio_dev *rdev)
 {
-	struct rio_mport *mport = rdev->net->hport;
-	u16 destid = rdev->rswitch->destid;
-	u8 hopcount = rdev->rswitch->hopcount;
 	u32 regval;
 	int i, tmp;
 
@@ -220,29 +217,25 @@ idtg2_em_init(struct rio_dev *rdev)
 	 * All standard EM configuration should be performed at upper level.
 	 */
 
-	pr_debug("RIO: %s [%d:%d]\n", __func__, destid, hopcount);
+	pr_debug("RIO: %s [%d:%d]\n", __func__, rdev->destid, rdev->hopcount);
 
 	/* Set Port-Write info CSR: PRIO=3 and CRF=1 */
-	rio_mport_write_config_32(mport, destid, hopcount,
-			IDT_PW_INFO_CSR, 0x0000e000);
+	rio_write_config_32(rdev, IDT_PW_INFO_CSR, 0x0000e000);
 
 	/*
 	 * Configure LT LAYER error reporting.
 	 */
 
 	/* Enable standard (RIO.p8) error reporting */
-	rio_mport_write_config_32(mport, destid, hopcount,
-			IDT_LT_ERR_REPORT_EN,
+	rio_write_config_32(rdev, IDT_LT_ERR_REPORT_EN,
 			REM_LTL_ERR_ILLTRAN | REM_LTL_ERR_UNSOLR |
 			REM_LTL_ERR_UNSUPTR);
 
 	/* Use Port-Writes for LT layer error reporting.
 	 * Enable per-port reset
 	 */
-	rio_mport_read_config_32(mport, destid, hopcount,
-			IDT_DEV_CTRL_1, &regval);
-	rio_mport_write_config_32(mport, destid, hopcount,
-			IDT_DEV_CTRL_1,
+	rio_read_config_32(rdev, IDT_DEV_CTRL_1, &regval);
+	rio_write_config_32(rdev, IDT_DEV_CTRL_1,
 			regval | IDT_DEV_CTRL_1_GENPW | IDT_DEV_CTRL_1_PRSTBEH);
 
 	/*
@@ -250,45 +243,40 @@ idtg2_em_init(struct rio_dev *rdev)
 	 */
 
 	/* Report all RIO.p8 errors supported by device */
-	rio_mport_write_config_32(mport, destid, hopcount,
-			IDT_PORT_ERR_REPORT_EN_BC, 0x807e8037);
+	rio_write_config_32(rdev, IDT_PORT_ERR_REPORT_EN_BC, 0x807e8037);
 
 	/* Configure reporting of implementation specific errors/events */
-	rio_mport_write_config_32(mport, destid, hopcount,
-			IDT_PORT_ISERR_REPORT_EN_BC, IDT_PORT_INIT_TX_ACQUIRED);
+	rio_write_config_32(rdev, IDT_PORT_ISERR_REPORT_EN_BC,
+			    IDT_PORT_INIT_TX_ACQUIRED);
 
 	/* Use Port-Writes for port error reporting and enable error logging */
 	tmp = RIO_GET_TOTAL_PORTS(rdev->swpinfo);
 	for (i = 0; i < tmp; i++) {
-		rio_mport_read_config_32(mport, destid, hopcount,
-				IDT_PORT_OPS(i), &regval);
-		rio_mport_write_config_32(mport, destid, hopcount,
+		rio_read_config_32(rdev, IDT_PORT_OPS(i), &regval);
+		rio_write_config_32(rdev,
 				IDT_PORT_OPS(i), regval | IDT_PORT_OPS_GENPW |
 				IDT_PORT_OPS_PL_ELOG |
 				IDT_PORT_OPS_LL_ELOG |
 				IDT_PORT_OPS_LT_ELOG);
 	}
 	/* Overwrite error log if full */
-	rio_mport_write_config_32(mport, destid, hopcount,
-			IDT_ERR_CAP, IDT_ERR_CAP_LOG_OVERWR);
+	rio_write_config_32(rdev, IDT_ERR_CAP, IDT_ERR_CAP_LOG_OVERWR);
 
 	/*
 	 * Configure LANE error reporting.
 	 */
 
 	/* Disable line error reporting */
-	rio_mport_write_config_32(mport, destid, hopcount,
-			IDT_LANE_ERR_REPORT_EN_BC, 0);
+	rio_write_config_32(rdev, IDT_LANE_ERR_REPORT_EN_BC, 0);
 
 	/* Use Port-Writes for lane error reporting (when enabled)
 	 * (do per-lane update because lanes may have different configuration)
 	 */
 	tmp = (rdev->did == RIO_DID_IDTCPS1848) ? 48 : 16;
 	for (i = 0; i < tmp; i++) {
-		rio_mport_read_config_32(mport, destid, hopcount,
-				IDT_LANE_CTRL(i), &regval);
-		rio_mport_write_config_32(mport, destid, hopcount,
-				IDT_LANE_CTRL(i), regval | IDT_LANE_CTRL_GENPW);
+		rio_read_config_32(rdev, IDT_LANE_CTRL(i), &regval);
+		rio_write_config_32(rdev, IDT_LANE_CTRL(i),
+				    regval | IDT_LANE_CTRL_GENPW);
 	}
 
 	/*
@@ -296,41 +284,32 @@ idtg2_em_init(struct rio_dev *rdev)
 	 */
 
 	/* Disable JTAG and I2C Error capture */
-	rio_mport_write_config_32(mport, destid, hopcount,
-			IDT_AUX_PORT_ERR_CAP_EN, 0);
+	rio_write_config_32(rdev, IDT_AUX_PORT_ERR_CAP_EN, 0);
 
 	/* Disable JTAG and I2C Error reporting/logging */
-	rio_mport_write_config_32(mport, destid, hopcount,
-			IDT_AUX_ERR_REPORT_EN, 0);
+	rio_write_config_32(rdev, IDT_AUX_ERR_REPORT_EN, 0);
 
 	/* Disable Port-Write notification from JTAG */
-	rio_mport_write_config_32(mport, destid, hopcount,
-			IDT_JTAG_CTRL, 0);
+	rio_write_config_32(rdev, IDT_JTAG_CTRL, 0);
 
 	/* Disable Port-Write notification from I2C */
-	rio_mport_read_config_32(mport, destid, hopcount,
-			IDT_I2C_MCTRL, &regval);
-	rio_mport_write_config_32(mport, destid, hopcount,
-			IDT_I2C_MCTRL,
-			regval & ~IDT_I2C_MCTRL_GENPW);
+	rio_read_config_32(rdev, IDT_I2C_MCTRL, &regval);
+	rio_write_config_32(rdev, IDT_I2C_MCTRL, regval & ~IDT_I2C_MCTRL_GENPW);
 
 	/*
 	 * Configure CFG_BLK error reporting.
 	 */
 
 	/* Disable Configuration Block error capture */
-	rio_mport_write_config_32(mport, destid, hopcount,
-			IDT_CFGBLK_ERR_CAPTURE_EN, 0);
+	rio_write_config_32(rdev, IDT_CFGBLK_ERR_CAPTURE_EN, 0);
 
 	/* Disable Port-Writes for Configuration Block error reporting */
-	rio_mport_read_config_32(mport, destid, hopcount,
-			IDT_CFGBLK_ERR_REPORT, &regval);
-	rio_mport_write_config_32(mport, destid, hopcount,
-			IDT_CFGBLK_ERR_REPORT,
-			regval & ~IDT_CFGBLK_ERR_REPORT_GENPW);
+	rio_read_config_32(rdev, IDT_CFGBLK_ERR_REPORT, &regval);
+	rio_write_config_32(rdev, IDT_CFGBLK_ERR_REPORT,
+			    regval & ~IDT_CFGBLK_ERR_REPORT_GENPW);
 
 	/* set TVAL = ~50us */
-	rio_mport_write_config_32(mport, destid, hopcount,
+	rio_write_config_32(rdev,
 		rdev->phys_efptr + RIO_PORT_LINKTO_CTL_CSR, 0x8e << 8);
 
 	return 0;
@@ -339,18 +318,15 @@ idtg2_em_init(struct rio_dev *rdev)
 static int
 idtg2_em_handler(struct rio_dev *rdev, u8 portnum)
 {
-	struct rio_mport *mport = rdev->net->hport;
-	u16 destid = rdev->rswitch->destid;
-	u8 hopcount = rdev->rswitch->hopcount;
 	u32 regval, em_perrdet, em_ltlerrdet;
 
-	rio_mport_read_config_32(mport, destid, hopcount,
+	rio_read_config_32(rdev,
 		rdev->em_efptr + RIO_EM_LTL_ERR_DETECT, &em_ltlerrdet);
 	if (em_ltlerrdet) {
 		/* Service Logical/Transport Layer Error(s) */
 		if (em_ltlerrdet & REM_LTL_ERR_IMPSPEC) {
 			/* Implementation specific error reported */
-			rio_mport_read_config_32(mport, destid, hopcount,
+			rio_read_config_32(rdev,
 					IDT_ISLTL_ADDRESS_CAP, &regval);
 
 			pr_debug("RIO: %s Implementation Specific LTL errors" \
@@ -358,13 +334,12 @@ idtg2_em_handler(struct rio_dev *rdev, u
 				 rio_name(rdev), em_ltlerrdet, regval);
 
 			/* Clear implementation specific address capture CSR */
-			rio_mport_write_config_32(mport, destid, hopcount,
-					IDT_ISLTL_ADDRESS_CAP, 0);
+			rio_write_config_32(rdev, IDT_ISLTL_ADDRESS_CAP, 0);
 
 		}
 	}
 
-	rio_mport_read_config_32(mport, destid, hopcount,
+	rio_read_config_32(rdev,
 		rdev->em_efptr + RIO_EM_PN_ERR_DETECT(portnum), &em_perrdet);
 	if (em_perrdet) {
 		/* Service Port-Level Error(s) */
@@ -372,14 +347,14 @@ idtg2_em_handler(struct rio_dev *rdev, u
 			/* Implementation Specific port error reported */
 
 			/* Get IS errors reported */
-			rio_mport_read_config_32(mport, destid, hopcount,
+			rio_read_config_32(rdev,
 					IDT_PORT_ISERR_DET(portnum), &regval);
 
 			pr_debug("RIO: %s Implementation Specific Port" \
 				 " errors 0x%x\n", rio_name(rdev), regval);
 
 			/* Clear all implementation specific events */
-			rio_mport_write_config_32(mport, destid, hopcount,
+			rio_write_config_32(rdev,
 					IDT_PORT_ISERR_DET(portnum), 0);
 		}
 	}
@@ -391,14 +366,10 @@ static ssize_t
 idtg2_show_errlog(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct rio_dev *rdev = to_rio_dev(dev);
-	struct rio_mport *mport = rdev->net->hport;
-	u16 destid = rdev->rswitch->destid;
-	u8 hopcount = rdev->rswitch->hopcount;
 	ssize_t len = 0;
 	u32 regval;
 
-	while (!rio_mport_read_config_32(mport, destid, hopcount,
-					 IDT_ERR_RD, &regval)) {
+	while (!rio_read_config_32(rdev, IDT_ERR_RD, &regval)) {
 		if (!regval)    /* 0 = end of log */
 			break;
 		len += snprintf(buf + len, PAGE_SIZE - len,
diff -puN drivers/rapidio/switches/idtcps.c~rapidio-use-common-destid-storage-for-endpoints-and-switches drivers/rapidio/switches/idtcps.c
--- a/drivers/rapidio/switches/idtcps.c~rapidio-use-common-destid-storage-for-endpoints-and-switches
+++ a/drivers/rapidio/switches/idtcps.c
@@ -117,10 +117,6 @@ idtcps_get_domain(struct rio_mport *mpor
 
 static int idtcps_switch_init(struct rio_dev *rdev, int do_enum)
 {
-	struct rio_mport *mport = rdev->net->hport;
-	u16 destid = rdev->rswitch->destid;
-	u8 hopcount = rdev->rswitch->hopcount;
-
 	pr_debug("RIO: %s for %s\n", __func__, rio_name(rdev));
 	rdev->rswitch->add_entry = idtcps_route_add_entry;
 	rdev->rswitch->get_entry = idtcps_route_get_entry;
@@ -132,7 +128,7 @@ static int idtcps_switch_init(struct rio
 
 	if (do_enum) {
 		/* set TVAL = ~50us */
-		rio_mport_write_config_32(mport, destid, hopcount,
+		rio_write_config_32(rdev,
 			rdev->phys_efptr + RIO_PORT_LINKTO_CTL_CSR, 0x8e << 8);
 	}
 
diff -puN drivers/rapidio/switches/tsi568.c~rapidio-use-common-destid-storage-for-endpoints-and-switches drivers/rapidio/switches/tsi568.c
--- a/drivers/rapidio/switches/tsi568.c~rapidio-use-common-destid-storage-for-endpoints-and-switches
+++ a/drivers/rapidio/switches/tsi568.c
@@ -113,22 +113,17 @@ tsi568_route_clr_table(struct rio_mport 
 static int
 tsi568_em_init(struct rio_dev *rdev)
 {
-	struct rio_mport *mport = rdev->net->hport;
-	u16 destid = rdev->rswitch->destid;
-	u8 hopcount = rdev->rswitch->hopcount;
 	u32 regval;
 	int portnum;
 
-	pr_debug("TSI568 %s [%d:%d]\n", __func__, destid, hopcount);
+	pr_debug("TSI568 %s [%d:%d]\n", __func__, rdev->destid, rdev->hopcount);
 
 	/* Make sure that Port-Writes are disabled (for all ports) */
 	for (portnum = 0;
 	     portnum < RIO_GET_TOTAL_PORTS(rdev->swpinfo); portnum++) {
-		rio_mport_read_config_32(mport, destid, hopcount,
-				TSI568_SP_MODE(portnum), &regval);
-		rio_mport_write_config_32(mport, destid, hopcount,
-				TSI568_SP_MODE(portnum),
-				regval | TSI568_SP_MODE_PW_DIS);
+		rio_read_config_32(rdev, TSI568_SP_MODE(portnum), &regval);
+		rio_write_config_32(rdev, TSI568_SP_MODE(portnum),
+				    regval | TSI568_SP_MODE_PW_DIS);
 	}
 
 	return 0;
diff -puN drivers/rapidio/switches/tsi57x.c~rapidio-use-common-destid-storage-for-endpoints-and-switches drivers/rapidio/switches/tsi57x.c
--- a/drivers/rapidio/switches/tsi57x.c~rapidio-use-common-destid-storage-for-endpoints-and-switches
+++ a/drivers/rapidio/switches/tsi57x.c
@@ -158,48 +158,45 @@ tsi57x_get_domain(struct rio_mport *mpor
 static int
 tsi57x_em_init(struct rio_dev *rdev)
 {
-	struct rio_mport *mport = rdev->net->hport;
-	u16 destid = rdev->rswitch->destid;
-	u8 hopcount = rdev->rswitch->hopcount;
 	u32 regval;
 	int portnum;
 
-	pr_debug("TSI578 %s [%d:%d]\n", __func__, destid, hopcount);
+	pr_debug("TSI578 %s [%d:%d]\n", __func__, rdev->destid, rdev->hopcount);
 
 	for (portnum = 0;
 	     portnum < RIO_GET_TOTAL_PORTS(rdev->swpinfo); portnum++) {
 		/* Make sure that Port-Writes are enabled (for all ports) */
-		rio_mport_read_config_32(mport, destid, hopcount,
+		rio_read_config_32(rdev,
 				TSI578_SP_MODE(portnum), &regval);
-		rio_mport_write_config_32(mport, destid, hopcount,
+		rio_write_config_32(rdev,
 				TSI578_SP_MODE(portnum),
 				regval & ~TSI578_SP_MODE_PW_DIS);
 
 		/* Clear all pending interrupts */
-		rio_mport_read_config_32(mport, destid, hopcount,
+		rio_read_config_32(rdev,
 				rdev->phys_efptr +
 					RIO_PORT_N_ERR_STS_CSR(portnum),
 				&regval);
-		rio_mport_write_config_32(mport, destid, hopcount,
+		rio_write_config_32(rdev,
 				rdev->phys_efptr +
 					RIO_PORT_N_ERR_STS_CSR(portnum),
 				regval & 0x07120214);
 
-		rio_mport_read_config_32(mport, destid, hopcount,
+		rio_read_config_32(rdev,
 				TSI578_SP_INT_STATUS(portnum), &regval);
-		rio_mport_write_config_32(mport, destid, hopcount,
+		rio_write_config_32(rdev,
 				TSI578_SP_INT_STATUS(portnum),
 				regval & 0x000700bd);
 
 		/* Enable all interrupts to allow ports to send a port-write */
-		rio_mport_read_config_32(mport, destid, hopcount,
+		rio_read_config_32(rdev,
 				TSI578_SP_CTL_INDEP(portnum), &regval);
-		rio_mport_write_config_32(mport, destid, hopcount,
+		rio_write_config_32(rdev,
 				TSI578_SP_CTL_INDEP(portnum),
 				regval | 0x000b0000);
 
 		/* Skip next (odd) port if the current port is in x4 mode */
-		rio_mport_read_config_32(mport, destid, hopcount,
+		rio_read_config_32(rdev,
 				rdev->phys_efptr + RIO_PORT_N_CTL_CSR(portnum),
 				&regval);
 		if ((regval & RIO_PORT_N_CTL_PWIDTH) == RIO_PORT_N_CTL_PWIDTH_4)
@@ -207,7 +204,7 @@ tsi57x_em_init(struct rio_dev *rdev)
 	}
 
 	/* set TVAL = ~50us */
-	rio_mport_write_config_32(mport, destid, hopcount,
+	rio_write_config_32(rdev,
 		rdev->phys_efptr + RIO_PORT_LINKTO_CTL_CSR, 0x9a << 8);
 
 	return 0;
@@ -217,14 +214,12 @@ static int
 tsi57x_em_handler(struct rio_dev *rdev, u8 portnum)
 {
 	struct rio_mport *mport = rdev->net->hport;
-	u16 destid = rdev->rswitch->destid;
-	u8 hopcount = rdev->rswitch->hopcount;
 	u32 intstat, err_status;
 	int sendcount, checkcount;
 	u8 route_port;
 	u32 regval;
 
-	rio_mport_read_config_32(mport, destid, hopcount,
+	rio_read_config_32(rdev,
 			rdev->phys_efptr + RIO_PORT_N_ERR_STS_CSR(portnum),
 			&err_status);
 
@@ -232,15 +227,15 @@ tsi57x_em_handler(struct rio_dev *rdev, 
 	    (err_status & (RIO_PORT_N_ERR_STS_PW_OUT_ES |
 			  RIO_PORT_N_ERR_STS_PW_INP_ES))) {
 		/* Remove any queued packets by locking/unlocking port */
-		rio_mport_read_config_32(mport, destid, hopcount,
+		rio_read_config_32(rdev,
 			rdev->phys_efptr + RIO_PORT_N_CTL_CSR(portnum),
 			&regval);
 		if (!(regval & RIO_PORT_N_CTL_LOCKOUT)) {
-			rio_mport_write_config_32(mport, destid, hopcount,
+			rio_write_config_32(rdev,
 				rdev->phys_efptr + RIO_PORT_N_CTL_CSR(portnum),
 				regval | RIO_PORT_N_CTL_LOCKOUT);
 			udelay(50);
-			rio_mport_write_config_32(mport, destid, hopcount,
+			rio_write_config_32(rdev,
 				rdev->phys_efptr + RIO_PORT_N_CTL_CSR(portnum),
 				regval);
 		}
@@ -248,7 +243,7 @@ tsi57x_em_handler(struct rio_dev *rdev, 
 		/* Read from link maintenance response register to clear
 		 * valid bit
 		 */
-		rio_mport_read_config_32(mport, destid, hopcount,
+		rio_read_config_32(rdev,
 			rdev->phys_efptr + RIO_PORT_N_MNT_RSP_CSR(portnum),
 			&regval);
 
@@ -257,13 +252,12 @@ tsi57x_em_handler(struct rio_dev *rdev, 
 		 */
 		sendcount = 3;
 		while (sendcount) {
-			rio_mport_write_config_32(mport, destid, hopcount,
+			rio_write_config_32(rdev,
 					  TSI578_SP_CS_TX(portnum), 0x40fc8000);
 			checkcount = 3;
 			while (checkcount--) {
 				udelay(50);
-				rio_mport_read_config_32(
-					mport, destid, hopcount,
+				rio_read_config_32(rdev,
 					rdev->phys_efptr +
 						RIO_PORT_N_MNT_RSP_CSR(portnum),
 					&regval);
@@ -277,25 +271,23 @@ tsi57x_em_handler(struct rio_dev *rdev, 
 
 exit_es:
 	/* Clear implementation specific error status bits */
-	rio_mport_read_config_32(mport, destid, hopcount,
-				 TSI578_SP_INT_STATUS(portnum), &intstat);
+	rio_read_config_32(rdev, TSI578_SP_INT_STATUS(portnum), &intstat);
 	pr_debug("TSI578[%x:%x] SP%d_INT_STATUS=0x%08x\n",
-		 destid, hopcount, portnum, intstat);
+		 rdev->destid, rdev->hopcount, portnum, intstat);
 
 	if (intstat & 0x10000) {
-		rio_mport_read_config_32(mport, destid, hopcount,
+		rio_read_config_32(rdev,
 				TSI578_SP_LUT_PEINF(portnum), &regval);
 		regval = (mport->sys_size) ? (regval >> 16) : (regval >> 24);
 		route_port = rdev->rswitch->route_table[regval];
 		pr_debug("RIO: TSI578[%s] P%d LUT Parity Error (destID=%d)\n",
 			rio_name(rdev), portnum, regval);
-		tsi57x_route_add_entry(mport, destid, hopcount,
+		tsi57x_route_add_entry(mport, rdev->destid, rdev->hopcount,
 				RIO_GLOBAL_TABLE, regval, route_port);
 	}
 
-	rio_mport_write_config_32(mport, destid, hopcount,
-				  TSI578_SP_INT_STATUS(portnum),
-				  intstat & 0x000700bd);
+	rio_write_config_32(rdev, TSI578_SP_INT_STATUS(portnum),
+			    intstat & 0x000700bd);
 
 	return 0;
 }
diff -puN include/linux/rio.h~rapidio-use-common-destid-storage-for-endpoints-and-switches include/linux/rio.h
--- a/include/linux/rio.h~rapidio-use-common-destid-storage-for-endpoints-and-switches
+++ a/include/linux/rio.h
@@ -98,7 +98,8 @@ union rio_pw_msg;
  * @dev: Device model device
  * @riores: RIO resources this device owns
  * @pwcback: port-write callback function for this device
- * @destid: Network destination ID
+ * @destid: Network destination ID (or associated destid for switch)
+ * @hopcount: Hopcount to this device
  * @prev: Previous RIO device connected to the current one
  */
 struct rio_dev {
@@ -126,6 +127,7 @@ struct rio_dev {
 	struct resource riores[RIO_MAX_DEV_RESOURCES];
 	int (*pwcback) (struct rio_dev *rdev, union rio_pw_msg *msg, int step);
 	u16 destid;
+	u8 hopcount;
 	struct rio_dev *prev;
 };
 
@@ -229,8 +231,6 @@ struct rio_net {
  * @node: Node in global list of switches
  * @rdev: Associated RIO device structure
  * @switchid: Switch ID that is unique across a network
- * @hopcount: Hopcount to this switch
- * @destid: Associated destid in the path
  * @route_table: Copy of switch routing table
  * @port_ok: Status of each port (one bit per port) - OK=1 or UNINIT=0
  * @add_entry: Callback for switch-specific route add function
@@ -247,8 +247,6 @@ struct rio_switch {
 	struct list_head node;
 	struct rio_dev *rdev;
 	u16 switchid;
-	u16 hopcount;
-	u16 destid;
 	u8 *route_table;
 	u32 port_ok;
 	int (*add_entry) (struct rio_mport * mport, u16 destid, u8 hopcount,
diff -puN include/linux/rio_drv.h~rapidio-use-common-destid-storage-for-endpoints-and-switches include/linux/rio_drv.h
--- a/include/linux/rio_drv.h~rapidio-use-common-destid-storage-for-endpoints-and-switches
+++ a/include/linux/rio_drv.h
@@ -150,16 +150,8 @@ static inline int rio_local_write_config
 static inline int rio_read_config_32(struct rio_dev *rdev, u32 offset,
 				     u32 * data)
 {
-	u8 hopcount = 0xff;
-	u16 destid = rdev->destid;
-
-	if (rdev->rswitch) {
-		destid = rdev->rswitch->destid;
-		hopcount = rdev->rswitch->hopcount;
-	}
-
-	return rio_mport_read_config_32(rdev->net->hport, destid, hopcount,
-					offset, data);
+	return rio_mport_read_config_32(rdev->net->hport, rdev->destid,
+					rdev->hopcount, offset, data);
 };
 
 /**
@@ -174,16 +166,8 @@ static inline int rio_read_config_32(str
 static inline int rio_write_config_32(struct rio_dev *rdev, u32 offset,
 				      u32 data)
 {
-	u8 hopcount = 0xff;
-	u16 destid = rdev->destid;
-
-	if (rdev->rswitch) {
-		destid = rdev->rswitch->destid;
-		hopcount = rdev->rswitch->hopcount;
-	}
-
-	return rio_mport_write_config_32(rdev->net->hport, destid, hopcount,
-					 offset, data);
+	return rio_mport_write_config_32(rdev->net->hport, rdev->destid,
+					 rdev->hopcount, offset, data);
 };
 
 /**
@@ -198,16 +182,8 @@ static inline int rio_write_config_32(st
 static inline int rio_read_config_16(struct rio_dev *rdev, u32 offset,
 				     u16 * data)
 {
-	u8 hopcount = 0xff;
-	u16 destid = rdev->destid;
-
-	if (rdev->rswitch) {
-		destid = rdev->rswitch->destid;
-		hopcount = rdev->rswitch->hopcount;
-	}
-
-	return rio_mport_read_config_16(rdev->net->hport, destid, hopcount,
-					offset, data);
+	return rio_mport_read_config_16(rdev->net->hport, rdev->destid,
+					rdev->hopcount, offset, data);
 };
 
 /**
@@ -222,16 +198,8 @@ static inline int rio_read_config_16(str
 static inline int rio_write_config_16(struct rio_dev *rdev, u32 offset,
 				      u16 data)
 {
-	u8 hopcount = 0xff;
-	u16 destid = rdev->destid;
-
-	if (rdev->rswitch) {
-		destid = rdev->rswitch->destid;
-		hopcount = rdev->rswitch->hopcount;
-	}
-
-	return rio_mport_write_config_16(rdev->net->hport, destid, hopcount,
-					 offset, data);
+	return rio_mport_write_config_16(rdev->net->hport, rdev->destid,
+					 rdev->hopcount, offset, data);
 };
 
 /**
@@ -245,16 +213,8 @@ static inline int rio_write_config_16(st
  */
 static inline int rio_read_config_8(struct rio_dev *rdev, u32 offset, u8 * data)
 {
-	u8 hopcount = 0xff;
-	u16 destid = rdev->destid;
-
-	if (rdev->rswitch) {
-		destid = rdev->rswitch->destid;
-		hopcount = rdev->rswitch->hopcount;
-	}
-
-	return rio_mport_read_config_8(rdev->net->hport, destid, hopcount,
-				       offset, data);
+	return rio_mport_read_config_8(rdev->net->hport, rdev->destid,
+				       rdev->hopcount, offset, data);
 };
 
 /**
@@ -268,16 +228,8 @@ static inline int rio_read_config_8(stru
  */
 static inline int rio_write_config_8(struct rio_dev *rdev, u32 offset, u8 data)
 {
-	u8 hopcount = 0xff;
-	u16 destid = rdev->destid;
-
-	if (rdev->rswitch) {
-		destid = rdev->rswitch->destid;
-		hopcount = rdev->rswitch->hopcount;
-	}
-
-	return rio_mport_write_config_8(rdev->net->hport, destid, hopcount,
-					offset, data);
+	return rio_mport_write_config_8(rdev->net->hport, rdev->destid,
+					rdev->hopcount, offset, data);
 };
 
 extern int rio_mport_send_doorbell(struct rio_mport *mport, u16 destid,
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

rapidio-fix-rapidio-sysfs-hierarchy.patch
rapidio-powerpc-85xx-modify-rio-port-write-interrupt-handler.patch
rapidio-use-stored-ingress-port-number-instead-of-register-read.patch
rapidio-add-relation-links-between-rio-device-structures.patch
rapidio-add-default-handler-for-error-stopped-state.patch
rapidio-modify-sysfs-initialization-for-switches.patch
rapidio-add-handling-of-orphan-port-write-message.patch
rapidio-add-device-access-check-into-the-enumeration.patch
rapidio-add-support-for-idt-cps-gen2-switches.patch
rapidio-add-handling-of-redundant-routes.patch
rapidio-fix-idle2-bits-corruption.patch
rapidio-fix-maximum-port-number-in-tsi57x-em-initialization.patch
rapidio-fix-destructive-port-em-initialization-for-tsi568.patch
rapidio-use-common-destid-storage-for-endpoints-and-switches.patch
rapidio-integrate-rio_switch-into-rio_dev.patch

