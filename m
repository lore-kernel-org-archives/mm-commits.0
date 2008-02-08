From: akpm@linux-foundation.org
Subject: - mbcs-convert-dmawritelock-to-mutex.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:06:57 -0800
Message-ID: <200802080806.m1886cRr014469@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56807 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759475AbYBHITU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:19:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthias.kaehlcke@gmail.com, mm-commits@vger.kernel.org


The patch titled
     MBCS: convert dmawritelock to mutex
has been removed from the -mm tree.  Its filename was
     mbcs-convert-dmawritelock-to-mutex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MBCS: convert dmawritelock to mutex
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

MBCS: Convert the semaphore dmawritelock to the mutex API

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mbcs.c |    6 +++---
 drivers/char/mbcs.h |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/char/mbcs.c~mbcs-convert-dmawritelock-to-mutex drivers/char/mbcs.c
--- a/drivers/char/mbcs.c~mbcs-convert-dmawritelock-to-mutex
+++ a/drivers/char/mbcs.c
@@ -310,7 +310,7 @@ do_mbcs_sram_dmawrite(struct mbcs_soft *
 {
 	int rv = 0;
 
-	if (down_interruptible(&soft->dmawritelock))
+	if (mutex_lock_interruptible(&soft->dmawritelock))
 		return -ERESTARTSYS;
 
 	atomic_set(&soft->dmawrite_done, 0);
@@ -336,7 +336,7 @@ do_mbcs_sram_dmawrite(struct mbcs_soft *
 	*off += len;
 
 dmawrite_exit:
-	up(&soft->dmawritelock);
+	mutex_unlock(&soft->dmawritelock);
 
 	return rv;
 }
@@ -763,7 +763,7 @@ static int mbcs_probe(struct cx_dev *dev
 	init_waitqueue_head(&soft->dmaread_queue);
 	init_waitqueue_head(&soft->algo_queue);
 
-	init_MUTEX(&soft->dmawritelock);
+	mutex_init(&soft->dmawritelock);
 	init_MUTEX(&soft->dmareadlock);
 	mutex_init(&soft->algolock);
 
diff -puN drivers/char/mbcs.h~mbcs-convert-dmawritelock-to-mutex drivers/char/mbcs.h
--- a/drivers/char/mbcs.h~mbcs-convert-dmawritelock-to-mutex
+++ a/drivers/char/mbcs.h
@@ -537,7 +537,7 @@ struct mbcs_soft {
 	atomic_t dmawrite_done;
 	atomic_t dmaread_done;
 	atomic_t algo_done;
-	struct semaphore dmawritelock;
+	struct mutex dmawritelock;
 	struct semaphore dmareadlock;
 	struct mutex algolock;
 };
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

origin.patch
