From: akpm@linux-foundation.org
Subject: + rtc-convert-rtc-cmos-to-dev_pm_ops-from-legacy-pm_ops.patch
 added to -mm tree
Date: Thu, 29 Aug 2013 14:37:32 -0700
Message-ID: <521fbf1c.//SANEHBqhck/gM6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37278 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab3H2Vhe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Aug 2013 17:37:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tpmdd@sirrix.com, tpmdd@selhorst.net, rob.herring@calxeda.com, rafael.j.wysocki@intel.com, matthew.garrett@nebula.com, mail@srajiv.net, leosilva@linux.vnet.ibm.com, grant.likely@linaro.org, bhelgaas@google.com, ashley@ashleylai.com, a.zummo@towertech.it, PeterHuewe@gmx.de, shuah.kh@samsung.com

Subject: + rtc-convert-rtc-cmos-to-dev_pm_ops-from-legacy-pm_ops.patch added to -mm tree
To: shuah.kh@samsung.com,PeterHuewe@gmx.de,a.zummo@towertech.it,ashley@ashleylai.com,bhelgaas@google.com,grant.likely@linaro.org,leosilva@linux.vnet.ibm.com,mail@srajiv.net,matthew.garrett@nebula.com,rafael.j.wysocki@intel.com,rob.herring@calxeda.com,tpmdd@selhorst.net,tpmdd@sirrix.com
From: akpm@linux-foundation.org
Date: Thu, 29 Aug 2013 14:37:32 -0700


The patch titled
     Subject: rtc: convert rtc-cmos to dev_pm_ops from legacy pm_ops
has been added to the -mm tree.  Its filename is
     rtc-convert-rtc-cmos-to-dev_pm_ops-from-legacy-pm_ops.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-convert-rtc-cmos-to-dev_pm_ops-from-legacy-pm_ops.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-convert-rtc-cmos-to-dev_pm_ops-from-legacy-pm_ops.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shuah Khan <shuah.kh@samsung.com>
Subject: rtc: convert rtc-cmos to dev_pm_ops from legacy pm_ops

Convert drivers/rtc/rtc-cmos to use dev_pm_ops instead of legacy pm_ops. 
This patch depends on pnp driver bus ops change to invoke pnp_driver
dev_pm_ops.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>
Cc: Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>
Cc: Ashley Lai <ashley@ashleylai.com>
Cc: Rajiv Andrade <mail@srajiv.net>
Cc: Marcel Selhorst <tpmdd@selhorst.net>
Cc: Sirrix AG <tpmdd@sirrix.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Peter Hüwe <PeterHuewe@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-cmos.c |   24 +++++-------------------
 1 file changed, 5 insertions(+), 19 deletions(-)

diff -puN drivers/rtc/rtc-cmos.c~rtc-convert-rtc-cmos-to-dev_pm_ops-from-legacy-pm_ops drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~rtc-convert-rtc-cmos-to-dev_pm_ops-from-legacy-pm_ops
+++ a/drivers/rtc/rtc-cmos.c
@@ -1018,23 +1018,6 @@ static void __exit cmos_pnp_remove(struc
 	cmos_do_remove(&pnp->dev);
 }
 
-#ifdef	CONFIG_PM
-
-static int cmos_pnp_suspend(struct pnp_dev *pnp, pm_message_t mesg)
-{
-	return cmos_suspend(&pnp->dev);
-}
-
-static int cmos_pnp_resume(struct pnp_dev *pnp)
-{
-	return cmos_resume(&pnp->dev);
-}
-
-#else
-#define	cmos_pnp_suspend	NULL
-#define	cmos_pnp_resume		NULL
-#endif
-
 static void cmos_pnp_shutdown(struct pnp_dev *pnp)
 {
 	if (system_state == SYSTEM_POWER_OFF && !cmos_poweroff(&pnp->dev))
@@ -1060,8 +1043,11 @@ static struct pnp_driver cmos_pnp_driver
 
 	/* flag ensures resume() gets called, and stops syslog spam */
 	.flags		= PNP_DRIVER_RES_DO_NOT_CHANGE,
-	.suspend	= cmos_pnp_suspend,
-	.resume		= cmos_pnp_resume,
+#ifdef CONFIG_PM_SLEEP
+	.driver		= {
+			.pm = &cmos_pm_ops,
+	},
+#endif
 };
 
 #endif	/* CONFIG_PNP */
_

Patches currently in -mm which might be from shuah.kh@samsung.com are

pnp-change-pnp-bus-pm_ops-to-invoke-pnp-driver-dev_pm_ops-if-specified.patch
rtc-convert-rtc-cmos-to-dev_pm_ops-from-legacy-pm_ops.patch
tpm-convert-tpm_tis-driver-to-use-dev_pm_ops-from-legacy-pm_ops.patch
platform-convert-apple-gmux-driver-to-dev_pm_ops-from-legacy-pm_ops.patch
linux-next.patch

