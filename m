From: akpm@linux-foundation.org
Subject: [merged]
 drivers-rtc-rtc-twlc-fix-missing-device_init_wakeup-when-booted-with-device-tree.patch removed from -mm tree
Date: Thu, 13 Jun 2013 11:57:42 -0700
Message-ID: <51ba1626.W7saNZY4LgydH8ea%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37060 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757897Ab3FMS5n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jun 2013 14:57:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, khilman@linaro.org, jg1.han@samsung.com, a.zummo@towertech.it, tony@atomide.com

Subject: [merged] drivers-rtc-rtc-twlc-fix-missing-device_init_wakeup-when-booted-with-device-tree.patch removed from -mm tree
To: tony@atomide.com,a.zummo@towertech.it,jg1.han@samsung.com,khilman@linaro.org,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 13 Jun 2013 11:57:42 -0700


The patch titled
     Subject: drivers/rtc/rtc-twl.c: fix missing device_init_wakeup() when booted with device tree
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-twlc-fix-missing-device_init_wakeup-when-booted-with-device-tree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tony Lindgren <tony@atomide.com>
Subject: drivers/rtc/rtc-twl.c: fix missing device_init_wakeup() when booted with device tree

When booted in legacy mode device_init_wakeup() gets called by
drivers/mfd/twl-core.c when the children are initialized.  However, when
booted using device tree, the children are created with
of_platform_populate() instead add_children().

This means that the RTC driver will not have device_init_wakeup() set, and
we need to call it from the driver probe like RTC drivers typically do.

Without this we cannot test PM wake-up events on omaps for cases where
there may not be any physical wake-up event.

Signed-off-by: Tony Lindgren <tony@atomide.com>
Reported-by: Kevin Hilman <khilman@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Jingoo Han <jg1.han@samsung.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-twl.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/rtc/rtc-twl.c~drivers-rtc-rtc-twlc-fix-missing-device_init_wakeup-when-booted-with-device-tree drivers/rtc/rtc-twl.c
--- a/drivers/rtc/rtc-twl.c~drivers-rtc-rtc-twlc-fix-missing-device_init_wakeup-when-booted-with-device-tree
+++ a/drivers/rtc/rtc-twl.c
@@ -524,6 +524,7 @@ static int twl_rtc_probe(struct platform
 	}
 
 	platform_set_drvdata(pdev, rtc);
+	device_init_wakeup(&pdev->dev, 1);
 	return 0;
 
 out2:
_

Patches currently in -mm which might be from tony@atomide.com are

origin.patch
linux-next.patch
drivers-rtc-rtc-twlc-ensure-irq-is-wakeup-enabled.patch

