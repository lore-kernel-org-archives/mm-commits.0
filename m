From: akpm@linux-foundation.org
Subject: - ecryptfs-protect-crypt_stat-flags-in-ecryptfs_open.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:41:59 -0700
Message-ID: <200804300541.m3U5fxa5029099@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49127 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760312AbYD3GNT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:13:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhalcrow@us.ibm.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     eCryptfs: protect crypt_stat->flags in ecryptfs_open()
has been removed from the -mm tree.  Its filename was
     ecryptfs-protect-crypt_stat-flags-in-ecryptfs_open.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: eCryptfs: protect crypt_stat->flags in ecryptfs_open()
From: Michael Halcrow <mhalcrow@us.ibm.com>

Make sure crypt_stat->flags is protected with a lock in ecryptfs_open().

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/file.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/ecryptfs/file.c~ecryptfs-protect-crypt_stat-flags-in-ecryptfs_open fs/ecryptfs/file.c
--- a/fs/ecryptfs/file.c~ecryptfs-protect-crypt_stat-flags-in-ecryptfs_open
+++ a/fs/ecryptfs/file.c
@@ -195,7 +195,9 @@ static int ecryptfs_open(struct inode *i
 		file, ecryptfs_inode_to_private(inode)->lower_file);
 	if (S_ISDIR(ecryptfs_dentry->d_inode->i_mode)) {
 		ecryptfs_printk(KERN_DEBUG, "This is a directory\n");
+		mutex_lock(&crypt_stat->cs_mutex);
 		crypt_stat->flags &= ~(ECRYPTFS_ENCRYPTED);
+		mutex_unlock(&crypt_stat->cs_mutex);
 		rc = 0;
 		goto out;
 	}
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

origin.patch
git-unionfs.patch
notify_change-callers-must-hold-i_mutex.patch

