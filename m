From: akpm@linux-foundation.org
Subject: - input-ad7879-touchscreen-driver-cleanup.patch removed from -mm tree
Date: Mon, 01 Dec 2008 14:19:09 -0800
Message-ID: <200812012219.mB1MJArF011917@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41759 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751874AbYLAWUV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Dec 2008 17:20:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael.hennerich@analog.com, cooloney@kernel.org, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     input: AD7879 Touchscreen driver cleanup
has been removed from the -mm tree.  Its filename was
     input-ad7879-touchscreen-driver-cleanup.patch

This patch was dropped because it was folded into input-ad7879-touchscreen-driver.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: input: AD7879 Touchscreen driver cleanup
From: Michael Hennerich <michael.hennerich@analog.com>

 - Rename ad7879_destruct() to ad7879_destroy()
 - Test flag with spinlock hold

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/ad7879.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff -puN drivers/input/touchscreen/ad7879.c~input-ad7879-touchscreen-driver-cleanup drivers/input/touchscreen/ad7879.c
--- a/drivers/input/touchscreen/ad7879.c~input-ad7879-touchscreen-driver-cleanup
+++ a/drivers/input/touchscreen/ad7879.c
@@ -242,10 +242,12 @@ static void ad7879_disable(struct ad7879
 {
 	unsigned long flags;
 
-	if (ts->disabled)
+	spin_lock_irqsave(&ts->lock, flags);
+	if (ts->disabled) {
+		spin_unlock_irqrestore(&ts->lock, flags);
 		return;
+	}
 
-	spin_lock_irqsave(&ts->lock, flags);
 	ts->disabled = 1;
 	disable_irq(ts->bus->irq);
 	spin_unlock_irqrestore(&ts->lock, flags);
@@ -264,10 +266,11 @@ static void ad7879_enable(struct ad7879 
 {
 	unsigned long flags;
 
-	if (!ts->disabled)
-		return;
-
 	spin_lock_irqsave(&ts->lock, flags);
+	if (ts->disabled) {
+		spin_unlock_irqrestore(&ts->lock, flags);
+		return;
+	}
 	ts->disabled = 0;
 	enable_irq(ts->bus->irq);
 	spin_unlock_irqrestore(&ts->lock, flags);
@@ -485,7 +488,7 @@ err_free_mem:
 	return err;
 }
 
-static int __devexit ad7879_destruct(bus_device *bus, struct ad7879 *ts)
+static int __devexit ad7879_destroy(bus_device *bus, struct ad7879 *ts)
 {
 	ad7879_disable(ts);
 	ad7879_write(ts->bus, AD7879_REG_CTRL2,
@@ -667,7 +670,7 @@ static int __devexit ad7879_remove(struc
 {
 	struct ad7879 *ts = dev_get_drvdata(&spi->dev);
 
-	ad7879_destruct(spi, ts);
+	ad7879_destroy(spi, ts);
 	dev_set_drvdata(&spi->dev, NULL);
 	kfree(ts);
 	return 0;
@@ -753,7 +756,7 @@ static int __devexit ad7879_remove(struc
 {
 	struct ad7879 *ts = dev_get_drvdata(&client->dev);
 
-	ad7879_destruct(client, ts);
+	ad7879_destroy(client, ts);
 	i2c_set_clientdata(client, NULL);
 	kfree(ts);
 	return 0;
_

Patches currently in -mm which might be from michael.hennerich@analog.com are

linux-next.patch
input-touchscreen-driver-add-support-ad7877-touchscreen-driver.patch
input-ad7879-touchscreen-driver.patch
input-ad7879-touchscreen-driver-cleanup.patch
input-ad7879-fix-workaroud-build-error-reported-by-andrew-morton.patch
pcmcia-blackfin-fix-bug-add-missing-to-module-macro.patch

