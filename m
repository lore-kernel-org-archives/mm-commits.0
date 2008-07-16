From: akpm@linux-foundation.org
Subject: - arm-ixp4xx-ethernet-napi-fix.patch removed from -mm tree
Date: Wed, 16 Jul 2008 14:35:31 -0700
Message-ID: <200807162135.m6GLZV8h014099@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43063 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757344AbYGPVh1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 17:37:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khc@pm.waw.pl, mm-commits@vger.kernel.org


The patch titled
     arm: IXP4xx Ethernet NAPI fix
has been removed from the -mm tree.  Its filename was
     arm-ixp4xx-ethernet-napi-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arm: IXP4xx Ethernet NAPI fix
From: Krzysztof Halasa <khc@pm.waw.pl>

This patch removes some weirdness from IXP4xx Ethernet driver.

The function has to return the number of received packets.  I.e., it was
not up to the NAPI specs.  Now it does what NAPI wants.  This change has
no visible effects.

Signed-off-by: Krzysztof Halasa <khc@pm.waw.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/arm/ixp4xx_eth.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/net/arm/ixp4xx_eth.c~arm-ixp4xx-ethernet-napi-fix drivers/net/arm/ixp4xx_eth.c
--- a/drivers/net/arm/ixp4xx_eth.c~arm-ixp4xx-ethernet-napi-fix
+++ a/drivers/net/arm/ixp4xx_eth.c
@@ -522,7 +522,6 @@ static int eth_poll(struct napi_struct *
 #endif
 
 		if ((n = queue_get_desc(rxq, port, 0)) < 0) {
-			received = 0; /* No packet received */
 #if DEBUG_RX
 			printk(KERN_DEBUG "%s: eth_poll netif_rx_complete\n",
 			       dev->name);
@@ -543,7 +542,7 @@ static int eth_poll(struct napi_struct *
 			printk(KERN_DEBUG "%s: eth_poll all done\n",
 			       dev->name);
 #endif
-			return 0; /* all work done */
+			return received; /* all work done */
 		}
 
 		desc = rx_desc_ptr(port, n);
_

Patches currently in -mm which might be from khc@pm.waw.pl are

arm-fix-fls-for-64-bit-arguments.patch
linux-next.patch

