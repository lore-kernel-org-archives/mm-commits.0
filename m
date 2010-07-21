From: akpm@linux-foundation.org
Subject: + sdhci-get-rid-of-mdelays-where-it-is-safe-and-makes-sense.patch added to -mm tree
Date: Wed, 21 Jul 2010 14:14:14 -0700
Message-ID: <201007212114.o6LLEEFE015620@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40902 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758155Ab0GUVPL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Jul 2010 17:15:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@mvista.com, albert_herranz@yahoo.es, ben-linux@fluff.org, matt@console-pimps.org, pierre@ossman.eu, w.sang@pengutronix.de


The patch titled
     sdhci: get rid of mdelay()s where it is safe and makes sense
has been added to the -mm tree.  Its filename is
     sdhci-get-rid-of-mdelays-where-it-is-safe-and-makes-sense.patch

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
Subject: sdhci: get rid of mdelay()s where it is safe and makes sense
From: Anton Vorontsov <avorontsov@mvista.com>

Since we don't run in the atomic context any longer, we can turn mdelay()s
into msleep()s.

The only place where the driver is still using mdelay() is
sdhci_send_command().  There it is possible to use sleepable delays too,
but we don't actually want to force rescheduling in a hot path.

Sure, we might end up calling msleep() there too, just not via this safe
patch.

Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Cc: Albert Herranz <albert_herranz@yahoo.es>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Pierre Ossman <pierre@ossman.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci-of-esdhc.c |    2 +-
 drivers/mmc/host/sdhci.c          |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/mmc/host/sdhci-of-esdhc.c~sdhci-get-rid-of-mdelays-where-it-is-safe-and-makes-sense drivers/mmc/host/sdhci-of-esdhc.c
--- a/drivers/mmc/host/sdhci-of-esdhc.c~sdhci-get-rid-of-mdelays-where-it-is-safe-and-makes-sense
+++ a/drivers/mmc/host/sdhci-of-esdhc.c
@@ -94,7 +94,7 @@ static void esdhc_set_clock(struct sdhci
 	setbits32(host->ioaddr + ESDHC_SYSTEM_CONTROL, ESDHC_CLOCK_IPGEN |
 		  ESDHC_CLOCK_HCKEN | ESDHC_CLOCK_PEREN |
 		  div << ESDHC_DIVIDER_SHIFT | pre_div << ESDHC_PREDIV_SHIFT);
-	mdelay(100);
+	msleep(100);
 out:
 	host->clock = clock;
 }
diff -puN drivers/mmc/host/sdhci.c~sdhci-get-rid-of-mdelays-where-it-is-safe-and-makes-sense drivers/mmc/host/sdhci.c
--- a/drivers/mmc/host/sdhci.c~sdhci-get-rid-of-mdelays-where-it-is-safe-and-makes-sense
+++ a/drivers/mmc/host/sdhci.c
@@ -171,7 +171,7 @@ static void sdhci_reset(struct sdhci_hos
 			return;
 		}
 		timeout--;
-		mdelay(1);
+		msleep(1);
 	}
 
 	if (host->quirks & SDHCI_QUIRK_RESTORE_IRQS_AFTER_RESET)
@@ -1019,7 +1019,7 @@ static void sdhci_set_clock(struct sdhci
 			return;
 		}
 		timeout--;
-		mdelay(1);
+		msleep(1);
 	}
 
 	clk |= SDHCI_CLOCK_CARD_EN;
@@ -1086,7 +1086,7 @@ static void sdhci_set_power(struct sdhci
 	 * can apply clock after applying power
 	 */
 	if (host->quirks & SDHCI_QUIRK_DELAY_AFTER_POWER)
-		mdelay(10);
+		msleep(10);
 }
 
 /*****************************************************************************\
_

Patches currently in -mm which might be from avorontsov@mvista.com are

origin.patch
linux-next.patch
sdhci-pltfm-switch-to-module-device-table-matching.patch
sdhci-pltfm-reorganize-makefile-entries-to-support-soc-devices.patch
sdhci-pltfm-add-support-for-cns3xxx-soc-devices.patch
sdhci-s3c-add-support-for-the-non-standard-minimal-clock-value.patch
sdhci-turn-timeout-timer-into-delayed-work.patch
sdhci-use-work-structs-instead-of-tasklets.patch
sdhci-clear-interrupt-status-register-just-once.patch
sdhci-use-threaded-irq-handler.patch
sdhci-turn-host-lock-into-a-mutex.patch
sdhci-get-rid-of-card-detect-work.patch
sdhci-get-rid-of-mdelays-where-it-is-safe-and-makes-sense.patch
sdhci-use-jiffies-instead-of-a-timeout-counter.patch

