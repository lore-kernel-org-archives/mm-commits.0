From: akpm@linux-foundation.org
Subject: + mmc-use-regulator-framework-correctly.patch added to -mm tree
Date: Thu, 05 Aug 2010 14:32:47 -0700
Message-ID: <201008052132.o75LWlge006062__15733.2098614008$1281044021$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35255 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754603Ab0HEVdc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Aug 2010 17:33:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adrian.hunter@nokia.com, broonie@opensource.wolfsonmicro.com, linux-mmc@vger.kernel.org, lrg@slimlogic.co.uk, sameo@linux.intel.com


The patch titled
     mmc: use regulator framework correctly
has been added to the -mm tree.  Its filename is
     mmc-use-regulator-framework-correctly.patch

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
Subject: mmc: use regulator framework correctly
From: Adrian Hunter <adrian.hunter@nokia.com>

Issues with the regulator framework no longer exist, so regulator_enable()
/ regulator_disable() should be used correctly.

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/core.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN drivers/mmc/core/core.c~mmc-use-regulator-framework-correctly drivers/mmc/core/core.c
--- a/drivers/mmc/core/core.c~mmc-use-regulator-framework-correctly
+++ a/drivers/mmc/core/core.c
@@ -784,11 +784,6 @@ int mmc_regulator_set_ocr(struct regulat
 {
 	int			result = 0;
 	int			min_uV, max_uV;
-	int			enabled;
-
-	enabled = regulator_is_enabled(supply);
-	if (enabled < 0)
-		return enabled;
 
 	if (vdd_bit) {
 		int		tmp;
@@ -819,9 +814,9 @@ int mmc_regulator_set_ocr(struct regulat
 		else
 			result = 0;
 
-		if (result == 0 && !enabled)
+		if (result == 0)
 			result = regulator_enable(supply);
-	} else if (enabled) {
+	} else {
 		result = regulator_disable(supply);
 	}
 
_

Patches currently in -mm which might be from adrian.hunter@nokia.com are

origin.patch
linux-next.patch
mmc-recognize-csd-structure.patch
mmc-recognize-csd-structure-fix.patch
mmc-split-mmc_sd_init_card.patch
mmc-implement-sd-combo-iomem-support.patch
mmc-omap-fix-for-bus-width-which-improves-sd-cards-peformance.patch
sdio-allow-non-standard-sdio-cards.patch
omap_hsmmc-add-init_card-pass-through-callback.patch
omap-pandora-pass-wl1251-information-to-sdio-core.patch
mmc-add-erase-secure-erase-trim-and-secure-trim-operations.patch
mmc_block-add-discard-support.patch
omap_hsmmc-add-erase-capability.patch
block-add-secure-discard.patch
mmc_block-add-support-for-secure-discard.patch
mmc_test-add-performance-tests.patch
mmc_test-fix-large-memory-allocation.patch
mmc-use-regulator-framework-correctly.patch

