From: akpm@linux-foundation.org
Subject: + drivers-w1-masters-w1-gpioc-add-ext_pullup_enable-pin-in-platform-data.patch added to -mm tree
Date: Tue, 14 Aug 2012 16:20:24 -0700
Message-ID: <20120814232025.932D55C0065@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:65213 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab2HNXU1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Aug 2012 19:20:27 -0400
Received: by eaac1 with SMTP id c1so45752eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 14 Aug 2012 16:20:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zonque@gmail.com, greg@kroah.com, syrjala@sci.fi, zbr@ioremap.net


The patch titled
     Subject: drivers/w1/masters/w1-gpio.c: add ext_pullup_enable pin in platform data
has been added to the -mm tree.  Its filename is
     drivers-w1-masters-w1-gpioc-add-ext_pullup_enable-pin-in-platform-data.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

origin.patch
linux-next.patch
drivers-w1-masters-w1-gpioc-add-ext_pullup_enable-pin-in-platform-data.patch
drivers-w1-masters-w1-gpioc-add-dt-bindings.patch

