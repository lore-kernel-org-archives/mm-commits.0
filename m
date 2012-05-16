From: akpm@linux-foundation.org
Subject: + backlight-progear-use-pr_err-instead-of-printk.patch added to -mm tree
Date: Wed, 16 May 2012 12:55:12 -0700
Message-ID: <20120516195512.E4846A0270@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:41997 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760517Ab2EPTzO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 May 2012 15:55:14 -0400
Received: by qabg24 with SMTP id g24so153981qab.1
        for <mm-commits@vger.kernel.org>; Wed, 16 May 2012 12:55:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, joe@perches.com, openembedded@haerwu.biz, rpurdie@rpsys.net


The patch titled
     Subject: backlight: progear: use pr_err() instead of printk()
has been added to the -mm tree.  Its filename is
     backlight-progear-use-pr_err-instead-of-printk.patch

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
Subject: backlight: progear: use pr_err() instead of printk()

Use pr_err() instead of printk() to allow dynamic debugging.  The pr_fmt
prefix for pr_ macros is used.  Also fix checkpatch warnings as below:

WARNING: printk() should include KERN_ facility level

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
 
+#define pr_fmt(fmt) "progear_bl: " fmt
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
Subject: Subject: backlight: progear: use pr_err() instead of printk()

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

