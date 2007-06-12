From: akpm@linux-foundation.org
Subject: - ehea-fixed-possible-kernel-panic-on-vlan-packet-recv.patch removed from -mm tree
Date: Tue, 12 Jun 2007 11:58:13 -0700
Message-ID: <200706121858.l5CIwDjW018529@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60793 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751229AbXFLTJU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 15:09:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: osstklei@de.ibm.com, meder@de.ibm.com, ossrosch@linux.vnet.ibm.com, raisch@de.ibm.com, themann@de.ibm.com, tklein@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ehea: fix possible kernel panic on VLAN packet recv
has been removed from the -mm tree.  Its filename was
     ehea-fixed-possible-kernel-panic-on-vlan-packet-recv.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ehea: fix possible kernel panic on VLAN packet recv
From: Thomas Klein <osstklei@de.ibm.com>

Fix a possible kernel panic due to not checking the vlan group when
processing received VLAN packets and a malfunction in VLAN/hypervisor
registration.

Signed-off-by: Thomas Klein <tklein@de.ibm.com>
Cc: Christoph Raisch <raisch@de.ibm.com>
Cc: "Jan-Bernd Themann" <themann@de.ibm.com>
Cc: Marcus Eder <meder@de.ibm.com>
Cc: Stefan Roscher <ossrosch@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ehea/ehea.h      |    2 +-
 drivers/net/ehea/ehea_main.c |   12 +++++-------
 2 files changed, 6 insertions(+), 8 deletions(-)

diff -puN drivers/net/ehea/ehea.h~ehea-fixed-possible-kernel-panic-on-vlan-packet-recv drivers/net/ehea/ehea.h
--- a/drivers/net/ehea/ehea.h~ehea-fixed-possible-kernel-panic-on-vlan-packet-recv
+++ a/drivers/net/ehea/ehea.h
@@ -39,7 +39,7 @@
 #include <asm/io.h>
 
 #define DRV_NAME	"ehea"
-#define DRV_VERSION	"EHEA_0061"
+#define DRV_VERSION	"EHEA_0064"
 
 #define EHEA_MSG_DEFAULT (NETIF_MSG_LINK | NETIF_MSG_TIMER \
 	| NETIF_MSG_RX_ERR | NETIF_MSG_TX_ERR)
diff -puN drivers/net/ehea/ehea_main.c~ehea-fixed-possible-kernel-panic-on-vlan-packet-recv drivers/net/ehea/ehea_main.c
--- a/drivers/net/ehea/ehea_main.c~ehea-fixed-possible-kernel-panic-on-vlan-packet-recv
+++ a/drivers/net/ehea/ehea_main.c
@@ -451,7 +451,8 @@ static struct ehea_cqe *ehea_proc_rwqes(
 				processed_rq3++;
 			}
 
-			if (cqe->status & EHEA_CQE_VLAN_TAG_XTRACT)
+			if ((cqe->status & EHEA_CQE_VLAN_TAG_XTRACT)
+			    && port->vgrp)
 				vlan_hwaccel_receive_skb(skb, port->vgrp,
 							 cqe->vlan_tag);
 			else
@@ -1910,10 +1911,7 @@ static void ehea_vlan_rx_register(struct
 		goto out;
 	}
 
-	if (grp)
-		memset(cb1->vlan_filter, 0, sizeof(cb1->vlan_filter));
-	else
-		memset(cb1->vlan_filter, 0xFF, sizeof(cb1->vlan_filter));
+	memset(cb1->vlan_filter, 0, sizeof(cb1->vlan_filter));
 
 	hret = ehea_h_modify_ehea_port(adapter->handle, port->logical_port_id,
 				       H_PORT_CB1, H_PORT_CB1_ALL, cb1);
@@ -1947,7 +1945,7 @@ static void ehea_vlan_rx_add_vid(struct 
 	}
 
 	index = (vid / 64);
-	cb1->vlan_filter[index] |= ((u64)(1 << (vid & 0x3F)));
+	cb1->vlan_filter[index] |= ((u64)(0x8000000000000000 >> (vid & 0x3F)));
 
 	hret = ehea_h_modify_ehea_port(adapter->handle, port->logical_port_id,
 				       H_PORT_CB1, H_PORT_CB1_ALL, cb1);
@@ -1982,7 +1980,7 @@ static void ehea_vlan_rx_kill_vid(struct
 	}
 
 	index = (vid / 64);
-	cb1->vlan_filter[index] &= ~((u64)(1 << (vid & 0x3F)));
+	cb1->vlan_filter[index] &= ~((u64)(0x8000000000000000 >> (vid & 0x3F)));
 
 	hret = ehea_h_modify_ehea_port(adapter->handle, port->logical_port_id,
 				       H_PORT_CB1, H_PORT_CB1_ALL, cb1);
_

Patches currently in -mm which might be from osstklei@de.ibm.com are

git-netdev-all.patch
