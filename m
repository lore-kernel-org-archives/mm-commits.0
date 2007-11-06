From: akpm@linux-foundation.org
Subject: - md-fix-misapplied-patch-in-raid5c.patch removed from -mm tree
Date: Mon, 05 Nov 2007 21:52:27 -0800
Message-ID: <200711060552.lA65qRJV007307@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53440 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753737AbXKFFxE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Nov 2007 00:53:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, dan.j.williams@intel.com, mm-commits@vger.kernel.org


The patch titled
     md: fix misapplied patch in raid5.c
has been removed from the -mm tree.  Its filename was
     md-fix-misapplied-patch-in-raid5c.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-md-accel.patch
git-nfsd.patch
sunrpc-xprtrdma-transportc-fix-use-after-free.patch
coding-style-cleanups-for-drivers-md-mktablesc.patch
one-less-parameter-to-__d_path.patch
d_path-kerneldoc-cleanup.patch
d_path-use-struct-path-in-struct-avc_audit_data.patch
d_path-make-proc_get_link-use-a-struct-path-argument.patch
d_path-make-get_dcookie-use-a-struct-path-argument.patch
use-struct-path-in-struct-svc_export.patch
use-struct-path-in-struct-svc_export-checkpatch-fixes.patch
use-struct-path-in-struct-svc_expkey.patch
d_path-make-seq_path-use-a-struct-path-argument.patch
d_path-make-d_path-use-a-struct-path.patch
