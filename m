From: akpm@linux-foundation.org
Subject: + w1-w1-gpio-use-dev_get_platdata.patch added to -mm tree
Date: Fri, 13 Sep 2013 16:01:15 -0700
Message-ID: <5233993b.nnIMgfP2FZyfdFxk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39490 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990Ab3IMXBQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 19:01:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zbr@ioremap.net, greg@kroah.com, jg1.han@samsung.com

Subject: + w1-w1-gpio-use-dev_get_platdata.patch added to -mm tree
To: jg1.han@samsung.com,greg@kroah.com,zbr@ioremap.net
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 16:01:15 -0700


The patch titled
     Subject: drivers/w1/masters/w1-gpio.c: use dev_get_platdata()
has been added to the -mm tree.  Its filename is
     w1-w1-gpio-use-dev_get_platdata.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/w1-w1-gpio-use-dev_get_platdata.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/w1-w1-gpio-use-dev_get_platdata.patch

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
Subject: drivers/w1/masters/w1-gpio.c: use dev_get_platdata()

Use the wrapper function for retrieving the platform data instead of
accessing dev->platform_data directly.  This is a cosmetic change to make
the code simpler and enhance the readability.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/masters/w1-gpio.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/w1/masters/w1-gpio.c~w1-w1-gpio-use-dev_get_platdata drivers/w1/masters/w1-gpio.c
--- a/drivers/w1/masters/w1-gpio.c~w1-w1-gpio-use-dev_get_platdata
+++ a/drivers/w1/masters/w1-gpio.c
@@ -56,7 +56,7 @@ MODULE_DEVICE_TABLE(of, w1_gpio_dt_ids);
 
 static int w1_gpio_probe_dt(struct platform_device *pdev)
 {
-	struct w1_gpio_platform_data *pdata = pdev->dev.platform_data;
+	struct w1_gpio_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	struct device_node *np = pdev->dev.of_node;
 
 	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
@@ -87,7 +87,7 @@ static int w1_gpio_probe(struct platform
 		}
 	}
 
-	pdata = pdev->dev.platform_data;
+	pdata = dev_get_platdata(&pdev->dev);
 
 	if (!pdata) {
 		dev_err(&pdev->dev, "No configuration data\n");
@@ -157,7 +157,7 @@ static int w1_gpio_probe(struct platform
 static int w1_gpio_remove(struct platform_device *pdev)
 {
 	struct w1_bus_master *master = platform_get_drvdata(pdev);
-	struct w1_gpio_platform_data *pdata = pdev->dev.platform_data;
+	struct w1_gpio_platform_data *pdata = dev_get_platdata(&pdev->dev);
 
 	if (pdata->enable_external_pullup)
 		pdata->enable_external_pullup(0);
@@ -176,7 +176,7 @@ static int w1_gpio_remove(struct platfor
 
 static int w1_gpio_suspend(struct platform_device *pdev, pm_message_t state)
 {
-	struct w1_gpio_platform_data *pdata = pdev->dev.platform_data;
+	struct w1_gpio_platform_data *pdata = dev_get_platdata(&pdev->dev);
 
 	if (pdata->enable_external_pullup)
 		pdata->enable_external_pullup(0);
@@ -186,7 +186,7 @@ static int w1_gpio_suspend(struct platfo
 
 static int w1_gpio_resume(struct platform_device *pdev)
 {
-	struct w1_gpio_platform_data *pdata = pdev->dev.platform_data;
+	struct w1_gpio_platform_data *pdata = dev_get_platdata(&pdev->dev);
 
 	if (pdata->enable_external_pullup)
 		pdata->enable_external_pullup(1);
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
w1-w1-gpio-use-dev_get_platdata.patch
w1-ds1wm-use-dev_get_platdata.patch

