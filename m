From: akpm@linux-foundation.org
Subject: + pm-make-wakeup-flags-available-whenever-config_pm-is-set.patch added to -mm tree
Date: Mon, 17 Mar 2008 17:04:38 -0700
Message-ID: <200803180004.m2I04dM1005126@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34757 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752461AbYCRAE4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 20:04:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stern@rowland.harvard.edu, greg@kroah.com, lenb@kernel.org, rjw@sisk.pl


The patch titled
     pm: make wakeup flags available whenever CONFIG_PM is set
has been added to the -mm tree.  Its filename is
     pm-make-wakeup-flags-available-whenever-config_pm-is-set.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pm: make wakeup flags available whenever CONFIG_PM is set
From: Alan Stern <stern@rowland.harvard.edu>

The various wakeup flags and their accessor macros in struct dev_pm_info
should be available whenever CONFIG_PM is enabled, not just when
CONFIG_PM_SLEEP is on.  Otherwise remote wakeup won't always be configurable
for runtime power management.  This patch (as1056b) fixes the oversight.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/power/main.c  |    2 --
 drivers/base/power/sysfs.c |    2 ++
 include/linux/pm.h         |   34 ++++++++++++++++++++--------------
 3 files changed, 22 insertions(+), 16 deletions(-)

diff -puN drivers/base/power/main.c~pm-make-wakeup-flags-available-whenever-config_pm-is-set drivers/base/power/main.c
--- a/drivers/base/power/main.c~pm-make-wakeup-flags-available-whenever-config_pm-is-set
+++ a/drivers/base/power/main.c
@@ -57,8 +57,6 @@ static DEFINE_MUTEX(dpm_list_mtx);
 /* 'true' if all devices have been suspended, protected by dpm_list_mtx */
 static bool all_sleeping;
 
-int (*platform_enable_wakeup)(struct device *dev, int is_on);
-
 /**
  *	device_pm_add - add a device to the list of active devices
  *	@dev:	Device to be added to the list
diff -puN drivers/base/power/sysfs.c~pm-make-wakeup-flags-available-whenever-config_pm-is-set drivers/base/power/sysfs.c
--- a/drivers/base/power/sysfs.c~pm-make-wakeup-flags-available-whenever-config_pm-is-set
+++ a/drivers/base/power/sysfs.c
@@ -6,6 +6,8 @@
 #include <linux/string.h>
 #include "power.h"
 
+int (*platform_enable_wakeup)(struct device *dev, int is_on);
+
 
 /*
  *	wakeup - Report/change current wakeup option for device
diff -puN include/linux/pm.h~pm-make-wakeup-flags-available-whenever-config_pm-is-set include/linux/pm.h
--- a/include/linux/pm.h~pm-make-wakeup-flags-available-whenever-config_pm-is-set
+++ a/include/linux/pm.h
@@ -198,11 +198,6 @@ extern void device_resume(void);
 extern int device_suspend(pm_message_t state);
 extern int device_prepare_suspend(pm_message_t state);
 
-#define device_set_wakeup_enable(dev,val) \
-	((dev)->power.should_wakeup = !!(val))
-#define device_may_wakeup(dev) \
-	(device_can_wakeup(dev) && (dev)->power.should_wakeup)
-
 extern void __suspend_report_result(const char *function, void *fn, int ret);
 
 #define suspend_report_result(fn, ret)					\
@@ -210,6 +205,24 @@ extern void __suspend_report_result(cons
 		__suspend_report_result(__FUNCTION__, fn, ret);		\
 	} while (0)
 
+#else /* !CONFIG_PM_SLEEP */
+
+static inline int device_suspend(pm_message_t state)
+{
+	return 0;
+}
+
+#define suspend_report_result(fn, ret) do { } while (0)
+
+#endif /* !CONFIG_PM_SLEEP */
+
+#ifdef CONFIG_PM
+
+#define device_set_wakeup_enable(dev,val) \
+	((dev)->power.should_wakeup = !!(val))
+#define device_may_wakeup(dev) \
+	(device_can_wakeup(dev) && (dev)->power.should_wakeup)
+
 /*
  * Platform hook to activate device wakeup capability, if that's not already
  * handled by enable_irq_wake() etc.
@@ -224,24 +237,17 @@ static inline int call_platform_enable_w
 	return 0;
 }
 
-#else /* !CONFIG_PM_SLEEP */
-
-static inline int device_suspend(pm_message_t state)
-{
-	return 0;
-}
+#else /* !CONFIG_PM */
 
 #define device_set_wakeup_enable(dev,val)	do{}while(0)
 #define device_may_wakeup(dev)			(0)
 
-#define suspend_report_result(fn, ret) do { } while (0)
