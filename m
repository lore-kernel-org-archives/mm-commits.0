From: akpm@linux-foundation.org
Subject: - locks-allow-lock-to-return-file_lock_deferred.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:03:34 -0700
Message-ID: <200807252303.m6PN3YS6003962@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43799 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754186AbYGYXFX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:05:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, bfields@fieldses.org, hch@lst.de, matthew@wil.cx, teigland@redhat.com, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     locks: allow ->lock() to return FILE_LOCK_DEFERRED
has been removed from the -mm tree.  Its filename was
     locks-allow-lock-to-return-file_lock_deferred.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1747,21 +1747,16 @@ static int do_lock_file_wait(struct file
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
