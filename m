From: akpm@linux-foundation.org
Subject: - mbcs-convert-dmareadlock-to-mutex.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:06:59 -0800
Message-ID: <200802080806.m1886eZI014472@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50554 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758298AbYBHITT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:19:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthias.kaehlcke@gmail.com, mm-commits@vger.kernel.org


The patch titled
     MBCS: convert dmareadlock to mutex
has been removed from the -mm tree.  Its filename was
     mbcs-convert-dmareadlock-to-mutex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MBCS: convert dmareadlock to mutex
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

MBCS: Convert the semaphore dmareadlock to the mutex API

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mbcs.c |    6 +++---
 drivers/char/mbcs.h |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/char/mbcs.c~mbcs-convert-dmareadlock-to-mutex drivers/char/mbcs.c
--- a/drivers/char/mbcs.c~mbcs-convert-dmareadlock-to-mutex
+++ a/drivers/char/mbcs.c
@@ -347,7 +347,7 @@ do_mbcs_sram_dmaread(struct mbcs_soft *s
 {
 	int rv = 0;
 
-	if (down_interruptible(&soft->dmareadlock))
+	if (mutex_lock_interruptible(&soft->dmareadlock))
 		return -ERESTARTSYS;
 
 	atomic_set(&soft->dmawrite_done, 0);
@@ -372,7 +372,7 @@ do_mbcs_sram_dmaread(struct mbcs_soft *s
 	*off += len;
 
 dmaread_exit:
-	up(&soft->dmareadlock);
+	mutex_unlock(&soft->dmareadlock);
 
 	return rv;
 }
@@ -764,7 +764,7 @@ static int mbcs_probe(struct cx_dev *dev
 	init_waitqueue_head(&soft->algo_queue);
 
 	mutex_init(&soft->dmawritelock);
-	init_MUTEX(&soft->dmareadlock);
+	mutex_init(&soft->dmareadlock);
 	mutex_init(&soft->algolock);
 
 	mbcs_getdma_init(&soft->getdma);
diff -puN drivers/char/mbcs.h~mbcs-convert-dmareadlock-to-mutex drivers/char/mbcs.h
--- a/drivers/char/mbcs.h~mbcs-convert-dmareadlock-to-mutex
+++ a/drivers/char/mbcs.h
@@ -538,7 +538,7 @@ struct mbcs_soft {
 	atomic_t dmaread_done;
 	atomic_t algo_done;
 	struct mutex dmawritelock;
-	struct semaphore dmareadlock;
+	struct mutex dmareadlock;
 	struct mutex algolock;
 };
 
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

origin.patch
