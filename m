From: akpm@linux-foundation.org
Subject: - ecryptfs-use-generic_file_splice_read.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:40:42 -0700
Message-ID: <200710162040.l9GKegox015714@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42858 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936084AbXJPVIu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:08:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhalcrow@us.ibm.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     eCryptfs: Use generic_file_splice_read()
has been removed from the -mm tree.  Its filename was
     ecryptfs-use-generic_file_splice_read.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: eCryptfs: Use generic_file_splice_read()
From: Michael Halcrow <mhalcrow@us.ibm.com>

eCryptfs is currently just passing through splice reads to the lower
filesystem.  This is obviously incorrect behavior; the decrypted data is
what needs to be read, not the lower encrypted data.  I cannot think of any
good reason for eCryptfs to implement splice_read, so this patch points the
eCryptfs fops splice_read to use generic_file_splice_read.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Reviewed-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/file.c |   19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff -puN fs/ecryptfs/file.c~ecryptfs-use-generic_file_splice_read fs/ecryptfs/file.c
--- a/fs/ecryptfs/file.c~ecryptfs-use-generic_file_splice_read
+++ a/fs/ecryptfs/file.c
@@ -338,21 +338,6 @@ static int ecryptfs_fasync(int fd, struc
 	return rc;
 }
 
-static ssize_t ecryptfs_splice_read(struct file *file, loff_t * ppos,
-				    struct pipe_inode_info *pipe, size_t count,
-				    unsigned int flags)
-{
-	struct file *lower_file = NULL;
-	int rc = -EINVAL;
-
-	lower_file = ecryptfs_file_to_lower(file);
-	if (lower_file->f_op && lower_file->f_op->splice_read)
-		rc = lower_file->f_op->splice_read(lower_file, ppos, pipe,
-						count, flags);
-
-	return rc;
-}
-
 static int ecryptfs_ioctl(struct inode *inode, struct file *file,
 			  unsigned int cmd, unsigned long arg);
 
@@ -365,7 +350,7 @@ const struct file_operations ecryptfs_di
 	.release = ecryptfs_release,
 	.fsync = ecryptfs_fsync,
 	.fasync = ecryptfs_fasync,
-	.splice_read = ecryptfs_splice_read,
+	.splice_read = generic_file_splice_read,
 };
 
 const struct file_operations ecryptfs_main_fops = {
@@ -382,7 +367,7 @@ const struct file_operations ecryptfs_ma
 	.release = ecryptfs_release,
 	.fsync = ecryptfs_fsync,
 	.fasync = ecryptfs_fasync,
-	.splice_read = ecryptfs_splice_read,
+	.splice_read = generic_file_splice_read,
 };
 
 static int
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

origin.patch
git-unionfs.patch
ecryptfs-allow-lower-fs-to-interpret-attr_kill_sid.patch
vfs-make-notify_change-pass-attr_kill_sid-to-setattr-operations.patch
