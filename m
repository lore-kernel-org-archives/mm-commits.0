From: akpm@linux-foundation.org
Subject: +
 drivers-rtc-rtc-pl030c-use-devm_kzalloc-instead-of-kmalloc.patch added to
 -mm tree
Date: Thu, 10 Oct 2013 15:56:47 -0700
Message-ID: <525730af.GStqOzUU2IE7OS24%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38864 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755421Ab3JJW4s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Oct 2013 18:56:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rmk+kernel@arm.linux.org.uk, joe@perches.com, a.zummo@towertech.it, sangjung.woo@samsung.com

Subject: + drivers-rtc-rtc-pl030c-use-devm_kzalloc-instead-of-kmalloc.patch added to -mm tree
To: sangjung.woo@samsung.com,a.zummo@towertech.it,joe@perches.com,rmk+kernel@arm.linux.org.uk
From: akpm@linux-foundation.org
Date: Thu, 10 Oct 2013 15:56:47 -0700


The patch titled
     Subject: drivers/rtc/rtc-pl030.c: use devm_kzalloc() instead of kmalloc()
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-pl030c-use-devm_kzalloc-instead-of-kmalloc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-pl030c-use-devm_kzalloc-instead-of-kmalloc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-pl030c-use-devm_kzalloc-instead-of-kmalloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sangjung Woo <sangjung.woo@samsung.com>
Subject: drivers/rtc/rtc-pl030.c: use devm_kzalloc() instead of kmalloc()

In order to be free automatically and make the cleanup paths more simple,
use devm_kzalloc() instead of kmalloc().

Signed-off-by: Sangjung Woo <sangjung.woo@samsung.com>
Cc: Joe Perches <joe@perches.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pl030.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-pl030.c~drivers-rtc-rtc-pl030c-use-devm_kzalloc-instead-of-kmalloc drivers/rtc/rtc-pl030.c
--- a/drivers/rtc/rtc-pl030.c~drivers-rtc-rtc-pl030c-use-devm_kzalloc-instead-of-kmalloc
+++ a/drivers/rtc/rtc-pl030.c
@@ -106,7 +106,7 @@ static int pl030_probe(struct amba_devic
 	if (ret)
 		goto err_req;
 
-	rtc = kmalloc(sizeof(*rtc), GFP_KERNEL);
+	rtc = devm_kzalloc(&dev->dev, sizeof(*rtc), GFP_KERNEL);
 	if (!rtc) {
 		ret = -ENOMEM;
 		goto err_rtc;
@@ -115,7 +115,7 @@ static int pl030_probe(struct amba_devic
 	rtc->base = ioremap(dev->res.start, resource_size(&dev->res));
 	if (!rtc->base) {
 		ret = -ENOMEM;
-		goto err_map;
+		goto err_rtc;
 	}
 
 	__raw_writel(0, rtc->base + RTC_CR);
@@ -141,8 +141,6 @@ static int pl030_probe(struct amba_devic
 	free_irq(dev->irq[0], rtc);
  err_irq:
 	iounmap(rtc->base);
- err_map:
-	kfree(rtc);
  err_rtc:
 	amba_release_regions(dev);
  err_req:
@@ -158,7 +156,6 @@ static int pl030_remove(struct amba_devi
 	free_irq(dev->irq[0], rtc);
 	rtc_device_unregister(rtc->rtc);
 	iounmap(rtc->base);
-	kfree(rtc);
 	amba_release_regions(dev);
 
 	return 0;
_

Patches currently in -mm which might be from sangjung.woo@samsung.com are

drivers-rtc-rtc-puv3c-use-dev_dbg-instead-of-pr_debug.patch
drivers-rtc-rtc-pl030c-use-devm_kzalloc-instead-of-kmalloc.patch

