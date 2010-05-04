From: akpm@linux-foundation.org
Subject: + rapidio-add-switch-domain-routines.patch added to -mm tree
Date: Tue, 04 May 2010 16:25:18 -0700
Message-ID: <201005042325.o44NPIVh025155@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34889 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751110Ab0EDXbG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 May 2010 19:31:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexandre.bounine@idt.com, galak@kernel.crashing.org, leoli@freescale.com, mporter@kernel.crashing.org, thomas.moll@sysgo.com


The patch titled
     rapidio: add switch domain routines
has been added to the -mm tree.  Its filename is
     rapidio-add-switch-domain-routines.patch

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
Subject: rapidio: add switch domain routines
From: Alexandre Bounine <alexandre.bounine@idt.com>

Add switch specific domain routines required for 16-bit routing support in
switches with hierarchical implementation of routing tables.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Thomas Moll <thomas.moll@sysgo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/switches/idtcps.c |   33 ++++++++++++++++++++
 drivers/rapidio/switches/tsi500.c |    2 +
 drivers/rapidio/switches/tsi568.c |    2 +
 drivers/rapidio/switches/tsi57x.c |   45 ++++++++++++++++++++++++++++
 include/linux/rio.h               |    4 ++
 5 files changed, 86 insertions(+)

diff -puN drivers/rapidio/switches/idtcps.c~rapidio-add-switch-domain-routines drivers/rapidio/switches/idtcps.c
--- a/drivers/rapidio/switches/idtcps.c~rapidio-add-switch-domain-routines
+++ a/drivers/rapidio/switches/idtcps.c
@@ -17,6 +17,8 @@
 
 #define CPS_NO_ROUTE 0xdf
 
+#define IDTCPS_RIO_DOMAIN 0xf20020
+
 static int
 idtcps_route_add_entry(struct rio_mport *mport, u16 destid, u8 hopcount,
 		       u16 table, u16 route_destid, u8 route_port)
@@ -82,12 +84,43 @@ idtcps_route_clr_table(struct rio_mport 
 	return 0;
 }
 
