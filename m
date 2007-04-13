From: akpm@linux-foundation.org
Subject: + mm-optimize-acorn-partition-truncate.patch added to -mm tree
Date: Fri, 13 Apr 2007 13:01:29 -0700
Message-ID: <200704132001.l3DK1Tls008215@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48500 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964821AbXDMUBe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 16:01:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl


The patch titled
     mm: optimize acorn partition truncate
has been added to the -mm tree.  Its filename is
     mm-optimize-acorn-partition-truncate.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm: optimize acorn partition truncate
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

invalidate_bdev() is superfluous when truncate_inode_pages() is also
called.  do call invalidate_bh_lrus() though, to avoid stale pointers.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/partitions/acorn.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

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

lumpy-reclaim-v4.patch
split-mmap.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
mm-remove-destroy_dirty_buffers-from-invalidate_bdev.patch
mm-optimize-kill_bdev.patch
mm-optimize-kill_bdev-fix.patch
mm-optimize-acorn-partition-truncate.patch
exec-fix-remove_arg_zero-add-comment.patch
lockdep-treats-down_write_trylock-like-regular-down_write.patch
nfs-fix-congestion-control-use-atomic_longs.patch
