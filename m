From: akpm@linux-foundation.org
Subject: + backlight-cr_bllcd-use-pr_err-pr_info-instead-of-printk.patch added to -mm tree
Date: Wed, 16 May 2012 12:55:04 -0700
Message-ID: <20120516195504.E7021A0270@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:42573 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760096Ab2EPTzG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 May 2012 15:55:06 -0400
Received: by yhgm50 with SMTP id m50so162816yhg.1
        for <mm-commits@vger.kernel.org>; Wed, 16 May 2012 12:55:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, joe@perches.com, rpurdie@rpsys.net


The patch titled
     Subject: backlight: cr_bllcd: use pr_err()/pr_info() instead of printk()
has been added to the -mm tree.  Its filename is
     backlight-cr_bllcd-use-pr_err-pr_info-instead-of-printk.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: cr_bllcd: use pr_err()/pr_info() instead of printk()

Use pr_err()/pr_info() instead of printk() to allow dynamic debugging. 
The pr_fmt prefix for pr_ macros is used.  Also fix checkpatch warnings as
below:

WARNING: printk() should include KERN_ facility level
WARNING: Prefer pr_err(... to printk(KERN_ERR, ...

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
 
+#define pr_fmt(fmt) "cr_backlight: " fmt
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
Subject: Subject: backlight: cr_bllcd: use pr_err()/pr_info() instead of printk()

Patches currently in -mm which might be from jg1.han@samsung.com are

linux-next.patch
backlight-adp8860-use-kstrtoul.patch
backlight-adp8870-use-kstrtoul.patch
backlight-adp5520-use-kstrtoul.patch
backlight-use-pr_warn-and-pr_debug-instead-of-printk.patch
backlight-apple_bl-use-pr_debug-pr_err-instead-of-printk.patch
backlight-cr_bllcd-use-pr_err-pr_info-instead-of-printk.patch
backlight-generic_bl-use-pr_info-instead-of-printk.patch
backlight-jornada720-use-pr_err-pr_info-instead-of-printk.patch
backlight-omap1-use-pr_info-instead-of-printk.patch
backlight-progear-use-pr_err-instead-of-printk.patch

