From: akpm@linux-foundation.org
Subject: [merged] drivers-scsi-a3000c-make-2-functions-static.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:39:15 -0700
Message-ID: <200904061939.n36JdFvC013789@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33915 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751902AbZDFUGA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 16:06:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, James.Bottomley@HansenPartnership.com, mm-commits@vger.kernel.org


The patch titled
     drivers/scsi/a3000.c: make 2 functions static
has been removed from the -mm tree.  Its filename was
     drivers-scsi-a3000c-make-2-functions-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/scsi/a3000.c: make 2 functions static
From: Adrian Bunk <bunk@kernel.org>

a3000_{detect,release}() can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/a3000.c |    6 ++++--
 drivers/scsi/a3000.h |    3 ---
 2 files changed, 4 insertions(+), 5 deletions(-)

diff -puN drivers/scsi/a3000.c~drivers-scsi-a3000c-make-2-functions-static drivers/scsi/a3000.c
--- a/drivers/scsi/a3000.c~drivers-scsi-a3000c-make-2-functions-static
+++ a/drivers/scsi/a3000.c
@@ -25,6 +25,8 @@
 
 static struct Scsi_Host *a3000_host = NULL;
 
+static int a3000_release(struct Scsi_Host *instance);
+
 static irqreturn_t a3000_intr (int irq, void *dummy)
 {
 	unsigned long flags;
@@ -157,7 +159,7 @@ static void dma_stop(struct Scsi_Host *i
     }
 }
 
-int __init a3000_detect(struct scsi_host_template *tpnt)
+static int __init a3000_detect(struct scsi_host_template *tpnt)
 {
     wd33c93_regs regs;
 
@@ -232,7 +234,7 @@ static struct scsi_host_template driver_
 
 #include "scsi_module.c"
 
-int a3000_release(struct Scsi_Host *instance)
+static int a3000_release(struct Scsi_Host *instance)
 {
     wd33c93_release();
     DMA(instance)->CNTR = 0;
diff -puN drivers/scsi/a3000.h~drivers-scsi-a3000c-make-2-functions-static drivers/scsi/a3000.h
--- a/drivers/scsi/a3000.h~drivers-scsi-a3000c-make-2-functions-static
+++ a/drivers/scsi/a3000.h
@@ -11,9 +11,6 @@
 
 #include <linux/types.h>
 
-int a3000_detect(struct scsi_host_template *);
-int a3000_release(struct Scsi_Host *);
