From: akpm@linux-foundation.org
Subject: + sdhci-support-10-bit-divided-clock-mode-for-spec-30.patch added to -mm tree
Date: Mon, 23 Aug 2010 13:19:56 -0700
Message-ID: <201008232019.o7NKJuXY012653@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44468 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753950Ab0HWUUL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Aug 2010 16:20:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zgao6@marvell.com, david.vrabel@csr.com, matt@console-pimps.org, mirqus@gmail.com


The patch titled
     sdhci: support 10 bit divided clock Mode for spec 3.0
has been added to the -mm tree.  Its filename is
     sdhci-support-10-bit-divided-clock-mode-for-spec-30.patch

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
Subject: sdhci: support 10 bit divided clock Mode for spec 3.0
From: Zhangfei Gao <zgao6@marvell.com>

Signed-off-by: Zhangfei Gao <zgao6@marvell.com>
Reviewed-by: Matt Fleming <matt@console-pimps.org>
Cc: Michal Miroslaw <mirqus@gmail.com>
Acked-by: David Vrabel <david.vrabel@csr.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci.c |   22 +++++++++++++++++-----
 drivers/mmc/host/sdhci.h |    5 +++++
 2 files changed, 22 insertions(+), 5 deletions(-)

diff -puN drivers/mmc/host/sdhci.c~sdhci-support-10-bit-divided-clock-mode-for-spec-30 drivers/mmc/host/sdhci.c
--- a/drivers/mmc/host/sdhci.c~sdhci-support-10-bit-divided-clock-mode-for-spec-30
+++ a/drivers/mmc/host/sdhci.c
@@ -1001,13 +1001,25 @@ static void sdhci_set_clock(struct sdhci
 	if (clock == 0)
 		goto out;
 
-	for (div = 1;div < 256;div *= 2) {
-		if ((host->max_clk / div) <= clock)
-			break;
+	if (host->version >= SDHCI_SPEC_300) {
+		if(host->max_clk <= clock)
+			div = 1;
+		else {
+			for (div = 2; div < 2046; div += 2) {
+				if ((host->max_clk / div) <= clock)
+					break;
+			}
+		}
+	} else {
+		for (div = 1;div < 256;div *= 2) {
+			if ((host->max_clk / div) <= clock)
+				break;
+		}
 	}
 	div >>= 1;
 
-	clk = div << SDHCI_DIVIDER_SHIFT;
+	clk = (div & SDHCI_DIV_MASK) << SDHCI_DIVIDER_SHIFT;
+	clk |= ((div & SDHCI_DIV_HI_MASK) >> SDHCI_DIV_MASK_LEN) << SDHCI_DIVIDER_HI_SHIFT;
 	clk |= SDHCI_CLOCK_INT_EN;
 	sdhci_writew(host, clk, SDHCI_CLOCK_CONTROL);
 
@@ -1708,7 +1720,7 @@ int sdhci_add_host(struct sdhci_host *ho
 	host->version = sdhci_readw(host, SDHCI_HOST_VERSION);
 	host->version = (host->version & SDHCI_SPEC_VER_MASK)
 				>> SDHCI_SPEC_VER_SHIFT;
-	if (host->version > SDHCI_SPEC_200) {
+	if (host->version > SDHCI_SPEC_300) {
 		printk(KERN_ERR "%s: Unknown controller version (%d). "
 			"You may experience problems.\n", mmc_hostname(mmc),
 			host->version);
diff -puN drivers/mmc/host/sdhci.h~sdhci-support-10-bit-divided-clock-mode-for-spec-30 drivers/mmc/host/sdhci.h
--- a/drivers/mmc/host/sdhci.h~sdhci-support-10-bit-divided-clock-mode-for-spec-30
+++ a/drivers/mmc/host/sdhci.h
@@ -86,6 +86,10 @@
 
 #define SDHCI_CLOCK_CONTROL	0x2C
 #define  SDHCI_DIVIDER_SHIFT	8
+#define  SDHCI_DIVIDER_HI_SHIFT	6
+#define  SDHCI_DIV_MASK	0xFF
+#define  SDHCI_DIV_MASK_LEN	8
+#define  SDHCI_DIV_HI_MASK	0x300
 #define  SDHCI_CLOCK_CARD_EN	0x0004
 #define  SDHCI_CLOCK_INT_STABLE	0x0002
 #define  SDHCI_CLOCK_INT_EN	0x0001
@@ -178,6 +182,7 @@
 #define  SDHCI_SPEC_VER_SHIFT	0
 #define   SDHCI_SPEC_100	0
 #define   SDHCI_SPEC_200	1
+#define   SDHCI_SPEC_300	2
 
 struct sdhci_ops;
 
_

Patches currently in -mm which might be from zgao6@marvell.com are

sdhci-support-mmc_cap_mmc_highspeed.patch
sdhci-support-10-bit-divided-clock-mode-for-spec-30.patch
sdhci-support-10-bit-divided-clock-mode-for-spec-30-checkpatch-fixes.patch
sdhci-base-clock-freqency-change-in-spec-30.patch

