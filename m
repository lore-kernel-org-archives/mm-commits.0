From: akpm@linux-foundation.org
Subject: [merged] aoe-improve-network-congestion-handling.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:10:09 -0800
Message-ID: <20121218201010.123AE200061@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:42217 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755270Ab2LRUKM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:10:12 -0500
Received: by mail-wg0-f74.google.com with SMTP id dt14so63379wgb.3
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:10:11 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aoe: improve network congestion handling
has been removed from the -mm tree.  Its filename was
     aoe-improve-network-congestion-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: improve network congestion handling

The aoe driver already had some congestion handling, but it was limited in
its ability to cope with the kind of congestion that can arise on more
complex networks such as those involving paths through multiple ethernet
switches.

Some of the lessons from TCP's history of development can be applied to
improving the congestion control and avoidance on AoE storage networks. 
These changes use familar concepts from Van Jacobson's "Congestion
Avoidance and Control" paper from '88, without adding significant
overhead.

This patch depends on an upcoming patch that covers the failover case when
AoE commands being retransmitted are transferred from one retransmit queue
to another.  Another upcoming patch increases the timing accuracy.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoe.h    |   16 ++-
 drivers/block/aoe/aoecmd.c |  173 +++++++++++++++++++++--------------
 drivers/block/aoe/aoedev.c |    6 -
 3 files changed, 121 insertions(+), 74 deletions(-)

