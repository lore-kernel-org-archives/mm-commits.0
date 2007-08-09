From: akpm@linux-foundation.org
Subject: + aoe-remove-unecessary-wrapper-function.patch added to -mm tree
Date: Thu, 09 Aug 2007 12:16:45 -0700
Message-ID: <200708091916.l79JGjXJ014968@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34249 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751120AbXHITQx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 15:16:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ecashin@coraid.com


The patch titled
     aoe: remove unecessary wrapper function
has been added to the -mm tree.  Its filename is
     aoe-remove-unecessary-wrapper-function.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -119,7 +119,7 @@ aoecmd_ata_rw(struct aoedev *d, struct f
 
 	/* initialize the headers & frame */
 	skb = f->skb;
-	h = aoe_hdr(skb);
+	h = (struct aoe_hdr *) skb_mac_header(skb);
 	ah = (struct aoe_atahdr *) (h+1);
 	skb_put(skb, sizeof *h + sizeof *ah);
 	memset(h, 0, skb->len);
@@ -208,7 +208,7 @@ aoecmd_cfg_pkts(ushort aoemajor, unsigne
 		skb->dev = ifp;
 		if (sl_tail == NULL)
 			sl_tail = skb;
-		h = aoe_hdr(skb);
+		h = (struct aoe_hdr *) skb_mac_header(skb);
 		memset(h, 0, sizeof *h + sizeof *ch);
 
 		memset(h->dst, 0xff, sizeof h->dst);
@@ -303,7 +303,7 @@ rexmit(struct aoedev *d, struct frame *f
 	aoechr_error(buf);
 
 	skb = f->skb;
-	h = aoe_hdr(skb);
+	h = (struct aoe_hdr *) skb_mac_header(skb);
 	ah = (struct aoe_atahdr *) (h+1);
 	f->tag = n;
 	h->tag = cpu_to_be32(n);
@@ -532,7 +532,7 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 	char ebuf[128];
 	u16 aoemajor;
 
-	hin = aoe_hdr(skb);
+	hin = (struct aoe_hdr *) skb_mac_header(skb);
 	aoemajor = be16_to_cpu(get_unaligned(&hin->major));
 	d = aoedev_by_aoeaddr(aoemajor, hin->minor);
 	if (d == NULL) {
@@ -564,7 +564,7 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 	calc_rttavg(d, tsince(f->tag));
 
 	ahin = (struct aoe_atahdr *) (hin+1);
-	hout = aoe_hdr(f->skb);
+	hout = (struct aoe_hdr *) skb_mac_header(f->skb);
 	ahout = (struct aoe_atahdr *) (hout+1);
 	buf = f->buf;
 
@@ -698,7 +698,7 @@ aoecmd_ata_id(struct aoedev *d)
 
 	/* initialize the headers & frame */
 	skb = f->skb;
-	h = aoe_hdr(skb);
+	h = (struct aoe_hdr *) skb_mac_header(skb);
 	ah = (struct aoe_atahdr *) (h+1);
 	skb_put(skb, sizeof *h + sizeof *ah);
 	memset(h, 0, skb->len);
@@ -729,7 +729,7 @@ aoecmd_cfg_rsp(struct sk_buff *skb)
 	enum { MAXFRAMES = 16 };
 	u16 n;
 
-	h = aoe_hdr(skb);
+	h = (struct aoe_hdr *) skb_mac_header(skb);
 	ch = (struct aoe_cfghdr *) (h+1);
 
 	/*
diff -puN drivers/block/aoe/aoenet.c~aoe-remove-unecessary-wrapper-function drivers/block/aoe/aoenet.c
--- a/drivers/block/aoe/aoenet.c~aoe-remove-unecessary-wrapper-function
+++ a/drivers/block/aoe/aoenet.c
@@ -123,7 +123,7 @@ aoenet_rcv(struct sk_buff *skb, struct n
 		goto exit;
 	skb_push(skb, ETH_HLEN);	/* (1) */
 
-	h = aoe_hdr(skb);
+	h = (struct aoe_hdr *) skb_mac_header(skb);
 	n = be32_to_cpu(get_unaligned(&h->tag));
 	if ((h->verfl & AOEFL_RSP) == 0 || (n & 1<<31))
 		goto exit;
_

Patches currently in -mm which might be from ecashin@coraid.com are

aoe-remove-unecessary-wrapper-function.patch
