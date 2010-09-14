From: akpm@linux-foundation.org
Subject: + rapidio-add-handling-of-redundant-routes.patch added to -mm tree
Date: Tue, 14 Sep 2010 15:21:35 -0700
Message-ID: <201009142221.o8EMLZZF021822@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51256 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752281Ab0INWXE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Sep 2010 18:23:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexandre.bounine@idt.com, galak@kernel.crashing.org, leoli@freescale.com, micha@neli.hopto.org, mporter@kernel.crashing.org, thomas.moll@sysgo.com


The patch titled
     rapidio: add handling of redundant routes
has been added to the -mm tree.  Its filename is
     rapidio-add-handling-of-redundant-routes.patch

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
Subject: rapidio: add handling of redundant routes
From: Alexandre Bounine <alexandre.bounine@idt.com>

Detects RIO link to the already enumerated device and properly sets links
between device objects.  Changes to the enumeration/discovery logic:

1. Use Master Enable bit to signal end of the enumeration - agents may
   start their discovery process as soon as they see this bit set
   (Component Tag register was used before for this purpose).

2. Enumerator sets Component Tag (!= 0) immediately during device
   setup.  This allows to identify the device if the redundant route
   exists in a RIO system.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Thomas Moll <thomas.moll@sysgo.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Micha Nelissen <micha@neli.hopto.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/sysdev/fsl_rio.c |    8 ++
 drivers/rapidio/rio-scan.c    |   88 ++++++++++++++++----------------
 drivers/rapidio/rio.c         |   16 ++---
 drivers/rapidio/rio.h         |    1 
 include/linux/rio.h           |    2 
 5 files changed, 64 insertions(+), 51 deletions(-)

diff -puN arch/powerpc/sysdev/fsl_rio.c~rapidio-add-handling-of-redundant-routes arch/powerpc/sysdev/fsl_rio.c
--- a/arch/powerpc/sysdev/fsl_rio.c~rapidio-add-handling-of-redundant-routes
+++ a/arch/powerpc/sysdev/fsl_rio.c
@@ -50,6 +50,7 @@
 #define RIO_ATMU_REGS_OFFSET	0x10c00
 #define RIO_P_MSG_REGS_OFFSET	0x11000
 #define RIO_S_MSG_REGS_OFFSET	0x13000
+#define RIO_GCCSR		0x13c
 #define RIO_ESCSR		0x158
 #define RIO_CCSR		0x15c
 #define RIO_LTLEDCSR		0x0608
