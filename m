From: akpm@linux-foundation.org
Subject: - xfs-replace-the-xfs-buf-iodone-semaphore-with-a-completion.patch removed from -mm tree
Date: Thu, 14 Aug 2008 16:54:09 -0700
Message-ID: <200808142354.m7ENs9jq003891@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47528 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751433AbYHNXyN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Aug 2008 19:54:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@fromorbit.com, lachlan@sgi.com, tes@sgi.com, mm-commits@vger.kernel.org


The patch titled
     xfs: replace the XFS buf iodone semaphore with a completion
has been removed from the -mm tree.  Its filename was
     xfs-replace-the-xfs-buf-iodone-semaphore-with-a-completion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xfs: replace the XFS buf iodone semaphore with a completion
From: Dave Chinner <david@fromorbit.com>

The xfs_buf_t b_iodonesema is really just a semaphore that wants to be a
completion.  Change it to a completion and remove the last user of the sema_t
from XFS.

Signed-off-by: Dave Chinner <david@fromorbit.com>
Cc: Timothy Shimmin <tes@sgi.com>
Cc: Lachlan McIlroy <lachlan@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/linux-2.6/xfs_buf.c |    6 +++---
 fs/xfs/linux-2.6/xfs_buf.h |    4 ++--
 fs/xfs/xfs_buf_item.c      |    2 +-
 fs/xfs/xfs_rw.c            |    2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff -puN fs/xfs/linux-2.6/xfs_buf.c~xfs-replace-the-xfs-buf-iodone-semaphore-with-a-completion fs/xfs/linux-2.6/xfs_buf.c
--- a/fs/xfs/linux-2.6/xfs_buf.c~xfs-replace-the-xfs-buf-iodone-semaphore-with-a-completion
+++ a/fs/xfs/linux-2.6/xfs_buf.c
@@ -253,7 +253,7 @@ _xfs_buf_initialize(
 
 	memset(bp, 0, sizeof(xfs_buf_t));
 	atomic_set(&bp->b_hold, 1);
-	init_MUTEX_LOCKED(&bp->b_iodonesema);
+	init_completion(&bp->b_iowait);
 	INIT_LIST_HEAD(&bp->b_list);
 	INIT_LIST_HEAD(&bp->b_hash_list);
 	init_MUTEX_LOCKED(&bp->b_sema); /* held, no waiters */
@@ -1037,7 +1037,7 @@ xfs_buf_ioend(
 			xfs_buf_iodone_work(&bp->b_iodone_work);
 		}
 	} else {
-		up(&bp->b_iodonesema);
+		complete(&bp->b_iowait);
 	}
 }
 
@@ -1275,7 +1275,7 @@ xfs_buf_iowait(
 	XB_TRACE(bp, "iowait", 0);
 	if (atomic_read(&bp->b_io_remaining))
 		blk_run_address_space(bp->b_target->bt_mapping);
-	down(&bp->b_iodonesema);
+	wait_for_completion(&bp->b_iowait);
 	XB_TRACE(bp, "iowaited", (long)bp->b_error);
 	return bp->b_error;
 }
diff -puN fs/xfs/linux-2.6/xfs_buf.h~xfs-replace-the-xfs-buf-iodone-semaphore-with-a-completion fs/xfs/linux-2.6/xfs_buf.h
--- a/fs/xfs/linux-2.6/xfs_buf.h~xfs-replace-the-xfs-buf-iodone-semaphore-with-a-completion
+++ a/fs/xfs/linux-2.6/xfs_buf.h
@@ -157,7 +157,7 @@ typedef struct xfs_buf {
 	xfs_buf_iodone_t	b_iodone;	/* I/O completion function */
 	xfs_buf_relse_t		b_relse;	/* releasing function */
 	xfs_buf_bdstrat_t	b_strat;	/* pre-write function */
-	struct semaphore	b_iodonesema;	/* Semaphore for I/O waiters */
+	struct completion	b_iowait;	/* queue for I/O waiters */
 	void			*b_fspriv;
 	void			*b_fspriv2;
 	void			*b_fspriv3;
@@ -352,7 +352,7 @@ extern void xfs_buf_trace(xfs_buf_t *, c
 #define XFS_BUF_CPSEMA(bp)	(xfs_buf_cond_lock(bp) == 0)
 #define XFS_BUF_VSEMA(bp)	xfs_buf_unlock(bp)
 #define XFS_BUF_PSEMA(bp,x)	xfs_buf_lock(bp)
-#define XFS_BUF_V_IODONESEMA(bp) up(&bp->b_iodonesema);
+#define XFS_BUF_FINISH_IOWAIT(bp)	complete(&bp->b_iowait);
 
 #define XFS_BUF_SET_TARGET(bp, target)	((bp)->b_target = (target))
 #define XFS_BUF_TARGET(bp)		((bp)->b_target)
diff -puN fs/xfs/xfs_buf_item.c~xfs-replace-the-xfs-buf-iodone-semaphore-with-a-completion fs/xfs/xfs_buf_item.c
--- a/fs/xfs/xfs_buf_item.c~xfs-replace-the-xfs-buf-iodone-semaphore-with-a-completion
+++ a/fs/xfs/xfs_buf_item.c
@@ -1056,7 +1056,7 @@ xfs_buf_iodone_callbacks(
 			   anyway. */
 			XFS_BUF_SET_BRELSE_FUNC(bp,xfs_buf_error_relse);
 			XFS_BUF_DONE(bp);
-			XFS_BUF_V_IODONESEMA(bp);
+			XFS_BUF_FINISH_IOWAIT(bp);
 		}
 		return;
 	}
diff -puN fs/xfs/xfs_rw.c~xfs-replace-the-xfs-buf-iodone-semaphore-with-a-completion fs/xfs/xfs_rw.c
--- a/fs/xfs/xfs_rw.c~xfs-replace-the-xfs-buf-iodone-semaphore-with-a-completion
+++ a/fs/xfs/xfs_rw.c
@@ -314,7 +314,7 @@ xfs_bioerror_relse(
 		 * ASYNC buffers.
 		 */
 		XFS_BUF_ERROR(bp, EIO);
-		XFS_BUF_V_IODONESEMA(bp);
+		XFS_BUF_FINISH_IOWAIT(bp);
 	} else {
 		xfs_buf_relse(bp);
 	}
_

Patches currently in -mm which might be from david@fromorbit.com are

origin.patch
completions-un-inline-try_wait_for_completion-and-completion_done.patch
linux-next.patch

