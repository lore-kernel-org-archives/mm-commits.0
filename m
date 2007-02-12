From: akpm@linux-foundation.org
Subject: - make-bh_unwritten-a-first-class-bufferhead-flag-v2.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:42:54 -0800
Message-ID: <200702122242.l1CMgsle013457@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44797 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030228AbXBLWnE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:43:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dgc@sgi.com, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     Make BH_Unwritten a first class bufferhead flag V2
has been removed from the -mm tree.  Its filename was
     make-bh_unwritten-a-first-class-bufferhead-flag-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Make BH_Unwritten a first class bufferhead flag V2
From: David Chinner <dgc@sgi.com>

Currently, XFS uses BH_PrivateStart for flagging unwritten extent state in a
bufferhead.  Recently, I found the long standing mmap/unwritten extent
conversion bug, and it was to do with partial page invalidation not clearing
the unwritten flag from bufferheads attached to the page but beyond EOF.  See
here for a full explaination:

http://oss.sgi.com/archives/xfs/2006-12/msg00196.html

The solution I have checked into the XFS dev tree involves duplicating code
from block_invalidatepage to clear the unwritten flag from the bufferhead(s),
and then calling block_invalidatepage() to do the rest.

Christoph suggested that this would be better solved by pushing the unwritten
flag into the common buffer head flags and just adding the call to
discard_buffer():

http://oss.sgi.com/archives/xfs/2006-12/msg00239.html

The following patch makes BH_Unwritten a first class citizen.

Signed-off-by: Dave Chinner <dgc@sgi.com>
Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                  |    4 +++-
 fs/xfs/linux-2.6/xfs_linux.h |   10 ----------
 include/linux/buffer_head.h  |    2 ++
 3 files changed, 5 insertions(+), 11 deletions(-)

diff -puN fs/buffer.c~make-bh_unwritten-a-first-class-bufferhead-flag-v2 fs/buffer.c
--- a/fs/buffer.c~make-bh_unwritten-a-first-class-bufferhead-flag-v2
+++ a/fs/buffer.c
@@ -1440,6 +1440,7 @@ static void discard_buffer(struct buffer
 	clear_buffer_req(bh);
 	clear_buffer_new(bh);
 	clear_buffer_delay(bh);
+	clear_buffer_unwritten(bh);
 	unlock_buffer(bh);
 }
 
@@ -1823,6 +1824,7 @@ static int __block_prepare_write(struct 
 			continue; 
 		}
 		if (!buffer_uptodate(bh) && !buffer_delay(bh) &&
+		    !buffer_unwritten(bh) &&
 		     (block_start < from || block_end > to)) {
 			ll_rw_block(READ, 1, &bh);
 			*wait_bh++=bh;
@@ -2544,7 +2546,7 @@ int block_truncate_page(struct address_s
 	if (PageUptodate(page))
 		set_buffer_uptodate(bh);
 
-	if (!buffer_uptodate(bh) && !buffer_delay(bh)) {
+	if (!buffer_uptodate(bh) && !buffer_delay(bh) && !buffer_unwritten(bh)) {
 		err = -EIO;
 		ll_rw_block(READ, 1, &bh);
 		wait_on_buffer(bh);
diff -puN fs/xfs/linux-2.6/xfs_linux.h~make-bh_unwritten-a-first-class-bufferhead-flag-v2 fs/xfs/linux-2.6/xfs_linux.h
--- a/fs/xfs/linux-2.6/xfs_linux.h~make-bh_unwritten-a-first-class-bufferhead-flag-v2
+++ a/fs/xfs/linux-2.6/xfs_linux.h
@@ -109,16 +109,6 @@
 #undef  HAVE_PERCPU_SB	/* per cpu superblock counters are a 2.6 feature */
 #endif
 
-/*
- * State flag for unwritten extent buffers.
- *
- * We need to be able to distinguish between these and delayed
- * allocate buffers within XFS.  The generic IO path code does
- * not need to distinguish - we use the BH_Delay flag for both
- * delalloc and these ondisk-uninitialised buffers.
- */
-BUFFER_FNS(PrivateStart, unwritten);
-
 #define restricted_chown	xfs_params.restrict_chown.val
 #define irix_sgid_inherit	xfs_params.sgid_inherit.val
 #define irix_symlink_mode	xfs_params.symlink_mode.val
diff -puN include/linux/buffer_head.h~make-bh_unwritten-a-first-class-bufferhead-flag-v2 include/linux/buffer_head.h
--- a/include/linux/buffer_head.h~make-bh_unwritten-a-first-class-bufferhead-flag-v2
+++ a/include/linux/buffer_head.h
@@ -34,6 +34,7 @@ enum bh_state_bits {
 	BH_Write_EIO,	/* I/O error on write */
 	BH_Ordered,	/* ordered write */
 	BH_Eopnotsupp,	/* operation not supported (barrier) */
+	BH_Unwritten,	/* Buffer is allocated on disk but not written */
 
 	BH_PrivateStart,/* not a state bit, but the first bit available
 			 * for private allocation by other entities
@@ -126,6 +127,7 @@ BUFFER_FNS(Boundary, boundary)
 BUFFER_FNS(Write_EIO, write_io_error)
 BUFFER_FNS(Ordered, ordered)
 BUFFER_FNS(Eopnotsupp, eopnotsupp)
+BUFFER_FNS(Unwritten, unwritten)
 
 #define bh_offset(bh)		((unsigned long)(bh)->b_data & ~PAGE_MASK)
 #define touch_buffer(bh)	mark_page_accessed(bh->b_page)
_

Patches currently in -mm which might be from dgc@sgi.com are

origin.patch
git-block-xfs-barriers-broke.patch
sysctl-remove-insert_at_head-from-register_sysctl.patch
