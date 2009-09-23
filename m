From: akpm@linux-foundation.org
Subject: [merged] sdhci-of-fix-sd-clock-calculation.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:55:37 -0700
Message-ID: <200909231955.n8NJtbnx003220@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39513 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753598AbZIWT4z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:56:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avorontsov@ru.mvista.com, ben@fluff.org, david.vrabel@csr.com, galak@kernel.crashing.org, linux-mmc@vger.kernel.org, pierre@ossman.eu, s.hauer@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     sdhci-of: fix SD clock calculation
has been removed from the -mm tree.  Its filename was
     sdhci-of-fix-sd-clock-calculation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sdhci-of: fix SD clock calculation
From: Anton Vorontsov <avorontsov@ru.mvista.com>

Linear divisor's values in a register start at 0 (zero means "divide by
1").  Before this patch the code didn't account that fact, so SD cards
were running underclocked.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Pierre Ossman <pierre@ossman.eu>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: David Vrabel <david.vrabel@csr.com>
Cc: Ben Dooks <ben@fluff.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci-of.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/mmc/host/sdhci-of.c~sdhci-of-fix-sd-clock-calculation drivers/mmc/host/sdhci-of.c
--- a/drivers/mmc/host/sdhci-of.c~sdhci-of-fix-sd-clock-calculation
+++ a/drivers/mmc/host/sdhci-of.c
@@ -136,6 +136,7 @@ static void esdhc_set_clock(struct sdhci
 	}
 
 	pre_div >>= 1;
+	div--;
 
 	setbits32(host->ioaddr + ESDHC_SYSTEM_CONTROL, ESDHC_CLOCK_IPGEN |
 		  ESDHC_CLOCK_HCKEN | ESDHC_CLOCK_PEREN |
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

origin.patch
linux-next.patch
rtc-set-wakeup-capability-for-i2c-and-spi-rtc-drivers.patch

