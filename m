From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-mpc5121-use-devm_-functions.patch removed from
 -mm tree
Date: Mon, 08 Jul 2013 12:33:26 -0700
Message-ID: <51db1406.LR7c/mq6H5Tppbvv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51242 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001Ab3GHTdl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:33:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] rtc-rtc-mpc5121-use-devm_-functions.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:33:26 -0700


The patch titled
     Subject: rtc: rtc-mpc5121: use devm_*() functions
has been removed from the -mm tree.  Its filename was
     rtc-rtc-mpc5121-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-mpc5121: use devm_*() functions

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-mpc5121.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff -puN drivers/rtc/rtc-mpc5121.c~rtc-rtc-mpc5121-use-devm_-functions drivers/rtc/rtc-mpc5121.c
--- a/drivers/rtc/rtc-mpc5121.c~rtc-rtc-mpc5121-use-devm_-functions
+++ a/drivers/rtc/rtc-mpc5121.c
@@ -312,15 +312,14 @@ static int mpc5121_rtc_probe(struct plat
 	struct mpc5121_rtc_data *rtc;
 	int err = 0;
 
-	rtc = kzalloc(sizeof(*rtc), GFP_KERNEL);
+	rtc = devm_kzalloc(&op->dev, sizeof(*rtc), GFP_KERNEL);
 	if (!rtc)
 		return -ENOMEM;
 
 	rtc->regs = of_iomap(op->dev.of_node, 0);
 	if (!rtc->regs) {
 		dev_err(&op->dev, "%s: couldn't map io space\n", __func__);
-		err = -ENOSYS;
-		goto out_free;
+		return -ENOSYS;
 	}
 
 	device_init_wakeup(&op->dev, 1);
@@ -354,10 +353,10 @@ static int mpc5121_rtc_probe(struct plat
 			out_be32(&rtc->regs->keep_alive, ka);
 		}
 
-		rtc->rtc = rtc_device_register("mpc5121-rtc", &op->dev,
+		rtc->rtc = devm_rtc_device_register(&op->dev, "mpc5121-rtc",
 						&mpc5121_rtc_ops, THIS_MODULE);
 	} else {
-		rtc->rtc = rtc_device_register("mpc5200-rtc", &op->dev,
+		rtc->rtc = devm_rtc_device_register(&op->dev, "mpc5200-rtc",
 						&mpc5200_rtc_ops, THIS_MODULE);
 	}
 
@@ -377,8 +376,6 @@ out_dispose2:
 out_dispose:
 	irq_dispose_mapping(rtc->irq);
 	iounmap(rtc->regs);
-out_free:
-	kfree(rtc);
 
 	return err;
 }
@@ -392,14 +389,11 @@ static int mpc5121_rtc_remove(struct pla
 	out_8(&regs->alm_enable, 0);
 	out_8(&regs->int_enable, in_8(&regs->int_enable) & ~0x1);
 
-	rtc_device_unregister(rtc->rtc);
 	iounmap(rtc->regs);
 	free_irq(rtc->irq, &op->dev);
 	free_irq(rtc->irq_periodic, &op->dev);
 	irq_dispose_mapping(rtc->irq);
 	irq_dispose_mapping(rtc->irq_periodic);
-	dev_set_drvdata(&op->dev, NULL);
-	kfree(rtc);
 
 	return 0;
 }
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch

