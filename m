From: akpm@linux-foundation.org
Subject: + sdhci-add-no-hi-speed-bit-quirk-support.patch added to -mm tree
Date: Thu, 10 Jun 2010 13:43:19 -0700
Message-ID: <201006102043.o5AKhJjl022731@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39937 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759700Ab0FJUnn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jun 2010 16:43:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kmpark@infradead.org, kyungmin.park@samsung.com, linux-mmc@vger.kernel.org


The patch titled
     SDHCI: add no hi-speed bit quirk support
has been added to the -mm tree.  Its filename is
     sdhci-add-no-hi-speed-bit-quirk-support.patch

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
Subject: SDHCI: add no hi-speed bit quirk support
From: Kyungmin Park <kmpark@infradead.org>

Some SDHCI controllers like s5pc110 don't have an HISPD bit in the HOSTCTL
register.

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci.c |    3 ++-
 drivers/mmc/host/sdhci.h |    2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/mmc/host/sdhci.c~sdhci-add-no-hi-speed-bit-quirk-support drivers/mmc/host/sdhci.c
--- a/drivers/mmc/host/sdhci.c~sdhci-add-no-hi-speed-bit-quirk-support
+++ a/drivers/mmc/host/sdhci.c
@@ -1164,7 +1164,8 @@ static void sdhci_set_ios(struct mmc_hos
 	else
 		ctrl &= ~SDHCI_CTRL_4BITBUS;
 
-	if (ios->timing == MMC_TIMING_SD_HS)
+	if (ios->timing == MMC_TIMING_SD_HS &&
+	    !(host->quirks & SDHCI_QUIRK_NO_HISPD_BIT))
 		ctrl |= SDHCI_CTRL_HISPD;
 	else
 		ctrl &= ~SDHCI_CTRL_HISPD;
diff -puN drivers/mmc/host/sdhci.h~sdhci-add-no-hi-speed-bit-quirk-support drivers/mmc/host/sdhci.h
--- a/drivers/mmc/host/sdhci.h~sdhci-add-no-hi-speed-bit-quirk-support
+++ a/drivers/mmc/host/sdhci.h
@@ -240,6 +240,8 @@ struct sdhci_host {
 #define SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN		(1<<25)
 /* Controller cannot support End Attribute in NOP ADMA descriptor */
 #define SDHCI_QUIRK_NO_ENDATTR_IN_NOPDESC		(1<<26)
+/* Controller doesn't have HISPD bit field in HI-SPEED SD card */
+#define SDHCI_QUIRK_NO_HISPD_BIT			(1<<27)
 
 	int			irq;		/* Device IRQ */
 	void __iomem *		ioaddr;		/* Mapped address */
_

Patches currently in -mm which might be from kmpark@infradead.org are

mmc-recognize-csd-structure.patch
mmc-recognize-csd-structure-fix.patch
s5pc110-sdhci-s3c-can-override-host-capabilities.patch
s5pc110-sdhci-s3c-support-on-s5pc110.patch
sdhci-add-no-hi-speed-bit-quirk-support.patch

