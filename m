From: akpm@osdl.org
Subject: + ehea-fixed-wrong-jumbo-frames-status-query.patch added to -mm tree
Date: Mon, 29 Jan 2007 17:10:53 -0800
Message-ID: <200701300110.l0U1ArtG005114@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36270 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630AbXA3BLD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jan 2007 20:11:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: osstklei@de.ibm.com, tklein@de.ibm.com


The patch titled
     ehea: Fixed wrong jumbo frames status query
has been added to the -mm tree.  Its filename is
     ehea-fixed-wrong-jumbo-frames-status-query.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ehea: Fixed wrong jumbo frames status query
From: Thomas Klein <osstklei@de.ibm.com>

Fix the wrong query and logging of the per interface jumbo frames
enabled/disabled status.

Signed-off-by: Thomas Klein <tklein@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/ehea/ehea.h      |    2 +-
 drivers/net/ehea/ehea_main.c |   30 +++++++++++++++++++++++-------
 2 files changed, 24 insertions(+), 8 deletions(-)

diff -puN drivers/net/ehea/ehea.h~ehea-fixed-wrong-jumbo-frames-status-query drivers/net/ehea/ehea.h
--- a/drivers/net/ehea/ehea.h~ehea-fixed-wrong-jumbo-frames-status-query
+++ a/drivers/net/ehea/ehea.h
@@ -39,7 +39,7 @@
 #include <asm/io.h>
 
 #define DRV_NAME	"ehea"
-#define DRV_VERSION	"EHEA_0044"
+#define DRV_VERSION	"EHEA_0045"
 
 #define EHEA_MSG_DEFAULT (NETIF_MSG_LINK | NETIF_MSG_TIMER \
 	| NETIF_MSG_RX_ERR | NETIF_MSG_TX_ERR)
diff -puN drivers/net/ehea/ehea_main.c~ehea-fixed-wrong-jumbo-frames-status-query drivers/net/ehea/ehea_main.c
--- a/drivers/net/ehea/ehea_main.c~ehea-fixed-wrong-jumbo-frames-status-query
+++ a/drivers/net/ehea/ehea_main.c
@@ -2316,6 +2316,7 @@ static int ehea_setup_single_port(struct
 	struct ehea_adapter *adapter = port->adapter;
 	struct hcp_ehea_port_cb4 *cb4;
 	u32 *dn_log_port_id;
+	int jumbo = 0;
 
 	sema_init(&port->port_lock, 1);
 	port->state = EHEA_PORT_DOWN;
@@ -2357,13 +2358,25 @@ static int ehea_setup_single_port(struct
 	if (!cb4) {
 		ehea_error("no mem for cb4");
 	} else {
-		cb4->jumbo_frame = 1;
-		hret = ehea_h_modify_ehea_port(adapter->handle,
-					       port->logical_port_id,
-					       H_PORT_CB4, H_PORT_CB4_JUMBO,
-					       cb4);
-		if (hret != H_SUCCESS) {
-			ehea_info("Jumbo frames not activated");
+		hret = ehea_h_query_ehea_port(adapter->handle,
+					      port->logical_port_id,
+					      H_PORT_CB4,
+					      H_PORT_CB4_JUMBO, cb4);
+
+		if (hret == H_SUCCESS) {
+			if (cb4->jumbo_frame)
+				jumbo = 1;
+			else {
+				cb4->jumbo_frame = 1;
+				hret = ehea_h_modify_ehea_port(adapter->handle,
+							       port->
+							        logical_port_id,
+							       H_PORT_CB4,
+							       H_PORT_CB4_JUMBO,
+							       cb4);
+				if (hret == H_SUCCESS)
+					jumbo = 1;
+			}
 		}
 		kfree(cb4);
 	}
@@ -2402,6 +2415,9 @@ static int ehea_setup_single_port(struct
 		goto out_free;
 	}
 
+	ehea_info("%s: Jumbo frames are %sabled", dev->name,
+		  jumbo == 1 ? "en" : "dis");
+
 	port->netdev = dev;
 	ret = 0;
 	goto out;
_

Patches currently in -mm which might be from osstklei@de.ibm.com are

ehea-fixed-wrong-jumbo-frames-status-query.patch
ehea-fixed-missing-tasklet_kill-call.patch
