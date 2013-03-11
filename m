From: akpm@linux-foundation.org
Subject: + rtc-tegra-protect-suspend-resume-callbacks-with-config_pm_sleep.patch added to -mm tree
Date: Mon, 11 Mar 2013 13:28:12 -0700
Message-ID: <20130311202812.CDC7F31C18B@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:54677 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505Ab3CKU2O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Mar 2013 16:28:14 -0400
Received: by mail-qa0-f74.google.com with SMTP id o13so226705qaj.3
        for <mm-commits@vger.kernel.org>; Mon, 11 Mar 2013 13:28:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ldewangan@nvidia.com, jg1.han@samsung.com, swarren@nvidia.com, thierry.reding@avionic-design.de


The patch titled
     Subject: drivers/rtc/rtc-tegra.c: protect suspend/resume callbacks with CONFIG_PM_SLEEP
has been added to the -mm tree.  Its filename is
     rtc-tegra-protect-suspend-resume-callbacks-with-config_pm_sleep.patch

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
Subject: drivers/rtc/rtc-tegra.c: protect suspend/resume callbacks with CONFIG_PM_SLEEP

CONFIG_PM doesn't actually enable any of the PM callbacks, it only allows
to enable CONFIG_PM_SLEEP and CONFIG_PM_RUNTIME.  This means if CONFIG_PM
is used to protect system sleep callbacks then it may end up unreferenced
if only runtime PM is enabled.  Hence protecting sleep callbacks with
CONFIG_PM_SLEEP.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>
Reviewed-by: Stephen Warren <swarren@nvidia.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-tegra.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-tegra.c~rtc-tegra-protect-suspend-resume-callbacks-with-config_pm_sleep drivers/rtc/rtc-tegra.c
--- a/drivers/rtc/rtc-tegra.c~rtc-tegra-protect-suspend-resume-callbacks-with-config_pm_sleep
+++ a/drivers/rtc/rtc-tegra.c
@@ -390,7 +390,7 @@ static int __exit tegra_rtc_remove(struc
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int tegra_rtc_suspend(struct platform_device *pdev, pm_message_t state)
 {
 	struct device *dev = &pdev->dev;
@@ -446,7 +446,7 @@ static struct platform_driver tegra_rtc_
 		.owner	= THIS_MODULE,
 		.of_match_table = tegra_rtc_dt_match,
 	},
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend	= tegra_rtc_suspend,
 	.resume		= tegra_rtc_resume,
 #endif
_

Patches currently in -mm which might be from ldewangan@nvidia.com are

linux-next.patch
rtc-tegra-protect-suspend-resume-callbacks-with-config_pm_sleep.patch
rtc-tegra-use-struct-dev_pm_ops-for-power-management.patch
rtc-tegra-set-irq-name-as-device-name.patch
rtc-tegra-use-managed-rtc_device_register.patch

