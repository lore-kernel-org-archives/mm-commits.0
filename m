From: akpm@linux-foundation.org
Subject: - md-fix-some-bugs-with-growing-raid5-raid6-arrays.patch removed from -mm tree
Date: Sun, 16 Sep 2007 02:25:34 -0700
Message-ID: <200709160925.l8G9PYMQ009112@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53667 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751477AbXIPJZo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Sep 2007 05:25:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, dan.j.williams@intel.com, mm-commits@vger.kernel.org


The patch titled
     md: fix some bugs with growing raid5/raid6 arrays.
has been removed from the -mm tree.  Its filename was
     md-fix-some-bugs-with-growing-raid5-raid6-arrays.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: md: fix some bugs with growing raid5/raid6 arrays.
From: NeilBrown <neilb@suse.de>

The recent changed to raid5 to allow offload of parity calculation etc
introduced some bugs in the code for growing (i.e.  adding a disk to) raid5
and raid6.  This fixes them

Acked-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/raid5.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff -puN drivers/md/raid5.c~md-fix-some-bugs-with-growing-raid5-raid6-arrays drivers/md/raid5.c
--- a/drivers/md/raid5.c~md-fix-some-bugs-with-growing-raid5-raid6-arrays
+++ a/drivers/md/raid5.c
@@ -2541,7 +2541,7 @@ static void handle_stripe_expansion(raid
 	struct dma_async_tx_descriptor *tx = NULL;
 	clear_bit(STRIPE_EXPAND_SOURCE, &sh->state);
 	for (i = 0; i < sh->disks; i++)
-		if (i != sh->pd_idx && (r6s && i != r6s->qd_idx)) {
+		if (i != sh->pd_idx && (!r6s || i != r6s->qd_idx)) {
 			int dd_idx, pd_idx, j;
 			struct stripe_head *sh2;
 
@@ -2574,7 +2574,8 @@ static void handle_stripe_expansion(raid
 			set_bit(R5_UPTODATE, &sh2->dev[dd_idx].flags);
 			for (j = 0; j < conf->raid_disks; j++)
 				if (j != sh2->pd_idx &&
-				    (r6s && j != r6s->qd_idx) &&
+				    (!r6s || j != raid6_next_disk(sh2->pd_idx,
+								 sh2->disks)) &&
 				    !test_bit(R5_Expanded, &sh2->dev[j].flags))
 					break;
 			if (j == conf->raid_disks) {
@@ -2583,12 +2584,12 @@ static void handle_stripe_expansion(raid
 			}
 			release_stripe(sh2);
 
-			/* done submitting copies, wait for them to complete */
-			if (i + 1 >= sh->disks) {
-				async_tx_ack(tx);
-				dma_wait_for_async_tx(tx);
-			}
 		}
+	/* done submitting copies, wait for them to complete */
+	if (tx) {
+		async_tx_ack(tx);
+		dma_wait_for_async_tx(tx);
+	}
 }
 
 /*
@@ -2855,7 +2856,7 @@ static void handle_stripe5(struct stripe
 		sh->disks = conf->raid_disks;
 		sh->pd_idx = stripe_to_pdidx(sh->sector, conf,
 			conf->raid_disks);
-		s.locked += handle_write_operations5(sh, 0, 1);
+		s.locked += handle_write_operations5(sh, 1, 1);
 	} else if (s.expanded &&
 		!test_bit(STRIPE_OP_POSTXOR, &sh->ops.pending)) {
 		clear_bit(STRIPE_EXPAND_READY, &sh->state);
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
git-nfsd.patch
mm-revert-kernel_ds-buffered-write-optimisation.patch
fs-nfsd-exportc-make-3-functions-static.patch
md-software-raid-autodetect-dev-list-not-array.patch
md-software-raid-autodetect-dev-list-not-array-fix.patch
bitmaph-remove-dead-artifacts.patch
sysctl-remove-broken-sunrpc-debug-binary-sysctls.patch
