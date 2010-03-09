From: akpm@linux-foundation.org
Subject: [merged] sdio-kick-the-interrupt-thread-upon-a-resume.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:08:18 -0800
Message-ID: <201003091908.o29J8IRP031435@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58059 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755999Ab0CITWO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:22:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nico@fluxnic.net, linux-mmc@vger.kernel.org, nico@marvell.com, mm-commits@vger.kernel.org


The patch titled
     sdio: kick the interrupt thread upon a resume
has been removed from the -mm tree.  Its filename was
     sdio-kick-the-interrupt-thread-upon-a-resume.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sdio: kick the interrupt thread upon a resume
From: Nicolas Pitre <nico@fluxnic.net>

Some SDIO cards may suspend while keeping function interrupts active
especially in the powered suspend case.  Upon resume we need to kick the
SDIO interrupt thread to check for pending interrupts and to restart card
IRQ detection at the host controller level.

Signed-off-by: Nicolas Pitre <nico@marvell.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/sdio.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/mmc/core/sdio.c~sdio-kick-the-interrupt-thread-upon-a-resume drivers/mmc/core/sdio.c
--- a/drivers/mmc/core/sdio.c~sdio-kick-the-interrupt-thread-upon-a-resume
+++ a/drivers/mmc/core/sdio.c
@@ -441,6 +441,8 @@ static int mmc_sdio_resume(struct mmc_ho
 	mmc_claim_host(host);
 	err = mmc_sdio_init_card(host, host->ocr, host->card,
 				 (host->pm_flags & MMC_PM_KEEP_POWER));
+	if (!err && host->sdio_irqs)
+		mmc_signal_sdio_irq(host);
 	mmc_release_host(host);
 
 	/*
_

Patches currently in -mm which might be from nico@fluxnic.net are

linux-next.patch

