From: akpm@linux-foundation.org
Subject: + ehea-fix-ipv6-support.patch added to -mm tree
Date: Thu, 20 Mar 2008 14:55:54 -0700
Message-ID: <200803202155.m2KLtsEm026011@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60274 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757440AbYCTV4G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Mar 2008 17:56:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: osstklei@de.ibm.com, davem@davemloft.net, hering2@de.ibm.com, jeff@garzik.org, raisch@de.ibm.com, stefan.roscher@de.ibm.com, themann@de.ibm.com, tklein@de.ibm.com


The patch titled
     ehea: fix IPv6 support
has been added to the -mm tree.  Its filename is
     ehea-fix-ipv6-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ehea: fix IPv6 support
From: Thomas Klein <osstklei@de.ibm.com>

Indicate that EHEA calculates IPv4 checksums only

Signed-off-by: Thomas Klein <tklein@de.ibm.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Christoph Raisch <raisch@de.ibm.com>
Cc: "Jan-Bernd Themann" <themann@de.ibm.com>
Cc: Stefan Roscher <stefan.roscher@de.ibm.com>
Cc: Hannes Hering <hering2@de.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ehea/ehea.h      |    2 +-
 drivers/net/ehea/ehea_main.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/ehea/ehea.h~ehea-fix-ipv6-support drivers/net/ehea/ehea.h
--- a/drivers/net/ehea/ehea.h~ehea-fix-ipv6-support
+++ a/drivers/net/ehea/ehea.h
@@ -40,7 +40,7 @@
 #include <asm/io.h>
 
 #define DRV_NAME	"ehea"
-#define DRV_VERSION	"EHEA_0087"
+#define DRV_VERSION	"EHEA_0089"
 
 /* eHEA capability flags */
 #define DLPAR_PORT_ADD_REM 1
diff -puN drivers/net/ehea/ehea_main.c~ehea-fix-ipv6-support drivers/net/ehea/ehea_main.c
--- a/drivers/net/ehea/ehea_main.c~ehea-fix-ipv6-support
+++ a/drivers/net/ehea/ehea_main.c
@@ -3110,7 +3110,7 @@ struct ehea_port *ehea_setup_single_port
 	dev->vlan_rx_add_vid = ehea_vlan_rx_add_vid;
 	dev->vlan_rx_kill_vid = ehea_vlan_rx_kill_vid;
 	dev->features = NETIF_F_SG | NETIF_F_FRAGLIST | NETIF_F_TSO
-		      | NETIF_F_HIGHDMA | NETIF_F_HW_CSUM | NETIF_F_HW_VLAN_TX
+		      | NETIF_F_HIGHDMA | NETIF_F_IP_CSUM | NETIF_F_HW_VLAN_TX
 		      | NETIF_F_HW_VLAN_RX | NETIF_F_HW_VLAN_FILTER
 		      | NETIF_F_LLTX;
 	dev->tx_timeout = &ehea_tx_watchdog;
_

Patches currently in -mm which might be from osstklei@de.ibm.com are

ehea-fix-ipv6-support.patch

