From: akpm@linux-foundation.org
Subject: - coda-allow-removal-of-busy-directories.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:03:01 -0700
Message-ID: <200707192003.l6JK31KS019813@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38707 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761463AbXGSUQX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:16:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jaharkes@cs.cmu.edu, mm-commits@vger.kernel.org


The patch titled
     coda: allow removal of busy directories
has been removed from the -mm tree.  Its filename was
     coda-allow-removal-of-busy-directories.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: coda: allow removal of busy directories
From: Jan Harkes <jaharkes@cs.cmu.edu>

A directory without children may still be busy when it is the cwd for some
process.  We can safely remove such a directory because the VFS prevents
further operations.  Also we don't need to call d_delete as it is already
called in vfs_rmdir.

Signed-off-by: Jan Harkes <jaharkes@cs.cmu.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coda/dir.c |   25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff -puN fs/coda/dir.c~coda-allow-removal-of-busy-directories fs/coda/dir.c
--- a/fs/coda/dir.c~coda-allow-removal-of-busy-directories
+++ a/fs/coda/dir.c
@@ -391,28 +391,23 @@ int coda_rmdir(struct inode *dir, struct
 {
 	const char *name = de->d_name.name;
 	int len = de->d_name.len;
-        int error;
+	int error;
 
 	lock_kernel();
 	coda_vfs_stat.rmdir++;
 
-	if (!d_unhashed(de)) {
-		unlock_kernel();
-		return -EBUSY;
-	}
 	error = venus_rmdir(dir->i_sb, coda_i2f(dir), name, len);
-
-	if ( error ) {
-		unlock_kernel();
-		return error;
+	if (!error) {
+		/* VFS may delete the child */
+		if (de->d_inode)
+		    de->d_inode->i_nlink = 0;
+
+		/* fix the link count of the parent */
+		coda_dir_drop_nlink(dir);
+		coda_dir_update_mtime(dir);
 	}
-
-	coda_dir_drop_nlink(dir);
-	coda_dir_update_mtime(dir);
-	drop_nlink(de->d_inode);
-	d_delete(de);
 	unlock_kernel();
-	return 0;
+	return error;
 }
 
 /* rename */
_

Patches currently in -mm which might be from jaharkes@cs.cmu.edu are

origin.patch