@@ -1456,6 +1457,7 @@ int fsl_rio_setup(struct platform_device
 	port->host_deviceid = fsl_rio_get_hdid(port->id);
 
 	port->priv = priv;
+	port->phys_efptr = 0x100;
 	rio_register_mport(port);
 
 	priv->regs_win = ioremap(regs.start, regs.end - regs.start + 1);
@@ -1503,6 +1505,12 @@ int fsl_rio_setup(struct platform_device
 	dev_info(&dev->dev, "RapidIO Common Transport System size: %d\n",
 			port->sys_size ? 65536 : 256);
 
+	if (port->host_deviceid >= 0)
+		out_be32(priv->regs_win + RIO_GCCSR, RIO_PORT_GEN_HOST |
+			RIO_PORT_GEN_MASTER | RIO_PORT_GEN_DISCOVERED);
+	else
+		out_be32(priv->regs_win + RIO_GCCSR, 0x00000000);
+
 	priv->atmu_regs = (struct rio_atmu_regs *)(priv->regs_win
 					+ RIO_ATMU_REGS_OFFSET);
 	priv->maint_atmu_regs = priv->atmu_regs + 1;
diff -puN drivers/rapidio/rio-scan.c~rapidio-add-handling-of-redundant-routes drivers/rapidio/rio-scan.c
--- a/drivers/rapidio/rio-scan.c~rapidio-add-handling-of-redundant-routes
+++ a/drivers/rapidio/rio-scan.c
@@ -48,7 +48,7 @@ DEFINE_SPINLOCK(rio_global_list_lock);
 static int next_destid = 0;
 static int next_switchid = 0;
 static int next_net = 0;
-static int next_comptag;
+static int next_comptag = 1;
 
 static struct timer_list rio_enum_timer =
 TIMER_INITIALIZER(rio_enum_timeout, 0, 0);
@@ -121,27 +121,6 @@ static int rio_clear_locks(struct rio_mp
 	u32 result;
 	int ret = 0;
 
-	/* Assign component tag to all devices */
-	next_comptag = 1;
-	rio_local_write_config_32(port, RIO_COMPONENT_TAG_CSR, next_comptag++);
-
-	list_for_each_entry(rdev, &rio_devices, global_list) {
-		/* Mark device as discovered */
-		rio_read_config_32(rdev,
-				   rdev->phys_efptr + RIO_PORT_GEN_CTL_CSR,
-				   &result);
-		rio_write_config_32(rdev,
-				    rdev->phys_efptr + RIO_PORT_GEN_CTL_CSR,
-				    result | RIO_PORT_GEN_DISCOVERED);
-
-		rio_write_config_32(rdev, RIO_COMPONENT_TAG_CSR, next_comptag);
-		rdev->comp_tag = next_comptag++;
-		if (next_comptag >= 0x10000) {
-			pr_err("RIO: Component Tag Counter Overflow\n");
-			break;
-		}
-	}
-
 	/* Release host device id locks */
 	rio_local_write_config_32(port, RIO_HOST_DID_LOCK_CSR,
 				  port->host_deviceid);
@@ -162,6 +141,15 @@ static int rio_clear_locks(struct rio_mp
 			       rdev->vid, rdev->did);
 			ret = -EINVAL;
 		}
+
+		/* Mark device as discovered and enable master */
+		rio_read_config_32(rdev,
+				   rdev->phys_efptr + RIO_PORT_GEN_CTL_CSR,
+				   &result);
+		result |= RIO_PORT_GEN_DISCOVERED | RIO_PORT_GEN_MASTER;
+		rio_write_config_32(rdev,
+				    rdev->phys_efptr + RIO_PORT_GEN_CTL_CSR,
+				    result);
 	}
 
 	return ret;
@@ -430,6 +418,17 @@ static struct rio_dev __devinit *rio_set
 	rio_mport_read_config_32(port, destid, hopcount, RIO_DST_OPS_CAR,
 				 &rdev->dst_ops);
 
+	if (do_enum) {
+		/* Assign component tag to device */
+		if (next_comptag >= 0x10000) {
+			pr_err("RIO: Component Tag Counter Overflow\n");
+			goto cleanup;
+		}
+		rio_mport_write_config_32(port, destid, hopcount,
+					  RIO_COMPONENT_TAG_CSR, next_comptag);
+		rdev->comp_tag = next_comptag++;
+	}
+
 	if (rio_device_has_destid(port, rdev->src_ops, rdev->dst_ops)) {
 		if (do_enum) {
 			rio_set_device_id(port, destid, hopcount, next_destid);
@@ -726,21 +725,6 @@ static u16 rio_get_host_deviceid_lock(st
 }
 
 /**
- * rio_net_add_mport- Add a master port to a RIO network
- * @net: RIO network
- * @port: Master port to add
- *
- * Adds a master port to the network list of associated master
- * ports..
- */
-static void rio_net_add_mport(struct rio_net *net, struct rio_mport *port)
-{
-	spin_lock(&rio_global_list_lock);
-	list_add_tail(&port->nnode, &net->mports);
-	spin_unlock(&rio_global_list_lock);
-}
-
-/**
  * rio_enum_peer- Recursively enumerate a RIO network through a master port
  * @net: RIO network being enumerated
  * @port: Master port to send transactions
@@ -760,6 +744,7 @@ static int __devinit rio_enum_peer(struc
 	int sw_inport;
 	struct rio_dev *rdev;
 	u16 destid;
+	u32 regval;
 	int tmp;
 
 	if (rio_mport_chk_dev_access(port,
@@ -772,9 +757,21 @@ static int __devinit rio_enum_peer(struc
 		pr_debug("RIO: PE already discovered by this host\n");
 		/*
 		 * Already discovered by this host. Add it as another
-		 * master port for the current network.
+		 * link to the existing device.
 		 */
-		rio_net_add_mport(net, port);
+		rio_mport_read_config_32(port, RIO_ANY_DESTID(port->sys_size),
+				hopcount, RIO_COMPONENT_TAG_CSR, &regval);
+
+		if (regval) {
+			rdev = rio_get_comptag((regval & 0xffff), NULL);
+
+			if (rdev && prev && rio_is_switch(prev)) {
+				pr_debug("RIO: redundant path to %s\n",
+					 rio_name(rdev));
+				prev->rswitch->nextdev[prev_port] = rdev;
+			}
+		}
+
 		return 0;
 	}
 
@@ -925,10 +922,11 @@ static int __devinit rio_enum_peer(struc
  */
 static int rio_enum_complete(struct rio_mport *port)
 {
-	u32 tag_csr;
+	u32 regval;
 
-	rio_local_read_config_32(port, RIO_COMPONENT_TAG_CSR, &tag_csr);
-	return (tag_csr & 0xffff) ? 1 : 0;
+	rio_local_read_config_32(port, port->phys_efptr + RIO_PORT_GEN_CTL_CSR,
+				 &regval);
+	return (regval & RIO_PORT_GEN_MASTER) ? 1 : 0;
 }
 
 /**
@@ -991,6 +989,8 @@ rio_disc_peer(struct rio_net *net, struc
 						break;
 				}
 
+				if (ndestid == RIO_ANY_DESTID(port->sys_size))
+					continue;
 				rio_unlock_device(port, destid, hopcount);
 				if (rio_disc_peer
 				    (net, port, ndestid, hopcount + 1) < 0)
@@ -1163,6 +1163,10 @@ int __devinit rio_enum_mport(struct rio_
 		/* Enable Input Output Port (transmitter reviever) */
 		rio_enable_rx_tx_port(mport, 1, 0, 0, 0);
 
+		/* Set component tag for host */
+		rio_local_write_config_32(mport, RIO_COMPONENT_TAG_CSR,
+					  next_comptag++);
+
 		if (rio_enum_peer(net, mport, 0, NULL, 0) < 0) {
 			/* A higher priority host won enumeration, bail. */
 			printk(KERN_INFO
diff -puN drivers/rapidio/rio.c~rapidio-add-handling-of-redundant-routes drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-add-handling-of-redundant-routes
+++ a/drivers/rapidio/rio.c
@@ -443,7 +443,7 @@ rio_mport_get_physefb(struct rio_mport *
  * @from is not %NULL, searches continue from next device on the global
  * list.
  */
-static struct rio_dev *rio_get_comptag(u32 comp_tag, struct rio_dev *from)
+struct rio_dev *rio_get_comptag(u32 comp_tag, struct rio_dev *from)
 {
 	struct list_head *n;
 	struct rio_dev *rdev;
@@ -507,7 +507,7 @@ static int
 rio_chk_dev_route(struct rio_dev *rdev, struct rio_dev **nrdev, int *npnum)
 {
 	u32 result;
-	int p_port, rc = -EIO;
+	int p_port, dstid, rc = -EIO;
 	struct rio_dev *prev = NULL;
 
 	/* Find switch with failed RIO link */
@@ -522,20 +522,18 @@ rio_chk_dev_route(struct rio_dev *rdev, 
 	if (prev == NULL)
 		goto err_out;
 
-	/* Find port with failed RIO link */
-	for (p_port = 0;
-	     p_port < RIO_GET_TOTAL_PORTS(prev->swpinfo); p_port++)
-		if (prev->rswitch->nextdev[p_port] == rdev)
-			break;
+	dstid = (rdev->pef & RIO_PEF_SWITCH) ?
+			rdev->rswitch->destid : rdev->destid;
+	p_port = prev->rswitch->route_table[dstid];
 
-	if (p_port < RIO_GET_TOTAL_PORTS(prev->swpinfo)) {
+	if (p_port != RIO_INVALID_ROUTE) {
 		pr_debug("RIO: link failed on [%s]-P%d\n",
 			 rio_name(prev), p_port);
 		*nrdev = prev;
 		*npnum = p_port;
 		rc = 0;
 	} else
-		pr_debug("RIO: failed to trace route to %s\n", rio_name(prev));
+		pr_debug("RIO: failed to trace route to %s\n", rio_name(rdev));
 err_out:
 	return rc;
 }
diff -puN drivers/rapidio/rio.h~rapidio-add-handling-of-redundant-routes drivers/rapidio/rio.h
--- a/drivers/rapidio/rio.h~rapidio-add-handling-of-redundant-routes
+++ a/drivers/rapidio/rio.h
@@ -38,6 +38,7 @@ extern int rio_std_route_get_entry(struc
 extern int rio_std_route_clr_table(struct rio_mport *mport, u16 destid,
 				   u8 hopcount, u16 table);
 extern int rio_set_port_lockout(struct rio_dev *rdev, u32 pnum, int lock);
+extern struct rio_dev *rio_get_comptag(u32 comp_tag, struct rio_dev *from);
 
 /* Structures internal to the RIO core code */
 extern struct device_attribute rio_dev_attrs[];
diff -puN include/linux/rio.h~rapidio-add-handling-of-redundant-routes include/linux/rio.h
--- a/include/linux/rio.h~rapidio-add-handling-of-redundant-routes
+++ a/include/linux/rio.h
@@ -177,6 +177,7 @@ enum rio_phy_type {
  * @index: Port index, unique among all port interfaces of the same type
  * @sys_size: RapidIO common transport system size
  * @phy_type: RapidIO phy type
+ * @phys_efptr: RIO port extended features pointer
  * @name: Port name string
  * @priv: Master port private data
  */
@@ -198,6 +199,7 @@ struct rio_mport {
 				 * 1 - Large size, 65536 devices.
 				 */
 	enum rio_phy_type phy_type;	/* RapidIO phy type */
+	u32 phys_efptr;
 	unsigned char name[40];
 	void *priv;		/* Master port private data */
 };
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

