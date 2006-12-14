From: akpm@osdl.org
Subject: + spidernet-avoid-possible-rx-chain-corruption.patch added to -mm tree
Date: Wed, 13 Dec 2006 16:26:20 -0800
Message-ID: <200612140026.kBE0QKiR026159@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:34122 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888AbWLNAmQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 19:42:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linas@austin.ibm.com, arnd@arndb.de, jklewis@us.ibm.com


The patch titled
     Spidernet: Avoid possible RX chain corruption
has been added to the -mm tree.  Its filename is
     spidernet-avoid-possible-rx-chain-corruption.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
spidernet-dma-coalescing.patch
spidernet-add-net_ratelimit-to-suppress-long-output.patch
spidernet-remove-rxramfull-tasklet.patch
spidernet-cleanup-un-needed-api.patch
spidernet-rx-skb-mem-leak.patch
spidernet-another-skb-mem-leak.patch
spidernet-cleanup-return-codes.patch
spidernet-rx-refill.patch
spidernet-remove-unused-variable.patch
spidernet-rx-chain-tail.patch
spidernet-memory-barrier.patch
spidernet-avoid-possible-rx-chain-corruption.patch
spidernet-rx-debugging-printout.patch
spidernet-rework-rx-linked-list.patch

