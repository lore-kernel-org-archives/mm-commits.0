From: akpm@linux-foundation.org
Subject: + ecryptfs-ecryptfs_setattr-bugfix.patch added to -mm tree
Date: Tue, 17 Jul 2007 17:07:16 -0700
Message-ID: <200707180007.l6I07GO2014708@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59822 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760003AbXGRAHd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 20:07:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com, stable@kernel.org


The patch titled
     eCryptfs: ecryptfs_setattr() bugfix
has been added to the -mm tree.  Its filename is
     ecryptfs-ecryptfs_setattr-bugfix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/ecryptfs/inode.c~ecryptfs-ecryptfs_setattr-bugfix fs/ecryptfs/inode.c
--- a/fs/ecryptfs/inode.c~ecryptfs-ecryptfs_setattr-bugfix
+++ a/fs/ecryptfs/inode.c
@@ -908,8 +908,9 @@ static int ecryptfs_setattr(struct dentr
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
ecryptfs-ecryptfs_setattr-bugfix.patch
fs-introduce-vfs_path_lookup.patch
sunrpc-use-vfs_path_lookup.patch
nfsctl-use-vfs_path_lookup.patch
fs-mark-link_path_walk-static.patch
fs-remove-path_walk-export.patch
