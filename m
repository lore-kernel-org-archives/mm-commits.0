From: akpm@linux-foundation.org
Subject: - bfs-assorted-cleanups.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:13:39 -0700
Message-ID: <200807262113.m6QLDdlj019613@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53727 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757433AbYGZVNv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:13:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dmitri.vorobiev@movial.fi, tigran_aivazian@symantec.com, mm-commits@vger.kernel.org


The patch titled
     bfs: assorted cleanups
has been removed from the -mm tree.  Its filename was
     bfs-assorted-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bfs: assorted cleanups
From: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>

This patch makes the following cleanups:

	o removing an unused variable from bfs_fill_super();
	o removing unneeded blank spaces from pointer
	  definitions.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
Cc: Tigran Aivazian <tigran_aivazian@symantec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/bfs/bfs.h   |    4 ++--
 fs/bfs/inode.c |    3 +--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff -puN fs/bfs/bfs.h~bfs-assorted-cleanups fs/bfs/bfs.h
--- a/fs/bfs/bfs.h~bfs-assorted-cleanups
+++ a/fs/bfs/bfs.h
@@ -16,8 +16,8 @@ struct bfs_sb_info {
 	unsigned long si_freei;
 	unsigned long si_lf_eblk;
 	unsigned long si_lasti;
-	unsigned long * si_imap;
-	struct buffer_head * si_sbh;		/* buffer header w/superblock */
+	unsigned long *si_imap;
+	struct buffer_head *si_sbh;		/* buffer header w/superblock */
 };
 
 /*
diff -puN fs/bfs/inode.c~bfs-assorted-cleanups fs/bfs/inode.c
--- a/fs/bfs/inode.c~bfs-assorted-cleanups
+++ a/fs/bfs/inode.c
@@ -380,7 +380,7 @@ static int bfs_fill_super(struct super_b
 		struct bfs_inode *di;
 		int block = (i - BFS_ROOT_INO) / BFS_INODES_PER_BLOCK + 1;
 		int off = (i - BFS_ROOT_INO) % BFS_INODES_PER_BLOCK;
-		unsigned long sblock, eblock;
+		unsigned long eblock;
 
 		if (!off) {
 			brelse(bh);
@@ -399,7 +399,6 @@ static int bfs_fill_super(struct super_b
 		set_bit(i, info->si_imap);
 		info->si_freeb -= BFS_FILEBLOCKS(di);
 
-		sblock =  le32_to_cpu(di->i_sblock);
 		eblock =  le32_to_cpu(di->i_eblock);
 		if (eblock > info->si_lf_eblk)
 			info->si_lf_eblk = eblock;
_

Patches currently in -mm which might be from dmitri.vorobiev@movial.fi are

origin.patch

