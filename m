From: akpm@linux-foundation.org
Subject: - locks-fix-possible-infinite-loop-in-fcntlf_setlkw-over-nfs.patch removed from -mm tree
Date: Tue, 15 Apr 2008 13:43:28 -0700
Message-ID: <200804152043.m3FKhSOp014596@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43104 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757374AbYDOUoQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 16:44:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@citi.umich.edu, eshel@almaden.ibm.com, mszeredi@suse.cz, stable@kernel.org, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     locks: fix possible infinite loop in fcntl(F_SETLKW) over nfs
has been removed from the -mm tree.  Its filename was
     locks-fix-possible-infinite-loop-in-fcntlf_setlkw-over-nfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: locks: fix possible infinite loop in fcntl(F_SETLKW) over nfs
From: J. Bruce Fields <bfields@citi.umich.edu>

Miklos Szeredi found the bug:

	"Basically what happens is that on the server nlm_fopen() calls
	nfsd_open() which returns -EACCES, to which nlm_fopen() returns
	NLM_LCK_DENIED.

	"On the client this will turn into a -EAGAIN (nlm_stat_to_errno()),
	which in will cause fcntl_setlk() to retry forever."

So, for example, opening a file on an nfs filesystem, changing permissions to
forbid further access, then trying to lock the file, could result in an
infinite loop.

And Trond Myklebust identified the culprit, from Marc Eshel and I:

	7723ec9777d9832849b76475b1a21a2872a40d20 "locks: factor out
	generic/filesystem switch from setlock code"

That commit claimed to just be reshuffling code, but actually introduced a
behavioral change by calling the lock method repeatedly as long as it returned
-EAGAIN.

We assumed this would be safe, since we assumed a lock of type SETLKW would
only return with either success or an error other than -EAGAIN.  However, nfs
does can in fact return -EAGAIN in this situation, and independently of
whether that behavior is correct or not, we don't actually need this change,
and it seems far safer not to depend on such assumptions about the
filesystem's ->lock method.

Therefore, revert the problematic part of the original commit.  This leaves
vfs_lock_file() and its other callers unchanged, while returning fcntl_setlk
and fcntl_setlk64 to their former behavior.

This is appropriate for 2.6.25 (as well as older stable kernels--the bug was
introduced in 2.6.22).

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Tested-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Marc Eshel <eshel@almaden.ibm.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/locks.c |   48 ++++++++++++++++++++++++++++--------------------
 1 file changed, 28 insertions(+), 20 deletions(-)

diff -puN fs/locks.c~locks-fix-possible-infinite-loop-in-fcntlf_setlkw-over-nfs fs/locks.c
--- a/fs/locks.c~locks-fix-possible-infinite-loop-in-fcntlf_setlkw-over-nfs
+++ a/fs/locks.c
@@ -1801,17 +1801,21 @@ again:
 	if (error)
 		goto out;
 
-	for (;;) {
-		error = vfs_lock_file(filp, cmd, file_lock, NULL);
-		if (error != -EAGAIN || cmd == F_SETLK)
-			break;
-		error = wait_event_interruptible(file_lock->fl_wait,
-				!file_lock->fl_next);
-		if (!error)
-			continue;
+	if (filp->f_op && filp->f_op->lock != NULL)
+		error = filp->f_op->lock(filp, cmd, file_lock);
+	else {
+		for (;;) {
+			error = posix_lock_file(filp, file_lock, NULL);
+			if (error != -EAGAIN || cmd == F_SETLK)
+				break;
+			error = wait_event_interruptible(file_lock->fl_wait,
+					!file_lock->fl_next);
+			if (!error)
+				continue;
 
-		locks_delete_block(file_lock);
-		break;
+			locks_delete_block(file_lock);
+			break;
+		}
 	}
 
 	/*
@@ -1925,17 +1929,21 @@ again:
 	if (error)
 		goto out;
 
-	for (;;) {
-		error = vfs_lock_file(filp, cmd, file_lock, NULL);
-		if (error != -EAGAIN || cmd == F_SETLK64)
-			break;
-		error = wait_event_interruptible(file_lock->fl_wait,
-				!file_lock->fl_next);
-		if (!error)
-			continue;
+	if (filp->f_op && filp->f_op->lock != NULL)
+		error = filp->f_op->lock(filp, cmd, file_lock);
+	else {
+		for (;;) {
+			error = posix_lock_file(filp, file_lock, NULL);
+			if (error != -EAGAIN || cmd == F_SETLK64)
+				break;
+			error = wait_event_interruptible(file_lock->fl_wait,
+					!file_lock->fl_next);
+			if (!error)
+				continue;
 
-		locks_delete_block(file_lock);
-		break;
+			locks_delete_block(file_lock);
+			break;
+		}
 	}
 
 	/*
_

Patches currently in -mm which might be from bfields@citi.umich.edu are

origin.patch
git-nfsd.patch
reiser4.patch

