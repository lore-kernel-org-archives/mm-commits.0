From: akpm@linux-foundation.org
Subject: - mm-optimize-acorn-partition-truncate.patch removed from -mm tree
Date: Mon, 07 May 2007 17:03:23 -0700
Message-ID: <200705080003.l4803Nlw008946@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49588 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967436AbXEHAIy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:08:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org


The patch titled
     mm: optimize acorn partition truncate
has been removed from the -mm tree.  Its filename was
     mm-optimize-acorn-partition-truncate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mm: optimize acorn partition truncate
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

invalidate_bdev() is superfluous when truncate_inode_pages() is also
called.  do call invalidate_bh_lrus() though, to avoid stale pointers.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/partitions/acorn.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/partitions/acorn.c~mm-optimize-acorn-partition-truncate fs/partitions/acorn.c
--- a/fs/partitions/acorn.c~mm-optimize-acorn-partition-truncate
+++ a/fs/partitions/acorn.c
@@ -271,7 +271,7 @@ adfspart_check_ADFS(struct parsed_partit
 		extern void xd_set_geometry(struct block_device *,
 			unsigned char, unsigned char, unsigned int);
 		xd_set_geometry(bdev, dr->secspertrack, heads, 1);
-		invalidate_bdev(bdev);
+		invalidate_bh_lrus();
 		truncate_inode_pages(bdev->bd_inode->i_mapping, 0);
 	}
 #endif
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
lazy-freeing-of-memory-through-madv_free.patch
restore-madv_dontneed-to-its-original-linux-behaviour.patch
lumpy-reclaim-v4.patch
split-mmap.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
exec-fix-remove_arg_zero.patch
lockdep-treats-down_write_trylock-like-regular-down_write.patch
nfs-fix-congestion-control-use-atomic_longs.patch
