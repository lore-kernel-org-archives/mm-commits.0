From: akpm@linux-foundation.org
Subject: + backlight-generic_bl-use-pr_info-instead-of-printk.patch added to -mm tree
Date: Wed, 16 May 2012 12:55:06 -0700
Message-ID: <20120516195506.DC30AA0270@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:35211 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760458Ab2EPTzH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 May 2012 15:55:07 -0400
Received: by qcsp5 with SMTP id p5so137991qcs.1
        for <mm-commits@vger.kernel.org>; Wed, 16 May 2012 12:55:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, joe@perches.com, rpurdie@rpsys.net


The patch titled
     Subject: backlight: generic_bl: use pr_info() instead of printk()
has been added to the -mm tree.  Its filename is
     backlight-generic_bl-use-pr_info-instead-of-printk.patch

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
Subject: backlight: generic_bl: use pr_info() instead of printk()

Use pr_info() instead of printk() to allow dynamic debugging.  The pr_fmt
prefix for pr_ macros is used.  Also fix checkpatch warnings as below:

WARNING: printk() should include KERN_ facility level

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/generic_bl.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/video/backlight/generic_bl.c~backlight-generic_bl-use-pr_info-instead-of-printk drivers/video/backlight/generic_bl.c
--- a/drivers/video/backlight/generic_bl.c~backlight-generic_bl-use-pr_info-instead-of-printk
+++ a/drivers/video/backlight/generic_bl.c
@@ -9,6 +9,8 @@
  *
  */
 
+#define pr_fmt(fmt) "generic_bl: " fmt
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
@@ -106,7 +108,7 @@ static int genericbl_probe(struct platfo
 
 	generic_backlight_device = bd;
 
-	printk("Generic Backlight Driver Initialized.\n");
+	pr_info("Generic Backlight Driver Initialized.\n");
 	return 0;
 }
 
@@ -120,7 +122,7 @@ static int genericbl_remove(struct platf
 
 	backlight_device_unregister(bd);
 
-	printk("Generic Backlight Driver Unloaded\n");
+	pr_info("Generic Backlight Driver Unloaded\n");
 	return 0;
 }
 
_
Subject: Subject: backlight: generic_bl: use pr_info() instead of printk()

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

