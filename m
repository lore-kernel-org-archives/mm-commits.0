From: akpm@osdl.org
Subject: + fix-bug-in-cancel_dirty_pages-on-xfs.patch added to -mm tree
Date: Wed, 24 Jan 2007 23:33:18 -0800
Message-ID: <200701250733.l0P7XIxk009260@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52020 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965672AbXAYHdV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 02:33:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dgc@sgi.com, nickpiggin@yahoo.com.au


The patch titled
     Fix BUG in cancel_dirty_pages on XFS
has been added to the -mm tree.  Its filename is
     fix-bug-in-cancel_dirty_pages-on-xfs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

add-truncate_unmap_inode_pages_range.patch
fix-bug-in-cancel_dirty_pages-on-xfs.patch
xfs-remove-useless-wmb-memory-barrier.patch
make-bh_unwritten-a-first-class-bufferhead-flag-v2.patch
make-xfs-use-bh_unwritten-and-bh_delay-correctly.patch
sysctl-xfs-remove-unnecessary-insert_at_head-flag.patch
sysctl-c99-convert-xfs-ctl_tables.patch
sysctl-c99-convert-xfs-ctl_tables-fixes.patch
