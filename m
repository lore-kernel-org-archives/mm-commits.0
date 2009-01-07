From: akpm@linux-foundation.org
Subject: - bfs-check-that-filesystem-fits-on-the-blockdevice.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:21:09 -0800
Message-ID: <200901072221.n07ML9dK020327@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51491 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762126AbZAGWWG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:22:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: snakebyte@gmx.de, tigran@aivazian.fsnet.co.uk, mm-commits@vger.kernel.org


The patch titled
     bfs: check that filesystem fits on the blockdevice
has been removed from the -mm tree.  Its filename was
     bfs-check-that-filesystem-fits-on-the-blockdevice.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bfs: check that filesystem fits on the blockdevice
From: Eric Sesterhenn <snakebyte@gmx.de>

Since all sanity checks rely on the validity of s_start which gets only
checked to be smaller than s_end, we should also check if s_end is sane. 
Now we also try to retrieve the last block of the filesystem, which is
computed by s_end.  If this fails, something is bogus.

Signed-off-by: Eric Sesterhenn <snakebyte@gmx.de>
Acked-by: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/bfs/inode.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN fs/bfs/inode.c~bfs-check-that-filesystem-fits-on-the-blockdevice fs/bfs/inode.c
--- a/fs/bfs/inode.c~bfs-check-that-filesystem-fits-on-the-blockdevice
+++ a/fs/bfs/inode.c
@@ -390,6 +390,18 @@ static int bfs_fill_super(struct super_b
 			- le32_to_cpu(bfs_sb->s_start)) >> BFS_BSIZE_BITS;
 	info->si_freei = 0;
 	info->si_lf_eblk = 0;
+
+	/* can we read the last block? */
+	bh = sb_bread(s, info->si_blocks - 1);
+	if (!bh) {
+		printf("Last block not available: %lu\n", info->si_blocks - 1);
+		iput(inode);
+		ret = -EIO;
+		kfree(info->si_imap);
+		goto out;
+	}
+	brelse(bh);
+
 	bh = NULL;
 	for (i = BFS_ROOT_INO; i <= info->si_lasti; i++) {
 		struct bfs_inode *di;
_

Patches currently in -mm which might be from snakebyte@gmx.de are

origin.patch
linux-next.patch

