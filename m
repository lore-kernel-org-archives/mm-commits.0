From: akpm@linux-foundation.org
Subject: - ecryptfs-ecryptfs_setattr-bugfix.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:00:57 -0700
Message-ID: <200707192000.l6JK0vj2019490@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35740 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761406AbXGSUSB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:18:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhalcrow@us.ibm.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     eCryptfs: ecryptfs_setattr() bugfix
has been removed from the -mm tree.  Its filename was
     ecryptfs-ecryptfs_setattr-bugfix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: eCryptfs: ecryptfs_setattr() bugfix
From: Michael Halcrow <mhalcrow@us.ibm.com>

There is another bug recently introduced into the ecryptfs_setattr()
function in 2.6.22.  eCryptfs will attempt to treat special files like
regular eCryptfs files on chmod, chown, and so forth.  This leads to a NULL
pointer dereference.  This patch validates that the file is a regular file
before proceeding with operations related to the inode's crypt_stat.

Thanks to Ryusuke Konishi for finding this bug and suggesting the fix.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/inode.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/ecryptfs/inode.c~ecryptfs-ecryptfs_setattr-bugfix fs/ecryptfs/inode.c
--- a/fs/ecryptfs/inode.c~ecryptfs-ecryptfs_setattr-bugfix
+++ a/fs/ecryptfs/inode.c
@@ -902,8 +902,9 @@ static int ecryptfs_setattr(struct dentr
 	mutex_lock(&crypt_stat->cs_mutex);
 	if (S_ISDIR(dentry->d_inode->i_mode))
 		crypt_stat->flags &= ~(ECRYPTFS_ENCRYPTED);
-	else if (!(crypt_stat->flags & ECRYPTFS_POLICY_APPLIED)
-		 || !(crypt_stat->flags & ECRYPTFS_KEY_VALID)) {
+	else if (S_ISREG(dentry->d_inode->i_mode)
+		 && (!(crypt_stat->flags & ECRYPTFS_POLICY_APPLIED)
+		     || !(crypt_stat->flags & ECRYPTFS_KEY_VALID))) {
 		struct vfsmount *lower_mnt;
 		struct file *lower_file = NULL;
 		struct ecryptfs_mount_crypt_stat *mount_crypt_stat;
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

origin.patch
git-unionfs.patch
fs-remove-some-aop_truncated_page.patch
