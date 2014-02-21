From: akpm@linux-foundation.org
Subject: +
 drivers-rtc-rtc-cmosc-fix-compilation-warning-when-config_pm_sleep.patch
 added to -mm tree
Date: Fri, 21 Feb 2014 15:36:41 -0800
Message-ID: <5307e309.gCTNCZOQ4SueZBT/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59215 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332AbaBUXgm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Feb 2014 18:36:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mika.westerberg@linux.intel.com

Subject: + drivers-rtc-rtc-cmosc-fix-compilation-warning-when-config_pm_sleep.patch added to -mm tree
To: mika.westerberg@linux.intel.com
From: akpm@linux-foundation.org
Date: Fri, 21 Feb 2014 15:36:41 -0800


The patch titled
     Subject: drivers/rtc/rtc-cmos.c: fix compilation warning when !CONFIG_PM_SLEEP
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-cmosc-fix-compilation-warning-when-config_pm_sleep.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-cmosc-fix-compilation-warning-when-config_pm_sleep.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-cmosc-fix-compilation-warning-when-config_pm_sleep.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: drivers/rtc/rtc-cmos.c: fix compilation warning when !CONFIG_PM_SLEEP

CONFIG_PM will be set also if only CONFIG_PM_RUNTIME is set which causes
the compiler to emit following warning:

drivers/rtc/rtc-cmos.c:845:12: warning: =E2=80=98cmos_resume=E2=80=99 defin=
ed but not used [-Wunused-function]

Fix this by using CONFIG_PM_SLEEP instead of CONFIG_PM and removing it
from the driver pm ops as this has been taken care by SIMPLE_DEV_PM_OPS()
already.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-cmos.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-cmos.c~drivers-rtc-rtc-cmosc-fix-compilation-warning-when-config_pm_sleep drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~drivers-rtc-rtc-cmosc-fix-compilation-warning-when-config_pm_sleep
+++ a/drivers/rtc/rtc-cmos.c
@@ -837,7 +837,7 @@ static void __exit cmos_do_remove(struct
 	cmos->dev = NULL;
 }
 
-#ifdef	CONFIG_PM
+#ifdef	CONFIG_PM_SLEEP
 
 static int cmos_suspend(struct device *dev)
 {
@@ -935,8 +935,6 @@ static int cmos_resume(struct device *de
 	return 0;
 }
 
-static SIMPLE_DEV_PM_OPS(cmos_pm_ops, cmos_suspend, cmos_resume);
-
 #else
 
 static inline int cmos_poweroff(struct device *dev)
@@ -946,6 +944,8 @@ static inline int cmos_poweroff(struct d
 
 #endif
 
+static SIMPLE_DEV_PM_OPS(cmos_pm_ops, cmos_suspend, cmos_resume);
+
 /*----------------------------------------------------------------*/
 
 /* On non-x86 systems, a "CMOS" RTC lives most naturally on platform_bus.
@@ -1088,11 +1088,9 @@ static struct pnp_driver cmos_pnp_driver
 
 	/* flag ensures resume() gets called, and stops syslog spam */
 	.flags		= PNP_DRIVER_RES_DO_NOT_CHANGE,
-#ifdef CONFIG_PM_SLEEP
 	.driver		= {
 			.pm = &cmos_pm_ops,
 	},
-#endif
 };
 
 #endif	/* CONFIG_PNP */
_

Patches currently in -mm which might be from mika.westerberg@linux.intel.com are

drivers-rtc-rtc-cmosc-fix-compilation-warning-when-config_pm_sleep.patch
linux-next.patch

