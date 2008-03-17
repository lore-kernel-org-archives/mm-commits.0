From: akpm@linux-foundation.org
Subject: + mmc-omap-remove-extra-divisor-increase.patch added to -mm tree
Date: Mon, 17 Mar 2008 15:27:09 -0700
Message-ID: <200803172227.m2HMR9iS001519@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41277 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751478AbYCQW1W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 18:27:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tony@atomide.com, carlos.aguiar@indt.org.br, drzeus-list@drzeus.cx


The patch titled
     mmc: omap: remove extra divisor increase
has been added to the -mm tree.  Its filename is
     mmc-omap-remove-extra-divisor-increase.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc: omap: remove extra divisor increase
From: Tony Lindgren <tony@atomide.com>

As noted by Kyungmin Park, the divisor calculation has an unnecessary
increase.

Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Carlos Eduardo Aguiar <carlos.aguiar@indt.org.br>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/mmc/host/omap.c~mmc-omap-remove-extra-divisor-increase drivers/mmc/host/omap.c
--- a/drivers/mmc/host/omap.c~mmc-omap-remove-extra-divisor-increase
+++ a/drivers/mmc/host/omap.c
@@ -931,7 +931,6 @@ static int mmc_omap_calc_divisor(struct 
 
 	if (dsor > 250)
 		dsor = 250;
-	dsor++;
 
 	if (ios->bus_width == MMC_BUS_WIDTH_4)
 		dsor |= 1 << 15;
_

Patches currently in -mm which might be from tony@atomide.com are

git-arm-master.patch
mmc-omap-remove-some-opcodes-from-host-driver.patch
mmc-omap-remove-extra-divisor-increase.patch
mmc-omap-fix-the-byteblock-capability-removal.patch
mmc-omap-remove-cover-switch-handling-to-allow-adding-multislot-support.patch
mmc-omap-introduce-new-multislot-structure-and-change-driver-to-use-it.patch
mmc-omap-add-back-cover-switch-support.patch
mmc-omap-new-release-dma-and-abort-xfer-functions.patch
mmc-omap-fix-timeout-calculation-for-mmc-multislot-support.patch
mmc-omap-power-functions-modified-to-mmc-multislot-support.patch
mmc-omap-general-cleanup-for-mmc-multislot-support.patch
mmc-omap-abort-stuck-commands.patch
mmc-omap-using-setup_timer-instead-of-init_timer.patch
mmc-omap-check-the-get_cover_state-function-pointer-if-not-set.patch
mmc-omap-use-tasklet-instead-of-workqueue-for-cover-switch-notification.patch
mmc-omap-move-failing-command-abortion-to-workqueue.patch
mmc-omap-lazy-clock-shutdown.patch
mmc-omap-start-new-commands-from-work-queue-instead-of-irq.patch
mmc-omap-do-not-busy-wait-for-end-of-command-for-ever.patch

