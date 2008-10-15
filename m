From: akpm@linux-foundation.org
Subject: - rtc-ds1374-wakeup-support-update.patch removed from -mm tree
Date: Wed, 15 Oct 2008 16:50:51 -0700
Message-ID: <200810152350.m9FNoqAu023677@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33997 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752656AbYJOXvP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Oct 2008 19:51:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marc.pignat@hevs.ch, a.zummo@towertech.it, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     rtc: DS1374 wakeup support (update)
has been removed from the -mm tree.  Its filename was
     rtc-ds1374-wakeup-support-update.patch

This patch was dropped because it was folded into rtc-ds1374-wakup-support.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: DS1374 wakeup support (update)
From: Marc Pignat <marc.pignat@hevs.ch>

Changes since v1:
 * patch against 2.6.27-rc1
 * removed device_init_wakeup(...) calls, they should be handled in i2c-core.c

Signed-off-by: Marc Pignat <marc.pignat@hevs.ch>
Cc: David Brownell <david-b@pacbell.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1374.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-ds1374.c~rtc-ds1374-wakeup-support-update drivers/rtc/rtc-ds1374.c
--- a/drivers/rtc/rtc-ds1374.c~rtc-ds1374-wakeup-support-update
+++ a/drivers/rtc/rtc-ds1374.c
@@ -388,7 +388,6 @@ static int ds1374_probe(struct i2c_clien
 			dev_err(&client->dev, "unable to request IRQ\n");
 			goto out_free;
 		}
-		device_init_wakeup(&client->dev, 1);
 	}
 
 	ds1374->rtc = rtc_device_register(client->name, &client->dev,
@@ -402,10 +401,9 @@ static int ds1374_probe(struct i2c_clien
 	return 0;
 
 out_irq:
-	if (client->irq > 0) {
-		device_init_wakeup(&client->dev, 0);
+	if (client->irq > 0)
 		free_irq(client->irq, client);
-	}
+
 out_free:
 	i2c_set_clientdata(client, NULL);
 	kfree(ds1374);
@@ -421,7 +419,6 @@ static int __devexit ds1374_remove(struc
 		ds1374->exiting = 1;
 		mutex_unlock(&ds1374->mutex);
 
-		device_init_wakeup(&client->dev, 0);
 		free_irq(client->irq, client);
 		flush_scheduled_work();
 	}
_

Patches currently in -mm which might be from marc.pignat@hevs.ch are

rtc-ds1374-wakup-support.patch
rtc-ds1374-wakeup-support-update.patch

