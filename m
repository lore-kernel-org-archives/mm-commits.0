From: akpm@linux-foundation.org
Subject: + sdhci-remove-useless-set_clock-check.patch added to -mm tree
Date: Tue, 15 Jun 2010 13:17:49 -0700
Message-ID: <201006152017.o5FKHnlT028485@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55621 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932251Ab0FOUSX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jun 2010 16:18:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kyungmin.park@samsung.com, linux-mmc@vger.kernel.org


The patch titled
     sdhci: remove useless set_clock() check
has been added to the -mm tree.  Its filename is
     sdhci-remove-useless-set_clock-check.patch

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
Subject: sdhci: remove useless set_clock() check
From: Kyungmin Park <kyungmin.park@samsung.com>

When using QUIRK_NONSTANDARD_CLOCK, it checks the set_clock() function
which is not used actually.  So delete it.

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mmc/host/sdhci.c~sdhci-remove-useless-set_clock-check drivers/mmc/host/sdhci.c
--- a/drivers/mmc/host/sdhci.c~sdhci-remove-useless-set_clock-check
+++ a/drivers/mmc/host/sdhci.c
@@ -1787,7 +1787,7 @@ int sdhci_add_host(struct sdhci_host *ho
 	 */
 	mmc->ops = &sdhci_ops;
 	if (host->quirks & SDHCI_QUIRK_NONSTANDARD_CLOCK &&
-			host->ops->set_clock && host->ops->get_min_clock)
+			host->ops->get_min_clock)
 		mmc->f_min = host->ops->get_min_clock(host);
 	else
 		mmc->f_min = host->max_clk / 256;
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

