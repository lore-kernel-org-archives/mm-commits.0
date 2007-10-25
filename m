From: akpm@linux-foundation.org
Subject: + mbcs-convert-algolock-to-mutex.patch added to -mm tree
Date: Wed, 24 Oct 2007 21:11:57 -0700
Message-ID: <200710250411.l9P4BvlW031146@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39582 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761801AbXJYEMB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Oct 2007 00:12:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias.kaehlcke@gmail.com


The patch titled
     MBCS: convert algolock to mutex
has been added to the -mm tree.  Its filename is
     mbcs-convert-algolock-to-mutex.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: MBCS: convert algolock to mutex
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

MBCS: Convert the semaphore algolock to the mutex API

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mbcs.c |    7 ++++---
 drivers/char/mbcs.h |    2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/char/mbcs.c~mbcs-convert-algolock-to-mutex drivers/char/mbcs.c
--- a/drivers/char/mbcs.c~mbcs-convert-algolock-to-mutex
+++ a/drivers/char/mbcs.c
@@ -23,6 +23,7 @@
 #include <linux/device.h>
 #include <linux/mm.h>
 #include <linux/uio.h>
+#include <linux/mutex.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
 #include <asm/system.h>
@@ -281,7 +282,7 @@ static inline int mbcs_algo_start(struct
 	void *mmr_base = soft->mmr_base;
 	union cm_control cm_control;
 
-	if (down_interruptible(&soft->algolock))
+	if (mutex_lock_interruptible(&soft->algolock))
 		return -ERESTARTSYS;
 
 	atomic_set(&soft->algo_done, 0);
@@ -298,7 +299,7 @@ static inline int mbcs_algo_start(struct
 	cm_control.alg_go = 1;
 	MBCS_MMR_SET(mmr_base, MBCS_CM_CONTROL, cm_control.cm_control_reg);
 
-	up(&soft->algolock);
+	mutex_unlock(&soft->algolock);
 
 	return 0;
 }
@@ -764,7 +765,7 @@ static int mbcs_probe(struct cx_dev *dev
 
 	init_MUTEX(&soft->dmawritelock);
 	init_MUTEX(&soft->dmareadlock);
-	init_MUTEX(&soft->algolock);
+	mutex_init(&soft->algolock);
 
 	mbcs_getdma_init(&soft->getdma);
 	mbcs_putdma_init(&soft->putdma);
diff -puN drivers/char/mbcs.h~mbcs-convert-algolock-to-mutex drivers/char/mbcs.h
--- a/drivers/char/mbcs.h~mbcs-convert-algolock-to-mutex
+++ a/drivers/char/mbcs.h
@@ -539,7 +539,7 @@ struct mbcs_soft {
 	atomic_t algo_done;
 	struct semaphore dmawritelock;
 	struct semaphore dmareadlock;
-	struct semaphore algolock;
+	struct mutex algolock;
 };
 
 static int mbcs_open(struct inode *ip, struct file *fp);
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

generic-ac97-mixer-modem-oss-use-list_for_each_entry.patch
mbcs-convert-algolock-to-mutex.patch
mbcs-convert-dmawritelock-to-mutex.patch
mbcs-convert-dmareadlock-to-mutex.patch
