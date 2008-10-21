From: akpm@linux-foundation.org
Subject: + bfs-check-that-filesystem-fits-on-the-blockdevice.patch added to -mm tree
Date: Tue, 21 Oct 2008 15:15:41 -0700
Message-ID: <200810212215.m9LMFfVa000312@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45733 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753108AbYJUWPv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Oct 2008 18:15:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: snakebyte@gmx.de, tigran@aivazian.fsnet.co.uk


The patch titled
     bfs: check that filesystem fits on the blockdevice
has been added to the -mm tree.  Its filename is
     bfs-check-that-filesystem-fits-on-the-blockdevice.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

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
bfs-add-some-basic-sanity-checks.patch
bfs-check-that-filesystem-fits-on-the-blockdevice.patch

