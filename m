From: akpm@linux-foundation.org
Subject: + rtc-rtc-v3020-use-gpio_request_array.patch added to -mm tree
Date: Fri, 22 Feb 2013 14:18:34 -0800
Message-ID: <20130222221834.A4AFC31C229@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:58826 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756826Ab3BVWSf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 17:18:35 -0500
Received: by mail-yh0-f73.google.com with SMTP id 28so113553yhr.4
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 14:18:35 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, a.zummo@towertech.it, grinberg@compulab.co.il


The patch titled
     Subject: drivers/rtc/rtc-v3020.c: use gpio_request_array()
has been added to the -mm tree.  Its filename is
     rtc-rtc-v3020-use-gpio_request_array.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/rtc/rtc-v3020.c: use gpio_request_array()

Using gpio_request_array()/gpio_free_array() can make the code simpler
because it can set the direction and initial value in one shot and the for
loop is unnecessary.

Also, struct v3020_gpio is removed, because the struct v3020_gpio is
replaced with struct gpio.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Igor Grinberg <grinberg@compulab.co.il>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-v3020.c |   37 ++++++++++++-------------------------
 1 file changed, 12 insertions(+), 25 deletions(-)

diff -puN drivers/rtc/rtc-v3020.c~rtc-rtc-v3020-use-gpio_request_array drivers/rtc/rtc-v3020.c
--- a/drivers/rtc/rtc-v3020.c~rtc-rtc-v3020-use-gpio_request_array
+++ a/drivers/rtc/rtc-v3020.c
@@ -49,18 +49,13 @@ struct v3020_chip_ops {
 #define V3020_RD	2
 #define V3020_IO	3
 
-struct v3020_gpio {
-	const char *name;
-	unsigned int gpio;
-};
-
 struct v3020 {
 	/* MMIO access */
 	void __iomem *ioaddress;
 	int leftshift;
 
 	/* GPIO access */
-	struct v3020_gpio *gpio;
+	struct gpio *gpio;
 
 	struct v3020_chip_ops *ops;
 
@@ -107,48 +102,40 @@ static struct v3020_chip_ops v3020_mmio_
 	.write_bit	= v3020_mmio_write_bit,
 };
 
-static struct v3020_gpio v3020_gpio[] = {
-	{ "RTC CS", 0 },
-	{ "RTC WR", 0 },
-	{ "RTC RD", 0 },
-	{ "RTC IO", 0 },
+static struct gpio v3020_gpio[] = {
+	{ 0, GPIOF_OUT_INIT_HIGH, "RTC CS"},
+	{ 0, GPIOF_OUT_INIT_HIGH, "RTC WR"},
+	{ 0, GPIOF_OUT_INIT_HIGH, "RTC RD"},
+	{ 0, GPIOF_OUT_INIT_HIGH, "RTC IO"},
 };
 
 static int v3020_gpio_map(struct v3020 *chip, struct platform_device *pdev,
 			  struct v3020_platform_data *pdata)
 {
-	int i, err;
+	int err;
 
 	v3020_gpio[V3020_CS].gpio = pdata->gpio_cs;
 	v3020_gpio[V3020_WR].gpio = pdata->gpio_wr;
 	v3020_gpio[V3020_RD].gpio = pdata->gpio_rd;
 	v3020_gpio[V3020_IO].gpio = pdata->gpio_io;
 
-	for (i = 0; i < ARRAY_SIZE(v3020_gpio); i++) {
-		err = gpio_request(v3020_gpio[i].gpio, v3020_gpio[i].name);
-		if (err)
-			goto err_request;
-
-		gpio_direction_output(v3020_gpio[i].gpio, 1);
-	}
+	err = gpio_request_array(v3020_gpio, ARRAY_SIZE(v3020_gpio));
+	if (err)
+		goto err_request;
 
 	chip->gpio = v3020_gpio;
 
 	return 0;
 
 err_request:
-	while (--i >= 0)
-		gpio_free(v3020_gpio[i].gpio);
+	gpio_free_array(v3020_gpio, ARRAY_SIZE(v3020_gpio));
 
 	return err;
 }
 
 static void v3020_gpio_unmap(struct v3020 *chip)
 {
-	int i;
