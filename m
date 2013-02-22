From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-ds2404-use-dev_err-instead-of-printk.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:44:20 -0800
Message-ID: <20130222204420.B878631C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:47263 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758336Ab3BVUoV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:44:21 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so103530vea.4
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:44:21 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-ds2404: use dev_err() instead of printk()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-ds2404-use-dev_err-instead-of-printk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-ds2404: use dev_err() instead of printk()

Fix the checkpatch warning as below:

  WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds2404.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-ds2404.c~rtc-rtc-ds2404-use-dev_err-instead-of-printk drivers/rtc/rtc-ds2404.c
--- a/drivers/rtc/rtc-ds2404.c~rtc-rtc-ds2404-use-dev_err-instead-of-printk
+++ a/drivers/rtc/rtc-ds2404.c
@@ -70,7 +70,7 @@ static int ds2404_gpio_map(struct ds2404
 	for (i = 0; i < ARRAY_SIZE(ds2404_gpio); i++) {
 		err = gpio_request(ds2404_gpio[i].gpio, ds2404_gpio[i].name);
 		if (err) {
-			printk(KERN_ERR "error mapping gpio %s: %d\n",
+			dev_err(&pdev->dev, "error mapping gpio %s: %d\n",
 				ds2404_gpio[i].name, err);
 			goto err_request;
 		}
@@ -177,7 +177,7 @@ static void ds2404_write_memory(struct d
 
 	for (i = 0; i < length; i++) {
 		if (out[i] != ds2404_read_byte(dev)) {
-			printk(KERN_ERR "read invalid data\n");
+			dev_err(dev, "read invalid data\n");
 			return;
 		}
 	}
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

