From: akpm@linux-foundation.org
Subject: + aoe-use-high-resolution-rtts-with-fallback-to-low-res.patch added to -mm tree
Date: Thu, 08 Nov 2012 11:26:54 -0800
Message-ID: <20121108192655.982325C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:36632 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756705Ab2KHT05 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Nov 2012 14:26:57 -0500
Received: by mail-la0-f74.google.com with SMTP id j13so204056lah.1
        for <mm-commits@vger.kernel.org>; Thu, 08 Nov 2012 11:26:56 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ecashin@coraid.com


The patch titled
     Subject: aoe: use high-resolution RTTs with fallback to low-res
has been added to the -mm tree.  Its filename is
     aoe-use-high-resolution-rtts-with-fallback-to-low-res.patch

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
Subject: aoe: use high-resolution RTTs with fallback to low-res

These changes improve the accuracy of the decision about whether it's time
to retransmit an AoE command by using the microsecond-resolution
gettimeofday instead of jiffies.

Because the system time can jump suddenly, the decision reverts to using
jiffies if the high-resolution time difference is relatively large.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoe.h    |    9 +++--
 drivers/block/aoe/aoecmd.c |   57 ++++++++++++++++++++++++++++++-----
 2 files changed, 55 insertions(+), 11 deletions(-)

diff -puN drivers/block/aoe/aoe.h~aoe-use-high-resolution-rtts-with-fallback-to-low-res drivers/block/aoe/aoe.h
--- a/drivers/block/aoe/aoe.h~aoe-use-high-resolution-rtts-with-fallback-to-low-res
+++ a/drivers/block/aoe/aoe.h
@@ -88,8 +88,7 @@ enum {
 	TIMERTICK = HZ / 10,
 	RTTSCALE = 8,
 	RTTDSCALE = 3,
-	MAXTIMER = HZ << 1,
-	RTTAVG_INIT = HZ / 4 << RTTSCALE,
+	RTTAVG_INIT = USEC_PER_SEC / 4 << RTTSCALE,
 	RTTDEV_INIT = RTTAVG_INIT / 4,
 };
 
