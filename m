From: akpm@linux-foundation.org
Subject: + s3cmci-fix-direct-write-to-interrupt-mask.patch added to -mm tree
Date: Tue, 29 Sep 2009 15:57:11 -0700
Message-ID: <200909292257.n8TMvBZi025725__44810.7875920416$1254265047$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44466 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752686AbZI2W5L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Sep 2009 18:57:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben@simtec.co.uk, linux-mmc@vger.kernel.org


The patch titled
     s3cmci: fix direct write to interrupt mask
has been added to the -mm tree.  Its filename is
     s3cmci-fix-direct-write-to-interrupt-mask.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
s3cmci-use-resource_size-instead-of-local-macro.patch
s3cmci-update-probe-to-use-new-platform-id-list.patch
s3cmci-change-gpio-to-gpiolib-from-s3c24xx-specific-calls.patch
s3cmci-change-to-use-dev_pm_ops.patch
s3cmci-fix-direct-write-to-interrupt-mask.patch
s3cmci-add-debugfs-support-for-examining-driver-and-hardware-state.patch
s3cmci-add-sdio-irq-support.patch
s3cmci-kconfig-selection-for-pio-dma-both.patch
s3cmci-dma-fixes.patch
s3cmci-make-sdio-irq-hardware-irq-support-build-time-configurable.patch
s3cmci-add-better-support-for-no-card-detect-or-write-protect-available.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch

