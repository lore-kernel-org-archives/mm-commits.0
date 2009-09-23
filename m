From: akpm@linux-foundation.org
Subject: [merged] sdhci-be-more-strict-with-get_min_clock-usage.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:55:31 -0700
Message-ID: <200909231955.n8NJtVIY002967@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36449 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753929AbZIWUEq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:04:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avorontsov@ru.mvista.com, ian@mnementh.co.uk, matt@console-pimps.org, philipl@overt.org, pierre@ossman.eu, mm-commits@vger.kernel.org


The patch titled
     sdhci: be more strict with get_min_clock() usage
has been removed from the -mm tree.  Its filename was
     sdhci-be-more-strict-with-get_min_clock-usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
rtc-set-wakeup-capability-for-i2c-and-spi-rtc-drivers.patch

