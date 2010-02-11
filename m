From: akpm@linux-foundation.org
Subject: + sdio-kick-the-interrupt-thread-upon-a-resume.patch added to -mm tree
Date: Thu, 11 Feb 2010 12:33:21 -0800
Message-ID: <201002112033.o1BKXLN6026968__24910.1750589491$1265920451$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46089 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756876Ab0BKUd6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Feb 2010 15:33:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nico@fluxnic.net, linux-mmc@vger.kernel.org, nico@marvell.com


The patch titled
     sdio: kick the interrupt thread upon a resume
has been added to the -mm tree.  Its filename is
     sdio-kick-the-interrupt-thread-upon-a-resume.patch

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

mmc-fix-hang-if-card-was-removed-during-suspend-and-unsafe-resume-was-enabled.patch
sdio-introduce-api-for-special-power-management-features.patch
sdio-sdhci-support-for-suspend-mode-pm-features.patch
sdio-kick-the-interrupt-thread-upon-a-resume.patch

