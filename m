From: akpm@linux-foundation.org
Subject: + rapidio-modify-for-rev3-specification-changes.patch added to
 -mm tree
Date: Thu, 21 Jul 2016 11:40:36 -0700
Message-ID: <57911724.OJ4aW0SfX8tI8ZsZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50432 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbcGUSkh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jul 2016 14:40:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, andre.van.herk@prodrive-technologies.com, barry.wood@idt.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: modify for rev.3 specification changes
has been added to the -mm tree.  Its filename is
     rapidio-modify-for-rev3-specification-changes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-modify-for-rev3-specification-changes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-modify-for-rev3-specification-changes.patch

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
Subject: rapidio: modify for rev.3 specification changes

Implement changes made in RapidIO specification rev.3 to LP-Serial Physical
Layer register definitions:
- use per-port register offset calculations based on LP-Serial Extended
  Features Block (EFB) Register Map type (I or II) with different per-port
  offset step (0x20 vs. 0x40 respectfully).
- remove deprecated Parallel Physical layer definitions and related code.

Link: http://lkml.kernel.org/r/1469125134-16523-12-git-send-email-alexandre.bounine@idt.com
Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Tested-by: Barry Wood <barry.wood@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Cc: Barry Wood <barry.wood@idt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/rio_mport_cdev.c |    2 
 drivers/rapidio/devices/tsi721.c         |    8 -
 drivers/rapidio/rio-scan.c               |   74 ++-------
 drivers/rapidio/rio.c                    |  149 +++++++++---------
 drivers/rapidio/rio.h                    |    2 
 drivers/rapidio/switches/tsi57x.c        |   26 +--
 include/linux/rio.h                      |   11 -
 include/linux/rio_regs.h                 |  167 ++++++++++++++++-----
 8 files changed, 248 insertions(+), 191 deletions(-)

