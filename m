From: akpm@linux-foundation.org
Subject: + ufs-validate-maximum-fast-symlink-size-from-superblock.patch added to -mm tree
Date: Tue, 13 Jan 2009 00:13:47 -0800
Message-ID: <200901130813.n0D8DlF2011024@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48023 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758767AbZAMIOT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Jan 2009 03:14:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: duaneg@dghda.com


The patch titled
     ufs: validate maximum fast symlink size from superblock
has been added to the -mm tree.  Its filename is
     ufs-validate-maximum-fast-symlink-size-from-superblock.patch

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
Subject: ufs: validate maximum fast symlink size from superblock
From: Duane Griffin <duaneg@dghda.com>

The maximum fast symlink size is set in the superblock of certain types
of UFS filesystem. Before using it we need to check that it isn't longer
than the available space we have in the inode.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/super.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN fs/ufs/super.c~ufs-validate-maximum-fast-symlink-size-from-superblock fs/ufs/super.c
--- a/fs/ufs/super.c~ufs-validate-maximum-fast-symlink-size-from-superblock
+++ a/fs/ufs/super.c
@@ -636,6 +636,7 @@ static int ufs_fill_super(struct super_b
 	unsigned block_size, super_block_size;
 	unsigned flags;
 	unsigned super_block_offset;
+	unsigned maxsymlen;
 	int ret = -EINVAL;
 
 	uspi = NULL;
@@ -1069,6 +1070,16 @@ magic_found:
 		uspi->s_maxsymlinklen =
 		    fs32_to_cpu(sb, usb3->fs_un2.fs_44.fs_maxsymlinklen);
 
+	if (uspi->fs_magic == UFS2_MAGIC)
+		maxsymlen = 2 * 4 * (UFS_NDADDR + UFS_NINDIR);
+	else
+		maxsymlen = 4 * (UFS_NDADDR + UFS_NINDIR);
+	if (uspi->s_maxsymlinklen > maxsymlen) {
+		ufs_warning(sb, __func__, "ufs_read_super: excessive maximum "
+			    "fast symlink size (%u)\n", uspi->s_maxsymlinklen);
+		uspi->s_maxsymlinklen = maxsymlen;
+	}
+
 	inode = ufs_iget(sb, UFS_ROOTINO);
 	if (IS_ERR(inode)) {
 		ret = PTR_ERR(inode);
_

Patches currently in -mm which might be from duaneg@dghda.com are

ext4-dont-inherit-inappropriate-inode-flags-from-parent.patch
ext4-tighten-restrictions-on-inode-flags.patch
ufs-validate-maximum-fast-symlink-size-from-superblock.patch
ufs-dont-truncate-longer-ufs2-fast-symlinks.patch
ufs-ensure-fast-symlinks-are-nul-terminated.patch
ufs-copy-symlink-data-into-the-correct-union-member.patch

