From: akpm@linux-foundation.org
Subject: +
 platform-convert-apple-gmux-driver-to-dev_pm_ops-from-legacy-pm_ops.patch
 added to -mm tree
Date: Thu, 29 Aug 2013 14:37:36 -0700
Message-ID: <521fbf20.EKk6g/42m83/8kx8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37317 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab3H2Vhi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Aug 2013 17:37:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tpmdd@sirrix.com, tpmdd@selhorst.net, rob.herring@calxeda.com, rafael.j.wysocki@intel.com, matthew.garrett@nebula.com, mail@srajiv.net, leosilva@linux.vnet.ibm.com, grant.likely@linaro.org, bhelgaas@google.com, ashley@ashleylai.com, a.zummo@towertech.it, PeterHuewe@gmx.de, shuah.kh@samsung.com

Subject: + platform-convert-apple-gmux-driver-to-dev_pm_ops-from-legacy-pm_ops.patch added to -mm tree
To: shuah.kh@samsung.com,PeterHuewe@gmx.de,a.zummo@towertech.it,ashley@ashleylai.com,bhelgaas@google.com,grant.likely@linaro.org,leosilva@linux.vnet.ibm.com,mail@srajiv.net,matthew.garrett@nebula.com,rafael.j.wysocki@intel.com,rob.herring@calxeda.com,tpmdd@selhorst.net,tpmdd@sirrix.com
From: akpm@linux-foundation.org
Date: Thu, 29 Aug 2013 14:37:36 -0700


The patch titled
     Subject: platform: convert apple-gmux driver to dev_pm_ops from legacy pm_ops
has been added to the -mm tree.  Its filename is
     platform-convert-apple-gmux-driver-to-dev_pm_ops-from-legacy-pm_ops.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/platform-convert-apple-gmux-driver-to-dev_pm_ops-from-legacy-pm_ops.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/platform-convert-apple-gmux-driver-to-dev_pm_ops-from-legacy-pm_ops.patch

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
Subject: platform: convert apple-gmux driver to dev_pm_ops from legacy pm_ops

Convert drivers/platform/x86/apple-gmux to use dev_pm_ops instead of
legacy pm_ops.  This patch depends on pnp driver bus ops change to invoke
pnp_driver dev_pm_ops.

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

 drivers/platform/x86/apple-gmux.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff -puN drivers/platform/x86/apple-gmux.c~platform-convert-apple-gmux-driver-to-dev_pm_ops-from-legacy-pm_ops drivers/platform/x86/apple-gmux.c
--- a/drivers/platform/x86/apple-gmux.c~platform-convert-apple-gmux-driver-to-dev_pm_ops-from-legacy-pm_ops
+++ a/drivers/platform/x86/apple-gmux.c
@@ -393,17 +393,21 @@ static void gmux_notify_handler(acpi_han
 		complete(&gmux_data->powerchange_done);
 }
 
-static int gmux_suspend(struct pnp_dev *pnp, pm_message_t state)
+static int gmux_suspend(struct device *dev)
 {
+	struct pnp_dev *pnp = to_pnp_dev(dev);
 	struct apple_gmux_data *gmux_data = pnp_get_drvdata(pnp);
+
 	gmux_data->resume_client_id = gmux_active_client(gmux_data);
 	gmux_disable_interrupts(gmux_data);
 	return 0;
 }
 
-static int gmux_resume(struct pnp_dev *pnp)
+static int gmux_resume(struct device *dev)
 {
+	struct pnp_dev *pnp = to_pnp_dev(dev);
 	struct apple_gmux_data *gmux_data = pnp_get_drvdata(pnp);
+
 	gmux_enable_interrupts(gmux_data);
 	gmux_switchto(gmux_data->resume_client_id);
 	if (gmux_data->power_state == VGA_SWITCHEROO_OFF)
@@ -605,13 +609,19 @@ static const struct pnp_device_id gmux_d
 	{"", 0}
 };
 
+static const struct dev_pm_ops gmux_dev_pm_ops = {
+	.suspend = gmux_suspend,
+	.resume = gmux_resume,
+};
+
 static struct pnp_driver gmux_pnp_driver = {
 	.name		= "apple-gmux",
 	.probe		= gmux_probe,
 	.remove		= gmux_remove,
 	.id_table	= gmux_device_ids,
-	.suspend	= gmux_suspend,
-	.resume		= gmux_resume
+	.driver		= {
+			.pm = &gmux_dev_pm_ops,
+	},
 };
 
 static int __init apple_gmux_init(void)
_

Patches currently in -mm which might be from shuah.kh@samsung.com are

pnp-change-pnp-bus-pm_ops-to-invoke-pnp-driver-dev_pm_ops-if-specified.patch
rtc-convert-rtc-cmos-to-dev_pm_ops-from-legacy-pm_ops.patch
tpm-convert-tpm_tis-driver-to-use-dev_pm_ops-from-legacy-pm_ops.patch
platform-convert-apple-gmux-driver-to-dev_pm_ops-from-legacy-pm_ops.patch
linux-next.patch

