From: akpm@linux-foundation.org
Subject: + aoe-commands-in-retransmit-queue-use-new-destination-on-failure.patch added to -mm tree
Date: Thu, 08 Nov 2012 11:26:58 -0800
Message-ID: <20121108192659.90BB120004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:36632 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756681Ab2KHT1B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Nov 2012 14:27:01 -0500
Received: by mail-la0-f74.google.com with SMTP id j13so204056lah.1
        for <mm-commits@vger.kernel.org>; Thu, 08 Nov 2012 11:27:00 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ecashin@coraid.com


The patch titled
     Subject: aoe: commands in retransmit queue use new destination on failure
has been added to the -mm tree.  Its filename is
     aoe-commands-in-retransmit-queue-use-new-destination-on-failure.patch

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
Subject: aoe: commands in retransmit queue use new destination on failure

When one remote MAC address isn't working as a destination for AoE
commands, the frames used to track information associated with the AoE
commands are moved to a new aoetgt (defined by the tuple of {AoE major,
AoE minor, target MAC address}).

This patch makes sure that the frames on the queue for retransmits that
need to be done are updated to use the new destination, so that
retransmits will be sent through a working network path.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoe.h    |    1 
 drivers/block/aoe/aoecmd.c |   75 ++++++++++++++++++++++++-----------
 drivers/block/aoe/aoedev.c |   32 +++++++++-----
 3 files changed, 75 insertions(+), 33 deletions(-)

