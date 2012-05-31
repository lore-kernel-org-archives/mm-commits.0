From: akpm@linux-foundation.org
Subject: [merged] backlight-generic_bl-use-pr_info-instead-of-printk.patch removed from -mm tree
Date: Thu, 31 May 2012 12:18:47 -0700
Message-ID: <20120531191847.6046AA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:46438 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933045Ab2EaTSt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:18:49 -0400
Received: by were53 with SMTP id e53so75955wer.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:18:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, joe@perches.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: generic_bl: use pr_info() instead of printk()
has been removed from the -mm tree.  Its filename was
     backlight-generic_bl-use-pr_info-instead-of-printk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: generic_bl: use pr_info() instead of printk()

Use pr_info() instead of printk() to allow dynamic debugging.  The pr_fmt
prefix for pr_ macros is used.  Also fix checkpatch warnings as below:

WARNING: printk() should include KERN_ facility level

[akpm@linux-foundation.org: use KBUILD_MODNAME, per Joe]
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
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
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

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch

