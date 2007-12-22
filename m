From: akpm@linux-foundation.org
Subject: + aoe-dynamically-allocate-a-capped-number-of-skbs-when-necessary.patch added to -mm tree
Date: Fri, 21 Dec 2007 22:03:51 -0800
Message-ID: <200712220603.lBM63qXj020122@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53986 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751481AbXLVGD4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 22 Dec 2007 01:03:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ecashin@coraid.com, greg@kroah.com


The patch titled
     aoe: dynamically allocate a capped number of skbs when necessary
has been added to the -mm tree.  Its filename is
     aoe-dynamically-allocate-a-capped-number-of-skbs-when-necessary.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: aoe: dynamically allocate a capped number of skbs when necessary
From: "Ed L. Cashin" <ecashin@coraid.com>

What this Patch Does

  Even before this recent series of 12 patches to 2.6.22-rc4, the aoe
  driver was reusing a small set of skbs that were allocated once and
  were only used for outbound AoE commands.

  The network layer cannot be allowed to put_page on the data that is
  still associated with a bio we haven't returned to the block layer,
  so the aoe driver (even before the patch under discussion) is still
  the owner of skbs that have been handed to the network layer for
  transmission.  We need to keep track of these skbs so that we can
  free them, but by tracking them, we can also easily re-use them.

  The new patch was a response to the behavior of certain network
  drivers.  We cannot reuse an skb that the network driver still has
  in its transmit ring.  Network drivers can defer transmit ring
  cleanup and then use the state in the skb to determine how many data
  segments to clean up in its transmit ring.  The tg3 driver is one
  driver that behaves in this way.

  When the network driver defers cleanup of its transmit ring, the aoe
  driver can find itself in a situation where it would like to send an
  AoE command, and the AoE target is ready for more work, but the
  network driver still has all of the pre-allocated skbs.  In that
  case, the new patch just calls alloc_skb, as you'd expect.

  We don't want to get carried away, though.  We try not to do
  excessive allocation in the write path, so we cap the number of skbs
  we dynamically allocate.

  Probably calling it a "dynamic pool" is misleading.  We were already
  trying to use a small fixed-size set of pre-allocated skbs before
  this patch, and this patch just provides a little headroom (with a
  ceiling, though) to accomodate network drivers that hang onto skbs,
  by allocating when needed.  The d->skbpool_hd list of allocated skbs
  is necessary so that we can free them later.

  We didn't notice the need for this headroom until AoE targets got
  fast enough.

Alternatives

  If the network layer never did a put_page on the pages in the bio's
  we get from the block layer, then it would be possible for us to
  hand skbs to the network layer and forget about them, allowing the
  network layer to free skbs itself (and thereby calling our own
  skb->destructor callback function if we needed that).  In that case
  we could get rid of the pre-allocated skbs and also the
  d->skbpool_hd, instead just calling alloc_skb every time we wanted
  to transmit a packet.  The slab allocator would effectively maintain
  the list of skbs.

  Besides a loss of CPU cache locality, the main concern with that
  approach the danger that it would increase the likelihood of
  deadlock when VM is trying to free pages by writing dirty data from
  the page cache through the aoe driver out to persistent storage on
  an AoE device.  Right now we have a situation where we have
  pre-allocation that corresponds to how much we use, which seems
  ideal.

  Of course, there's still the separate issue of receiving the packets
  that tell us that a write has successfully completed on the AoE
  target.  When memory is low and VM is using AoE to flush dirty data
  to free up pages, it would be perfect if there were a way for us to
  register a fast callback that could recognize write command
  completion responses.  But I don't think the current problems with
  the receive side of the situation are a justification for
  exacerbating the problem on the transmit side.

Signed-off-by: Ed L. Cashin <ecashin@coraid.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoe.h    |    5 +
 drivers/block/aoe/aoecmd.c |  117 ++++++++++++++++++++++++-----------
 drivers/block/aoe/aoedev.c |   52 +++++++++++++--
 3 files changed, 133 insertions(+), 41 deletions(-)

