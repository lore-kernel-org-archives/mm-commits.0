From: akpm@linux-foundation.org
Subject: + bfs-add-some-basic-sanity-checks.patch added to -mm tree
Date: Tue, 21 Oct 2008 15:15:38 -0700
Message-ID: <200810212215.m9LMFdKt000300@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53131 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753092AbYJUWPs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Oct 2008 18:15:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: snakebyte@gmx.de, tigran@aivazian.fsnet.co.uk


The patch titled
     bfs: add some basic sanity checks
has been added to the -mm tree.  Its filename is
     bfs-add-some-basic-sanity-checks.patch

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
Subject: bfs: add some basic sanity checks
From: Eric Sesterhenn <snakebyte@gmx.de>

bfs_fill_super() already touches all inodes, so we can easily add some
cheap sanity checks and check if the inode start and end blocks are
smaller than the maximum number of blocks, the inode start block lies
behind the end block or the file end offset is behind the end of the
filesystem.  Also check if the start of data offset in the super block
fits the filesystem.

The added sanity checks catch softlockup issues early when we try to
sb_bread() lots of blocks in a loop in bfs_readdir() and bfs_find_entry().
 In addition an oom issue in bfs_fill_super() is prevented by this when
s_start is corrupted, which influences imap_len and we try to allocate a
huge info->si_imap.

Signed-off-by: Eric Sesterhenn <snakebyte@gmx.de>
Acked-by: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/bfs/inode.c |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff -puN fs/bfs/inode.c~bfs-add-some-basic-sanity-checks fs/bfs/inode.c
--- a/fs/bfs/inode.c~bfs-add-some-basic-sanity-checks
+++ a/fs/bfs/inode.c
@@ -213,6 +213,9 @@ static void bfs_put_super(struct super_b
 {
 	struct bfs_sb_info *info = BFS_SB(s);
 
+	if (!info)
+		return;
+
 	brelse(info->si_sbh);
 	mutex_destroy(&info->bfs_lock);
 	kfree(info->si_imap);
@@ -327,6 +330,7 @@ static int bfs_fill_super(struct super_b
 	unsigned i, imap_len;
 	struct bfs_sb_info *info;
 	long ret = -EINVAL;
+	unsigned long i_sblock, i_eblock, i_eoff, s_size;
 
 	info = kzalloc(sizeof(*info), GFP_KERNEL);
 	if (!info)
@@ -350,6 +354,12 @@ static int bfs_fill_super(struct super_b
 
 	s->s_magic = BFS_MAGIC;
 	info->si_sbh = bh;
+
+	if (le32_to_cpu(bfs_sb->s_start) > le32_to_cpu(bfs_sb->s_end)) {
+		printf("Superblock is corrupted\n");
+		goto out;
+	}
+
 	info->si_lasti = (le32_to_cpu(bfs_sb->s_start) - BFS_BSIZE) /
 					sizeof(struct bfs_inode)
 					+ BFS_ROOT_INO - 1;
@@ -397,6 +407,29 @@ static int bfs_fill_super(struct super_b
 
 		di = (struct bfs_inode *)bh->b_data + off;
 
+		/* test if filesystem is not corrupted */
+
+		i_eoff = le32_to_cpu(di->i_eoffset);
+		i_sblock = le32_to_cpu(di->i_sblock);
+		i_eblock = le32_to_cpu(di->i_eblock);
+		s_size = le32_to_cpu(bfs_sb->s_end);
+
+		if (i_sblock > info->si_blocks ||
+			i_eblock > info->si_blocks ||
+			i_sblock > i_eblock ||
+			i_eoff > s_size ||
+			i_sblock * BFS_BSIZE > i_eoff) {
+
+			printf("Inode 0x%08x corrupted\n", i);
+
+			brelse(bh);
+			s->s_root = NULL;
+			kfree(info->si_imap);
+			kfree(info);
+			s->s_fs_info = NULL;
+			return -EIO;
+		}
+
 		if (!di->i_ino) {
 			info->si_freei++;
 			continue;
_

Patches currently in -mm which might be from snakebyte@gmx.de are

origin.patch
linux-next.patch
bfs-add-some-basic-sanity-checks.patch
bfs-check-that-filesystem-fits-on-the-blockdevice.patch

