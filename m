From: akpm@linux-foundation.org
Subject: - fs-btrfs-inodec-eliminate-memory-leak.patch removed from -mm tree
Date: Tue, 19 Apr 2011 10:58:24 -0700
Message-ID: <201104191754.p3JHsQ4x014076@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47259 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753371Ab1DSRzF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Apr 2011 13:55:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, chris.mason@oracle.com, mm-commits@vger.kernel.org


The patch titled
     fs/btrfs/inode.c: eliminate memory leak
has been removed from the -mm tree.  Its filename was
     fs-btrfs-inodec-eliminate-memory-leak.patch

This patch was dropped because a suckier fix was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/btrfs/inode.c: eliminate memory leak
From: Julia Lawall <julia@diku.dk>

This code is preceded by a call to btrfs_alloc_path, which allocates some
memory.  There is some error handling code at the end of the function that
frees it, that can be taken advantage of with a little ordering
adjustment.

A simplified version of the semantic match that finds this problem is:
(http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
local idexpression x;
expression E;
identifier f1;
iterator I;
@@

x = btrfs_alloc_path(...);
<... when != x
     when != true (x == NULL || ...)
     when != if (...) { <+...x...+> }
     when != I (...) { <+...x...+> }
(
 x == NULL
|
 x == E
|
 x->f1
)
...>
* return ...;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/inode.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff -puN fs/btrfs/inode.c~fs-btrfs-inodec-eliminate-memory-leak fs/btrfs/inode.c
--- a/fs/btrfs/inode.c~fs-btrfs-inodec-eliminate-memory-leak
+++ a/fs/btrfs/inode.c
@@ -4527,17 +4527,17 @@ static struct inode *btrfs_new_inode(str
 	BUG_ON(!path);
 
 	inode = new_inode(root->fs_info->sb);
-	if (!inode)
-		return ERR_PTR(-ENOMEM);
+	if (!inode) {
+		ret = -ENOMEM;
+		goto fail_path;
+	}
 
 	if (dir) {
 		trace_btrfs_inode_request(dir);
 
 		ret = btrfs_set_inode_index(dir, index);
-		if (ret) {
-			iput(inode);
-			return ERR_PTR(ret);
-		}
+		if (ret)
+			goto fail_inode;
 	}
 	/*
 	 * index_cnt is ignored for everything but a dir,
@@ -4615,8 +4615,10 @@ static struct inode *btrfs_new_inode(str
 fail:
 	if (dir)
 		BTRFS_I(dir)->index_cnt--;
-	btrfs_free_path(path);
+fail_inode:
 	iput(inode);
+fail_path:
+	btrfs_free_path(path);
 	return ERR_PTR(ret);
 }
 
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
drivers-rtc-rtc-mrstc-use-release_mem_region-after-request_mem_region.patch
drivers-rtc-rtc-mrstc-use-release_mem_region-after-request_mem_region-fix.patch

