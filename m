From: akpm@linux-foundation.org
Subject: - aoe-remove-unecessary-wrapper-function.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:55:48 -0700
Message-ID: <200710180655.l9I6tm97030645@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60239 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762828AbXJRHPm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:15:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, mm-commits@vger.kernel.org


The patch titled
     aoe: remove unecessary wrapper function
has been removed from the -mm tree.  Its filename was
     aoe-remove-unecessary-wrapper-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: aoe: remove unecessary wrapper function
From: "Ed L. Cashin" <ecashin@coraid.com>

We can just use skb_mac_header now, and we don't need a wrapper function to
perform the cast.  Instead of requiring the reader to check aoe.h to look
up what an aoe_hdr function does, I'd rather do without it.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoe.h    |    9 ---------
 drivers/block/aoe/aoecmd.c |   14 +++++++-------
 drivers/block/aoe/aoenet.c |    2 +-
 3 files changed, 8 insertions(+), 17 deletions(-)

diff -puN drivers/block/aoe/aoe.h~aoe-remove-unecessary-wrapper-function drivers/block/aoe/aoe.h
--- a/drivers/block/aoe/aoe.h~aoe-remove-unecessary-wrapper-function
+++ a/drivers/block/aoe/aoe.h
@@ -48,15 +48,6 @@ struct aoe_hdr {
 	__be32 tag;
 };
 
-#ifdef __KERNEL__
-#include <linux/skbuff.h>
-
-static inline struct aoe_hdr *aoe_hdr(const struct sk_buff *skb)
-{
-	return (struct aoe_hdr *)skb_mac_header(skb);
-}
-#endif
-
 struct aoe_atahdr {
 	unsigned char aflags;
 	unsigned char errfeat;
diff -puN drivers/block/aoe/aoecmd.c~aoe-remove-unecessary-wrapper-function drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~aoe-remove-unecessary-wrapper-function
+++ a/drivers/block/aoe/aoecmd.c
@@ -120,7 +120,7 @@ aoecmd_ata_rw(struct aoedev *d, struct f
 
 	/* initialize the headers & frame */
 	skb = f->skb;
-	h = aoe_hdr(skb);
+	h = (struct aoe_hdr *) skb_mac_header(skb);
 	ah = (struct aoe_atahdr *) (h+1);
 	skb_put(skb, sizeof *h + sizeof *ah);
 	memset(h, 0, skb->len);
@@ -209,7 +209,7 @@ aoecmd_cfg_pkts(ushort aoemajor, unsigne
 		skb->dev = ifp;
 		if (sl_tail == NULL)
 			sl_tail = skb;
-		h = aoe_hdr(skb);
+		h = (struct aoe_hdr *) skb_mac_header(skb);
 		memset(h, 0, sizeof *h + sizeof *ch);
 
 		memset(h->dst, 0xff, sizeof h->dst);
@@ -304,7 +304,7 @@ rexmit(struct aoedev *d, struct frame *f
 	aoechr_error(buf);
 
 	skb = f->skb;
-	h = aoe_hdr(skb);
+	h = (struct aoe_hdr *) skb_mac_header(skb);
 	ah = (struct aoe_atahdr *) (h+1);
 	f->tag = n;
 	h->tag = cpu_to_be32(n);
@@ -533,7 +533,7 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 	char ebuf[128];
 	u16 aoemajor;
 
-	hin = aoe_hdr(skb);
+	hin = (struct aoe_hdr *) skb_mac_header(skb);
 	aoemajor = be16_to_cpu(get_unaligned(&hin->major));
 	d = aoedev_by_aoeaddr(aoemajor, hin->minor);
 	if (d == NULL) {
@@ -565,7 +565,7 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 	calc_rttavg(d, tsince(f->tag));
 
 	ahin = (struct aoe_atahdr *) (hin+1);
-	hout = aoe_hdr(f->skb);
+	hout = (struct aoe_hdr *) skb_mac_header(f->skb);
 	ahout = (struct aoe_atahdr *) (hout+1);
 	buf = f->buf;
 
@@ -699,7 +699,7 @@ aoecmd_ata_id(struct aoedev *d)
 
 	/* initialize the headers & frame */
 	skb = f->skb;
-	h = aoe_hdr(skb);
+	h = (struct aoe_hdr *) skb_mac_header(skb);
 	ah = (struct aoe_atahdr *) (h+1);
 	skb_put(skb, sizeof *h + sizeof *ah);
 	memset(h, 0, skb->len);
@@ -730,7 +730,7 @@ aoecmd_cfg_rsp(struct sk_buff *skb)
 	enum { MAXFRAMES = 16 };
 	u16 n;
 
-	h = aoe_hdr(skb);
+	h = (struct aoe_hdr *) skb_mac_header(skb);
 	ch = (struct aoe_cfghdr *) (h+1);
 
 	/*
diff -puN drivers/block/aoe/aoenet.c~aoe-remove-unecessary-wrapper-function drivers/block/aoe/aoenet.c
--- a/drivers/block/aoe/aoenet.c~aoe-remove-unecessary-wrapper-function
+++ a/drivers/block/aoe/aoenet.c
@@ -127,7 +127,7 @@ aoenet_rcv(struct sk_buff *skb, struct n
 		goto exit;
 	skb_push(skb, ETH_HLEN);	/* (1) */
 
-	h = aoe_hdr(skb);
+	h = (struct aoe_hdr *) skb_mac_header(skb);
 	n = be32_to_cpu(get_unaligned(&h->tag));
 	if ((h->verfl & AOEFL_RSP) == 0 || (n & 1<<31))
 		goto exit;
_

Patches currently in -mm which might be from ecashin@coraid.com are

origin.patch
