From: akpm@linux-foundation.org
Subject: + ecryptfs-use-generic_file_splice_read.patch added to -mm tree
Date: Fri, 14 Sep 2007 04:29:57 -0700
Message-ID: <200709141129.l8EBTvYn002638@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34645 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753211AbXINLac (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Sep 2007 07:30:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com, jens.axboe@oracle.com


The patch titled
     eCryptfs: Use generic_file_splice_read()
has been added to the -mm tree.  Its filename is
     ecryptfs-use-generic_file_splice_read.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: eCryptfs: Use generic_file_splice_read()
From: Michael Halcrow <mhalcrow@us.ibm.com>

eCryptfs is currently just passing through splice reads to the lower
filesystem.  This is obviously incorrect behavior; the decrypted data is
what needs to be read, not the lower encrypted data.  I cannot think of any
good reason for eCryptfs to implement splice_read, so this patch points the
eCryptfs fops splice_read to use generic_file_splice_read.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
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

documentation-00-index-notice-ecryptfstxt-moved.patch
git-unionfs.patch
fs-remove-some-aop_truncated_page.patch
ecryptfs-add-key-list-structure-search-keyring.patch
ecryptfs-use-list_for_each_entry_safe-when-wiping-auth-toks.patch
ecryptfs-kmem_cache-objects-for-multiple-keys-init-exit-functions.patch
ecryptfs-fix-tag-1-parsing-code.patch
ecryptfs-fix-tag-3-parsing-code.patch
ecryptfs-fix-tag-11-parsing-code.patch
ecryptfs-fix-tag-11-writing-code.patch
ecryptfs-update-comment-and-debug-statement.patch
ecryptfs-printk-warning-fixes.patch
ecryptfs-remove-unnecessary-bug_on.patch
ecryptfs-collapse-flag-set-into-one-statement.patch
ecryptfs-grammatical-fix-destruct-to-destroy.patch
ecryptfs-comments-for-some-structs.patch
ecryptfs-kerneldoc-fixes-for-cryptoc-and-keystorec.patch
ecryptfs-remove-unnecessary-variable-initializations.patch
ecryptfs-make-needlessly-global-symbols-static.patch
ecryptfs-use-generic_file_splice_read.patch
