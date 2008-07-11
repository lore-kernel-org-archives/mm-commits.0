From: akpm@linux-foundation.org
Subject: + arm-ixp4xx-ethernet-napi-fix.patch added to -mm tree
Date: Fri, 11 Jul 2008 11:38:12 -0700
Message-ID: <200807111843.m6BIhrL9030827@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35049 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756716AbYGKSoG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 14:44:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khc@pm.waw.pl


The patch titled
     arm: IXP4xx Ethernet NAPI fix
has been added to the -mm tree.  Its filename is
     arm-ixp4xx-ethernet-napi-fix.patch

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
Subject: arm: IXP4xx Ethernet NAPI fix
From: Krzysztof Halasa <khc@pm.waw.pl>

This patch removes some weirdness from IXP4xx Ethernet driver.

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

linux-next.patch
arm-ixp4xx-ethernet-napi-fix.patch

