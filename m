From: akpm@linux-foundation.org
Subject: - pm-convert-wakeup-flag-accessors-to-inline-functions.patch removed from -mm tree
Date: Wed, 19 Mar 2008 11:46:56 -0700
Message-ID: <200803191846.m2JIku8b028645@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40479 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754127AbYCSTeD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Mar 2008 15:34:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stern@rowland.harvard.edu, greg@kroah.com, lenb@kernel.org, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     pm: convert wakeup flag accessors to inline functions
has been removed from the -mm tree.  Its filename was
     pm-convert-wakeup-flag-accessors-to-inline-functions.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pm: convert wakeup flag accessors to inline functions
From: Alan Stern <stern@rowland.harvard.edu>

This patch (as1058) improves the wakeup macros in include/linux/pm.h.  All but
the trivial ones are converted to inline routines, which requires moving them
to a separate header file since they depend on the definition of struct
device.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/device.h    |    3 +
 include/linux/pm.h        |   46 ------------------
 include/linux/pm_wakeup.h |   90 ++++++++++++++++++++++++++++++++++++
 3 files changed, 94 insertions(+), 45 deletions(-)

diff -puN include/linux/device.h~pm-convert-wakeup-flag-accessors-to-inline-functions include/linux/device.h
--- a/include/linux/device.h~pm-convert-wakeup-flag-accessors-to-inline-functions
+++ a/include/linux/device.h
@@ -377,6 +377,9 @@ struct device {
 	void	(*release)(struct device *dev);
 };
 
+/* Get the wakeup routines, which depend on struct device */
+#include <linux/pm_wakeup.h>
+
 #ifdef CONFIG_NUMA
 static inline int dev_to_node(struct device *dev)
 {
diff -puN include/linux/pm.h~pm-convert-wakeup-flag-accessors-to-inline-functions include/linux/pm.h
--- a/include/linux/pm.h~pm-convert-wakeup-flag-accessors-to-inline-functions
+++ a/include/linux/pm.h
@@ -212,54 +212,10 @@ static inline int device_suspend(pm_mess
 	return 0;
 }
 
-#define suspend_report_result(fn, ret) do { } while (0)
+#define suspend_report_result(fn, ret)		do {} while (0)
 
 #endif /* !CONFIG_PM_SLEEP */
 
-#ifdef CONFIG_PM
-
-#define device_set_wakeup_enable(dev,val) \
-	((dev)->power.should_wakeup = !!(val))
-#define device_may_wakeup(dev) \
-	(device_can_wakeup(dev) && (dev)->power.should_wakeup)
-
-/*
- * Platform hook to activate device wakeup capability, if that's not already
- * handled by enable_irq_wake() etc.
- * Returns zero on success, else negative errno
- */
-extern int (*platform_enable_wakeup)(struct device *dev, int is_on);
-
-static inline int call_platform_enable_wakeup(struct device *dev, int is_on)
-{
-	if (platform_enable_wakeup)
-		return (*platform_enable_wakeup)(dev, is_on);
-	return 0;
-}
-
-#else /* !CONFIG_PM */
-
-#define device_set_wakeup_enable(dev,val)	do{}while(0)
-#define device_may_wakeup(dev)			(0)
-
-static inline int call_platform_enable_wakeup(struct device *dev, int is_on)
-{
-	return 0;
-}
-
-#endif /* !CONFIG_PM */
-
-/* changes to device_may_wakeup take effect on the next pm state change.
- * by default, devices should wakeup if they can.
- */
-#define device_can_wakeup(dev) \
-	((dev)->power.can_wakeup)
-#define device_init_wakeup(dev,val) \
-	do { \
-		device_can_wakeup(dev) = !!(val); \
-		device_set_wakeup_enable(dev,val); \
-	} while(0)
-
 /*
  * Global Power Management flags
  * Used to keep APM and ACPI from both being active
diff -puN /dev/null include/linux/pm_wakeup.h
--- /dev/null
+++ a/include/linux/pm_wakeup.h
@@ -0,0 +1,90 @@
+/*
+ *  pm_wakeup.h - Power management wakeup interface
+ *
+ *  Copyright (C) 2008 Alan Stern
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#ifndef _LINUX_PM_WAKEUP_H
+#define _LINUX_PM_WAKEUP_H
+
+#ifndef _DEVICE_H_
+# error "please don't include this file directly"
+#endif
+
+#ifdef CONFIG_PM
+
+/* changes to device_may_wakeup take effect on the next pm state change.
+ * by default, devices should wakeup if they can.
+ */
+static inline void device_init_wakeup(struct device *dev, int val)
+{
+	dev->power.can_wakeup = dev->power.should_wakeup = !!val;
+}
+
+static inline int device_can_wakeup(struct device *dev)
+{
+	return dev->power.can_wakeup;
+}
+
+static inline void device_set_wakeup_enable(struct device *dev, int val)
+{
+	dev->power.should_wakeup = !!val;
+}
+
+static inline int device_may_wakeup(struct device *dev)
+{
+	return dev->power.can_wakeup & dev->power.should_wakeup;
+}
+
+/*
+ * Platform hook to activate device wakeup capability, if that's not already
+ * handled by enable_irq_wake() etc.
+ * Returns zero on success, else negative errno
+ */
+extern int (*platform_enable_wakeup)(struct device *dev, int is_on);
+
+static inline int call_platform_enable_wakeup(struct device *dev, int is_on)
+{
+	if (platform_enable_wakeup)
+		return (*platform_enable_wakeup)(dev, is_on);
+	return 0;
+}
+
+#else /* !CONFIG_PM */
+
+/* For some reason the next two routines work even without CONFIG_PM */
+static inline void device_init_wakeup(struct device *dev, int val)
+{
+	dev->power.can_wakeup = !!val;
+}
+
+static inline int device_can_wakeup(struct device *dev)
+{
+	return dev->power.can_wakeup;
+}
+
+#define device_set_wakeup_enable(dev, val)	do {} while (0)
+#define device_may_wakeup(dev)			0
+
+static inline int call_platform_enable_wakeup(struct device *dev, int is_on)
+{
+	return 0;
+}
+
+#endif /* !CONFIG_PM */
+
+#endif /* _LINUX_PM_WAKEUP_H */
_

Patches currently in -mm which might be from stern@rowland.harvard.edu are

revert-gregkh-driver-pm-make-wakeup-flags-available-whenever-config_pm-is-set.patch
pm-convert-wakeup-flag-accessors-to-inline-functions.patch
pm-convert-wakeup-flag-accessors-to-inline-functions-fix.patch
isd200-fix-memory-leak-in-isd200_get_inquiry_data.patch

