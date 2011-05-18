From: akpm@linux-foundation.org
Subject: [merged] rapidio-fix-default-routing-initialization.patch removed from -mm tree
Date: Wed, 18 May 2011 11:27:37 -0700
Message-ID: <201105181827.p4IIR5Rj015162@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48764 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933405Ab1ERS1q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 May 2011 14:27:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, galak@kernel.crashing.org, leoli@freescale.com, mporter@kernel.crashing.org, stable@kernel.org, thomas.moll@sysgo.com, mm-commits@vger.kernel.org


The patch titled
     rapidio: fix default routing initialization
has been removed from the -mm tree.  Its filename was
     rapidio-fix-default-routing-initialization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rapidio: fix default routing initialization
From: Alexandre Bounine <alexandre.bounine@idt.com>

Fix switch initialization to ensure that all switches have default routing
disabled.  This guarantees that no unexpected RapidIO packets arrive to
the default port set by reset and there is no default routing destination
until it is properly configured by software.

This update also unifies handling of unmapped destinations by tsi57x, IDT
Gen1 and IDT Gen2 switches.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Thomas Moll <thomas.moll@sysgo.com>
Cc: <stable@kernel.org>		[2.6.37+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/switches/idt_gen2.c |    9 +++++++++
 drivers/rapidio/switches/idtcps.c   |    6 ++++++
 drivers/rapidio/switches/tsi57x.c   |    6 ++++++
 3 files changed, 21 insertions(+)

diff -puN drivers/rapidio/switches/idt_gen2.c~rapidio-fix-default-routing-initialization drivers/rapidio/switches/idt_gen2.c
--- a/drivers/rapidio/switches/idt_gen2.c~rapidio-fix-default-routing-initialization
+++ a/drivers/rapidio/switches/idt_gen2.c
@@ -95,6 +95,9 @@ idtg2_route_add_entry(struct rio_mport *
 	else
 		table++;
 
+	if (route_port == RIO_INVALID_ROUTE)
+		route_port = IDT_DEFAULT_ROUTE;
+
 	rio_mport_write_config_32(mport, destid, hopcount,
 				  LOCAL_RTE_CONF_DESTID_SEL, table);
 
@@ -411,6 +414,12 @@ static int idtg2_switch_init(struct rio_
 	rdev->rswitch->em_handle = idtg2_em_handler;
 	rdev->rswitch->sw_sysfs = idtg2_sysfs;
 
+	if (do_enum) {
+		/* Ensure that default routing is disabled on startup */
+		rio_write_config_32(rdev,
+				    RIO_STD_RTE_DEFAULT_PORT, IDT_NO_ROUTE);
+	}
+
 	return 0;
 }
 
diff -puN drivers/rapidio/switches/idtcps.c~rapidio-fix-default-routing-initialization drivers/rapidio/switches/idtcps.c
--- a/drivers/rapidio/switches/idtcps.c~rapidio-fix-default-routing-initialization
+++ a/drivers/rapidio/switches/idtcps.c
@@ -26,6 +26,9 @@ idtcps_route_add_entry(struct rio_mport 
 {
 	u32 result;
 
+	if (route_port == RIO_INVALID_ROUTE)
+		route_port = CPS_DEFAULT_ROUTE;
+
 	if (table == RIO_GLOBAL_TABLE) {
 		rio_mport_write_config_32(mport, destid, hopcount,
 				RIO_STD_RTE_CONF_DESTID_SEL_CSR, route_destid);
@@ -130,6 +133,9 @@ static int idtcps_switch_init(struct rio
 		/* set TVAL = ~50us */
 		rio_write_config_32(rdev,
 			rdev->phys_efptr + RIO_PORT_LINKTO_CTL_CSR, 0x8e << 8);
+		/* Ensure that default routing is disabled on startup */
+		rio_write_config_32(rdev,
+				    RIO_STD_RTE_DEFAULT_PORT, CPS_NO_ROUTE);
 	}
 
 	return 0;
diff -puN drivers/rapidio/switches/tsi57x.c~rapidio-fix-default-routing-initialization drivers/rapidio/switches/tsi57x.c
--- a/drivers/rapidio/switches/tsi57x.c~rapidio-fix-default-routing-initialization
+++ a/drivers/rapidio/switches/tsi57x.c
@@ -303,6 +303,12 @@ static int tsi57x_switch_init(struct rio
 	rdev->rswitch->em_init = tsi57x_em_init;
 	rdev->rswitch->em_handle = tsi57x_em_handler;
 
+	if (do_enum) {
+		/* Ensure that default routing is disabled on startup */
+		rio_write_config_32(rdev, RIO_STD_RTE_DEFAULT_PORT,
+				    RIO_INVALID_ROUTE);
+	}
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

origin.patch

