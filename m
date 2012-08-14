From: akpm@linux-foundation.org
Subject: + drivers-w1-masters-w1-gpioc-add-dt-bindings.patch added to -mm tree
Date: Tue, 14 Aug 2012 16:20:28 -0700
Message-ID: <20120814232029.8743720004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:56676 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab2HNXUc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Aug 2012 19:20:32 -0400
Received: by bkcjc3 with SMTP id jc3so45645bkc.1
        for <mm-commits@vger.kernel.org>; Tue, 14 Aug 2012 16:20:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zonque@gmail.com, greg@kroah.com, syrjala@sci.fi, zbr@ioremap.net


The patch titled
     Subject: drivers/w1/masters/w1-gpio.c: add DT bindings
has been added to the -mm tree.  Its filename is
     drivers-w1-masters-w1-gpioc-add-dt-bindings.patch

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
Subject: drivers/w1/masters/w1-gpio.c: add DT bindings

Add DT bindings to the w1-gpio driver, along with some documentation on
how to use them.

Signed-off-by: Daniel Mack <zonque@gmail.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Ville Syrjala <syrjala@sci.fi>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/w1/w1-gpio.txt |   22 ++++++
 drivers/w1/masters/w1-gpio.c                     |   46 +++++++++++++
 2 files changed, 68 insertions(+)

diff -puN /dev/null Documentation/devicetree/bindings/w1/w1-gpio.txt
--- /dev/null
+++ a/Documentation/devicetree/bindings/w1/w1-gpio.txt
@@ -0,0 +1,22 @@
+w1-gpio devicetree bindings
+
+Required properties:
+
+ - compatible: "w1-gpio"
+ - gpios: one or two GPIO specs:
+		- the first one is used as data I/O pin
+		- the second one is optional. If specified, it is used as
+		  enable pin for an external pin pullup.
+
+Optional properties:
+
+ - linux,open-drain: if specified, the data pin is considered in
+		     open-drain mode.
+
+Examples:
+
+	onewire@0 {
+		compatible = "w1-gpio";
+		gpios = <&gpio 126 0>, <&gpio 105 0>;
+	};
+
diff -puN drivers/w1/masters/w1-gpio.c~drivers-w1-masters-w1-gpioc-add-dt-bindings drivers/w1/masters/w1-gpio.c
--- a/drivers/w1/masters/w1-gpio.c~drivers-w1-masters-w1-gpioc-add-dt-bindings
+++ a/drivers/w1/masters/w1-gpio.c
@@ -14,6 +14,8 @@
 #include <linux/slab.h>
 #include <linux/w1-gpio.h>
 #include <linux/gpio.h>
+#include <linux/of_platform.h>
+#include <linux/of_gpio.h>
 
 #include "../w1.h"
 #include "../w1_int.h"
@@ -42,12 +44,55 @@ static u8 w1_gpio_read_bit(void *data)
 	return gpio_get_value(pdata->pin) ? 1 : 0;
 }
 
+#ifdef CONFIG_OF
+static struct of_device_id w1_gpio_dt_ids[] = {
+	{ .compatible = "w1-gpio" },
+	{}
+};
+MODULE_DEVICE_TABLE(of, w1_gpio_dt_ids);
+
+static int w1_gpio_probe_dt(struct platform_device *pdev)
+{
+	struct w1_gpio_platform_data *pdata = pdev->dev.platform_data;
+	struct device_node *np = pdev->dev.of_node;
+	const struct of_device_id *of_id =
+			of_match_device(w1_gpio_dt_ids, &pdev->dev);
+
+	if (!of_id)
+		return 0;
+
+	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		return -ENOMEM;
+
+	if (of_get_property(np, "linux,open-drain", NULL))
+		pdata->is_open_drain = 1;
+
+	pdata->pin = of_get_gpio(np, 0);
+	pdata->ext_pullup_enable_pin = of_get_gpio(np, 1);
+	pdev->dev.platform_data = pdata;
+
+	return 0;
+}
+#else
+static int w1_gpio_probe_dt(struct platform_device *pdev)
+{
+	return 0;
+}
+#endif
+
 static int __init w1_gpio_probe(struct platform_device *pdev)
 {
 	struct w1_bus_master *master;
 	struct w1_gpio_platform_data *pdata = pdev->dev.platform_data;
 	int err;
 
+	err = w1_gpio_probe_dt(pdev);
+	if (err < 0)
+		return err;
+
+	pdata = pdev->dev.platform_data;
+
 	if (!pdata)
 		return -ENXIO;
 
@@ -151,6 +196,7 @@ static struct platform_driver w1_gpio_dr
 	.driver = {
 		.name	= "w1-gpio",
 		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(w1_gpio_dt_ids),
 	},
 	.remove	= __exit_p(w1_gpio_remove),
 	.suspend = w1_gpio_suspend,
_

Patches currently in -mm which might be from zonque@gmail.com are

origin.patch
linux-next.patch
drivers-w1-masters-w1-gpioc-add-ext_pullup_enable-pin-in-platform-data.patch
drivers-w1-masters-w1-gpioc-add-dt-bindings.patch

