From: akpm@linux-foundation.org
Subject: [folded-merged] drivers-rtc-rtc-mrst-fix-suspend-resume.patch
 removed from -mm tree
Date: Wed, 25 Mar 2015 15:50:08 -0700
Message-ID: <55133ba0.yw+vwrBaqWSb/W9Q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34075 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbbCYWuJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Mar 2015 18:50:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lars@metafoo.de, a.zummo@towertech.it, feng.tang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-mrst: fix suspend/resume
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-mrst-fix-suspend-resume.patch

This patch was dropped because it was folded into aoe-update-aoe-maintainer-information.patch

------------------------------------------------------
From: Lars-Peter Clausen <lars@metafoo.de>
Subject: drivers/rtc/rtc-mrst: fix suspend/resume

The Moorestown RTC driver implements suspend and resume callbacks and
assigns them to the suspend and resume fields of the device_driver struct.
These callbacks are never actually called by anything though.

Modify the driver to properly use dev_pm_ops so that the suspend and resume
functions are actually executed upon suspend/resume.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Feng Tang <feng.tang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-mrst.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff -puN drivers/rtc/rtc-mrst.c~drivers-rtc-rtc-mrst-fix-suspend-resume drivers/rtc/rtc-mrst.c
--- a/drivers/rtc/rtc-mrst.c~drivers-rtc-rtc-mrst-fix-suspend-resume
+++ a/drivers/rtc/rtc-mrst.c
@@ -413,8 +413,8 @@ static void rtc_mrst_do_remove(struct de
 	mrst->dev = NULL;
 }
 
-#ifdef	CONFIG_PM
-static int mrst_suspend(struct device *dev, pm_message_t mesg)
+#ifdef CONFIG_PM_SLEEP
+static int mrst_suspend(struct device *dev)
 {
 	struct mrst_rtc	*mrst = dev_get_drvdata(dev);
 	unsigned char	tmp;
@@ -453,7 +453,7 @@ static int mrst_suspend(struct device *d
  */
 static inline int mrst_poweroff(struct device *dev)
 {
-	return mrst_suspend(dev, PMSG_HIBERNATE);
+	return mrst_suspend(dev);
 }
 
 static int mrst_resume(struct device *dev)
@@ -490,9 +490,11 @@ static int mrst_resume(struct device *de
 	return 0;
 }
 
+static SIMPLE_DEV_PM_OPS(mrst_pm_ops, mrst_suspend, mrst_resume);
+#define MRST_PM_OPS (&mrst_pm_ops)
+
 #else
-#define	mrst_suspend	NULL
-#define	mrst_resume	NULL
+#define MRST_PM_OPS NULL
 
 static inline int mrst_poweroff(struct device *dev)
 {
@@ -529,9 +531,8 @@ static struct platform_driver vrtc_mrst_
 	.remove		= vrtc_mrst_platform_remove,
 	.shutdown	= vrtc_mrst_platform_shutdown,
 	.driver = {
-		.name		= (char *) driver_name,
-		.suspend	= mrst_suspend,
-		.resume		= mrst_resume,
+		.name	= (char *) driver_name,
+		.pm	= MRST_PM_OPS,
 	}
 };
 
_

Patches currently in -mm which might be from lars@metafoo.de are

aoe-update-aoe-maintainer-information.patch
drivers-rtc-rtc-mrst-fix-suspend-resume-fix.patch
linux-next.patch

