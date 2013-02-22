From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-vr41xx-use-dev_info-instead-of-printk.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:44:32 -0800
Message-ID: <20130222204432.A310A31C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:40373 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758350Ab3BVUod (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:44:33 -0500
Received: by mail-yh0-f73.google.com with SMTP id 28so104085yhr.4
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:44:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-vr41xx: use dev_info() instead of printk()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-vr41xx-use-dev_info-instead-of-printk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-vr41xx: use dev_info() instead of printk()

Fix the checkpatch warning as below:

  WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-vr41xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-vr41xx.c~rtc-rtc-vr41xx-use-dev_info-instead-of-printk drivers/rtc/rtc-vr41xx.c
--- a/drivers/rtc/rtc-vr41xx.c~rtc-rtc-vr41xx-use-dev_info-instead-of-printk
+++ a/drivers/rtc/rtc-vr41xx.c
@@ -352,7 +352,7 @@ static int rtc_probe(struct platform_dev
 	disable_irq(aie_irq);
 	disable_irq(pie_irq);
 
-	printk(KERN_INFO "rtc: Real Time Clock of NEC VR4100 series\n");
+	dev_info(&pdev->dev, "Real Time Clock of NEC VR4100 series\n");
 
 	return 0;
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

