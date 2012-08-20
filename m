From: akpm@linux-foundation.org
Subject: [merged] drivers-w1-masters-w1-gpioc-add-ext_pullup_enable-pin-in-platform-data.patch removed from -mm tree
Date: Mon, 20 Aug 2012 12:57:12 -0700
Message-ID: <20120820195713.255B0200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:57556 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326Ab2HTT5P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 15:57:15 -0400
Received: by faem1 with SMTP id m1so221166fae.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 12:57:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zonque@gmail.com, greg@kroah.com, syrjala@sci.fi, zbr@ioremap.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/w1/masters/w1-gpio.c: add ext_pullup_enable pin in platform data
has been removed from the -mm tree.  Its filename was
     drivers-w1-masters-w1-gpioc-add-ext_pullup_enable-pin-in-platform-data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Daniel Mack <zonque@gmail.com>
Subject: drivers/w1/masters/w1-gpio.c: add ext_pullup_enable pin in platform data

In the process of porting boards to devicetree implemenation, we should
keep information about external circuitry where they belong - the
individual drivers.

This patch adds a way to specify a GPIO to drive the (optional) external
pull-up logic, rather than using a function pointer for that.

Signed-off-by: Daniel Mack <zonque@gmail.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Ville Syrjala <syrjala@sci.fi>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/masters/w1-gpio.c |   18 +++++++++++++++++-
 include/linux/w1-gpio.h      |    1 +
 2 files changed, 18 insertions(+), 1 deletion(-)

diff -puN drivers/w1/masters/w1-gpio.c~drivers-w1-masters-w1-gpioc-add-ext_pullup_enable-pin-in-platform-data drivers/w1/masters/w1-gpio.c
--- a/drivers/w1/masters/w1-gpio.c~drivers-w1-masters-w1-gpioc-add-ext_pullup_enable-pin-in-platform-data
+++ a/drivers/w1/masters/w1-gpio.c
@@ -59,6 +59,13 @@ static int __init w1_gpio_probe(struct p
 	if (err)
 		goto free_master;
 
+	if (gpio_is_valid(pdata->ext_pullup_enable_pin)) {
+		err = gpio_request_one(pdata->ext_pullup_enable_pin,
+				       GPIOF_INIT_LOW, "w1 pullup");
+		if (err < 0)
+			goto free_gpio;
+	}
+
 	master->data = pdata;
 	master->read_bit = w1_gpio_read_bit;
 
@@ -72,15 +79,21 @@ static int __init w1_gpio_probe(struct p
 
 	err = w1_add_master_device(master);
 	if (err)
-		goto free_gpio;
+		goto free_gpio_ext_pu;
 
 	if (pdata->enable_external_pullup)
 		pdata->enable_external_pullup(1);
 
+	if (gpio_is_valid(pdata->ext_pullup_enable_pin))
+		gpio_set_value(pdata->ext_pullup_enable_pin, 1);
+
 	platform_set_drvdata(pdev, master);
 
 	return 0;
 
+ free_gpio_ext_pu:
+	if (gpio_is_valid(pdata->ext_pullup_enable_pin))
+		gpio_free(pdata->ext_pullup_enable_pin);
  free_gpio:
 	gpio_free(pdata->pin);
  free_master:
@@ -97,6 +110,9 @@ static int __exit w1_gpio_remove(struct 
 	if (pdata->enable_external_pullup)
 		pdata->enable_external_pullup(0);
 
+	if (gpio_is_valid(pdata->ext_pullup_enable_pin))
+		gpio_set_value(pdata->ext_pullup_enable_pin, 0);
+
 	w1_remove_master_device(master);
 	gpio_free(pdata->pin);
 	kfree(master);
diff -puN include/linux/w1-gpio.h~drivers-w1-masters-w1-gpioc-add-ext_pullup_enable-pin-in-platform-data include/linux/w1-gpio.h
--- a/include/linux/w1-gpio.h~drivers-w1-masters-w1-gpioc-add-ext_pullup_enable-pin-in-platform-data
+++ a/include/linux/w1-gpio.h
@@ -19,6 +19,7 @@ struct w1_gpio_platform_data {
 	unsigned int pin;
 	unsigned int is_open_drain:1;
 	void (*enable_external_pullup)(int enable);
+	unsigned int ext_pullup_enable_pin;
 };
 
 #endif /* _LINUX_W1_GPIO_H */
_

Patches currently in -mm which might be from zonque@gmail.com are

linux-next.patch
drivers-misc-lis3lv02d-add-generic-dt-matching-code.patch
drivers-misc-lis3lv02d-lis3lv02d_spic-add-dt-matching-table-passthru-code.patch

