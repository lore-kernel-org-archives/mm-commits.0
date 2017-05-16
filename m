From: akpm@linux-foundation.org
Subject: [merged] imx7-fix-kconfig-warning-and-build-errors.patch
 removed from -mm tree
Date: Tue, 16 May 2017 10:50:29 -0700
Message-ID: <20170516175029.FnZMFj4z-%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57496 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752796AbdEPRua (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 16 May 2017 13:50:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabio.estevam@nxp.com, kernel@pengutronix.de, mm-commits@vger.kernel.org, rdunlap@infradead.org, shawnguo@kernel.org


The patch titled
     Subject: imx7: fix Kconfig warning and build errors
has been removed from the -mm tree.  Its filename was
     imx7-fix-kconfig-warning-and-build-errors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: imx7: fix Kconfig warning and build errors

Fix Kconfig warning in drivers/soc/imx/Kconfig and subsequent build errors
elsewhere when CONFIG_PM is not enabled.

warning: (IMX7_PM_DOMAINS) selects PM_GENERIC_DOMAINS which has unmet direct dependencies (PM)

This warning causes multiple build errors in drivers/base/power/domain.c:

../drivers/base/power/domain.c: In function 'genpd_queue_power_off_work':
../drivers/base/power/domain.c:279:13: error: 'pm_wq' undeclared (first use in this function)
  queue_work(pm_wq, &genpd->power_off_work);
../drivers/base/power/domain.c: In function 'genpd_dev_pm_qos_notifier':
../drivers/base/power/domain.c:462:25: error: 'struct dev_pm_info' has no member named 'ignore_children'
   if (!dev || dev->power.ignore_children)
../drivers/base/power/domain.c: In function 'rtpm_status_str':
../drivers/base/power/domain.c:2207:16: error: 'struct dev_pm_info' has no member named 'runtime_error'
  if (dev->power.runtime_error)
../drivers/base/power/domain.c:2209:21: error: 'struct dev_pm_info' has no member named 'disable_depth'
  else if (dev->power.disable_depth)
../drivers/base/power/domain.c:2211:21: error: 'struct dev_pm_info' has no member named 'runtime_status'
  else if (dev->power.runtime_status < ARRAY_SIZE(status_lookup))
   p = status_lookup[dev->power.runtime_status];

Link: http://lkml.kernel.org/r/47fc2167-bf0a-866a-e075-8247a10aa6e0@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Fabio Estevam <fabio.estevam@nxp.com>
Cc: Shawn Guo <shawnguo@kernel.org>
Cc: Sascha Hauer <kernel@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/soc/imx/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/soc/imx/Kconfig~imx7-fix-kconfig-warning-and-build-errors drivers/soc/imx/Kconfig
--- a/drivers/soc/imx/Kconfig~imx7-fix-kconfig-warning-and-build-errors
+++ a/drivers/soc/imx/Kconfig
@@ -2,6 +2,7 @@ menu "i.MX SoC drivers"
 
 config IMX7_PM_DOMAINS
 	bool "i.MX7 PM domains"
+	depends on PM
 	select PM_GENERIC_DOMAINS
 	depends on SOC_IMX7D || (COMPILE_TEST && OF)
 	default y if SOC_IMX7D
_

Patches currently in -mm which might be from rdunlap@infradead.org are

maintainers-greybus-dev-list-is-members-only.patch

