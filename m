From: akpm@linux-foundation.org
Subject: [merged]
 rtc-convert-rtc-cmos-to-dev_pm_ops-from-legacy-pm_ops.patch removed from
 -mm tree
Date: Thu, 12 Sep 2013 12:45:57 -0700
Message-ID: <523219f5.3ZM/XVlk4X3/Mmg1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58661 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756410Ab3ILTp6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:45:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tpmdd@sirrix.com, tpmdd@selhorst.net, rob.herring@calxeda.com, rafael.j.wysocki@intel.com, matthew.garrett@nebula.com, mail@srajiv.net, leosilva@linux.vnet.ibm.com, grant.likely@linaro.org, bhelgaas@google.com, ashley@ashleylai.com, a.zummo@towertech.it, PeterHuewe@gmx.de, shuah.kh@samsung.com

Subject: [merged] rtc-convert-rtc-cmos-to-dev_pm_ops-from-legacy-pm_ops.patch removed from -mm tree
To: shuah.kh@samsung.com,PeterHuewe@gmx.de,a.zummo@towertech.it,ashley@ashleylai.com,bhelgaas@google.com,grant.likely@linaro.org,leosilva@linux.vnet.ibm.com,mail@srajiv.net,matthew.garrett@nebula.com,rafael.j.wysocki@intel.com,rob.herring@calxeda.com,tpmdd@selhorst.net,tpmdd@sirrix.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:45:57 -0700


The patch titled
     Subject: rtc: convert rtc-cmos to dev_pm_ops from legacy pm_ops
has been removed from the -mm tree.  Its filename was
     rtc-convert-rtc-cmos-to-dev_pm_ops-from-legacy-pm_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
