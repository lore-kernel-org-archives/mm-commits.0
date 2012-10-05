From: akpm@linux-foundation.org
Subject: [merged] aoe-use-packets-that-work-with-the-smallest-mtu-local-interface.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:21:14 -0700
Message-ID: <20121005202115.22DBD5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:53149 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab2JEUVR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:21:17 -0400
Received: by mail-wi0-f202.google.com with SMTP id hr7so58063wib.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:21:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aoe: use packets that work with the smallest-MTU local interface
has been removed from the -mm tree.  Its filename was
     aoe-use-packets-that-work-with-the-smallest-mtu-local-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: use packets that work with the smallest-MTU local interface

Users with several network interfaces dedicated to AoE generally do not
configure them to support different-sized AoE data payloads on purpose.

For a given AoE target, there will be a set of local network interfaces
that can reach it.  Using only the payload that will fit in the
smallest-sized MTU of all those local interfaces greatly simplifies the
driver, especially in failure scenarios.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoe.h    |    7 -
 drivers/block/aoe/aoecmd.c |  151 +++++++++++++++++++----------------
 2 files changed, 87 insertions(+), 71 deletions(-)

diff -puN drivers/block/aoe/aoe.h~aoe-use-packets-that-work-with-the-smallest-mtu-local-interface drivers/block/aoe/aoe.h
--- a/drivers/block/aoe/aoe.h~aoe-use-packets-that-work-with-the-smallest-mtu-local-interface
+++ a/drivers/block/aoe/aoe.h
@@ -125,9 +125,8 @@ struct frame {
 
 struct aoeif {
 	struct net_device *nd;
-	unsigned char lost;
-	unsigned char lostjumbo;
-	ushort maxbcnt;
+	ulong lost;
+	int bcnt;
 };
 
 struct aoetgt {
@@ -144,6 +143,7 @@ struct aoetgt {
 	u16 useme;
 	ulong falloc;
 	ulong lastwadj;		/* last window adjustment */
+	int minbcnt;
 	int wpkts, rpkts;
 };
 
@@ -172,6 +172,7 @@ struct aoedev {
 		struct bio *nxbio;
 		struct request *rq;
 	} ip;
+	ulong maxbcnt;
 	struct aoetgt *targets[NTARGETS];
 	struct aoetgt **tgt;	/* target in use when working */
 	struct aoetgt *htgt;	/* target needing rexmit assistance */
diff -puN drivers/block/aoe/aoecmd.c~aoe-use-packets-that-work-with-the-smallest-mtu-local-interface drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~aoe-use-packets-that-work-with-the-smallest-mtu-local-interface
+++ a/drivers/block/aoe/aoecmd.c
@@ -119,16 +119,18 @@ put_lba(struct aoe_atahdr *ah, sector_t 
 	ah->lba5 = lba >>= 8;
 }
 
-static void
+static struct aoeif *
 ifrotate(struct aoetgt *t)
 {
-	t->ifp++;
-	if (t->ifp >= &t->ifs[NAOEIFS] || t->ifp->nd == NULL)
-		t->ifp = t->ifs;
-	if (t->ifp->nd == NULL) {
-		printk(KERN_INFO "aoe: no interface to rotate to\n");
-		BUG();
-	}
+	struct aoeif *ifp;
+
+	ifp = t->ifp;
+	ifp++;
+	if (ifp >= &t->ifs[NAOEIFS] || ifp->nd == NULL)
+		ifp = t->ifs;
+	if (ifp->nd == NULL)
+		return NULL;
+	return t->ifp = ifp;
 }
 
 static void
@@ -232,8 +234,8 @@ newframe(struct aoedev *d)
 		&& t->ifp->nd) {
 			f = newtframe(d, t);
 			if (f) {
-				d->tgt = tt;
 				ifrotate(t);
+				d->tgt = tt;
 				return f;
 			}
 		}
@@ -300,7 +302,7 @@ aoecmd_ata_rw(struct aoedev *d)
 		return 0;
 	t = *d->tgt;
 	bv = buf->bv;
-	bcnt = t->ifp->maxbcnt;
+	bcnt = d->maxbcnt;
 	if (bcnt == 0)
 		bcnt = DEFAULTBCNT;
 	if (bcnt > buf->resid)
@@ -431,9 +433,14 @@ resend(struct aoedev *d, struct frame *f
 	u32 n;
 
 	t = f->t;
-	ifrotate(t);
 	n = newtag(t);
 	skb = f->skb;
+	if (ifrotate(t) == NULL) {
+		/* probably can't happen, but set it up to fail anyway */
+		pr_info("aoe: resend: no interfaces to rotate to.\n");
+		ktcomplete(f, NULL);
+		return;
+	}
 	h = (struct aoe_hdr *) skb_mac_header(skb);
 	ah = (struct aoe_atahdr *) (h+1);
 
@@ -483,21 +490,6 @@ getif(struct aoetgt *t, struct net_devic
 	return NULL;
 }
 
-static struct aoeif *
-addif(struct aoetgt *t, struct net_device *nd)
-{
-	struct aoeif *p;
-
-	p = getif(t, NULL);
-	if (!p)
-		return NULL;
-	p->nd = nd;
-	p->maxbcnt = DEFAULTBCNT;
-	p->lost = 0;
-	p->lostjumbo = 0;
-	return p;
-}
-
 static void
 ejectif(struct aoetgt *t, struct aoeif *ifp)
 {
@@ -546,7 +538,11 @@ sthtith(struct aoedev *d)
 			resend(d, nf);
 		}
 	}
-	/* he's clean, he's useless.  take away his interfaces */
+	/* We've cleaned up the outstanding so take away his
+	 * interfaces so he won't be used.  We should remove him from
+	 * the target array here, but cleaning up a target is
+	 * involved.  PUNT!
+	 */
 	memset(ht->ifs, 0, sizeof ht->ifs);
 	d->htgt = NULL;
 	return 1;
@@ -1015,11 +1011,8 @@ noskb:	if (buf)
 	case ATA_CMD_PIO_WRITE_EXT:
 		spin_lock_irq(&d->lock);
 		ifp = getif(t, skb->dev);
-		if (ifp) {
+		if (ifp)
 			ifp->lost = 0;
-			if (n > DEFAULTBCNT)
-				ifp->lostjumbo = 0;
-		}
 		if (d->htgt == t) /* I'll help myself, thank you. */
 			d->htgt = NULL;
 		spin_unlock_irq(&d->lock);
@@ -1292,6 +1285,56 @@ addtgt(struct aoedev *d, char *addr, ulo
 	return *tt = t;
 }
 
+static void
+setdbcnt(struct aoedev *d)
+{
+	struct aoetgt **t, **e;
+	int bcnt = 0;
+
+	t = d->targets;
+	e = t + NTARGETS;
+	for (; t < e && *t; t++)
+		if (bcnt == 0 || bcnt > (*t)->minbcnt)
+			bcnt = (*t)->minbcnt;
+	if (bcnt != d->maxbcnt) {
+		d->maxbcnt = bcnt;
+		pr_info("aoe: e%ld.%d: setting %d byte data frames\n",
+			d->aoemajor, d->aoeminor, bcnt);
+	}
+}
+
+static void
+setifbcnt(struct aoetgt *t, struct net_device *nd, int bcnt)
+{
+	struct aoedev *d;
+	struct aoeif *p, *e;
+	int minbcnt;
+
+	d = t->d;
+	minbcnt = bcnt;
+	p = t->ifs;
+	e = p + NAOEIFS;
+	for (; p < e; p++) {
+		if (p->nd == NULL)
+			break;		/* end of the valid interfaces */
+		if (p->nd == nd) {
+			p->bcnt = bcnt;	/* we're updating */
+			nd = NULL;
+		} else if (minbcnt > p->bcnt)
+			minbcnt = p->bcnt; /* find the min interface */
+	}
+	if (nd) {
+		if (p == e) {
+			pr_err("aoe: device setifbcnt failure; too many interfaces.\n");
+			return;
+		}
+		p->nd = nd;
+		p->bcnt = bcnt;
+	}
+	t->minbcnt = minbcnt;
+	setdbcnt(d);
+}
+
 void
 aoecmd_cfg_rsp(struct sk_buff *skb)
 {
@@ -1299,7 +1342,6 @@ aoecmd_cfg_rsp(struct sk_buff *skb)
 	struct aoe_hdr *h;
 	struct aoe_cfghdr *ch;
 	struct aoetgt *t;
-	struct aoeif *ifp;
 	ulong flags, sysminor, aoemajor;
 	struct sk_buff *sl;
 	struct sk_buff_head queue;
@@ -1345,32 +1387,13 @@ aoecmd_cfg_rsp(struct sk_buff *skb)
 		if (!t)
 			goto bail;
 	}
-	ifp = getif(t, skb->dev);
-	if (!ifp) {
-		ifp = addif(t, skb->dev);
-		if (!ifp) {
-			printk(KERN_INFO
-				"aoe: device addif failure; "
-				"too many interfaces?\n");
-			goto bail;
-		}
-	}
-	if (ifp->maxbcnt) {
-		n = ifp->nd->mtu;
-		n -= sizeof (struct aoe_hdr) + sizeof (struct aoe_atahdr);
-		n /= 512;
-		if (n > ch->scnt)
-			n = ch->scnt;
-		n = n ? n * 512 : DEFAULTBCNT;
-		if (n != ifp->maxbcnt) {
-			printk(KERN_INFO
-				"aoe: e%ld.%d: setting %d%s%s:%pm\n",
-				d->aoemajor, d->aoeminor, n,
-				" byte data frames on ", ifp->nd->name,
-				t->addr);
-			ifp->maxbcnt = n;
-		}
-	}
+	n = skb->dev->mtu;
+	n -= sizeof(struct aoe_hdr) + sizeof(struct aoe_atahdr);
+	n /= 512;
+	if (n > ch->scnt)
+		n = ch->scnt;
+	n = n ? n * 512 : DEFAULTBCNT;
+	setifbcnt(t, skb->dev, n);
 
 	/* don't change users' perspective */
 	if (d->nopen == 0) {
@@ -1391,22 +1414,14 @@ void
 aoecmd_cleanslate(struct aoedev *d)
 {
 	struct aoetgt **t, **te;
-	struct aoeif *p, *e;
 
 	d->mintimer = MINTIMER;
+	d->maxbcnt = 0;
 
 	t = d->targets;
 	te = t + NTARGETS;
-	for (; t < te && *t; t++) {
+	for (; t < te && *t; t++)
 		(*t)->maxout = (*t)->nframes;
-		p = (*t)->ifs;
-		e = p + NAOEIFS;
-		for (; p < e; p++) {
-			p->lostjumbo = 0;
-			p->lost = 0;
-			p->maxbcnt = DEFAULTBCNT;
-		}
-	}
 }
 
 void
_

Patches currently in -mm which might be from ecashin@coraid.com are

origin.patch

