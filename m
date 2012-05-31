From: akpm@linux-foundation.org
Subject: [merged] backlight-omap1-use-pr_info-instead-of-printk.patch removed from -mm tree
Date: Thu, 31 May 2012 12:18:51 -0700
Message-ID: <20120531191851.4D409A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:36898 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933023Ab2EaTSv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:18:51 -0400
Received: by mail-gg0-f202.google.com with SMTP id h3so135741gge.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:18:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, balrogg@gmail.com, joe@perches.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: omap1: use pr_info() instead of printk()
has been removed from the -mm tree.  Its filename was
     backlight-omap1-use-pr_info-instead-of-printk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: omap1: use pr_info() instead of printk()

Use pr_info() instead of printk() to allow dynamic debugging.  The pr_fmt
prefix for pr_ macros is used.  Also fix checkpatch warning as below:

WARNING: Prefer pr_info(... to printk(KERN_INFO, ...

[akpm@linux-foundation.org: use KBUILD_MODNAME, per Joe]
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
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
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

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch

