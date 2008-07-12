From: akpm@linux-foundation.org
Subject: + xfs-fix-reference-counting-race-on-log-buffers.patch added to -mm tree
Date: Fri, 11 Jul 2008 19:19:08 -0700
Message-ID: <200807120219.m6C2J8jh016048@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43659 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751602AbYGLCTU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 22:19:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david@fromorbit.com, sandeen@sandeen.net, tes@sgi.com


The patch titled
     xfs: fix reference counting race on log buffers
has been added to the -mm tree.  Its filename is
     xfs-fix-reference-counting-race-on-log-buffers.patch

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
Subject: xfs: fix reference counting race on log buffers
From: Dave Chinner <david@fromorbit.com>

When we release the iclog, we do an atomic_dec_and_lock to determine if we
are the last reference and need to trigger update of log headers and
writeout.  However, in xlog_state_get_iclog_space() we also need to check
if we have the last reference count there.  If we do, we release the log
buffer, otherwise we decrement the reference count.

The issue is that the compare and decrement in
xlog_state_get_iclog_space() is not atomic, so both places can see a
reference count of 2 and neither will release the iclog.  That leads to a
filesystem hang.

Close the race by replacing the atomic_read() and atomic_dec() pair with
atomic_add_unless() to ensure that they are executed atomically.

Signed-off-by: Dave Chinner <david@fromorbit.com>
Reviewed-by: Tim Shimmin <tes@sgi.com>
Tested-by: Eric Sandeen <sandeen@sandeen.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/xfs_log.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff -puN fs/xfs/xfs_log.c~xfs-fix-reference-counting-race-on-log-buffers fs/xfs/xfs_log.c
--- a/fs/xfs/xfs_log.c~xfs-fix-reference-counting-race-on-log-buffers
+++ a/fs/xfs/xfs_log.c
@@ -2427,13 +2427,20 @@ restart:
 	if (iclog->ic_size - iclog->ic_offset < 2*sizeof(xlog_op_header_t)) {
 		xlog_state_switch_iclogs(log, iclog, iclog->ic_size);
 
-		/* If I'm the only one writing to this iclog, sync it to disk */
-		if (atomic_read(&iclog->ic_refcnt) == 1) {
+		/*
+		 * If I'm the only one writing to this iclog, sync it to disk.
+		 * We need to do an atomic compare and decrement here to avoid
+		 * racing with concurrent atomic_dec_and_lock() calls in
+		 * xlog_state_release_iclog() when there is more than one
+		 * reference to the iclog.
+		 */
+		if (!atomic_add_unless(&iclog->ic_refcnt, -1, 1)) {
+			/* we are the only one */
 			spin_unlock(&log->l_icloglock);
-			if ((error = xlog_state_release_iclog(log, iclog)))
+			error = xlog_state_release_iclog(log, iclog);
+			if (error)
 				return error;
 		} else {
-			atomic_dec(&iclog->ic_refcnt);
 			spin_unlock(&log->l_icloglock);
 		}
 		goto restart;
_

Patches currently in -mm which might be from david@fromorbit.com are

xfs-fix-reference-counting-race-on-log-buffers.patch
xfs-clean-up-stale-references-to-semaphores.patch
xfs-replace-the-xfs-buf-iodone-semaphore-with-a-completion.patch
xfs-extend-completions-to-provide-xfs-object-flush-requirements.patch
xfs-replace-inode-flush-semaphore-with-a-completion.patch
xfs-replace-dquot-flush-semaphore-with-a-completion.patch
xfs-remove-the-sema_t-from-xfs.patch
xfs-fix-disabled-xfs-posix-acl-handling.patch

