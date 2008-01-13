From: akpm@linux-foundation.org
Subject: - md-fix-data-corruption-when-a-degraded-raid5-array-is-reshaped.patch removed from -mm tree
Date: Sun, 13 Jan 2008 03:32:59 -0800
Message-ID: <200801131132.m0DBWdJb009786@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36560 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751348AbYAMLcz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Jan 2008 06:32:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, neilb@suse.de, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     md: fix data corruption when a degraded raid5 array is reshaped
has been removed from the -mm tree.  Its filename was
     md-fix-data-corruption-when-a-degraded-raid5-array-is-reshaped.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-arm.patch
git-md-accel.patch
dca-convert-struct-class_device-to-struct-device.patch
