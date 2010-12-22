From: akpm@linux-foundation.org
Subject: + rtc-cmos-fix-suspend-resume.patch added to -mm tree
Date: Wed, 22 Dec 2010 14:20:10 -0800
Message-ID: <201012222220.oBMMKA7L022650__7130.53599834001$1293056439$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40067 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751791Ab0LVWU0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Dec 2010 17:20:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pgf@laptop.org, dsd@laptop.org, rjw@sisk.pl, stable@kernel.org


The patch titled
     rtc-cmos: fix suspend/resume
has been added to the -mm tree.  Its filename is
     rtc-cmos-fix-suspend-resume.patch

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
Subject: rtc-cmos: fix suspend/resume
From: Paul Fox <pgf@laptop.org>

rtc-cmos was setting suspend/resume hooks at the device_driver level. 
However, the platform bus code (drivers/base/platform.c) only looks for
resume hooks at the dev_pm_ops level, or within the platform_driver.

Switch rtc_cmos to use dev_pm_ops so that suspend/resume code is executed
again.

Signed-off-by: Paul Fox <pgf@laptop.org>
Signed-off-by: Daniel Drake <dsd@laptop.org>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: <stable@kernel.org>		[2.6.37.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-cmos.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff -puN drivers/rtc/rtc-cmos.c~rtc-cmos-fix-suspend-resume drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~rtc-cmos-fix-suspend-resume
+++ a/drivers/rtc/rtc-cmos.c
@@ -36,6 +36,7 @@
 #include <linux/platform_device.h>
 #include <linux/mod_devicetable.h>
 #include <linux/log2.h>
+#include <linux/pm.h>
 
 /* this is for "generic access to PC-style RTC" using CMOS_READ/CMOS_WRITE */
 #include <asm-generic/rtc.h>
@@ -851,7 +852,7 @@ static void __exit cmos_do_remove(struct
 
 #ifdef	CONFIG_PM
 
-static int cmos_suspend(struct device *dev, pm_message_t mesg)
+static int cmos_suspend(struct device *dev)
 {
 	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
 	unsigned char	tmp;
@@ -899,7 +900,7 @@ static int cmos_suspend(struct device *d
  */
 static inline int cmos_poweroff(struct device *dev)
 {
-	return cmos_suspend(dev, PMSG_HIBERNATE);
+	return cmos_suspend(dev);
 }
 
 static int cmos_resume(struct device *dev)
@@ -946,9 +947,9 @@ static int cmos_resume(struct device *de
 	return 0;
 }
 
+static SIMPLE_DEV_PM_OPS(cmos_pm_ops, cmos_suspend, cmos_resume);
+
 #else
-#define	cmos_suspend	NULL
-#define	cmos_resume	NULL
 
 static inline int cmos_poweroff(struct device *dev)
 {
@@ -1078,7 +1079,7 @@ static void __exit cmos_pnp_remove(struc
 
 static int cmos_pnp_suspend(struct pnp_dev *pnp, pm_message_t mesg)
 {
-	return cmos_suspend(&pnp->dev, mesg);
+	return cmos_suspend(&pnp->dev);
 }
 
 static int cmos_pnp_resume(struct pnp_dev *pnp)
@@ -1158,8 +1159,9 @@ static struct platform_driver cmos_platf
 	.shutdown	= cmos_platform_shutdown,
 	.driver = {
 		.name		= (char *) driver_name,
-		.suspend	= cmos_suspend,
-		.resume		= cmos_resume,
+#ifdef CONFIG_PM
+		.pm		= &cmos_pm_ops,
+#endif
 	}
 };
 
_

Patches currently in -mm which might be from pgf@laptop.org are

linux-next.patch
rtc-cmos-fix-suspend-resume.patch

