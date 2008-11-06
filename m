From: akpm@linux-foundation.org
Subject: + tpm-clean-up-tpm_nsc-driver-for-platform_device-suspend-resume-compliance.patch added to -mm tree
Date: Thu, 06 Nov 2008 13:28:11 -0800
Message-ID: <200811062128.mA6LSBxC029261@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43587 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751157AbYKFV2c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Nov 2008 16:28:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dds@google.com, tpm@selhorst.net


The patch titled
     tpm: clean up tpm_nsc driver for platform_device suspend/resume compliance
has been added to the -mm tree.  Its filename is
     tpm-clean-up-tpm_nsc-driver-for-platform_device-suspend-resume-compliance.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tpm: clean up tpm_nsc driver for platform_device suspend/resume compliance
From: David Smith <dds@google.com>

Signed-off-by: Marcel Selhorst <tpm@selhorst.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tpm/tpm_nsc.c |   35 ++++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 13 deletions(-)

diff -puN drivers/char/tpm/tpm_nsc.c~tpm-clean-up-tpm_nsc-driver-for-platform_device-suspend-resume-compliance drivers/char/tpm/tpm_nsc.c
--- a/drivers/char/tpm/tpm_nsc.c~tpm-clean-up-tpm_nsc-driver-for-platform_device-suspend-resume-compliance
+++ a/drivers/char/tpm/tpm_nsc.c
@@ -273,12 +273,23 @@ static void tpm_nsc_remove(struct device
 	}
 }
 
-static struct device_driver nsc_drv = {
-	.name = "tpm_nsc",
-	.bus = &platform_bus_type,
-	.owner = THIS_MODULE,
-	.suspend = tpm_pm_suspend,
-	.resume = tpm_pm_resume,
+static int tpm_nsc_suspend(struct platform_device *dev, pm_message_t msg)
+{
+	return tpm_pm_suspend(&dev->dev, msg);
+}
+
+static int tpm_nsc_resume(struct platform_device *dev)
+{
+	return tpm_pm_resume(&dev->dev);
+}
+
+static struct platform_driver nsc_drv = {
+	.suspend         = tpm_nsc_suspend,
+	.resume          = tpm_nsc_resume,
+	.driver          = {
+		.name    = "tpm_nsc",
+		.owner   = THIS_MODULE,
+	},
 };
 
 static int __init init_nsc(void)
@@ -297,7 +308,7 @@ static int __init init_nsc(void)
 			return -ENODEV;
 	}
 
-	err = driver_register(&nsc_drv);
+	err = platform_driver_register(&nsc_drv);
 	if (err)
 		return err;
 
@@ -308,17 +319,15 @@ static int __init init_nsc(void)
 	/* enable the DPM module */
 	tpm_write_index(nscAddrBase, NSC_LDC_INDEX, 0x01);
 
-	pdev = kzalloc(sizeof(struct platform_device), GFP_KERNEL);
+	pdev = platform_device_alloc("tpm_nscl0", -1);
 	if (!pdev) {
 		rc = -ENOMEM;
 		goto err_unreg_drv;
 	}
 
-	pdev->name = "tpm_nscl0";
-	pdev->id = -1;
 	pdev->num_resources = 0;
+	pdev->dev.driver = &nsc_drv.driver;
 	pdev->dev.release = tpm_nsc_remove;
-	pdev->dev.driver = &nsc_drv;
 
 	if ((rc = platform_device_register(pdev)) < 0)
 		goto err_free_dev;
@@ -377,7 +386,7 @@ err_unreg_dev:
 err_free_dev:
 	kfree(pdev);
 err_unreg_drv:
-	driver_unregister(&nsc_drv);
+	platform_driver_unregister(&nsc_drv);
 	return rc;
 }
 
@@ -390,7 +399,7 @@ static void __exit cleanup_nsc(void)
 		pdev = NULL;
 	}
 
-	driver_unregister(&nsc_drv);
+	platform_driver_unregister(&nsc_drv);
 }
 
 module_init(init_nsc);
_

Patches currently in -mm which might be from dds@google.com are

tpm-clean-up-tpm_nsc-driver-for-platform_device-suspend-resume-compliance.patch