@@ -106,6 +105,8 @@ struct buf {
 struct frame {
 	struct list_head head;
 	u32 tag;
+	struct timeval sent;	/* high-res time packet was sent */
+	u32 sent_jiffs;		/* low-res jiffies-based sent time */
 	ulong waited;
 	struct aoetgt *t;		/* parent target I belong to */
 	sector_t lba;
@@ -143,11 +144,11 @@ struct aoedev {
 	struct aoedev *next;
 	ulong sysminor;
 	ulong aoemajor;
+	u32 rttavg;		/* scaled AoE round trip time average */
+	u32 rttdev;		/* scaled round trip time mean deviation */
 	u16 aoeminor;
 	u16 flags;
 	u16 nopen;		/* (bd_openers isn't available without sleeping) */
-	u16 rttavg;		/* scaled AoE round trip time average */
-	u16 rttdev;		/* scaled round trip time mean deviation */
 	u16 fw_ver;		/* version of blade's firmware */
 	u16 lasttag;		/* last tag sent */
 	u16 useme;
diff -puN drivers/block/aoe/aoecmd.c~aoe-use-high-resolution-rtts-with-fallback-to-low-res drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~aoe-use-high-resolution-rtts-with-fallback-to-low-res
+++ a/drivers/block/aoe/aoecmd.c
@@ -387,6 +387,8 @@ aoecmd_ata_rw(struct aoedev *d)
 	skb->dev = t->ifp->nd;
 	skb = skb_clone(skb, GFP_ATOMIC);
 	if (skb) {
+		do_gettimeofday(&f->sent);
+		f->sent_jiffs = (u32) jiffies;
 		__skb_queue_head_init(&queue);
 		__skb_queue_tail(&queue, skb);
 		aoenet_xmit(&queue);
@@ -475,12 +477,46 @@ resend(struct aoedev *d, struct frame *f
 	skb = skb_clone(skb, GFP_ATOMIC);
 	if (skb == NULL)
 		return;
+	do_gettimeofday(&f->sent);
+	f->sent_jiffs = (u32) jiffies;
 	__skb_queue_head_init(&queue);
 	__skb_queue_tail(&queue, skb);
 	aoenet_xmit(&queue);
 }
 
 static int
+tsince_hr(struct frame *f)
+{
+	struct timeval now;
+	int n;
+
+	do_gettimeofday(&now);
+	n = now.tv_usec - f->sent.tv_usec;
+	n += (now.tv_sec - f->sent.tv_sec) * USEC_PER_SEC;
+
+	if (n < 0)
+		n = -n;
+
+	/* For relatively long periods, use jiffies to avoid
+	 * discrepancies caused by updates to the system time.
+	 *
+	 * On system with HZ of 1000, 32-bits is over 49 days
+	 * worth of jiffies, or over 71 minutes worth of usecs.
+	 *
+	 * Jiffies overflow is handled by subtraction of unsigned ints:
+	 * (gdb) print (unsigned) 2 - (unsigned) 0xfffffffe
+	 * $3 = 4
+	 * (gdb)
+	 */
+	if (n > USEC_PER_SEC / 4) {
+		n = ((u32) jiffies) - f->sent_jiffs;
+		n *= USEC_PER_SEC / HZ;
+	}
+
+	return n;
+}
+
+static int
 tsince(u32 tag)
 {
 	int n;
@@ -489,7 +525,7 @@ tsince(u32 tag)
 	n -= tag & 0xffff;
 	if (n < 0)
 		n += 1<<16;
-	return n;
+	return jiffies_to_usecs(n + 1);
 }
 
 static struct aoeif *
@@ -552,6 +588,7 @@ sthtith(struct aoedev *d)
 			nf->bv = f->bv;
 			nf->bv_off = f->bv_off;
 			nf->waited = 0;
+			nf->sent_jiffs = f->sent_jiffs;
 			f->skb = skb;
 			aoe_freetframe(f);
 			ht->nout--;
@@ -621,7 +658,7 @@ rexmit_timer(ulong vp)
 		head = &d->factive[i];
 		list_for_each_safe(pos, nx, head) {
 			f = list_entry(pos, struct frame, head);
-			if (tsince(f->tag) < timeout)
+			if (tsince_hr(f) < timeout)
 				break;	/* end of expired frames */
 			/* move to flist for later processing */
 			list_move_tail(pos, &flist);
@@ -632,8 +669,8 @@ rexmit_timer(ulong vp)
 	while (!list_empty(&flist)) {
 		pos = flist.next;
 		f = list_entry(pos, struct frame, head);
-		n = f->waited += tsince(f->tag);
-		n /= HZ;
+		n = f->waited += tsince_hr(f);
+		n /= USEC_PER_SEC;
 		if (n > aoe_deadsecs) {
 			/* Waited too long.  Device failure.
 			 * Hang all frames on first hash bucket for downdev
@@ -1193,12 +1230,12 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 	n = be32_to_cpu(get_unaligned(&h->tag));
 	f = getframe(d, n);
 	if (f) {
-		calc_rttavg(d, f->t, tsince(n));
+		calc_rttavg(d, f->t, tsince_hr(f));
 		f->t->nout--;
 	} else {
 		f = getframe_deferred(d, n);
 		if (f) {
-			calc_rttavg(d, NULL, tsince(n));
+			calc_rttavg(d, NULL, tsince_hr(f));
 		} else {
 			calc_rttavg(d, NULL, tsince(n));
 			spin_unlock_irqrestore(&d->lock, flags);
@@ -1276,7 +1313,13 @@ aoecmd_ata_id(struct aoedev *d)
 	d->rttdev = RTTDEV_INIT;
 	d->timer.function = rexmit_timer;
 
-	return skb_clone(skb, GFP_ATOMIC);
+	skb = skb_clone(skb, GFP_ATOMIC);
+	if (skb) {
+		do_gettimeofday(&f->sent);
+		f->sent_jiffs = (u32) jiffies;
+	}
+
+	return skb;
 }
 
 static struct aoetgt *
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

