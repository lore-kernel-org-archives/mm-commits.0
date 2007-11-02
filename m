From: akpm@linux-foundation.org
Subject: + md-fix-misapplied-patch-in-raid5c.patch added to -mm tree
Date: Fri, 02 Nov 2007 00:39:12 -0700
Message-ID: <200711020739.lA27dC4Z012003@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44447 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752219AbXKBHjU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Nov 2007 03:39:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de, dan.j.williams@intel.com


The patch titled
     md: fix misapplied patch in raid5.c
has been added to the -mm tree.  Its filename is
     md-fix-misapplied-patch-in-raid5c.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: md: fix misapplied patch in raid5.c
From: NeilBrown <neilb@suse.de>

commit 4ae3f847e49e3787eca91bced31f8fd328d50496 did not get applied
correctly, presumably due to substantial similarities between
handle_stripe5 and handle_stripe6.

This patch moves the chunk of new code from handle_stripe6 (where it isn't
needed (yet)) to handle_stripe5.

Signed-off-by: Neil Brown <neilb@suse.de>
Cc: "Dan Williams" <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/raid5.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/md/raid5.c~md-fix-misapplied-patch-in-raid5c drivers/md/raid5.c
--- a/drivers/md/raid5.c~md-fix-misapplied-patch-in-raid5c
+++ a/drivers/md/raid5.c
@@ -2624,6 +2624,13 @@ static void handle_stripe5(struct stripe
 	s.expanded = test_bit(STRIPE_EXPAND_READY, &sh->state);
 	/* Now to look around and see what can be done */
 
+	/* clean-up completed biofill operations */
+	if (test_bit(STRIPE_OP_BIOFILL, &sh->ops.complete)) {
+		clear_bit(STRIPE_OP_BIOFILL, &sh->ops.pending);
+		clear_bit(STRIPE_OP_BIOFILL, &sh->ops.ack);
+		clear_bit(STRIPE_OP_BIOFILL, &sh->ops.complete);
+	}
+
 	rcu_read_lock();
 	for (i=disks; i--; ) {
 		mdk_rdev_t *rdev;
@@ -2897,13 +2904,6 @@ static void handle_stripe6(struct stripe
 	s.expanded = test_bit(STRIPE_EXPAND_READY, &sh->state);
 	/* Now to look around and see what can be done */
 
-	/* clean-up completed biofill operations */
-	if (test_bit(STRIPE_OP_BIOFILL, &sh->ops.complete)) {
-		clear_bit(STRIPE_OP_BIOFILL, &sh->ops.pending);
-		clear_bit(STRIPE_OP_BIOFILL, &sh->ops.ack);
-		clear_bit(STRIPE_OP_BIOFILL, &sh->ops.complete);
-	}
-
 	rcu_read_lock();
 	for (i=disks; i--; ) {
 		mdk_rdev_t *rdev;
_

Patches currently in -mm which might be from neilb@suse.de are

md-fix-misapplied-patch-in-raid5c.patch
git-md-accel.patch
sunrpc-xprtrdma-transportc-fix-use-after-free.patch
coding-style-cleanups-for-drivers-md-mktablesc.patch
