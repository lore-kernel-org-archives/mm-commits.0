From: akpm@linux-foundation.org
Subject: - ecryptfs-set-o_largefile-when-opening-lower-file.patch removed from -mm tree
Date: Thu, 01 Mar 2007 21:06:37 -0800
Message-ID: <200703020506.l2256bHc000811@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42307 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422741AbXCBFGl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 00:06:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhalcrow@us.ibm.com, dmonakhov@openvz.org, mm-commits@vger.kernel.org


The patch titled
     eCryptfs: set O_LARGEFILE when opening lower file
has been removed from the -mm tree.  Its filename was
     ecryptfs-set-o_largefile-when-opening-lower-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: eCryptfs: set O_LARGEFILE when opening lower file
From: Michael Halcrow <mhalcrow@us.ibm.com>

O_LARGEFILE should be set here when opening the lower file.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: Dmitriy Monakhov <dmonakhov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/file.c  |    1 +
 fs/ecryptfs/inode.c |    3 ---
 2 files changed, 1 insertion(+), 3 deletions(-)

diff -puN fs/ecryptfs/file.c~ecryptfs-set-o_largefile-when-opening-lower-file fs/ecryptfs/file.c
--- a/fs/ecryptfs/file.c~ecryptfs-set-o_largefile-when-opening-lower-file
+++ a/fs/ecryptfs/file.c
@@ -205,6 +205,7 @@ int ecryptfs_open_lower_file(struct file
 {
 	int rc = 0;
 
+	flags |= O_LARGEFILE;
 	dget(lower_dentry);
 	mntget(lower_mnt);
 	*lower_file = dentry_open(lower_dentry, lower_mnt, flags);
diff -puN fs/ecryptfs/inode.c~ecryptfs-set-o_largefile-when-opening-lower-file fs/ecryptfs/inode.c
--- a/fs/ecryptfs/inode.c~ecryptfs-set-o_largefile-when-opening-lower-file
+++ a/fs/ecryptfs/inode.c
@@ -200,9 +200,6 @@ static int ecryptfs_initialize_file(stru
 	inode = ecryptfs_dentry->d_inode;
 	crypt_stat = &ecryptfs_inode_to_private(inode)->crypt_stat;
 	lower_flags = ((O_CREAT | O_TRUNC) & O_ACCMODE) | O_RDWR;
-#if BITS_PER_LONG != 32
-	lower_flags |= O_LARGEFILE;
-#endif
 	lower_mnt = ecryptfs_dentry_to_lower_mnt(ecryptfs_dentry);
 	/* Corresponding fput() at end of this function */
 	if ((rc = ecryptfs_open_lower_file(&lower_file, lower_dentry, lower_mnt,
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

origin.patch
ecryptfs-check-xattr-operation-support-fix.patch
git-unionfs.patch
ecryptfs-handles-aop_truncated_page-better.patch
