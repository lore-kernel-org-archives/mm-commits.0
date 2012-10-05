From: akpm@linux-foundation.org
Subject: [merged] aoe-associate-frames-with-the-aoe-storage-target.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:21:30 -0700
Message-ID: <20121005202130.A9F761E0048@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:40851 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab2JEUVb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:21:31 -0400
Received: by mail-qa0-f74.google.com with SMTP id a16so94890qae.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:21:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aoe: associate frames with the AoE storage target
has been removed from the -mm tree.  Its filename was
     aoe-associate-frames-with-the-aoe-storage-target.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: associate frames with the AoE storage target

In the driver code, "target" and aoetgt refer to a particular remote
interface on the AoE storage target.  The latter is identified by its AoE
major and minor addresses.  Commands that are being sent to an AoE storage
target {major, minor} can be sent or retransmitted to any of the remote
MAC addresses associated with the AoE storage target.

That is, frames are naturally associated with not an aoetgt (AoE major,
AoE minor, remote MAC address) but an aoedev (AoE major, AoE minor). 
Making the code reflect that reality simplifies the driver, especially
when the path to a remote MAC address becomes unusable.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoe.h    |    8 ++--
 drivers/block/aoe/aoecmd.c |   65 +++++++++++++++--------------------
 drivers/block/aoe/aoedev.c |   30 +++++++++-------
 3 files changed, 49 insertions(+), 54 deletions(-)

