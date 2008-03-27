From: akpm@linux-foundation.org
Subject: - mmc-omap-do-not-busy-wait-for-end-of-command-for-ever.patch removed from -mm tree
Date: Wed, 26 Mar 2008 20:18:06 -0700
Message-ID: <200803270318.m2R3I6is015276@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37282 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755587AbYC0DSY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Mar 2008 23:18:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jarkko.lavinen@nokia.com, drzeus-list@drzeus.cx, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     mmc: omap: do not busy wait for end of command for ever
has been removed from the -mm tree.  Its filename was
     mmc-omap-do-not-busy-wait-for-end-of-command-for-ever.patch

This patch was dropped because an updated version will be merged

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

mmc-omap-do-not-busy-wait-for-end-of-command-for-ever.patch

