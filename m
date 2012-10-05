From: akpm@linux-foundation.org
Subject: [merged] sfc-use-standard-__clearset_bit_le-functions.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:15:15 -0700
Message-ID: <20121005201516.269155C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:47187 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757189Ab2JEUPS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:15:18 -0400
Received: by mail-ee0-f74.google.com with SMTP id b57so139516eek.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:15:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhutchings@solarflare.com, davem@davemloft.net, yoshikawa.takuya@oss.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/net/ethernet/sfc: use standard __{clear,set}_bit_le() functions
has been removed from the -mm tree.  Its filename was
     sfc-use-standard-__clearset_bit_le-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ben Hutchings <bhutchings@solarflare.com>
Subject: drivers/net/ethernet/sfc: use standard __{clear,set}_bit_le() functions

There are now standard functions for dealing with little-endian bit
arrays, so use them instead of our own implementations.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/sfc/efx.c        |    4 ++--
 drivers/net/ethernet/sfc/net_driver.h |   12 ------------
 drivers/net/ethernet/sfc/nic.c        |    4 ++--
 3 files changed, 4 insertions(+), 16 deletions(-)

diff -puN drivers/net/ethernet/sfc/efx.c~sfc-use-standard-__clearset_bit_le-functions drivers/net/ethernet/sfc/efx.c
--- a/drivers/net/ethernet/sfc/efx.c~sfc-use-standard-__clearset_bit_le-functions
+++ a/drivers/net/ethernet/sfc/efx.c
@@ -2019,14 +2019,14 @@ static void efx_set_rx_mode(struct net_d
 		netdev_for_each_mc_addr(ha, net_dev) {
 			crc = ether_crc_le(ETH_ALEN, ha->addr);
 			bit = crc & (EFX_MCAST_HASH_ENTRIES - 1);
-			set_bit_le(bit, mc_hash->byte);
+			__set_bit_le(bit, mc_hash);
 		}
 
 		/* Broadcast packets go through the multicast hash filter.
 		 * ether_crc_le() of the broadcast address is 0xbe2612ff
 		 * so we always add bit 0xff to the mask.
 		 */
-		set_bit_le(0xff, mc_hash->byte);
+		__set_bit_le(0xff, mc_hash);
 	}
 
 	if (efx->port_enabled)
diff -puN drivers/net/ethernet/sfc/net_driver.h~sfc-use-standard-__clearset_bit_le-functions drivers/net/ethernet/sfc/net_driver.h
--- a/drivers/net/ethernet/sfc/net_driver.h~sfc-use-standard-__clearset_bit_le-functions
+++ a/drivers/net/ethernet/sfc/net_driver.h
@@ -1101,18 +1101,6 @@ static inline struct efx_rx_buffer *efx_
 	return &rx_queue->buffer[index];
 }
 
-/* Set bit in a little-endian bitfield */
-static inline void set_bit_le(unsigned nr, unsigned char *addr)
-{
-	addr[nr / 8] |= (1 << (nr % 8));
-}
-
-/* Clear bit in a little-endian bitfield */
-static inline void clear_bit_le(unsigned nr, unsigned char *addr)
-{
-	addr[nr / 8] &= ~(1 << (nr % 8));
-}
