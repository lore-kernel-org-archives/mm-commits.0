From: akpm@linux-foundation.org
Subject: [folded] rtc-add-stand-alone-driver-for-rx8025-chip-fix.patch removed from -mm tree
Date: Wed, 17 Jun 2009 15:44:33 -0700
Message-ID: <200906172244.n5HMiXgs004914@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37109 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762620AbZFQWpm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 18:45:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wg@grandegger.com, a.zummo@towertech.it, david-b@pacbell.net, khali@linux-fr.org, matthias.fuchs@esd.eu, rda@emcraft.com, sposelenov@emcraft.com, yur@emcraft.com, mm-commits@vger.kernel.org


The patch titled
     rtc-add-stand-alone-driver-for-rx8025-chip-fix
has been removed from the -mm tree.  Its filename was
     rtc-add-stand-alone-driver-for-rx8025-chip-fix.patch

This patch was dropped because it was folded into rtc-add-stand-alone-driver-for-rx8025-chip.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-add-stand-alone-driver-for-rx8025-chip-fix
From: Wolfgang Grandegger <wg@grandegger.com>

Signed-off-by: Wolfgang Grandegger <wg@grandegger.com>
Cc: Sergei Poselenov <sposelenov@emcraft.com>
Cc: Yuri Tikhonov <yur@emcraft.com>
Cc: Dmitry Rakhchev <rda@emcraft.com>
Cc: Matthias Fuchs <matthias.fuchs@esd.eu>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-rx8025.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/rtc/rtc-rx8025.c~rtc-add-stand-alone-driver-for-rx8025-chip-fix drivers/rtc/rtc-rx8025.c
--- a/drivers/rtc/rtc-rx8025.c~rtc-add-stand-alone-driver-for-rx8025-chip-fix
+++ a/drivers/rtc/rtc-rx8025.c
@@ -6,7 +6,7 @@
  * Copyright (C) 2005 by Digi International Inc.
  * All rights reserved.
  *
- * Modify by fengjh at rising.com.cn
+ * Modified by fengjh at rising.com.cn
  * <http://lists.lm-sensors.org/mailman/listinfo/lm-sensors>
  * 2006.11
  *
@@ -321,7 +321,7 @@ static int rx8025_read_alarm(struct devi
 	u8 ctrl2, ald[2];
 	int err;
 
-	if (client->irq == NO_IRQ)
+	if (client->irq <= 0)
 		return -EINVAL;
 
 	err = rx8025_read_regs(client, RX8025_REG_ALDMIN, 2, ald);
@@ -366,7 +366,7 @@ static int rx8025_set_alarm(struct devic
 	u8 ald[2];
 	int err;
 
-	if (client->irq == NO_IRQ)
+	if (client->irq <= 0)
 		return -EINVAL;
 
 	/* Hardware alarm precision is 1 minute! */
@@ -430,7 +430,7 @@ static int rx8025_irq_set_state(struct d
 	int ctrl1;
 	int err;
 
-	if (client->irq == NO_IRQ)
+	if (client->irq <= 0)
 		return -ENXIO;
 
 	ctrl1 = rx8025->ctrl1 & ~RX8025_BIT_CTRL1_CT;
@@ -604,7 +604,7 @@ static int __devinit rx8025_probe(struct
 		goto errout_free;
 	}
 
-	if (client->irq != NO_IRQ) {
+	if (client->irq > 0) {
 		dev_info(&client->dev, "IRQ %d supplied\n", client->irq);
 		err = request_irq(client->irq, rx8025_irq,
 				  0, "rx8025", client);
@@ -624,7 +624,7 @@ static int __devinit rx8025_probe(struct
 	return 0;
 
 errout_irq:
-	if (client->irq != NO_IRQ)
+	if (client->irq > 0)
 		free_irq(client->irq, client);
 
 errout_reg:
@@ -644,7 +644,7 @@ static int __devexit rx8025_remove(struc
 	struct rx8025_data *rx8025 = i2c_get_clientdata(client);
 	struct mutex *lock = &rx8025->rtc->ops_lock;
 
-	if (client->irq != NO_IRQ) {
+	if (client->irq > 0) {
 		mutex_lock(lock);
 		rx8025->exiting = 1;
 		mutex_unlock(lock);
_

Patches currently in -mm which might be from wg@grandegger.com are

origin.patch
rtc-add-stand-alone-driver-for-rx8025-chip.patch
rtc-add-stand-alone-driver-for-rx8025-chip-fix.patch

