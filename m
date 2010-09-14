From: akpm@linux-foundation.org
Subject: + rapidio-add-default-handler-for-error-stopped-state.patch added to -mm tree
Date: Tue, 14 Sep 2010 15:21:21 -0700
Message-ID: <201009142221.o8EMLLmp021806@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35490 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754935Ab0INWWX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Sep 2010 18:22:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexandre.bounine@idt.com, galak@kernel.crashing.org, leoli@freescale.com, micha@neli.hopto.org, mporter@kernel.crashing.org, thomas.moll@sysgo.com


The patch titled
     rapidio: add default handler for error-stopped state
has been added to the -mm tree.  Its filename is
     rapidio-add-default-handler-for-error-stopped-state.patch

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
Subject: rapidio: add default handler for error-stopped state
From: Alexandre Bounine <alexandre.bounine@idt.com>

The default error-stopped state handler provides recovery mechanism as
defined by RIO specification.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Thomas Moll <thomas.moll@sysgo.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Micha Nelissen <micha@neli.hopto.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio.c             |  218 ++++++++++++++++++++++++----
 drivers/rapidio/switches/idtcps.c |   10 +
 drivers/rapidio/switches/tsi57x.c |    4 
 include/linux/rio_regs.h          |    8 -
 4 files changed, 206 insertions(+), 34 deletions(-)

