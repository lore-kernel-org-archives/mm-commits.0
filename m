From: akpm@linux-foundation.org
Subject: + aoe-improve-handling-of-misbehaving-network-paths.patch added to -mm tree
Date: Tue, 04 Dec 2012 15:48:37 -0800
Message-ID: <20121204234838.9832620005C@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:40931 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab2LDXsl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2012 18:48:41 -0500
Received: by mail-ee0-f74.google.com with SMTP id t10so327373eei.1
        for <mm-commits@vger.kernel.org>; Tue, 04 Dec 2012 15:48:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ecashin@coraid.com, axboe@kernel.dk


The patch titled
     Subject: aoe: improve handling of misbehaving network paths
has been added to the -mm tree.  Its filename is
     aoe-improve-handling-of-misbehaving-network-paths.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: improve handling of misbehaving network paths

An AoE target can have multiple network ports used for AoE, and in the aoe
driver, those are tracked by the aoetgt struct.  These changes allow the
aoe driver to handle network paths, or aoetgts, that are not working well,
compared to the others.

Paths that do not get responses despite the retransmission of AoE commands
are marked as "tainted", and non-tainted paths are preferred.

Meanwhile, the aoe driver attempts to "probe" the tainted path in the
background by issuing reads of LBA 0 that are padded out to full (possibly
jumbo-frame) size.  If the probes get responses, then the path is
"redeemed", and its taint is removed.

This mechanism has been shown to be helpful in transparently handling and
recovering from real-world network "brown outs" in ways that the earlier
"shoot the help-needing target in the head" mechanism could not.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoe.h    |   11 -
 drivers/block/aoe/aoecmd.c |  377 +++++++++++++++++++++++------------
 drivers/block/aoe/aoedev.c |    1 
 3 files changed, 268 insertions(+), 121 deletions(-)

