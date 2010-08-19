From: akpm@linux-foundation.org
Subject: + drivers-mmc-host-sdhci-s3cc-use-the-correct-mutex-and-card-detect-function.patch added to -mm tree
Date: Wed, 18 Aug 2010 19:45:18 -0700
Message-ID: <201008190242.o7J2ga0c025961@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54224 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750944Ab0HSCmp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Aug 2010 22:42:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kyungmin.park@samsung.com, linux-mmc@vger.kernel.org


The patch titled
     drivers/mmc/host/sdhci-s3c.c: use the correct mutex and card detect function
has been added to the -mm tree.  Its filename is
     drivers-mmc-host-sdhci-s3cc-use-the-correct-mutex-and-card-detect-function.patch

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
Subject: drivers/mmc/host/sdhci-s3c.c: use the correct mutex and card detect function
From: Kyungmin Park <kyungmin.park@samsung.com>

There's some merge problem between sdhic core and sdhci-s3c host.  After
mutex is changed to spinlock.  It needs to use use spin lock functions and
use the correct card detection function.

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci-s3c.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/mmc/host/sdhci-s3c.c~drivers-mmc-host-sdhci-s3cc-use-the-correct-mutex-and-card-detect-function drivers/mmc/host/sdhci-s3c.c
--- a/drivers/mmc/host/sdhci-s3c.c~drivers-mmc-host-sdhci-s3cc-use-the-correct-mutex-and-card-detect-function
+++ a/drivers/mmc/host/sdhci-s3c.c
@@ -242,7 +242,7 @@ static void sdhci_s3c_notify_change(stru
 {
 	struct sdhci_host *host = platform_get_drvdata(dev);
 	if (host) {
-		mutex_lock(&host->lock);
+		spin_lock(&host->lock);
 		if (state) {
 			dev_dbg(&dev->dev, "card inserted.\n");
 			host->flags &= ~SDHCI_DEVICE_DEAD;
@@ -252,8 +252,8 @@ static void sdhci_s3c_notify_change(stru
 			host->flags |= SDHCI_DEVICE_DEAD;
 			host->quirks &= ~SDHCI_QUIRK_BROKEN_CARD_DETECTION;
 		}
-		sdhci_card_detect(host);
-		mutex_unlock(&host->lock);
+		tasklet_schedule(&host->card_tasklet);
+		spin_unlock(&host->lock);
 	}
 }
 
_

Patches currently in -mm which might be from kyungmin.park@samsung.com are

drivers-mmc-host-sdhci-s3cc-use-the-correct-mutex-and-card-detect-function.patch
linux-next.patch
s5pc110-sdhci-s3c-can-override-host-capabilities.patch
s5pc110-sdhci-s3c-support-on-s5pc110.patch
sdhci-add-no-hi-speed-bit-quirk-support.patch
ramoops-use-the-platform-data-structure-instead-of-module-params.patch

