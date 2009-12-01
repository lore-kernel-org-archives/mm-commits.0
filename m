From: akpm@linux-foundation.org
Subject: + mmc-remove-const-from-tmio-mmc-platform-data-v2.patch added to -mm tree
Date: Tue, 01 Dec 2009 13:54:19 -0800
Message-ID: <200912012154.nB1LsJPm029862__38883.7137179964$1259704477$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34186 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752667AbZLAVyT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Dec 2009 16:54:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: damm@opensource.se, lethal@linux-sh.org, linux-mmc@vger.kernel.org


The patch titled
     mmc: remove const from tmio-mmc platform data
has been added to the -mm tree.  Its filename is
     mmc-remove-const-from-tmio-mmc-platform-data-v2.patch

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
Subject: mmc: remove const from tmio-mmc platform data
From: Magnus Damm <damm@opensource.se>

Remove the const from the tmio-mmc platform data parameter "hclk".  Needed
by the SDHI driver.

Signed-off-by: Magnus Damm <damm@opensource.se>
Cc: <linux-mmc@vger.kernel.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mfd/tmio.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/mfd/tmio.h~mmc-remove-const-from-tmio-mmc-platform-data-v2 include/linux/mfd/tmio.h
--- a/include/linux/mfd/tmio.h~mmc-remove-const-from-tmio-mmc-platform-data-v2
+++ a/include/linux/mfd/tmio.h
@@ -60,7 +60,7 @@ void tmio_core_set_bus_shift(int bus_shi
  * data for the MMC controller
  */
 struct tmio_mmc_data {
-	const unsigned int		hclk;
+	unsigned int		hclk;
 	void (*set_pwr)(struct platform_device *host, int state);
 	void (*set_no_clk_div)(struct platform_device *host, int state);
 };
_

Patches currently in -mm which might be from damm@opensource.se are

linux-next.patch
clocksource-add-argument-to-resume-callback.patch
clocksource-start-cmt-at-clocksource-resume.patch
mmc-let-tmio-mmc-use-dev_name-with-request_irq.patch
mmc-remove-const-from-tmio-mmc-platform-data-v2.patch
mmc-balance-tmio-mmc-cell-enable-disable-calls.patch
spi-superh-msiof-spi-master-driver.patch
spi-superh-msiof-spi-master-driver-update.patch