diff -puN drivers/block/aoe/aoe.h~aoe-commands-in-retransmit-queue-use-new-destination-on-failure drivers/block/aoe/aoe.h
--- a/drivers/block/aoe/aoe.h~aoe-commands-in-retransmit-queue-use-new-destination-on-failure
+++ a/drivers/block/aoe/aoe.h
@@ -108,6 +108,7 @@ struct frame {
 	struct timeval sent;	/* high-res time packet was sent */
 	u32 sent_jiffs;		/* low-res jiffies-based sent time */
 	ulong waited;
+	ulong waited_total;
 	struct aoetgt *t;		/* parent target I belong to */
 	sector_t lba;
 	struct sk_buff *skb;		/* command skb freed on module exit */
diff -puN drivers/block/aoe/aoecmd.c~aoe-commands-in-retransmit-queue-use-new-destination-on-failure drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~aoe-commands-in-retransmit-queue-use-new-destination-on-failure
+++ a/drivers/block/aoe/aoecmd.c
@@ -352,6 +352,7 @@ aoecmd_ata_rw(struct aoedev *d)
 	fhash(f);
 	t->nout++;
 	f->waited = 0;
+	f->waited_total = 0;
 	f->buf = buf;
 	f->bcnt = bcnt;
 	f->lba = buf->sector;
@@ -556,46 +557,69 @@ ejectif(struct aoetgt *t, struct aoeif *
 	dev_put(nd);
 }
 
+static struct frame *
+reassign_frame(struct list_head *pos)
+{
+	struct frame *f;
+	struct frame *nf;
+	struct sk_buff *skb;
+
+	f = list_entry(pos, struct frame, head);
+	nf = newframe(f->t->d);
+	if (!nf)
+		return NULL;
+
+	list_del(pos);
+
+	skb = nf->skb;
+	nf->skb = f->skb;
+	nf->buf = f->buf;
+	nf->bcnt = f->bcnt;
+	nf->lba = f->lba;
+	nf->bv = f->bv;
+	nf->bv_off = f->bv_off;
+	nf->waited = 0;
+	nf->waited_total = f->waited_total;
+	nf->sent = f->sent;
+	f->skb = skb;
+	aoe_freetframe(f);
+	f->t->nout--;
+	nf->t->nout++;
+
+	return nf;
+}
+
 static int
 sthtith(struct aoedev *d)
 {
 	struct frame *f, *nf;
 	struct list_head *nx, *pos, *head;
-	struct sk_buff *skb;
 	struct aoetgt *ht = d->htgt;
 	int i;
 
+	/* look through the active and pending retransmit frames */
 	for (i = 0; i < NFACTIVE; i++) {
 		head = &d->factive[i];
 		list_for_each_safe(pos, nx, head) {
 			f = list_entry(pos, struct frame, head);
 			if (f->t != ht)
 				continue;
-
-			nf = newframe(d);
+			nf = reassign_frame(pos);
 			if (!nf)
 				return 0;
-
-			/* remove frame from active list */
-			list_del(pos);
-
-			/* reassign all pertinent bits to new outbound frame */
-			skb = nf->skb;
-			nf->skb = f->skb;
-			nf->buf = f->buf;
-			nf->bcnt = f->bcnt;
-			nf->lba = f->lba;
-			nf->bv = f->bv;
-			nf->bv_off = f->bv_off;
-			nf->waited = 0;
-			nf->sent_jiffs = f->sent_jiffs;
-			f->skb = skb;
-			aoe_freetframe(f);
-			ht->nout--;
-			nf->t->nout++;
 			resend(d, nf);
 		}
 	}
+	head = &d->rexmitq;
+	list_for_each_safe(pos, nx, head) {
+		f = list_entry(pos, struct frame, head);
+		if (f->t != ht)
+			continue;
+		nf = reassign_frame(pos);
+		if (!nf)
+			return 0;
+		resend(d, nf);
+	}
 	/* We've cleaned up the outstanding so take away his
 	 * interfaces so he won't be used.  We should remove him from
 	 * the target array here, but cleaning up a target is
@@ -612,6 +636,7 @@ rexmit_deferred(struct aoedev *d)
 	struct aoetgt *t;
 	struct frame *f;
 	struct list_head *pos, *nx, *head;
+	int since;
 
 	head = &d->rexmitq;
 	list_for_each_safe(pos, nx, head) {
@@ -621,6 +646,9 @@ rexmit_deferred(struct aoedev *d)
 			continue;
 		list_del(pos);
 		t->nout++;
+		since = tsince_hr(f);
+		f->waited += since;
+		f->waited_total += since;
 		resend(d, f);
 	}
 }
@@ -637,6 +665,7 @@ rexmit_timer(ulong vp)
 	register long timeout;
 	ulong flags, n;
 	int i;
+	int since;
 
 	d = (struct aoedev *) vp;
 
@@ -669,7 +698,8 @@ rexmit_timer(ulong vp)
 	while (!list_empty(&flist)) {
 		pos = flist.next;
 		f = list_entry(pos, struct frame, head);
-		n = f->waited += tsince_hr(f);
+		since = tsince_hr(f);
+		n = f->waited_total + since;
 		n /= USEC_PER_SEC;
 		if (n > aoe_deadsecs) {
 			/* Waited too long.  Device failure.
@@ -1301,6 +1331,7 @@ aoecmd_ata_id(struct aoedev *d)
 	fhash(f);
 	t->nout++;
 	f->waited = 0;
+	f->waited_total = 0;
 
 	/* set up ata header */
 	ah->scnt = 1;
diff -puN drivers/block/aoe/aoedev.c~aoe-commands-in-retransmit-queue-use-new-destination-on-failure drivers/block/aoe/aoedev.c
--- a/drivers/block/aoe/aoedev.c~aoe-commands-in-retransmit-queue-use-new-destination-on-failure
+++ a/drivers/block/aoe/aoedev.c
@@ -170,30 +170,40 @@ aoe_failip(struct aoedev *d)
 		aoe_end_request(d, rq, 0);
 }
 
+static void
+downdev_frame(struct list_head *pos)
+{
+	struct frame *f;
+
+	f = list_entry(pos, struct frame, head);
+	list_del(pos);
+	if (f->buf) {
+		f->buf->nframesout--;
+		aoe_failbuf(f->t->d, f->buf);
+	}
+	aoe_freetframe(f);
+}
+
 void
 aoedev_downdev(struct aoedev *d)
 {
 	struct aoetgt *t, **tt, **te;
-	struct frame *f;
 	struct list_head *head, *pos, *nx;
 	struct request *rq;
 	int i;
 
 	d->flags &= ~DEVFL_UP;
 
-	/* clean out active buffers */
+	/* clean out active and to-be-retransmitted buffers */
 	for (i = 0; i < NFACTIVE; i++) {
 		head = &d->factive[i];
-		list_for_each_safe(pos, nx, head) {
-			f = list_entry(pos, struct frame, head);
-			list_del(pos);
-			if (f->buf) {
-				f->buf->nframesout--;
-				aoe_failbuf(d, f->buf);
-			}
-			aoe_freetframe(f);
-		}
+		list_for_each_safe(pos, nx, head)
+			downdev_frame(pos);
 	}
+	head = &d->rexmitq;
+	list_for_each_safe(pos, nx, head)
+		downdev_frame(pos);
+
 	/* reset window dressings */
 	tt = d->targets;
 	te = tt + NTARGETS;
_

Patches currently in -mm which might be from ecashin@coraid.com are

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
aoe-avoid-running-request-handler-on-plugged-queue.patch
aoe-provide-ata-identify-device-content-to-user-on-request.patch
aoe-improve-network-congestion-handling.patch
aoe-err-device-include-mac-addresses-for-unexpected-responses.patch
aoe-manipulate-aoedev-network-stats-under-lock.patch
aoe-use-high-resolution-rtts-with-fallback-to-low-res.patch
aoe-commands-in-retransmit-queue-use-new-destination-on-failure.patch
aoe-update-driver-internal-version-to-64.patch

