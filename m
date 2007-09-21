From: akpm@linux-foundation.org
Subject: + make-mv643xx_ethc-build-again.patch added to -mm tree
Date: Thu, 20 Sep 2007 23:53:39 -0700
Message-ID: <200709210653.l8L6rdl8023397@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43303 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750748AbXIUGxm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 02:53:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jfannin@gmail.com, davem@davemloft.net


The patch titled
     git-net: make mv643xx_eth.c build again
has been added to the -mm tree.  Its filename is
     make-mv643xx_ethc-build-again.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-net: make mv643xx_eth.c build again
From: jfannin@gmail.com (Joseph Fannin)

The changeset to "Make NAPI polling independent of struct net_device
objects" forgot to change a function prototype in mv643xx_eth.c, and also
introduced a typo that caused the driver not to build.

Signed-off-by: Joseph Fannin <jfannin@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/mv643xx_eth.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/mv643xx_eth.c~make-mv643xx_ethc-build-again drivers/net/mv643xx_eth.c
--- a/drivers/net/mv643xx_eth.c~make-mv643xx_ethc-build-again
+++ a/drivers/net/mv643xx_eth.c
@@ -65,7 +65,7 @@ static int mv643xx_eth_stop(struct net_d
 static int mv643xx_eth_change_mtu(struct net_device *, int);
 static void eth_port_init_mac_tables(unsigned int eth_port_num);
 #ifdef MV643XX_NAPI
-static int mv643xx_poll(struct net_device *dev, int budget);
+static int mv643xx_poll(struct napi_struct *napi, int budget);
 #endif
 static int ethernet_phy_get(unsigned int eth_port_num);
 static void ethernet_phy_set(unsigned int eth_port_num, int phy_addr);
@@ -561,7 +561,7 @@ static irqreturn_t mv643xx_eth_int_handl
 		/* wait for previous write to complete */
 		mv_read(MV643XX_ETH_INTERRUPT_MASK_REG(port_num));
 
-		netif_rx_schedule(dev, &bp->napi);
+		netif_rx_schedule(dev, &mp->napi);
 	}
 #else
 	if (eth_int_cause & ETH_INT_CAUSE_RX)
_

Patches currently in -mm which might be from jfannin@gmail.com are

make-mv643xx_ethc-build-again.patch
