From: akpm@linux-foundation.org
Subject: + drivers-net-ethernet-dec-tulip-use-standard-__set_bit_le-function.patch added to -mm tree
Date: Tue, 18 Sep 2012 16:21:43 -0700
Message-ID: <20120918232144.13E801E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:46494 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab2IRXVp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Sep 2012 19:21:45 -0400
Received: by yhl10 with SMTP id 10so62366yhl.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Sep 2012 16:21:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yoshikawa.takuya@oss.ntt.co.jp, davem@davemloft.net, grundler@parisc-linux.org


The patch titled
     Subject: drivers/net/ethernet/dec/tulip: Use standard __set_bit_le() function
has been added to the -mm tree.  Its filename is
     drivers-net-ethernet-dec-tulip-use-standard-__set_bit_le-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
-
 static void build_setup_frame_hash(u16 *setup_frm, struct net_device *dev)
 {
 	struct tulip_private *tp = netdev_priv(dev);
@@ -1022,12 +1019,12 @@ static void build_setup_frame_hash(u16 *
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
 		*setup_frm++ = hash_table[i];
_

Patches currently in -mm which might be from yoshikawa.takuya@oss.ntt.co.jp are

linux-next.patch
sfc-use-standard-__clearset_bit_le-functions.patch
drivers-net-ethernet-dec-tulip-use-standard-__set_bit_le-function.patch
bitops-introduce-generic-clearset_bit_le.patch
powerpc-bitops-introduce-clearset_bit_le.patch
kvm-replace-test_and_set_bit_le-in-mark_page_dirty_in_slot-with-set_bit_le.patch

