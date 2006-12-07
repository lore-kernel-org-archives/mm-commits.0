From: akpm@osdl.org
Subject: + spidernet-memory-barrier.patch added to -mm tree
Date: Wed, 06 Dec 2006 21:37:02 -0800
Message-ID: <200612070537.kB75b2TB031695@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51072 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031113AbWLGFpZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 00:45:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linas@austin.ibm.com, arnd@arndb.de, jklewis@us.ibm.com


The patch titled
     spidernet: memory barrier
has been added to the -mm tree.  Its filename is
     spidernet-memory-barrier.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spidernet: memory barrier
From: Linas Vepstas <linas@austin.ibm.com>

Add memory barrier to make sure that the rest of the RX descriptor state is
flushed to memory before we tell the hardware that its ready to go.

Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
Cc: James K Lewis <jklewis@us.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/spider_net.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/net/spider_net.c~spidernet-memory-barrier drivers/net/spider_net.c
--- a/drivers/net/spider_net.c~spidernet-memory-barrier
+++ a/drivers/net/spider_net.c
@@ -389,6 +389,7 @@ spider_net_prepare_rx_descr(struct spide
 		card->spider_stats.rx_iommu_map_error++;
 		descr->dmac_cmd_status = SPIDER_NET_DESCR_NOT_IN_USE;
 	} else {
+		wmb();
 		descr->dmac_cmd_status = SPIDER_NET_DESCR_CARDOWNED |
 					 SPIDER_NET_DMAC_NOINTR_COMPLETE;
 	}
_

Patches currently in -mm which might be from linas@austin.ibm.com are

origin.patch
hvcs-char-driver-janitoring-move-block-of-code.patch
spidernet-dma-coalescing.patch
spidernet-add-net_ratelimit-to-suppress-long-output.patch
spidernet-rx-locking.patch
spidernet-refactor-rx-refill.patch
spidernet-rx-skb-mem-leak.patch
spidernet-another-skb-mem-leak.patch
spidernet-cleanup-return-codes.patch
spidernet-rx-refill.patch
spidernet-merge-error-branches.patch
spidernet-remove-unused-variable.patch
spidernet-rx-chain-tail.patch
spidernet-turn-rx-irq-back-on.patch
spidernet-memory-barrier.patch
spidernet-avoid-possible-rx-chain-corruption.patch
spidernet-rx-debugging-printout.patch
spidernet-rework-rx-linked-list.patch

