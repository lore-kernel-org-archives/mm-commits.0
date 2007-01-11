From: akpm@osdl.org
Subject: + make-xfs-use-bh_unwritten-and-bh_delay-correctly.patch added to -mm tree
Date: Wed, 10 Jan 2007 16:52:10 -0800
Message-ID: <200701110052.l0B0qA9T012967@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41735 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965280AbXAKAwT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jan 2007 19:52:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dgc@sgi.com, hch@lst.de


The patch titled
     Make XFS use BH_Unwritten and BH_Delay correctly
has been added to the -mm tree.  Its filename is
     make-xfs-use-bh_unwritten-and-bh_delay-correctly.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Make XFS use BH_Unwritten and BH_Delay correctly
From: David Chinner <dgc@sgi.com>

Don't hide buffer_unwritten behind buffer_delay() and remove the hack that
clears unexpected buffer_unwritten() states now that it can't happen.

Signed-off-by: Dave Chinner <dgc@sgi.com>
Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/xfs/linux-2.6/xfs_aops.c |    3 ---
 1 files changed, 3 deletions(-)

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

revert-bd_mount_mutex-back-to-a-semaphore.patch
xfs-remove-useless-wmb-memory-barrier.patch
make-bh_unwritten-a-first-class-bufferhead-flag-v2.patch
make-xfs-use-bh_unwritten-and-bh_delay-correctly.patch
