From: akpm@linux-foundation.org
Subject: [merged] memstick-r592-make-r592_pm_ops-static.patch removed from -mm tree
Date: Tue, 07 May 2013 10:50:27 -0700
Message-ID: <20130507175027.77A545A4525@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:55551 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab3EGRu2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:50:28 -0400
Received: by mail-ve0-f202.google.com with SMTP id 15so86244vea.5
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:50:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, maximlevitsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/memstick/host/r592.c: make r592_pm_ops static
has been removed from the -mm tree.  Its filename was
     memstick-r592-make-r592_pm_ops-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/memstick/host/r592.c: make r592_pm_ops static

r592_pm_ops is not exported. Also, CONFIG_PM_SLEEP is used to
remove unnecessary ifdefs.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/host/r592.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/memstick/host/r592.c~memstick-r592-make-r592_pm_ops-static drivers/memstick/host/r592.c
--- a/drivers/memstick/host/r592.c~memstick-r592-make-r592_pm_ops-static
+++ a/drivers/memstick/host/r592.c
@@ -847,7 +847,7 @@ static void r592_remove(struct pci_dev *
 			dev->dummy_dma_page_physical_address);
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int r592_suspend(struct device *core_dev)
 {
 	struct pci_dev *pdev = to_pci_dev(core_dev);
@@ -870,10 +870,10 @@ static int r592_resume(struct device *co
 	r592_update_card_detect(dev);
 	return 0;
 }
-
-SIMPLE_DEV_PM_OPS(r592_pm_ops, r592_suspend, r592_resume);
 #endif
 
+static SIMPLE_DEV_PM_OPS(r592_pm_ops, r592_suspend, r592_resume);
+
 MODULE_DEVICE_TABLE(pci, r592_pci_id_tbl);
 
 static struct pci_driver r852_pci_driver = {
@@ -881,9 +881,7 @@ static struct pci_driver r852_pci_driver
 	.id_table	= r592_pci_id_tbl,
 	.probe		= r592_probe,
 	.remove		= r592_remove,
-#ifdef CONFIG_PM
 	.driver.pm	= &r592_pm_ops,
-#endif
 };
 
 static __init int r592_module_init(void)
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch

