From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-m48t86c-use-dev_get_platdata.patch
 removed from -mm tree
Date: Wed, 13 Nov 2013 12:44:06 -0800
Message-ID: <5283e496.FW1BWAPil6BWG0WM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43083 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab3KMUoH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:44:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] drivers-rtc-rtc-m48t86c-use-dev_get_platdata.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:44:06 -0800


The patch titled
     Subject: drivers/rtc/rtc-m48t86.c: use dev_get_platdata()
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-m48t86c-use-dev_get_platdata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/rtc/rtc-m48t86.c: use dev_get_platdata()

Use the wrapper function for retrieving the platform data instead of
accessing dev->platform_data directly.  This is a cosmetic change to make
the code simpler and enhance the readability.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-m48t86.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-m48t86.c~drivers-rtc-rtc-m48t86c-use-dev_get_platdata drivers/rtc/rtc-m48t86.c
--- a/drivers/rtc/rtc-m48t86.c~drivers-rtc-rtc-m48t86c-use-dev_get_platdata
+++ a/drivers/rtc/rtc-m48t86.c
@@ -46,7 +46,7 @@ static int m48t86_rtc_read_time(struct d
 {
 	unsigned char reg;
 	struct platform_device *pdev = to_platform_device(dev);
-	struct m48t86_ops *ops = pdev->dev.platform_data;
+	struct m48t86_ops *ops = dev_get_platdata(&pdev->dev);
 
 	reg = ops->readbyte(M48T86_REG_B);
 
@@ -84,7 +84,7 @@ static int m48t86_rtc_set_time(struct de
 {
 	unsigned char reg;
 	struct platform_device *pdev = to_platform_device(dev);
-	struct m48t86_ops *ops = pdev->dev.platform_data;
+	struct m48t86_ops *ops = dev_get_platdata(&pdev->dev);
 
 	reg = ops->readbyte(M48T86_REG_B);
 
@@ -123,7 +123,7 @@ static int m48t86_rtc_proc(struct device
 {
 	unsigned char reg;
 	struct platform_device *pdev = to_platform_device(dev);
-	struct m48t86_ops *ops = pdev->dev.platform_data;
+	struct m48t86_ops *ops = dev_get_platdata(&pdev->dev);
 
 	reg = ops->readbyte(M48T86_REG_B);
 
@@ -147,7 +147,7 @@ static const struct rtc_class_ops m48t86
 static int m48t86_rtc_probe(struct platform_device *dev)
 {
 	unsigned char reg;
-	struct m48t86_ops *ops = dev->dev.platform_data;
+	struct m48t86_ops *ops = dev_get_platdata(&dev->dev);
 	struct rtc_device *rtc;
 
 	rtc = devm_rtc_device_register(&dev->dev, "m48t86",
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
drivers-block-sx8c-use-module_pci_driver.patch
drivers-block-sx8c-remove-unnecessary-pci_set_drvdata.patch
linux-next.patch
drivers-rtc-rtc-hid-sensor-timec-use-dev_get_platdata.patch
w1-w1-gpio-use-dev_get_platdata.patch

