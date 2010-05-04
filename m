From: akpm@linux-foundation.org
Subject: + s3c6410-add-new-quirk-in-sdhci-driver-and-update-adma-descriptor-build.patch added to -mm tree
Date: Tue, 04 May 2010 16:46:06 -0700
Message-ID: <201005042346.o44Nk6Oi025952__5171.42358371547$1273016795$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37532 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754139Ab0EDXqa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 May 2010 19:46:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mcuelenaere@gmail.com, ben-linux@fluff.org, linux-mmc@vger.kernel.org, thomas.ab@samsung.com


The patch titled
     mmc: s3c6410: add new quirk in sdhci driver and update ADMA descriptor build.
has been added to the -mm tree.  Its filename is
     s3c6410-add-new-quirk-in-sdhci-driver-and-update-adma-descriptor-build.patch

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
Subject: mmc: s3c6410: add new quirk in sdhci driver and update ADMA descriptor build.
From: Maurus Cuelenaere <mcuelenaere@gmail.com>

The s3c6410 sdhci controller does not support the 'End' attribute and NOP
attribute in the same 8-Byte ADMA descriptor.  This patch adds a new quirk
to identify sdhci host contollers with such behaviour.  In addition to
this, for controllers using the new quirk, the last entry in the ADMA
descritor table is marked with the 'End' attribute (instead of using a NOP
descriptor with 'End' attribute).

Signed-off-by: Maurus Cuelenaere <mcuelenaere@gmail.com>
Signed-off-by: Thomas Abraham <thomas.ab@samsung.com>
Acked-by: Ben Dooks <ben-linux@fluff.org>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci.c |   20 +++++++++++++++-----
 drivers/mmc/host/sdhci.h |    2 ++
 2 files changed, 17 insertions(+), 5 deletions(-)

diff -puN drivers/mmc/host/sdhci.c~s3c6410-add-new-quirk-in-sdhci-driver-and-update-adma-descriptor-build drivers/mmc/host/sdhci.c
--- a/drivers/mmc/host/sdhci.c~s3c6410-add-new-quirk-in-sdhci-driver-and-update-adma-descriptor-build
+++ a/drivers/mmc/host/sdhci.c
@@ -496,12 +496,22 @@ static int sdhci_adma_table_pre(struct s
 		WARN_ON((desc - host->adma_desc) > (128 * 2 + 1) * 4);
 	}
 
-	/*
-	 * Add a terminating entry.
-	 */
+	if (host->quirks & SDHCI_QUIRK_NO_ENDATTR_IN_NOPDESC) {
+		/*
+		* Mark the last descriptor as the terminating descriptor
+		*/
+		if (desc != host->adma_desc) {
+			desc -= 8;
+			desc[0] |= 0x2; /* end */
+		}
+	} else {
+		/*
+		* Add a terminating entry.
+		*/
 
-	/* nop, end, valid */
-	sdhci_set_adma_desc(desc, 0, 0, 0x3);
+		/* nop, end, valid */
+		sdhci_set_adma_desc(desc, 0, 0, 0x3);
+	}
 
 	/*
 	 * Resync align buffer as we might have changed it.
diff -puN drivers/mmc/host/sdhci.h~s3c6410-add-new-quirk-in-sdhci-driver-and-update-adma-descriptor-build drivers/mmc/host/sdhci.h
--- a/drivers/mmc/host/sdhci.h~s3c6410-add-new-quirk-in-sdhci-driver-and-update-adma-descriptor-build
+++ a/drivers/mmc/host/sdhci.h
@@ -238,6 +238,8 @@ struct sdhci_host {
 #define SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK		(1<<24)
 /* Controller reports wrong base clock capability */
 #define SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN		(1<<25)
+/* Controller cannot support End Attribute in NOP ADMA descriptor */
+#define SDHCI_QUIRK_NO_ENDATTR_IN_NOPDESC		(1<<26)
 
 	int			irq;		/* Device IRQ */
 	void __iomem *		ioaddr;		/* Mapped address */
_

Patches currently in -mm which might be from mcuelenaere@gmail.com are

s3c6410-add-new-quirk-in-sdhci-driver-and-update-adma-descriptor-build.patch
s3c6410-enable-adma-feature-in-6410-sdhci-controller.patch
sdhci-enable-multiblock-transfers-in-sdhci-s3c.patch
s3c-rtc-driver-add-support-for-s3c64xx.patch

