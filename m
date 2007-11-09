From: akpm@linux-foundation.org
Subject: + raid5-fix-unending-write-sequence.patch added to -mm tree
Date: Fri, 09 Nov 2007 15:45:06 -0800
Message-ID: <200711092345.lA9Nj6rp005477@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56082 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764266AbXKIXqF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Nov 2007 18:46:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dan.j.williams@intel.com, joel.bertrand@systella.fr, neilb@suse.de, stable@kernel.org


The patch titled
     raid5: fix unending write sequence
has been added to the -mm tree.  Its filename is
     raid5-fix-unending-write-sequence.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: raid5: fix unending write sequence
From: Dan Williams <dan.j.williams@intel.com>

<debug output from Joel's system>
handling stripe 7629696, state=0x14 cnt=1, pd_idx=2 ops=0:0:0
check 5: state 0x6 toread 0000000000000000 read 0000000000000000 write fffff800ffcffcc0 written 0000000000000000
check 4: state 0x6 toread 0000000000000000 read 0000000000000000 write fffff800fdd4e360 written 0000000000000000
check 3: state 0x1 toread 0000000000000000 read 0000000000000000 write 0000000000000000 written 0000000000000000
check 2: state 0x1 toread 0000000000000000 read 0000000000000000 write 0000000000000000 written 0000000000000000
check 1: state 0x6 toread 0000000000000000 read 0000000000000000 write fffff800ff517e40 written 0000000000000000
check 0: state 0x6 toread 0000000000000000 read 0000000000000000 write fffff800fd4cae60 written 0000000000000000
locked=4 uptodate=2 to_read=0 to_write=4 failed=0 failed_num=0
for sector 7629696, rmw=0 rcw=0
</debug>

These blocks were prepared to be written out, but were never handled in
ops_run_biodrain(), so they remain locked forever.  The operations flags
are all clear which means handle_stripe() thinks nothing else needs to be
done.

This state suggests that the STRIPE_OP_PREXOR bit was sampled 'set' when it
should not have been.  This patch cleans up cases where the code looks at
sh->ops.pending when it should be looking at the consistent stack-based
snapshot of the operations flags.

Report from Joel:
	Resync done. Patch fix this bug.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Tested-by: Joel Bertrand <joel.bertrand@systella.fr>
Cc: <stable@kernel.org>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/raid5.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff -puN drivers/md/raid5.c~raid5-fix-unending-write-sequence drivers/md/raid5.c
--- a/drivers/md/raid5.c~raid5-fix-unending-write-sequence
+++ a/drivers/md/raid5.c
@@ -688,7 +688,8 @@ ops_run_prexor(struct stripe_head *sh, s
 }
 
 static struct dma_async_tx_descriptor *
-ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
+ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx,
+		 unsigned long pending)
 {
 	int disks = sh->disks;
 	int pd_idx = sh->pd_idx, i;
@@ -696,7 +697,7 @@ ops_run_biodrain(struct stripe_head *sh,
 	/* check if prexor is active which means only process blocks
 	 * that are part of a read-modify-write (Wantprexor)
 	 */
-	int prexor = test_bit(STRIPE_OP_PREXOR, &sh->ops.pending);
+	int prexor = test_bit(STRIPE_OP_PREXOR, &pending);
 
 	pr_debug("%s: stripe %llu\n", __FUNCTION__,
 		(unsigned long long)sh->sector);
@@ -773,7 +774,8 @@ static void ops_complete_write(void *str
 }
 
 static void
-ops_run_postxor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
+ops_run_postxor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx,
+		unsigned long pending)
 {
 	/* kernel stack size limits the total number of disks */
 	int disks = sh->disks;
@@ -781,7 +783,7 @@ ops_run_postxor(struct stripe_head *sh, 
 
 	int count = 0, pd_idx = sh->pd_idx, i;
 	struct page *xor_dest;
-	int prexor = test_bit(STRIPE_OP_PREXOR, &sh->ops.pending);
+	int prexor = test_bit(STRIPE_OP_PREXOR, &pending);
 	unsigned long flags;
 	dma_async_tx_callback callback;
 
@@ -808,7 +810,7 @@ ops_run_postxor(struct stripe_head *sh, 
 	}
 
 	/* check whether this postxor is part of a write */
-	callback = test_bit(STRIPE_OP_BIODRAIN, &sh->ops.pending) ?
+	callback = test_bit(STRIPE_OP_BIODRAIN, &pending) ?
 		ops_complete_write : ops_complete_postxor;
 
 	/* 1/ if we prexor'd then the dest is reused as a source
@@ -896,12 +898,12 @@ static void raid5_run_ops(struct stripe_
 		tx = ops_run_prexor(sh, tx);
 
 	if (test_bit(STRIPE_OP_BIODRAIN, &pending)) {
-		tx = ops_run_biodrain(sh, tx);
+		tx = ops_run_biodrain(sh, tx, pending);
 		overlap_clear++;
 	}
 
 	if (test_bit(STRIPE_OP_POSTXOR, &pending))
-		ops_run_postxor(sh, tx);
+		ops_run_postxor(sh, tx, pending);
 
 	if (test_bit(STRIPE_OP_CHECK, &pending))
 		ops_run_check(sh);
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

dmaengine-fix-broken-device-refcounting.patch
raid5-fix-unending-write-sequence.patch
git-arm-master.patch
git-md-accel.patch
i-oat-add-support-for-version-2-of-ioatdma-device.patch
dca-convert-struct-class_device-to-struct-device.patch
add-dma-engine-driver-for-freescale-mpc85xx-processors.patch
add-dma-engine-driver-for-freescale-mpc85xx-processors-fix.patch
