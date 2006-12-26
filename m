From: akpm@osdl.org
Subject: - spidernet-avoid-possible-rx-chain-corruption.patch removed from -mm tree
Date: Tue, 26 Dec 2006 15:19:20 -0800
Message-ID: <200612262319.kBQNJKVK027811@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37868 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932837AbWLZXZn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Dec 2006 18:25:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linas@austin.ibm.com, arnd@arndb.de, jklewis@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Spidernet: Avoid possible RX chain corruption
has been removed from the -mm tree.  Its filename was
     spidernet-avoid-possible-rx-chain-corruption.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Spidernet: Avoid possible RX chain corruption
From: Linas Vepstas <linas@austin.ibm.com>

Delete possible source of chain corruption; the hardware already knows the
location of the tail, and writing it again is likely to mess it up.

Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
Cc: James K Lewis <jklewis@us.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/spider_net.c |    1 -
 1 files changed, 1 deletion(-)

diff -puN drivers/net/spider_net.c~spidernet-avoid-possible-rx-chain-corruption drivers/net/spider_net.c
--- a/drivers/net/spider_net.c~spidernet-avoid-possible-rx-chain-corruption
+++ a/drivers/net/spider_net.c
@@ -513,7 +513,6 @@ spider_net_alloc_rx_skbs(struct spider_n
 	/* This will allocate the rest of the rx buffers;
 	 * if not, it's business as usual later on. */
 	spider_net_refill_rx_chain(card);
-	spider_net_enable_rxchtails(card);
 	spider_net_enable_rxdmac(card);
 	return 0;
 
_

Patches currently in -mm which might be from linas@austin.ibm.com are

git-netdev-all.patch
spidernet-rework-rx-linked-list.patch

