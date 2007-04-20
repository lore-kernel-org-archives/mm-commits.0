From: akpm@linux-foundation.org
Subject: + xfs-fix-unmount-race.patch added to -mm tree
Date: Fri, 20 Apr 2007 15:53:12 -0700
Message-ID: <200704202253.l3KMrCwf025745@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53876 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767304AbXDTWxQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 18:53:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dgc@sgi.com, michal.k.k.piotrowski@gmail.com


The patch titled
     xfs: fix unmount race
has been added to the -mm tree.  Its filename is
     xfs-fix-unmount-race.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: xfs: fix unmount race
From: David Chinner <dgc@sgi.com>

It looks like the workqueue is being run while the log is being torn down.

On unmount, we write a log record to indicate a clean unmount just before
we tear the log down.  We sleep on the iclog force semaphore waiting for
the log I/O to complete, which is processed by xfslogd and xlog_iodone().

xlog_iodone() calls xlog_state_done_syncing() which processes the I/O
completion and wakes the unmount process sleeping on the semaphore. 
xlog_state_done_syncing() then does a bit more work before returning to
xlog_iodone() where we check the buffer to determine if it was an async I/o
or not.

However, before we get to this, the unmount process has woken and continued
onwards which then frees the iclogs and the buffer.  Hence we have a race
between xlog_iodone() looking at the buffer and the unmount process tearing
the buffer down.

There's a couple of different ways I can see to fix the problem - the first
is to not reference the buffer in xlog_iodone() after running the callbacks
that may trigger it being freed.  I'd prfer to see if this fixes the
problem before having to do more invasive surgery.

Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/xfs_log.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff -puN fs/xfs/xfs_log.c~xfs-fix-unmount-race fs/xfs/xfs_log.c
--- a/fs/xfs/xfs_log.c~xfs-fix-unmount-race
+++ a/fs/xfs/xfs_log.c
@@ -967,14 +967,11 @@ xlog_iodone(xfs_buf_t *bp)
 	} else if (iclog->ic_state & XLOG_STATE_IOERROR) {
 		aborted = XFS_LI_ABORTED;
 	}
+	/* log I/O is always issued ASYNC, so we should see that here */
+	WARN_ON(!(XFS_BUF_ISASYNC(bp)));
 	xlog_state_done_syncing(iclog, aborted);
-	if (!(XFS_BUF_ISASYNC(bp))) {
-		/*
-		 * Corresponding psema() will be done in bwrite().  If we don't
-		 * vsema() here, panic.
-		 */
-		XFS_BUF_V_IODONESEMA(bp);
-	}
+	/* do not reference bp here - it may have been freed during unmount */
+
 }	/* xlog_iodone */
 
 /*
_

Patches currently in -mm which might be from dgc@sgi.com are

xfs-clean-up-shrinker-games.patch
xfs-fix-unmount-race.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
