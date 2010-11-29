From: akpm@linux-foundation.org
Subject: [merged] drivers-leds-leds-lp5521c-perform-sw-reset-before-detection.patch removed from -mm tree
Date: Mon, 29 Nov 2010 11:51:09 -0800
Message-ID: <201011291951.oATJpcdn007304@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35229 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752944Ab0K2Tvv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Nov 2010 14:51:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: samu.p.onkalo@nokia.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     drivers/leds/leds-lp5521.c: perform SW reset before detection
has been removed from the -mm tree.  Its filename was
     drivers-leds-leds-lp5521c-perform-sw-reset-before-detection.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/leds/leds-lp5521.c: perform SW reset before detection
From: Samu Onkalo <samu.p.onkalo@nokia.com>

Chip detection may fail if the chip is in some odd state for example after
system restart.  Chip doesn't have HW reset line.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-lp5521.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff -puN drivers/leds/leds-lp5521.c~drivers-leds-leds-lp5521c-perform-sw-reset-before-detection drivers/leds/leds-lp5521.c
--- a/drivers/leds/leds-lp5521.c~drivers-leds-leds-lp5521c-perform-sw-reset-before-detection
+++ a/drivers/leds/leds-lp5521.c
@@ -245,13 +245,6 @@ static int lp5521_configure(struct i2c_c
 
 	lp5521_init_engine(chip, attr_group);
 
-	lp5521_write(client, LP5521_REG_RESET, 0xff);
-
-	usleep_range(10000, 20000); /*
-				     * Exact value is not available. 10 - 20ms
-				     * appears to be enough for reset.
-				     */
