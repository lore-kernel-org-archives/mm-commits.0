From: akpm@linux-foundation.org
Subject: + sdhci-8-bit-data-transfer-width-support.patch added to -mm tree
Date: Tue, 15 Jun 2010 13:17:53 -0700
Message-ID: <201006152017.o5FKHrpL028492__9120.39943873442$1276633119$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51264 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757835Ab0FOUSa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jun 2010 16:18:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kyungmin.park@samsung.com, linux-mmc@vger.kernel.org


The patch titled
     sdhci: 8-bit data transfer width support
has been added to the -mm tree.  Its filename is
     sdhci-8-bit-data-transfer-width-support.patch

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
Subject: sdhci: 8-bit data transfer width support
From: Kyungmin Park <kyungmin.park@samsung.com>

Some host controllers such as s5pc110 support the WIDE8 feature.

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci.c |    5 +++++
 drivers/mmc/host/sdhci.h |    1 +
 2 files changed, 6 insertions(+)

diff -puN drivers/mmc/host/sdhci.c~sdhci-8-bit-data-transfer-width-support drivers/mmc/host/sdhci.c
--- a/drivers/mmc/host/sdhci.c~sdhci-8-bit-data-transfer-width-support
+++ a/drivers/mmc/host/sdhci.c
@@ -1159,6 +1159,11 @@ static void sdhci_set_ios(struct mmc_hos
 
 	ctrl = sdhci_readb(host, SDHCI_HOST_CONTROL);
 
+	if (ios->bus_width == MMC_BUS_WIDTH_8)
+		ctrl |= SDHCI_CTRL_8BITBUS;
+	else
+		ctrl &= ~SDHCI_CTRL_8BITBUS;
+
 	if (ios->bus_width == MMC_BUS_WIDTH_4)
 		ctrl |= SDHCI_CTRL_4BITBUS;
 	else
diff -puN drivers/mmc/host/sdhci.h~sdhci-8-bit-data-transfer-width-support drivers/mmc/host/sdhci.h
--- a/drivers/mmc/host/sdhci.h~sdhci-8-bit-data-transfer-width-support
+++ a/drivers/mmc/host/sdhci.h
@@ -72,6 +72,7 @@
 #define   SDHCI_CTRL_ADMA1	0x08
 #define   SDHCI_CTRL_ADMA32	0x10
 #define   SDHCI_CTRL_ADMA64	0x18
+#define  SDHCI_CTRL_8BITBUS	0x20
 
 #define SDHCI_POWER_CONTROL	0x29
 #define  SDHCI_POWER_ON		0x01
_

Patches currently in -mm which might be from kyungmin.park@samsung.com are

mmc-recognize-csd-structure.patch
mmc-recognize-csd-structure-fix.patch
s5pc110-sdhci-s3c-can-override-host-capabilities.patch
s5pc110-sdhci-s3c-support-on-s5pc110.patch
sdhci-add-no-hi-speed-bit-quirk-support.patch
sdhci-remove-useless-set_clock-check.patch
sdhci-dont-assign-mmc-caps-at-sdhci-directly.patch
sdhci-8-bit-data-transfer-width-support.patch

