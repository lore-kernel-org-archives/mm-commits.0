From: akpm@linux-foundation.org
Subject: + bfs-assorted-cleanups.patch added to -mm tree
Date: Thu, 05 Jun 2008 11:40:26 -0700
Message-ID: <200806051840.m55IeQFI024023@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38995 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758395AbYFESkt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2008 14:40:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmitri.vorobiev@movial.fi, tigran_aivazian@symantec.com


The patch titled
     bfs: assorted cleanups
has been added to the -mm tree.  Its filename is
     bfs-assorted-cleanups.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

bfs-assorted-cleanups.patch
bfs-kill-bkl.patch

