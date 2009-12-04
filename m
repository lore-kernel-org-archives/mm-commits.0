From: akpm@linux-foundation.org
Subject: [merged] writeback-introduce-wbcfor_background.patch removed from -mm tree
Date: Fri, 04 Dec 2009 12:33:37 -0800
Message-ID: <200912042033.nB4KXbqh011175@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38463 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757222AbZLDUdn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Dec 2009 15:33:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@gmail.com, Trond.Myklebust@netapp.com, fengguang.wu@intel.com, hch@infradead.org, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     writeback: introduce wbc.for_background
has been removed from the -mm tree.  Its filename was
     writeback-introduce-wbcfor_background.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: writeback: introduce wbc.for_background
From: Wu Fengguang <fengguang.wu@gmail.com>

It will lower the flush priority for NFS, and maybe more in future.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c         |    1 +
 fs/nfs/write.c            |    2 +-
 include/linux/writeback.h |    1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/fs-writeback.c~writeback-introduce-wbcfor_background fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-introduce-wbcfor_background
+++ a/fs/fs-writeback.c
@@ -731,6 +731,7 @@ static long wb_writeback(struct bdi_writ
 		.sync_mode		= args->sync_mode,
 		.older_than_this	= NULL,
 		.for_kupdate		= args->for_kupdate,
+		.for_background		= args->for_background,
 		.range_cyclic		= args->range_cyclic,
 	};
 	unsigned long oldest_jif;
diff -puN fs/nfs/write.c~writeback-introduce-wbcfor_background fs/nfs/write.c
--- a/fs/nfs/write.c~writeback-introduce-wbcfor_background
+++ a/fs/nfs/write.c
@@ -178,7 +178,7 @@ static int wb_priority(struct writeback_
 {
 	if (wbc->for_reclaim)
 		return FLUSH_HIGHPRI | FLUSH_STABLE;
-	if (wbc->for_kupdate)
+	if (wbc->for_kupdate || wbc->for_background)
 		return FLUSH_LOWPRI;
 	return 0;
 }
diff -puN include/linux/writeback.h~writeback-introduce-wbcfor_background include/linux/writeback.h
--- a/include/linux/writeback.h~writeback-introduce-wbcfor_background
+++ a/include/linux/writeback.h
@@ -49,6 +49,7 @@ struct writeback_control {
 	unsigned nonblocking:1;		/* Don't get stuck on request queues */
 	unsigned encountered_congestion:1; /* An output: a queue is full */
 	unsigned for_kupdate:1;		/* A kupdate writeback */
+	unsigned for_background:1;	/* A background writeback */
 	unsigned for_reclaim:1;		/* Invoked from the page allocator */
 	unsigned range_cyclic:1;	/* range_start is cyclic */
 	unsigned more_io:1;		/* more io to be dispatched */
_

Patches currently in -mm which might be from fengguang.wu@gmail.com are

linux-next.patch

