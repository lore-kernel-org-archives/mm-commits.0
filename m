From: akpm@linux-foundation.org
Subject: + rtc-tegra-set-irq-name-as-device-name.patch added to -mm tree
Date: Mon, 11 Mar 2013 13:28:16 -0700
Message-ID: <20130311202816.C88A831C18B@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:42327 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505Ab3CKU2S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Mar 2013 16:28:18 -0400
Received: by mail-gh0-f201.google.com with SMTP id z19so423981ghb.4
        for <mm-commits@vger.kernel.org>; Mon, 11 Mar 2013 13:28:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ldewangan@nvidia.com, jg1.han@samsung.com, swarren@nvidia.com, thierry.reding@avionic-design.de


The patch titled
     Subject: drivers/rtc/rtc-tegra.c: set irq name as device name
has been added to the -mm tree.  Its filename is
     rtc-tegra-set-irq-name-as-device-name.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Laxman Dewangan <ldewangan@nvidia.com>
Subject: drivers/rtc/rtc-tegra.c: set irq name as device name

The irq name of tegra rtc shows as "rtc alarm" which actually does not
reflect the name related to driver.

Passing the device name to have the irq names with driver name.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>
Reviewed-by: Stephen Warren <swarren@nvidia.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-tegra.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-tegra.c~rtc-tegra-set-irq-name-as-device-name drivers/rtc/rtc-tegra.c
--- a/drivers/rtc/rtc-tegra.c~rtc-tegra-set-irq-name-as-device-name
+++ a/drivers/rtc/rtc-tegra.c
@@ -362,7 +362,7 @@ static int __init tegra_rtc_probe(struct
 
 	ret = devm_request_irq(&pdev->dev, info->tegra_rtc_irq,
 			tegra_rtc_irq_handler, IRQF_TRIGGER_HIGH,
-			"rtc alarm", &pdev->dev);
+			dev_name(&pdev->dev), &pdev->dev);
 	if (ret) {
 		dev_err(&pdev->dev,
 			"Unable to request interrupt for device (err=%d).\n",
_

Patches currently in -mm which might be from ldewangan@nvidia.com are

linux-next.patch
rtc-tegra-protect-suspend-resume-callbacks-with-config_pm_sleep.patch
rtc-tegra-use-struct-dev_pm_ops-for-power-management.patch
rtc-tegra-set-irq-name-as-device-name.patch
rtc-tegra-use-managed-rtc_device_register.patch

