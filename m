From: akpm@linux-foundation.org
Subject: [merged] aoe-become-i-o-request-queue-handler-for-increased-user-control.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:21:07 -0700
Message-ID: <20121005202108.10DC55C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:43499 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab2JEUVK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:21:10 -0400
Received: by mail-ea0-f202.google.com with SMTP id q10so3351eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:21:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aoe: become I/O request queue handler for increased user control
has been removed from the -mm tree.  Its filename was
     aoe-become-i-o-request-queue-handler-for-increased-user-control.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: become I/O request queue handler for increased user control

To allow users to choose an elevator algorithm for their particular
workloads, change from a make_request-style driver to an
I/O-request-queue-handler-style driver.

We have to do a couple of things that might be surprising.  We manipulate
the page _count directly on the assumption that we still have no guarantee
that users of the block layer are prohibited from submitting bios
containing pages with zero reference counts.[1] If such a prohibition now
exists, I can get rid of the _count manipulation.

Just as before this patch, we still keep track of the sk_buffs that the
network layer still hasn't finished yet and cap the resources we use with
a "pool" of skbs.[2]

Now that the block layer maintains the disk stats, the aoe driver's
diskstats function can go away.

1. https://lkml.org/lkml/2007/3/1/374
2. https://lkml.org/lkml/2007/7/6/241

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoe.h    |   26 +--
 drivers/block/aoe/aoeblk.c |   88 +++-------
 drivers/block/aoe/aoechr.c |    1 
 drivers/block/aoe/aoecmd.c |  282 +++++++++++++++++++++++++----------
 drivers/block/aoe/aoedev.c |   93 +++++++----
 5 files changed, 308 insertions(+), 182 deletions(-)

