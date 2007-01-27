From: akpm@osdl.org
Subject: - fix-bug-in-cancel_dirty_pages-on-xfs.patch removed from -mm tree
Date: Fri, 26 Jan 2007 17:05:43 -0800
Message-ID: <200701270105.l0R15hRS031374@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34598 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161AbXA0BFq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 20:05:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dgc@sgi.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     Fix BUG in cancel_dirty_pages on XFS
has been removed from the -mm tree.  Its filename was
     fix-bug-in-cancel_dirty_pages-on-xfs.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: Fix BUG in cancel_dirty_pages on XFS
From: David Chinner <dgc@sgi.com>

Make XFS use the new truncate_unmap_inode_pages_range() function.

Signed-off-by: Dave Chinner <dgc@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/xfs/linux-2.6/xfs_fs_subr.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN fs/xfs/linux-2.6/xfs_fs_subr.c~fix-bug-in-cancel_dirty_pages-on-xfs fs/xfs/linux-2.6/xfs_fs_subr.c
--- a/fs/xfs/linux-2.6/xfs_fs_subr.c~fix-bug-in-cancel_dirty_pages-on-xfs
+++ a/fs/xfs/linux-2.6/xfs_fs_subr.c
@@ -32,7 +32,8 @@ fs_tosspages(
 	struct inode	*ip = vn_to_inode(vp);
 
 	if (VN_CACHED(vp))
-		truncate_inode_pages(ip->i_mapping, first);
+		truncate_unmap_inode_pages_range(ip->i_mapping,
+						first, last, 1);
 }
 
 void
@@ -49,7 +50,8 @@ fs_flushinval_pages(
 		if (VN_TRUNC(vp))
 			VUNTRUNCATE(vp);
 		filemap_write_and_wait(ip->i_mapping);
-		truncate_inode_pages(ip->i_mapping, first);
+		truncate_unmap_inode_pages_range(ip->i_mapping,
+						first, last, 1);
 	}
 }
 
_

Patches currently in -mm which might be from dgc@sgi.com are

fix-bug-in-cancel_dirty_pages-on-xfs.patch
xfs-remove-useless-wmb-memory-barrier.patch
make-bh_unwritten-a-first-class-bufferhead-flag-v2.patch
make-xfs-use-bh_unwritten-and-bh_delay-correctly.patch
sysctl-xfs-remove-unnecessary-insert_at_head-flag.patch
sysctl-c99-convert-xfs-ctl_tables.patch
sysctl-c99-convert-xfs-ctl_tables-fixes.patch
