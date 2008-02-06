From: akpm@linux-foundation.org
Subject: - w1-gpio-add-gpio-w1-bus-master-driver-v3.patch removed from -mm tree
Date: Tue, 05 Feb 2008 23:30:44 -0800
Message-ID: <200802060730.m167UQx6031828@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34498 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753334AbYBFHgP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 02:36:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: syrjala@sci.fi, david-b@pacbell.net, johnpol@2ka.mipt.ru, mm-commits@vger.kernel.org


The patch titled
     w1-gpio: add GPIO w1 bus master driver
has been removed from the -mm tree.  Its filename was
     w1-gpio-add-gpio-w1-bus-master-driver-v3.patch

This patch was dropped because it was folded into w1-gpio-add-gpio-w1-bus-master-driver.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: w1-gpio: add GPIO w1 bus master driver
From: Ville Syrjala <syrjala@sci.fi>

Changes from version 2 to version 3:
* Use platform_driver_probe() instead of platform_driver_register().
* Remove useless address operators from function pointer assignments.

Signed-off-by: Ville Syrjala <syrjala@sci.fi>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/masters/w1-gpio.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN drivers/w1/masters/w1-gpio.c~w1-gpio-add-gpio-w1-bus-master-driver-v3 drivers/w1/masters/w1-gpio.c
--- a/drivers/w1/masters/w1-gpio.c~w1-gpio-add-gpio-w1-bus-master-driver-v3
+++ a/drivers/w1/masters/w1-gpio.c
@@ -60,14 +60,14 @@ static int __init w1_gpio_probe(struct p
 		goto free_master;
 
 	master->data = pdata;
-	master->read_bit = &w1_gpio_read_bit;
+	master->read_bit = w1_gpio_read_bit;
 
 	if (pdata->is_open_drain) {
 		gpio_direction_output(pdata->pin, 1);
-		master->write_bit = &w1_gpio_write_bit_val;
+		master->write_bit = w1_gpio_write_bit_val;
 	} else {
 		gpio_direction_input(pdata->pin);
-		master->write_bit = &w1_gpio_write_bit_dir;
+		master->write_bit = w1_gpio_write_bit_dir;
 	}
 
 	err = w1_add_master_device(master);
@@ -103,13 +103,12 @@ static struct platform_driver w1_gpio_dr
 		.name	= "w1-gpio",
 		.owner	= THIS_MODULE,
 	},
-	.probe	= w1_gpio_probe,
 	.remove	= __exit_p(w1_gpio_remove),
 };
 
 static int __init w1_gpio_init(void)
 {
-	return platform_driver_register(&w1_gpio_driver);
+	return platform_driver_probe(&w1_gpio_driver, w1_gpio_probe);
 }
 
 static void __exit w1_gpio_exit(void)
_

Patches currently in -mm which might be from syrjala@sci.fi are

origin.patch
w1-gpio-add-gpio-w1-bus-master-driver.patch
w1-gpio-add-gpio-w1-bus-master-driver-v3.patch
