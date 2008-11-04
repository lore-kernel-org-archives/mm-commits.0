From: akpm@linux-foundation.org
Subject: + input-ad7879-touchscreen-driver-cleanup.patch added to -mm tree
Date: Mon, 03 Nov 2008 18:13:04 -0800
Message-ID: <200811040213.mA42D43i007432@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33774 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752353AbYKDCNp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Nov 2008 21:13:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael.hennerich@analog.com, cooloney@kernel.org, dtor@mail.ru


The patch titled
     input: AD7879 Touchscreen driver cleanup
has been added to the -mm tree.  Its filename is
     input-ad7879-touchscreen-driver-cleanup.patch

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

input-touchscreen-driver-add-support-ad7877-touchscreen-driver.patch
input-touchscreen-driver-add-support-ad7877-touchscreen-driver-fix.patch
input-ad7879-touchscreen-driver.patch
input-ad7879-touchscreen-driver-cleanup.patch