diff -puN drivers/rapidio/rio.c~rapidio-add-default-handler-for-error-stopped-state drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-add-default-handler-for-error-stopped-state
+++ a/drivers/rapidio/rio.c
@@ -495,6 +495,148 @@ int rio_set_port_lockout(struct rio_dev 
 }
 
 /**
+ * rio_get_input_status - Sends a Link-Request/Input-Status control symbol and
+ *                        returns link-response (if requested).
+ * @rdev: RIO devive to issue Input-status command
+ * @pnum: Device port number to issue the command
+ * @lnkresp: Response from a link partner
+ */
+static int
+rio_get_input_status(struct rio_dev *rdev, int pnum, u32 *lnkresp)
+{
+	struct rio_mport *mport = rdev->net->hport;
+	u16 destid = rdev->rswitch->destid;
+	u8 hopcount = rdev->rswitch->hopcount;
+	u32 regval;
+	int checkcount;
+
+	if (lnkresp) {
+		/* Read from link maintenance response register
+		 * to clear valid bit */
+		rio_mport_read_config_32(mport, destid, hopcount,
+			rdev->phys_efptr + RIO_PORT_N_MNT_RSP_CSR(pnum),
+			&regval);
+		udelay(50);
+	}
+
+	/* Issue Input-status command */
+	rio_mport_write_config_32(mport, destid, hopcount,
+		rdev->phys_efptr + RIO_PORT_N_MNT_REQ_CSR(pnum),
+		RIO_MNT_REQ_CMD_IS);
+
+	/* Exit if the response is not expected */
+	if (lnkresp == NULL)
+		return 0;
+
+	checkcount = 3;
+	while (checkcount--) {
+		udelay(50);
+		rio_mport_read_config_32(mport, destid, hopcount,
+			rdev->phys_efptr + RIO_PORT_N_MNT_RSP_CSR(pnum),
+			&regval);
+		if (regval & RIO_PORT_N_MNT_RSP_RVAL) {
+			*lnkresp = regval;
+			return 0;
+		}
+	}
+
+	return -EIO;
+}
+
+/**
+ * rio_clr_err_stopped - Clears port Error-stopped states.
+ * @rdev: Pointer to RIO device control structure
+ * @pnum: Switch port number to clear errors
+ * @err_status: port error status (if 0 reads register from device)
+ */
+static int rio_clr_err_stopped(struct rio_dev *rdev, u32 pnum, u32 err_status)
+{
+	struct rio_mport *mport = rdev->net->hport;
+	u16 destid = rdev->rswitch->destid;
+	u8 hopcount = rdev->rswitch->hopcount;
+	struct rio_dev *nextdev = rdev->rswitch->nextdev[pnum];
+	u32 regval;
+	u32 far_ackid, far_linkstat, near_ackid;
+
+	if (err_status == 0)
+		rio_mport_read_config_32(mport, destid, hopcount,
+			rdev->phys_efptr + RIO_PORT_N_ERR_STS_CSR(pnum),
+			&err_status);
+
+	if (err_status & RIO_PORT_N_ERR_STS_PW_OUT_ES) {
+		pr_debug("RIO_EM: servicing Output Error-Stopped state\n");
+		/*
+		 * Send a Link-Request/Input-Status control symbol
+		 */
+		if (rio_get_input_status(rdev, pnum, &regval)) {
+			pr_debug("RIO_EM: Input-status response timeout\n");
+			goto rd_err;
+		}
+
+		pr_debug("RIO_EM: SP%d Input-status response=0x%08x\n",
+			 pnum, regval);
+		far_ackid = (regval & RIO_PORT_N_MNT_RSP_ASTAT) >> 5;
+		far_linkstat = regval & RIO_PORT_N_MNT_RSP_LSTAT;
+		rio_mport_read_config_32(mport, destid, hopcount,
+			rdev->phys_efptr + RIO_PORT_N_ACK_STS_CSR(pnum),
+			&regval);
+		pr_debug("RIO_EM: SP%d_ACK_STS_CSR=0x%08x\n", pnum, regval);
+		near_ackid = (regval & RIO_PORT_N_ACK_INBOUND) >> 24;
+		pr_debug("RIO_EM: SP%d far_ackID=0x%02x far_linkstat=0x%02x" \
+			 " near_ackID=0x%02x\n",
+			pnum, far_ackid, far_linkstat, near_ackid);
+
+		/*
+		 * If required, synchronize ackIDs of near and
+		 * far sides.
+		 */
+		if ((far_ackid != ((regval & RIO_PORT_N_ACK_OUTSTAND) >> 8)) ||
+		    (far_ackid != (regval & RIO_PORT_N_ACK_OUTBOUND))) {
+			/* Align near outstanding/outbound ackIDs with
+			 * far inbound.
+			 */
+			rio_mport_write_config_32(mport, destid,
+				hopcount, rdev->phys_efptr +
+					RIO_PORT_N_ACK_STS_CSR(pnum),
+				(near_ackid << 24) |
+					(far_ackid << 8) | far_ackid);
+			/* Align far outstanding/outbound ackIDs with
+			 * near inbound.
+			 */
+			far_ackid++;
+			if (nextdev)
+				rio_write_config_32(nextdev,
+					nextdev->phys_efptr +
+					RIO_PORT_N_ACK_STS_CSR(RIO_GET_PORT_NUM(nextdev->swpinfo)),
+					(far_ackid << 24) |
+					(near_ackid << 8) | near_ackid);
+			else
+				pr_debug("RIO_EM: Invalid nextdev pointer (NULL)\n");
+		}
+rd_err:
+		rio_mport_read_config_32(mport, destid, hopcount,
+			rdev->phys_efptr + RIO_PORT_N_ERR_STS_CSR(pnum),
+			&err_status);
+		pr_debug("RIO_EM: SP%d_ERR_STS_CSR=0x%08x\n", pnum, err_status);
+	}
+
+	if ((err_status & RIO_PORT_N_ERR_STS_PW_INP_ES) && nextdev) {
+		pr_debug("RIO_EM: servicing Input Error-Stopped state\n");
+		rio_get_input_status(nextdev,
+				     RIO_GET_PORT_NUM(nextdev->swpinfo), NULL);
+		udelay(50);
+
+		rio_mport_read_config_32(mport, destid, hopcount,
+			rdev->phys_efptr + RIO_PORT_N_ERR_STS_CSR(pnum),
+			&err_status);
+		pr_debug("RIO_EM: SP%d_ERR_STS_CSR=0x%08x\n", pnum, err_status);
+	}
+
+	return (err_status & (RIO_PORT_N_ERR_STS_PW_OUT_ES |
+			      RIO_PORT_N_ERR_STS_PW_INP_ES)) ? 1 : 0;
+}
+
+/**
  * rio_inb_pwrite_handler - process inbound port-write message
  * @pw_msg: pointer to inbound port-write message
  *
@@ -507,7 +649,7 @@ int rio_inb_pwrite_handler(union rio_pw_
 	struct rio_mport *mport;
 	u8 hopcount;
 	u16 destid;
-	u32 err_status;
+	u32 err_status, em_perrdet, em_ltlerrdet;
 	int rc, portnum;
 
 	rdev = rio_get_comptag(pw_msg->em.comptag, NULL);
@@ -524,12 +666,11 @@ int rio_inb_pwrite_handler(union rio_pw_
 	{
 	u32 i;
 	for (i = 0; i < RIO_PW_MSG_SIZE/sizeof(u32);) {
-			pr_debug("0x%02x: %08x %08x %08x %08x",
+			pr_debug("0x%02x: %08x %08x %08x %08x\n",
 				 i*4, pw_msg->raw[i], pw_msg->raw[i + 1],
 				 pw_msg->raw[i + 2], pw_msg->raw[i + 3]);
 			i += 4;
 	}
-	pr_debug("\n");
 	}
 #endif
 
@@ -573,29 +714,28 @@ int rio_inb_pwrite_handler(union rio_pw_
 			&err_status);
 	pr_debug("RIO_PW: SP%d_ERR_STS_CSR=0x%08x\n", portnum, err_status);
 
-	if (pw_msg->em.errdetect) {
-		pr_debug("RIO_PW: RIO_EM_P%d_ERR_DETECT=0x%08x\n",
-			 portnum, pw_msg->em.errdetect);
-		/* Clear EM Port N Error Detect CSR */
-		rio_mport_write_config_32(mport, destid, hopcount,
-			rdev->em_efptr + RIO_EM_PN_ERR_DETECT(portnum), 0);
-	}
+	if (err_status & RIO_PORT_N_ERR_STS_PORT_OK) {
 
-	if (pw_msg->em.ltlerrdet) {
-		pr_debug("RIO_PW: RIO_EM_LTL_ERR_DETECT=0x%08x\n",
-			 pw_msg->em.ltlerrdet);
-		/* Clear EM L/T Layer Error Detect CSR */
-		rio_mport_write_config_32(mport, destid, hopcount,
-			rdev->em_efptr + RIO_EM_LTL_ERR_DETECT, 0);
-	}
+		if (!(rdev->rswitch->port_ok & (1 << portnum))) {
+			rdev->rswitch->port_ok |= (1 << portnum);
+			rio_set_port_lockout(rdev, portnum, 0);
+			/* Schedule Insertion Service */
+			pr_debug("RIO_PW: Device Insertion on [%s]-P%d\n",
+			       rio_name(rdev), portnum);
+		}
 
-	/* Clear Port Errors */
-	rio_mport_write_config_32(mport, destid, hopcount,
-			rdev->phys_efptr + RIO_PORT_N_ERR_STS_CSR(portnum),
-			err_status & RIO_PORT_N_ERR_STS_CLR_MASK);
+		/* Clear error-stopped states (if reported).
+		 * Depending on the link partner state, two attempts
+		 * may be needed for successful recovery.
+		 */
+		if (err_status & (RIO_PORT_N_ERR_STS_PW_OUT_ES |
+				  RIO_PORT_N_ERR_STS_PW_INP_ES)) {
+			if (rio_clr_err_stopped(rdev, portnum, err_status))
+				rio_clr_err_stopped(rdev, portnum, 0);
+		}
+	}  else { /* if (err_status & RIO_PORT_N_ERR_STS_PORT_UNINIT) */
 
-	if (rdev->rswitch->port_ok & (1 << portnum)) {
-		if (err_status & RIO_PORT_N_ERR_STS_PORT_UNINIT) {
+		if (rdev->rswitch->port_ok & (1 << portnum)) {
 			rdev->rswitch->port_ok &= ~(1 << portnum);
 			rio_set_port_lockout(rdev, portnum, 1);
 
@@ -608,17 +748,33 @@ int rio_inb_pwrite_handler(union rio_pw_
 			pr_debug("RIO_PW: Device Extraction on [%s]-P%d\n",
 			       rio_name(rdev), portnum);
 		}
-	} else {
-		if (err_status & RIO_PORT_N_ERR_STS_PORT_OK) {
-			rdev->rswitch->port_ok |= (1 << portnum);
-			rio_set_port_lockout(rdev, portnum, 0);
+	}
 
-			/* Schedule Insertion Service */
-			pr_debug("RIO_PW: Device Insertion on [%s]-P%d\n",
-			       rio_name(rdev), portnum);
-		}
+	rio_mport_read_config_32(mport, destid, hopcount,
+		rdev->em_efptr + RIO_EM_PN_ERR_DETECT(portnum), &em_perrdet);
+	if (em_perrdet) {
+		pr_debug("RIO_PW: RIO_EM_P%d_ERR_DETECT=0x%08x\n",
+			 portnum, em_perrdet);
+		/* Clear EM Port N Error Detect CSR */
+		rio_mport_write_config_32(mport, destid, hopcount,
+			rdev->em_efptr + RIO_EM_PN_ERR_DETECT(portnum), 0);
+	}
+
+	rio_mport_read_config_32(mport, destid, hopcount,
+		rdev->em_efptr + RIO_EM_LTL_ERR_DETECT, &em_ltlerrdet);
+	if (em_ltlerrdet) {
+		pr_debug("RIO_PW: RIO_EM_LTL_ERR_DETECT=0x%08x\n",
+			 em_ltlerrdet);
+		/* Clear EM L/T Layer Error Detect CSR */
+		rio_mport_write_config_32(mport, destid, hopcount,
+			rdev->em_efptr + RIO_EM_LTL_ERR_DETECT, 0);
 	}
 
+	/* Clear remaining error bits */
+	rio_mport_write_config_32(mport, destid, hopcount,
+			rdev->phys_efptr + RIO_PORT_N_ERR_STS_CSR(portnum),
+			err_status & RIO_PORT_N_ERR_STS_CLR_MASK);
+
 	/* Clear Port-Write Pending bit */
 	rio_mport_write_config_32(mport, destid, hopcount,
 			rdev->phys_efptr + RIO_PORT_N_ERR_STS_CSR(portnum),
diff -puN drivers/rapidio/switches/idtcps.c~rapidio-add-default-handler-for-error-stopped-state drivers/rapidio/switches/idtcps.c
--- a/drivers/rapidio/switches/idtcps.c~rapidio-add-default-handler-for-error-stopped-state
+++ a/drivers/rapidio/switches/idtcps.c
@@ -117,6 +117,10 @@ idtcps_get_domain(struct rio_mport *mpor
 
 static int idtcps_switch_init(struct rio_dev *rdev, int do_enum)
 {
+	struct rio_mport *mport = rdev->net->hport;
+	u16 destid = rdev->rswitch->destid;
+	u8 hopcount = rdev->rswitch->hopcount;
+
 	pr_debug("RIO: %s for %s\n", __func__, rio_name(rdev));
 	rdev->rswitch->add_entry = idtcps_route_add_entry;
 	rdev->rswitch->get_entry = idtcps_route_get_entry;
@@ -126,6 +130,12 @@ static int idtcps_switch_init(struct rio
 	rdev->rswitch->em_init = NULL;
 	rdev->rswitch->em_handle = NULL;
 
+	if (do_enum) {
+		/* set TVAL = ~50us */
+		rio_mport_write_config_32(mport, destid, hopcount,
+			rdev->phys_efptr + RIO_PORT_LINKTO_CTL_CSR, 0x8e << 8);
+	}
+
 	return 0;
 }
 
diff -puN drivers/rapidio/switches/tsi57x.c~rapidio-add-default-handler-for-error-stopped-state drivers/rapidio/switches/tsi57x.c
--- a/drivers/rapidio/switches/tsi57x.c~rapidio-add-default-handler-for-error-stopped-state
+++ a/drivers/rapidio/switches/tsi57x.c
@@ -205,6 +205,10 @@ tsi57x_em_init(struct rio_dev *rdev)
 			portnum++;
 	}
 
+	/* set TVAL = ~50us */
+	rio_mport_write_config_32(mport, destid, hopcount,
+		rdev->phys_efptr + RIO_PORT_LINKTO_CTL_CSR, 0x9a << 8);
+
 	return 0;
 }
 
diff -puN include/linux/rio_regs.h~rapidio-add-default-handler-for-error-stopped-state include/linux/rio_regs.h
--- a/include/linux/rio_regs.h~rapidio-add-default-handler-for-error-stopped-state
+++ a/include/linux/rio_regs.h
@@ -224,15 +224,17 @@
 #define  RIO_PORT_GEN_MASTER		0x40000000
 #define  RIO_PORT_GEN_DISCOVERED	0x20000000
 #define RIO_PORT_N_MNT_REQ_CSR(x)	(0x0040 + x*0x20)	/* 0x0002 */
+#define  RIO_MNT_REQ_CMD_RD		0x03	/* Reset-device command */
+#define  RIO_MNT_REQ_CMD_IS		0x04	/* Input-status command */
 #define RIO_PORT_N_MNT_RSP_CSR(x)	(0x0044 + x*0x20)	/* 0x0002 */
 #define  RIO_PORT_N_MNT_RSP_RVAL	0x80000000 /* Response Valid */
 #define  RIO_PORT_N_MNT_RSP_ASTAT	0x000003e0 /* ackID Status */
 #define  RIO_PORT_N_MNT_RSP_LSTAT	0x0000001f /* Link Status */
 #define RIO_PORT_N_ACK_STS_CSR(x)	(0x0048 + x*0x20)	/* 0x0002 */
 #define  RIO_PORT_N_ACK_CLEAR		0x80000000
-#define  RIO_PORT_N_ACK_INBOUND		0x1f000000
-#define  RIO_PORT_N_ACK_OUTSTAND	0x00001f00
-#define  RIO_PORT_N_ACK_OUTBOUND	0x0000001f
+#define  RIO_PORT_N_ACK_INBOUND		0x3f000000
+#define  RIO_PORT_N_ACK_OUTSTAND	0x00003f00
+#define  RIO_PORT_N_ACK_OUTBOUND	0x0000003f
 #define RIO_PORT_N_ERR_STS_CSR(x)	(0x0058 + x*0x20)
 #define  RIO_PORT_N_ERR_STS_PW_OUT_ES	0x00010000 /* Output Error-stopped */
 #define  RIO_PORT_N_ERR_STS_PW_INP_ES	0x00000100 /* Input Error-stopped */
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

