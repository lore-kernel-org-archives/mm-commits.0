From: akpm@linux-foundation.org
Subject: - make-xfs-use-bh_unwritten-and-bh_delay-correctly.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:42:57 -0800
Message-ID: <200702122242.l1CMgvuW013460@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44806 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030232AbXBLWnI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:43:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dgc@sgi.com, hch@lst.de, tes@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Make XFS use BH_Unwritten and BH_Delay correctly
has been removed from the -mm tree.  Its filename was
     make-xfs-use-bh_unwritten-and-bh_delay-correctly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Make XFS use BH_Unwritten and BH_Delay correctly
From: David Chinner <dgc@sgi.com>

Don't hide buffer_unwritten behind buffer_delay() and remove the hack that
clears unexpected buffer_unwritten() states now that it can't happen.

Signed-off-by: Dave Chinner <dgc@sgi.com>
Acked-by: Christoph Hellwig <hch@lst.de>
Cc: Timothy Shimmin <tes@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/linux-2.6/xfs_aops.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN fs/xfs/linux-2.6/xfs_aops.c~make-xfs-use-bh_unwritten-and-bh_delay-correctly fs/xfs/linux-2.6/xfs_aops.c
--- a/fs/xfs/linux-2.6/xfs_aops.c~make-xfs-use-bh_unwritten-and-bh_delay-correctly
+++ a/fs/xfs/linux-2.6/xfs_aops.c
@@ -56,8 +56,6 @@ xfs_count_page_state(
 	do {
 		if (buffer_uptodate(bh) && !buffer_mapped(bh))
 			(*unmapped) = 1;
-		else if (buffer_unwritten(bh) && !buffer_delay(bh))
-			clear_buffer_unwritten(bh);
 		else if (buffer_unwritten(bh))
 			(*unwritten) = 1;
 		else if (buffer_delay(bh))
@@ -1272,7 +1270,6 @@ __xfs_get_blocks(
 			if (direct)
 				bh_result->b_private = inode;
 			set_buffer_unwritten(bh_result);
-			set_buffer_delay(bh_result);
 		}
 	}
 
_

Patches currently in -mm which might be from dgc@sgi.com are

origin.patch
git-block-xfs-barriers-broke.patch
sysctl-remove-insert_at_head-from-register_sysctl.patch
