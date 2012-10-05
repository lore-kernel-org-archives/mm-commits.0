From: akpm@linux-foundation.org
Subject: [merged] aoe-for-performance-support-larger-packet-payloads.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:21:01 -0700
Message-ID: <20121005202101.BCCCA1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:50064 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab2JEUVC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:21:02 -0400
Received: by mail-gg0-f202.google.com with SMTP id i4so236089ggm.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:21:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, jesse@nicira.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aoe: for performance support larger packet payloads
has been removed from the -mm tree.  Its filename was
     aoe-for-performance-support-larger-packet-payloads.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: for performance support larger packet payloads

tAdd adds the ability to work with large packets composed of a number of
segments, using the scatter gather feature of the block layer (biovecs)
and the network layer (skb frag array).  The motivation is the performance
gained by using a packet data payload greater than a page size and by
using the network card's scatter gather feature.

Users of the out-of-tree aoe driver already had these changes, but since
early 2011, they have complained of increased memory utilization and
higher CPU utilization during heavy writes.[1] The commit below appears
related, as it disables scatter gather on non-IP protocols inside the
harmonize_features function, even when the NIC supports sg.

  commit f01a5236bd4b140198fbcc550f085e8361fd73fa
  Author: Jesse Gross <jesse@nicira.com>
  Date:   Sun Jan 9 06:23:31 2011 +0000

      net offloading: Generalize netif_get_vlan_features().

With that regression in place, transmits always linearize sg AoE packets,
but in-kernel users did not have this patch.  Before 2.6.38, though, these
changes were working to allow sg to increase performance.

1. http://www.spinics.net/lists/linux-mm/msg15184.html

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoe.h    |    2 
 drivers/block/aoe/aoeblk.c |    3 
 drivers/block/aoe/aoecmd.c |  138 ++++++++++++++++++++++++-----------
 drivers/block/aoe/aoedev.c |    1 
 drivers/block/aoe/aoenet.c |   13 ++-
 5 files changed, 111 insertions(+), 46 deletions(-)

diff -puN drivers/block/aoe/aoe.h~aoe-for-performance-support-larger-packet-payloads drivers/block/aoe/aoe.h
--- a/drivers/block/aoe/aoe.h~aoe-for-performance-support-larger-packet-payloads
+++ a/drivers/block/aoe/aoe.h
@@ -119,6 +119,8 @@ struct frame {
 	ulong bcnt;
 	sector_t lba;
 	struct sk_buff *skb;
+	struct bio_vec *bv;
+	ulong bv_off;
 };
 
 struct aoeif {
diff -puN drivers/block/aoe/aoeblk.c~aoe-for-performance-support-larger-packet-payloads drivers/block/aoe/aoeblk.c
--- a/drivers/block/aoe/aoeblk.c~aoe-for-performance-support-larger-packet-payloads
+++ a/drivers/block/aoe/aoeblk.c
@@ -254,6 +254,7 @@ aoeblk_gdalloc(void *vp)
 {
 	struct aoedev *d = vp;
 	struct gendisk *gd;
+	enum { KB = 1024, MB = KB * KB, READ_AHEAD = MB, };
 	ulong flags;
 
 	gd = alloc_disk(AOE_PARTITIONS);
@@ -279,6 +280,8 @@ aoeblk_gdalloc(void *vp)
 	if (bdi_init(&d->blkq->backing_dev_info))
 		goto err_blkq;
 	spin_lock_irqsave(&d->lock, flags);
+	blk_queue_max_hw_sectors(d->blkq, BLK_DEF_MAX_SECTORS);
+	d->blkq->backing_dev_info.ra_pages = READ_AHEAD / PAGE_CACHE_SIZE;
 	gd->major = AOE_MAJOR;
 	gd->first_minor = d->sysminor * AOE_PARTITIONS;
 	gd->fops = &aoe_bdops;
diff -puN drivers/block/aoe/aoecmd.c~aoe-for-performance-support-larger-packet-payloads drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~aoe-for-performance-support-larger-packet-payloads
+++ a/drivers/block/aoe/aoecmd.c
@@ -165,7 +165,8 @@ freeframe(struct aoedev *d)
 						rf = f;
 					continue;
 				}
-gotone:				skb_shinfo(skb)->nr_frags = skb->data_len = 0;
+gotone:				skb->truesize -= skb->data_len;
+				skb_shinfo(skb)->nr_frags = skb->data_len = 0;
 				skb_trim(skb, 0);
 				d->tgt = t;
 				ifrotate(*t);
@@ -201,6 +202,24 @@ gotone:				skb_shinfo(skb)->nr_frags = s
 	return NULL;
 }
 
