From: akpm@linux-foundation.org
Subject: + fs-btrfs-inodec-eliminate-memory-leak.patch added to -mm tree
Date: Fri, 24 Sep 2010 15:27:37 -0700
Message-ID: <201009242227.o8OMRbxj028968@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56287 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755320Ab0IXW2D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Sep 2010 18:28:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, chris.mason@oracle.com


The patch titled
     fs/btrfs/inode.c: eliminate memory leak
has been added to the -mm tree.  Its filename is
     fs-btrfs-inodec-eliminate-memory-leak.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

 fs/btrfs/inode.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff -puN fs/btrfs/inode.c~fs-btrfs-inodec-eliminate-memory-leak fs/btrfs/inode.c
--- a/fs/btrfs/inode.c~fs-btrfs-inodec-eliminate-memory-leak
+++ a/fs/btrfs/inode.c
@@ -4426,15 +4426,14 @@ static struct inode *btrfs_new_inode(str
 	BUG_ON(!path);
 
 	inode = new_inode(root->fs_info->sb);
-	if (!inode)
-		return ERR_PTR(-ENOMEM);
-
+	if (!inode) {
+		ret = -ENOMEM;
+		goto fail_path;
+	}
 	if (dir) {
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
@@ -4507,8 +4506,10 @@ static struct inode *btrfs_new_inode(str
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
drivers-char-agp-parisc-agpc-eliminate-memory-leak.patch
fs-btrfs-use-memdup_user.patch
fs-btrfs-use-err_cast.patch
fs-btrfs-inodec-eliminate-memory-leak.patch
arch-x86-kernel-cpu-cpufreq-fix-unsigned-return-type.patch
drivers-i2c-busses-i2c-pasemic-fix-unsigned-return-type.patch
drivers-video-matrox-matroxfb_mavenc-fix-unsigned-return-type.patch

