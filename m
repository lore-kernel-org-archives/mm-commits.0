From: akpm@linux-foundation.org
Subject: + ecryptfs-remove-retry-loop-in-ecryptfs_readdir.patch added to -mm tree
Date: Tue, 02 Sep 2008 15:34:04 -0700
Message-ID: <200809022234.m82MY4aG016290@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40460 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754843AbYIBWew (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Sep 2008 18:34:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com, viro@ZinIV.linux.org.uk


The patch titled
     eCryptfs: remove retry loop in ecryptfs_readdir()
has been added to the -mm tree.  Its filename is
     ecryptfs-remove-retry-loop-in-ecryptfs_readdir.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

ecryptfs-remove-retry-loop-in-ecryptfs_readdir.patch
notify_change-callers-must-hold-i_mutex.patch

