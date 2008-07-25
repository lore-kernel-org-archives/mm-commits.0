From: akpm@linux-foundation.org
Subject: - fuse-lockd-support.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:03:45 -0700
Message-ID: <200807252303.m6PN3jmo003981@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33347 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755617AbYGYXHc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:07:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, bfields@fieldses.org, hch@lst.de, matthew@wil.cx, teigland@redhat.com, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     fuse: lockd support
has been removed from the -mm tree.  Its filename was
     fuse-lockd-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fuse: lockd support
From: Miklos Szeredi <mszeredi@suse.cz>

If fuse filesystem doesn't define it's own lock operations, then allow the
lock manager to work with fuse.

Adding lockd support for remote locking is also possible, but more rarely
used, so leave it till later.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: David Teigland <teigland@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/file.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN fs/fuse/file.c~fuse-lockd-support fs/fuse/file.c
--- a/fs/fuse/file.c~fuse-lockd-support
+++ a/fs/fuse/file.c
@@ -1341,6 +1341,11 @@ static int fuse_setlk(struct file *file,
 	pid_t pid = fl->fl_type != F_UNLCK ? current->tgid : 0;
 	int err;
 
+	if (fl->fl_lmops && fl->fl_lmops->fl_grant) {
+		/* NLM needs asynchronous locks, which we don't support yet */
+		return -ENOLCK;
+	}
+
 	/* Unlock on close is handled by the flush method */
 	if (fl->fl_flags & FL_CLOSE)
 		return 0;
@@ -1365,7 +1370,9 @@ static int fuse_file_lock(struct file *f
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	int err;
 
-	if (cmd == F_GETLK) {
+	if (cmd == F_CANCELLK) {
+		err = 0;
+	} else if (cmd == F_GETLK) {
 		if (fc->no_lock) {
 			posix_test_lock(file, fl);
 			err = 0;
@@ -1373,7 +1380,7 @@ static int fuse_file_lock(struct file *f
 			err = fuse_getlk(file, fl);
 	} else {
 		if (fc->no_lock)
-			err = posix_lock_file_wait(file, fl);
+			err = posix_lock_file(file, fl, NULL);
 		else
 			err = fuse_setlk(file, fl, 0);
 	}
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
linux-next.patch
git-unprivileged-mounts.patch

