From: akpm@linux-foundation.org
Subject: - i2c-at91-supports-new-style-i2c-drivers.patch removed from -mm tree
Date: Wed, 09 May 2007 14:55:11 -0700
Message-ID: <200705092155.l49LtBBb003245@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53085 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759343AbXEIVzn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:55:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     i2c-at91 supports new-style i2c drivers
has been removed from the -mm tree.  Its filename was
     i2c-at91-supports-new-style-i2c-drivers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i2c-at91 supports new-style i2c drivers
From: David Brownell <david-b@pacbell.net>

Make i2c-at91 register as i2c adapter zero (none of these chips seem to
have more than one TWI controllers) to let it kick in any board-specific
device declarations; also make it hotplug/coldplug.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/busses/i2c-at91.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/i2c/busses/i2c-at91.c~i2c-at91-supports-new-style-i2c-drivers drivers/i2c/busses/i2c-at91.c
--- a/drivers/i2c/busses/i2c-at91.c~i2c-at91-supports-new-style-i2c-drivers
+++ a/drivers/i2c/busses/i2c-at91.c
@@ -226,13 +226,14 @@ static int __devinit at91_i2c_probe(stru
 	adapter->algo = &at91_algorithm;
 	adapter->class = I2C_CLASS_HWMON;
 	adapter->dev.parent = &pdev->dev;
+	/* adapter->id == 0 ... only one TWI controller for now */
 
 	platform_set_drvdata(pdev, adapter);
 
 	clk_enable(twi_clk);		/* enable peripheral clock */
 	at91_twi_hwinit();		/* initialize TWI controller */
 
-	rc = i2c_add_adapter(adapter);
+	rc = i2c_add_numbered_adapter(adapter);
 	if (rc) {
 		dev_err(&pdev->dev, "Adapter %s registration failed\n",
 				adapter->name);
@@ -295,6 +296,9 @@ static int at91_i2c_resume(struct platfo
 #define at91_i2c_resume		NULL
 #endif
 
+/* work with "modprobe at91_i2c" from hotplugging or coldplugging */
+MODULE_ALIAS("at91_i2c");
+
 static struct platform_driver at91_i2c_driver = {
 	.probe		= at91_i2c_probe,
 	.remove		= __devexit_p(at91_i2c_remove),
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
acpi-driver-model-flags-and-platform_enable_wake.patch
update-documentation-driver-model-platformtxt.patch
leds-gpio-handles-timer-unsafe-gpios.patch
mpc52xx-psc-spi-master-driver-update.patch
mpc52xx-psc-spi-master-driver-update-tidy.patch
