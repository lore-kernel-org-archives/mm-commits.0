From: akpm@linux-foundation.org
Subject: + sdhci-be-more-strict-with-get_min_clock-usage.patch added to -mm tree
Date: Wed, 05 Aug 2009 16:55:41 -0700
Message-ID: <200908052355.n75NtfgT000997@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56325 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751267AbZHEX4V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Aug 2009 19:56:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com, ian@mnementh.co.uk, matt@console-pimps.org, philipl@overt.org, pierre@ossman.eu


The patch titled
     sdhci: be more strict with get_min_clock() usage
has been added to the -mm tree.  Its filename is
     sdhci-be-more-strict-with-get_min_clock-usage.patch

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
Subject: sdhci: be more strict with get_min_clock() usage
From: Anton Vorontsov <avorontsov@ru.mvista.com>

get_min_clock() makes sense only with NONSTANDARD_CLOCK quirk and when
set_clock() callback is specified.

The patch should cause no functional changes, it just makes the code
self-documented and avoids any possible misuse of get_min_clock().

Suggested-by: Pierre Ossman <pierre@ossman.eu>
Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Philip Langdale <philipl@overt.org>
Cc: Pierre Ossman <pierre@ossman.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/mmc/host/sdhci.c~sdhci-be-more-strict-with-get_min_clock-usage drivers/mmc/host/sdhci.c
--- a/drivers/mmc/host/sdhci.c~sdhci-be-more-strict-with-get_min_clock-usage
+++ a/drivers/mmc/host/sdhci.c
@@ -1772,7 +1772,8 @@ int sdhci_add_host(struct sdhci_host *ho
 	 * Set host parameters.
 	 */
 	mmc->ops = &sdhci_ops;
-	if (host->ops->get_min_clock)
+	if (host->quirks & SDHCI_QUIRK_NONSTANDARD_CLOCK &&
+			host->ops->set_clock && host->ops->get_min_clock)
 		mmc->f_min = host->ops->get_min_clock(host);
 	else
 		mmc->f_min = host->max_clk / 256;
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

linux-next.patch
mtd-sst25l-non-jedec-spi-flash-driver.patch
mtd-sst25l-non-jedec-spi-flash-driver-update.patch
mtd-sst25l-non-jedec-spi-flash-driver-fix.patch
drivers-mmc-correct-error-handling-code.patch
mtd-m25p80-fix-null-pointer-dereference-bug.patch
sdhci-be-more-strict-with-get_min_clock-usage.patch
spi-add-support-for-device-table-matching.patch
mtd-m25p80-convert-to-device-table-matching.patch
of-remove-stmm25p40-alias.patch
hwmon-adxx-convert-to-device-table-matching.patch
hwmon-lm70-convert-to-device-table-matching.patch
spi-prefix-modalias-with-spi.patch

