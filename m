From: akpm@linux-foundation.org
Subject: + backlight-omap1-use-pr_info-instead-of-printk.patch added to -mm tree
Date: Wed, 16 May 2012 12:55:10 -0700
Message-ID: <20120516195510.DFBFDA0270@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:59058 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760484Ab2EPTzN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 May 2012 15:55:13 -0400
Received: by eeit10 with SMTP id t10so60103eei.1
        for <mm-commits@vger.kernel.org>; Wed, 16 May 2012 12:55:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, balrogg@gmail.com, joe@perches.com, rpurdie@rpsys.net


The patch titled
     Subject: backlight: omap1: use pr_info() instead of printk()
has been added to the -mm tree.  Its filename is
     backlight-omap1-use-pr_info-instead-of-printk.patch

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
Subject: backlight: omap1: use pr_info() instead of printk()

Use pr_info() instead of printk() to allow dynamic debugging.  The pr_fmt
prefix for pr_ macros is used.  Also fix checkpatch warning as below:

WARNING: Prefer pr_info(... to printk(KERN_INFO, ...

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Andrzej Zaborowski <balrogg@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/omap1_bl.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/video/backlight/omap1_bl.c~backlight-omap1-use-pr_info-instead-of-printk drivers/video/backlight/omap1_bl.c
--- a/drivers/video/backlight/omap1_bl.c~backlight-omap1-use-pr_info-instead-of-printk
+++ a/drivers/video/backlight/omap1_bl.c
@@ -18,6 +18,8 @@
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#define pr_fmt(fmt) "omap1_bl: " fmt
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
@@ -168,7 +170,7 @@ static int omapbl_probe(struct platform_
 	dev->props.brightness = pdata->default_intensity;
 	omapbl_update_status(dev);
 
-	printk(KERN_INFO "OMAP LCD backlight initialised\n");
+	pr_info("OMAP LCD backlight initialised\n");
 
 	return 0;
 }
_
Subject: Subject: backlight: omap1: use pr_info() instead of printk()

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

