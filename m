From: akpm@linux-foundation.org
Subject: + rapidio-use-stored-ingress-port-number-instead-of-register-read.patch added to -mm tree
Date: Tue, 14 Sep 2010 15:21:17 -0700
Message-ID: <201009142221.o8EMLHkf021794@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38903 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755084Ab0INWVu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Sep 2010 18:21:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexandre.bounine@idt.com, galak@kernel.crashing.org, leoli@freescale.com, micha@neli.hopto.org, mporter@kernel.crashing.org, thomas.moll@sysgo.com


The patch titled
     rapidio: use stored ingress port number instead of register read
has been added to the -mm tree.  Its filename is
     rapidio-use-stored-ingress-port-number-instead-of-register-read.patch

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
Subject: rapidio: use stored ingress port number instead of register read
From: Alexandre Bounine <alexandre.bounine@idt.com>

A switch port information is obtained and stored during RIO device
  setup.  Therefore repeated reads from Switch Port Information CAR may be
  removed.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Thomas Moll <thomas.moll@sysgo.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Micha Nelissen <micha@neli.hopto.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio-scan.c |   36 ++++++++---------------------------
 include/linux/rio.h        |    4 ++-
 include/linux/rio_regs.h   |    2 +
 3 files changed, 14 insertions(+), 28 deletions(-)

diff -puN drivers/rapidio/rio-scan.c~rapidio-use-stored-ingress-port-number-instead-of-register-read drivers/rapidio/rio-scan.c
--- a/drivers/rapidio/rio-scan.c~rapidio-use-stored-ingress-port-number-instead-of-register-read
+++ a/drivers/rapidio/rio-scan.c
@@ -420,6 +420,11 @@ static struct rio_dev __devinit *rio_set
 						hopcount, RIO_EFB_ERR_MGMNT);
 	}
 
