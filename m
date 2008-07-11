From: akpm@linux-foundation.org
Subject: - md-ensure-all-blocks-are-uptodate-or-locked-when-syncing.patch removed from -mm tree
Date: Fri, 11 Jul 2008 16:50:46 -0700
Message-ID: <200807112350.m6BNoksI010982@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42973 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754380AbYGKXvA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 19:51:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, neilb@suse.de, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     md: ensure all blocks are uptodate or locked when syncing
has been removed from the -mm tree.  Its filename was
     md-ensure-all-blocks-are-uptodate-or-locked-when-syncing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: md: ensure all blocks are uptodate or locked when syncing
From: Dan Williams <dan.j.williams@intel.com>

Remove the dubious attempt to prefer 'compute' over 'read'.  Not only is it
wrong given commit c337869d (md: do not compute parity unless it is on a
failed drive), but it can trigger a BUG_ON in handle_parity_checks5().

Cc: <stable@kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/raid5.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN drivers/md/raid5.c~md-ensure-all-blocks-are-uptodate-or-locked-when-syncing drivers/md/raid5.c
--- a/drivers/md/raid5.c~md-ensure-all-blocks-are-uptodate-or-locked-when-syncing
+++ a/drivers/md/raid5.c
@@ -2017,12 +2017,7 @@ static int __handle_issuing_new_read_req
 			 */
 			s->uptodate++;
 			return 0; /* uptodate + compute == disks */
-		} else if ((s->uptodate < disks - 1) &&
-			test_bit(R5_Insync, &dev->flags)) {
-			/* Note: we hold off compute operations while checks are
-			 * in flight, but we still prefer 'compute' over 'read'
-			 * hence we only read if (uptodate < * disks-1)
-			 */
+		} else if (test_bit(R5_Insync, &dev->flags)) {
 			set_bit(R5_LOCKED, &dev->flags);
 			set_bit(R5_Wantread, &dev->flags);
 			if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

origin.patch
linux-next.patch

