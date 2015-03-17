From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-mrst-fix-suspend-resume.patch added to -mm tree
Date: Tue, 17 Mar 2015 15:50:47 -0700
Message-ID: <5508afc7.PIs7CebV9Q+HOg2D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52459 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969AbbCQWus (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Mar 2015 18:50:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lars@metafoo.de, a.zummo@towertech.it, feng.tang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-mrst: fix suspend/resume
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-mrst-fix-suspend-resume.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-mrst-fix-suspend-resume.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-mrst-fix-suspend-resume.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

origin.patch
drivers-rtc-rtc-mrst-fix-suspend-resume.patch
drivers-rtc-rtc-mrst-fix-suspend-resume-fix.patch
linux-next.patch

