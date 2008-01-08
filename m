From: akpm@linux-foundation.org
Subject: + ecryptfs-fix-dentry-handling-on-create-error-unlink-and-inode-destroy.patch added to -mm tree
Date: Mon, 07 Jan 2008 21:44:23 -0800
Message-ID: <200801080544.m085i3f3030224@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40409 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752840AbYAHFou (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Jan 2008 00:44:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com, jmoyer@redhat.com, sandeen@redhat.com, shaggy@austin.ibm.com


The patch titled
     eCryptfs: fix dentry handling on create error, unlink, and inode destroy
has been added to the -mm tree.  Its filename is
     ecryptfs-fix-dentry-handling-on-create-error-unlink-and-inode-destroy.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: eCryptfs: fix dentry handling on create error, unlink, and inode destroy
From: Michael Halcrow <mhalcrow@us.ibm.com>

This patch corrects some erroneous dentry handling in eCryptfs.

If there is a problem creating the lower file, then there is nothing that
the persistent lower file can do to really help us.  This patch makes a
vfs_create() failure in the lower filesystem always lead to an
unconditional do_create failure in eCryptfs.

Under certain sequences of operations, the eCryptfs dentry can remain in
the dcache after an unlink.  This patch calls d_drop() on the eCryptfs
dentry to correct this.

eCryptfs has no business calling d_delete() directly on a lower
filesystem's dentry.  This patch removes the call to d_delete() on the
lower persistent file's dentry in ecryptfs_destroy_inode().

(Thanks to David Kleikamp, Eric Sandeen, and Jeff Moyer for helping
identify and resolve this issue)

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: Dave Kleikamp <shaggy@austin.ibm.com>
Cc: Eric Sandeen <sandeen@redhat.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/inode.c |   20 ++++----------------
 fs/ecryptfs/super.c |    1 -
 2 files changed, 4 insertions(+), 17 deletions(-)

diff -puN fs/ecryptfs/inode.c~ecryptfs-fix-dentry-handling-on-create-error-unlink-and-inode-destroy fs/ecryptfs/inode.c
--- a/fs/ecryptfs/inode.c~ecryptfs-fix-dentry-handling-on-create-error-unlink-and-inode-destroy
+++ a/fs/ecryptfs/inode.c
@@ -120,22 +120,9 @@ ecryptfs_do_create(struct inode *directo
 	rc = ecryptfs_create_underlying_file(lower_dir_dentry->d_inode,
 					     ecryptfs_dentry, mode, nd);
 	if (rc) {
-		struct inode *ecryptfs_inode = ecryptfs_dentry->d_inode;
-		struct ecryptfs_inode_info *inode_info =
-			ecryptfs_inode_to_private(ecryptfs_inode);
-
-		printk(KERN_WARNING "%s: Error creating underlying file; "
-		       "rc = [%d]; checking for existing\n", __FUNCTION__, rc);
-		if (inode_info) {
-			mutex_lock(&inode_info->lower_file_mutex);
-			if (!inode_info->lower_file) {
-				mutex_unlock(&inode_info->lower_file_mutex);
-				printk(KERN_ERR "%s: Failure to set underlying "
-				       "file; rc = [%d]\n", __FUNCTION__, rc);
-				goto out_lock;
-			}
-			mutex_unlock(&inode_info->lower_file_mutex);
-		}
+		printk(KERN_ERR "%s: Failure to create dentry in lower fs; "
+		       "rc = [%d]\n", __FUNCTION__, rc);
+		goto out_lock;
 	}
 	rc = ecryptfs_interpose(lower_dentry, ecryptfs_dentry,
 				directory_inode->i_sb, 0);
@@ -451,6 +438,7 @@ static int ecryptfs_unlink(struct inode 
 	dentry->d_inode->i_nlink =
 		ecryptfs_inode_to_lower(dentry->d_inode)->i_nlink;
 	dentry->d_inode->i_ctime = dir->i_ctime;
+	d_drop(dentry);
 out_unlock:
 	unlock_parent(lower_dentry);
 	return rc;
diff -puN fs/ecryptfs/super.c~ecryptfs-fix-dentry-handling-on-create-error-unlink-and-inode-destroy fs/ecryptfs/super.c
--- a/fs/ecryptfs/super.c~ecryptfs-fix-dentry-handling-on-create-error-unlink-and-inode-destroy
+++ a/fs/ecryptfs/super.c
@@ -86,7 +86,6 @@ static void ecryptfs_destroy_inode(struc
 			fput(inode_info->lower_file);
 			inode_info->lower_file = NULL;
 			d_drop(lower_dentry);
-			d_delete(lower_dentry);
 		}
 	}
 	mutex_unlock(&inode_info->lower_file_mutex);
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

ecryptfs-fix-dentry-handling-on-create-error-unlink-and-inode-destroy.patch
git-unionfs.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix-2.patch
fs-ecryptfs-possible-cleanups.patch
ecryptfs-track-header-bytes-rather-than-extents.patch
ecryptfs-set-inode-key-only-once-per-crypto-operation.patch
ecryptfs-make-show_options-reflect-actual-mount-options.patch
ecryptfs-make-show_options-reflect-actual-mount-options-fix.patch
ecryptfs-remove-debug-as-mount-option-and-warn-if-set-via-modprobe.patch
ecryptfs-minor-fixes-to-printk-messages.patch
ecryptfs-change-the-type-of-cipher_code-from-u16-to-u8.patch
ecryptfs-load-each-file-decryption-key-only-once.patch
ecryptfs-check-for-existing-key_tfm-at-mount-time.patch
d_path-make-d_path-use-a-struct-path.patch
