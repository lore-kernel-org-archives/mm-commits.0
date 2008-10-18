From: akpm@linux-foundation.org
Subject: - rtc-ds1374-wakup-support.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:15:12 -0700
Message-ID: <200810182315.m9INFCD0028552@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50655 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751946AbYJRXPb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:15:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marc.pignat@hevs.ch, a.zummo@towertech.it, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     rtc: DS1374 wakeup support
has been removed from the -mm tree.  Its filename was
     rtc-ds1374-wakup-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: DS1374 wakeup support
From: Marc Pignat <marc.pignat@hevs.ch>

Wakeup support implementation.

Signed-off-by: Marc Pignat <marc.pignat@hevs.ch>
Cc: David Brownell <david-b@pacbell.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1374.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff -puN drivers/rtc/rtc-ds1374.c~rtc-ds1374-wakup-support drivers/rtc/rtc-ds1374.c
--- a/drivers/rtc/rtc-ds1374.c~rtc-ds1374-wakup-support
+++ a/drivers/rtc/rtc-ds1374.c
@@ -429,12 +429,33 @@ static int __devexit ds1374_remove(struc
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

