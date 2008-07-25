From: akpm@linux-foundation.org
Subject: - locks-cleanup-code-duplication.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:03:32 -0700
Message-ID: <200807252303.m6PN3WGR003959@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34071 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754050AbYGYXFI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:05:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, bfields@fieldses.org, hch@lst.de, matthew@wil.cx, teigland@redhat.com, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     locks: cleanup code duplication
has been removed from the -mm tree.  Its filename was
     locks-cleanup-code-duplication.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: locks: cleanup code duplication
From: Miklos Szeredi <mszeredi@suse.cz>

Extract common code into a function.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: David Teigland <teigland@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/locks.c |   71 ++++++++++++++++++++++-----------------------------
 1 file changed, 31 insertions(+), 40 deletions(-)

diff -puN fs/locks.c~locks-cleanup-code-duplication fs/locks.c
--- a/fs/locks.c~locks-cleanup-code-duplication
+++ a/fs/locks.c
@@ -1738,6 +1738,35 @@ int vfs_lock_file(struct file *filp, uns
 }
 EXPORT_SYMBOL_GPL(vfs_lock_file);
 
+static int do_lock_file_wait(struct file *filp, unsigned int cmd,
+			     struct file_lock *fl)
+{
+	int error;
+
+	error = security_file_lock(filp, fl->fl_type);
+	if (error)
+		return error;
+
+	if (filp->f_op && filp->f_op->lock != NULL)
+		error = filp->f_op->lock(filp, cmd, fl);
+	else {
+		for (;;) {
+			error = posix_lock_file(filp, fl, NULL);
+			if (error != FILE_LOCK_DEFERRED)
+				break;
+			error = wait_event_interruptible(fl->fl_wait,
+							 !fl->fl_next);
+			if (!error)
+				continue;
+
+			locks_delete_block(fl);
+			break;
+		}
+	}
+
+	return error;
+}
+
 /* Apply the lock described by l to an open file descriptor.
  * This implements both the F_SETLK and F_SETLKW commands of fcntl().
  */
@@ -1795,26 +1824,7 @@ again:
 		goto out;
 	}
 
-	error = security_file_lock(filp, file_lock->fl_type);
-	if (error)
-		goto out;
-
-	if (filp->f_op && filp->f_op->lock != NULL)
-		error = filp->f_op->lock(filp, cmd, file_lock);
-	else {
-		for (;;) {
-			error = posix_lock_file(filp, file_lock, NULL);
-			if (error != FILE_LOCK_DEFERRED)
-				break;
-			error = wait_event_interruptible(file_lock->fl_wait,
-					!file_lock->fl_next);
-			if (!error)
-				continue;
-
-			locks_delete_block(file_lock);
-			break;
-		}
-	}
+	error = do_lock_file_wait(filp, cmd, file_lock);
 
 	/*
 	 * Attempt to detect a close/fcntl race and recover by
@@ -1932,26 +1942,7 @@ again:
 		goto out;
 	}
 
-	error = security_file_lock(filp, file_lock->fl_type);
-	if (error)
-		goto out;
-
-	if (filp->f_op && filp->f_op->lock != NULL)
-		error = filp->f_op->lock(filp, cmd, file_lock);
-	else {
-		for (;;) {
-			error = posix_lock_file(filp, file_lock, NULL);
-			if (error != FILE_LOCK_DEFERRED)
-				break;
-			error = wait_event_interruptible(file_lock->fl_wait,
-					!file_lock->fl_next);
-			if (!error)
-				continue;
