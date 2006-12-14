From: akpm@osdl.org
Subject: - spidernet-avoid-possible-rx-chain-corruption.patch removed from -mm tree
Date: Wed, 13 Dec 2006 16:21:23 -0800
Message-ID: <200612140021.kBE0LNEF025992@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:33078 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836AbWLNAWl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 19:22:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linas@austin.ibm.com, arnd@arndb.de, jklewis@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     spidernet: avoid possible RX chain corruption
has been removed from the -mm tree.  Its filename was
     spidernet-avoid-possible-rx-chain-corruption.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: spidernet: avoid possible RX chain corruption
From: Linas Vepstas <linas@austin.ibm.com>

Delete possible source of chain corruption; the hardware already knows the
location of the tail, and writing it again is likely to mess it up.

Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
Cc: James K Lewis <jklewis@us.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/spider_net.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/net/spider_net.c~spidernet-avoid-possible-rx-chain-corruption drivers/net/spider_net.c
--- a/drivers/net/spider_net.c~spidernet-avoid-possible-rx-chain-corruption
+++ a/drivers/net/spider_net.c
@@ -1195,7 +1195,6 @@ spider_net_handle_rxram_full(struct spid
 	while (spider_net_decode_one_descr(card, 0));
 
 	spider_net_refill_rx_chain(card);
-	spider_net_enable_rxchtails(card);
 	spider_net_enable_rxdmac(card);
 	netif_rx_schedule(card->netdev);
 	spider_net_rx_irq_on(card);
_

Patches currently in -mm which might be from linas@austin.ibm.com are

origin.patch
spidernet-avoid-possible-rx-chain-corruption.patch
spidernet-rx-debugging-printout.patch
spidernet-rework-rx-linked-list.patch

