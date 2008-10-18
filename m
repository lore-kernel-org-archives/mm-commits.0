From: akpm@linux-foundation.org
Subject: - ecryptfs-remove-retry-loop-in-ecryptfs_readdir.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:14:52 -0700
Message-ID: <200810182314.m9INEqPi028480@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35707 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751485AbYJRXO4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:14:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhalcrow@us.ibm.com, viro@ZinIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     eCryptfs: remove retry loop in ecryptfs_readdir()
has been removed from the -mm tree.  Its filename was
     ecryptfs-remove-retry-loop-in-ecryptfs_readdir.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: eCryptfs: remove retry loop in ecryptfs_readdir()
From: Michael Halcrow <mhalcrow@us.ibm.com>

The retry block in ecryptfs_readdir() has been in the eCryptfs code base
for a while, apparently for no good reason.  This loop could potentially
run without terminating.  This patch removes the loop, instead erroring
out if vfs_readdir() on the lower file fails.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Reported-by: Al Viro <viro@ZinIV.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/file.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff -puN fs/ecryptfs/file.c~ecryptfs-remove-retry-loop-in-ecryptfs_readdir fs/ecryptfs/file.c
--- a/fs/ecryptfs/file.c~ecryptfs-remove-retry-loop-in-ecryptfs_readdir
+++ a/fs/ecryptfs/file.c
@@ -71,12 +71,11 @@ struct ecryptfs_getdents_callback {
 	void *dirent;
 	struct dentry *dentry;
 	filldir_t filldir;
-	int err;
 	int filldir_called;
 	int entries_written;
 };
 
-/* Inspired by generic filldir in fs/readir.c */
+/* Inspired by generic filldir in fs/readdir.c */
 static int
 ecryptfs_filldir(void *dirent, const char *name, int namelen, loff_t offset,
 		 u64 ino, unsigned int d_type)
@@ -125,18 +124,18 @@ static int ecryptfs_readdir(struct file 
 	buf.dirent = dirent;
 	buf.dentry = file->f_path.dentry;
 	buf.filldir = filldir;
-retry:
 	buf.filldir_called = 0;
 	buf.entries_written = 0;
-	buf.err = 0;
 	rc = vfs_readdir(lower_file, ecryptfs_filldir, (void *)&buf);
-	if (buf.err)
-		rc = buf.err;
-	if (buf.filldir_called && !buf.entries_written)
-		goto retry;
 	file->f_pos = lower_file->f_pos;
+	if (rc < 0)
+		goto out;
+	if (buf.filldir_called && !buf.entries_written)
+		goto out;
 	if (rc >= 0)
-		fsstack_copy_attr_atime(inode, lower_file->f_path.dentry->d_inode);
+		fsstack_copy_attr_atime(inode,
+					lower_file->f_path.dentry->d_inode);
+out:
 	return rc;
 }
 
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

origin.patch

