From: akpm@linux-foundation.org
Subject: [merged] sdhci-increase-timeout-for-internal-clock-stabilization.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:56:30 -0700
Message-ID: <200909231956.n8NJuUvo005000__20801.5113872991$1253735844$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56300 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753680AbZIWT5C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:57:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cjb@laptop.org, HaraldWelte@viatech.com, linux-mmc@vger.kernel.org, pierre@ossman.eu, mm-commits@vger.kernel.org


The patch titled
     sdhci: increase timeout for internal clock stabilization.
has been removed from the -mm tree.  Its filename was
     sdhci-increase-timeout-for-internal-clock-stabilization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sdhci: increase timeout for internal clock stabilization.
From: Chris Ball <cjb@laptop.org>

On an OLPC XO-1.5 development board with Via VX855 chipset, the sdhci
controller can take up to 12ms to stabilize its clock, but the current
timeout at which we give up on the controller is 10ms.

The patch increases the timeout delay rather than using a device-specific
quirk -- since we exit the loop when the clock comes up, increasing the
timeout value will only make us mdelay() longer in the errant case of a
device with a clock that is not stabilizing, which it seems worth waiting
a little longer for in general.

Signed-off-by: Chris Ball <cjb@laptop.org>
Cc: Harald Welte <HaraldWelte@viatech.com>
Acked-by: Pierre Ossman <pierre@ossman.eu>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/mmc/host/sdhci.c~sdhci-increase-timeout-for-internal-clock-stabilization drivers/mmc/host/sdhci.c
--- a/drivers/mmc/host/sdhci.c~sdhci-increase-timeout-for-internal-clock-stabilization
+++ a/drivers/mmc/host/sdhci.c
@@ -994,8 +994,8 @@ static void sdhci_set_clock(struct sdhci
 	clk |= SDHCI_CLOCK_INT_EN;
 	sdhci_writew(host, clk, SDHCI_CLOCK_CONTROL);
 
-	/* Wait max 10 ms */
-	timeout = 10;
+	/* Wait max 20 ms */
+	timeout = 20;
 	while (!((clk = sdhci_readw(host, SDHCI_CLOCK_CONTROL))
 		& SDHCI_CLOCK_INT_STABLE)) {
 		if (timeout == 0) {
_

Patches currently in -mm which might be from cjb@laptop.org are

origin.patch

