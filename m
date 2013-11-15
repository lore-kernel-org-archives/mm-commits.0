From: akpm@linux-foundation.org
Subject: [merged] w1-w1-gpio-use-dev_get_platdata.patch removed from -mm
 tree
Date: Fri, 15 Nov 2013 12:09:11 -0800
Message-ID: <52867f67.9cBHZLTW+akc7g61%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35789 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274Ab3KOUJL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 15:09:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zbr@ioremap.net, greg@kroah.com, jg1.han@samsung.com

Subject: [merged] w1-w1-gpio-use-dev_get_platdata.patch removed from -mm tree
To: jg1.han@samsung.com,greg@kroah.com,zbr@ioremap.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 12:09:11 -0800


The patch titled
     Subject: drivers/w1/masters/w1-gpio.c: use dev_get_platdata()
has been removed from the -mm tree.  Its filename was
     w1-w1-gpio-use-dev_get_platdata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/w1/masters/w1-gpio.c: use dev_get_platdata()

Use the wrapper function for retrieving the platform data instead of
accessing dev->platform_data directly.  This is a cosmetic change to make
the code simpler and enhance the readability.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
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
 	int gpio;
 
@@ -92,7 +92,7 @@ static int w1_gpio_probe(struct platform
 		}
 	}
 
-	pdata = pdev->dev.platform_data;
+	pdata = dev_get_platdata(&pdev->dev);
 
 	if (!pdata) {
 		dev_err(&pdev->dev, "No configuration data\n");
@@ -154,7 +154,7 @@ static int w1_gpio_probe(struct platform
 static int w1_gpio_remove(struct platform_device *pdev)
 {
 	struct w1_bus_master *master = platform_get_drvdata(pdev);
-	struct w1_gpio_platform_data *pdata = pdev->dev.platform_data;
+	struct w1_gpio_platform_data *pdata = dev_get_platdata(&pdev->dev);
 
 	if (pdata->enable_external_pullup)
 		pdata->enable_external_pullup(0);
@@ -171,7 +171,7 @@ static int w1_gpio_remove(struct platfor
 
 static int w1_gpio_suspend(struct platform_device *pdev, pm_message_t state)
 {
-	struct w1_gpio_platform_data *pdata = pdev->dev.platform_data;
+	struct w1_gpio_platform_data *pdata = dev_get_platdata(&pdev->dev);
 
 	if (pdata->enable_external_pullup)
 		pdata->enable_external_pullup(0);
@@ -181,7 +181,7 @@ static int w1_gpio_suspend(struct platfo
 
 static int w1_gpio_resume(struct platform_device *pdev)
 {
-	struct w1_gpio_platform_data *pdata = pdev->dev.platform_data;
+	struct w1_gpio_platform_data *pdata = dev_get_platdata(&pdev->dev);
 
 	if (pdata->enable_external_pullup)
 		pdata->enable_external_pullup(1);
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
drivers-block-sx8c-use-module_pci_driver.patch
drivers-block-sx8c-remove-unnecessary-pci_set_drvdata.patch
linux-next.patch

