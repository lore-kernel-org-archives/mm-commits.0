From: akpm@linux-foundation.org
Subject: + sfc-use-standard-__clearset_bit_le-functions.patch added to -mm tree
Date: Tue, 18 Sep 2012 16:21:40 -0700
Message-ID: <20120918232141.2C5441E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:34191 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab2IRXVm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Sep 2012 19:21:42 -0400
Received: by qafl39 with SMTP id l39so82476qaf.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Sep 2012 16:21:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bhutchings@solarflare.com, davem@davemloft.net, yoshikawa.takuya@oss.ntt.co.jp


The patch titled
     Subject: drivers/net/ethernet/sfc: use standard __{clear,set}_bit_le() functions
has been added to the -mm tree.  Its filename is
     sfc-use-standard-__clearset_bit_le-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2004,14 +2004,14 @@ static void efx_set_rx_mode(struct net_d
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
@@ -1086,18 +1086,6 @@ static inline struct efx_rx_buffer *efx_
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
-
 
 /**
  * EFX_MAX_FRAME_LEN - calculate maximum frame length
diff -puN drivers/net/ethernet/sfc/nic.c~sfc-use-standard-__clearset_bit_le-functions drivers/net/ethernet/sfc/nic.c
--- a/drivers/net/ethernet/sfc/nic.c~sfc-use-standard-__clearset_bit_le-functions
+++ a/drivers/net/ethernet/sfc/nic.c
@@ -472,9 +472,9 @@ void efx_nic_init_tx(struct efx_tx_queue
 
 		efx_reado(efx, &reg, FR_AA_TX_CHKSM_CFG);
 		if (tx_queue->queue & EFX_TXQ_TYPE_OFFLOAD)
-			clear_bit_le(tx_queue->queue, (void *)&reg);
+			__clear_bit_le(tx_queue->queue, &reg);
 		else
-			set_bit_le(tx_queue->queue, (void *)&reg);
+			__set_bit_le(tx_queue->queue, &reg);
 		efx_writeo(efx, &reg, FR_AA_TX_CHKSM_CFG);
 	}
 
_

Patches currently in -mm which might be from bhutchings@solarflare.com are

linux-next.patch
sfc-use-standard-__clearset_bit_le-functions.patch

