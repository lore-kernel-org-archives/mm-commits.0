From: akpm@linux-foundation.org
Subject: + rtc-tegra-use-managed-rtc_device_register-fix.patch added to -mm tree
Date: Thu, 21 Mar 2013 12:14:12 -0700
Message-ID: <20130321191412.683225A429F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:52176 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab3CUTON (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Mar 2013 15:14:13 -0400
Received: by mail-gh0-f201.google.com with SMTP id z19so291773ghb.0
        for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2013 12:14:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ldewangan@nvidia.com


The patch titled
     Subject: drivers/rtc/rtc-tegra.c: fix build warning
has been added to the -mm tree.  Its filename is
     rtc-tegra-use-managed-rtc_device_register-fix.patch

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
Subject: drivers/rtc/rtc-tegra.c: fix build warning

Fix the below build warning:

drivers/rtc/rtc-tegra.c: In function 'tegra_rtc_probe':
drivers/rtc/rtc-tegra.c:353:33: warning: passing argument 1 of 'devm_rtc_device_register' from incompatible pointer type [enabled by default]
include/linux/rtc.h:136:27: note: expected 'struct device *' but argument is of type 'const char *'
drivers/rtc/rtc-tegra.c:353:33: warning: passing argument 2 of 'devm_rtc_device_register' from incompatible pointer type [enabled by default]
include/linux/rtc.h:136:27: note: expected 'const char *' but argument is of type 'struct device *'

This warning was introduced with patch
	commit 8a96d445e921b0d881421767fb6f7c5b6fb91b3a
	drivers/rtc/rtc-tegra.c: use managed rtc_device_register()

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-tegra.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-tegra.c~rtc-tegra-use-managed-rtc_device_register-fix drivers/rtc/rtc-tegra.c
--- a/drivers/rtc/rtc-tegra.c~rtc-tegra-use-managed-rtc_device_register-fix
+++ a/drivers/rtc/rtc-tegra.c
@@ -349,8 +349,9 @@ static int __init tegra_rtc_probe(struct
 
 	device_init_wakeup(&pdev->dev, 1);
 
-	info->rtc_dev = devm_rtc_device_register(dev_name(&pdev->dev),
-				&pdev->dev, &tegra_rtc_ops, THIS_MODULE);
+	info->rtc_dev = devm_rtc_device_register(&pdev->dev,
+				dev_name(&pdev->dev), &tegra_rtc_ops,
+				THIS_MODULE);
 	if (IS_ERR(info->rtc_dev)) {
 		ret = PTR_ERR(info->rtc_dev);
 		dev_err(&pdev->dev, "Unable to register device (err=%d).\n",
_

Patches currently in -mm which might be from ldewangan@nvidia.com are

linux-next.patch
rtc-tegra-protect-suspend-resume-callbacks-with-config_pm_sleep.patch
rtc-tegra-use-struct-dev_pm_ops-for-power-management.patch
rtc-tegra-set-irq-name-as-device-name.patch
rtc-tegra-use-managed-rtc_device_register.patch
rtc-tegra-use-managed-rtc_device_register-fix.patch

