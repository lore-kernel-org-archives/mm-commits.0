From: akpm@linux-foundation.org
Subject: + locks-cleanup-code-duplication.patch added to -mm tree
Date: Thu, 15 May 2008 17:16:07 -0700
Message-ID: <200805160016.m4G0G7mV017761@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53465 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753069AbYEPAQu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 May 2008 20:16:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, bfields@fieldses.org, hch@lst.de, matthew@wil.cx, teigland@redhat.com, trond.myklebust@fys.uio.no


The patch titled
     locks: cleanup code duplication
has been added to the -mm tree.  Its filename is
     locks-cleanup-code-duplication.patch

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
@@ -1744,6 +1744,35 @@ int vfs_lock_file(struct file *filp, uns
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
@@ -1801,26 +1830,7 @@ again:
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
@@ -1938,26 +1948,7 @@ again:
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
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
mm-fix-infinite-loop-in-filemap_fault.patch
git-vfs-cleanups.patch
lockd-dont-return-eagain-for-a-permanent-error.patch
locks-add-special-return-value-for-asynchronous-locks.patch
locks-cleanup-code-duplication.patch
locks-allow-lock-to-return-file_lock_deferred.patch
fuse-prepare-lookup-for-nfs-export.patch
fuse-add-export-operations.patch
fuse-add-fuse_lookup_name-helper.patch
fuse-nfs-export-special-lookups.patch
fuse-lockd-support.patch