diff -puN drivers/block/aoe/aoe.h~aoe-associate-frames-with-the-aoe-storage-target drivers/block/aoe/aoe.h
--- a/drivers/block/aoe/aoe.h~aoe-associate-frames-with-the-aoe-storage-target
+++ a/drivers/block/aoe/aoe.h
@@ -91,7 +91,7 @@ enum {
 	NTARGETS = 8,
 	NAOEIFS = 8,
 	NSKBPOOLMAX = 256,
-	NFACTIVE = 17,
+	NFACTIVE = 61,
 
 	TIMERTICK = HZ / 10,
 	MINTIMER = HZ >> 2,
@@ -132,14 +132,11 @@ struct aoetgt {
 	unsigned char addr[6];
 	ushort nframes;
 	struct aoedev *d;			/* parent device I belong to */
-	struct list_head factive[NFACTIVE];	/* hash of active frames */
 	struct list_head ffree;			/* list of free frames */
 	struct aoeif ifs[NAOEIFS];
 	struct aoeif *ifp;	/* current aoeif in use */
 	ushort nout;
 	ushort maxout;
-	u16 lasttag;		/* last tag sent */
-	u16 useme;
 	ulong falloc;
 	ulong lastwadj;		/* last window adjustment */
 	int minbcnt;
@@ -156,6 +153,8 @@ struct aoedev {
 	u16 rttavg;		/* round trip average of requests/responses */
 	u16 mintimer;
 	u16 fw_ver;		/* version of blade's firmware */
+	u16 lasttag;		/* last tag sent */
+	u16 useme;
 	ulong ref;
 	struct work_struct work;/* disk create work struct */
 	struct gendisk *gd;
@@ -172,6 +171,7 @@ struct aoedev {
 		struct request *rq;
 	} ip;
 	ulong maxbcnt;
+	struct list_head factive[NFACTIVE];	/* hash of active frames */
 	struct aoetgt *targets[NTARGETS];
 	struct aoetgt **tgt;	/* target in use when working */
 	struct aoetgt *htgt;	/* target needing rexmit assistance */
diff -puN drivers/block/aoe/aoecmd.c~aoe-associate-frames-with-the-aoe-storage-target drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~aoe-associate-frames-with-the-aoe-storage-target
+++ a/drivers/block/aoe/aoecmd.c
@@ -59,14 +59,14 @@ new_skb(ulong len)
 }
 
 static struct frame *
-getframe(struct aoetgt *t, u32 tag)
+getframe(struct aoedev *d, u32 tag)
 {
 	struct frame *f;
 	struct list_head *head, *pos, *nx;
 	u32 n;
 
 	n = tag % NFACTIVE;
-	head = &t->factive[n];
+	head = &d->factive[n];
 	list_for_each_safe(pos, nx, head) {
 		f = list_entry(pos, struct frame, head);
 		if (f->tag == tag) {
@@ -83,18 +83,18 @@ getframe(struct aoetgt *t, u32 tag)
  * This driver reserves tag -1 to mean "unused frame."
  */
 static int
-newtag(struct aoetgt *t)
+newtag(struct aoedev *d)
 {
 	register ulong n;
 
 	n = jiffies & 0xffff;
-	return n |= (++t->lasttag & 0x7fff) << 16;
+	return n |= (++d->lasttag & 0x7fff) << 16;
 }
 
 static u32
 aoehdr_atainit(struct aoedev *d, struct aoetgt *t, struct aoe_hdr *h)
 {
-	u32 host_tag = newtag(t);
+	u32 host_tag = newtag(d);
 
 	memcpy(h->src, t->ifp->nd->dev_addr, sizeof h->src);
 	memcpy(h->dst, t->addr, sizeof h->dst);
@@ -270,11 +270,11 @@ loop:
 static void
 fhash(struct frame *f)
 {
-	struct aoetgt *t = f->t;
+	struct aoedev *d = f->t->d;
 	u32 n;
 
 	n = f->tag % NFACTIVE;
-	list_add_tail(&f->head, &t->factive[n]);
+	list_add_tail(&f->head, &d->factive[n]);
 }
 
 static int
@@ -433,7 +433,7 @@ resend(struct aoedev *d, struct frame *f
 	u32 n;
 
 	t = f->t;
-	n = newtag(t);
+	n = newtag(d);
 	skb = f->skb;
 	if (ifrotate(t) == NULL) {
 		/* probably can't happen, but set it up to fail anyway */
@@ -512,9 +512,12 @@ sthtith(struct aoedev *d)
 	int i;
 
 	for (i = 0; i < NFACTIVE; i++) {
-		head = &ht->factive[i];
+		head = &d->factive[i];
 		list_for_each_safe(pos, nx, head) {
 			f = list_entry(pos, struct frame, head);
+			if (f->t != ht)
+				continue;
+
 			nf = newframe(d);
 			if (!nf)
 				return 0;
@@ -585,22 +588,20 @@ rexmit_timer(ulong vp)
 	}
 
 	/* collect all frames to rexmit into flist */
-	tt = d->targets;
-	te = tt + NTARGETS;
-	for (; tt < te && *tt; tt++) {
-		t = *tt;
-		for (i = 0; i < NFACTIVE; i++) {
-			head = &t->factive[i];
-			list_for_each_safe(pos, nx, head) {
-				f = list_entry(pos, struct frame, head);
-				if (tsince(f->tag) < timeout)
-					continue;
-				/* move to flist for later processing */
-				list_move_tail(pos, &flist);
-			}
+	for (i = 0; i < NFACTIVE; i++) {
+		head = &d->factive[i];
+		list_for_each_safe(pos, nx, head) {
+			f = list_entry(pos, struct frame, head);
+			if (tsince(f->tag) < timeout)
+				break;	/* end of expired frames */
+			/* move to flist for later processing */
+			list_move_tail(pos, &flist);
 		}
-
-		/* window check */
+	}
+	/* window check */
+	tt = d->targets;
+	te = tt + d->ntargets;
+	for (; tt < te && (t = *tt); tt++) {
 		if (t->nout == t->maxout
 		&& t->maxout < t->nframes
 		&& (jiffies - t->lastwadj)/HZ > 10) {
@@ -626,7 +627,7 @@ rexmit_timer(ulong vp)
 			 * Hang all frames on first hash bucket for downdev
 			 * to clean up.
 			 */
-			list_splice(&flist, &f->t->factive[0]);
+			list_splice(&flist, &d->factive[0]);
 			aoedev_downdev(d);
 			break;
 		}
@@ -1162,15 +1163,7 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 	spin_lock_irqsave(&d->lock, flags);
 
 	n = be32_to_cpu(get_unaligned(&h->tag));
-	t = gettgt(d, h->src);
-	if (t == NULL) {
-		printk(KERN_INFO "aoe: can't find target e%ld.%d:%pm\n",
-		       d->aoemajor, d->aoeminor, h->src);
-		spin_unlock_irqrestore(&d->lock, flags);
-		aoedev_put(d);
-		return skb;
-	}
-	f = getframe(t, n);
+	f = getframe(d, n);
 	if (f == NULL) {
 		calc_rttavg(d, -tsince(n));
 		spin_unlock_irqrestore(&d->lock, flags);
@@ -1185,6 +1178,7 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 		aoechr_error(ebuf);
 		return skb;
 	}
+	t = f->t;
 	calc_rttavg(d, tsince(f->tag));
 	t->nout--;
 	aoecmd_work(d);
@@ -1253,7 +1247,6 @@ static struct aoetgt *
 addtgt(struct aoedev *d, char *addr, ulong nframes)
 {
 	struct aoetgt *t, **tt, **te;
-	int i;
 
 	tt = d->targets;
 	te = tt + NTARGETS;
@@ -1278,8 +1271,6 @@ addtgt(struct aoedev *d, char *addr, ulo
 	t->ifp = t->ifs;
 	t->maxout = t->nframes;
 	INIT_LIST_HEAD(&t->ffree);
-	for (i = 0; i < NFACTIVE; ++i)
-		INIT_LIST_HEAD(&t->factive[i]);
 	return *tt = t;
 }
 
diff -puN drivers/block/aoe/aoedev.c~aoe-associate-frames-with-the-aoe-storage-target drivers/block/aoe/aoedev.c
--- a/drivers/block/aoe/aoedev.c~aoe-associate-frames-with-the-aoe-storage-target
+++ a/drivers/block/aoe/aoedev.c
@@ -103,22 +103,23 @@ aoedev_downdev(struct aoedev *d)
 
 	d->flags &= ~DEVFL_UP;
 
-	/* clean out active buffers on all targets */
+	/* clean out active buffers */
+	for (i = 0; i < NFACTIVE; i++) {
+		head = &d->factive[i];
+		list_for_each_safe(pos, nx, head) {
+			f = list_entry(pos, struct frame, head);
+			list_del(pos);
+			if (f->buf) {
+				f->buf->nframesout--;
+				aoe_failbuf(d, f->buf);
+			}
+			aoe_freetframe(f);
+		}
+	}
+	/* reset window dressings */
 	tt = d->targets;
 	te = tt + NTARGETS;
 	for (; tt < te && (t = *tt); tt++) {
-		for (i = 0; i < NFACTIVE; i++) {
-			head = &t->factive[i];
-			list_for_each_safe(pos, nx, head) {
-				list_del(pos);
-				f = list_entry(pos, struct frame, head);
-				if (f->buf) {
-					f->buf->nframesout--;
-					aoe_failbuf(d, f->buf);
-				}
-				aoe_freetframe(f);
-			}
-		}
 		t->maxout = t->nframes;
 		t->nout = 0;
 	}
@@ -250,6 +251,7 @@ struct aoedev *
 aoedev_by_sysminor_m(ulong sysminor)
 {
 	struct aoedev *d;
+	int i;
 	ulong flags;
 
 	spin_lock_irqsave(&devlist_lock, flags);
@@ -275,6 +277,8 @@ aoedev_by_sysminor_m(ulong sysminor)
 	d->bufpool = NULL;	/* defer to aoeblk_gdalloc */
 	d->tgt = d->targets;
 	d->ref = 1;
+	for (i = 0; i < NFACTIVE; i++)
+		INIT_LIST_HEAD(&d->factive[i]);
 	d->sysminor = sysminor;
 	d->aoemajor = AOEMAJOR(sysminor);
 	d->aoeminor = AOEMINOR(sysminor);
_

Patches currently in -mm which might be from ecashin@coraid.com are

origin.patch