+static void
+skb_fillup(struct sk_buff *skb, struct bio_vec *bv, ulong off, ulong cnt)
+{
+	int frag = 0;
+	ulong fcnt;
+loop:
+	fcnt = bv->bv_len - (off - bv->bv_offset);
+	if (fcnt > cnt)
+		fcnt = cnt;
+	skb_fill_page_desc(skb, frag++, bv->bv_page, off, fcnt);
+	cnt -= fcnt;
+	if (cnt <= 0)
+		return;
+	bv++;
+	off = bv->bv_offset;
+	goto loop;
+}
+
 static int
 aoecmd_ata_rw(struct aoedev *d)
 {
@@ -211,7 +230,7 @@ aoecmd_ata_rw(struct aoedev *d)
 	struct bio_vec *bv;
 	struct aoetgt *t;
 	struct sk_buff *skb;
-	ulong bcnt;
+	ulong bcnt, fbcnt;
 	char writebit, extbit;
 
 	writebit = 0x10;
@@ -226,8 +245,28 @@ aoecmd_ata_rw(struct aoedev *d)
 	bcnt = t->ifp->maxbcnt;
 	if (bcnt == 0)
 		bcnt = DEFAULTBCNT;
-	if (bcnt > buf->bv_resid)
-		bcnt = buf->bv_resid;
+	if (bcnt > buf->resid)
+		bcnt = buf->resid;
+	fbcnt = bcnt;
+	f->bv = buf->bv;
+	f->bv_off = f->bv->bv_offset + (f->bv->bv_len - buf->bv_resid);
+	do {
+		if (fbcnt < buf->bv_resid) {
+			buf->bv_resid -= fbcnt;
+			buf->resid -= fbcnt;
+			break;
+		}
+		fbcnt -= buf->bv_resid;
+		buf->resid -= buf->bv_resid;
+		if (buf->resid == 0) {
+			d->inprocess = NULL;
+			break;
+		}
+		buf->bv++;
+		buf->bv_resid = buf->bv->bv_len;
+		WARN_ON(buf->bv_resid == 0);
+	} while (fbcnt);
+
 	/* initialize the headers & frame */
 	skb = f->skb;
 	h = (struct aoe_hdr *) skb_mac_header(skb);
@@ -238,7 +277,6 @@ aoecmd_ata_rw(struct aoedev *d)
 	t->nout++;
 	f->waited = 0;
 	f->buf = buf;
-	f->bufaddr = page_address(bv->bv_page) + buf->bv_off;
 	f->bcnt = bcnt;
 	f->lba = buf->sector;
 
@@ -253,10 +291,11 @@ aoecmd_ata_rw(struct aoedev *d)
 		ah->lba3 |= 0xe0;	/* LBA bit + obsolete 0xa0 */
 	}
 	if (bio_data_dir(buf->bio) == WRITE) {
-		skb_fill_page_desc(skb, 0, bv->bv_page, buf->bv_off, bcnt);
+		skb_fillup(skb, f->bv, f->bv_off, bcnt);
 		ah->aflags |= AOEAFL_WRITE;
 		skb->len += bcnt;
 		skb->data_len = bcnt;
+		skb->truesize += bcnt;
 		t->wpkts++;
 	} else {
 		t->rpkts++;
@@ -267,18 +306,7 @@ aoecmd_ata_rw(struct aoedev *d)
 
 	/* mark all tracking fields and load out */
 	buf->nframesout += 1;
-	buf->bv_off += bcnt;
-	buf->bv_resid -= bcnt;
-	buf->resid -= bcnt;
 	buf->sector += bcnt >> 9;
-	if (buf->resid == 0) {
-		d->inprocess = NULL;
-	} else if (buf->bv_resid == 0) {
-		buf->bv = ++bv;
-		buf->bv_resid = bv->bv_len;
-		WARN_ON(buf->bv_resid == 0);
-		buf->bv_off = bv->bv_offset;
-	}
 
 	skb->dev = t->ifp->nd;
 	skb = skb_clone(skb, GFP_ATOMIC);
@@ -365,14 +393,12 @@ resend(struct aoedev *d, struct aoetgt *
 		put_lba(ah, f->lba);
 
 		n = f->bcnt;
-		if (n > DEFAULTBCNT)
-			n = DEFAULTBCNT;
 		ah->scnt = n >> 9;
 		if (ah->aflags & AOEAFL_WRITE) {
-			skb_fill_page_desc(skb, 0, virt_to_page(f->bufaddr),
-				offset_in_page(f->bufaddr), n);
+			skb_fillup(skb, f->bv, f->bv_off, n);
 			skb->len = sizeof *h + sizeof *ah + n;
 			skb->data_len = n;
+			skb->truesize += n;
 		}
 	}
 	skb->dev = t->ifp->nd;
@@ -531,20 +557,6 @@ rexmit_timer(ulong vp)
 				ejectif(t, ifp);
 				ifp = NULL;
 			}
