From: akpm@linux-foundation.org
Subject: + aoe-handle-multiple-network-paths-to-aoe-device.patch added to -mm tree
Date: Fri, 21 Dec 2007 22:03:41 -0800
Message-ID: <200712220603.lBM63fhE020107@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48256 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753852AbXLVGDs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 22 Dec 2007 01:03:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ecashin@coraid.com, greg@kroah.com


The patch titled
     aoe: handle multiple network paths to AoE device
has been added to the -mm tree.  Its filename is
     aoe-handle-multiple-network-paths-to-aoe-device.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: aoe: handle multiple network paths to AoE device
From: "Ed L. Cashin" <ecashin@coraid.com>

A remote AoE device is something can process ATA commands and is identified by
an AoE shelf number and an AoE slot number.  Such a device might have more
than one network interface, and it might be reachable by more than one local
network interface.  This patch tracks the available network paths available to
each AoE device, allowing them to be used more efficiently.

Andrew Morton asked about the call to msleep_interruptible in the revalidate
function.  Yes, if a signal is pending, then msleep_interruptible will not
return 0.  That means we will not loop but will call aoenet_xmit with a NULL
skb, which is a noop.  If the system is too low on memory or the aoe driver is
too low on frames, then the user can hit control-C to interrupt the attempt to
do a revalidate.  I have added a comment to the code summarizing that.

Andrew Morton asked whether the allocation performed inside addtgt could use a
more relaxed allocation like GFP_KERNEL, but addtgt is called when the aoedev
lock has been locked with spin_lock_irqsave.  It would be nice to allocate the
memory under fewer restrictions, but targets are only added when the device is
being discovered, and if the target can't be added right now, we can try again
in a minute when then next AoE config query broadcast goes out.

Andrew Morton pointed out that the "too many targets" message could be printed
for failing GFP_ATOMIC allocations.  The last patch in this series makes the
messages more specific.

Signed-off-by: Ed L. Cashin <ecashin@coraid.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoe.h    |   57 ++
 drivers/block/aoe/aoeblk.c |   62 ++-
 drivers/block/aoe/aoechr.c |   17 
 drivers/block/aoe/aoecmd.c |  673 +++++++++++++++++++++++------------
 drivers/block/aoe/aoedev.c |  168 ++++----
 drivers/block/aoe/aoenet.c |    9 
 6 files changed, 652 insertions(+), 334 deletions(-)

diff -puN drivers/block/aoe/aoe.h~aoe-handle-multiple-network-paths-to-aoe-device drivers/block/aoe/aoe.h
--- a/drivers/block/aoe/aoe.h~aoe-handle-multiple-network-paths-to-aoe-device
+++ a/drivers/block/aoe/aoe.h
@@ -76,10 +76,8 @@ enum {
 	DEVFL_EXT = (1<<2),	/* device accepts lba48 commands */
 	DEVFL_CLOSEWAIT = (1<<3), /* device is waiting for all closes to revalidate */
 	DEVFL_GDALLOC = (1<<4),	/* need to alloc gendisk */
-	DEVFL_PAUSE = (1<<5),
+	DEVFL_KICKME = (1<<5),	/* slow polling network card catch */
 	DEVFL_NEWSIZE = (1<<6),	/* need to update dev size in block layer */
-	DEVFL_MAXBCNT = (1<<7), /* d->maxbcnt is not changeable */
-	DEVFL_KICKME = (1<<8),
 
 	BUFFL_FAIL = 1,
 };
