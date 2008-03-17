From: akpm@linux-foundation.org
Subject: + mmc-omap-do-not-busy-wait-for-end-of-command-for-ever.patch added to -mm tree
Date: Mon, 17 Mar 2008 15:27:43 -0700
Message-ID: <200803172227.m2HMRiZe001567@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57007 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753596AbYCQW17 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 18:27:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jarkko.lavinen@nokia.com, drzeus-list@drzeus.cx, tony@atomide.com


The patch titled
     mmc: omap: do not busy wait for end of command for ever
has been added to the -mm tree.  Its filename is
     mmc-omap-do-not-busy-wait-for-end-of-command-for-ever.patch

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
Subject: mmc: omap: do not busy wait for end of command for ever
From: Jarkko Lavinen <jarkko.lavinen@nokia.com>

The limit was a fixed 100k limit in the busy loop, which is not accurate.  It
would better to have time limit for the worst case which occurs when sending
80 cycles at 400 kHz and takes about 200 microseconds, so limit the max time
spend in the busy loop for some 250 microseconds.

Signed-off-by: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/mmc/host/omap.c~mmc-omap-do-not-busy-wait-for-end-of-command-for-ever drivers/mmc/host/omap.c
--- a/drivers/mmc/host/omap.c~mmc-omap-do-not-busy-wait-for-end-of-command-for-ever
+++ a/drivers/mmc/host/omap.c
@@ -1276,11 +1276,17 @@ static void mmc_omap_set_ios(struct mmc_
 		OMAP_MMC_WRITE(host, CON, dsor);
 	slot->saved_con = dsor;
 	if (ios->power_mode == MMC_POWER_ON) {
+		/* worst case at 400kHz, 80 cycles makes 200 microsecs */
+		int usecs = 250;
+
 		/* Send clock cycles, poll completion */
 		OMAP_MMC_WRITE(host, IE, 0);
 		OMAP_MMC_WRITE(host, STAT, 0xffff);
 		OMAP_MMC_WRITE(host, CMD, 1 << 7);
-		while ((OMAP_MMC_READ(host, STAT) & 1) == 0);
+		while (usecs > 0 && (OMAP_MMC_READ(host, STAT) & 1) == 0) {
+			udelay(1);
+			usecs--;
+		}
 		OMAP_MMC_WRITE(host, STAT, 1);
 	}
 
_

Patches currently in -mm which might be from jarkko.lavinen@nokia.com are

mmc-omap-introduce-new-multislot-structure-and-change-driver-to-use-it.patch
mmc-omap-add-back-cover-switch-support.patch
mmc-omap-fix-timeout-calculation-for-mmc-multislot-support.patch
mmc-omap-abort-stuck-commands.patch
mmc-omap-use-tasklet-instead-of-workqueue-for-cover-switch-notification.patch
mmc-omap-move-failing-command-abortion-to-workqueue.patch
mmc-omap-lazy-clock-shutdown.patch
mmc-omap-start-new-commands-from-work-queue-instead-of-irq.patch
mmc-omap-do-not-busy-wait-for-end-of-command-for-ever.patch

