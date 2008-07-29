From: akpm@linux-foundation.org
Subject: + rtc-ds1374-wakup-support.patch added to -mm tree
Date: Mon, 28 Jul 2008 20:59:55 -0700
Message-ID: <200807290359.m6T3xtqf013026@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51859 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750743AbYG2EAv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 00:00:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marc.pignat@hevs.ch, a.zummo@towertech.it, david-b@pacbell.net


The patch titled
     rtc: DS1374 wakup support
has been added to the -mm tree.  Its filename is
     rtc-ds1374-wakup-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: DS1374 wakup support
From: Marc Pignat <marc.pignat@hevs.ch>

Wakeup support implementation.

Signed-off-by: Marc Pignat <marc.pignat@hevs.ch>
Cc: David Brownell <david-b@pacbell.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1374.c |   27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-ds1374.c~rtc-ds1374-wakup-support drivers/rtc/rtc-ds1374.c
--- a/drivers/rtc/rtc-ds1374.c~rtc-ds1374-wakup-support
+++ a/drivers/rtc/rtc-ds1374.c
@@ -388,6 +388,7 @@ static int ds1374_probe(struct i2c_clien
 			dev_err(&client->dev, "unable to request IRQ\n");
 			goto out_free;
 		}
+		device_init_wakeup(&client->dev, 1);
 	}
 
 	ds1374->rtc = rtc_device_register(client->name, &client->dev,
@@ -401,8 +402,10 @@ static int ds1374_probe(struct i2c_clien
 	return 0;
 
 out_irq:
-	if (client->irq >= 0)
+	if (client->irq >= 0) {
+		device_init_wakeup(&client->dev, 0);
 		free_irq(client->irq, client);
+	}
 
 out_free:
 	i2c_set_clientdata(client, NULL);
@@ -419,6 +422,7 @@ static int __devexit ds1374_remove(struc
 		ds1374->exiting = 1;
 		mutex_unlock(&ds1374->mutex);
 
+		device_init_wakeup(&client->dev, 0);
 		free_irq(client->irq, client);
 		flush_scheduled_work();
 	}
@@ -429,12 +433,33 @@ static int __devexit ds1374_remove(struc
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int ds1374_suspend(struct i2c_client *client, pm_message_t state)
+{
+	if (client->irq >= 0 && device_may_wakeup(&client->dev))
+		enable_irq_wake(client->irq);
+	return 0;
+}
+
+static int ds1374_resume(struct i2c_client *client)
+{
+	if (client->irq >= 0 && device_may_wakeup(&client->dev))
+		disable_irq_wake(client->irq);
+	return 0;
+}
+#else
+#define ds1374_suspend	NULL
+#define ds1374_resume	NULL
+#endif
+
 static struct i2c_driver ds1374_driver = {
 	.driver = {
 		.name = "rtc-ds1374",
 		.owner = THIS_MODULE,
 	},
 	.probe = ds1374_probe,
+	.suspend = ds1374_suspend,
+	.resume = ds1374_resume,
 	.remove = __devexit_p(ds1374_remove),
 	.id_table = ds1374_id,
 };
_

Patches currently in -mm which might be from marc.pignat@hevs.ch are

origin.patch
rtc-ds1374-wakup-support.patch

