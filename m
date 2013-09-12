From: akpm@linux-foundation.org
Subject: [merged]
 pnp-change-pnp-bus-pm_ops-to-invoke-pnp-driver-dev_pm_ops-if-specified.patch removed from -mm tree
Date: Thu, 12 Sep 2013 12:45:55 -0700
Message-ID: <523219f3.Z3gNyISOoiViB+1R%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58642 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756398Ab3ILTp4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:45:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tpmdd@sirrix.com, tpmdd@selhorst.net, rob.herring@calxeda.com, rafael.j.wysocki@intel.com, matthew.garrett@nebula.com, mail@srajiv.net, leosilva@linux.vnet.ibm.com, grant.likely@linaro.org, bhelgaas@google.com, ashley@ashleylai.com, a.zummo@towertech.it, PeterHuewe@gmx.de, shuah.kh@samsung.com

Subject: [merged] pnp-change-pnp-bus-pm_ops-to-invoke-pnp-driver-dev_pm_ops-if-specified.patch removed from -mm tree
To: shuah.kh@samsung.com,PeterHuewe@gmx.de,a.zummo@towertech.it,ashley@ashleylai.com,bhelgaas@google.com,grant.likely@linaro.org,leosilva@linux.vnet.ibm.com,mail@srajiv.net,matthew.garrett@nebula.com,rafael.j.wysocki@intel.com,rob.herring@calxeda.com,tpmdd@selhorst.net,tpmdd@sirrix.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:45:55 -0700


The patch titled
     Subject: pnp: change pnp bus pm_ops to invoke pnp driver dev_pm_ops if specified
has been removed from the -mm tree.  Its filename was
     pnp-change-pnp-bus-pm_ops-to-invoke-pnp-driver-dev_pm_ops-if-specified.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shuah Khan <shuah.kh@samsung.com>
Subject: pnp: change pnp bus pm_ops to invoke pnp driver dev_pm_ops if specified

pnp_bus_suspend() and pnp_bus_resume() invoke legacy pm_ops from
pnp_driver.  Changed pnp_bus_suspend() and pnp_bus_resume() to check if
pnp driver has dev_pm_ops and call.  If dev_pm_ops don't exist, then call
use legacy pm_ops.  Without this change, pnp_driver dev_pm_ops will not
get called.

In addition to the pnp driver bus pm_ops change to invoke driver
dev_pm_ops, this patch set contains changes to rtc-cmos, tpm_tis, and
apple-gmux pnp drivers to convert from legacy pm_ops to dev_pm_ops.


This patch (of 4):

pnp_bus_suspend() and pnp_bus_resume() invoke legacy pm_ops from
pnp_driver.  Changed pnp_bus_suspend() and pnp_bus_resume() to check if
pnp driver has dev_pm_ops and call.  If dev_pm_ops don't exist, then call
use legacy pm_ops.  Without this change, pnp_driver dev_pm_ops will not
get called.

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

 drivers/pnp/driver.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN drivers/pnp/driver.c~pnp-change-pnp-bus-pm_ops-to-invoke-pnp-driver-dev_pm_ops-if-specified drivers/pnp/driver.c
--- a/drivers/pnp/driver.c~pnp-change-pnp-bus-pm_ops-to-invoke-pnp-driver-dev_pm_ops-if-specified
+++ a/drivers/pnp/driver.c
@@ -163,6 +163,13 @@ static int __pnp_bus_suspend(struct devi
 	if (!pnp_drv)
 		return 0;
 
+	if (pnp_drv->driver.pm && pnp_drv->driver.pm->suspend) {
+		error = pnp_drv->driver.pm->suspend(dev);
+		suspend_report_result(pnp_drv->driver.pm->suspend, error);
+		if (error)
+			return error;
+	}
+
 	if (pnp_drv->suspend) {
 		error = pnp_drv->suspend(pnp_dev, state);
 		if (error)
@@ -210,6 +217,12 @@ static int pnp_bus_resume(struct device
 		if (error)
 			return error;
 	}
+
+	if (pnp_drv->driver.pm && pnp_drv->driver.pm->resume) {
+		error = pnp_drv->driver.pm->resume(dev);
+		if (error)
+			return error;
+	}
 
 	if (pnp_drv->resume) {
 		error = pnp_drv->resume(pnp_dev);
_

Patches currently in -mm which might be from shuah.kh@samsung.com are

origin.patch