-
-			if (ata_scnt(skb_mac_header(f->skb)) > DEFAULTBCNT / 512
-			&& ifp && ++ifp->lostjumbo > (t->nframes << 1)
-			&& ifp->maxbcnt != DEFAULTBCNT) {
-				printk(KERN_INFO
-					"aoe: e%ld.%d: "
-					"too many lost jumbo on "
-					"%s:%pm - "
-					"falling back to %d frames.\n",
-					d->aoemajor, d->aoeminor,
-					ifp->nd->name, t->addr,
-					DEFAULTBCNT);
-				ifp->maxbcnt = 0;
-			}
 			resend(d, t, f);
 		}
 
@@ -737,6 +749,45 @@ diskstats(struct gendisk *disk, struct b
 	part_stat_unlock();
 }
 
+static void
+bvcpy(struct bio_vec *bv, ulong off, struct sk_buff *skb, ulong cnt)
+{
+	ulong fcnt;
+	char *p;
+	int soff = 0;
+loop:
+	fcnt = bv->bv_len - (off - bv->bv_offset);
+	if (fcnt > cnt)
+		fcnt = cnt;
+	p = page_address(bv->bv_page) + off;
+	skb_copy_bits(skb, soff, p, fcnt);
+	soff += fcnt;
+	cnt -= fcnt;
+	if (cnt <= 0)
+		return;
+	bv++;
+	off = bv->bv_offset;
+	goto loop;
+}
+
+static void
+fadvance(struct frame *f, ulong cnt)
+{
+	ulong fcnt;
+
+	f->lba += cnt >> 9;
+loop:
+	fcnt = f->bv->bv_len - (f->bv_off - f->bv->bv_offset);
+	if (fcnt > cnt) {
+		f->bv_off += cnt;
+		return;
+	}
+	cnt -= fcnt;
+	f->bv++;
+	f->bv_off = f->bv->bv_offset;
+	goto loop;
+}
+
 void
 aoecmd_ata_rsp(struct sk_buff *skb)
 {
@@ -754,6 +805,7 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 	u16 aoemajor;
 
 	hin = (struct aoe_hdr *) skb_mac_header(skb);
+	skb_pull(skb, sizeof(*hin));
 	aoemajor = get_unaligned_be16(&hin->major);
 	d = aoedev_by_aoeaddr(aoemajor, hin->minor);
 	if (d == NULL) {
@@ -791,7 +843,8 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 
 	calc_rttavg(d, tsince(f->tag));
 
-	ahin = (struct aoe_atahdr *) (hin+1);
+	ahin = (struct aoe_atahdr *) skb->data;
+	skb_pull(skb, sizeof(*ahin));
 	hout = (struct aoe_hdr *) skb_mac_header(f->skb);
 	ahout = (struct aoe_atahdr *) (hout+1);
 	buf = f->buf;
@@ -810,7 +863,7 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 		switch (ahout->cmdstat) {
 		case ATA_CMD_PIO_READ:
 		case ATA_CMD_PIO_READ_EXT:
-			if (skb->len - sizeof *hin - sizeof *ahin < n) {
+			if (skb->len < n) {
 				printk(KERN_ERR
 					"aoe: %s.  skb->len=%d need=%ld\n",
 					"runt data size in read", skb->len, n);
@@ -818,7 +871,7 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 				spin_unlock_irqrestore(&d->lock, flags);
 				return;
 			}
-			memcpy(f->bufaddr, ahin+1, n);
+			bvcpy(f->bv, f->bv_off, skb, n);
 		case ATA_CMD_PIO_WRITE:
 		case ATA_CMD_PIO_WRITE_EXT:
 			ifp = getif(t, skb->dev);
@@ -828,21 +881,22 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 					ifp->lostjumbo = 0;
 			}
 			if (f->bcnt -= n) {
-				f->lba += n >> 9;
-				f->bufaddr += n;
+				fadvance(f, n);
 				resend(d, t, f);
 				goto xmit;
 			}
 			break;
 		case ATA_CMD_ID_ATA:
-			if (skb->len - sizeof *hin - sizeof *ahin < 512) {
+			if (skb->len < 512) {
 				printk(KERN_INFO
 					"aoe: runt data size in ataid.  skb->len=%d\n",
 					skb->len);
 				spin_unlock_irqrestore(&d->lock, flags);
 				return;
 			}
-			ataid_complete(d, t, (char *) (ahin+1));
+			if (skb_linearize(skb))
+				break;
+			ataid_complete(d, t, skb->data);
 			break;
 		default:
 			printk(KERN_INFO
diff -puN drivers/block/aoe/aoedev.c~aoe-for-performance-support-larger-packet-payloads drivers/block/aoe/aoedev.c
--- a/drivers/block/aoe/aoedev.c~aoe-for-performance-support-larger-packet-payloads
+++ a/drivers/block/aoe/aoedev.c
@@ -182,6 +182,7 @@ skbfree(struct sk_buff *skb)
 			"cannot free skb -- memory leaked.");
 		return;
 	}
+	skb->truesize -= skb->data_len;
 	skb_shinfo(skb)->nr_frags = skb->data_len = 0;
 	skb_trim(skb, 0);
 	dev_kfree_skb(skb);
diff -puN drivers/block/aoe/aoenet.c~aoe-for-performance-support-larger-packet-payloads drivers/block/aoe/aoenet.c
--- a/drivers/block/aoe/aoenet.c~aoe-for-performance-support-larger-packet-payloads
+++ a/drivers/block/aoe/aoenet.c
@@ -102,7 +102,9 @@ static int
 aoenet_rcv(struct sk_buff *skb, struct net_device *ifp, struct packet_type *pt, struct net_device *orig_dev)
 {
 	struct aoe_hdr *h;
+	struct aoe_atahdr *ah;
 	u32 n;
+	int sn;
 
 	if (dev_net(ifp) != &init_net)
 		goto exit;
@@ -110,13 +112,16 @@ aoenet_rcv(struct sk_buff *skb, struct n
 	skb = skb_share_check(skb, GFP_ATOMIC);
 	if (skb == NULL)
 		return 0;
-	if (skb_linearize(skb))
-		goto exit;
 	if (!is_aoe_netif(ifp))
 		goto exit;
 	skb_push(skb, ETH_HLEN);	/* (1) */
