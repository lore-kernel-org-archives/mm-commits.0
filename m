From: akpm@linux-foundation.org
Subject: + sdhci-base-clock-freqency-change-in-spec-30.patch added to -mm tree
Date: Mon, 23 Aug 2010 13:19:59 -0700
Message-ID: <201008232019.o7NKJxrW012656@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53451 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753950Ab0HWUUJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Aug 2010 16:20:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zgao6@marvell.com, david.vrabel@csr.com, matt@console-pimps.org, mirqus@gmail.com


The patch titled
     sdhci: base clock freqency change in spec 3.0
has been added to the -mm tree.  Its filename is
     sdhci-base-clock-freqency-change-in-spec-30.patch

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
Subject: sdhci: base clock freqency change in spec 3.0
From: Zhangfei Gao <zgao6@marvell.com>

sdhc spec 3.0:       Capabilities Register bits[15-08] is Base Clock Freqency
sdhc spec 1.0 & 2.0: Capabilities Register bits[13-08] is Base Clock Freqency

Signed-off-by: Zhangfei Gao <zgao6@marvell.com>
Cc: David Vrabel <david.vrabel@csr.com>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Michal Miroslaw <mirqus@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci.c |    8 ++++++--
 drivers/mmc/host/sdhci.h |    1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

diff -puN drivers/mmc/host/sdhci.c~sdhci-base-clock-freqency-change-in-spec-30 drivers/mmc/host/sdhci.c
--- a/drivers/mmc/host/sdhci.c~sdhci-base-clock-freqency-change-in-spec-30
+++ a/drivers/mmc/host/sdhci.c
@@ -1792,8 +1792,12 @@ int sdhci_add_host(struct sdhci_host *ho
 		mmc_dev(host->mmc)->dma_mask = &host->dma_mask;
 	}
 
-	host->max_clk =
-		(caps & SDHCI_CLOCK_BASE_MASK) >> SDHCI_CLOCK_BASE_SHIFT;
+	if (host->version >= SDHCI_SPEC_300)
+		host->max_clk =
+			(caps & SDHCI_CLOCK_V3_BASE_MASK) >> SDHCI_CLOCK_BASE_SHIFT;
+	else
+		host->max_clk =
+			(caps & SDHCI_CLOCK_BASE_MASK) >> SDHCI_CLOCK_BASE_SHIFT;
 	host->max_clk *= 1000000;
 	if (host->max_clk == 0 || host->quirks &
 			SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN) {
diff -puN drivers/mmc/host/sdhci.h~sdhci-base-clock-freqency-change-in-spec-30 drivers/mmc/host/sdhci.h
--- a/drivers/mmc/host/sdhci.h~sdhci-base-clock-freqency-change-in-spec-30
+++ a/drivers/mmc/host/sdhci.h
@@ -144,6 +144,7 @@
 #define  SDHCI_TIMEOUT_CLK_SHIFT 0
 #define  SDHCI_TIMEOUT_CLK_UNIT	0x00000080
 #define  SDHCI_CLOCK_BASE_MASK	0x00003F00
+#define  SDHCI_CLOCK_V3_BASE_MASK	0x0000FF00
 #define  SDHCI_CLOCK_BASE_SHIFT	8
 #define  SDHCI_MAX_BLOCK_MASK	0x00030000
 #define  SDHCI_MAX_BLOCK_SHIFT  16
_

Patches currently in -mm which might be from zgao6@marvell.com are

sdhci-support-mmc_cap_mmc_highspeed.patch
sdhci-support-10-bit-divided-clock-mode-for-spec-30.patch
sdhci-support-10-bit-divided-clock-mode-for-spec-30-checkpatch-fixes.patch
sdhci-base-clock-freqency-change-in-spec-30.patch

