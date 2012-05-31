From: akpm@linux-foundation.org
Subject: [merged] backlight-progear-use-pr_err-instead-of-printk.patch removed from -mm tree
Date: Thu, 31 May 2012 12:18:53 -0700
Message-ID: <20120531191853.4D432A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:56583 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933023Ab2EaTSy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:18:54 -0400
Received: by mail-ee0-f74.google.com with SMTP id t10so76371eei.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:18:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, joe@perches.com, openembedded@haerwu.biz, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: progear: use pr_err() instead of printk()
has been removed from the -mm tree.  Its filename was
     backlight-progear-use-pr_err-instead-of-printk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: progear: use pr_err() instead of printk()

Use pr_err() instead of printk() to allow dynamic debugging.  The pr_fmt
prefix for pr_ macros is used.  Also fix checkpatch warnings as below:

WARNING: printk() should include KERN_ facility level

[akpm@linux-foundation.org: use KBUILD_MODNAME, per Joe]
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Marcin Juszkiewicz <openembedded@haerwu.biz>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/progear_bl.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/video/backlight/progear_bl.c~backlight-progear-use-pr_err-instead-of-printk drivers/video/backlight/progear_bl.c
--- a/drivers/video/backlight/progear_bl.c~backlight-progear-use-pr_err-instead-of-printk
+++ a/drivers/video/backlight/progear_bl.c
@@ -15,6 +15,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
@@ -68,13 +70,13 @@ static int progearbl_probe(struct platfo
 
 	pmu_dev = pci_get_device(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M7101, NULL);
 	if (!pmu_dev) {
-		printk("ALI M7101 PMU not found.\n");
+		pr_err("ALI M7101 PMU not found.\n");
 		return -ENODEV;
 	}
 
 	sb_dev = pci_get_device(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M1533, NULL);
 	if (!sb_dev) {
-		printk("ALI 1533 SB not found.\n");
+		pr_err("ALI 1533 SB not found.\n");
 		ret = -ENODEV;
 		goto put_pmu;
 	}
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch

