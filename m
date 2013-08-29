From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-ds1742c-use-devm_ioremap_resource.patch added
 to -mm tree
Date: Thu, 29 Aug 2013 15:03:31 -0700
Message-ID: <521fc533.sdwvMbZHCYOz46Tq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37491 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675Ab3H2WDc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Aug 2013 18:03:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com, shc_work@mail.ru

Subject: + drivers-rtc-rtc-ds1742c-use-devm_ioremap_resource.patch added to -mm tree
To: shc_work@mail.ru,jg1.han@samsung.com
From: akpm@linux-foundation.org
Date: Thu, 29 Aug 2013 15:03:31 -0700


The patch titled
     Subject: drivers/rtc/rtc-ds1742.c: use devm_ioremap_resource()
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-ds1742c-use-devm_ioremap_resource.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-ds1742c-use-devm_ioremap_resource.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-ds1742c-use-devm_ioremap_resource.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Shiyan <shc_work@mail.ru>
Subject: drivers/rtc/rtc-ds1742.c: use devm_ioremap_resource()

Replace devm_request_mem_region() and devm_ioremap() with
devm_ioremap_resource().

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1742.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff -puN drivers/rtc/rtc-ds1742.c~drivers-rtc-rtc-ds1742c-use-devm_ioremap_resource drivers/rtc/rtc-ds1742.c
--- a/drivers/rtc/rtc-ds1742.c~drivers-rtc-rtc-ds1742c-use-devm_ioremap_resource
+++ a/drivers/rtc/rtc-ds1742.c
@@ -56,7 +56,6 @@ struct rtc_plat_data {
 	void __iomem *ioaddr_nvram;
 	void __iomem *ioaddr_rtc;
 	size_t size_nvram;
-	size_t size;
 	unsigned long last_jiffies;
 	struct bin_attribute nvram_attr;
 };
@@ -168,22 +167,17 @@ static int ds1742_rtc_probe(struct platf
 	void __iomem *ioaddr;
 	int ret = 0;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENODEV;
 	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
 		return -ENOMEM;
-	pdata->size = resource_size(res);
-	if (!devm_request_mem_region(&pdev->dev, res->start, pdata->size,
-		pdev->name))
-		return -EBUSY;
-	ioaddr = devm_ioremap(&pdev->dev, res->start, pdata->size);
-	if (!ioaddr)
-		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	ioaddr = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(ioaddr))
+		return PTR_ERR(ioaddr);
 
 	pdata->ioaddr_nvram = ioaddr;
-	pdata->size_nvram = pdata->size - RTC_SIZE;
+	pdata->size_nvram = resource_size(res) - RTC_SIZE;
 	pdata->ioaddr_rtc = ioaddr + pdata->size_nvram;
 
 	sysfs_bin_attr_init(&pdata->nvram_attr);
_

Patches currently in -mm which might be from shc_work@mail.ru are

drivers-rtc-rtc-ds1742c-use-devm_ioremap_resource.patch
drivers-rtc-rtc-ds1742c-remove-unused-field-rtc-from-private-structure.patch
drivers-rtc-rtc-ds1742c-report-to-rtc-core-if-retrieved-time-is-invalid.patch
linux-next.patch

