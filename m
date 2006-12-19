From: akpm@osdl.org
Subject: + fix-aoe-without-scatter-gather.patch added to -mm tree
Date: Mon, 18 Dec 2006 16:49:43 -0800
Message-ID: <200612190049.kBJ0nhgc018679@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:36684 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932565AbWLSAu1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Dec 2006 19:50:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ecashin@coraid.com, boddingt@optusnet.com.au, greg@kroah.com, stable@kernel.org


The patch titled
     fix aoe without scatter-gather [Bug 7662]
has been added to the -mm tree.  Its filename is
     fix-aoe-without-scatter-gather.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix aoe without scatter-gather [Bug 7662]
From: "Ed L. Cashin" <ecashin@coraid.com>

Fix a bug that only appears when AoE goes over a network card that does not
support scatter-gather.  The headers in the linear part of the skb appeared
to be larger than they really were, resulting in data that was offset by 24
bytes.

This patch eliminates the offset data on cards that don't support
scatter-gather or have had scatter-gather turned off.  There remains an
unrelated issue that I'll address in a separate email.

Fixes bugzilla #7662

Signed-off-by: "Ed L. Cashin" <ecashin@coraid.com>
Cc: <stable@kernel.org>
Cc: Greg KH <greg@kroah.com>
Cc: <boddingt@optusnet.com.au>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/block/aoe/aoecmd.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff -puN drivers/block/aoe/aoecmd.c~fix-aoe-without-scatter-gather drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~fix-aoe-without-scatter-gather
+++ a/drivers/block/aoe/aoecmd.c
@@ -30,8 +30,6 @@ new_skb(ulong len)
 		skb->nh.raw = skb->mac.raw = skb->data;
 		skb->protocol = __constant_htons(ETH_P_AOE);
 		skb->priority = 0;
-		skb_put(skb, len);
-		memset(skb->head, 0, len);
 		skb->next = skb->prev = NULL;
 
 		/* tell the network layer not to perform IP checksums
@@ -122,8 +120,8 @@ aoecmd_ata_rw(struct aoedev *d, struct f
 	skb = f->skb;
 	h = (struct aoe_hdr *) skb->mac.raw;
 	ah = (struct aoe_atahdr *) (h+1);
-	skb->len = sizeof *h + sizeof *ah;
-	memset(h, 0, ETH_ZLEN);
+	skb_put(skb, sizeof *h + sizeof *ah);
+	memset(h, 0, skb->len);
 	f->tag = aoehdr_atainit(d, h);
 	f->waited = 0;
 	f->buf = buf;
@@ -149,7 +147,6 @@ aoecmd_ata_rw(struct aoedev *d, struct f
 		skb->len += bcnt;
 		skb->data_len = bcnt;
 	} else {
-		skb->len = ETH_ZLEN;
 		writebit = 0;
 	}
 
@@ -206,6 +203,7 @@ aoecmd_cfg_pkts(ushort aoemajor, unsigne
 			printk(KERN_INFO "aoe: skb alloc failure\n");
 			continue;
 		}
+		skb_put(skb, sizeof *h + sizeof *ch);
 		skb->dev = ifp;
 		if (sl_tail == NULL)
 			sl_tail = skb;
@@ -243,6 +241,7 @@ freeframe(struct aoedev *d)
 			continue;
 		if (atomic_read(&skb_shinfo(f->skb)->dataref) == 1) {
 			skb_shinfo(f->skb)->nr_frags = f->skb->data_len = 0;
+			skb_trim(f->skb, 0);
 			return f;
 		}
 		n++;
@@ -698,8 +697,8 @@ aoecmd_ata_id(struct aoedev *d)
 	skb = f->skb;
 	h = (struct aoe_hdr *) skb->mac.raw;
 	ah = (struct aoe_atahdr *) (h+1);
-	skb->len = ETH_ZLEN;
-	memset(h, 0, ETH_ZLEN);
+	skb_put(skb, sizeof *h + sizeof *ah);
+	memset(h, 0, skb->len);
 	f->tag = aoehdr_atainit(d, h);
 	f->waited = 0;
 
_

Patches currently in -mm which might be from ecashin@coraid.com are

fix-aoe-without-scatter-gather.patch

