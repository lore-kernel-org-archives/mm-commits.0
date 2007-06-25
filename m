From: akpm@linux-foundation.org
Subject: - sm501-initialise-sdram-clock-before-bus-clocks.patch removed from -mm tree
Date: Mon, 25 Jun 2007 02:20:36 -0700
Message-ID: <200706250920.l5P9Kaj1031028@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55388 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751586AbXFYJV0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 05:21:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben-linux@fluff.org, vince@simtec.co.uk, mm-commits@vger.kernel.org


The patch titled
     SM501: initialise SDRAM clock before bus clocks
has been removed from the -mm tree.  Its filename was
     sm501-initialise-sdram-clock-before-bus-clocks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SM501: initialise SDRAM clock before bus clocks
From: Ben Dooks <ben-linux@fluff.org>

This init sequence of setting the SDRAM clock before the bus clock is
recommend by Silicon Motion to stop problems with writes not sticking into
registers.

Signed-off-by: Vincent Sanders <vince@simtec.co.uk>
Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/sm501.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/mfd/sm501.c~sm501-initialise-sdram-clock-before-bus-clocks drivers/mfd/sm501.c
--- a/drivers/mfd/sm501.c~sm501-initialise-sdram-clock-before-bus-clocks
+++ a/drivers/mfd/sm501.c
@@ -843,15 +843,15 @@ static void sm501_init_regs(struct sm501
 	sm501_init_reg(sm, SM501_GPIO31_0_CONTROL, &init->gpio_low);
 	sm501_init_reg(sm, SM501_GPIO63_32_CONTROL, &init->gpio_high);
 
-	if (init->mclk) {
-		dev_info(sm->dev, "setting MCLK to %ld\n", init->mclk);
-		sm501_set_clock(sm->dev, SM501_CLOCK_MCLK, init->mclk);
-	}
-
 	if (init->m1xclk) {
 		dev_info(sm->dev, "setting M1XCLK to %ld\n", init->m1xclk);
 		sm501_set_clock(sm->dev, SM501_CLOCK_M1XCLK, init->m1xclk);
 	}
+
+	if (init->mclk) {
+		dev_info(sm->dev, "setting MCLK to %ld\n", init->mclk);
+		sm501_set_clock(sm->dev, SM501_CLOCK_MCLK, init->mclk);
+	}
 }
 
 static unsigned int sm501_mem_local[] = {
_

Patches currently in -mm which might be from ben-linux@fluff.org are

git-watchdog.patch
spi-tle620x-power-switch-driver.patch
