From: akpm@linux-foundation.org
Subject: - fuse-fix-sparse-warnings.patch removed from -mm tree
Date: Thu, 01 May 2008 02:32:16 -0700
Message-ID: <200805010932.m419WGHt030971@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60463 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758000AbYEAJcU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:32:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     fuse: fix sparse warnings
has been removed from the -mm tree.  Its filename was
     fuse-fix-sparse-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fuse: fix sparse warnings
From: Miklos Szeredi <mszeredi@suse.cz>

fs/fuse/dev.c:306:2: warning: context imbalance in 'wait_answer_interruptible' - unexpected unlock
fs/fuse/dev.c:361:2: warning: context imbalance in 'request_wait_answer' - unexpected unlock
fs/fuse/dev.c:1002:4: warning: context imbalance in 'end_io_requests' - unexpected unlock

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/dev.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/fuse/dev.c~fuse-fix-sparse-warnings fs/fuse/dev.c
--- a/fs/fuse/dev.c~fuse-fix-sparse-warnings
+++ a/fs/fuse/dev.c
@@ -299,6 +299,7 @@ static void request_end(struct fuse_conn
 
 static void wait_answer_interruptible(struct fuse_conn *fc,
 				      struct fuse_req *req)
+	__releases(fc->lock) __acquires(fc->lock)
 {
 	if (signal_pending(current))
 		return;
@@ -315,8 +316,8 @@ static void queue_interrupt(struct fuse_
 	kill_fasync(&fc->fasync, SIGIO, POLL_IN);
 }
 
-/* Called with fc->lock held.  Releases, and then reacquires it. */
 static void request_wait_answer(struct fuse_conn *fc, struct fuse_req *req)
+	__releases(fc->lock) __acquires(fc->lock)
 {
 	if (!fc->no_interrupt) {
 		/* Any signal may interrupt this */
@@ -987,6 +988,7 @@ static void end_requests(struct fuse_con
  * locked).
  */
 static void end_io_requests(struct fuse_conn *fc)
+	__releases(fc->lock) __acquires(fc->lock)
 {
 	while (!list_empty(&fc->io)) {
 		struct fuse_req *req =
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
vfs-fix-permission-checking-in-sys_utimensat.patch

