From: akpm@linux-foundation.org
Subject: + fuse-lockd-support.patch added to -mm tree
Date: Thu, 15 May 2008 17:16:20 -0700
Message-ID: <200805160016.m4G0GKN6017783@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52440 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753337AbYEPARA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 May 2008 20:17:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, bfields@fieldses.org, hch@lst.de, matthew@wil.cx, teigland@redhat.com, trond.myklebust@fys.uio.no


The patch titled
     fuse: lockd support
has been added to the -mm tree.  Its filename is
     fuse-lockd-support.patch

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

