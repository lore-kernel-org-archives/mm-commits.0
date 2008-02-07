From: akpm@linux-foundation.org
Subject: - ecryptfs-minor-fixes-to-printk-messages.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:26:50 -0800
Message-ID: <200802070026.m170QVC4006925@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45143 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764712AbYBGApb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:45:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike@halcrow.us, mhalcrow@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     eCryptfs: Minor fixes to printk messages
has been removed from the -mm tree.  Its filename was
     ecryptfs-minor-fixes-to-printk-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: eCryptfs: Minor fixes to printk messages
From: Michael Halcrow <mike@halcrow.us>

The printk statements that result when the user does not have the
proper key available could use some refining.

Signed-off-by: Mike Halcrow <mhalcrow@us.ibm.com>
Cc: Mike Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/crypto.c |    7 ++++---
 fs/ecryptfs/file.c   |    5 +++--
 fs/ecryptfs/inode.c  |    6 +++---
 3 files changed, 10 insertions(+), 8 deletions(-)

diff -puN fs/ecryptfs/crypto.c~ecryptfs-minor-fixes-to-printk-messages fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~ecryptfs-minor-fixes-to-printk-messages
+++ a/fs/ecryptfs/crypto.c
@@ -1527,9 +1527,10 @@ int ecryptfs_read_xattr_region(char *pag
 	size = ecryptfs_getxattr_lower(lower_dentry, ECRYPTFS_XATTR_NAME,
 				       page_virt, ECRYPTFS_DEFAULT_EXTENT_SIZE);
 	if (size < 0) {
-		printk(KERN_ERR "Error attempting to read the [%s] "
-		       "xattr from the lower file; return value = [%zd]\n",
-		       ECRYPTFS_XATTR_NAME, size);
+		if (unlikely(ecryptfs_verbosity > 0))
+			printk(KERN_INFO "Error attempting to read the [%s] "
+			       "xattr from the lower file; return value = "
+			       "[%zd]\n", ECRYPTFS_XATTR_NAME, size);
 		rc = -EINVAL;
 		goto out;
 	}
diff -puN fs/ecryptfs/file.c~ecryptfs-minor-fixes-to-printk-messages fs/ecryptfs/file.c
--- a/fs/ecryptfs/file.c~ecryptfs-minor-fixes-to-printk-messages
+++ a/fs/ecryptfs/file.c
@@ -209,9 +209,10 @@ static int ecryptfs_open(struct inode *i
 			if (!(mount_crypt_stat->flags
 			      & ECRYPTFS_PLAINTEXT_PASSTHROUGH_ENABLED)) {
 				rc = -EIO;
-				printk(KERN_WARNING "Attempt to read file that "
+				printk(KERN_WARNING "Either the lower file "
 				       "is not in a valid eCryptfs format, "
-				       "and plaintext passthrough mode is not "
+				       "or the key could not be retrieved. "
+				       "Plaintext passthrough mode is not "
 				       "enabled; returning -EIO\n");
 				mutex_unlock(&crypt_stat->cs_mutex);
 				goto out_free;
diff -puN fs/ecryptfs/inode.c~ecryptfs-minor-fixes-to-printk-messages fs/ecryptfs/inode.c
--- a/fs/ecryptfs/inode.c~ecryptfs-minor-fixes-to-printk-messages
+++ a/fs/ecryptfs/inode.c
@@ -873,11 +873,11 @@ static int ecryptfs_setattr(struct dentr
 			if (!(mount_crypt_stat->flags
 			      & ECRYPTFS_PLAINTEXT_PASSTHROUGH_ENABLED)) {
 				rc = -EIO;
-				printk(KERN_WARNING "Attempt to read file that "
+				printk(KERN_WARNING "Either the lower file "
 				       "is not in a valid eCryptfs format, "
-				       "and plaintext passthrough mode is not "
+				       "or the key could not be retrieved. "
+				       "Plaintext passthrough mode is not "
 				       "enabled; returning -EIO\n");
-
 				mutex_unlock(&crypt_stat->cs_mutex);
 				goto out;
 			}
_

Patches currently in -mm which might be from mike@halcrow.us are

origin.patch