diff -puN drivers/block/aoe/aoe.h~aoe-dynamically-allocate-a-capped-number-of-skbs-when-necessary drivers/block/aoe/aoe.h
--- a/drivers/block/aoe/aoe.h~aoe-dynamically-allocate-a-capped-number-of-skbs-when-necessary
+++ a/drivers/block/aoe/aoe.h
@@ -89,6 +89,7 @@ enum {
 	MIN_BUFS = 16,
 	NTARGETS = 8,
 	NAOEIFS = 8,
+	NSKBPOOLMAX = 128,
 
 	TIMERTICK = HZ / 10,
 	MINTIMER = HZ >> 2,
@@ -138,6 +139,7 @@ struct aoetgt {
 	u16 useme;
 	ulong lastwadj;		/* last window adjustment */
 	int wpkts, rpkts;
+	int dataref;
 };
 
 struct aoedev {
@@ -159,6 +161,9 @@ struct aoedev {
 	spinlock_t lock;
 	struct sk_buff *sendq_hd; /* packets needing to be sent, list head */
 	struct sk_buff *sendq_tl;
+	struct sk_buff *skbpool_hd;
+	struct sk_buff *skbpool_tl;
+	int nskbpool;
 	mempool_t *bufpool;	/* for deadlock-free Buf allocation */
 	struct list_head bufq;	/* queue of bios to work on */
 	struct buf *inprocess;	/* the one we're currently working on */
diff -puN drivers/block/aoe/aoecmd.c~aoe-dynamically-allocate-a-capped-number-of-skbs-when-necessary drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~aoe-dynamically-allocate-a-capped-number-of-skbs-when-necessary
+++ a/drivers/block/aoe/aoecmd.c
@@ -106,45 +106,104 @@ ifrotate(struct aoetgt *t)
 	}
 }
 
+static void
+skb_pool_put(struct aoedev *d, struct sk_buff *skb)
+{
+	if (!d->skbpool_hd)
+		d->skbpool_hd = skb;
+	else
+		d->skbpool_tl->next = skb;
+	d->skbpool_tl = skb;
+}
+
+static struct sk_buff *
+skb_pool_get(struct aoedev *d)
+{
+	struct sk_buff *skb;
+
+	skb = d->skbpool_hd;
+	if (skb && atomic_read(&skb_shinfo(skb)->dataref) == 1) {
+		d->skbpool_hd = skb->next;
+		skb->next = NULL;
+		return skb;
+	}
+	if (d->nskbpool < NSKBPOOLMAX
+	&& (skb = new_skb(ETH_ZLEN))) {
+		d->nskbpool++;
+		return skb;
+	}
+	return NULL;
+}
+
+/* freeframe is where we do our load balancing so it's a little hairy. */
 static struct frame *
 freeframe(struct aoedev *d)
 {
-	struct frame *f, *e;
+	struct frame *f, *e, *rf;
 	struct aoetgt **t;
-	ulong n;
+	struct sk_buff *skb;
 
 	if (d->targets[0] == NULL) {	/* shouldn't happen, but I'm paranoid */
 		printk(KERN_ERR "aoe: NULL TARGETS!\n");
 		return NULL;
 	}
-	t = d->targets;
-	do {
-		if (t != d->htgt
-		&& (*t)->ifp->nd
-		&& (*t)->nout < (*t)->maxout) {
-			n = (*t)->nframes;
+	t = d->tgt;
+	t++;
+	if (t >= &d->targets[NTARGETS] || !*t)
+		t = d->targets;
+	for (;;) {
+		if ((*t)->nout < (*t)->maxout
+		&& t != d->htgt
+		&& (*t)->ifp->nd) {
+			rf = NULL;
 			f = (*t)->frames;
-			e = f + n;
+			e = f + (*t)->nframes;
 			for (; f < e; f++) {
 				if (f->tag != FREETAG)
 					continue;
-				if (atomic_read(&skb_shinfo(f->skb)->dataref)
+				skb = f->skb;
+				if (!skb
+				&& !(f->skb = skb = new_skb(ETH_ZLEN)))
+					continue;
+				if (atomic_read(&skb_shinfo(skb)->dataref)
 					!= 1) {
-					n--;
+					if (!rf)
+						rf = f;
 					continue;
 				}
-				skb_shinfo(f->skb)->nr_frags = 0;
-				f->skb->data_len = 0;
-				skb_trim(f->skb, 0);
+gotone:				skb_shinfo(skb)->nr_frags = skb->data_len = 0;
+				skb_trim(skb, 0);
 				d->tgt = t;
 				ifrotate(*t);
 				return f;
 			}
-			if (n == 0)	/* slow polling network card */
+			/* Work can be done, but the network layer is
+			   holding our precious packets.  Try to grab
+			   one from the pool. */
+			f = rf;
+			if (f == NULL) {	/* more paranoia */
+				printk(KERN_ERR
+					"aoe: freeframe: %s.\n",
+					"unexpected null rf");
+				d->flags |= DEVFL_KICKME;
+				return NULL;
+			}
+			skb = skb_pool_get(d);
+			if (skb) {
+				skb_pool_put(d, f->skb);
+				f->skb = skb;
+				goto gotone;
+			}
+			(*t)->dataref++;
+			if ((*t)->nout == 0)
 				d->flags |= DEVFL_KICKME;
 		}
+		if (t == d->tgt)	/* we've looped and found nada */
+			break;
 		t++;
-	} while (t < &d->targets[NTARGETS] && *t);
+		if (t >= &d->targets[NTARGETS] || !*t)
+			t = d->targets;
+	}
 	return NULL;
 }
 
@@ -894,33 +953,23 @@ addtgt(struct aoedev *d, char *addr, ulo
 		return NULL;
 
 	t = kcalloc(1, sizeof *t, GFP_ATOMIC);
+	if (!t)
+		return NULL;
 	f = kcalloc(nframes, sizeof *f, GFP_ATOMIC);
-	if (!t || !f)
-		goto bail;
+	if (!f) {
+		kfree(t);
+		return NULL;
+	}
+
 	t->nframes = nframes;
 	t->frames = f;
 	e = f + nframes;
-	for (; f < e; f++) {
+	for (; f < e; f++)
 		f->tag = FREETAG;
-		f->skb = new_skb(ETH_ZLEN);
-		if (!f->skb)
-			break;
-	}
-	if (f != e) {
-		while (f > t->frames) {
-			f--;
-			dev_kfree_skb(f->skb);
-		}
-		goto bail;
-	}
 	memcpy(t->addr, addr, sizeof t->addr);
 	t->ifp = t->ifs;
 	t->maxout = t->nframes;
 	return *tt = t;
-bail:
-	kfree(t);
-	kfree(f);
-	return NULL;
 }
 
 void
diff -puN drivers/block/aoe/aoedev.c~aoe-dynamically-allocate-a-capped-number-of-skbs-when-necessary drivers/block/aoe/aoedev.c
--- a/drivers/block/aoe/aoedev.c~aoe-dynamically-allocate-a-capped-number-of-skbs-when-necessary
+++ a/drivers/block/aoe/aoedev.c
@@ -7,11 +7,13 @@
 #include <linux/hdreg.h>
 #include <linux/blkdev.h>
 #include <linux/netdevice.h>
+#include <linux/delay.h>
 #include "aoe.h"
 
 static void dummy_timer(ulong);
 static void aoedev_freedev(struct aoedev *);
-static void freetgt(struct aoetgt *t);
+static void freetgt(struct aoedev *d, struct aoetgt *t);
+static void skbpoolfree(struct aoedev *d);
 
 static struct aoedev *devlist;
 static spinlock_t devlist_lock;
@@ -125,9 +127,10 @@ aoedev_freedev(struct aoedev *d)
 	t = d->targets;
 	e = t + NTARGETS;
 	for (; t < e && *t; t++)
-		freetgt(*t);
+		freetgt(d, *t);
 	if (d->bufpool)
 		mempool_destroy(d->bufpool);
+	skbpoolfree(d);
 	kfree(d);
 }
 
@@ -176,6 +179,43 @@ aoedev_flush(const char __user *str, siz
 	return 0;
 }
 
+/* I'm not really sure that this is a realistic problem, but if the
+network driver goes gonzo let's just leak memory after complaining. */
+static void
+skbfree(struct sk_buff *skb)
+{
+	enum { Sms = 100, Tms = 3*1000};
+	int i = Tms / Sms;
+
+	if (skb == NULL)
+		return;
+	while (atomic_read(&skb_shinfo(skb)->dataref) != 1 && i-- > 0)
+		msleep(Sms);
+	if (i <= 0) {
+		printk(KERN_ERR
+			"aoe: %s holds ref: %s\n",
+			skb->dev ? skb->dev->name : "netif",
+			"cannot free skb -- memory leaked.");
+		return;
+	}
+	skb_shinfo(skb)->nr_frags = skb->data_len = 0;
+	skb_trim(skb, 0);
+	dev_kfree_skb(skb);
+}
+
+static void
+skbpoolfree(struct aoedev *d)
+{
+	struct sk_buff *skb;
+
+	while ((skb = d->skbpool_hd)) {
+		d->skbpool_hd = skb->next;
+		skb->next = NULL;
+		skbfree(skb);
+	}
+	d->skbpool_tl = NULL;
+}
+
 /* find it or malloc it */
 struct aoedev *
 aoedev_by_sysminor_m(ulong sysminor)
@@ -215,16 +255,14 @@ aoedev_by_sysminor_m(ulong sysminor)
 }
 
 static void
-freetgt(struct aoetgt *t)
+freetgt(struct aoedev *d, struct aoetgt *t)
 {
 	struct frame *f, *e;
 
 	f = t->frames;
 	e = f + t->nframes;
-	for (; f < e; f++) {
-		skb_shinfo(f->skb)->nr_frags = 0;
-		dev_kfree_skb(f->skb);
-	}
+	for (; f < e; f++)
+		skbfree(f->skb);
 	kfree(t->frames);
 	kfree(t);
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
