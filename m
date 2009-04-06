From: akpm@linux-foundation.org
Subject: [merged] drivers-scsi-a2091c-make-2-functions-static.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:39:13 -0700
Message-ID: <200904061939.n36JdDfM013711@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50548 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752249AbZDFUHa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 16:07:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, James.Bottomley@HansenPartnership.com, mm-commits@vger.kernel.org


The patch titled
     drivers/scsi/a2091.c: make 2 functions static
has been removed from the -mm tree.  Its filename was
     drivers-scsi-a2091c-make-2-functions-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/scsi/a2091.c: make 2 functions static
From: Adrian Bunk <bunk@kernel.org>

a2091_{detect,release}() can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/a2091.c |    6 ++++--
 drivers/scsi/a2091.h |    3 ---
 2 files changed, 4 insertions(+), 5 deletions(-)

diff -puN drivers/scsi/a2091.c~drivers-scsi-a2091c-make-2-functions-static drivers/scsi/a2091.c
--- a/drivers/scsi/a2091.c~drivers-scsi-a2091c-make-2-functions-static
+++ a/drivers/scsi/a2091.c
@@ -23,6 +23,8 @@
 #define DMA(ptr) ((a2091_scsiregs *)((ptr)->base))
 #define HDATA(ptr) ((struct WD33C93_hostdata *)((ptr)->hostdata))
 
+static int a2091_release(struct Scsi_Host *instance);
+
 static irqreturn_t a2091_intr (int irq, void *_instance)
 {
     unsigned long flags;
@@ -144,7 +146,7 @@ static void dma_stop(struct Scsi_Host *i
     }
 }
 
-int __init a2091_detect(struct scsi_host_template *tpnt)
+static int __init a2091_detect(struct scsi_host_template *tpnt)
 {
     static unsigned char called = 0;
     struct Scsi_Host *instance;
@@ -233,7 +235,7 @@ static struct scsi_host_template driver_
 
 #include "scsi_module.c"
 
-int a2091_release(struct Scsi_Host *instance)
+static int a2091_release(struct Scsi_Host *instance)
 {
 #ifdef MODULE
 	DMA(instance)->CNTR = 0;
diff -puN drivers/scsi/a2091.h~drivers-scsi-a2091c-make-2-functions-static drivers/scsi/a2091.h
--- a/drivers/scsi/a2091.h~drivers-scsi-a2091c-make-2-functions-static
+++ a/drivers/scsi/a2091.h
@@ -11,9 +11,6 @@
 
 #include <linux/types.h>
 
-int a2091_detect(struct scsi_host_template *);
-int a2091_release(struct Scsi_Host *);
