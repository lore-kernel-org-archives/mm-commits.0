From: akpm@linux-foundation.org
Subject: + md-fix-data-corruption-when-a-degraded-raid5-array-is-reshaped.patch added to -mm tree
Date: Sat, 05 Jan 2008 12:23:23 -0800
Message-ID: <200801052023.m05KN3lE009769@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40376 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756341AbYAEUXZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 5 Jan 2008 15:23:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dan.j.williams@intel.com, neilb@suse.de, stable@kernel.org


The patch titled
     md: fix data corruption when a degraded raid5 array is reshaped
has been added to the -mm tree.  Its filename is
     md-fix-data-corruption-when-a-degraded-raid5-array-is-reshaped.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: md: fix data corruption when a degraded raid5 array is reshaped
From: Dan Williams <dan.j.williams@intel.com>

md: Fix data corruption when a degraded raid5 array is reshaped.

We currently do not wait for the block from the missing device to be
computed from parity before copying data to the new stripe layout.

The change in the raid6 code is not techincally needed as we don't delay
data block recovery in the same way for raid6 yet.  But making the change
now is safer long-term.

This bug exists in 2.6.23 and 2.6.24-rc

Cc: <stable@kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/raid5.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/md/raid5.c~md-fix-data-corruption-when-a-degraded-raid5-array-is-reshaped drivers/md/raid5.c
--- a/drivers/md/raid5.c~md-fix-data-corruption-when-a-degraded-raid5-array-is-reshaped
+++ a/drivers/md/raid5.c
@@ -2865,7 +2865,8 @@ static void handle_stripe5(struct stripe
 		md_done_sync(conf->mddev, STRIPE_SECTORS, 1);
 	}
 
-	if (s.expanding && s.locked == 0)
+	if (s.expanding && s.locked == 0 &&
+	    !test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending))
 		handle_stripe_expansion(conf, sh, NULL);
 
 	if (sh->ops.count)
@@ -3067,7 +3068,8 @@ static void handle_stripe6(struct stripe
 		md_done_sync(conf->mddev, STRIPE_SECTORS, 1);
 	}
 
-	if (s.expanding && s.locked == 0)
+	if (s.expanding && s.locked == 0 &&
+	    !test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending))
 		handle_stripe_expansion(conf, sh, &r6s);
 
 	spin_unlock(&sh->lock);
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

md-fix-data-corruption-when-a-degraded-raid5-array-is-reshaped.patch
git-arm.patch
git-md-accel.patch
dca-convert-struct-class_device-to-struct-device.patch
add-dma-engine-driver-for-freescale-mpc85xx-processors.patch
add-dma-engine-driver-for-freescale-mpc85xx-processors-fix.patch
add-dma-engine-driver-for-freescale-mpc85xx-processors-fix-fix.patch