@@ -88,17 +86,24 @@ enum {
 	DEFAULTBCNT = 2 * 512,	/* 2 sectors */
 	NPERSHELF = 16,		/* number of slots per shelf address */
 	FREETAG = -1,
-	MIN_BUFS = 8,
+	MIN_BUFS = 16,
+	NTARGETS = 8,
+	NAOEIFS = 8,
+
+	TIMERTICK = HZ / 10,
+	MINTIMER = HZ >> 2,
+	MAXTIMER = HZ << 1,
+	HELPWAIT = 20,
 };
 
 struct buf {
 	struct list_head bufs;
-	ulong start_time;	/* for disk stats */
+	ulong stime;	/* for disk stats */
 	ulong flags;
 	ulong nframesout;
-	char *bufaddr;
 	ulong resid;
 	ulong bv_resid;
+	ulong bv_off;
 	sector_t sector;
 	struct bio *bio;
 	struct bio_vec *bv;
@@ -114,19 +119,37 @@ struct frame {
 	struct sk_buff *skb;
 };
 
+struct aoeif {
+	struct net_device *nd;
+	unsigned char lost;
+	unsigned char lostjumbo;
+	ushort maxbcnt;
+};
+
+struct aoetgt {
+	unsigned char addr[6];
+	ushort nframes;
+	struct frame *frames;
+	struct aoeif ifs[NAOEIFS];
+	struct aoeif *ifp;	/* current aoeif in use */
+	ushort nout;
+	ushort maxout;
+	u16 lasttag;		/* last tag sent */
+	u16 useme;
+	ulong lastwadj;		/* last window adjustment */
+	int wpkts, rpkts;
+};
+
 struct aoedev {
 	struct aoedev *next;
-	unsigned char addr[6];	/* remote mac addr */
-	ushort flags;
 	ulong sysminor;
 	ulong aoemajor;
-	ulong aoeminor;
+	u16 aoeminor;
+	u16 flags;
 	u16 nopen;		/* (bd_openers isn't available without sleeping) */
-	u16 lasttag;		/* last tag sent */
 	u16 rttavg;		/* round trip average of requests/responses */
 	u16 mintimer;
 	u16 fw_ver;		/* version of blade's firmware */
-	u16 maxbcnt;
 	struct work_struct work;/* disk create work struct */
 	struct gendisk *gd;
 	struct request_queue blkq;
@@ -134,15 +157,14 @@ struct aoedev {
 	sector_t ssize;
 	struct timer_list timer;
 	spinlock_t lock;
-	struct net_device *ifp;	/* interface ed is attached to */
 	struct sk_buff *sendq_hd; /* packets needing to be sent, list head */
 	struct sk_buff *sendq_tl;
 	mempool_t *bufpool;	/* for deadlock-free Buf allocation */
 	struct list_head bufq;	/* queue of bios to work on */
 	struct buf *inprocess;	/* the one we're currently working on */
-	ushort lostjumbo;
-	ushort nframes;		/* number of frames below */
-	struct frame *frames;
+	struct aoetgt *targets[NTARGETS];
+	struct aoetgt **tgt;	/* target in use when working */
+	struct aoetgt **htgt;	/* target needing rexmit assistance */
 };
 
 
@@ -160,12 +182,13 @@ void aoecmd_cfg(ushort aoemajor, unsigne
 void aoecmd_ata_rsp(struct sk_buff *);
 void aoecmd_cfg_rsp(struct sk_buff *);
 void aoecmd_sleepwork(struct work_struct *);
-struct sk_buff *new_skb(ulong);
+void aoecmd_cleanslate(struct aoedev *);
+struct sk_buff *aoecmd_ata_id(struct aoedev *);
 
 int aoedev_init(void);
 void aoedev_exit(void);
 struct aoedev *aoedev_by_aoeaddr(int maj, int min);
-struct aoedev *aoedev_by_sysminor_m(ulong sysminor, ulong bufcnt);
+struct aoedev *aoedev_by_sysminor_m(ulong sysminor);
 void aoedev_downdev(struct aoedev *d);
 int aoedev_isbusy(struct aoedev *d);
 
diff -puN drivers/block/aoe/aoeblk.c~aoe-handle-multiple-network-paths-to-aoe-device drivers/block/aoe/aoeblk.c
--- a/drivers/block/aoe/aoeblk.c~aoe-handle-multiple-network-paths-to-aoe-device
+++ a/drivers/block/aoe/aoeblk.c
@@ -24,7 +24,7 @@ static ssize_t aoedisk_show_state(struct
 	return snprintf(page, PAGE_SIZE,
 			"%s%s\n",
 			(d->flags & DEVFL_UP) ? "up" : "down",
-			(d->flags & DEVFL_PAUSE) ? ",paused" :
+			(d->flags & DEVFL_KICKME) ? ",kickme" :
 			(d->nopen && !(d->flags & DEVFL_UP)) ? ",closewait" : "");
 	/* I'd rather see nopen exported so we can ditch closewait */
 }
@@ -33,17 +33,49 @@ static ssize_t aoedisk_show_mac(struct d
 {
 	struct gendisk *disk = dev_to_disk(dev);
 	struct aoedev *d = disk->private_data;
+	struct aoetgt *t = d->targets[0];
 
+	if (t == NULL)
+		return snprintf(page, PAGE_SIZE, "none\n");
 	return snprintf(page, PAGE_SIZE, "%012llx\n",
-			(unsigned long long)mac_addr(d->addr));
+			(unsigned long long)mac_addr(t->addr));
 }
 static ssize_t aoedisk_show_netif(struct device *dev,
 				  struct device_attribute *attr, char *page)
 {
 	struct gendisk *disk = dev_to_disk(dev);
 	struct aoedev *d = disk->private_data;
+	struct net_device *nds[8], **nd, **nnd, **ne;
+	struct aoetgt **t, **te;
+	struct aoeif *ifp, *e;
+	char *p;
+
+	memset(nds, 0, sizeof nds);
+	nd = nds;
+	ne = nd + ARRAY_SIZE(nds);
+	t = d->targets;
+	te = t + NTARGETS;
+	for (; t < te && *t; t++) {
+		ifp = (*t)->ifs;
+		e = ifp + NAOEIFS;
+		for (; ifp < e && ifp->nd; ifp++) {
+			for (nnd = nds; nnd < nd; nnd++)
+				if (*nnd == ifp->nd)
+					break;
+			if (nnd == nd && nd != ne)
+				*nd++ = ifp->nd;
+		}
+	}
 
-	return snprintf(page, PAGE_SIZE, "%s\n", d->ifp->name);
+	ne = nd;
+	nd = nds;
+	if (*nd == NULL)
+		return snprintf(page, PAGE_SIZE, "none\n");
+	for (p = page; nd < ne; nd++)
+		p += snprintf(p, PAGE_SIZE - (p-page), "%s%s",
+			p == page ? "" : ",", (*nd)->name);
+	p += snprintf(p, PAGE_SIZE - (p-page), "\n");
+	return p-page;
 }
 /* firmware version */
 static ssize_t aoedisk_show_fwver(struct device *dev,
@@ -134,7 +166,23 @@ aoeblk_make_request(struct request_queue
 
 	blk_queue_bounce(q, &bio);
 
+	if (bio == NULL) {
+		printk(KERN_ERR "aoe: bio is NULL\n");
+		BUG();
+		return 0;
+	}
 	d = bio->bi_bdev->bd_disk->private_data;
+	if (d == NULL) {
+		printk(KERN_ERR "aoe: bd_disk->private_data is NULL\n");
+		BUG();
+		bio_endio(bio, -ENXIO);
+		return 0;
+	} else if (bio->bi_io_vec == NULL) {
+		printk(KERN_ERR "aoe: bi_io_vec is NULL\n");
+		BUG();
+		bio_endio(bio, -ENXIO);
+		return 0;
+	}
 	buf = mempool_alloc(d->bufpool, GFP_NOIO);
 	if (buf == NULL) {
 		printk(KERN_INFO "aoe: buf allocation failure\n");
@@ -143,14 +191,14 @@ aoeblk_make_request(struct request_queue
 	}
 	memset(buf, 0, sizeof(*buf));
 	INIT_LIST_HEAD(&buf->bufs);
-	buf->start_time = jiffies;
+	buf->stime = jiffies;
 	buf->bio = bio;
 	buf->resid = bio->bi_size;
 	buf->sector = bio->bi_sector;
 	buf->bv = &bio->bi_io_vec[bio->bi_idx];
-	WARN_ON(buf->bv->bv_len == 0);
 	buf->bv_resid = buf->bv->bv_len;
-	buf->bufaddr = page_address(buf->bv->bv_page) + buf->bv->bv_offset;
+	WARN_ON(buf->bv_resid == 0);
+	buf->bv_off = buf->bv->bv_offset;
 
 	spin_lock_irqsave(&d->lock, flags);
 
@@ -229,7 +277,7 @@ aoeblk_gdalloc(void *vp)
 	gd->fops = &aoe_bdops;
 	gd->private_data = d;
 	gd->capacity = d->ssize;
-	snprintf(gd->disk_name, sizeof gd->disk_name, "etherd/e%ld.%ld",
+	snprintf(gd->disk_name, sizeof gd->disk_name, "etherd/e%ld.%d",
 		d->aoemajor, d->aoeminor);
 
 	gd->queue = &d->blkq;
diff -puN drivers/block/aoe/aoechr.c~aoe-handle-multiple-network-paths-to-aoe-device drivers/block/aoe/aoechr.c
--- a/drivers/block/aoe/aoechr.c~aoe-handle-multiple-network-paths-to-aoe-device
+++ a/drivers/block/aoe/aoechr.c
@@ -6,6 +6,7 @@
 
 #include <linux/hdreg.h>
 #include <linux/blkdev.h>
+#include <linux/delay.h>
 #include "aoe.h"
 
 enum {
@@ -68,6 +69,7 @@ revalidate(const char __user *str, size_
 	int major, minor, n;
 	ulong flags;
 	struct aoedev *d;
+	struct sk_buff *skb;
 	char buf[16];
 
 	if (size >= sizeof buf)
@@ -85,13 +87,20 @@ revalidate(const char __user *str, size_
 	d = aoedev_by_aoeaddr(major, minor);
 	if (!d)
 		return -EINVAL;
-
 	spin_lock_irqsave(&d->lock, flags);
-	d->flags &= ~DEVFL_MAXBCNT;
-	d->flags |= DEVFL_PAUSE;
+	aoecmd_cleanslate(d);
+loop:
+	skb = aoecmd_ata_id(d);
 	spin_unlock_irqrestore(&d->lock, flags);
+	/* try again if we are able to sleep a bit,
+	 * otherwise give up this revalidation
+	 */
+	if (!skb && !msleep_interruptible(200)) {
+		spin_lock_irqsave(&d->lock, flags);
+		goto loop;
+	}
+	aoenet_xmit(skb);
 	aoecmd_cfg(major, minor);
-
 	return 0;
 }
 
diff -puN drivers/block/aoe/aoecmd.c~aoe-handle-multiple-network-paths-to-aoe-device drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~aoe-handle-multiple-network-paths-to-aoe-device
+++ a/drivers/block/aoe/aoecmd.c
@@ -9,19 +9,16 @@
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
 #include <linux/genhd.h>
+#include <linux/moduleparam.h>
 #include <net/net_namespace.h>
 #include <asm/unaligned.h>
 #include "aoe.h"
 
-#define TIMERTICK (HZ / 10)
-#define MINTIMER (2 * TIMERTICK)
-#define MAXTIMER (HZ << 1)
-
 static int aoe_deadsecs = 60 * 3;
 module_param(aoe_deadsecs, int, 0644);
 MODULE_PARM_DESC(aoe_deadsecs, "After aoe_deadsecs seconds, give up and fail dev.");
 
-struct sk_buff *
+static struct sk_buff *
 new_skb(ulong len)
 {
 	struct sk_buff *skb;
@@ -43,12 +40,12 @@ new_skb(ulong len)
 }
 
 static struct frame *
-getframe(struct aoedev *d, int tag)
+getframe(struct aoetgt *t, int tag)
 {
 	struct frame *f, *e;
 
-	f = d->frames;
-	e = f + d->nframes;
+	f = t->frames;
+	e = f + t->nframes;
 	for (; f<e; f++)
 		if (f->tag == tag)
 			return f;
@@ -61,21 +58,21 @@ getframe(struct aoedev *d, int tag)
  * This driver reserves tag -1 to mean "unused frame."
  */
 static int
-newtag(struct aoedev *d)
+newtag(struct aoetgt *t)
 {
 	register ulong n;
 
 	n = jiffies & 0xffff;
-	return n |= (++d->lasttag & 0x7fff) << 16;
+	return n |= (++t->lasttag & 0x7fff) << 16;
 }
 
 static int
-aoehdr_atainit(struct aoedev *d, struct aoe_hdr *h)
+aoehdr_atainit(struct aoedev *d, struct aoetgt *t, struct aoe_hdr *h)
 {
-	u32 host_tag = newtag(d);
+	u32 host_tag = newtag(t);
 
-	memcpy(h->src, d->ifp->dev_addr, sizeof h->src);
-	memcpy(h->dst, d->addr, sizeof h->dst);
+	memcpy(h->src, t->ifp->nd->dev_addr, sizeof h->src);
+	memcpy(h->dst, t->addr, sizeof h->dst);
 	h->type = __constant_cpu_to_be16(ETH_P_AOE);
 	h->verfl = AOE_HVER;
 	h->major = cpu_to_be16(d->aoemajor);
@@ -98,42 +95,103 @@ put_lba(struct aoe_atahdr *ah, sector_t 
 }
 
 static void
-aoecmd_ata_rw(struct aoedev *d, struct frame *f)
+ifrotate(struct aoetgt *t)
+{
+	t->ifp++;
+	if (t->ifp >= &t->ifs[NAOEIFS] || t->ifp->nd == NULL)
+		t->ifp = t->ifs;
+	if (t->ifp->nd == NULL) {
+		printk(KERN_INFO "aoe: no interface to rotate to\n");
+		BUG();
+	}
+}
+
+static struct frame *
+freeframe(struct aoedev *d)
+{
+	struct frame *f, *e;
+	struct aoetgt **t;
+	ulong n;
+
+	if (d->targets[0] == NULL) {	/* shouldn't happen, but I'm paranoid */
+		printk(KERN_ERR "aoe: NULL TARGETS!\n");
+		return NULL;
+	}
+	t = d->targets;
+	do {
+		if (t != d->htgt
+		&& (*t)->ifp->nd
+		&& (*t)->nout < (*t)->maxout) {
+			n = (*t)->nframes;
+			f = (*t)->frames;
+			e = f + n;
+			for (; f < e; f++) {
+				if (f->tag != FREETAG)
+					continue;
+				if (atomic_read(&skb_shinfo(f->skb)->dataref)
+					!= 1) {
+					n--;
+					continue;
+				}
+				skb_shinfo(f->skb)->nr_frags = 0;
+				f->skb->data_len = 0;
+				skb_trim(f->skb, 0);
+				d->tgt = t;
+				ifrotate(*t);
+				return f;
+			}
+			if (n == 0)	/* slow polling network card */
+				d->flags |= DEVFL_KICKME;
+		}
+		t++;
+	} while (t < &d->targets[NTARGETS] && *t);
+	return NULL;
+}
+
+static int
+aoecmd_ata_rw(struct aoedev *d)
 {
+	struct frame *f;
 	struct aoe_hdr *h;
 	struct aoe_atahdr *ah;
 	struct buf *buf;
+	struct bio_vec *bv;
+	struct aoetgt *t;
 	struct sk_buff *skb;
 	ulong bcnt;
-	register sector_t sector;
 	char writebit, extbit;
 
 	writebit = 0x10;
 	extbit = 0x4;
 
+	f = freeframe(d);
+	if (f == NULL)
+		return 0;
+	t = *d->tgt;
 	buf = d->inprocess;
-
-	sector = buf->sector;
-	bcnt = buf->bv_resid;
-	if (bcnt > d->maxbcnt)
-		bcnt = d->maxbcnt;
-
+	bv = buf->bv;
+	bcnt = t->ifp->maxbcnt;
+	if (bcnt == 0)
+		bcnt = DEFAULTBCNT;
+	if (bcnt > buf->bv_resid)
+		bcnt = buf->bv_resid;
 	/* initialize the headers & frame */
 	skb = f->skb;
 	h = (struct aoe_hdr *) skb_mac_header(skb);
 	ah = (struct aoe_atahdr *) (h+1);
 	skb_put(skb, sizeof *h + sizeof *ah);
 	memset(h, 0, skb->len);
-	f->tag = aoehdr_atainit(d, h);
+	f->tag = aoehdr_atainit(d, t, h);
+	t->nout++;
 	f->waited = 0;
 	f->buf = buf;
-	f->bufaddr = buf->bufaddr;
+	f->bufaddr = page_address(bv->bv_page) + buf->bv_off;
 	f->bcnt = bcnt;
-	f->lba = sector;
+	f->lba = buf->sector;
 
 	/* set up ata header */
 	ah->scnt = bcnt >> 9;
-	put_lba(ah, sector);
+	put_lba(ah, buf->sector);
 	if (d->flags & DEVFL_EXT) {
 		ah->aflags |= AOEAFL_EXT;
 	} else {
@@ -141,14 +199,14 @@ aoecmd_ata_rw(struct aoedev *d, struct f
 		ah->lba3 &= 0x0f;
 		ah->lba3 |= 0xe0;	/* LBA bit + obsolete 0xa0 */
 	}
-
 	if (bio_data_dir(buf->bio) == WRITE) {
-		skb_fill_page_desc(skb, 0, virt_to_page(f->bufaddr),
-			offset_in_page(f->bufaddr), bcnt);
+		skb_fill_page_desc(skb, 0, bv->bv_page, buf->bv_off, bcnt);
 		ah->aflags |= AOEAFL_WRITE;
 		skb->len += bcnt;
 		skb->data_len = bcnt;
+		t->wpkts++;
 	} else {
+		t->rpkts++;
 		writebit = 0;
 	}
 
@@ -156,29 +214,29 @@ aoecmd_ata_rw(struct aoedev *d, struct f
 
 	/* mark all tracking fields and load out */
 	buf->nframesout += 1;
-	buf->bufaddr += bcnt;
+	buf->bv_off += bcnt;
 	buf->bv_resid -= bcnt;
-/* printk(KERN_DEBUG "aoe: bv_resid=%ld\n", buf->bv_resid); */
 	buf->resid -= bcnt;
 	buf->sector += bcnt >> 9;
 	if (buf->resid == 0) {
 		d->inprocess = NULL;
 	} else if (buf->bv_resid == 0) {
-		buf->bv++;
-		WARN_ON(buf->bv->bv_len == 0);
-		buf->bv_resid = buf->bv->bv_len;
-		buf->bufaddr = page_address(buf->bv->bv_page) + buf->bv->bv_offset;
+		buf->bv = ++bv;
+		buf->bv_resid = bv->bv_len;
+		WARN_ON(buf->bv_resid == 0);
+		buf->bv_off = bv->bv_offset;
 	}
 
-	skb->dev = d->ifp;
+	skb->dev = t->ifp->nd;
 	skb = skb_clone(skb, GFP_ATOMIC);
-	if (skb == NULL)
-		return;
-	if (d->sendq_hd)
-		d->sendq_tl->next = skb;
-	else
-		d->sendq_hd = skb;
-	d->sendq_tl = skb;
+	if (skb) {
+		if (d->sendq_hd)
+			d->sendq_tl->next = skb;
+		else
+			d->sendq_hd = skb;
+		d->sendq_tl = skb;
+	}
+	return 1;
 }
 
 /* some callers cannot sleep, and they can call this function,
@@ -232,62 +290,8 @@ cont:
 	return sl;
 }
 
-static struct frame *
-freeframe(struct aoedev *d)
-{
-	struct frame *f, *e;
-	int n = 0;
-
-	f = d->frames;
-	e = f + d->nframes;
-	for (; f<e; f++) {
-		if (f->tag != FREETAG)
-			continue;
-		if (atomic_read(&skb_shinfo(f->skb)->dataref) == 1) {
-			skb_shinfo(f->skb)->nr_frags = f->skb->data_len = 0;
-			skb_trim(f->skb, 0);
-			return f;
-		}
-		n++;
-	}
-	if (n == d->nframes)	/* wait for network layer */
-		d->flags |= DEVFL_KICKME;
-
-	return NULL;
-}
-
-/* enters with d->lock held */
-void
-aoecmd_work(struct aoedev *d)
-{
-	struct frame *f;
-	struct buf *buf;
-
-	if (d->flags & DEVFL_PAUSE) {
-		if (!aoedev_isbusy(d))
-			d->sendq_hd = aoecmd_cfg_pkts(d->aoemajor,
-						d->aoeminor, &d->sendq_tl);
-		return;
-	}
-
-loop:
-	f = freeframe(d);
-	if (f == NULL)
-		return;
-	if (d->inprocess == NULL) {
-		if (list_empty(&d->bufq))
-			return;
-		buf = container_of(d->bufq.next, struct buf, bufs);
-		list_del(d->bufq.next);
-/*printk(KERN_DEBUG "aoe: bi_size=%ld\n", buf->bio->bi_size); */
-		d->inprocess = buf;
-	}
-	aoecmd_ata_rw(d, f);
-	goto loop;
-}
-
 static void
-rexmit(struct aoedev *d, struct frame *f)
+resend(struct aoedev *d, struct aoetgt *t, struct frame *f)
 {
 	struct sk_buff *skb;
 	struct aoe_hdr *h;
@@ -295,41 +299,45 @@ rexmit(struct aoedev *d, struct frame *f
 	char buf[128];
 	u32 n;
 
-	n = newtag(d);
+	ifrotate(t);
+	n = newtag(t);
+	skb = f->skb;
+	h = (struct aoe_hdr *) skb_mac_header(skb);
+	ah = (struct aoe_atahdr *) (h+1);
 
 	snprintf(buf, sizeof buf,
-		"%15s e%ld.%ld oldtag=%08x@%08lx newtag=%08x\n",
-		"retransmit",
-		d->aoemajor, d->aoeminor, f->tag, jiffies, n);
+		"%15s e%ld.%d oldtag=%08x@%08lx newtag=%08x "
+		"s=%012llx d=%012llx nout=%d\n",
+		"retransmit", d->aoemajor, d->aoeminor, f->tag, jiffies, n,
+		mac_addr(h->src), mac_addr(h->dst), t->nout);
 	aoechr_error(buf);
 
-	skb = f->skb;
-	h = (struct aoe_hdr *) skb_mac_header(skb);
-	ah = (struct aoe_atahdr *) (h+1);
 	f->tag = n;
 	h->tag = cpu_to_be32(n);
-	memcpy(h->dst, d->addr, sizeof h->dst);
-	memcpy(h->src, d->ifp->dev_addr, sizeof h->src);
+	memcpy(h->dst, t->addr, sizeof h->dst);
+	memcpy(h->src, t->ifp->nd->dev_addr, sizeof h->src);
 
-	n = DEFAULTBCNT / 512;
-	if (ah->scnt > n) {
-		ah->scnt = n;
+	switch (ah->cmdstat) {
+	default:
+		break;
+	case WIN_READ:
+	case WIN_READ_EXT:
+	case WIN_WRITE:
+	case WIN_WRITE_EXT:
+		put_lba(ah, f->lba);
+
+		n = f->bcnt;
+		if (n > DEFAULTBCNT)
+			n = DEFAULTBCNT;
+		ah->scnt = n >> 9;
 		if (ah->aflags & AOEAFL_WRITE) {
 			skb_fill_page_desc(skb, 0, virt_to_page(f->bufaddr),
-				offset_in_page(f->bufaddr), DEFAULTBCNT);
-			skb->len = sizeof *h + sizeof *ah + DEFAULTBCNT;
-			skb->data_len = DEFAULTBCNT;
-		}
-		if (++d->lostjumbo > (d->nframes << 1))
-		if (d->maxbcnt != DEFAULTBCNT) {
-			printk(KERN_INFO "aoe: e%ld.%ld: too many lost jumbo on %s - using 1KB frames.\n",
-				d->aoemajor, d->aoeminor, d->ifp->name);
-			d->maxbcnt = DEFAULTBCNT;
-			d->flags |= DEVFL_MAXBCNT;
+				offset_in_page(f->bufaddr), n);
+			skb->len = sizeof *h + sizeof *ah + n;
+			skb->data_len = n;
 		}
 	}
-
-	skb->dev = d->ifp;
+	skb->dev = t->ifp->nd;
 	skb = skb_clone(skb, GFP_ATOMIC);
 	if (skb == NULL)
 		return;
@@ -352,10 +360,92 @@ tsince(int tag)
 	return n;
 }
 
+static struct aoeif *
+getif(struct aoetgt *t, struct net_device *nd)
+{
+	struct aoeif *p, *e;
+
+	p = t->ifs;
+	e = p + NAOEIFS;
+	for (; p < e; p++)
+		if (p->nd == nd)
+			return p;
+	return NULL;
+}
+
+static struct aoeif *
+addif(struct aoetgt *t, struct net_device *nd)
+{
+	struct aoeif *p;
+
+	p = getif(t, NULL);
+	if (!p)
+		return NULL;
+	p->nd = nd;
+	p->maxbcnt = DEFAULTBCNT;
+	p->lost = 0;
+	p->lostjumbo = 0;
+	return p;
+}
+
+static void
+ejectif(struct aoetgt *t, struct aoeif *ifp)
+{
+	struct aoeif *e;
+	ulong n;
+
+	e = t->ifs + NAOEIFS - 1;
+	n = (e - ifp) * sizeof *ifp;
+	memmove(ifp, ifp+1, n);
+	e->nd = NULL;
+}
+
+static int
+sthtith(struct aoedev *d)
+{
+	struct frame *f, *e, *nf;
+	struct sk_buff *skb;
+	struct aoetgt *ht = *d->htgt;
+
+	f = ht->frames;
+	e = f + ht->nframes;
+	for (; f < e; f++) {
+		if (f->tag == FREETAG)
+			continue;
+		nf = freeframe(d);
+		if (!nf)
+			return 0;
+		skb = nf->skb;
+		*nf = *f;
+		f->skb = skb;
+		f->tag = FREETAG;
+		nf->waited = 0;
+		ht->nout--;
+		(*d->tgt)->nout++;
+		resend(d, *d->tgt, nf);
+	}
+	/* he's clean, he's useless.  take away his interfaces */
+	memset(ht->ifs, 0, sizeof ht->ifs);
+	d->htgt = NULL;
+	return 1;
+}
+
+static inline unsigned char
+ata_scnt(unsigned char *packet) {
+	struct aoe_hdr *h;
+	struct aoe_atahdr *ah;
+
+	h = (struct aoe_hdr *) packet;
+	ah = (struct aoe_atahdr *) (h+1);
+	return ah->scnt;
+}
+
 static void
 rexmit_timer(ulong vp)
 {
 	struct aoedev *d;
+	struct aoetgt *t, **tt, **te;
+	struct aoeif *ifp;
 	struct frame *f, *e;
 	struct sk_buff *sl;
 	register long timeout;
@@ -374,31 +464,79 @@ rexmit_timer(ulong vp)
 		spin_unlock_irqrestore(&d->lock, flags);
 		return;
 	}
-	f = d->frames;
-	e = f + d->nframes;
-	for (; f<e; f++) {
-		if (f->tag != FREETAG && tsince(f->tag) >= timeout) {
+	tt = d->targets;
+	te = tt + NTARGETS;
+	for (; tt < te && *tt; tt++) {
+		t = *tt;
+		f = t->frames;
+		e = f + t->nframes;
+		for (; f < e; f++) {
+			if (f->tag == FREETAG
+			|| tsince(f->tag) < timeout)
+				continue;
 			n = f->waited += timeout;
 			n /= HZ;
-			if (n > aoe_deadsecs) { /* waited too long for response */
+			if (n > aoe_deadsecs) {
+				/* waited too long.  device failure. */
 				aoedev_downdev(d);
 				break;
 			}
-			rexmit(d, f);
+
+			if (n > HELPWAIT /* see if another target can help */
+			&& (tt != d->targets || d->targets[1]))
+				d->htgt = tt;
+
+			if (t->nout == t->maxout) {
+				if (t->maxout > 1)
+					t->maxout--;
+				t->lastwadj = jiffies;
+			}
+
+			ifp = getif(t, f->skb->dev);
+			if (ifp && ++ifp->lost > (t->nframes << 1)
+			&& (ifp != t->ifs || t->ifs[1].nd)) {
+				ejectif(t, ifp);
+				ifp = NULL;
+			}
+
+			if (ata_scnt(skb_mac_header(f->skb)) > DEFAULTBCNT / 512
+			&& ifp && ++ifp->lostjumbo > (t->nframes << 1)
+			&& ifp->maxbcnt != DEFAULTBCNT) {
+				printk(KERN_INFO
+					"aoe: e%ld.%d: "
+					"too many lost jumbo on "
+					"%s:%012llx - "
+					"falling back to %d frames.\n",
+					d->aoemajor, d->aoeminor,
+					ifp->nd->name, mac_addr(t->addr),
+					DEFAULTBCNT);
+				ifp->maxbcnt = 0;
+			}
+			resend(d, t, f);
+		}
+
+		/* window check */
+		if (t->nout == t->maxout
+		&& t->maxout < t->nframes
+		&& (jiffies - t->lastwadj)/HZ > 10) {
+			t->maxout++;
+			t->lastwadj = jiffies;
 		}
 	}
-	if (d->flags & DEVFL_KICKME) {
+
+	if (d->sendq_hd) {
+		n = d->rttavg <<= 1;
+		if (n > MAXTIMER)
+			d->rttavg = MAXTIMER;
+	}
+
+	if (d->flags & DEVFL_KICKME || d->htgt) {
 		d->flags &= ~DEVFL_KICKME;
 		aoecmd_work(d);
 	}
 
 	sl = d->sendq_hd;
 	d->sendq_hd = d->sendq_tl = NULL;
-	if (sl) {
-		n = d->rttavg <<= 1;
-		if (n > MAXTIMER)
-			d->rttavg = MAXTIMER;
-	}
 
 	d->timer.expires = jiffies + TIMERTICK;
 	add_timer(&d->timer);
@@ -408,6 +546,25 @@ rexmit_timer(ulong vp)
 	aoenet_xmit(sl);
 }
 
+/* enters with d->lock held */
+void
+aoecmd_work(struct aoedev *d)
+{
+	struct buf *buf;
+loop:
+	if (d->htgt && !sthtith(d))
+		return;
+	if (d->inprocess == NULL) {
+		if (list_empty(&d->bufq))
+			return;
+		buf = container_of(d->bufq.next, struct buf, bufs);
+		list_del(d->bufq.next);
+		d->inprocess = buf;
+	}
+	if (aoecmd_ata_rw(d))
+		goto loop;
+}
+
 /* this function performs work that has been deferred until sleeping is OK
  */
 void
@@ -440,7 +597,7 @@ aoecmd_sleepwork(struct work_struct *wor
 }
 
 static void
-ataid_complete(struct aoedev *d, unsigned char *id)
+ataid_complete(struct aoedev *d, struct aoetgt *t, unsigned char *id)
 {
 	u64 ssize;
 	u16 n;
@@ -476,7 +633,7 @@ ataid_complete(struct aoedev *d, unsigne
 
 	if (d->ssize != ssize)
 		printk(KERN_INFO "aoe: %012llx e%lu.%lu v%04x has %llu sectors\n",
-			(unsigned long long)mac_addr(d->addr),
+			(unsigned long long)mac_addr(t->addr),
 			d->aoemajor, d->aoeminor,
 			d->fw_ver, (long long)ssize);
 	d->ssize = ssize;
@@ -484,15 +641,8 @@ ataid_complete(struct aoedev *d, unsigne
 	if (d->gd != NULL) {
 		d->gd->capacity = ssize;
 		d->flags |= DEVFL_NEWSIZE;
-	} else {
-		if (d->flags & DEVFL_GDALLOC) {
-			printk(KERN_ERR "aoe: can't schedule work for e%lu.%lu, %s\n",
-			       d->aoemajor, d->aoeminor,
-			       "it's already on!  This shouldn't happen.\n");
-			return;
-		}
+	} else
 		d->flags |= DEVFL_GDALLOC;
-	}
 	schedule_work(&d->work);
 }
 
@@ -519,6 +669,31 @@ calc_rttavg(struct aoedev *d, int rtt)
 	d->rttavg += n >> 2;
 }
 
+static struct aoetgt *
+gettgt(struct aoedev *d, char *addr)
+{
+	struct aoetgt **t, **e;
+
+	t = d->targets;
+	e = t + NTARGETS;
+	for (; t < e && *t; t++)
+		if (memcmp((*t)->addr, addr, sizeof((*t)->addr)) == 0)
+			return *t;
+	return NULL;
+}
+
+static inline void
+diskstats(struct gendisk *disk, struct bio *bio, ulong duration)
+{
+	unsigned long n_sect = bio->bi_size >> 9;
+	const int rw = bio_data_dir(bio);
+
+	disk_stat_inc(disk, ios[rw]);
+	disk_stat_add(disk, ticks[rw], duration);
+	disk_stat_add(disk, sectors[rw], n_sect);
+	disk_stat_add(disk, io_ticks, duration);
+}
+
 void
 aoecmd_ata_rsp(struct sk_buff *skb)
 {
@@ -528,6 +703,8 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 	struct frame *f;
 	struct buf *buf;
 	struct sk_buff *sl;
+	struct aoetgt *t;
+	struct aoeif *ifp;
 	register long n;
 	ulong flags;
 	char ebuf[128];
@@ -547,7 +724,15 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 	spin_lock_irqsave(&d->lock, flags);
 
 	n = be32_to_cpu(get_unaligned(&hin->tag));
-	f = getframe(d, n);
+	t = gettgt(d, hin->src);
+	if (t == NULL) {
+		printk(KERN_INFO "aoe: can't find target e%ld.%d:%012llx\n",
+			d->aoemajor, d->aoeminor,
+			(unsigned long long) mac_addr(hin->src));
+		spin_unlock_irqrestore(&d->lock, flags);
+		return;
+	}
+	f = getframe(t, n);
 	if (f == NULL) {
 		calc_rttavg(d, -tsince(n));
 		spin_unlock_irqrestore(&d->lock, flags);
@@ -569,8 +754,6 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 	ahout = (struct aoe_atahdr *) (hout+1);
 	buf = f->buf;
 
-	if (ahout->cmdstat == WIN_IDENTIFY)
-		d->flags &= ~DEVFL_PAUSE;
 	if (ahin->cmdstat & 0xa9) {	/* these bits cleared on success */
 		printk(KERN_ERR
 			"aoe: ata error cmd=%2.2Xh stat=%2.2Xh from e%ld.%ld\n",
@@ -579,14 +762,16 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 		if (buf)
 			buf->flags |= BUFFL_FAIL;
 	} else {
+		if (d->htgt && t == *d->htgt) /* I'll help myself, thank you. */
+			d->htgt = NULL;
 		n = ahout->scnt << 9;
 		switch (ahout->cmdstat) {
 		case WIN_READ:
 		case WIN_READ_EXT:
 			if (skb->len - sizeof *hin - sizeof *ahin < n) {
 				printk(KERN_ERR
-					"aoe: runt data size in read.  skb->len=%d\n",
-					skb->len);
+					"aoe: %s.  skb->len=%d need=%ld\n",
+					"runt data size in read", skb->len, n);
 				/* fail frame f?  just returning will rexmit. */
 				spin_unlock_irqrestore(&d->lock, flags);
 				return;
@@ -594,32 +779,18 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 			memcpy(f->bufaddr, ahin+1, n);
 		case WIN_WRITE:
 		case WIN_WRITE_EXT:
+			ifp = getif(t, skb->dev);
+			if (ifp) {
+				ifp->lost = 0;
+				if (n > DEFAULTBCNT)
+					ifp->lostjumbo = 0;
+			}
 			if (f->bcnt -= n) {
-				skb = f->skb;
+				f->lba += n >> 9;
 				f->bufaddr += n;
-				put_lba(ahout, f->lba += ahout->scnt);
-				n = f->bcnt;
-				if (n > DEFAULTBCNT)
-					n = DEFAULTBCNT;
-				ahout->scnt = n >> 9;
-				if (ahout->aflags & AOEAFL_WRITE) {
-					skb_fill_page_desc(skb, 0,
-						virt_to_page(f->bufaddr),
-						offset_in_page(f->bufaddr), n);
-					skb->len = sizeof *hout + sizeof *ahout + n;
-					skb->data_len = n;
-				}
-				f->tag = newtag(d);
-				hout->tag = cpu_to_be32(f->tag);
-				skb->dev = d->ifp;
-				skb = skb_clone(skb, GFP_ATOMIC);
-				spin_unlock_irqrestore(&d->lock, flags);
-				if (skb)
-					aoenet_xmit(skb);
-				return;
+				resend(d, t, f);
+				goto xmit;
 			}
-			if (n > DEFAULTBCNT)
-				d->lostjumbo = 0;
 			break;
 		case WIN_IDENTIFY:
 			if (skb->len - sizeof *hin - sizeof *ahin < 512) {
@@ -629,7 +800,7 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 				spin_unlock_irqrestore(&d->lock, flags);
 				return;
 			}
-			ataid_complete(d, (char *) (ahin+1));
+			ataid_complete(d, t, (char *) (ahin+1));
 			break;
 		default:
 			printk(KERN_INFO
@@ -640,28 +811,19 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 		}
 	}
 
-	if (buf) {
-		buf->nframesout -= 1;
-		if (buf->nframesout == 0 && buf->resid == 0) {
-			unsigned long duration = jiffies - buf->start_time;
-			unsigned long n_sect = buf->bio->bi_size >> 9;
-			struct gendisk *disk = d->gd;
-			const int rw = bio_data_dir(buf->bio);
-
-			disk_stat_inc(disk, ios[rw]);
-			disk_stat_add(disk, ticks[rw], duration);
-			disk_stat_add(disk, sectors[rw], n_sect);
-			disk_stat_add(disk, io_ticks, duration);
-			n = (buf->flags & BUFFL_FAIL) ? -EIO : 0;
-			bio_endio(buf->bio, n);
-			mempool_free(buf, d->bufpool);
-		}
+	if (buf && --buf->nframesout == 0 && buf->resid == 0) {
+		diskstats(d->gd, buf->bio, jiffies - buf->stime);
+		n = (buf->flags & BUFFL_FAIL) ? -EIO : 0;
+		bio_endio(buf->bio, n);
+		mempool_free(buf, d->bufpool);
 	}
 
 	f->buf = NULL;
 	f->tag = FREETAG;
+	t->nout--;
 
 	aoecmd_work(d);
+xmit:
 	sl = d->sendq_hd;
 	d->sendq_hd = d->sendq_tl = NULL;
 
@@ -679,23 +841,20 @@ aoecmd_cfg(ushort aoemajor, unsigned cha
 	aoenet_xmit(sl);
 }
  
-/*
- * Since we only call this in one place (and it only prepares one frame)
- * we just return the skb.  Usually we'd chain it up to the aoedev sendq.
- */
-static struct sk_buff *
+struct sk_buff *
 aoecmd_ata_id(struct aoedev *d)
 {
 	struct aoe_hdr *h;
 	struct aoe_atahdr *ah;
 	struct frame *f;
 	struct sk_buff *skb;
+	struct aoetgt *t;
 
 	f = freeframe(d);
-	if (f == NULL) {
-		printk(KERN_ERR "aoe: can't get a frame. This shouldn't happen.\n");
+	if (f == NULL)
 		return NULL;
-	}
+
+	t = *d->tgt;
 
 	/* initialize the headers & frame */
 	skb = f->skb;
@@ -703,7 +862,8 @@ aoecmd_ata_id(struct aoedev *d)
 	ah = (struct aoe_atahdr *) (h+1);
 	skb_put(skb, sizeof *h + sizeof *ah);
 	memset(h, 0, skb->len);
-	f->tag = aoehdr_atainit(d, h);
+	f->tag = aoehdr_atainit(d, t, h);
+	t->nout++;
 	f->waited = 0;
 
 	/* set up ata header */
@@ -711,7 +871,7 @@ aoecmd_ata_id(struct aoedev *d)
 	ah->cmdstat = WIN_IDENTIFY;
 	ah->lba3 = 0xa0;
 
-	skb->dev = d->ifp;
+	skb->dev = t->ifp->nd;
 
 	d->rttavg = MAXTIMER;
 	d->timer.function = rexmit_timer;
@@ -719,12 +879,58 @@ aoecmd_ata_id(struct aoedev *d)
 	return skb_clone(skb, GFP_ATOMIC);
 }
  
+static struct aoetgt *
+addtgt(struct aoedev *d, char *addr, ulong nframes)
+{
+	struct aoetgt *t, **tt, **te;
+	struct frame *f, *e;
+
+	tt = d->targets;
+	te = tt + NTARGETS;
+	for (; tt < te && *tt; tt++)
+		;
+
+	if (tt == te)
+		return NULL;
+
+	t = kcalloc(1, sizeof *t, GFP_ATOMIC);
+	f = kcalloc(nframes, sizeof *f, GFP_ATOMIC);
+	if (!t || !f)
+		goto bail;
+	t->nframes = nframes;
+	t->frames = f;
+	e = f + nframes;
+	for (; f < e; f++) {
+		f->tag = FREETAG;
+		f->skb = new_skb(ETH_ZLEN);
+		if (!f->skb)
+			break;
+	}
+	if (f != e) {
+		while (f > t->frames) {
+			f--;
+			dev_kfree_skb(f->skb);
+		}
+		goto bail;
+	}
+	memcpy(t->addr, addr, sizeof t->addr);
+	t->ifp = t->ifs;
+	t->maxout = t->nframes;
+	return *tt = t;
+bail:
+	kfree(t);
+	kfree(f);
+	return NULL;
+}
+
 void
 aoecmd_cfg_rsp(struct sk_buff *skb)
 {
 	struct aoedev *d;
 	struct aoe_hdr *h;
 	struct aoe_cfghdr *ch;
+	struct aoetgt *t;
+	struct aoeif *ifp;
 	ulong flags, sysminor, aoemajor;
 	struct sk_buff *sl;
 	enum { MAXFRAMES = 16 };
@@ -755,7 +961,7 @@ aoecmd_cfg_rsp(struct sk_buff *skb)
 	if (n > MAXFRAMES)	/* keep it reasonable */
 		n = MAXFRAMES;
 
-	d = aoedev_by_sysminor_m(sysminor, n);
+	d = aoedev_by_sysminor_m(sysminor);
 	if (d == NULL) {
 		printk(KERN_INFO "aoe: device sysminor_m failure\n");
 		return;
@@ -763,38 +969,77 @@ aoecmd_cfg_rsp(struct sk_buff *skb)
 
 	spin_lock_irqsave(&d->lock, flags);
 
-	/* permit device to migrate mac and network interface */
-	d->ifp = skb->dev;
-	memcpy(d->addr, h->src, sizeof d->addr);
-	if (!(d->flags & DEVFL_MAXBCNT)) {
-		n = d->ifp->mtu;
+	t = gettgt(d, h->src);
+	if (!t) {
+		t = addtgt(d, h->src, n);
+		if (!t) {
+			printk(KERN_INFO
+				"aoe: device addtgt failure; "
+				"too many targets?\n");
+			spin_unlock_irqrestore(&d->lock, flags);
+			return;
+		}
+	}
+	ifp = getif(t, skb->dev);
+	if (!ifp) {
+		ifp = addif(t, skb->dev);
+		if (!ifp) {
+			printk(KERN_INFO
+				"aoe: device addif failure; "
+				"too many interfaces?\n");
+			spin_unlock_irqrestore(&d->lock, flags);
+			return;
+		}
+	}
+	if (ifp->maxbcnt) {
+		n = ifp->nd->mtu;
 		n -= sizeof (struct aoe_hdr) + sizeof (struct aoe_atahdr);
 		n /= 512;
 		if (n > ch->scnt)
 			n = ch->scnt;
 		n = n ? n * 512 : DEFAULTBCNT;
-		if (n != d->maxbcnt) {
+		if (n != ifp->maxbcnt) {
 			printk(KERN_INFO
-				"aoe: e%ld.%ld: setting %d byte data frames on %s\n",
-				d->aoemajor, d->aoeminor, n, d->ifp->name);
-			d->maxbcnt = n;
+				"aoe: e%ld.%d: setting %d%s%s:%012llx\n",
+				d->aoemajor, d->aoeminor, n,
+				" byte data frames on ", ifp->nd->name,
+				(unsigned long long) mac_addr(t->addr));
+			ifp->maxbcnt = n;
 		}
 	}
 
 	/* don't change users' perspective */
-	if (d->nopen && !(d->flags & DEVFL_PAUSE)) {
+	if (d->nopen) {
 		spin_unlock_irqrestore(&d->lock, flags);
 		return;
 	}
-	d->flags |= DEVFL_PAUSE;	/* force pause */
-	d->mintimer = MINTIMER;
 	d->fw_ver = be16_to_cpu(ch->fwver);
 
-	/* check for already outstanding ataid */
-	sl = aoedev_isbusy(d) == 0 ? aoecmd_ata_id(d) : NULL;
+	sl = aoecmd_ata_id(d);
 
 	spin_unlock_irqrestore(&d->lock, flags);
 
 	aoenet_xmit(sl);
 }
 
+void
+aoecmd_cleanslate(struct aoedev *d)
+{
+	struct aoetgt **t, **te;
+	struct aoeif *p, *e;
+
+	d->mintimer = MINTIMER;
+
+	t = d->targets;
+	te = t + NTARGETS;
+	for (; t < te && *t; t++) {
+		(*t)->maxout = (*t)->nframes;
+		p = (*t)->ifs;
+		e = p + NAOEIFS;
+		for (; p < e; p++) {
+			p->lostjumbo = 0;
+			p->lost = 0;
+			p->maxbcnt = DEFAULTBCNT;
+		}
+	}
+}
diff -puN drivers/block/aoe/aoedev.c~aoe-handle-multiple-network-paths-to-aoe-device drivers/block/aoe/aoedev.c
--- a/drivers/block/aoe/aoedev.c~aoe-handle-multiple-network-paths-to-aoe-device
+++ a/drivers/block/aoe/aoedev.c
@@ -15,15 +15,18 @@ static spinlock_t devlist_lock;
 int
 aoedev_isbusy(struct aoedev *d)
 {
+	struct aoetgt **t, **te;
 	struct frame *f, *e;
 
-	f = d->frames;
-	e = f + d->nframes;
-	do {
-		if (f->tag != FREETAG)
-			return 1;
-	} while (++f < e);
-
+	t = d->targets;
+	te = t + NTARGETS;
+	for (; t < te && *t; t++) {
+		f = (*t)->frames;
+		e = f + (*t)->nframes;
+		for (; f < e; f++)
+			if (f->tag != FREETAG)
+				return 1;
+	}
 	return 0;
 }
 
@@ -55,75 +58,41 @@ dummy_timer(ulong vp)
 	add_timer(&d->timer);
 }
 
-/* called with devlist lock held */
-static struct aoedev *
-aoedev_newdev(ulong nframes)
-{
-	struct aoedev *d;
-	struct frame *f, *e;
-
-	d = kzalloc(sizeof *d, GFP_ATOMIC);
-	f = kcalloc(nframes, sizeof *f, GFP_ATOMIC);
- 	switch (!d || !f) {
- 	case 0:
- 		d->nframes = nframes;
- 		d->frames = f;
- 		e = f + nframes;
- 		for (; f<e; f++) {
- 			f->tag = FREETAG;
- 			f->skb = new_skb(ETH_ZLEN);
- 			if (!f->skb)
- 				break;
- 		}
- 		if (f == e)
- 			break;
- 		while (f > d->frames) {
- 			f--;
- 			dev_kfree_skb(f->skb);
- 		}
- 	default:
- 		if (f)
- 			kfree(f);
- 		if (d)
- 			kfree(d);
-		return NULL;
-	}
-	INIT_WORK(&d->work, aoecmd_sleepwork);
-	spin_lock_init(&d->lock);
-	init_timer(&d->timer);
-	d->timer.data = (ulong) d;
-	d->timer.function = dummy_timer;
-	d->timer.expires = jiffies + HZ;
-	add_timer(&d->timer);
-	d->bufpool = NULL;	/* defer to aoeblk_gdalloc */
-	INIT_LIST_HEAD(&d->bufq);
-	d->next = devlist;
-	devlist = d;
-
-	return d;
-}
-
 void
 aoedev_downdev(struct aoedev *d)
 {
+	struct aoetgt **t, **te;
 	struct frame *f, *e;
 	struct buf *buf;
 	struct bio *bio;
 
-	f = d->frames;
-	e = f + d->nframes;
-	for (; f<e; f->tag = FREETAG, f->buf = NULL, f++) {
-		if (f->tag == FREETAG || f->buf == NULL)
-			continue;
-		buf = f->buf;
-		bio = buf->bio;
-		if (--buf->nframesout == 0) {
-			mempool_free(buf, d->bufpool);
-			bio_endio(bio, -EIO);
+	t = d->targets;
+	te = t + NTARGETS;
+	for (; t < te && *t; t++) {
+		f = (*t)->frames;
+		e = f + (*t)->nframes;
+		for (; f < e; f->tag = FREETAG, f->buf = NULL, f++) {
+			if (f->tag == FREETAG || f->buf == NULL)
+				continue;
+			buf = f->buf;
+			bio = buf->bio;
+			if (--buf->nframesout == 0
+			&& buf != d->inprocess) {
+				mempool_free(buf, d->bufpool);
+				bio_endio(bio, -EIO);
+			}
 		}
-		skb_shinfo(f->skb)->nr_frags = f->skb->data_len = 0;
+		(*t)->maxout = (*t)->nframes;
+		(*t)->nout = 0;
+	}
+	buf = d->inprocess;
+	if (buf) {
+		bio = buf->bio;
+		mempool_free(buf, d->bufpool);
+		bio_endio(bio, -EIO);
 	}
 	d->inprocess = NULL;
+	d->htgt = NULL;
 
 	while (!list_empty(&d->bufq)) {
 		buf = container_of(d->bufq.next, struct buf, bufs);
@@ -136,12 +105,12 @@ aoedev_downdev(struct aoedev *d)
 	if (d->gd)
 		d->gd->capacity = 0;
 
-	d->flags &= ~(DEVFL_UP | DEVFL_PAUSE);
+	d->flags &= ~DEVFL_UP;
 }
 
 /* find it or malloc it */
 struct aoedev *
-aoedev_by_sysminor_m(ulong sysminor, ulong bufcnt)
+aoedev_by_sysminor_m(ulong sysminor)
 {
 	struct aoedev *d;
 	ulong flags;
@@ -151,40 +120,61 @@ aoedev_by_sysminor_m(ulong sysminor, ulo
 	for (d=devlist; d; d=d->next)
 		if (d->sysminor == sysminor)
 			break;
-
-	if (d == NULL) {
-		d = aoedev_newdev(bufcnt);
-	 	if (d == NULL) {
-			spin_unlock_irqrestore(&devlist_lock, flags);
-			printk(KERN_INFO "aoe: aoedev_newdev failure.\n");
-			return NULL;
-		}
-		d->sysminor = sysminor;
-		d->aoemajor = AOEMAJOR(sysminor);
-		d->aoeminor = AOEMINOR(sysminor);
-	}
-
+	if (d)
+		goto out;
+	d = kcalloc(1, sizeof *d, GFP_ATOMIC);
+	if (!d)
+		goto out;
+	INIT_WORK(&d->work, aoecmd_sleepwork);
+	spin_lock_init(&d->lock);
+	init_timer(&d->timer);
+	d->timer.data = (ulong) d;
+	d->timer.function = dummy_timer;
+	d->timer.expires = jiffies + HZ;
+	add_timer(&d->timer);
+	d->bufpool = NULL;	/* defer to aoeblk_gdalloc */
+	d->tgt = d->targets;
+	INIT_LIST_HEAD(&d->bufq);
+	d->sysminor = sysminor;
+	d->aoemajor = AOEMAJOR(sysminor);
+	d->aoeminor = AOEMINOR(sysminor);
+	d->mintimer = MINTIMER;
+	d->next = devlist;
+	devlist = d;
+ out:
 	spin_unlock_irqrestore(&devlist_lock, flags);
 	return d;
 }
 
 static void
-aoedev_freedev(struct aoedev *d)
+freetgt(struct aoetgt *t)
 {
 	struct frame *f, *e;
 
+	f = t->frames;
+	e = f + t->nframes;
+	for (; f < e; f++) {
+		skb_shinfo(f->skb)->nr_frags = 0;
+		dev_kfree_skb(f->skb);
+	}
+	kfree(t->frames);
+	kfree(t);
+}
+
+static void
+aoedev_freedev(struct aoedev *d)
+{
+	struct aoetgt **t, **e;
+
 	if (d->gd) {
 		aoedisk_rm_sysfs(d);
 		del_gendisk(d->gd);
 		put_disk(d->gd);
 	}
-	f = d->frames;
-	e = f + d->nframes;
-	for (; f<e; f++) {
-		skb_shinfo(f->skb)->nr_frags = 0;
-		dev_kfree_skb(f->skb);
-	}
-	kfree(d->frames);
+	t = d->targets;
+	e = t + NTARGETS;
+	for (; t < e && *t; t++)
+		freetgt(*t);
 	if (d->bufpool)
 		mempool_destroy(d->bufpool);
 	kfree(d);
diff -puN drivers/block/aoe/aoenet.c~aoe-handle-multiple-network-paths-to-aoe-device drivers/block/aoe/aoenet.c
--- a/drivers/block/aoe/aoenet.c~aoe-handle-multiple-network-paths-to-aoe-device
+++ a/drivers/block/aoe/aoenet.c
@@ -137,9 +137,12 @@ aoenet_rcv(struct sk_buff *skb, struct n
 		if (n > NECODES)
 			n = 0;
 		if (net_ratelimit())
-			printk(KERN_ERR "aoe: error packet from %d.%d; ecode=%d '%s'\n",
-			       be16_to_cpu(get_unaligned(&h->major)), h->minor,
-			       h->err, aoe_errlist[n]);
+			printk(KERN_ERR
+				"%s%d.%d@%s; ecode=%d '%s'\n",
+				"aoe: error packet from ",
+				be16_to_cpu(get_unaligned(&h->major)),
+				h->minor, skb->dev->name,
+				h->err, aoe_errlist[n]);
 		goto exit;
 	}
 
_

Patches currently in -mm which might be from ecashin@coraid.com are

aoe-bring-driver-version-number-to-47.patch
aoe-handle-multiple-network-paths-to-aoe-device.patch
aoe-mac_addr-avoid-64-bit-arch-compiler-warnings.patch
aoe-clean-up-udev-configuration-example.patch
aoe-eliminate-goto-and-improve-readability.patch
aoe-user-can-ask-driver-to-forget-previously-detected-devices.patch
aoe-dynamically-allocate-a-capped-number-of-skbs-when-necessary.patch
aoe-only-install-new-aoe-device-once.patch
aoe-add-module-parameter-for-users-who-need-more-outstanding-i-o.patch
aoe-the-aoeminor-doesnt-need-a-long-format.patch
aoe-make-error-messages-more-specific.patch
aoe-update-copyright-date.patch
aoe-statically-initialise-devlist_lock.patch