+	if (rdev->pef & (RIO_PEF_SWITCH | RIO_PEF_MULTIPORT)) {
+		rio_mport_read_config_32(port, destid, hopcount,
+					 RIO_SWP_INFO_CAR, &rdev->swpinfo);
+	}
+
 	rio_mport_read_config_32(port, destid, hopcount, RIO_SRC_OPS_CAR,
 				 &rdev->src_ops);
 	rio_mport_read_config_32(port, destid, hopcount, RIO_DST_OPS_CAR,
@@ -439,8 +444,6 @@ static struct rio_dev __devinit *rio_set
 
 	/* If a PE has both switch and other functions, show it as a switch */
 	if (rio_is_switch(rdev)) {
-		rio_mport_read_config_32(port, destid, hopcount,
-					 RIO_SWP_INFO_CAR, &rdev->swpinfo);
 		rswitch = kzalloc(sizeof(struct rio_switch), GFP_KERNEL);
 		if (!rswitch)
 			goto cleanup;
@@ -458,6 +461,7 @@ static struct rio_dev __devinit *rio_set
 				rdid++)
 			rswitch->route_table[rdid] = RIO_INVALID_ROUTE;
 		rdev->rswitch = rswitch;
+		rswitch->rdev = rdev;
 		dev_set_name(&rdev->dev, "%02x:s:%04x", rdev->net->id,
 			     rdev->rswitch->switchid);
 		rio_switch_init(rdev, do_enum);
@@ -719,25 +723,6 @@ static u16 rio_get_host_deviceid_lock(st
 }
 
 /**
- * rio_get_swpinfo_inport- Gets the ingress port number
- * @mport: Master port to send transaction
- * @destid: Destination ID associated with the switch
- * @hopcount: Number of hops to the device
- *
- * Returns port number being used to access the switch device.
- */
-static u8
-rio_get_swpinfo_inport(struct rio_mport *mport, u16 destid, u8 hopcount)
-{
-	u32 result;
-
-	rio_mport_read_config_32(mport, destid, hopcount, RIO_SWP_INFO_CAR,
-				 &result);
-
-	return (u8) (result & 0xff);
-}
-
-/**
  * rio_get_swpinfo_tports- Gets total number of ports on the switch
  * @mport: Master port to send transaction
  * @destid: Destination ID associated with the switch
@@ -834,8 +819,7 @@ static int __devinit rio_enum_peer(struc
 
 	if (rio_is_switch(rdev)) {
 		next_switchid++;
-		sw_inport = rio_get_swpinfo_inport(port,
-				RIO_ANY_DESTID(port->sys_size), hopcount);
+		sw_inport = RIO_GET_PORT_NUM(rdev->swpinfo);
 		rio_route_add_entry(port, rdev->rswitch, RIO_GLOBAL_TABLE,
 				    port->host_deviceid, sw_inport, 0);
 		rdev->rswitch->route_table[port->host_deviceid] = sw_inport;
@@ -989,8 +973,7 @@ rio_disc_peer(struct rio_net *net, struc
 		    "RIO: found %s (vid %4.4x did %4.4x) with %d ports\n",
 		    rio_name(rdev), rdev->vid, rdev->did, num_ports);
 		for (port_num = 0; port_num < num_ports; port_num++) {
-			if (rio_get_swpinfo_inport(port, destid, hopcount) ==
-			    port_num)
+			if (RIO_GET_PORT_NUM(rdev->swpinfo) == port_num)
 				continue;
 
 			if (rio_sport_is_active
@@ -1109,8 +1092,7 @@ static void rio_update_route_tables(stru
 				if (rswitch->destid == destid)
 					continue;
 
-				sport = rio_get_swpinfo_inport(port,
-						rswitch->destid, rswitch->hopcount);
+				sport = RIO_GET_PORT_NUM(rswitch->rdev->swpinfo);
 
 				if (rswitch->add_entry)	{
 					rio_route_add_entry(port, rswitch,
diff -puN include/linux/rio.h~rapidio-use-stored-ingress-port-number-instead-of-register-read include/linux/rio.h
--- a/include/linux/rio.h~rapidio-use-stored-ingress-port-number-instead-of-register-read
+++ a/include/linux/rio.h
@@ -112,7 +112,7 @@ struct rio_dev {
 	u16 asm_rev;
 	u16 efptr;
 	u32 pef;
-	u32 swpinfo;		/* Only used for switches */
+	u32 swpinfo;
 	u32 src_ops;
 	u32 dst_ops;
 	u32 comp_tag;
@@ -219,6 +219,7 @@ struct rio_net {
 /**
  * struct rio_switch - RIO switch info
  * @node: Node in global list of switches
+ * @rdev: Associated RIO device structure
  * @switchid: Switch ID that is unique across a network
  * @hopcount: Hopcount to this switch
  * @destid: Associated destid in the path
@@ -234,6 +235,7 @@ struct rio_net {
  */
 struct rio_switch {
 	struct list_head node;
+	struct rio_dev *rdev;
 	u16 switchid;
 	u16 hopcount;
 	u16 destid;
diff -puN include/linux/rio_regs.h~rapidio-use-stored-ingress-port-number-instead-of-register-read include/linux/rio_regs.h
--- a/include/linux/rio_regs.h~rapidio-use-stored-ingress-port-number-instead-of-register-read
+++ a/include/linux/rio_regs.h
@@ -33,6 +33,7 @@
 #define  RIO_PEF_MEMORY			0x40000000	/* [I] MMIO */
 #define  RIO_PEF_PROCESSOR		0x20000000	/* [I] Processor */
 #define  RIO_PEF_SWITCH			0x10000000	/* [I] Switch */
+#define  RIO_PEF_MULTIPORT		0x08000000	/* [VI, 2.1] Multiport */
 #define  RIO_PEF_INB_MBOX		0x00f00000	/* [II] Mailboxes */
 #define  RIO_PEF_INB_MBOX0		0x00800000	/* [II] Mailbox 0 */
 #define  RIO_PEF_INB_MBOX1		0x00400000	/* [II] Mailbox 1 */
@@ -51,6 +52,7 @@
 #define  RIO_SWP_INFO_PORT_TOTAL_MASK	0x0000ff00	/* [I] Total number of ports */
 #define  RIO_SWP_INFO_PORT_NUM_MASK	0x000000ff	/* [I] Maintenance transaction port number */
 #define  RIO_GET_TOTAL_PORTS(x)		((x & RIO_SWP_INFO_PORT_TOTAL_MASK) >> 8)
+#define  RIO_GET_PORT_NUM(x)		(x & RIO_SWP_INFO_PORT_NUM_MASK)
 
 #define RIO_SRC_OPS_CAR		0x18	/* [I] Source Operations CAR */
 #define  RIO_SRC_OPS_READ		0x00008000	/* [I] Read op */
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

