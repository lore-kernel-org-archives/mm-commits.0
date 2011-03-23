From: akpm@linux-foundation.org
Subject: [merged] sys_swapon-simplify-error-flow-in-claim_swapfile.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:37:38 -0700
Message-ID: <201103232041.p2NKfEbY028619@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44313 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756124Ab1CWUzQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:55:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cesarb@cesarb.net, emunson@mgebm.net, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     sys_swapon: simplify error flow in claim_swapfile()
has been removed from the -mm tree.  Its filename was
     sys_swapon-simplify-error-flow-in-claim_swapfile.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sys_swapon: simplify error flow in claim_swapfile()
From: Cesar Eduardo Barros <cesarb@cesarb.net>

Since there is no cleanup to do, there is no reason to jump to a label.
Return directly instead.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Tested-by: Eric B Munson <emunson@mgebm.net>
Acked-by: Eric B Munson <emunson@mgebm.net>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff -puN mm/swapfile.c~sys_swapon-simplify-error-flow-in-claim_swapfile mm/swapfile.c
--- a/mm/swapfile.c~sys_swapon-simplify-error-flow-in-claim_swapfile
+++ a/mm/swapfile.c
@@ -1900,30 +1900,22 @@ static int claim_swapfile(struct swap_in
 				   sys_swapon);
 		if (error < 0) {
 			p->bdev = NULL;
-			error = -EINVAL;
-			goto bad_swap;
+			return -EINVAL;
 		}
 		p->old_block_size = block_size(p->bdev);
 		error = set_blocksize(p->bdev, PAGE_SIZE);
 		if (error < 0)
-			goto bad_swap;
+			return error;
 		p->flags |= SWP_BLKDEV;
 	} else if (S_ISREG(inode->i_mode)) {
 		p->bdev = inode->i_sb->s_bdev;
 		mutex_lock(&inode->i_mutex);
-		if (IS_SWAPFILE(inode)) {
-			error = -EBUSY;
-			goto bad_swap;
-		}
-	} else {
-		error = -EINVAL;
-		goto bad_swap;
-	}
+		if (IS_SWAPFILE(inode))
+			return -EBUSY;
+	} else
+		return -EINVAL;
 
 	return 0;
