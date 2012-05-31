From: akpm@linux-foundation.org
Subject: [merged] backlight-cr_bllcd-use-pr_err-pr_info-instead-of-printk.patch removed from -mm tree
Date: Thu, 31 May 2012 12:18:45 -0700
Message-ID: <20120531191845.6BF12A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:53340 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933045Ab2EaTSq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:18:46 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so134798ghb.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:18:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, joe@perches.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: cr_bllcd: use pr_err()/pr_info() instead of printk()
has been removed from the -mm tree.  Its filename was
     backlight-cr_bllcd-use-pr_err-pr_info-instead-of-printk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: cr_bllcd: use pr_err()/pr_info() instead of printk()

Use pr_err()/pr_info() instead of printk() to allow dynamic debugging. 
The pr_fmt prefix for pr_ macros is used.  Also fix checkpatch warnings as
below:

WARNING: printk() should include KERN_ facility level
WARNING: Prefer pr_err(... to printk(KERN_ERR, ...

[akpm@linux-foundation.org: use KBUILD_MODNAME, per Joe]
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/cr_bllcd.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/video/backlight/cr_bllcd.c~backlight-cr_bllcd-use-pr_err-pr_info-instead-of-printk drivers/video/backlight/cr_bllcd.c
--- a/drivers/video/backlight/cr_bllcd.c~backlight-cr_bllcd-use-pr_err-pr_info-instead-of-printk
+++ a/drivers/video/backlight/cr_bllcd.c
@@ -27,6 +27,8 @@
  *   Alan Hourihane <alanh-at-tungstengraphics-dot-com>
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
@@ -180,14 +182,13 @@ static int cr_backlight_probe(struct pla
 	lpc_dev = pci_get_device(PCI_VENDOR_ID_INTEL,
 					CRVML_DEVICE_LPC, NULL);
 	if (!lpc_dev) {
-		printk("INTEL CARILLO RANCH LPC not found.\n");
+		pr_err("INTEL CARILLO RANCH LPC not found.\n");
 		return -ENODEV;
 	}
 
 	pci_read_config_byte(lpc_dev, CRVML_REG_GPIOEN, &dev_en);
 	if (!(dev_en & CRVML_GPIOEN_BIT)) {
-		printk(KERN_ERR
-		       "Carillo Ranch GPIO device was not enabled.\n");
+		pr_err("Carillo Ranch GPIO device was not enabled.\n");
 		pci_dev_put(lpc_dev);
 		return -ENODEV;
 	}
@@ -270,7 +271,7 @@ static int __init cr_backlight_init(void
 		return PTR_ERR(crp);
 	}
 
-	printk("Carillo Ranch Backlight Driver Initialized.\n");
+	pr_info("Carillo Ranch Backlight Driver Initialized.\n");
 
 	return 0;
 }
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch

