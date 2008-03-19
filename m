From: akpm@linux-foundation.org
Subject: + pm-make-wakeup-flags-available-whenever-config_pm-is-set-ver-2.patch added to -mm tree
Date: Wed, 19 Mar 2008 15:22:00 -0700
Message-ID: <200803192222.m2JMM01d007094@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57256 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S940839AbYCSWWW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Mar 2008 18:22:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stern@rowland.harvard.edu, greg@kroah.com, rjw@sisk.pl


The patch titled
     PM: Make wakeup flags available whenever CONFIG_PM is set (ver 2)
has been added to the -mm tree.  Its filename is
     pm-make-wakeup-flags-available-whenever-config_pm-is-set-ver-2.patch

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
Subject: PM: Make wakeup flags available whenever CONFIG_PM is set (ver 2)
From: Alan Stern <stern@rowland.harvard.edu>

The various wakeup flags and their accessor macros in struct dev_pm_info
should be available whenever CONFIG_PM is enabled, not just when
CONFIG_PM_SLEEP is on.  Otherwise remote wakeup won't always be configurable
for runtime power management.  This patch (as1056b) fixes the oversight.

[rjw: rebased]
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/power/main.c  |    2 -
 drivers/base/power/sysfs.c |    2 +
 include/linux/pm.h         |   36 ++++++++++++++++++++---------------
 3 files changed, 23 insertions(+), 17 deletions(-)

diff -puN drivers/base/power/main.c~pm-make-wakeup-flags-available-whenever-config_pm-is-set-ver-2 drivers/base/power/main.c
--- a/drivers/base/power/main.c~pm-make-wakeup-flags-available-whenever-config_pm-is-set-ver-2
+++ a/drivers/base/power/main.c
@@ -57,8 +57,6 @@ static DEFINE_MUTEX(dpm_list_mtx);
 /* 'true' if all devices have been suspended, protected by dpm_list_mtx */
 static bool all_sleeping;
 
-int (*platform_enable_wakeup)(struct device *dev, int is_on);
-
 /**
  *	device_pm_add - add a device to the list of active devices
  *	@dev:	Device to be added to the list
diff -puN drivers/base/power/sysfs.c~pm-make-wakeup-flags-available-whenever-config_pm-is-set-ver-2 drivers/base/power/sysfs.c
--- a/drivers/base/power/sysfs.c~pm-make-wakeup-flags-available-whenever-config_pm-is-set-ver-2
+++ a/drivers/base/power/sysfs.c
@@ -6,6 +6,8 @@
 #include <linux/string.h>
 #include "power.h"
 
+int (*platform_enable_wakeup)(struct device *dev, int is_on);
+
 
 /*
  *	wakeup - Report/change current wakeup option for device
diff -puN include/linux/pm.h~pm-make-wakeup-flags-available-whenever-config_pm-is-set-ver-2 include/linux/pm.h
--- a/include/linux/pm.h~pm-make-wakeup-flags-available-whenever-config_pm-is-set-ver-2
+++ a/include/linux/pm.h
@@ -183,9 +183,9 @@ typedef struct pm_message {
 struct dev_pm_info {
 	pm_message_t		power_state;
 	unsigned		can_wakeup:1;
+	unsigned		should_wakeup:1;
 	bool			sleeping:1;	/* Owned by the PM core */
 #ifdef	CONFIG_PM_SLEEP
-	unsigned		should_wakeup:1;
 	struct list_head	entry;
 #endif
 };
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
