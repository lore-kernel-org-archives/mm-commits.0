From: akpm@linux-foundation.org
Subject: [folded-merged] rtc-tegra-use-managed-rtc_device_register-fix.patch removed from -mm tree
Date: Mon, 29 Apr 2013 16:03:43 -0700
Message-ID: <20130429230343.AE92C5A418D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:64534 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758694Ab3D2XDo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Apr 2013 19:03:44 -0400
Received: by mail-yh0-f73.google.com with SMTP id f35so200225yha.0
        for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2013 16:03:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ldewangan@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-tegra.c: fix build warning
has been removed from the -mm tree.  Its filename was
     rtc-tegra-use-managed-rtc_device_register-fix.patch

This patch was dropped because it was folded into rtc-tegra-use-managed-rtc_device_register.patch

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


