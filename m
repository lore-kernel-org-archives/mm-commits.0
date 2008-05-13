From: akpm@linux-foundation.org
Subject: - md-fix-raid5-repair-operations.patch removed from -mm tree
Date: Tue, 13 May 2008 14:33:23 -0700
Message-ID: <200805132133.m4DLXNOx000817@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41490 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761332AbYEMVdn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 17:33:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, linux@horizon.com, neilb@suse.de, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     md: fix raid5 'repair' operations
has been removed from the -mm tree.  Its filename was
     md-fix-raid5-repair-operations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: md: fix raid5 'repair' operations
From: Dan Williams <dan.j.williams@intel.com>

commit bd2ab67030e9116f1e4aae1289220255412b37fd "md: close a livelock window
in handle_parity_checks5" introduced a bug in handling 'repair' operations. 
After a repair operation completes we clear the state bits tracking this
operation.  However, they are cleared too early and this results in the code
deciding to re-run the parity check operation.  Since we have done the repair
in memory the second check does not find a mismatch and thus does not do a
writeback.

Test results:
$ echo repair > /sys/block/md0/md/sync_action
$ cat /sys/block/md0/md/mismatch_cnt
51072
$ echo repair > /sys/block/md0/md/sync_action
$ cat /sys/block/md0/md/mismatch_cnt
0

(also fix incorrect indentation)

Cc: <stable@kernel.org>
Tested-by: George Spelvin <linux@horizon.com>
Acked-by: NeilBrown <neilb@suse.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/raid5.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff -puN drivers/md/raid5.c~md-fix-raid5-repair-operations drivers/md/raid5.c
--- a/drivers/md/raid5.c~md-fix-raid5-repair-operations
+++ a/drivers/md/raid5.c
@@ -2369,8 +2369,8 @@ static void handle_parity_checks5(raid5_
 
 	/* complete a check operation */
 	if (test_and_clear_bit(STRIPE_OP_CHECK, &sh->ops.complete)) {
-	    clear_bit(STRIPE_OP_CHECK, &sh->ops.ack);
-	    clear_bit(STRIPE_OP_CHECK, &sh->ops.pending);
+		clear_bit(STRIPE_OP_CHECK, &sh->ops.ack);
+		clear_bit(STRIPE_OP_CHECK, &sh->ops.pending);
 		if (s->failed == 0) {
 			if (sh->ops.zero_sum_result == 0)
 				/* parity is correct (on disc,
@@ -2400,16 +2400,6 @@ static void handle_parity_checks5(raid5_
 			canceled_check = 1; /* STRIPE_INSYNC is not set */
 	}
 
-	/* check if we can clear a parity disk reconstruct */
-	if (test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.complete) &&
-		test_bit(STRIPE_OP_MOD_REPAIR_PD, &sh->ops.pending)) {
-
-		clear_bit(STRIPE_OP_MOD_REPAIR_PD, &sh->ops.pending);
-		clear_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.complete);
-		clear_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.ack);
-		clear_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending);
-	}
-
 	/* start a new check operation if there are no failures, the stripe is
 	 * not insync, and a repair is not in flight
 	 */
@@ -2424,6 +2414,17 @@ static void handle_parity_checks5(raid5_
 		}
 	}
 
+	/* check if we can clear a parity disk reconstruct */
+	if (test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.complete) &&
+	    test_bit(STRIPE_OP_MOD_REPAIR_PD, &sh->ops.pending)) {
+
+		clear_bit(STRIPE_OP_MOD_REPAIR_PD, &sh->ops.pending);
+		clear_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.complete);
+		clear_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.ack);
+		clear_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending);
+	}
+
+
 	/* Wait for check parity and compute block operations to complete
 	 * before write-back.  If a failure occurred while the check operation
 	 * was in flight we need to cycle this stripe through handle_stripe
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

origin.patch
linux-next.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch
fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver.patch

