From: akpm@linux-foundation.org
Subject: + coda-allow-removal-of-busy-directories.patch added to -mm tree
Date: Thu, 12 Jul 2007 22:29:32 -0700
Message-ID: <200707130529.l6D5TW6V030793@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44688 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751738AbXGMFaM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 01:30:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jaharkes@cs.cmu.edu


The patch titled
     coda: allow removal of busy directories
has been added to the -mm tree.  Its filename is
     coda-allow-removal-of-busy-directories.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

coda-do-not-grab-an-uninitialized-fd-when-the-open-upcall-returns-an-error.patch
coda-correctly-invalidate-cached-access-rights.patch
coda-fix-nlink-updates-for-directories.patch
coda-allow-removal-of-busy-directories.patch
coda-coda-doesnt-track-atime.patch
coda-use-ilookup5.patch
coda-cleanup-dev-cfs-open-and-close-handling.patch
coda-cleanup-for-upcall-handling-path.patch
coda-block-signals-during-upcall-processing.patch
coda-avoid-lockdep-warning-in-coda_readdir.patch
coda-replace-upc_alloc-upc_free-with-kmalloc-kfree.patch
coda-ignore-returned-values-when-upcalls-return-errors.patch
coda-cleanup-coda_lookup-use-dsplice_alias.patch
coda-cleanup-downcall-handler.patch
coda-remove-struct-coda_sb_info.patch
coda-remove-statistics-counters-from-proc-fs-coda.patch
coda-update-module-information.patch
