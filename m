From: akpm@linux-foundation.org
Subject: [merged] mmc-in-mmc_power_up-use-previously-selected-ocr-if-available.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:53:54 -0700
Message-ID: <200909231953.n8NJrsuI032095@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60732 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753094AbZIWTzE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:55:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: balajirrao@openmoko.org, andy@openmoko.com, drzeus-mmc@drzeus.cx, ian@mnementh.co.uk, matt@console-pimps.org, philipl@overt.org, roberto.foglietta@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mmc: in mmc_power_up(), use previously selected ocr if available
has been removed from the -mm tree.  Its filename was
     mmc-in-mmc_power_up-use-previously-selected-ocr-if-available.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc: in mmc_power_up(), use previously selected ocr if available
From: Balaji Rao <balajirrao@openmoko.org>

When mmc_power_up is called during unsafe resume, host->ocr should be used
instead of host->ocr_avail.

Signed-off-by: Balaji Rao <balajirrao@openmoko.org>
Cc: Andy Green <andy@openmoko.com>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: "Roberto A. Foglietta" <roberto.foglietta@gmail.com>
Cc: Philip Langdale <philipl@overt.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/core.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/mmc/core/core.c~mmc-in-mmc_power_up-use-previously-selected-ocr-if-available drivers/mmc/core/core.c
--- a/drivers/mmc/core/core.c~mmc-in-mmc_power_up-use-previously-selected-ocr-if-available
+++ a/drivers/mmc/core/core.c
@@ -687,7 +687,13 @@ void mmc_set_timing(struct mmc_host *hos
  */
 static void mmc_power_up(struct mmc_host *host)
 {
-	int bit = fls(host->ocr_avail) - 1;
+	int bit;
+
+	/* If ocr is set, we use it */
+	if (host->ocr)
+		bit = ffs(host->ocr) - 1;
+	else
+		bit = fls(host->ocr_avail) - 1;
 
 	host->ios.vdd = bit;
 	if (mmc_host_is_spi(host)) {
_

Patches currently in -mm which might be from balajirrao@openmoko.org are

origin.patch

