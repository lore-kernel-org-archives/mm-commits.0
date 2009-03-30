From: akpm@linux-foundation.org
Subject: [merged] ufs-ensure-fast-symlinks-are-nul-terminated.patch removed from -mm tree
Date: Mon, 30 Mar 2009 12:07:18 -0700
Message-ID: <200903301907.n2UJ7IL1019322@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43987 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754403AbZC3TJL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 15:09:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: duaneg@dghda.com, mm-commits@vger.kernel.org


The patch titled
     ufs: ensure fast symlinks are NUL-terminated
has been removed from the -mm tree.  Its filename was
     ufs-ensure-fast-symlinks-are-nul-terminated.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ufs: ensure fast symlinks are NUL-terminated
From: Duane Griffin <duaneg@dghda.com>

Ensure fast symlink targets are NUL-terminated, even if corrupted
on-disk.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/inode.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN fs/ufs/inode.c~ufs-ensure-fast-symlinks-are-nul-terminated fs/ufs/inode.c
--- a/fs/ufs/inode.c~ufs-ensure-fast-symlinks-are-nul-terminated
+++ a/fs/ufs/inode.c
@@ -650,7 +650,8 @@ static int ufs1_read_inode(struct inode 
 		       sizeof(ufs_inode->ui_u2.ui_addr));
 	} else {
 		memcpy(ufsi->i_u1.i_symlink, ufs_inode->ui_u2.ui_symlink,
-		       sizeof(ufs_inode->ui_u2.ui_symlink));
+		       sizeof(ufs_inode->ui_u2.ui_symlink) - 1);
+		ufsi->i_u1.i_symlink[sizeof(ufs_inode->ui_u2.ui_symlink) - 1] = 0;
 	}
 	return 0;
 }
@@ -698,7 +699,8 @@ static int ufs2_read_inode(struct inode 
 		       sizeof(ufs2_inode->ui_u2.ui_addr));
 	} else {
 		memcpy(ufsi->i_u1.i_symlink, ufs2_inode->ui_u2.ui_symlink,
-		       sizeof(ufs2_inode->ui_u2.ui_symlink));
+		       sizeof(ufs2_inode->ui_u2.ui_symlink) - 1);
+		ufsi->i_u1.i_symlink[sizeof(ufs2_inode->ui_u2.ui_symlink) - 1] = 0;
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from duaneg@dghda.com are

origin.patch
linux-next.patch

