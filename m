From: akpm@linux-foundation.org
Subject: [merged] drivers-leds-leds-pca9532c-change-driver-name-to-be-unique.patch removed from -mm tree
Date: Mon, 11 Jul 2011 11:43:09 -0700
Message-ID: <201107111842.p6BIgega025519@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38426 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754535Ab1GKTmY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jul 2011 15:42:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: w.sang@pengutronix.de, khali@linux-fr.org, richard.purdie@linuxfoundation.org, mm-commits@vger.kernel.org


The patch titled
     drivers/leds/leds-pca9532.c: change driver name to be unique
has been removed from the -mm tree.  Its filename was
     drivers-leds-leds-pca9532c-change-driver-name-to-be-unique.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/leds/leds-pca9532.c: change driver name to be unique
From: Wolfram Sang <w.sang@pengutronix.de>

This driver handles the variants pca9530-pca9533, so it chose the name
"pca953x".  However, there is a gpio driver which decided on the same
name.  As a result, those two can't be loaded at the same time.  Add a
subsystem prefix to make the driver name unique.  Device matching will not
suffer, because both are I2C drivers which match using a
i2c_device_id-table which is not altered.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Acked-by: Jean Delvare <khali@linux-fr.org>
Cc: Richard Purdie <richard.purdie@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-pca9532.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/leds/leds-pca9532.c~drivers-leds-leds-pca9532c-change-driver-name-to-be-unique drivers/leds/leds-pca9532.c
--- a/drivers/leds/leds-pca9532.c~drivers-leds-leds-pca9532c-change-driver-name-to-be-unique
+++ a/drivers/leds/leds-pca9532.c
@@ -88,7 +88,7 @@ static const struct pca9532_chip_info pc
 
 static struct i2c_driver pca9532_driver = {
 	.driver = {
-		.name = "pca953x",
+		.name = "leds-pca953x",
 	},
 	.probe = pca9532_probe,
 	.remove = pca9532_remove,
_

Patches currently in -mm which might be from w.sang@pengutronix.de are

origin.patch
linux-next.patch