diff -puN drivers/block/aoe/aoe.h~aoe-improve-network-congestion-handling drivers/block/aoe/aoe.h
--- a/drivers/block/aoe/aoe.h~aoe-improve-network-congestion-handling
+++ a/drivers/block/aoe/aoe.h
@@ -86,8 +86,11 @@ enum {
 	NFACTIVE = 61,
 
 	TIMERTICK = HZ / 10,
-	MINTIMER = HZ >> 2,
+	RTTSCALE = 8,
+	RTTDSCALE = 3,
 	MAXTIMER = HZ << 1,
+	RTTAVG_INIT = HZ / 4 << RTTSCALE,
+	RTTDEV_INIT = RTTAVG_INIT / 4,
 };
 
 struct buf {
@@ -127,10 +130,11 @@ struct aoetgt {
 	struct list_head ffree;			/* list of free frames */
 	struct aoeif ifs[NAOEIFS];
 	struct aoeif *ifp;	/* current aoeif in use */
-	ushort nout;
+	ushort nout;		/* value of nout when skb was sent */
 	ushort maxout;		/* current value for max outstanding */
+	ushort next_cwnd;	/* incr maxout after decrementing to zero */
+	ushort ssthresh;	/* slow start threshold */
 	ulong falloc;		/* number of allocated frames */
-	ulong lastwadj;		/* last window adjustment */
 	int minbcnt;
 	int wpkts, rpkts;
 };
@@ -142,8 +146,8 @@ struct aoedev {
 	u16 aoeminor;
 	u16 flags;
 	u16 nopen;		/* (bd_openers isn't available without sleeping) */
-	u16 rttavg;		/* round trip average of requests/responses */
-	u16 mintimer;
+	u16 rttavg;		/* scaled AoE round trip time average */
+	u16 rttdev;		/* scaled round trip time mean deviation */
 	u16 fw_ver;		/* version of blade's firmware */
 	u16 lasttag;		/* last tag sent */
 	u16 useme;
@@ -164,6 +168,7 @@ struct aoedev {
 	} ip;
 	ulong maxbcnt;
 	struct list_head factive[NFACTIVE];	/* hash of active frames */
+	struct list_head rexmitq; /* deferred retransmissions */
 	struct aoetgt *targets[NTARGETS];
 	struct aoetgt **tgt;	/* target in use when working */
 	struct aoetgt *htgt;	/* target needing rexmit assistance */
@@ -196,6 +201,7 @@ void aoecmd_cfg(ushort aoemajor, unsigne
 struct sk_buff *aoecmd_ata_rsp(struct sk_buff *);
 void aoecmd_cfg_rsp(struct sk_buff *);
 void aoecmd_sleepwork(struct work_struct *);
+void aoecmd_wreset(struct aoetgt *t);
 void aoecmd_cleanslate(struct aoedev *);
 void aoecmd_exit(void);
 int aoecmd_init(void);
diff -puN drivers/block/aoe/aoecmd.c~aoe-improve-network-congestion-handling drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~aoe-improve-network-congestion-handling
+++ a/drivers/block/aoe/aoecmd.c
@@ -59,6 +59,23 @@ new_skb(ulong len)
 }
 
 static struct frame *
+getframe_deferred(struct aoedev *d, u32 tag)
+{
+	struct list_head *head, *pos, *nx;
+	struct frame *f;
+
+	head = &d->rexmitq;
+	list_for_each_safe(pos, nx, head) {
+		f = list_entry(pos, struct frame, head);
+		if (f->tag == tag) {
+			list_del(pos);
+			return f;
+		}
+	}
+	return NULL;
+}
+
+static struct frame *
 getframe(struct aoedev *d, u32 tag)
 {
 	struct frame *f;
@@ -553,10 +570,29 @@ sthtith(struct aoedev *d)
 }
 
 static void
+rexmit_deferred(struct aoedev *d)
+{
+	struct aoetgt *t;
+	struct frame *f;
+	struct list_head *pos, *nx, *head;
+
+	head = &d->rexmitq;
+	list_for_each_safe(pos, nx, head) {
+		f = list_entry(pos, struct frame, head);
+		t = f->t;
+		if (t->nout >= t->maxout)
+			continue;
+		list_del(pos);
+		t->nout++;
+		resend(d, f);
+	}
+}
+
+static void
 rexmit_timer(ulong vp)
 {
 	struct aoedev *d;
-	struct aoetgt *t, **tt, **te;
+	struct aoetgt *t;
 	struct aoeif *ifp;
 	struct frame *f;
 	struct list_head *head, *pos, *nx;
@@ -567,9 +603,11 @@ rexmit_timer(ulong vp)
 
 	d = (struct aoedev *) vp;
 
-	/* timeout is always ~150% of the moving average */
-	timeout = d->rttavg;
-	timeout += timeout >> 1;
+	/* timeout based on observed timings and variations */
+	timeout = 2 * d->rttavg >> RTTSCALE;
+	timeout += 8 * d->rttdev >> RTTDSCALE;
+	if (timeout == 0)
+		timeout = 1;
 
 	spin_lock_irqsave(&d->lock, flags);
 
@@ -589,29 +627,12 @@ rexmit_timer(ulong vp)
 			list_move_tail(pos, &flist);
 		}
 	}
-	/* window check */
-	tt = d->targets;
-	te = tt + d->ntargets;
-	for (; tt < te && (t = *tt); tt++) {
-		if (t->nout == t->maxout
-		&& t->maxout < t->nframes
-		&& (jiffies - t->lastwadj)/HZ > 10) {
-			t->maxout++;
-			t->lastwadj = jiffies;
-		}
-	}
-
-	if (!list_empty(&flist)) {	/* retransmissions necessary */
-		n = d->rttavg <<= 1;
-		if (n > MAXTIMER)
-			d->rttavg = MAXTIMER;
-	}
 
 	/* process expired frames */
 	while (!list_empty(&flist)) {
 		pos = flist.next;
 		f = list_entry(pos, struct frame, head);
-		n = f->waited += timeout;
+		n = f->waited += tsince(f->tag);
 		n /= HZ;
 		if (n > aoe_deadsecs) {
 			/* Waited too long.  Device failure.
@@ -620,18 +641,16 @@ rexmit_timer(ulong vp)
 			 */
 			list_splice(&flist, &d->factive[0]);
 			aoedev_downdev(d);
-			break;
+			goto out;
 		}
-		list_del(pos);
 
 		t = f->t;
 		if (n > aoe_deadsecs/2)
 			d->htgt = t; /* see if another target can help */
 
-		if (t->nout == t->maxout) {
-			if (t->maxout > 1)
-				t->maxout--;
-			t->lastwadj = jiffies;
+		if (t->maxout != 1) {
+			t->ssthresh = t->maxout / 2;
+			t->maxout = 1;
 		}
 
 		ifp = getif(t, f->skb->dev);
@@ -640,9 +659,12 @@ rexmit_timer(ulong vp)
 			ejectif(t, ifp);
 			ifp = NULL;
 		}
-		resend(d, f);
+		list_move_tail(pos, &d->rexmitq);
+		t->nout--;
 	}
+	rexmit_deferred(d);
 
+out:
 	if ((d->flags & DEVFL_KICKME || d->htgt) && d->blkq) {
 		d->flags &= ~DEVFL_KICKME;
 		d->blkq->request_fn(d->blkq);
@@ -766,6 +788,7 @@ aoecmd_work(struct aoedev *d)
 {
 	if (d->htgt && !sthtith(d))
 		return;
+	rexmit_deferred(d);
 	while (aoecmd_ata_rw(d))
 		;
 }
@@ -868,26 +891,28 @@ ataid_complete(struct aoedev *d, struct 
 }
 
 static void
-calc_rttavg(struct aoedev *d, int rtt)
+calc_rttavg(struct aoedev *d, struct aoetgt *t, int rtt)
 {
 	register long n;
 
 	n = rtt;
-	if (n < 0) {
-		n = -rtt;
-		if (n < MINTIMER)
-			n = MINTIMER;
-		else if (n > MAXTIMER)
-			n = MAXTIMER;
-		d->mintimer += (n - d->mintimer) >> 1;
-	} else if (n < d->mintimer)
-		n = d->mintimer;
-	else if (n > MAXTIMER)
-		n = MAXTIMER;
-
-	/* g == .25; cf. Congestion Avoidance and Control, Jacobson & Karels; 1988 */
-	n -= d->rttavg;
-	d->rttavg += n >> 2;
+
+	/* cf. Congestion Avoidance and Control, Jacobson & Karels, 1988 */
+	n -= d->rttavg >> RTTSCALE;
+	d->rttavg += n;
+	if (n < 0)
+		n = -n;
+	n -= d->rttdev >> RTTDSCALE;
+	d->rttdev += n;
+
+	if (!t || t->maxout >= t->nframes)
+		return;
+	if (t->maxout < t->ssthresh)
+		t->maxout += 1;
+	else if (t->nout == t->maxout && t->next_cwnd-- == 0) {
+		t->maxout += 1;
+		t->next_cwnd = t->maxout;
+	}
 }
 
 static struct aoetgt *
@@ -1147,7 +1172,6 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 	struct aoedev *d;
 	struct aoe_hdr *h;
 	struct frame *f;
-	struct aoetgt *t;
 	u32 n;
 	ulong flags;
 	char ebuf[128];
@@ -1168,23 +1192,28 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 
 	n = be32_to_cpu(get_unaligned(&h->tag));
 	f = getframe(d, n);
-	if (f == NULL) {
-		calc_rttavg(d, -tsince(n));
-		spin_unlock_irqrestore(&d->lock, flags);
-		aoedev_put(d);
-		snprintf(ebuf, sizeof ebuf,
-			"%15s e%d.%d    tag=%08x@%08lx\n",
-			"unexpected rsp",
-			get_unaligned_be16(&h->major),
-			h->minor,
-			get_unaligned_be32(&h->tag),
-			jiffies);
-		aoechr_error(ebuf);
-		return skb;
+	if (f) {
+		calc_rttavg(d, f->t, tsince(n));
+		f->t->nout--;
+	} else {
+		f = getframe_deferred(d, n);
+		if (f) {
+			calc_rttavg(d, NULL, tsince(n));
+		} else {
+			calc_rttavg(d, NULL, tsince(n));
+			spin_unlock_irqrestore(&d->lock, flags);
+			aoedev_put(d);
+			snprintf(ebuf, sizeof(ebuf),
+				 "%15s e%d.%d    tag=%08x@%08lx\n",
+				 "unexpected rsp",
+				 get_unaligned_be16(&h->major),
+				 h->minor,
+				 get_unaligned_be32(&h->tag),
+				 jiffies);
+			aoechr_error(ebuf);
+			return skb;
+		}
 	}
-	t = f->t;
-	calc_rttavg(d, tsince(f->tag));
-	t->nout--;
 	aoecmd_work(d);
 
 	spin_unlock_irqrestore(&d->lock, flags);
@@ -1241,7 +1270,8 @@ aoecmd_ata_id(struct aoedev *d)
 
 	skb->dev = t->ifp->nd;
 
-	d->rttavg = MAXTIMER;
+	d->rttavg = RTTAVG_INIT;
+	d->rttdev = RTTDEV_INIT;
 	d->timer.function = rexmit_timer;
 
 	return skb_clone(skb, GFP_ATOMIC);
@@ -1273,7 +1303,7 @@ addtgt(struct aoedev *d, char *addr, ulo
 	t->d = d;
 	memcpy(t->addr, addr, sizeof t->addr);
 	t->ifp = t->ifs;
-	t->maxout = t->nframes;
+	aoecmd_wreset(t);
 	INIT_LIST_HEAD(&t->ffree);
 	return *tt = t;
 }
@@ -1382,7 +1412,7 @@ aoecmd_cfg_rsp(struct sk_buff *skb)
 	if (t) {
 		t->nframes = n;
 		if (n < t->maxout)
-			t->maxout = n;
+			aoecmd_wreset(t);
 	} else {
 		t = addtgt(d, h->src, n);
 		if (!t)
@@ -1412,17 +1442,26 @@ bail:
 }
 
 void
+aoecmd_wreset(struct aoetgt *t)
+{
+	t->maxout = 1;
+	t->ssthresh = t->nframes / 2;
+	t->next_cwnd = t->nframes;
+}
+
+void
 aoecmd_cleanslate(struct aoedev *d)
 {
 	struct aoetgt **t, **te;
 
-	d->mintimer = MINTIMER;
+	d->rttavg = RTTAVG_INIT;
+	d->rttdev = RTTDEV_INIT;
 	d->maxbcnt = 0;
 
 	t = d->targets;
 	te = t + NTARGETS;
 	for (; t < te && *t; t++)
-		(*t)->maxout = (*t)->nframes;
+		aoecmd_wreset(*t);
 }
 
 void
diff -puN drivers/block/aoe/aoedev.c~aoe-improve-network-congestion-handling drivers/block/aoe/aoedev.c
--- a/drivers/block/aoe/aoedev.c~aoe-improve-network-congestion-handling
+++ a/drivers/block/aoe/aoedev.c
@@ -198,7 +198,7 @@ aoedev_downdev(struct aoedev *d)
 	tt = d->targets;
 	te = tt + NTARGETS;
 	for (; tt < te && (t = *tt); tt++) {
-		t->maxout = t->nframes;
+		aoecmd_wreset(t);
 		t->nout = 0;
 	}
 
@@ -391,10 +391,12 @@ aoedev_by_aoeaddr(ulong maj, int min, in
 	d->ref = 1;
 	for (i = 0; i < NFACTIVE; i++)
 		INIT_LIST_HEAD(&d->factive[i]);
+	INIT_LIST_HEAD(&d->rexmitq);
 	d->sysminor = sysminor;
 	d->aoemajor = maj;
 	d->aoeminor = min;
-	d->mintimer = MINTIMER;
+	d->rttavg = RTTAVG_INIT;
+	d->rttdev = RTTDEV_INIT;
 	d->next = devlist;
 	devlist = d;
  out:
_

Patches currently in -mm which might be from ecashin@coraid.com are

origin.patch
linux-next.patch

