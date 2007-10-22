From: akpm@linux-foundation.org
Subject: + md-raid5-fix-clearing-of-biofill-operations.patch added to -mm tree
Date: Mon, 22 Oct 2007 00:40:04 -0700
Message-ID: <200710220740.l9M7e43c016723@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52781 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751196AbXJVHlO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Oct 2007 03:41:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dan.j.williams@intel.com, joel.bertrand@systella.fr, neilb@suse.de, stable@kernel.org


The patch titled
     md: raid5: fix clearing of biofill operations
has been added to the -mm tree.  Its filename is
     md-raid5-fix-clearing-of-biofill-operations.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: md: raid5: fix clearing of biofill operations
From: Dan Williams <dan.j.williams@intel.com>

ops_complete_biofill() runs outside of spin_lock(&sh->lock) and clears the
'pending' and 'ack' bits.  Since the test_and_ack_op() macro only checks
against 'complete' it can get an inconsistent snapshot of pending work.

Move the clearing of these bits to handle_stripe5(), under the lock.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Tested-by: Joel Bertrand <joel.bertrand@systella.fr>
Signed-off-by: Neil Brown <neilb@suse.de>
Cc: Stable <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/raid5.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff -puN drivers/md/raid5.c~md-raid5-fix-clearing-of-biofill-operations drivers/md/raid5.c
--- a/drivers/md/raid5.c~md-raid5-fix-clearing-of-biofill-operations
+++ a/drivers/md/raid5.c
@@ -376,7 +376,12 @@ static unsigned long get_stripe_work(str
 		ack++;
 
 	sh->ops.count -= ack;
-	BUG_ON(sh->ops.count < 0);
+	if (unlikely(sh->ops.count < 0)) {
+		printk(KERN_ERR "pending: %#lx ops.pending: %#lx ops.ack: %#lx "
+			"ops.complete: %#lx\n", pending, sh->ops.pending,
+			sh->ops.ack, sh->ops.complete);
+		BUG();
+	}
 
 	return pending;
 }
@@ -550,8 +555,7 @@ static void ops_complete_biofill(void *s
 			}
 		}
 	}
-	clear_bit(STRIPE_OP_BIOFILL, &sh->ops.ack);
-	clear_bit(STRIPE_OP_BIOFILL, &sh->ops.pending);
+	set_bit(STRIPE_OP_BIOFILL, &sh->ops.complete);
 
 	return_io(return_bi);
 
@@ -2893,6 +2897,13 @@ static void handle_stripe6(struct stripe
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
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

origin.patch
md-raid5-fix-clearing-of-biofill-operations.patch
git-md-accel.patch
