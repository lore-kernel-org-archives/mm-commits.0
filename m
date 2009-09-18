From: akpm@linux-foundation.org
Subject: + sdhci-increase-timeout-for-internal-clock-stabilization.patch added to -mm tree
Date: Fri, 18 Sep 2009 15:30:57 -0700
Message-ID: <200909182230.n8IMUv2f014367__14947.9312859059$1253313103$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46286 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751432AbZIRWb3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Sep 2009 18:31:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cjb@laptop.org, HaraldWelte@viatech.com, linux-mmc@vger.kernel.org


The patch titled
     sdhci: increase timeout for internal clock stabilization.
has been added to the -mm tree.  Its filename is
     sdhci-increase-timeout-for-internal-clock-stabilization.patch

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

sdhci-add-no-card-no-reset-quirk-for-ricoh-r5c822-sony-z11.patch
sdhci-increase-timeout-for-internal-clock-stabilization.patch

