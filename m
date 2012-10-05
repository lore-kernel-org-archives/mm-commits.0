From: akpm@linux-foundation.org
Subject: [merged] drivers-net-ethernet-dec-tulip-use-standard-__set_bit_le-function.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:15:19 -0700
Message-ID: <20121005201520.250DF5C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:38438 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757189Ab2JEUPW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:15:22 -0400
Received: by mail-bk0-f74.google.com with SMTP id q16so138958bkw.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:15:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yoshikawa.takuya@oss.ntt.co.jp, davem@davemloft.net, grundler@parisc-linux.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/net/ethernet/dec/tulip: Use standard __set_bit_le() function
has been removed from the -mm tree.  Its filename was
     drivers-net-ethernet-dec-tulip-use-standard-__set_bit_le-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Subject: drivers/net/ethernet/dec/tulip: Use standard __set_bit_le() function

To introduce generic set_bit_le() later, we remove our own definition
and use a proper non-atomic bitops function: __set_bit_le().

Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Acked-by: Grant Grundler <grundler@parisc-linux.org>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/dec/tulip/de2104x.c    |    7 ++-----
 drivers/net/ethernet/dec/tulip/tulip_core.c |    7 ++-----
 2 files changed, 4 insertions(+), 10 deletions(-)

diff -puN drivers/net/ethernet/dec/tulip/de2104x.c~drivers-net-ethernet-dec-tulip-use-standard-__set_bit_le-function drivers/net/ethernet/dec/tulip/de2104x.c
--- a/drivers/net/ethernet/dec/tulip/de2104x.c~drivers-net-ethernet-dec-tulip-use-standard-__set_bit_le-function
+++ a/drivers/net/ethernet/dec/tulip/de2104x.c
@@ -661,9 +661,6 @@ static netdev_tx_t de_start_xmit (struct
    new frame, not around filling de->setup_frame.  This is non-deterministic
    when re-entered but still correct. */
 
-#undef set_bit_le
-#define set_bit_le(i,p) do { ((char *)(p))[(i)/8] |= (1<<((i)%8)); } while(0)
-
 static void build_setup_frame_hash(u16 *setup_frm, struct net_device *dev)
 {
 	struct de_private *de = netdev_priv(dev);
@@ -673,12 +670,12 @@ static void build_setup_frame_hash(u16 *
 	u16 *eaddrs;
 
 	memset(hash_table, 0, sizeof(hash_table));
-	set_bit_le(255, hash_table); 			/* Broadcast entry */
+	__set_bit_le(255, hash_table);			/* Broadcast entry */
 	/* This should work on big-endian machines as well. */
 	netdev_for_each_mc_addr(ha, dev) {
 		int index = ether_crc_le(ETH_ALEN, ha->addr) & 0x1ff;
 
-		set_bit_le(index, hash_table);
+		__set_bit_le(index, hash_table);
 	}
 
 	for (i = 0; i < 32; i++) {
diff -puN drivers/net/ethernet/dec/tulip/tulip_core.c~drivers-net-ethernet-dec-tulip-use-standard-__set_bit_le-function drivers/net/ethernet/dec/tulip/tulip_core.c
--- a/drivers/net/ethernet/dec/tulip/tulip_core.c~drivers-net-ethernet-dec-tulip-use-standard-__set_bit_le-function
+++ a/drivers/net/ethernet/dec/tulip/tulip_core.c
@@ -1010,9 +1010,6 @@ static int private_ioctl (struct net_dev
    new frame, not around filling tp->setup_frame.  This is non-deterministic
    when re-entered but still correct. */
 
-#undef set_bit_le
-#define set_bit_le(i,p) do { ((char *)(p))[(i)/8] |= (1<<((i)%8)); } while(0)
