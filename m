From: akpm@linux-foundation.org
Subject: [merged] ufs-validate-maximum-fast-symlink-size-from-superblock.patch removed from -mm tree
Date: Mon, 30 Mar 2009 12:07:13 -0700
Message-ID: <200903301907.n2UJ7DC8019313@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40208 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759298AbZC3TJG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 15:09:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: duaneg@dghda.com, mm-commits@vger.kernel.org


The patch titled
     ufs: validate maximum fast symlink size from superblock
has been removed from the -mm tree.  Its filename was
     ufs-validate-maximum-fast-symlink-size-from-superblock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