diff -puN drivers/block/aoe/aoe.h~aoe-improve-handling-of-misbehaving-network-paths drivers/block/aoe/aoe.h
--- a/drivers/block/aoe/aoe.h~aoe-improve-handling-of-misbehaving-network-paths
+++ a/drivers/block/aoe/aoe.h
@@ -91,6 +91,9 @@ enum {
 	RTTDSCALE = 3,
 	RTTAVG_INIT = USEC_PER_SEC / 4 << RTTSCALE,
 	RTTDEV_INIT = RTTAVG_INIT / 4,
+
+	HARD_SCORN_SECS = 10,	/* try another remote port after this */
+	MAX_TAINT = 1000,	/* cap on aoetgt taint */
 };
 
 struct buf {
@@ -103,6 +106,10 @@ struct buf {
 	struct request *rq;
 };
 
+enum frame_flags {
+	FFL_PROBE = 1,
+};
+
 struct frame {
 	struct list_head head;
 	u32 tag;
@@ -118,6 +125,7 @@ struct frame {
 	struct bio_vec *bv;
 	ulong bcnt;
 	ulong bv_off;
+	char flags;
 };
 
 struct aoeif {
@@ -138,8 +146,10 @@ struct aoetgt {
 	ushort next_cwnd;	/* incr maxout after decrementing to zero */
 	ushort ssthresh;	/* slow start threshold */
 	ulong falloc;		/* number of allocated frames */
+	int taint;		/* how much we want to avoid this aoetgt */
 	int minbcnt;
 	int wpkts, rpkts;
+	char nout_probes;
 };
 
 struct aoedev {
@@ -174,7 +184,6 @@ struct aoedev {
 	struct list_head rexmitq; /* deferred retransmissions */
 	struct aoetgt *targets[NTARGETS];
 	struct aoetgt **tgt;	/* target in use when working */
-	struct aoetgt *htgt;	/* target needing rexmit assistance */
 	ulong ntargets;
 	ulong kicked;
 	char ident[512];
diff -puN drivers/block/aoe/aoecmd.c~aoe-improve-handling-of-misbehaving-network-paths drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~aoe-improve-handling-of-misbehaving-network-paths
+++ a/drivers/block/aoe/aoecmd.c
@@ -22,6 +22,7 @@
 #define MAXIOC (8192)	/* default meant to avoid most soft lockups */
 
 static void ktcomplete(struct frame *, struct sk_buff *);
+static int count_targets(struct aoedev *d, int *untainted);
 
 static struct buf *nextbuf(struct aoedev *);
 
@@ -43,6 +44,8 @@ static struct {
 	spinlock_t lock;
 } iocq;
 
+static struct page *empty_page;
+
 static struct sk_buff *
 new_skb(ulong len)
 {
@@ -179,8 +182,10 @@ aoe_freetframe(struct frame *f)
 
 	t = f->t;
 	f->buf = NULL;
+	f->lba = 0;
 	f->bv = NULL;
 	f->r_skb = NULL;
+	f->flags = 0;
 	list_add(&f->head, &t->ffree);
 }
 
@@ -234,20 +239,25 @@ newframe(struct aoedev *d)
 	struct frame *f;
 	struct aoetgt *t, **tt;
 	int totout = 0;
+	int use_tainted;
+	int has_untainted;
 
 	if (d->targets[0] == NULL) {	/* shouldn't happen, but I'm paranoid */
 		printk(KERN_ERR "aoe: NULL TARGETS!\n");
 		return NULL;
 	}
 	tt = d->tgt;	/* last used target */
-	for (;;) {
+	for (use_tainted = 0, has_untainted = 0;;) {
 		tt++;
 		if (tt >= &d->targets[NTARGETS] || !*tt)
 			tt = d->targets;
 		t = *tt;
-		totout += t->nout;
+		if (!t->taint) {
+			has_untainted = 1;
+			totout += t->nout;
+		}
 		if (t->nout < t->maxout
-		&& t != d->htgt
+		&& (use_tainted || !t->taint)
 		&& t->ifp->nd) {
 			f = newtframe(d, t);
 			if (f) {
@@ -256,8 +266,12 @@ newframe(struct aoedev *d)
 				return f;
 			}
 		}
-		if (tt == d->tgt)	/* we've looped and found nada */
-			break;
+		if (tt == d->tgt) {	/* we've looped and found nada */
+			if (!use_tainted && !has_untainted)
+				use_tainted = 1;
+			else
+				break;
+		}
 	}
 	if (totout == 0) {
 		d->kicked++;
@@ -294,21 +308,68 @@ fhash(struct frame *f)
 	list_add_tail(&f->head, &d->factive[n]);
 }
 
+static void
+ata_rw_frameinit(struct frame *f)
+{
+	struct aoetgt *t;
+	struct aoe_hdr *h;
+	struct aoe_atahdr *ah;
+	struct sk_buff *skb;
+	char writebit, extbit;
+
+	skb = f->skb;
+	h = (struct aoe_hdr *) skb_mac_header(skb);
+	ah = (struct aoe_atahdr *) (h + 1);
+	skb_put(skb, sizeof(*h) + sizeof(*ah));
+	memset(h, 0, skb->len);
+
+	writebit = 0x10;
+	extbit = 0x4;
+
+	t = f->t;
+	f->tag = aoehdr_atainit(t->d, t, h);
+	fhash(f);
+	t->nout++;
+	f->waited = 0;
+	f->waited_total = 0;
+	if (f->buf)
+		f->lba = f->buf->sector;
+
+	/* set up ata header */
+	ah->scnt = f->bcnt >> 9;
+	put_lba(ah, f->lba);
+	if (t->d->flags & DEVFL_EXT) {
+		ah->aflags |= AOEAFL_EXT;
+	} else {
+		extbit = 0;
+		ah->lba3 &= 0x0f;
+		ah->lba3 |= 0xe0;	/* LBA bit + obsolete 0xa0 */
+	}
+	if (f->buf && bio_data_dir(f->buf->bio) == WRITE) {
+		skb_fillup(skb, f->bv, f->bv_off, f->bcnt);
+		ah->aflags |= AOEAFL_WRITE;
+		skb->len += f->bcnt;
+		skb->data_len = f->bcnt;
+		skb->truesize += f->bcnt;
+		t->wpkts++;
+	} else {
+		t->rpkts++;
+		writebit = 0;
+	}
+
+	ah->cmdstat = ATA_CMD_PIO_READ | writebit | extbit;
+	skb->dev = t->ifp->nd;
+}
+
 static int
 aoecmd_ata_rw(struct aoedev *d)
 {
 	struct frame *f;
-	struct aoe_hdr *h;
-	struct aoe_atahdr *ah;
 	struct buf *buf;
 	struct aoetgt *t;
 	struct sk_buff *skb;
 	struct sk_buff_head queue;
 	ulong bcnt, fbcnt;
-	char writebit, extbit;
-
-	writebit = 0x10;
-	extbit = 0x4;
 
 	buf = nextbuf(d);
 	if (buf == NULL)
@@ -343,50 +404,15 @@ aoecmd_ata_rw(struct aoedev *d)
 	} while (fbcnt);
 
 	/* initialize the headers & frame */
-	skb = f->skb;
-	h = (struct aoe_hdr *) skb_mac_header(skb);
-	ah = (struct aoe_atahdr *) (h+1);
-	skb_put(skb, sizeof *h + sizeof *ah);
-	memset(h, 0, skb->len);
-	f->tag = aoehdr_atainit(d, t, h);
-	fhash(f);
-	t->nout++;
-	f->waited = 0;
-	f->waited_total = 0;
 	f->buf = buf;
 	f->bcnt = bcnt;
-	f->lba = buf->sector;
-
-	/* set up ata header */
-	ah->scnt = bcnt >> 9;
-	put_lba(ah, buf->sector);
-	if (d->flags & DEVFL_EXT) {
-		ah->aflags |= AOEAFL_EXT;
-	} else {
-		extbit = 0;
-		ah->lba3 &= 0x0f;
-		ah->lba3 |= 0xe0;	/* LBA bit + obsolete 0xa0 */
-	}
-	if (bio_data_dir(buf->bio) == WRITE) {
-		skb_fillup(skb, f->bv, f->bv_off, bcnt);
-		ah->aflags |= AOEAFL_WRITE;
-		skb->len += bcnt;
-		skb->data_len = bcnt;
-		skb->truesize += bcnt;
-		t->wpkts++;
-	} else {
-		t->rpkts++;
-		writebit = 0;
-	}
-
-	ah->cmdstat = ATA_CMD_PIO_READ | writebit | extbit;
+	ata_rw_frameinit(f);
 
 	/* mark all tracking fields and load out */
 	buf->nframesout += 1;
 	buf->sector += bcnt >> 9;
 
-	skb->dev = t->ifp->nd;
-	skb = skb_clone(skb, GFP_ATOMIC);
+	skb = skb_clone(f->skb, GFP_ATOMIC);
 	if (skb) {
 		do_gettimeofday(&f->sent);
 		f->sent_jiffs = (u32) jiffies;
@@ -462,11 +488,14 @@ resend(struct aoedev *d, struct frame *f
 	h = (struct aoe_hdr *) skb_mac_header(skb);
 	ah = (struct aoe_atahdr *) (h+1);
 
-	snprintf(buf, sizeof buf,
-		"%15s e%ld.%d oldtag=%08x@%08lx newtag=%08x s=%pm d=%pm nout=%d\n",
-		"retransmit", d->aoemajor, d->aoeminor, f->tag, jiffies, n,
-		h->src, h->dst, t->nout);
-	aoechr_error(buf);
+	if (!(f->flags & FFL_PROBE)) {
+		snprintf(buf, sizeof(buf),
+			"%15s e%ld.%d oldtag=%08x@%08lx newtag=%08x s=%pm d=%pm nout=%d\n",
+			"retransmit", d->aoemajor, d->aoeminor,
+			f->tag, jiffies, n,
+			h->src, h->dst, t->nout);
+		aoechr_error(buf);
+	}
 
 	f->tag = n;
 	fhash(f);
@@ -558,18 +587,18 @@ ejectif(struct aoetgt *t, struct aoeif *
 }
 
 static struct frame *
-reassign_frame(struct list_head *pos)
+reassign_frame(struct frame *f)
 {
-	struct frame *f;
 	struct frame *nf;
 	struct sk_buff *skb;
 
-	f = list_entry(pos, struct frame, head);
 	nf = newframe(f->t->d);
 	if (!nf)
 		return NULL;
-
-	list_del(pos);
+	if (nf->t == f->t) {
+		aoe_freetframe(nf);
+		return NULL;
+	}
 
 	skb = nf->skb;
 	nf->skb = f->skb;
@@ -583,52 +612,67 @@ reassign_frame(struct list_head *pos)
 	nf->sent = f->sent;
 	nf->sent_jiffs = f->sent_jiffs;
 	f->skb = skb;
-	aoe_freetframe(f);
-	f->t->nout--;
-	nf->t->nout++;
 
 	return nf;
 }
 
-static int
-sthtith(struct aoedev *d)
+static void
+probe(struct aoetgt *t)
 {
-	struct frame *f, *nf;
-	struct list_head *nx, *pos, *head;
-	struct aoetgt *ht = d->htgt;
-	int i;
+	struct aoedev *d;
+	struct frame *f;
+	struct sk_buff *skb;
+	struct sk_buff_head queue;
+	size_t n, m;
+	int frag;
 
-	/* look through the active and pending retransmit frames */
-	for (i = 0; i < NFACTIVE; i++) {
-		head = &d->factive[i];
-		list_for_each_safe(pos, nx, head) {
-			f = list_entry(pos, struct frame, head);
-			if (f->t != ht)
-				continue;
-			nf = reassign_frame(pos);
-			if (!nf)
-				return 0;
-			resend(d, nf);
-		}
+	d = t->d;
+	f = newtframe(d, t);
+	if (!f) {
+		pr_err("%s %pm for e%ld.%d: %s\n",
+			"aoe: cannot probe remote address",
+			t->addr,
+			(long) d->aoemajor, d->aoeminor,
+			"no frame available");
+		return;
 	}
-	head = &d->rexmitq;
-	list_for_each_safe(pos, nx, head) {
-		f = list_entry(pos, struct frame, head);
-		if (f->t != ht)
-			continue;
-		nf = reassign_frame(pos);
-		if (!nf)
-			return 0;
-		resend(d, nf);
+	f->flags |= FFL_PROBE;
+	ifrotate(t);
+	f->bcnt = t->d->maxbcnt ? t->d->maxbcnt : DEFAULTBCNT;
+	ata_rw_frameinit(f);
+	skb = f->skb;
+	for (frag = 0, n = f->bcnt; n > 0; ++frag, n -= m) {
+		if (n < PAGE_SIZE)
+			m = n;
+		else
+			m = PAGE_SIZE;
+		skb_fill_page_desc(skb, frag, empty_page, 0, m);
+	}
+	skb->len += f->bcnt;
+	skb->data_len = f->bcnt;
+	skb->truesize += f->bcnt;
+
+	skb = skb_clone(f->skb, GFP_ATOMIC);
+	if (skb) {
+		do_gettimeofday(&f->sent);
+		f->sent_jiffs = (u32) jiffies;
+		__skb_queue_head_init(&queue);
+		__skb_queue_tail(&queue, skb);
+		aoenet_xmit(&queue);
 	}
-	/* We've cleaned up the outstanding so take away his
-	 * interfaces so he won't be used.  We should remove him from
-	 * the target array here, but cleaning up a target is
-	 * involved.  PUNT!
-	 */
-	memset(ht->ifs, 0, sizeof ht->ifs);
-	d->htgt = NULL;
-	return 1;
+}
+
+static long
+rto(struct aoedev *d)
+{
+	long t;
+
+	t = 2 * d->rttavg >> RTTSCALE;
+	t += 8 * d->rttdev >> RTTDSCALE;
+	if (t == 0)
+		t = 1;
+
+	return t;
 }
 
 static void
@@ -636,17 +680,53 @@ rexmit_deferred(struct aoedev *d)
 {
 	struct aoetgt *t;
 	struct frame *f;
+	struct frame *nf;
 	struct list_head *pos, *nx, *head;
 	int since;
+	int untainted;
+
+	count_targets(d, &untainted);
 
 	head = &d->rexmitq;
 	list_for_each_safe(pos, nx, head) {
 		f = list_entry(pos, struct frame, head);
 		t = f->t;
+		if (t->taint) {
+			if (!(f->flags & FFL_PROBE)) {
+				nf = reassign_frame(f);
+				if (nf) {
+					if (t->nout_probes == 0
+					&& untainted > 0) {
+						probe(t);
+						t->nout_probes++;
+					}
+					list_replace(&f->head, &nf->head);
+					pos = &nf->head;
+					aoe_freetframe(f);
+					f = nf;
+					t = f->t;
+				}
+			} else if (untainted < 1) {
+				/* don't probe w/o other untainted aoetgts */
+				goto stop_probe;
+			} else if (tsince_hr(f) < t->taint * rto(d)) {
+				/* reprobe slowly when taint is high */
+				continue;
+			}
+		} else if (f->flags & FFL_PROBE) {
+stop_probe:		/* don't probe untainted aoetgts */
+			list_del(pos);
+			aoe_freetframe(f);
+			/* leaving d->kicked, because this is routine */
+			f->t->d->flags |= DEVFL_KICKME;
+			continue;
+		}
 		if (t->nout >= t->maxout)
 			continue;
 		list_del(pos);
 		t->nout++;
+		if (f->flags & FFL_PROBE)
+			t->nout_probes++;
 		since = tsince_hr(f);
 		f->waited += since;
 		f->waited_total += since;
@@ -654,6 +734,36 @@ rexmit_deferred(struct aoedev *d)
 	}
 }
 
+/* An aoetgt accumulates demerits quickly, and successful
+ * probing redeems the aoetgt slowly.
+ */
+static void
+scorn(struct aoetgt *t)
+{
+	int n;
+
+	n = t->taint++;
+	t->taint += t->taint * 2;
+	if (n > t->taint)
+		t->taint = n;
+	if (t->taint > MAX_TAINT)
+		t->taint = MAX_TAINT;
+}
+
+static int
+count_targets(struct aoedev *d, int *untainted)
+{
+	int i, good;
+
+	for (i = good = 0; i < d->ntargets && d->targets[i]; ++i)
+		if (d->targets[i]->taint == 0)
+			good++;
+
+	if (untainted)
+		*untainted = good;
+	return i;
+}
+
 static void
 rexmit_timer(ulong vp)
 {
@@ -666,6 +776,7 @@ rexmit_timer(ulong vp)
 	register long timeout;
 	ulong flags, n;
 	int i;
+	int utgts;	/* number of aoetgt descriptors (not slots) */
 	int since;
 
 	d = (struct aoedev *) vp;
@@ -673,10 +784,9 @@ rexmit_timer(ulong vp)
 	spin_lock_irqsave(&d->lock, flags);
 
 	/* timeout based on observed timings and variations */
-	timeout = 2 * d->rttavg >> RTTSCALE;
-	timeout += 8 * d->rttdev >> RTTDSCALE;
-	if (timeout == 0)
-		timeout = 1;
+	timeout = rto(d);
+
+	utgts = count_targets(d, NULL);
 
 	if (d->flags & DEVFL_TKILL) {
 		spin_unlock_irqrestore(&d->lock, flags);
@@ -702,7 +812,7 @@ rexmit_timer(ulong vp)
 		since = tsince_hr(f);
 		n = f->waited_total + since;
 		n /= USEC_PER_SEC;
-		if (n > aoe_deadsecs) {
+		if (n > aoe_deadsecs && !(f->flags & FFL_PROBE)) {
 			/* Waited too long.  Device failure.
 			 * Hang all frames on first hash bucket for downdev
 			 * to clean up.
@@ -713,19 +823,26 @@ rexmit_timer(ulong vp)
 		}
 
 		t = f->t;
-		if (n > aoe_deadsecs/2)
-			d->htgt = t; /* see if another target can help */
+		n = f->waited + since;
+		n /= USEC_PER_SEC;
+		if (aoe_deadsecs && utgts > 0
+		&& (n > aoe_deadsecs / utgts || n > HARD_SCORN_SECS))
+			scorn(t); /* avoid this target */
 
 		if (t->maxout != 1) {
 			t->ssthresh = t->maxout / 2;
 			t->maxout = 1;
 		}
 
-		ifp = getif(t, f->skb->dev);
-		if (ifp && ++ifp->lost > (t->nframes << 1)
-		&& (ifp != t->ifs || t->ifs[1].nd)) {
-			ejectif(t, ifp);
-			ifp = NULL;
+		if (f->flags & FFL_PROBE) {
+			t->nout_probes--;
+		} else {
+			ifp = getif(t, f->skb->dev);
+			if (ifp && ++ifp->lost > (t->nframes << 1)
+			&& (ifp != t->ifs || t->ifs[1].nd)) {
+				ejectif(t, ifp);
+				ifp = NULL;
+			}
 		}
 		list_move_tail(pos, &d->rexmitq);
 		t->nout--;
@@ -733,7 +850,7 @@ rexmit_timer(ulong vp)
 	rexmit_deferred(d);
 
 out:
-	if ((d->flags & DEVFL_KICKME || d->htgt) && d->blkq) {
+	if ((d->flags & DEVFL_KICKME) && d->blkq) {
 		d->flags &= ~DEVFL_KICKME;
 		d->blkq->request_fn(d->blkq);
 	}
@@ -854,8 +971,6 @@ nextbuf(struct aoedev *d)
 void
 aoecmd_work(struct aoedev *d)
 {
-	if (d->htgt && !sthtith(d))
-		return;
 	rexmit_deferred(d);
 	while (aoecmd_ata_rw(d))
 		;
@@ -1065,19 +1180,22 @@ ktiocomplete(struct frame *f)
 	struct aoeif *ifp;
 	struct aoedev *d;
 	long n;
+	int untainted;
 
 	if (f == NULL)
 		return;
 
 	t = f->t;
 	d = t->d;
+	skb = f->r_skb;
+	buf = f->buf;
+	if (f->flags & FFL_PROBE)
+		goto out;
+	if (!skb)		/* just fail the buf. */
+		goto noskb;
 
 	hout = (struct aoe_hdr *) skb_mac_header(f->skb);
 	ahout = (struct aoe_atahdr *) (hout+1);
-	buf = f->buf;
-	skb = f->r_skb;
-	if (skb == NULL)
-		goto noskb;	/* just fail the buf. */
 
 	hin = (struct aoe_hdr *) skb->data;
 	skb_pull(skb, sizeof(*hin));
@@ -1089,7 +1207,7 @@ ktiocomplete(struct frame *f)
 			d->aoemajor, d->aoeminor);
 noskb:		if (buf)
 			clear_bit(BIO_UPTODATE, &buf->bio->bi_flags);
-		goto badrsp;
+		goto out;
 	}
 
 	n = ahout->scnt << 9;
@@ -1109,8 +1227,6 @@ noskb:		if (buf)
 		ifp = getif(t, skb->dev);
 		if (ifp)
 			ifp->lost = 0;
-		if (d->htgt == t) /* I'll help myself, thank you. */
-			d->htgt = NULL;
 		spin_unlock_irq(&d->lock);
 		break;
 	case ATA_CMD_ID_ATA:
@@ -1131,8 +1247,17 @@ noskb:		if (buf)
 			be16_to_cpu(get_unaligned(&hin->major)),
 			hin->minor);
 	}
-badrsp:
+out:
 	spin_lock_irq(&d->lock);
+	if (t->taint > 0
+	&& --t->taint > 0
+	&& t->nout_probes == 0) {
+		count_targets(d, &untainted);
+		if (untainted > 0) {
+			probe(t);
+			t->nout_probes++;
+		}
+	}
 
 	aoe_freetframe(f);
 
@@ -1261,6 +1386,8 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 	if (f) {
 		calc_rttavg(d, f->t, tsince_hr(f));
 		f->t->nout--;
+		if (f->flags & FFL_PROBE)
+			f->t->nout_probes--;
 	} else {
 		f = getframe_deferred(d, n);
 		if (f) {
@@ -1379,6 +1506,7 @@ addtgt(struct aoedev *d, char *addr, ulo
 	memcpy(t->addr, addr, sizeof t->addr);
 	t->ifp = t->ifs;
 	aoecmd_wreset(t);
+	t->maxout = t->nframes / 2;
 	INIT_LIST_HEAD(&t->ffree);
 	return *tt = t;
 }
@@ -1584,6 +1712,14 @@ aoe_flush_iocq(void)
 int __init
 aoecmd_init(void)
 {
+	void *p;
+
+	/* get_zeroed_page returns page with ref count 1 */
+	p = (void *) get_zeroed_page(GFP_KERNEL | __GFP_REPEAT);
+	if (!p)
+		return -ENOMEM;
+	empty_page = virt_to_page(p);
+
 	INIT_LIST_HEAD(&iocq.head);
 	spin_lock_init(&iocq.lock);
 	init_waitqueue_head(&ktiowq);
@@ -1599,4 +1735,7 @@ aoecmd_exit(void)
 {
 	aoe_ktstop(&kts);
 	aoe_flush_iocq();
+
+	free_page((unsigned long) page_address(empty_page));
+	empty_page = NULL;
 }
diff -puN drivers/block/aoe/aoedev.c~aoe-improve-handling-of-misbehaving-network-paths drivers/block/aoe/aoedev.c
--- a/drivers/block/aoe/aoedev.c~aoe-improve-handling-of-misbehaving-network-paths
+++ a/drivers/block/aoe/aoedev.c
@@ -223,7 +223,6 @@ aoedev_downdev(struct aoedev *d)
 
 	/* clean out the in-process request (if any) */
 	aoe_failip(d);
-	d->htgt = NULL;
 
 	/* fast fail all pending I/O */
 	if (d->blkq) {
_

Patches currently in -mm which might be from ecashin@coraid.com are

linux-next.patch
linux-compilerh-add-__must_hold-macro-for-functions-called-with-a-lock-held.patch
documentation-sparsetxt-document-context-annotations-for-lock-checking.patch
aoe-describe-the-behavior-of-the-err-character-device.patch
aoe-print-warning-regarding-a-common-reason-for-dropped-transmits.patch
aoe-print-warning-regarding-a-common-reason-for-dropped-transmits-v2.patch
aoe-print-warning-regarding-a-common-reason-for-dropped-transmits-fix.patch
aoe-update-cap-on-outstanding-commands-based-on-config-query-response.patch
aoe-support-the-forgetting-flushing-of-a-user-specified-aoe-target.patch
aoe-support-larger-i-o-requests-via-aoe_maxsectors-module-param.patch
aoe-payload-sysfs-file-exports-per-aoe-command-data-transfer-size.patch
aoe-cleanup-remove-unused-ata_scnt-function.patch
aoe-whitespace-cleanup.patch
aoe-update-driver-internal-version-number-to-60.patch
aoe-provide-ata-identify-device-content-to-user-on-request.patch
aoe-improve-network-congestion-handling.patch
aoe-err-device-include-mac-addresses-for-unexpected-responses.patch
aoe-manipulate-aoedev-network-stats-under-lock.patch
aoe-use-high-resolution-rtts-with-fallback-to-low-res.patch
aoe-commands-in-retransmit-queue-use-new-destination-on-failure.patch
aoe-update-driver-internal-version-to-64.patch
aoe-copy-fallback-timing-information-on-destination-failover.patch
aoe-remove-vestigial-request-queue-allocation.patch
aoe-increase-default-cap-on-outstanding-aoe-commands-in-the-network.patch
aoe-cleanup-correct-comment-for-aoetgt-nout.patch
aoe-remove-call-to-request-handler-from-i-o-completion.patch
aoe-make-error-messages-more-specific-in-static-minor-allocation.patch
aoe-initialize-sysminor-to-avoid-compiler-warning.patch
aoe-return-real-minor-number-for-static-minors.patch
aoe-improve-handling-of-misbehaving-network-paths.patch
aoe-avoid-races-between-device-destruction-and-discovery.patch
aoe-use-dynamic-number-of-remote-ports-for-aoe-storage-target.patch
aoe-allow-user-to-disable-target-failure-timeout.patch
aoe-allow-comma-separator-in-aoe_iflist-value.patch
aoe-identify-source-of-runt-aoe-packets.patch
aoe-update-internal-version-number-to-81.patch

