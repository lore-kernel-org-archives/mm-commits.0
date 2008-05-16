From: akpm@linux-foundation.org
Subject: + locks-allow-lock-to-return-file_lock_deferred.patch added to -mm tree
Date: Thu, 15 May 2008 17:16:09 -0700
Message-ID: <200805160016.m4G0GAet017764@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53365 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753112AbYEPAQz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 May 2008 20:16:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, bfields@fieldses.org, hch@lst.de, matthew@wil.cx, teigland@redhat.com, trond.myklebust@fys.uio.no


The patch titled
     locks: allow ->lock() to return FILE_LOCK_DEFERRED
has been added to the -mm tree.  Its filename is
     locks-allow-lock-to-return-file_lock_deferred.patch

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
Subject: locks: allow ->lock() to return FILE_LOCK_DEFERRED
From: Miklos Szeredi <mszeredi@suse.cz>

Allow filesystem's ->lock() method to call posix_lock_file() instead of
posix_lock_file_wait(), and return FILE_LOCK_DEFERRED.  This makes it
possible to implement a such a ->lock() function, that works with the lock
manager, which needs the call to be asynchronous.

Now the vfs_lock_file() helper can be used, so this is a cleanup as well.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: David Teigland <teigland@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/locks.c |   23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff -puN fs/locks.c~locks-allow-lock-to-return-file_lock_deferred fs/locks.c
--- a/fs/locks.c~locks-allow-lock-to-return-file_lock_deferred
+++ a/fs/locks.c
@@ -1753,21 +1753,16 @@ static int do_lock_file_wait(struct file
 	if (error)
 		return error;
 
-	if (filp->f_op && filp->f_op->lock != NULL)
-		error = filp->f_op->lock(filp, cmd, fl);
-	else {
-		for (;;) {
-			error = posix_lock_file(filp, fl, NULL);
-			if (error != FILE_LOCK_DEFERRED)
-				break;
-			error = wait_event_interruptible(fl->fl_wait,
-							 !fl->fl_next);
-			if (!error)
-				continue;
-
-			locks_delete_block(fl);
+	for (;;) {
+		error = vfs_lock_file(filp, cmd, fl, NULL);
+		if (error != FILE_LOCK_DEFERRED)
 			break;
-		}
+		error = wait_event_interruptible(fl->fl_wait, !fl->fl_next);
+		if (!error)
+			continue;
+
+		locks_delete_block(fl);
+		break;
 	}
 
 	return error;
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

