From: akpm@linux-foundation.org
Subject: [merged] s3cmci-fix-direct-write-to-interrupt-mask.patch removed from -mm tree
Date: Mon, 05 Oct 2009 11:38:55 -0700
Message-ID: <200910051838.n95Ict76018016__47183.1334442415$1254768069$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52942 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754621AbZJESjf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Oct 2009 14:39:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben@simtec.co.uk, linux-mmc@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     s3cmci: fix direct write to interrupt mask
has been removed from the -mm tree.  Its filename was
     s3cmci-fix-direct-write-to-interrupt-mask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: s3cmci: fix direct write to interrupt mask
From: Ben Dooks <ben@simtec.co.uk>

The clear_imask() call should be used to clear the interrupt mask
register, as it may end up clearing the SDIO interrupt bit if this is
enabled.

Change all writes of zero to SDIIMSK register to use clear_imask() ready
for the SDIO updates.

Signed-off-by: Ben Dooks <ben@simtec.co.uk>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/s3cmci.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/mmc/host/s3cmci.c~s3cmci-fix-direct-write-to-interrupt-mask drivers/mmc/host/s3cmci.c
--- a/drivers/mmc/host/s3cmci.c~s3cmci-fix-direct-write-to-interrupt-mask
+++ a/drivers/mmc/host/s3cmci.c
@@ -681,9 +681,9 @@ out:
 fail_request:
 	host->mrq->data->error = -EINVAL;
 	host->complete_what = COMPLETION_FINALIZE;
-	writel(0, host->base + host->sdiimsk);
-	goto out;
+	clear_imask(host);
 
+	goto out;
 }
 
 static void finalize_request(struct s3cmci_host *host)
@@ -726,7 +726,7 @@ static void finalize_request(struct s3cm
 	writel(0, host->base + S3C2410_SDICMDARG);
 	writel(S3C2410_SDIDCON_STOP, host->base + S3C2410_SDIDCON);
 	writel(0, host->base + S3C2410_SDICMDCON);
-	writel(0, host->base + host->sdiimsk);
+	clear_imask(host);
 
 	if (cmd->data && cmd->error)
 		cmd->data->error = cmd->error;
_

Patches currently in -mm which might be from ben@simtec.co.uk are

gpiolib-add-names-file-in-gpio-chip-sysfs.patch