+static int
+idtcps_set_domain(struct rio_mport *mport, u16 destid, u8 hopcount,
+		       u8 sw_domain)
+{
+	/*
+	 * Switch domain configuration operates only at global level
+	 */
+	rio_mport_write_config_32(mport, destid, hopcount,
+				  IDTCPS_RIO_DOMAIN, (u32)sw_domain);
+	return 0;
+}
+
+static int
+idtcps_get_domain(struct rio_mport *mport, u16 destid, u8 hopcount,
+		       u8 *sw_domain)
+{
+	u32 regval;
+
+	/*
+	 * Switch domain configuration operates only at global level
+	 */
+	rio_mport_read_config_32(mport, destid, hopcount,
+				IDTCPS_RIO_DOMAIN, &regval);
+
+	*sw_domain = (u8)(regval & 0xff);
+
+	return 0;
+}
+
 static int idtcps_switch_init(struct rio_dev *rdev, int do_enum)
 {
 	pr_debug("RIO: %s for %s\n", __func__, rio_name(rdev));
 	rdev->rswitch->add_entry = idtcps_route_add_entry;
 	rdev->rswitch->get_entry = idtcps_route_get_entry;
 	rdev->rswitch->clr_table = idtcps_route_clr_table;
+	rdev->rswitch->set_domain = idtcps_set_domain;
+	rdev->rswitch->get_domain = idtcps_get_domain;
 	rdev->rswitch->em_init = NULL;
 	rdev->rswitch->em_handle = NULL;
 
diff -puN drivers/rapidio/switches/tsi500.c~rapidio-add-switch-domain-routines drivers/rapidio/switches/tsi500.c
--- a/drivers/rapidio/switches/tsi500.c~rapidio-add-switch-domain-routines
+++ a/drivers/rapidio/switches/tsi500.c
@@ -67,6 +67,8 @@ static int tsi500_switch_init(struct rio
 	rdev->rswitch->add_entry = tsi500_route_add_entry;
 	rdev->rswitch->get_entry = tsi500_route_get_entry;
 	rdev->rswitch->clr_table = NULL;
+	rdev->rswitch->set_domain = NULL;
+	rdev->rswitch->get_domain = NULL;
 	rdev->rswitch->em_init = NULL;
 	rdev->rswitch->em_handle = NULL;
 
diff -puN drivers/rapidio/switches/tsi568.c~rapidio-add-switch-domain-routines drivers/rapidio/switches/tsi568.c
--- a/drivers/rapidio/switches/tsi568.c~rapidio-add-switch-domain-routines
+++ a/drivers/rapidio/switches/tsi568.c
@@ -135,6 +135,8 @@ static int tsi568_switch_init(struct rio
 	rdev->rswitch->add_entry = tsi568_route_add_entry;
 	rdev->rswitch->get_entry = tsi568_route_get_entry;
 	rdev->rswitch->clr_table = tsi568_route_clr_table;
+	rdev->rswitch->set_domain = NULL;
+	rdev->rswitch->get_domain = NULL;
 	rdev->rswitch->em_init = tsi568_em_init;
 	rdev->rswitch->em_handle = NULL;
 
diff -puN drivers/rapidio/switches/tsi57x.c~rapidio-add-switch-domain-routines drivers/rapidio/switches/tsi57x.c
--- a/drivers/rapidio/switches/tsi57x.c~rapidio-add-switch-domain-routines
+++ a/drivers/rapidio/switches/tsi57x.c
@@ -30,13 +30,17 @@
 #define SPP_ROUTE_CFG_PORT(n)	(0x11074 + 0x100*n)
 
 #define TSI578_SP_MODE(n)	(0x11004 + n*0x100)
+#define TSI578_SP_MODE_GLBL	0x10004
 #define  TSI578_SP_MODE_PW_DIS	0x08000000
+#define  TSI578_SP_MODE_LUT_512	0x01000000
 
 #define TSI578_SP_CTL_INDEP(n)	(0x13004 + n*0x100)
 #define TSI578_SP_LUT_PEINF(n)	(0x13010 + n*0x100)
 #define TSI578_SP_CS_TX(n)	(0x13014 + n*0x100)
 #define TSI578_SP_INT_STATUS(n) (0x13018 + n*0x100)
 
+#define TSI578_GLBL_ROUTE_BASE	0x10078
+
 static int
 tsi57x_route_add_entry(struct rio_mport *mport, u16 destid, u8 hopcount,
 		       u16 table, u16 route_destid, u8 route_port)
@@ -113,6 +117,45 @@ tsi57x_route_clr_table(struct rio_mport 
 }
 
 static int
+tsi57x_set_domain(struct rio_mport *mport, u16 destid, u8 hopcount,
+		       u8 sw_domain)
+{
+	u32 regval;
+
+	/*
+	 * Switch domain configuration operates only at global level
+	 */
+
+	/* Turn off flat (LUT_512) mode */
+	rio_mport_read_config_32(mport, destid, hopcount,
+				 TSI578_SP_MODE_GLBL, &regval);
+	rio_mport_write_config_32(mport, destid, hopcount, TSI578_SP_MODE_GLBL,
+				  regval & ~TSI578_SP_MODE_LUT_512);
+	/* Set switch domain base */
+	rio_mport_write_config_32(mport, destid, hopcount,
+				  TSI578_GLBL_ROUTE_BASE,
+				  (u32)(sw_domain << 24));
+	return 0;
+}
+
+static int
+tsi57x_get_domain(struct rio_mport *mport, u16 destid, u8 hopcount,
+		       u8 *sw_domain)
+{
+	u32 regval;
+
+	/*
+	 * Switch domain configuration operates only at global level
+	 */
+	rio_mport_read_config_32(mport, destid, hopcount,
+				TSI578_GLBL_ROUTE_BASE, &regval);
+
+	*sw_domain = (u8)(regval >> 24);
+
+	return 0;
+}
+
+static int
 tsi57x_em_init(struct rio_dev *rdev)
 {
 	struct rio_mport *mport = rdev->net->hport;
@@ -258,6 +301,8 @@ static int tsi57x_switch_init(struct rio
 	rdev->rswitch->add_entry = tsi57x_route_add_entry;
 	rdev->rswitch->get_entry = tsi57x_route_get_entry;
 	rdev->rswitch->clr_table = tsi57x_route_clr_table;
+	rdev->rswitch->set_domain = tsi57x_set_domain;
+	rdev->rswitch->get_domain = tsi57x_get_domain;
 	rdev->rswitch->em_init = tsi57x_em_init;
 	rdev->rswitch->em_handle = tsi57x_em_handler;
 
diff -puN include/linux/rio.h~rapidio-add-switch-domain-routines include/linux/rio.h
--- a/include/linux/rio.h~rapidio-add-switch-domain-routines
+++ a/include/linux/rio.h
@@ -238,6 +238,10 @@ struct rio_switch {
 			  u16 table, u16 route_destid, u8 * route_port);
 	int (*clr_table) (struct rio_mport *mport, u16 destid, u8 hopcount,
 			  u16 table);
+	int (*set_domain) (struct rio_mport *mport, u16 destid, u8 hopcount,
+			   u8 sw_domain);
+	int (*get_domain) (struct rio_mport *mport, u16 destid, u8 hopcount,
+			   u8 *sw_domain);
 	int (*em_init) (struct rio_dev *dev);
 	int (*em_handle) (struct rio_dev *dev, u8 swport);
 };
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

rapidio-add-idt-cps-tsi-switches.patch
rapidio-add-switch-locking-during-discovery.patch
rapidio-add-port-write-handling-for-em.patch
rapidio-powerpc-85xx-add-port-write-message-handler-for-srio-port.patch
rapidio-powerpc-85xx-add-mchk-handler-for-srio-port.patch
rapidio-fix-typos-and-minor-edits.patch
rapidio-add-debug-configuration-option.patch
rapidio-modify-initialization-of-switch-operations.patch
rapidio-add-switch-domain-routines.patch
rapidio-use-default-route-value-for-cps-switches.patch

