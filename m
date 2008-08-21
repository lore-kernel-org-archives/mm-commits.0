From: akpm@linux-foundation.org
Subject: - rtc-rtc-ds1374-fix-no-irq-case-handling.patch removed from -mm tree
Date: Wed, 20 Aug 2008 20:49:56 -0700
Message-ID: <200808210349.m7L3nuHI015674@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41336 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750828AbYHUEbt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Aug 2008 00:31:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avorontsov@ru.mvista.com, a.zummo@towertech.it, david-b@pacbell.net, jacmet@sunsite.dk, mm-commits@vger.kernel.org


The patch titled
     rtc: rtc-ds1374: fix 'no irq' case handling
has been removed from the -mm tree.  Its filename was
     rtc-rtc-ds1374-fix-no-irq-case-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: rtc-ds1374: fix 'no irq' case handling
From: Anton Vorontsov <avorontsov@ru.mvista.com>

On a PowerPC board with ds1374 RTC I'm getting this error while RTC tries
to probe:

rtc-ds1374 0-0068: unable to request IRQ

This happens because I2C probing code (drivers/of/of_i2c.c) is specifying
IRQ0 for 'no irq' case, which is correct.

The driver handles this incorrectly, though. This patch fixes it.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Acked-by: Peter Korsgaard <jacmet@sunsite.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1374.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-ds1374.c~rtc-rtc-ds1374-fix-no-irq-case-handling drivers/rtc/rtc-ds1374.c
--- a/drivers/rtc/rtc-ds1374.c~rtc-rtc-ds1374-fix-no-irq-case-handling
+++ a/drivers/rtc/rtc-ds1374.c
@@ -173,7 +173,7 @@ static int ds1374_read_alarm(struct devi
 	int cr, sr;
 	int ret = 0;
 
-	if (client->irq < 0)
+	if (client->irq <= 0)
 		return -EINVAL;
 
 	mutex_lock(&ds1374->mutex);
@@ -212,7 +212,7 @@ static int ds1374_set_alarm(struct devic
 	int cr;
 	int ret = 0;
 
-	if (client->irq < 0)
+	if (client->irq <= 0)
 		return -EINVAL;
 
 	ret = ds1374_read_time(dev, &now);
@@ -381,7 +381,7 @@ static int ds1374_probe(struct i2c_clien
 	if (ret)
 		goto out_free;
 
-	if (client->irq >= 0) {
+	if (client->irq > 0) {
 		ret = request_irq(client->irq, ds1374_irq, 0,
 		                  "ds1374", client);
 		if (ret) {
@@ -401,7 +401,7 @@ static int ds1374_probe(struct i2c_clien
 	return 0;
 
 out_irq:
-	if (client->irq >= 0)
+	if (client->irq > 0)
 		free_irq(client->irq, client);
 
 out_free:
@@ -414,7 +414,7 @@ static int __devexit ds1374_remove(struc
 {
 	struct ds1374 *ds1374 = i2c_get_clientdata(client);
 
-	if (client->irq >= 0) {
+	if (client->irq > 0) {
 		mutex_lock(&ds1374->mutex);
 		ds1374->exiting = 1;
 		mutex_unlock(&ds1374->mutex);
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

rtc-bunch-of-drivers-fix-no-irq-case-handing.patch
mpc8xxx_wdt-fix-modular-build.patch