diff -puN drivers/rapidio/devices/rio_mport_cdev.c~rapidio-modify-for-rev3-specification-changes drivers/rapidio/devices/rio_mport_cdev.c
--- a/drivers/rapidio/devices/rio_mport_cdev.c~rapidio-modify-for-rev3-specification-changes
+++ a/drivers/rapidio/devices/rio_mport_cdev.c
@@ -1813,7 +1813,7 @@ static int rio_mport_add_riodev(struct m
 	if (rdev->pef & RIO_PEF_EXT_FEATURES) {
 		rdev->efptr = rval & 0xffff;
 		rdev->phys_efptr = rio_mport_get_physefb(mport, 0, destid,
-							 hopcount);
+						hopcount, &rdev->phys_rmap);
 
 		rdev->em_efptr = rio_mport_get_feature(mport, 0, destid,
 						hopcount, RIO_EFB_ERR_MGMNT);
diff -puN drivers/rapidio/devices/tsi721.c~rapidio-modify-for-rev3-specification-changes drivers/rapidio/devices/tsi721.c
--- a/drivers/rapidio/devices/tsi721.c~rapidio-modify-for-rev3-specification-changes
+++ a/drivers/rapidio/devices/tsi721.c
@@ -2555,11 +2555,11 @@ static int tsi721_query_mport(struct rio
 	struct tsi721_device *priv = mport->priv;
 	u32 rval;
 
-	rval = ioread32(priv->regs + (0x100 + RIO_PORT_N_ERR_STS_CSR(0)));
+	rval = ioread32(priv->regs + 0x100 + RIO_PORT_N_ERR_STS_CSR(0, 0));
 	if (rval & RIO_PORT_N_ERR_STS_PORT_OK) {
-		rval = ioread32(priv->regs + (0x100 + RIO_PORT_N_CTL2_CSR(0)));
+		rval = ioread32(priv->regs + 0x100 + RIO_PORT_N_CTL2_CSR(0, 0));
 		attr->link_speed = (rval & RIO_PORT_N_CTL2_SEL_BAUD) >> 28;
-		rval = ioread32(priv->regs + (0x100 + RIO_PORT_N_CTL_CSR(0)));
+		rval = ioread32(priv->regs + 0x100 + RIO_PORT_N_CTL_CSR(0, 0));
 		attr->link_width = (rval & RIO_PORT_N_CTL_IPW) >> 27;
 	} else
 		attr->link_speed = RIO_LINK_DOWN;
@@ -2673,9 +2673,9 @@ static int tsi721_setup_mport(struct tsi
 	mport->ops = &tsi721_rio_ops;
 	mport->index = 0;
 	mport->sys_size = 0; /* small system */
-	mport->phy_type = RIO_PHY_SERIAL;
 	mport->priv = (void *)priv;
 	mport->phys_efptr = 0x100;
+	mport->phys_rmap = 1;
 	mport->dev.parent = &pdev->dev;
 	mport->dev.release = tsi721_mport_release;
 
diff -puN drivers/rapidio/rio-scan.c~rapidio-modify-for-rev3-specification-changes drivers/rapidio/rio-scan.c
--- a/drivers/rapidio/rio-scan.c~rapidio-modify-for-rev3-specification-changes
+++ a/drivers/rapidio/rio-scan.c
@@ -49,15 +49,6 @@ struct rio_id_table {
 static int next_destid = 0;
 static int next_comptag = 1;
 
-static int rio_mport_phys_table[] = {
-	RIO_EFB_PAR_EP_ID,
-	RIO_EFB_PAR_EP_REC_ID,
-	RIO_EFB_SER_EP_ID,
-	RIO_EFB_SER_EP_REC_ID,
-	-1,
-};
-
-
 /**
  * rio_destid_alloc - Allocate next available destID for given network
  * @net: RIO network
@@ -380,10 +371,15 @@ static struct rio_dev *rio_setup_device(
 	if (rdev->pef & RIO_PEF_EXT_FEATURES) {
 		rdev->efptr = result & 0xffff;
 		rdev->phys_efptr = rio_mport_get_physefb(port, 0, destid,
-							 hopcount);
+						hopcount, &rdev->phys_rmap);
+		pr_debug("RIO: %s Register Map %d device\n",
+			 __func__, rdev->phys_rmap);
 
 		rdev->em_efptr = rio_mport_get_feature(port, 0, destid,
 						hopcount, RIO_EFB_ERR_MGMNT);
+		if (!rdev->em_efptr)
+			rdev->em_efptr = rio_mport_get_feature(port, 0, destid,
+						hopcount, RIO_EFB_ERR_MGMNT_HS);
 	}
 
 	rio_mport_read_config_32(port, destid, hopcount, RIO_SRC_OPS_CAR,
@@ -445,7 +441,7 @@ static struct rio_dev *rio_setup_device(
 			rio_route_clr_table(rdev, RIO_GLOBAL_TABLE, 0);
 	} else {
 		if (do_enum)
-			/*Enable Input Output Port (transmitter reviever)*/
+			/*Enable Input Output Port (transmitter receiver)*/
 			rio_enable_rx_tx_port(port, 0, destid, hopcount, 0);
 
 		dev_set_name(&rdev->dev, "%02x:e:%04x", rdev->net->id,
@@ -481,10 +477,8 @@ cleanup:
 
 /**
  * rio_sport_is_active- Tests if a switch port has an active connection.
- * @port: Master port to send transaction
- * @destid: Associated destination ID for switch
- * @hopcount: Hopcount to reach switch
- * @sport: Switch port number
+ * @rdev: RapidIO device object
+ * @sp: Switch port number
  *
  * Reads the port error status CSR for a particular switch port to
  * determine if the port has an active link.  Returns
@@ -492,31 +486,12 @@ cleanup:
  * inactive.
  */
 static int
-rio_sport_is_active(struct rio_mport *port, u16 destid, u8 hopcount, int sport)
+rio_sport_is_active(struct rio_dev *rdev, int sp)
 {
 	u32 result = 0;
-	u32 ext_ftr_ptr;
-
-	ext_ftr_ptr = rio_mport_get_efb(port, 0, destid, hopcount, 0);
-
-	while (ext_ftr_ptr) {
-		rio_mport_read_config_32(port, destid, hopcount,
-					 ext_ftr_ptr, &result);
-		result = RIO_GET_BLOCK_ID(result);
-		if ((result == RIO_EFB_SER_EP_FREE_ID) ||
-		    (result == RIO_EFB_SER_EP_FREE_ID_V13P) ||
-		    (result == RIO_EFB_SER_EP_FREC_ID))
-			break;
 
-		ext_ftr_ptr = rio_mport_get_efb(port, 0, destid, hopcount,
-						ext_ftr_ptr);
-	}
-
-	if (ext_ftr_ptr)
-		rio_mport_read_config_32(port, destid, hopcount,
-					 ext_ftr_ptr +
-					 RIO_PORT_N_ERR_STS_CSR(sport),
-					 &result);
+	rio_read_config_32(rdev, RIO_DEV_PORT_N_ERR_STS_CSR(rdev, sp),
+			   &result);
 
 	return result & RIO_PORT_N_ERR_STS_PORT_OK;
 }
@@ -655,9 +630,7 @@ static int rio_enum_peer(struct rio_net
 
 			cur_destid = next_destid;
 
-			if (rio_sport_is_active
-			    (port, RIO_ANY_DESTID(port->sys_size), hopcount,
-			     port_num)) {
+			if (rio_sport_is_active(rdev, port_num)) {
 				pr_debug(
 				    "RIO: scanning device on port %d\n",
 				    port_num);
@@ -785,8 +758,7 @@ rio_disc_peer(struct rio_net *net, struc
 			if (RIO_GET_PORT_NUM(rdev->swpinfo) == port_num)
 				continue;
 
-			if (rio_sport_is_active
-			    (port, destid, hopcount, port_num)) {
+			if (rio_sport_is_active(rdev, port_num)) {
 				pr_debug(
 				    "RIO: scanning device on port %d\n",
 				    port_num);
@@ -831,21 +803,11 @@ rio_disc_peer(struct rio_net *net, struc
 static int rio_mport_is_active(struct rio_mport *port)
 {
 	u32 result = 0;
-	u32 ext_ftr_ptr;
-	int *entry = rio_mport_phys_table;
-
-	do {
-		if ((ext_ftr_ptr =
-		     rio_mport_get_feature(port, 1, 0, 0, *entry)))
-			break;
-	} while (*++entry >= 0);
-
-	if (ext_ftr_ptr)
-		rio_local_read_config_32(port,
-					 ext_ftr_ptr +
-					 RIO_PORT_N_ERR_STS_CSR(port->index),
-					 &result);
 
+	rio_local_read_config_32(port,
+		port->phys_efptr +
+			RIO_PORT_N_ERR_STS_CSR(port->index, port->phys_rmap),
+		&result);
 	return result & RIO_PORT_N_ERR_STS_PORT_OK;
 }
 
diff -puN drivers/rapidio/rio.c~rapidio-modify-for-rev3-specification-changes drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-modify-for-rev3-specification-changes
+++ a/drivers/rapidio/rio.c
@@ -789,7 +789,7 @@ EXPORT_SYMBOL_GPL(rio_unmap_outb_region)
  */
 u32
 rio_mport_get_physefb(struct rio_mport *port, int local,
-		      u16 destid, u8 hopcount)
+		      u16 destid, u8 hopcount, u32 *rmap)
 {
 	u32 ext_ftr_ptr;
 	u32 ftr_header;
@@ -807,14 +807,21 @@ rio_mport_get_physefb(struct rio_mport *
 		ftr_header = RIO_GET_BLOCK_ID(ftr_header);
 		switch (ftr_header) {
 
-		case RIO_EFB_SER_EP_ID_V13P:
-		case RIO_EFB_SER_EP_REC_ID_V13P:
-		case RIO_EFB_SER_EP_FREE_ID_V13P:
 		case RIO_EFB_SER_EP_ID:
 		case RIO_EFB_SER_EP_REC_ID:
 		case RIO_EFB_SER_EP_FREE_ID:
-		case RIO_EFB_SER_EP_FREC_ID:
+		case RIO_EFB_SER_EP_M1_ID:
+		case RIO_EFB_SER_EP_SW_M1_ID:
+		case RIO_EFB_SER_EPF_M1_ID:
+		case RIO_EFB_SER_EPF_SW_M1_ID:
+			*rmap = 1;
+			return ext_ftr_ptr;
 
+		case RIO_EFB_SER_EP_M2_ID:
+		case RIO_EFB_SER_EP_SW_M2_ID:
+		case RIO_EFB_SER_EPF_M2_ID:
+		case RIO_EFB_SER_EPF_SW_M2_ID:
+			*rmap = 2;
 			return ext_ftr_ptr;
 
 		default:
@@ -873,16 +880,16 @@ int rio_set_port_lockout(struct rio_dev
 	u32 regval;
 
 	rio_read_config_32(rdev,
-				 rdev->phys_efptr + RIO_PORT_N_CTL_CSR(pnum),
-				 &regval);
+		RIO_DEV_PORT_N_CTL_CSR(rdev, pnum),
+		&regval);
 	if (lock)
 		regval |= RIO_PORT_N_CTL_LOCKOUT;
 	else
 		regval &= ~RIO_PORT_N_CTL_LOCKOUT;
 
 	rio_write_config_32(rdev,
-				  rdev->phys_efptr + RIO_PORT_N_CTL_CSR(pnum),
-				  regval);
+		RIO_DEV_PORT_N_CTL_CSR(rdev, pnum),
+		regval);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(rio_set_port_lockout);
@@ -906,6 +913,7 @@ int rio_enable_rx_tx_port(struct rio_mpo
 #ifdef CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS
 	u32 regval;
 	u32 ext_ftr_ptr;
+	u32 rmap;
 
 	/*
 	* enable rx input tx output port
@@ -913,34 +921,29 @@ int rio_enable_rx_tx_port(struct rio_mpo
 	pr_debug("rio_enable_rx_tx_port(local = %d, destid = %d, hopcount = "
 		 "%d, port_num = %d)\n", local, destid, hopcount, port_num);
 
-	ext_ftr_ptr = rio_mport_get_physefb(port, local, destid, hopcount);
+	ext_ftr_ptr = rio_mport_get_physefb(port, local, destid,
+					    hopcount, &rmap);
 
 	if (local) {
-		rio_local_read_config_32(port, ext_ftr_ptr +
-				RIO_PORT_N_CTL_CSR(0),
+		rio_local_read_config_32(port,
+				ext_ftr_ptr + RIO_PORT_N_CTL_CSR(0, rmap),
 				&regval);
 	} else {
 		if (rio_mport_read_config_32(port, destid, hopcount,
-		ext_ftr_ptr + RIO_PORT_N_CTL_CSR(port_num), &regval) < 0)
+			ext_ftr_ptr + RIO_PORT_N_CTL_CSR(port_num, rmap),
+				&regval) < 0)
 			return -EIO;
 	}
 
-	if (regval & RIO_PORT_N_CTL_P_TYP_SER) {
-		/* serial */
-		regval = regval | RIO_PORT_N_CTL_EN_RX_SER
-				| RIO_PORT_N_CTL_EN_TX_SER;
-	} else {
-		/* parallel */
-		regval = regval | RIO_PORT_N_CTL_EN_RX_PAR
-				| RIO_PORT_N_CTL_EN_TX_PAR;
-	}
+	regval = regval | RIO_PORT_N_CTL_EN_RX | RIO_PORT_N_CTL_EN_TX;
 
 	if (local) {
-		rio_local_write_config_32(port, ext_ftr_ptr +
-					  RIO_PORT_N_CTL_CSR(0), regval);
+		rio_local_write_config_32(port,
+			ext_ftr_ptr + RIO_PORT_N_CTL_CSR(0, rmap), regval);
 	} else {
 		if (rio_mport_write_config_32(port, destid, hopcount,
-		    ext_ftr_ptr + RIO_PORT_N_CTL_CSR(port_num), regval) < 0)
+			ext_ftr_ptr + RIO_PORT_N_CTL_CSR(port_num, rmap),
+				regval) < 0)
 			return -EIO;
 	}
 #endif
@@ -1042,14 +1045,14 @@ rio_get_input_status(struct rio_dev *rde
 		/* Read from link maintenance response register
 		 * to clear valid bit */
 		rio_read_config_32(rdev,
-			rdev->phys_efptr + RIO_PORT_N_MNT_RSP_CSR(pnum),
+			RIO_DEV_PORT_N_MNT_RSP_CSR(rdev, pnum),
 			&regval);
 		udelay(50);
 	}
 
 	/* Issue Input-status command */
 	rio_write_config_32(rdev,
-		rdev->phys_efptr + RIO_PORT_N_MNT_REQ_CSR(pnum),
+		RIO_DEV_PORT_N_MNT_REQ_CSR(rdev, pnum),
 		RIO_MNT_REQ_CMD_IS);
 
 	/* Exit if the response is not expected */
@@ -1060,7 +1063,7 @@ rio_get_input_status(struct rio_dev *rde
 	while (checkcount--) {
 		udelay(50);
 		rio_read_config_32(rdev,
-			rdev->phys_efptr + RIO_PORT_N_MNT_RSP_CSR(pnum),
+			RIO_DEV_PORT_N_MNT_RSP_CSR(rdev, pnum),
 			&regval);
 		if (regval & RIO_PORT_N_MNT_RSP_RVAL) {
 			*lnkresp = regval;
@@ -1076,6 +1079,13 @@ rio_get_input_status(struct rio_dev *rde
  * @rdev: Pointer to RIO device control structure
  * @pnum: Switch port number to clear errors
  * @err_status: port error status (if 0 reads register from device)
+ *
+ * TODO: Currently this routine is not compatible with recovery process
+ * specified for idt_gen3 RapidIO switch devices. It has to be reviewed
+ * to implement universal recovery process that is compatible full range
+ * off available devices.
+ * IDT gen3 switch driver now implements HW-specific error handler that
+ * issues soft port reset to the port to reset ERR_STOP bits and ackIDs.
  */
 static int rio_clr_err_stopped(struct rio_dev *rdev, u32 pnum, u32 err_status)
 {
@@ -1085,10 +1095,10 @@ static int rio_clr_err_stopped(struct ri
 
 	if (err_status == 0)
 		rio_read_config_32(rdev,
-			rdev->phys_efptr + RIO_PORT_N_ERR_STS_CSR(pnum),
+			RIO_DEV_PORT_N_ERR_STS_CSR(rdev, pnum),
 			&err_status);
 
-	if (err_status & RIO_PORT_N_ERR_STS_PW_OUT_ES) {
+	if (err_status & RIO_PORT_N_ERR_STS_OUT_ES) {
 		pr_debug("RIO_EM: servicing Output Error-Stopped state\n");
 		/*
 		 * Send a Link-Request/Input-Status control symbol
@@ -1103,7 +1113,7 @@ static int rio_clr_err_stopped(struct ri
 		far_ackid = (regval & RIO_PORT_N_MNT_RSP_ASTAT) >> 5;
 		far_linkstat = regval & RIO_PORT_N_MNT_RSP_LSTAT;
 		rio_read_config_32(rdev,
-			rdev->phys_efptr + RIO_PORT_N_ACK_STS_CSR(pnum),
+			RIO_DEV_PORT_N_ACK_STS_CSR(rdev, pnum),
 			&regval);
 		pr_debug("RIO_EM: SP%d_ACK_STS_CSR=0x%08x\n", pnum, regval);
 		near_ackid = (regval & RIO_PORT_N_ACK_INBOUND) >> 24;
@@ -1121,43 +1131,43 @@ static int rio_clr_err_stopped(struct ri
 			 * far inbound.
 			 */
 			rio_write_config_32(rdev,
-				rdev->phys_efptr + RIO_PORT_N_ACK_STS_CSR(pnum),
+				RIO_DEV_PORT_N_ACK_STS_CSR(rdev, pnum),
 				(near_ackid << 24) |
 					(far_ackid << 8) | far_ackid);
 			/* Align far outstanding/outbound ackIDs with
 			 * near inbound.
 			 */
 			far_ackid++;
-			if (nextdev)
-				rio_write_config_32(nextdev,
-					nextdev->phys_efptr +
-					RIO_PORT_N_ACK_STS_CSR(RIO_GET_PORT_NUM(nextdev->swpinfo)),
-					(far_ackid << 24) |
-					(near_ackid << 8) | near_ackid);
-			else
-				pr_debug("RIO_EM: Invalid nextdev pointer (NULL)\n");
+			if (!nextdev) {
+				pr_debug("RIO_EM: nextdev pointer == NULL\n");
+				goto rd_err;
+			}
+
+			rio_write_config_32(nextdev,
+				RIO_DEV_PORT_N_ACK_STS_CSR(nextdev,
+					RIO_GET_PORT_NUM(nextdev->swpinfo)),
+				(far_ackid << 24) |
+				(near_ackid << 8) | near_ackid);
 		}
 rd_err:
-		rio_read_config_32(rdev,
-			rdev->phys_efptr + RIO_PORT_N_ERR_STS_CSR(pnum),
-			&err_status);
+		rio_read_config_32(rdev, RIO_DEV_PORT_N_ERR_STS_CSR(rdev, pnum),
+				   &err_status);
 		pr_debug("RIO_EM: SP%d_ERR_STS_CSR=0x%08x\n", pnum, err_status);
 	}
 
-	if ((err_status & RIO_PORT_N_ERR_STS_PW_INP_ES) && nextdev) {
+	if ((err_status & RIO_PORT_N_ERR_STS_INP_ES) && nextdev) {
 		pr_debug("RIO_EM: servicing Input Error-Stopped state\n");
 		rio_get_input_status(nextdev,
 				     RIO_GET_PORT_NUM(nextdev->swpinfo), NULL);
 		udelay(50);
 
-		rio_read_config_32(rdev,
-			rdev->phys_efptr + RIO_PORT_N_ERR_STS_CSR(pnum),
-			&err_status);
+		rio_read_config_32(rdev, RIO_DEV_PORT_N_ERR_STS_CSR(rdev, pnum),
+				   &err_status);
 		pr_debug("RIO_EM: SP%d_ERR_STS_CSR=0x%08x\n", pnum, err_status);
 	}
 
-	return (err_status & (RIO_PORT_N_ERR_STS_PW_OUT_ES |
-			      RIO_PORT_N_ERR_STS_PW_INP_ES)) ? 1 : 0;
+	return (err_status & (RIO_PORT_N_ERR_STS_OUT_ES |
+			      RIO_PORT_N_ERR_STS_INP_ES)) ? 1 : 0;
 }
 
 /**
@@ -1257,9 +1267,8 @@ int rio_inb_pwrite_handler(struct rio_mp
 	if (rdev->rswitch->ops && rdev->rswitch->ops->em_handle)
 		rdev->rswitch->ops->em_handle(rdev, portnum);
 
-	rio_read_config_32(rdev,
-			rdev->phys_efptr + RIO_PORT_N_ERR_STS_CSR(portnum),
-			&err_status);
+	rio_read_config_32(rdev, RIO_DEV_PORT_N_ERR_STS_CSR(rdev, portnum),
+			   &err_status);
 	pr_debug("RIO_PW: SP%d_ERR_STS_CSR=0x%08x\n", portnum, err_status);
 
 	if (err_status & RIO_PORT_N_ERR_STS_PORT_OK) {
@@ -1276,8 +1285,8 @@ int rio_inb_pwrite_handler(struct rio_mp
 		 * Depending on the link partner state, two attempts
 		 * may be needed for successful recovery.
 		 */
-		if (err_status & (RIO_PORT_N_ERR_STS_PW_OUT_ES |
-				  RIO_PORT_N_ERR_STS_PW_INP_ES)) {
+		if (err_status & (RIO_PORT_N_ERR_STS_OUT_ES |
+				  RIO_PORT_N_ERR_STS_INP_ES)) {
 			if (rio_clr_err_stopped(rdev, portnum, err_status))
 				rio_clr_err_stopped(rdev, portnum, 0);
 		}
@@ -1287,10 +1296,18 @@ int rio_inb_pwrite_handler(struct rio_mp
 			rdev->rswitch->port_ok &= ~(1 << portnum);
 			rio_set_port_lockout(rdev, portnum, 1);
 
+			if (rdev->phys_rmap == 1) {
 			rio_write_config_32(rdev,
-				rdev->phys_efptr +
-					RIO_PORT_N_ACK_STS_CSR(portnum),
+				RIO_DEV_PORT_N_ACK_STS_CSR(rdev, portnum),
 				RIO_PORT_N_ACK_CLEAR);
+			} else {
+				rio_write_config_32(rdev,
+					RIO_DEV_PORT_N_OB_ACK_CSR(rdev, portnum),
+					RIO_PORT_N_OB_ACK_CLEAR);
+				rio_write_config_32(rdev,
+					RIO_DEV_PORT_N_IB_ACK_CSR(rdev, portnum),
+					0);
+			}
 
 			/* Schedule Extraction Service */
 			pr_debug("RIO_PW: Device Extraction on [%s]-P%d\n",
@@ -1319,9 +1336,8 @@ int rio_inb_pwrite_handler(struct rio_mp
 	}
 
 	/* Clear remaining error bits and Port-Write Pending bit */
-	rio_write_config_32(rdev,
-			rdev->phys_efptr + RIO_PORT_N_ERR_STS_CSR(portnum),
-			err_status);
+	rio_write_config_32(rdev, RIO_DEV_PORT_N_ERR_STS_CSR(rdev, portnum),
+			    err_status);
 
 	return 0;
 }
@@ -1372,20 +1388,7 @@ EXPORT_SYMBOL_GPL(rio_mport_get_efb);
  * Tell if a device supports a given RapidIO capability.
  * Returns the offset of the requested extended feature
  * block within the device's RIO configuration space or
- * 0 in case the device does not support it.  Possible
- * values for @ftr:
- *
- * %RIO_EFB_PAR_EP_ID		LP/LVDS EP Devices
- *
- * %RIO_EFB_PAR_EP_REC_ID	LP/LVDS EP Recovery Devices
- *
- * %RIO_EFB_PAR_EP_FREE_ID	LP/LVDS EP Free Devices
- *
- * %RIO_EFB_SER_EP_ID		LP/Serial EP Devices
- *
- * %RIO_EFB_SER_EP_REC_ID	LP/Serial EP Recovery Devices
- *
- * %RIO_EFB_SER_EP_FREE_ID	LP/Serial EP Free Devices
+ * 0 in case the device does not support it.
  */
 u32
 rio_mport_get_feature(struct rio_mport * port, int local, u16 destid,
diff -puN drivers/rapidio/rio.h~rapidio-modify-for-rev3-specification-changes drivers/rapidio/rio.h
--- a/drivers/rapidio/rio.h~rapidio-modify-for-rev3-specification-changes
+++ a/drivers/rapidio/rio.h
@@ -22,7 +22,7 @@
 extern u32 rio_mport_get_feature(struct rio_mport *mport, int local, u16 destid,
 				 u8 hopcount, int ftr);
 extern u32 rio_mport_get_physefb(struct rio_mport *port, int local,
-				 u16 destid, u8 hopcount);
+				 u16 destid, u8 hopcount, u32 *rmap);
 extern u32 rio_mport_get_efb(struct rio_mport *port, int local, u16 destid,
 			     u8 hopcount, u32 from);
 extern int rio_mport_chk_dev_access(struct rio_mport *mport, u16 destid,
diff -puN drivers/rapidio/switches/tsi57x.c~rapidio-modify-for-rev3-specification-changes drivers/rapidio/switches/tsi57x.c
--- a/drivers/rapidio/switches/tsi57x.c~rapidio-modify-for-rev3-specification-changes
+++ a/drivers/rapidio/switches/tsi57x.c
@@ -175,12 +175,10 @@ tsi57x_em_init(struct rio_dev *rdev)
 
 		/* Clear all pending interrupts */
 		rio_read_config_32(rdev,
-				rdev->phys_efptr +
-					RIO_PORT_N_ERR_STS_CSR(portnum),
+				RIO_DEV_PORT_N_ERR_STS_CSR(rdev, portnum),
 				&regval);
 		rio_write_config_32(rdev,
-				rdev->phys_efptr +
-					RIO_PORT_N_ERR_STS_CSR(portnum),
+				RIO_DEV_PORT_N_ERR_STS_CSR(rdev, portnum),
 				regval & 0x07120214);
 
 		rio_read_config_32(rdev,
@@ -198,7 +196,7 @@ tsi57x_em_init(struct rio_dev *rdev)
 
 		/* Skip next (odd) port if the current port is in x4 mode */
 		rio_read_config_32(rdev,
-				rdev->phys_efptr + RIO_PORT_N_CTL_CSR(portnum),
+				RIO_DEV_PORT_N_CTL_CSR(rdev, portnum),
 				&regval);
 		if ((regval & RIO_PORT_N_CTL_PWIDTH) == RIO_PORT_N_CTL_PWIDTH_4)
 			portnum++;
@@ -221,23 +219,23 @@ tsi57x_em_handler(struct rio_dev *rdev,
 	u32 regval;
 
 	rio_read_config_32(rdev,
-			rdev->phys_efptr + RIO_PORT_N_ERR_STS_CSR(portnum),
+			RIO_DEV_PORT_N_ERR_STS_CSR(rdev, portnum),
 			&err_status);
 
 	if ((err_status & RIO_PORT_N_ERR_STS_PORT_OK) &&
-	    (err_status & (RIO_PORT_N_ERR_STS_PW_OUT_ES |
-			  RIO_PORT_N_ERR_STS_PW_INP_ES))) {
+	    (err_status & (RIO_PORT_N_ERR_STS_OUT_ES |
+			  RIO_PORT_N_ERR_STS_INP_ES))) {
 		/* Remove any queued packets by locking/unlocking port */
 		rio_read_config_32(rdev,
-			rdev->phys_efptr + RIO_PORT_N_CTL_CSR(portnum),
+			RIO_DEV_PORT_N_CTL_CSR(rdev, portnum),
 			&regval);
 		if (!(regval & RIO_PORT_N_CTL_LOCKOUT)) {
 			rio_write_config_32(rdev,
-				rdev->phys_efptr + RIO_PORT_N_CTL_CSR(portnum),
+				RIO_DEV_PORT_N_CTL_CSR(rdev, portnum),
 				regval | RIO_PORT_N_CTL_LOCKOUT);
 			udelay(50);
 			rio_write_config_32(rdev,
-				rdev->phys_efptr + RIO_PORT_N_CTL_CSR(portnum),
+				RIO_DEV_PORT_N_CTL_CSR(rdev, portnum),
 				regval);
 		}
 
@@ -245,7 +243,7 @@ tsi57x_em_handler(struct rio_dev *rdev,
 		 * valid bit
 		 */
 		rio_read_config_32(rdev,
-			rdev->phys_efptr + RIO_PORT_N_MNT_RSP_CSR(portnum),
+			RIO_DEV_PORT_N_MNT_RSP_CSR(rdev, portnum),
 			&regval);
 
 		/* Send a Packet-Not-Accepted/Link-Request-Input-Status control
@@ -259,8 +257,8 @@ tsi57x_em_handler(struct rio_dev *rdev,
 			while (checkcount--) {
 				udelay(50);
 				rio_read_config_32(rdev,
-					rdev->phys_efptr +
-						RIO_PORT_N_MNT_RSP_CSR(portnum),
+					RIO_DEV_PORT_N_MNT_RSP_CSR(rdev,
+								   portnum),
 					&regval);
 				if (regval & RIO_PORT_N_MNT_RSP_RVAL)
 					goto exit_es;
diff -puN include/linux/rio.h~rapidio-modify-for-rev3-specification-changes include/linux/rio.h
--- a/include/linux/rio.h~rapidio-modify-for-rev3-specification-changes
+++ a/include/linux/rio.h
@@ -163,6 +163,7 @@ enum rio_device_state {
  * @dst_ops: Destination operation capabilities
  * @comp_tag: RIO component tag
  * @phys_efptr: RIO device extended features pointer
+ * @phys_rmap: LP-Serial Register Map Type (1 or 2)
  * @em_efptr: RIO Error Management features pointer
  * @dma_mask: Mask of bits of RIO address this device implements
  * @driver: Driver claiming this device
@@ -193,6 +194,7 @@ struct rio_dev {
 	u32 dst_ops;
 	u32 comp_tag;
 	u32 phys_efptr;
+	u32 phys_rmap;
 	u32 em_efptr;
 	u64 dma_mask;
 	struct rio_driver *driver;	/* RIO driver claiming this device */
@@ -237,11 +239,6 @@ struct rio_dbell {
 	void *dev_id;
 };
 
-enum rio_phy_type {
-	RIO_PHY_PARALLEL,
-	RIO_PHY_SERIAL,
-};
-
 /**
  * struct rio_mport - RIO master port info
  * @dbells: List of doorbell events
@@ -259,8 +256,8 @@ enum rio_phy_type {
  * @id: Port ID, unique among all ports
  * @index: Port index, unique among all port interfaces of the same type
  * @sys_size: RapidIO common transport system size
- * @phy_type: RapidIO phy type
  * @phys_efptr: RIO port extended features pointer
+ * @phys_rmap: LP-Serial EFB Register Mapping type (1 or 2).
  * @name: Port name string
  * @dev: device structure associated with an mport
  * @priv: Master port private data
@@ -289,8 +286,8 @@ struct rio_mport {
 				 * 0 - Small size. 256 devices.
 				 * 1 - Large size, 65536 devices.
 				 */
-	enum rio_phy_type phy_type;	/* RapidIO phy type */
 	u32 phys_efptr;
+	u32 phys_rmap;
 	unsigned char name[RIO_MAX_MPORT_NAME];
 	struct device dev;
 	void *priv;		/* Master port private data */
diff -puN include/linux/rio_regs.h~rapidio-modify-for-rev3-specification-changes include/linux/rio_regs.h
--- a/include/linux/rio_regs.h~rapidio-modify-for-rev3-specification-changes
+++ a/include/linux/rio_regs.h
@@ -42,9 +42,11 @@
 #define  RIO_PEF_INB_MBOX2		0x00200000	/* [II, <= 1.2] Mailbox 2 */
 #define  RIO_PEF_INB_MBOX3		0x00100000	/* [II, <= 1.2] Mailbox 3 */
 #define  RIO_PEF_INB_DOORBELL		0x00080000	/* [II, <= 1.2] Doorbells */
+#define  RIO_PEF_DEV32			0x00001000	/* [III] PE supports Common TRansport Dev32 */
 #define  RIO_PEF_EXT_RT			0x00000200	/* [III, 1.3] Extended route table support */
 #define  RIO_PEF_STD_RT			0x00000100	/* [III, 1.3] Standard route table support */
-#define  RIO_PEF_CTLS			0x00000010	/* [III] CTLS */
+#define  RIO_PEF_CTLS			0x00000010	/* [III] Common Transport Large System (< rev.3) */
+#define  RIO_PEF_DEV16			0x00000010	/* [III] PE Supports Common Transport Dev16 (rev.3) */
 #define  RIO_PEF_EXT_FEATURES		0x00000008	/* [I] EFT_PTR valid */
 #define  RIO_PEF_ADDR_66		0x00000004	/* [I] 66 bits */
 #define  RIO_PEF_ADDR_50		0x00000002	/* [I] 50 bits */
@@ -194,70 +196,101 @@
 #define RIO_GET_BLOCK_ID(x)	(x & RIO_EFB_ID_MASK)
 
 /* Extended Feature Block IDs */
-#define RIO_EFB_PAR_EP_ID	0x0001	/* [IV] LP/LVDS EP Devices */
-#define RIO_EFB_PAR_EP_REC_ID	0x0002	/* [IV] LP/LVDS EP Recovery Devices */
-#define RIO_EFB_PAR_EP_FREE_ID	0x0003	/* [IV] LP/LVDS EP Free Devices */
-#define RIO_EFB_SER_EP_ID_V13P	0x0001	/* [VI] LP/Serial EP Devices, RapidIO Spec ver 1.3 and above */
-#define RIO_EFB_SER_EP_REC_ID_V13P	0x0002	/* [VI] LP/Serial EP Recovery Devices, RapidIO Spec ver 1.3 and above */
-#define RIO_EFB_SER_EP_FREE_ID_V13P	0x0003	/* [VI] LP/Serial EP Free Devices, RapidIO Spec ver 1.3 and above */
-#define RIO_EFB_SER_EP_ID	0x0004	/* [VI] LP/Serial EP Devices */
-#define RIO_EFB_SER_EP_REC_ID	0x0005	/* [VI] LP/Serial EP Recovery Devices */
-#define RIO_EFB_SER_EP_FREE_ID	0x0006	/* [VI] LP/Serial EP Free Devices */
-#define RIO_EFB_SER_EP_FREC_ID	0x0009  /* [VI] LP/Serial EP Free Recovery Devices */
+#define RIO_EFB_SER_EP_M1_ID	0x0001	/* [VI] LP-Serial EP Devices, Map I */
+#define RIO_EFB_SER_EP_SW_M1_ID	0x0002	/* [VI] LP-Serial EP w SW Recovery Devices, Map I */
+#define RIO_EFB_SER_EPF_M1_ID	0x0003	/* [VI] LP-Serial EP Free Devices, Map I */
+#define RIO_EFB_SER_EP_ID	0x0004	/* [VI] LP-Serial EP Devices, RIO 1.2 */
+#define RIO_EFB_SER_EP_REC_ID	0x0005	/* [VI] LP-Serial EP w SW Recovery Devices, RIO 1.2 */
+#define RIO_EFB_SER_EP_FREE_ID	0x0006	/* [VI] LP-Serial EP Free Devices, RIO 1.2 */
 #define RIO_EFB_ERR_MGMNT	0x0007  /* [VIII] Error Management Extensions */
+#define RIO_EFB_SER_EPF_SW_M1_ID	0x0009  /* [VI] LP-Serial EP Free w SW Recovery Devices, Map I */
+#define RIO_EFB_SW_ROUTING_TBL	0x000E  /* [III] Switch Routing Table Block */
+#define RIO_EFB_SER_EP_M2_ID	0x0011	/* [VI] LP-Serial EP Devices, Map II */
+#define RIO_EFB_SER_EP_SW_M2_ID	0x0012	/* [VI] LP-Serial EP w SW Recovery Devices, Map II */
+#define RIO_EFB_SER_EPF_M2_ID	0x0013	/* [VI] LP-Serial EP Free Devices, Map II */
+#define RIO_EFB_ERR_MGMNT_HS	0x0017  /* [VIII] Error Management Extensions, Hot-Swap only */
+#define RIO_EFB_SER_EPF_SW_M2_ID	0x0019  /* [VI] LP-Serial EP Free w SW Recovery Devices, Map II */
 
 /*
- * Physical 8/16 LP-LVDS
- * ID=0x0001, Generic End Point Devices
- * ID=0x0002, Generic End Point Devices, software assisted recovery option
- * ID=0x0003, Generic End Point Free Devices
- *
- * Physical LP-Serial
- * ID=0x0004, Generic End Point Devices
- * ID=0x0005, Generic End Point Devices, software assisted recovery option
- * ID=0x0006, Generic End Point Free Devices
+ * Physical LP-Serial Registers Definitions
+ * Parameters in register macros:
+ *    n - port number, m - Register Map Type (1 or 2)
  */
 #define RIO_PORT_MNT_HEADER		0x0000
 #define RIO_PORT_REQ_CTL_CSR		0x0020
-#define RIO_PORT_RSP_CTL_CSR		0x0024	/* 0x0001/0x0002 */
-#define RIO_PORT_LINKTO_CTL_CSR		0x0020	/* Serial */
-#define RIO_PORT_RSPTO_CTL_CSR		0x0024	/* Serial */
+#define RIO_PORT_RSP_CTL_CSR		0x0024
+#define RIO_PORT_LINKTO_CTL_CSR		0x0020
+#define RIO_PORT_RSPTO_CTL_CSR		0x0024
 #define RIO_PORT_GEN_CTL_CSR		0x003c
 #define  RIO_PORT_GEN_HOST		0x80000000
 #define  RIO_PORT_GEN_MASTER		0x40000000
 #define  RIO_PORT_GEN_DISCOVERED	0x20000000
-#define RIO_PORT_N_MNT_REQ_CSR(x)	(0x0040 + x*0x20)	/* 0x0002 */
+#define RIO_PORT_N_MNT_REQ_CSR(n, m)	(0x40 + (n) * (0x20 * (m)))
 #define  RIO_MNT_REQ_CMD_RD		0x03	/* Reset-device command */
 #define  RIO_MNT_REQ_CMD_IS		0x04	/* Input-status command */
-#define RIO_PORT_N_MNT_RSP_CSR(x)	(0x0044 + x*0x20)	/* 0x0002 */
+#define RIO_PORT_N_MNT_RSP_CSR(n, m)	(0x44 + (n) * (0x20 * (m)))
 #define  RIO_PORT_N_MNT_RSP_RVAL	0x80000000 /* Response Valid */
 #define  RIO_PORT_N_MNT_RSP_ASTAT	0x000007e0 /* ackID Status */
 #define  RIO_PORT_N_MNT_RSP_LSTAT	0x0000001f /* Link Status */
-#define RIO_PORT_N_ACK_STS_CSR(x)	(0x0048 + x*0x20)	/* 0x0002 */
+#define RIO_PORT_N_ACK_STS_CSR(n)	(0x48 + (n) * 0x20) /* Only in RM-I */
 #define  RIO_PORT_N_ACK_CLEAR		0x80000000
 #define  RIO_PORT_N_ACK_INBOUND		0x3f000000
 #define  RIO_PORT_N_ACK_OUTSTAND	0x00003f00
 #define  RIO_PORT_N_ACK_OUTBOUND	0x0000003f
-#define RIO_PORT_N_CTL2_CSR(x)		(0x0054 + x*0x20)
+#define RIO_PORT_N_CTL2_CSR(n, m)	(0x54 + (n) * (0x20 * (m)))
 #define  RIO_PORT_N_CTL2_SEL_BAUD	0xf0000000
-#define RIO_PORT_N_ERR_STS_CSR(x)	(0x0058 + x*0x20)
-#define  RIO_PORT_N_ERR_STS_PW_OUT_ES	0x00010000 /* Output Error-stopped */
-#define  RIO_PORT_N_ERR_STS_PW_INP_ES	0x00000100 /* Input Error-stopped */
+#define RIO_PORT_N_ERR_STS_CSR(n, m)	(0x58 + (n) * (0x20 * (m)))
+#define  RIO_PORT_N_ERR_STS_OUT_ES	0x00010000 /* Output Error-stopped */
+#define  RIO_PORT_N_ERR_STS_INP_ES	0x00000100 /* Input Error-stopped */
 #define  RIO_PORT_N_ERR_STS_PW_PEND	0x00000010 /* Port-Write Pending */
+#define  RIO_PORT_N_ERR_STS_PORT_UA	0x00000008 /* Port Unavailable */
 #define  RIO_PORT_N_ERR_STS_PORT_ERR	0x00000004
 #define  RIO_PORT_N_ERR_STS_PORT_OK	0x00000002
 #define  RIO_PORT_N_ERR_STS_PORT_UNINIT	0x00000001
-#define RIO_PORT_N_CTL_CSR(x)		(0x005c + x*0x20)
+#define RIO_PORT_N_CTL_CSR(n, m)	(0x5c + (n) * (0x20 * (m)))
 #define  RIO_PORT_N_CTL_PWIDTH		0xc0000000
 #define  RIO_PORT_N_CTL_PWIDTH_1	0x00000000
 #define  RIO_PORT_N_CTL_PWIDTH_4	0x40000000
 #define  RIO_PORT_N_CTL_IPW		0x38000000 /* Initialized Port Width */
 #define  RIO_PORT_N_CTL_P_TYP_SER	0x00000001
 #define  RIO_PORT_N_CTL_LOCKOUT		0x00000002
-#define  RIO_PORT_N_CTL_EN_RX_SER	0x00200000
-#define  RIO_PORT_N_CTL_EN_TX_SER	0x00400000
-#define  RIO_PORT_N_CTL_EN_RX_PAR	0x08000000
-#define  RIO_PORT_N_CTL_EN_TX_PAR	0x40000000
+#define  RIO_PORT_N_CTL_EN_RX		0x00200000
+#define  RIO_PORT_N_CTL_EN_TX		0x00400000
+#define RIO_PORT_N_OB_ACK_CSR(n)	(0x60 + (n) * 0x40) /* Only in RM-II */
+#define  RIO_PORT_N_OB_ACK_CLEAR	0x80000000
+#define  RIO_PORT_N_OB_ACK_OUTSTD	0x00fff000
+#define  RIO_PORT_N_OB_ACK_OUTBND	0x00000fff
+#define RIO_PORT_N_IB_ACK_CSR(n)	(0x64 + (n) * 0x40) /* Only in RM-II */
+#define  RIO_PORT_N_IB_ACK_INBND	0x00000fff
+
+/*
+ * Device-based helper macros for serial port register access.
+ *   d - pointer to rapidio device object, n - port number
+ */
+
+#define RIO_DEV_PORT_N_MNT_REQ_CSR(d, n)	\
+		(d->phys_efptr + RIO_PORT_N_MNT_REQ_CSR(n, d->phys_rmap))
+
+#define RIO_DEV_PORT_N_MNT_RSP_CSR(d, n)	\
+		(d->phys_efptr + RIO_PORT_N_MNT_RSP_CSR(n, d->phys_rmap))
+
+#define RIO_DEV_PORT_N_ACK_STS_CSR(d, n)	\
+		(d->phys_efptr + RIO_PORT_N_ACK_STS_CSR(n))
+
+#define RIO_DEV_PORT_N_CTL2_CSR(d, n)		\
+		(d->phys_efptr + RIO_PORT_N_CTL2_CSR(n, d->phys_rmap))
+
+#define RIO_DEV_PORT_N_ERR_STS_CSR(d, n)	\
+		(d->phys_efptr + RIO_PORT_N_ERR_STS_CSR(n, d->phys_rmap))
+
+#define RIO_DEV_PORT_N_CTL_CSR(d, n)		\
+		(d->phys_efptr + RIO_PORT_N_CTL_CSR(n, d->phys_rmap))
+
+#define RIO_DEV_PORT_N_OB_ACK_CSR(d, n)		\
+		(d->phys_efptr + RIO_PORT_N_OB_ACK_CSR(n))
+
+#define RIO_DEV_PORT_N_IB_ACK_CSR(d, n)		\
+		(d->phys_efptr + RIO_PORT_N_IB_ACK_CSR(n))
 
 /*
  * Error Management Extensions (RapidIO 1.3+, Part 8)
@@ -268,6 +301,7 @@
 /* General EM Registers (Common for all Ports) */
 
 #define RIO_EM_EFB_HEADER	0x000	/* Error Management Extensions Block Header */
+#define RIO_EM_EMHS_CAR		0x004	/* EM Functionality CAR */
 #define RIO_EM_LTL_ERR_DETECT	0x008	/* Logical/Transport Layer Error Detect CSR */
 #define RIO_EM_LTL_ERR_EN	0x00c	/* Logical/Transport Layer Error Enable CSR */
 #define  REM_LTL_ERR_ILLTRAN		0x08000000 /* Illegal Transaction decode */
@@ -278,15 +312,33 @@
 #define RIO_EM_LTL_ADDR_CAP	0x014	/* Logical/Transport Layer Address Capture CSR */
 #define RIO_EM_LTL_DEVID_CAP	0x018	/* Logical/Transport Layer Device ID Capture CSR */
 #define RIO_EM_LTL_CTRL_CAP	0x01c	/* Logical/Transport Layer Control Capture CSR */
+#define RIO_EM_LTL_DID32_CAP	0x020	/* Logical/Transport Layer Dev32 DestID Capture CSR */
+#define RIO_EM_LTL_SID32_CAP	0x024	/* Logical/Transport Layer Dev32  source ID Capture CSR */
 #define RIO_EM_PW_TGT_DEVID	0x028	/* Port-write Target deviceID CSR */
+#define  RIO_EM_PW_TGT_DEVID_D16M	0xff000000	/* Port-write Target DID16 MSB */
+#define  RIO_EM_PW_TGT_DEVID_D8		0x00ff0000	/* Port-write Target DID16 LSB or DID8 */
+#define  RIO_EM_PW_TGT_DEVID_DEV16	0x00008000	/* Port-write Target DID16 LSB or DID8 */
+#define  RIO_EM_PW_TGT_DEVID_DEV32	0x00004000	/* Port-write Target DID16 LSB or DID8 */
 #define RIO_EM_PKT_TTL		0x02c	/* Packet Time-to-live CSR */
+#define RIO_EM_PKT_TTL_VAL		0xffff0000	/* Packet Time-to-live value */
+#define RIO_EM_PW_TGT32_DEVID	0x030	/* Port-write Dev32 Target deviceID CSR */
+#define RIO_EM_PW_TX_CTRL	0x034	/* Port-write Transmission Control CSR */
+#define RIO_EM_PW_TX_CTRL_PW_DIS	0x00000001	/* Port-write Transmission Disable bit */
 
 /* Per-Port EM Registers */
 
 #define RIO_EM_PN_ERR_DETECT(x)	(0x040 + x*0x40) /* Port N Error Detect CSR */
 #define  REM_PED_IMPL_SPEC		0x80000000
+#define  REM_PED_LINK_OK2U		0x40000000 /* Link OK to Uninit transition */
+#define  REM_PED_LINK_UPDA		0x20000000 /* Link Uninit Packet Discard Active */
+#define  REM_PED_LINK_U2OK		0x10000000 /* Link Uninit to OK transition */
 #define  REM_PED_LINK_TO		0x00000001
+
 #define RIO_EM_PN_ERRRATE_EN(x) (0x044 + x*0x40) /* Port N Error Rate Enable CSR */
+#define RIO_EM_PN_ERRRATE_EN_OK2U	0x40000000 /* Enable notification for OK2U */
+#define RIO_EM_PN_ERRRATE_EN_UPDA	0x20000000 /* Enable notification for UPDA */
+#define RIO_EM_PN_ERRRATE_EN_U2OK	0x10000000 /* Enable notification for U2OK */
+
 #define RIO_EM_PN_ATTRIB_CAP(x)	(0x048 + x*0x40) /* Port N Attributes Capture CSR */
 #define RIO_EM_PN_PKT_CAP_0(x)	(0x04c + x*0x40) /* Port N Packet/Control Symbol Capture 0 CSR */
 #define RIO_EM_PN_PKT_CAP_1(x)	(0x050 + x*0x40) /* Port N Packet Capture 1 CSR */
@@ -294,5 +346,50 @@
 #define RIO_EM_PN_PKT_CAP_3(x)	(0x058 + x*0x40) /* Port N Packet Capture 3 CSR */
 #define RIO_EM_PN_ERRRATE(x)	(0x068 + x*0x40) /* Port N Error Rate CSR */
 #define RIO_EM_PN_ERRRATE_TR(x) (0x06c + x*0x40) /* Port N Error Rate Threshold CSR */
+#define RIO_EM_PN_LINK_UDT(x)	(0x070 + x*0x40) /* Port N Link Uninit Discard Timer CSR */
+#define RIO_EM_PN_LINK_UDT_TO		0xffffff00 /* Link Uninit Timeout value */
+
+/*
+ * Switch Routing Table Register Block ID=0x000E (RapidIO 3.0+, part 3)
+ * Register offsets are defined from beginning of the block.
+ */
+
+/* Broadcast Routing Table Control CSR */
+#define RIO_BC_RT_CTL_CSR	0x020
+#define  RIO_RT_CTL_THREE_LVL		0x80000000
+#define  RIO_RT_CTL_DEV32_RT_CTRL	0x40000000
+#define  RIO_RT_CTL_MC_MASK_SZ		0x03000000 /* 3.0+ Part 11: Multicast */
+
+/* Broadcast Level 0 Info CSR */
+#define RIO_BC_RT_LVL0_INFO_CSR	0x030
+#define  RIO_RT_L0I_NUM_GR		0xff000000
+#define  RIO_RT_L0I_GR_PTR		0x00fffc00
+
+/* Broadcast Level 1 Info CSR */
+#define RIO_BC_RT_LVL1_INFO_CSR	0x034
+#define  RIO_RT_L1I_NUM_GR		0xff000000
+#define  RIO_RT_L1I_GR_PTR		0x00fffc00
+
+/* Broadcast Level 2 Info CSR */
+#define RIO_BC_RT_LVL2_INFO_CSR	0x038
+#define  RIO_RT_L2I_NUM_GR		0xff000000
+#define  RIO_RT_L2I_GR_PTR		0x00fffc00
+
+/* Per-Port Routing Table registers.
+ * Register fields defined in the broadcast section above are
+ * applicable to the corresponding registers below.
+ */
+#define RIO_SPx_RT_CTL_CSR(x)	(0x040 + (0x20 * x))
+#define RIO_SPx_RT_LVL0_INFO_CSR(x)	(0x50 + (0x20 * x))
+#define RIO_SPx_RT_LVL1_INFO_CSR(x)	(0x54 + (0x20 * x))
+#define RIO_SPx_RT_LVL2_INFO_CSR(x)	(0x58 + (0x20 * x))
+
+/* Register Formats for Routing Table Group entry.
+ * Register offsets are calculated using GR_PTR field in the corresponding
+ * table Level_N and group/entry numbers (see RapidIO 3.0+ Part 3).
+ */
+#define RIO_RT_Ln_ENTRY_IMPL_DEF	0xf0000000
+#define RIO_RT_Ln_ENTRY_RTE_VAL		0x000003ff
+#define RIO_RT_ENTRY_DROP_PKT		0x300
 
 #endif				/* LINUX_RIO_REGS_H */
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

rapidio-add-rapidio-channelized-messaging-driver.patch
rapidio-documentation-fix-mangled-paragraph-in-mport_cdev.patch
rapidio-fix-return-value-description-for-dma_prep-functions.patch
rapidio-tsi721_dma-add-channel-mask-and-queue-size-parameters.patch
rapidio-tsi721-add-pcie-mrrs-override-parameter.patch
rapidio-tsi721-add-messaging-mbox-selector-parameter.patch
rapidio-tsi721_dma-advance-queue-processing-from-transfer-submit-call.patch
rapidio-fix-error-handling-in-mbox-request-release-functions.patch
rapidio-idt_gen2-fix-locking-warning.patch
rapidio-change-inbound-window-size-type-to-u64.patch
rapidio-modify-for-rev3-specification-changes.patch
powerpc-fsl_rio-apply-changes-for-rio-spec-rev-3.patch
rapidio-switches-add-driver-for-idt-gen3-switches.patch

