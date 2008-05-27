From: akpm@linux-foundation.org
Subject: + md-fix-prexor-vs-sync_request-race.patch added to -mm tree
Date: Mon, 26 May 2008 23:43:50 -0700
Message-ID: <200805270643.m4R6hodB013278@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39007 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755349AbYE0GoI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 May 2008 02:44:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dan.j.williams@intel.com, neilb@suse.de, stable@kernel.org


The patch titled
     md: fix prexor vs sync_request race
has been added to the -mm tree.  Its filename is
     md-fix-prexor-vs-sync_request-race.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: md: fix prexor vs sync_request race
From: Dan Williams <dan.j.williams@intel.com>

During the initial array synchronization process there is a window between
when a prexor operation is scheduled to a specific stripe and when it
completes for a sync_request to be scheduled to the same stripe.  When
this happens the prexor completes and the stripe is unconditionally marked
"insync", effectively canceling the sync_request for the stripe.  Prior to
2.6.23 this was not a problem because the prexor operation was done under
sh->lock.  The effect in older kernels being that the prexor would still
erroneously mark the stripe "insync", but sync_request would be held off
and re-mark the stripe as "!in_sync".

Change the write completion logic to not mark the stripe "in_sync" if a
prexor was performed.  The effect of the change is to sometimes not set
STRIPE_INSYNC.  The worst this can do is cause the resync to stall waiting
for STRIPE_INSYNC to be set.  If this were happening, then STRIPE_SYNCING
would be set and handle_issuing_new_read_requests would cause all
available blocks to eventually be read, at which point prexor would never
be used on that stripe any more and STRIPE_INSYNC would eventually be set.

echo repair > /sys/block/mdN/md/sync_action will correct arrays that may
have lost this race.

Cc: <stable@kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/raid5.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/md/raid5.c~md-fix-prexor-vs-sync_request-race drivers/md/raid5.c
--- a/drivers/md/raid5.c~md-fix-prexor-vs-sync_request-race
+++ a/drivers/md/raid5.c
@@ -2645,6 +2645,7 @@ static void handle_stripe5(struct stripe
 	struct r5dev *dev;
 	unsigned long pending = 0;
 	mdk_rdev_t *blocked_rdev = NULL;
+	int prexor;
 
 	memset(&s, 0, sizeof(s));
 	pr_debug("handling stripe %llu, state=%#lx cnt=%d, pd_idx=%d "
@@ -2774,9 +2775,11 @@ static void handle_stripe5(struct stripe
 	/* leave prexor set until postxor is done, allows us to distinguish
 	 * a rmw from a rcw during biodrain
 	 */
+	prexor = 0;
 	if (test_bit(STRIPE_OP_PREXOR, &sh->ops.complete) &&
 		test_bit(STRIPE_OP_POSTXOR, &sh->ops.complete)) {
 
+		prexor = 1;
 		clear_bit(STRIPE_OP_PREXOR, &sh->ops.complete);
 		clear_bit(STRIPE_OP_PREXOR, &sh->ops.ack);
 		clear_bit(STRIPE_OP_PREXOR, &sh->ops.pending);
@@ -2810,6 +2813,8 @@ static void handle_stripe5(struct stripe
 				if (!test_and_set_bit(
 				    STRIPE_OP_IO, &sh->ops.pending))
 					sh->ops.count++;
+				if (prexor)
+					continue;
 				if (!test_bit(R5_Insync, &dev->flags) ||
 				    (i == sh->pd_idx && s.failed == 0))
 					set_bit(STRIPE_INSYNC, &sh->state);
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

origin.patch
md-md-raid5-rate-limit-error-printk.patch
md-notify-userspace-on-stop-events.patch
md-fix-prexor-vs-sync_request-race.patch
md-fix-uninitialized-use-of-mddev-recovery_wait.patch
md-do-not-compute-parity-unless-it-is-on-a-failed-drive.patch
linux-next.patch
fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver.patch
fsldma-fix-incorrect-exit-path-for-initialization.patch