diff -puN drivers/block/aoe/aoe.h~aoe-become-i-o-request-queue-handler-for-increased-user-control drivers/block/aoe/aoe.h
--- a/drivers/block/aoe/aoe.h~aoe-become-i-o-request-queue-handler-for-increased-user-control
+++ a/drivers/block/aoe/aoe.h
@@ -90,7 +90,7 @@ enum {
 	MIN_BUFS = 16,
 	NTARGETS = 8,
 	NAOEIFS = 8,
-	NSKBPOOLMAX = 128,
+	NSKBPOOLMAX = 256,
 	NFACTIVE = 17,
 
 	TIMERTICK = HZ / 10,
@@ -100,30 +100,26 @@ enum {
 };
 
 struct buf {
-	struct list_head bufs;
-	ulong stime;	/* for disk stats */
-	ulong flags;
 	ulong nframesout;
 	ulong resid;
 	ulong bv_resid;
-	ulong bv_off;
 	sector_t sector;
 	struct bio *bio;
 	struct bio_vec *bv;
+	struct request *rq;
 };
 
 struct frame {
 	struct list_head head;
 	u32 tag;
 	ulong waited;
-	struct buf *buf;
 	struct aoetgt *t;		/* parent target I belong to */
-	char *bufaddr;
-	ulong bcnt;
 	sector_t lba;
 	struct sk_buff *skb;		/* command skb freed on module exit */
 	struct sk_buff *r_skb;		/* response skb for async processing */
+	struct buf *buf;
 	struct bio_vec *bv;
+	ulong bcnt;
 	ulong bv_off;
 };
 
@@ -161,6 +157,7 @@ struct aoedev {
 	u16 rttavg;		/* round trip average of requests/responses */
 	u16 mintimer;
 	u16 fw_ver;		/* version of blade's firmware */
+	ulong ref;
 	struct work_struct work;/* disk create work struct */
 	struct gendisk *gd;
 	struct request_queue *blkq;
@@ -168,11 +165,13 @@ struct aoedev {
 	sector_t ssize;
 	struct timer_list timer;
 	spinlock_t lock;
-	struct sk_buff_head sendq;
 	struct sk_buff_head skbpool;
 	mempool_t *bufpool;	/* for deadlock-free Buf allocation */
-	struct list_head bufq;	/* queue of bios to work on */
-	struct buf *inprocess;	/* the one we're currently working on */
+	struct {		/* pointers to work in progress */
+		struct buf *buf;
+		struct bio *nxbio;
+		struct request *rq;
+	} ip;
 	struct aoetgt *targets[NTARGETS];
 	struct aoetgt **tgt;	/* target in use when working */
 	struct aoetgt *htgt;	/* target needing rexmit assistance */
@@ -209,6 +208,8 @@ void aoecmd_exit(void);
 int aoecmd_init(void);
 struct sk_buff *aoecmd_ata_id(struct aoedev *);
 void aoe_freetframe(struct frame *);
+void aoe_flush_iocq(void);
+void aoe_end_request(struct aoedev *, struct request *, int);
 
 int aoedev_init(void);
 void aoedev_exit(void);
@@ -216,7 +217,8 @@ struct aoedev *aoedev_by_aoeaddr(int maj
 struct aoedev *aoedev_by_sysminor_m(ulong sysminor);
 void aoedev_downdev(struct aoedev *d);
 int aoedev_flush(const char __user *str, size_t size);
-void aoe_failbuf(struct aoedev *d, struct buf *buf);
+void aoe_failbuf(struct aoedev *, struct buf *);
+void aoedev_put(struct aoedev *);
 
 int aoenet_init(void);
 void aoenet_exit(void);
diff -puN drivers/block/aoe/aoeblk.c~aoe-become-i-o-request-queue-handler-for-increased-user-control drivers/block/aoe/aoeblk.c
--- a/drivers/block/aoe/aoeblk.c~aoe-become-i-o-request-queue-handler-for-increased-user-control
+++ a/drivers/block/aoe/aoeblk.c
@@ -161,68 +161,22 @@ aoeblk_release(struct gendisk *disk, fmo
 }
 
 static void
-aoeblk_make_request(struct request_queue *q, struct bio *bio)
+aoeblk_request(struct request_queue *q)
 {
-	struct sk_buff_head queue;
 	struct aoedev *d;
-	struct buf *buf;
-	ulong flags;
-
-	blk_queue_bounce(q, &bio);
-
-	if (bio == NULL) {
-		printk(KERN_ERR "aoe: bio is NULL\n");
-		BUG();
-		return;
-	}
-	d = bio->bi_bdev->bd_disk->private_data;
-	if (d == NULL) {
-		printk(KERN_ERR "aoe: bd_disk->private_data is NULL\n");
-		BUG();
-		bio_endio(bio, -ENXIO);
-		return;
-	} else if (bio->bi_io_vec == NULL) {
-		printk(KERN_ERR "aoe: bi_io_vec is NULL\n");
-		BUG();
-		bio_endio(bio, -ENXIO);
-		return;
-	}
-	buf = mempool_alloc(d->bufpool, GFP_NOIO);
-	if (buf == NULL) {
-		printk(KERN_INFO "aoe: buf allocation failure\n");
-		bio_endio(bio, -ENOMEM);
-		return;
-	}
-	memset(buf, 0, sizeof(*buf));
-	INIT_LIST_HEAD(&buf->bufs);
-	buf->stime = jiffies;
-	buf->bio = bio;
-	buf->resid = bio->bi_size;
-	buf->sector = bio->bi_sector;
-	buf->bv = &bio->bi_io_vec[bio->bi_idx];
-	buf->bv_resid = buf->bv->bv_len;
-	WARN_ON(buf->bv_resid == 0);
-	buf->bv_off = buf->bv->bv_offset;
-
-	spin_lock_irqsave(&d->lock, flags);
+	struct request *rq;
 
+	d = q->queuedata;
 	if ((d->flags & DEVFL_UP) == 0) {
 		pr_info_ratelimited("aoe: device %ld.%d is not up\n",
 			d->aoemajor, d->aoeminor);
-		spin_unlock_irqrestore(&d->lock, flags);
-		mempool_free(buf, d->bufpool);
-		bio_endio(bio, -ENXIO);
+		while ((rq = blk_peek_request(q))) {
+			blk_start_request(rq);
+			aoe_end_request(d, rq, 1);
+		}
 		return;
 	}
-
-	list_add_tail(&buf->bufs, &d->bufq);
-
 	aoecmd_work(d);
-	__skb_queue_head_init(&queue);
-	skb_queue_splice_init(&d->sendq, &queue);
-
-	spin_unlock_irqrestore(&d->lock, flags);
-	aoenet_xmit(&queue);
 }
 
 static int
@@ -254,34 +208,46 @@ aoeblk_gdalloc(void *vp)
 {
 	struct aoedev *d = vp;
 	struct gendisk *gd;
-	enum { KB = 1024, MB = KB * KB, READ_AHEAD = MB, };
+	mempool_t *mp;
+	struct request_queue *q;
+	enum { KB = 1024, MB = KB * KB, READ_AHEAD = 2 * MB, };
 	ulong flags;
 
 	gd = alloc_disk(AOE_PARTITIONS);
 	if (gd == NULL) {
-		printk(KERN_ERR
-			"aoe: cannot allocate disk structure for %ld.%d\n",
+		pr_err("aoe: cannot allocate disk structure for %ld.%d\n",
 			d->aoemajor, d->aoeminor);
 		goto err;
 	}
 
-	d->bufpool = mempool_create_slab_pool(MIN_BUFS, buf_pool_cache);
-	if (d->bufpool == NULL) {
+	mp = mempool_create(MIN_BUFS, mempool_alloc_slab, mempool_free_slab,
+		buf_pool_cache);
+	if (mp == NULL) {
 		printk(KERN_ERR "aoe: cannot allocate bufpool for %ld.%d\n",
 			d->aoemajor, d->aoeminor);
 		goto err_disk;
 	}
+	q = blk_init_queue(aoeblk_request, &d->lock);
+	if (q == NULL) {
+		pr_err("aoe: cannot allocate block queue for %ld.%d\n",
+			d->aoemajor, d->aoeminor);
+		mempool_destroy(mp);
+		goto err_disk;
+	}
 
 	d->blkq = blk_alloc_queue(GFP_KERNEL);
 	if (!d->blkq)
 		goto err_mempool;
-	blk_queue_make_request(d->blkq, aoeblk_make_request);
 	d->blkq->backing_dev_info.name = "aoe";
 	if (bdi_init(&d->blkq->backing_dev_info))
 		goto err_blkq;
 	spin_lock_irqsave(&d->lock, flags);
 	blk_queue_max_hw_sectors(d->blkq, BLK_DEF_MAX_SECTORS);
-	d->blkq->backing_dev_info.ra_pages = READ_AHEAD / PAGE_CACHE_SIZE;
+	q->backing_dev_info.ra_pages = READ_AHEAD / PAGE_CACHE_SIZE;
+	d->bufpool = mp;
+	d->blkq = gd->queue = q;
+	q->queuedata = d;
+	d->gd = gd;
 	gd->major = AOE_MAJOR;
 	gd->first_minor = d->sysminor * AOE_PARTITIONS;
 	gd->fops = &aoe_bdops;
@@ -290,8 +256,6 @@ aoeblk_gdalloc(void *vp)
 	snprintf(gd->disk_name, sizeof gd->disk_name, "etherd/e%ld.%d",
 		d->aoemajor, d->aoeminor);
 
-	gd->queue = d->blkq;
-	d->gd = gd;
 	d->flags &= ~DEVFL_GDALLOC;
 	d->flags |= DEVFL_UP;
 
diff -puN drivers/block/aoe/aoechr.c~aoe-become-i-o-request-queue-handler-for-increased-user-control drivers/block/aoe/aoechr.c
--- a/drivers/block/aoe/aoechr.c~aoe-become-i-o-request-queue-handler-for-increased-user-control
+++ a/drivers/block/aoe/aoechr.c
@@ -106,6 +106,7 @@ loop:
 		spin_lock_irqsave(&d->lock, flags);
 		goto loop;
 	}
+	aoedev_put(d);
 	if (skb) {
 		struct sk_buff_head queue;
 		__skb_queue_head_init(&queue);
diff -puN drivers/block/aoe/aoecmd.c~aoe-become-i-o-request-queue-handler-for-increased-user-control drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~aoe-become-i-o-request-queue-handler-for-increased-user-control
+++ a/drivers/block/aoe/aoecmd.c
@@ -23,6 +23,8 @@
 
 static void ktcomplete(struct frame *, struct sk_buff *);
 
+static struct buf *nextbuf(struct aoedev *);
+
 static int aoe_deadsecs = 60 * 3;
 module_param(aoe_deadsecs, int, 0644);
 MODULE_PARM_DESC(aoe_deadsecs, "After aoe_deadsecs seconds, give up and fail dev.");
@@ -283,17 +285,20 @@ aoecmd_ata_rw(struct aoedev *d)
 	struct bio_vec *bv;
 	struct aoetgt *t;
 	struct sk_buff *skb;
+	struct sk_buff_head queue;
 	ulong bcnt, fbcnt;
 	char writebit, extbit;
 
 	writebit = 0x10;
 	extbit = 0x4;
 
+	buf = nextbuf(d);
+	if (buf == NULL)
+		return 0;
 	f = newframe(d);
 	if (f == NULL)
 		return 0;
 	t = *d->tgt;
-	buf = d->inprocess;
 	bv = buf->bv;
 	bcnt = t->ifp->maxbcnt;
 	if (bcnt == 0)
@@ -312,7 +317,7 @@ aoecmd_ata_rw(struct aoedev *d)
 		fbcnt -= buf->bv_resid;
 		buf->resid -= buf->bv_resid;
 		if (buf->resid == 0) {
-			d->inprocess = NULL;
+			d->ip.buf = NULL;
 			break;
 		}
 		buf->bv++;
@@ -364,8 +369,11 @@ aoecmd_ata_rw(struct aoedev *d)
 
 	skb->dev = t->ifp->nd;
 	skb = skb_clone(skb, GFP_ATOMIC);
-	if (skb)
-		__skb_queue_tail(&d->sendq, skb);
+	if (skb) {
+		__skb_queue_head_init(&queue);
+		__skb_queue_tail(&queue, skb);
+		aoenet_xmit(&queue);
+	}
 	return 1;
 }
 
@@ -415,6 +423,7 @@ static void
 resend(struct aoedev *d, struct frame *f)
 {
 	struct sk_buff *skb;
+	struct sk_buff_head queue;
 	struct aoe_hdr *h;
 	struct aoe_atahdr *ah;
 	struct aoetgt *t;
@@ -444,7 +453,9 @@ resend(struct aoedev *d, struct frame *f
 	skb = skb_clone(skb, GFP_ATOMIC);
 	if (skb == NULL)
 		return;
-	__skb_queue_tail(&d->sendq, skb);
+	__skb_queue_head_init(&queue);
+	__skb_queue_tail(&queue, skb);
+	aoenet_xmit(&queue);
 }
 
 static int
@@ -554,7 +565,6 @@ ata_scnt(unsigned char *packet) {
 static void
 rexmit_timer(ulong vp)
 {
-	struct sk_buff_head queue;
 	struct aoedev *d;
 	struct aoetgt *t, **tt, **te;
 	struct aoeif *ifp;
@@ -603,6 +613,12 @@ rexmit_timer(ulong vp)
 		}
 	}
 
+	if (!list_empty(&flist)) {	/* retransmissions necessary */
+		n = d->rttavg <<= 1;
+		if (n > MAXTIMER)
+			d->rttavg = MAXTIMER;
+	}
+
 	/* process expired frames */
 	while (!list_empty(&flist)) {
 		pos = flist.next;
@@ -641,45 +657,131 @@ rexmit_timer(ulong vp)
 		resend(d, f);
 	}
 
-	if (!skb_queue_empty(&d->sendq)) {
-		n = d->rttavg <<= 1;
-		if (n > MAXTIMER)
-			d->rttavg = MAXTIMER;
-	}
-
-	if (d->flags & DEVFL_KICKME || d->htgt) {
+	if ((d->flags & DEVFL_KICKME || d->htgt) && d->blkq) {
 		d->flags &= ~DEVFL_KICKME;
-		aoecmd_work(d);
+		d->blkq->request_fn(d->blkq);
 	}
 
-	__skb_queue_head_init(&queue);
-	skb_queue_splice_init(&d->sendq, &queue);
-
 	d->timer.expires = jiffies + TIMERTICK;
 	add_timer(&d->timer);
 
 	spin_unlock_irqrestore(&d->lock, flags);
+}
 
-	aoenet_xmit(&queue);
+static unsigned long
+rqbiocnt(struct request *r)
+{
+	struct bio *bio;
+	unsigned long n = 0;
+
+	__rq_for_each_bio(bio, r)
+		n++;
+	return n;
+}
+
+/* This can be removed if we are certain that no users of the block
+ * layer will ever use zero-count pages in bios.  Otherwise we have to
+ * protect against the put_page sometimes done by the network layer.
+ *
+ * See http://oss.sgi.com/archives/xfs/2007-01/msg00594.html for
+ * discussion.
+ *
+ * We cannot use get_page in the workaround, because it insists on a
+ * positive page count as a precondition.  So we use _count directly.
+ */
+static void
+bio_pageinc(struct bio *bio)
+{
+	struct bio_vec *bv;
+	struct page *page;
+	int i;
+
+	bio_for_each_segment(bv, bio, i) {
+		page = bv->bv_page;
+		/* Non-zero page count for non-head members of
+		 * compound pages is no longer allowed by the kernel,
+		 * but this has never been seen here.
+		 */
+		if (unlikely(PageCompound(page)))
+			if (compound_trans_head(page) != page) {
+				pr_crit("page tail used for block I/O\n");
+				BUG();
+			}
+		atomic_inc(&page->_count);
+	}
+}
+
+static void
+bio_pagedec(struct bio *bio)
+{
+	struct bio_vec *bv;
+	int i;
+
+	bio_for_each_segment(bv, bio, i)
+		atomic_dec(&bv->bv_page->_count);
+}
+
+static void
+bufinit(struct buf *buf, struct request *rq, struct bio *bio)
+{
+	struct bio_vec *bv;
+
+	memset(buf, 0, sizeof(*buf));
+	buf->rq = rq;
+	buf->bio = bio;
+	buf->resid = bio->bi_size;
+	buf->sector = bio->bi_sector;
+	bio_pageinc(bio);
+	buf->bv = bv = &bio->bi_io_vec[bio->bi_idx];
+	buf->bv_resid = bv->bv_len;
+	WARN_ON(buf->bv_resid == 0);
+}
+
+static struct buf *
+nextbuf(struct aoedev *d)
+{
+	struct request *rq;
+	struct request_queue *q;
+	struct buf *buf;
+	struct bio *bio;
+
+	q = d->blkq;
+	if (q == NULL)
+		return NULL;	/* initializing */
+	if (d->ip.buf)
+		return d->ip.buf;
+	rq = d->ip.rq;
+	if (rq == NULL) {
+		rq = blk_peek_request(q);
+		if (rq == NULL)
+			return NULL;
+		blk_start_request(rq);
+		d->ip.rq = rq;
+		d->ip.nxbio = rq->bio;
+		rq->special = (void *) rqbiocnt(rq);
+	}
+	buf = mempool_alloc(d->bufpool, GFP_ATOMIC);
+	if (buf == NULL) {
+		pr_err("aoe: nextbuf: unable to mempool_alloc!\n");
+		return NULL;
+	}
+	bio = d->ip.nxbio;
+	bufinit(buf, rq, bio);
+	bio = bio->bi_next;
+	d->ip.nxbio = bio;
+	if (bio == NULL)
+		d->ip.rq = NULL;
+	return d->ip.buf = buf;
 }
 
 /* enters with d->lock held */
 void
 aoecmd_work(struct aoedev *d)
 {
-	struct buf *buf;
-loop:
 	if (d->htgt && !sthtith(d))
 		return;
-	if (d->inprocess == NULL) {
-		if (list_empty(&d->bufq))
-			return;
-		buf = container_of(d->bufq.next, struct buf, bufs);
-		list_del(d->bufq.next);
-		d->inprocess = buf;
-	}
-	if (aoecmd_ata_rw(d))
-		goto loop;
+	while (aoecmd_ata_rw(d))
+		;
 }
 
 /* this function performs work that has been deferred until sleeping is OK
@@ -802,25 +904,6 @@ gettgt(struct aoedev *d, char *addr)
 	return NULL;
 }
 
-static inline void
-diskstats(struct gendisk *disk, struct bio *bio, ulong duration, sector_t sector)
-{
-	unsigned long n_sect = bio->bi_size >> 9;
-	const int rw = bio_data_dir(bio);
-	struct hd_struct *part;
-	int cpu;
-
-	cpu = part_stat_lock();
-	part = disk_map_sector_rcu(disk, sector);
-
-	part_stat_inc(cpu, part, ios[rw]);
-	part_stat_add(cpu, part, ticks[rw], duration);
-	part_stat_add(cpu, part, sectors[rw], n_sect);
-	part_stat_add(cpu, part, io_ticks, duration);
-
-	part_stat_unlock();
-}
-
 static void
 bvcpy(struct bio_vec *bv, ulong off, struct sk_buff *skb, long cnt)
 {
@@ -842,6 +925,43 @@ loop:
 	goto loop;
 }
 
+void
+aoe_end_request(struct aoedev *d, struct request *rq, int fastfail)
+{
+	struct bio *bio;
+	int bok;
+	struct request_queue *q;
+
+	q = d->blkq;
+	if (rq == d->ip.rq)
+		d->ip.rq = NULL;
+	do {
+		bio = rq->bio;
+		bok = !fastfail && test_bit(BIO_UPTODATE, &bio->bi_flags);
+	} while (__blk_end_request(rq, bok ? 0 : -EIO, bio->bi_size));
+
+	/* cf. http://lkml.org/lkml/2006/10/31/28 */
+	if (!fastfail)
+		q->request_fn(q);
+}
+
+static void
+aoe_end_buf(struct aoedev *d, struct buf *buf)
+{
+	struct request *rq;
+	unsigned long n;
+
+	if (buf == d->ip.buf)
+		d->ip.buf = NULL;
+	rq = buf->rq;
+	bio_pagedec(buf->bio);
+	mempool_free(buf, d->bufpool);
+	n = (unsigned long) rq->special;
+	rq->special = (void *) --n;
+	if (n == 0)
+		aoe_end_request(d, rq, 0);
+}
+
 static void
 ktiocomplete(struct frame *f)
 {
@@ -876,7 +996,7 @@ ktiocomplete(struct frame *f)
 			ahout->cmdstat, ahin->cmdstat,
 			d->aoemajor, d->aoeminor);
 noskb:	if (buf)
-			buf->flags |= BUFFL_FAIL;
+			clear_bit(BIO_UPTODATE, &buf->bio->bi_flags);
 		goto badrsp;
 	}
 
@@ -887,7 +1007,7 @@ noskb:	if (buf)
 		if (skb->len < n) {
 			pr_err("aoe: runt data size in read.  skb->len=%d need=%ld\n",
 				skb->len, n);
-			buf->flags |= BUFFL_FAIL;
+			clear_bit(BIO_UPTODATE, &buf->bio->bi_flags);
 			break;
 		}
 		bvcpy(f->bv, f->bv_off, skb, n);
@@ -927,18 +1047,13 @@ badrsp:
 
 	aoe_freetframe(f);
 
-	if (buf && --buf->nframesout == 0 && buf->resid == 0) {
-		struct bio *bio = buf->bio;
+	if (buf && --buf->nframesout == 0 && buf->resid == 0)
+		aoe_end_buf(d, buf);
 
-		diskstats(d->gd, bio, jiffies - buf->stime, buf->sector);
-		n = (buf->flags & BUFFL_FAIL) ? -EIO : 0;
-		mempool_free(buf, d->bufpool);
-		spin_unlock_irq(&d->lock);
-		if (n != -EIO)
-			bio_flush_dcache_pages(buf->bio);
-		bio_endio(bio, n);
-	} else
-		spin_unlock_irq(&d->lock);
+	aoecmd_work(d);
+
+	spin_unlock_irq(&d->lock);
+	aoedev_put(d);
 	dev_kfree_skb(skb);
 }
 
@@ -1061,12 +1176,14 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 		printk(KERN_INFO "aoe: can't find target e%ld.%d:%pm\n",
 		       d->aoemajor, d->aoeminor, h->src);
 		spin_unlock_irqrestore(&d->lock, flags);
+		aoedev_put(d);
 		return skb;
 	}
 	f = getframe(t, n);
 	if (f == NULL) {
 		calc_rttavg(d, -tsince(n));
 		spin_unlock_irqrestore(&d->lock, flags);
+		aoedev_put(d);
 		snprintf(ebuf, sizeof ebuf,
 			"%15s e%d.%d    tag=%08x@%08lx\n",
 			"unexpected rsp",
@@ -1185,8 +1302,10 @@ aoecmd_cfg_rsp(struct sk_buff *skb)
 	struct aoeif *ifp;
 	ulong flags, sysminor, aoemajor;
 	struct sk_buff *sl;
+	struct sk_buff_head queue;
 	u16 n;
 
+	sl = NULL;
 	h = (struct aoe_hdr *) skb_mac_header(skb);
 	ch = (struct aoe_cfghdr *) (h+1);
 
@@ -1223,10 +1342,8 @@ aoecmd_cfg_rsp(struct sk_buff *skb)
 	t = gettgt(d, h->src);
 	if (!t) {
 		t = addtgt(d, h->src, n);
-		if (!t) {
-			spin_unlock_irqrestore(&d->lock, flags);
-			return;
-		}
+		if (!t)
+			goto bail;
 	}
 	ifp = getif(t, skb->dev);
 	if (!ifp) {
@@ -1235,8 +1352,7 @@ aoecmd_cfg_rsp(struct sk_buff *skb)
 			printk(KERN_INFO
 				"aoe: device addif failure; "
 				"too many interfaces?\n");
-			spin_unlock_irqrestore(&d->lock, flags);
-			return;
+			goto bail;
 		}
 	}
 	if (ifp->maxbcnt) {
@@ -1257,18 +1373,14 @@ aoecmd_cfg_rsp(struct sk_buff *skb)
 	}
 
 	/* don't change users' perspective */
-	if (d->nopen) {
-		spin_unlock_irqrestore(&d->lock, flags);
-		return;
+	if (d->nopen == 0) {
+		d->fw_ver = be16_to_cpu(ch->fwver);
+		sl = aoecmd_ata_id(d);
 	}
-	d->fw_ver = be16_to_cpu(ch->fwver);
-
-	sl = aoecmd_ata_id(d);
-
+bail:
 	spin_unlock_irqrestore(&d->lock, flags);
-
+	aoedev_put(d);
 	if (sl) {
-		struct sk_buff_head queue;
 		__skb_queue_head_init(&queue);
 		__skb_queue_tail(&queue, sl);
 		aoenet_xmit(&queue);
@@ -1297,8 +1409,19 @@ aoecmd_cleanslate(struct aoedev *d)
 	}
 }
 
-static void
-flush_iocq(void)
+void
+aoe_failbuf(struct aoedev *d, struct buf *buf)
+{
+	if (buf == NULL)
+		return;
+	buf->resid = 0;
+	clear_bit(BIO_UPTODATE, &buf->bio->bi_flags);
+	if (buf->nframesout == 0)
+		aoe_end_buf(d, buf);
+}
+
+void
+aoe_flush_iocq(void)
 {
 	struct frame *f;
 	struct aoedev *d;
@@ -1324,6 +1447,7 @@ flush_iocq(void)
 		aoe_freetframe(f);
 		spin_unlock_irqrestore(&d->lock, flags);
 		dev_kfree_skb(skb);
+		aoedev_put(d);
 	}
 }
 
@@ -1344,5 +1468,5 @@ void
 aoecmd_exit(void)
 {
 	aoe_ktstop(&kts);
-	flush_iocq();
+	aoe_flush_iocq();
 }
diff -puN drivers/block/aoe/aoedev.c~aoe-become-i-o-request-queue-handler-for-increased-user-control drivers/block/aoe/aoedev.c
--- a/drivers/block/aoe/aoedev.c~aoe-become-i-o-request-queue-handler-for-increased-user-control
+++ a/drivers/block/aoe/aoedev.c
@@ -19,6 +19,17 @@ static void skbpoolfree(struct aoedev *d
 static struct aoedev *devlist;
 static DEFINE_SPINLOCK(devlist_lock);
 
+/*
+ * Users who grab a pointer to the device with aoedev_by_aoeaddr or
+ * aoedev_by_sysminor_m automatically get a reference count and must
+ * be responsible for performing a aoedev_put.  With the addition of
+ * async kthread processing I'm no longer confident that we can
+ * guarantee consistency in the face of device flushes.
+ *
+ * For the time being, we only bother to add extra references for
+ * frames sitting on the iocq.  When the kthreads finish processing
+ * these frames, they will aoedev_put the device.
+ */
 struct aoedev *
 aoedev_by_aoeaddr(int maj, int min)
 {
@@ -28,13 +39,25 @@ aoedev_by_aoeaddr(int maj, int min)
 	spin_lock_irqsave(&devlist_lock, flags);
 
 	for (d=devlist; d; d=d->next)
-		if (d->aoemajor == maj && d->aoeminor == min)
+		if (d->aoemajor == maj && d->aoeminor == min) {
+			d->ref++;
 			break;
+		}
 
 	spin_unlock_irqrestore(&devlist_lock, flags);
 	return d;
 }
 
+void
+aoedev_put(struct aoedev *d)
+{
+	ulong flags;
+
+	spin_lock_irqsave(&devlist_lock, flags);
+	d->ref--;
+	spin_unlock_irqrestore(&devlist_lock, flags);
+}
+
 static void
 dummy_timer(ulong vp)
 {
@@ -47,21 +70,26 @@ dummy_timer(ulong vp)
 	add_timer(&d->timer);
 }
 
-void
-aoe_failbuf(struct aoedev *d, struct buf *buf)
+static void
+aoe_failip(struct aoedev *d)
 {
+	struct request *rq;
 	struct bio *bio;
+	unsigned long n;
+
+	aoe_failbuf(d, d->ip.buf);
 
-	if (buf == NULL)
+	rq = d->ip.rq;
+	if (rq == NULL)
 		return;
-	buf->flags |= BUFFL_FAIL;
-	if (buf->nframesout == 0) {
-		if (buf == d->inprocess) /* ensure we only process this once */
-			d->inprocess = NULL;
-		bio = buf->bio;
-		mempool_free(buf, d->bufpool);
-		bio_endio(bio, -EIO);
+	while ((bio = d->ip.nxbio)) {
+		clear_bit(BIO_UPTODATE, &bio->bi_flags);
+		d->ip.nxbio = bio->bi_next;
+		n = (unsigned long) rq->special;
+		rq->special = (void *) --n;
 	}
+	if ((unsigned long) rq->special == 0)
+		aoe_end_request(d, rq, 0);
 }
 
 void
@@ -70,8 +98,11 @@ aoedev_downdev(struct aoedev *d)
 	struct aoetgt *t, **tt, **te;
 	struct frame *f;
 	struct list_head *head, *pos, *nx;
+	struct request *rq;
 	int i;
 
+	d->flags &= ~DEVFL_UP;
+
 	/* clean out active buffers on all targets */
 	tt = d->targets;
 	te = tt + NTARGETS;
@@ -92,22 +123,20 @@ aoedev_downdev(struct aoedev *d)
 		t->nout = 0;
 	}
 
-	/* clean out the in-process buffer (if any) */
-	aoe_failbuf(d, d->inprocess);
-	d->inprocess = NULL;
+	/* clean out the in-process request (if any) */
+	aoe_failip(d);
 	d->htgt = NULL;
 
-	/* clean out all pending I/O */
-	while (!list_empty(&d->bufq)) {
-		struct buf *buf = container_of(d->bufq.next, struct buf, bufs);
-		list_del(d->bufq.next);
-		aoe_failbuf(d, buf);
+	/* fast fail all pending I/O */
+	if (d->blkq) {
+		while ((rq = blk_peek_request(d->blkq))) {
+			blk_start_request(rq);
+			aoe_end_request(d, rq, 1);
+		}
 	}
 
 	if (d->gd)
 		set_capacity(d->gd, 0);
-
-	d->flags &= ~DEVFL_UP;
 }
 
 static void
@@ -120,6 +149,7 @@ aoedev_freedev(struct aoedev *d)
 		aoedisk_rm_sysfs(d);
 		del_gendisk(d->gd);
 		put_disk(d->gd);
+		blk_cleanup_queue(d->blkq);
 	}
 	t = d->targets;
 	e = t + NTARGETS;
@@ -128,7 +158,6 @@ aoedev_freedev(struct aoedev *d)
 	if (d->bufpool)
 		mempool_destroy(d->bufpool);
 	skbpoolfree(d);
-	blk_cleanup_queue(d->blkq);
 	kfree(d);
 }
 
@@ -155,7 +184,8 @@ aoedev_flush(const char __user *str, siz
 		spin_lock(&d->lock);
 		if ((!all && (d->flags & DEVFL_UP))
 		|| (d->flags & (DEVFL_GDALLOC|DEVFL_NEWSIZE))
-		|| d->nopen) {
+		|| d->nopen
+		|| d->ref) {
 			spin_unlock(&d->lock);
 			dd = &d->next;
 			continue;
@@ -176,12 +206,15 @@ aoedev_flush(const char __user *str, siz
 	return 0;
 }
 
-/* I'm not really sure that this is a realistic problem, but if the
-network driver goes gonzo let's just leak memory after complaining. */
+/* This has been confirmed to occur once with Tms=3*1000 due to the
+ * driver changing link and not processing its transmit ring.  The
+ * problem is hard enough to solve by returning an error that I'm
+ * still punting on "solving" this.
+ */
 static void
 skbfree(struct sk_buff *skb)
 {
-	enum { Sms = 100, Tms = 3*1000};
+	enum { Sms = 250, Tms = 30 * 1000};
 	int i = Tms / Sms;
 
 	if (skb == NULL)
@@ -222,8 +255,10 @@ aoedev_by_sysminor_m(ulong sysminor)
 	spin_lock_irqsave(&devlist_lock, flags);
 
 	for (d=devlist; d; d=d->next)
-		if (d->sysminor == sysminor)
+		if (d->sysminor == sysminor) {
+			d->ref++;
 			break;
+		}
 	if (d)
 		goto out;
 	d = kcalloc(1, sizeof *d, GFP_ATOMIC);
@@ -231,7 +266,6 @@ aoedev_by_sysminor_m(ulong sysminor)
 		goto out;
 	INIT_WORK(&d->work, aoecmd_sleepwork);
 	spin_lock_init(&d->lock);
-	skb_queue_head_init(&d->sendq);
 	skb_queue_head_init(&d->skbpool);
 	init_timer(&d->timer);
 	d->timer.data = (ulong) d;
@@ -240,7 +274,7 @@ aoedev_by_sysminor_m(ulong sysminor)
 	add_timer(&d->timer);
 	d->bufpool = NULL;	/* defer to aoeblk_gdalloc */
 	d->tgt = d->targets;
-	INIT_LIST_HEAD(&d->bufq);
+	d->ref = 1;
 	d->sysminor = sysminor;
 	d->aoemajor = AOEMAJOR(sysminor);
 	d->aoeminor = AOEMINOR(sysminor);
@@ -274,6 +308,7 @@ aoedev_exit(void)
 	struct aoedev *d;
 	ulong flags;
 
+	aoe_flush_iocq();
 	while ((d = devlist)) {
 		devlist = d->next;
 
_

Patches currently in -mm which might be from ecashin@coraid.com are

origin.patch

