From: akpm@linux-foundation.org
Subject: + pm-remove-deprecated-dpm_runtime_-routines.patch added to -mm tree
Date: Thu, 12 Jul 2007 14:14:26 -0700
Message-ID: <200707122114.l6CLEQ9D003591@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60250 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932443AbXGLVOt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jul 2007 17:14:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stern@rowland.harvard.edu, greg@kroah.com, linux@dominikbrodowski.net, nigel@nigel.suspend2.net, pavel@ucw.cz, rjw@sisk.pl


The patch titled
     PM: remove deprecated dpm_runtime_* routines
has been added to the -mm tree.  Its filename is
     pm-remove-deprecated-dpm_runtime_-routines.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PM: remove deprecated dpm_runtime_* routines
From: Alan Stern <stern@rowland.harvard.edu>

This patch (as933) removes the deprecated dpm_runtime_suspend() and
dpm_runtime_resume() routines from the PM core.  The only user of
those routines is the PCMCIA ds driver; local replacements are added.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/feature-removal-schedule.txt |    1 
 drivers/base/power/Makefile                |    2 
 drivers/base/power/power.h                 |    5 -
 drivers/base/power/runtime.c               |   85 -------------------
 drivers/pcmcia/ds.c                        |   40 +++++++-
 include/linux/pm.h                         |   11 --
 6 files changed, 35 insertions(+), 109 deletions(-)

diff -puN Documentation/feature-removal-schedule.txt~pm-remove-deprecated-dpm_runtime_-routines Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~pm-remove-deprecated-dpm_runtime_-routines
+++ a/Documentation/feature-removal-schedule.txt
@@ -27,7 +27,6 @@ Who:	Hans Verkuil <hverkuil@xs4all.nl> a
 ---------------------------
 
 What:	dev->power.power_state
-	dpm_runtime_{suspend,resume)()
 When:	July 2007
 Why:	Broken design for runtime control over driver power states, confusing
 	driver-internal runtime power management with:  mechanisms to support
diff -puN drivers/base/power/Makefile~pm-remove-deprecated-dpm_runtime_-routines drivers/base/power/Makefile
--- a/drivers/base/power/Makefile~pm-remove-deprecated-dpm_runtime_-routines
+++ a/drivers/base/power/Makefile
@@ -1,5 +1,5 @@
 obj-y			:= shutdown.o
-obj-$(CONFIG_PM)	+= main.o suspend.o resume.o runtime.o sysfs.o
+obj-$(CONFIG_PM)	+= main.o suspend.o resume.o sysfs.o
 obj-$(CONFIG_PM_TRACE)	+= trace.o
 
 ifeq ($(CONFIG_DEBUG_DRIVER),y)
diff -puN drivers/base/power/power.h~pm-remove-deprecated-dpm_runtime_-routines drivers/base/power/power.h
--- a/drivers/base/power/power.h~pm-remove-deprecated-dpm_runtime_-routines
+++ a/drivers/base/power/power.h
@@ -62,11 +62,6 @@ extern int resume_device(struct device *
  */
 extern int suspend_device(struct device *, pm_message_t);
 
-
-/*
- * runtime.c
- */
-
 #else /* CONFIG_PM */
 
 
diff -puN drivers/base/power/runtime.c~pm-remove-deprecated-dpm_runtime_-routines /dev/null
--- a/drivers/base/power/runtime.c
+++ /dev/null
@@ -1,85 +0,0 @@
-/*
- * drivers/base/power/runtime.c - Handling dynamic device power management.
- *
- * Copyright (c) 2003 Patrick Mochel
- * Copyright (c) 2003 Open Source Development Lab
- *
- */
-
-#include <linux/device.h>
-#include "power.h"
-
-
-static void runtime_resume(struct device * dev)
-{
-	dev_dbg(dev, "resuming\n");
-	if (!dev->power.power_state.event)
-		return;
-	if (!resume_device(dev))
-		dev->power.power_state = PMSG_ON;
-}
-
-
-/**
- *	dpm_runtime_resume - Power one device back on.
- *	@dev:	Device.
- *
- *	Bring one device back to the on state by first powering it
- *	on, then restoring state. We only operate on devices that aren't
- *	already on.
- *	FIXME: We need to handle devices that are in an unknown state.
- */
-
-void dpm_runtime_resume(struct device * dev)
-{
-	mutex_lock(&dpm_mtx);
-	runtime_resume(dev);
-	mutex_unlock(&dpm_mtx);
-}
-EXPORT_SYMBOL(dpm_runtime_resume);
-
-
-/**
- *	dpm_runtime_suspend - Put one device in low-power state.
- *	@dev:	Device.
- *	@state:	State to enter.
- */
-
-int dpm_runtime_suspend(struct device * dev, pm_message_t state)
-{
-	int error = 0;
-
-	mutex_lock(&dpm_mtx);
-	if (dev->power.power_state.event == state.event)
-		goto Done;
-
-	if (dev->power.power_state.event)
-		runtime_resume(dev);
-
-	if (!(error = suspend_device(dev, state)))
-		dev->power.power_state = state;
- Done:
-	mutex_unlock(&dpm_mtx);
-	return error;
-}
-EXPORT_SYMBOL(dpm_runtime_suspend);
-
-
-#if 0
-/**
- *	dpm_set_power_state - Update power_state field.
- *	@dev:	Device.
- *	@state:	Power state device is in.
- *
- *	This is an update mechanism for drivers to notify the core
- *	what power state a device is in. Device probing code may not
- *	always be able to tell, but we need accurate information to
- *	work reliably.
- */
-void dpm_set_power_state(struct device * dev, pm_message_t state)
-{
-	mutex_lock(&dpm_mtx);
-	dev->power.power_state = state;
-	mutex_unlock(&dpm_mtx);
-}
-#endif  /*  0  */
diff -puN drivers/pcmcia/ds.c~pm-remove-deprecated-dpm_runtime_-routines drivers/pcmcia/ds.c
--- a/drivers/pcmcia/ds.c~pm-remove-deprecated-dpm_runtime_-routines
+++ a/drivers/pcmcia/ds.c
@@ -1118,6 +1118,34 @@ static int pcmcia_bus_uevent(struct devi
 
 #endif
 
+/************************ runtime PM support ***************************/
+
+static int pcmcia_dev_suspend(struct device *dev, pm_message_t state);
+static int pcmcia_dev_resume(struct device *dev);
+
+static int runtime_suspend(struct device *dev)
+{
+	int rc;
+
+	down(&dev->sem);
+	rc = pcmcia_dev_suspend(dev, PMSG_SUSPEND);
+	up(&dev->sem);
+	if (!rc)
+		dev->power.power_state.event = PM_EVENT_SUSPEND;
+	return rc;
+}
+
+static void runtime_resume(struct device *dev)
+{
+	int rc;
+
+	down(&dev->sem);
+	rc = pcmcia_dev_resume(dev);
+	up(&dev->sem);
+	if (!rc)
+		dev->power.power_state.event = PM_EVENT_ON;
+}
+
 /************************ per-device sysfs output ***************************/
 
 #define pcmcia_device_attr(field, test, format)				\
@@ -1164,9 +1192,9 @@ static ssize_t pcmcia_store_pm_state(str
                 return -EINVAL;
 
 	if ((!p_dev->suspended) && !strncmp(buf, "off", 3))
-		ret = dpm_runtime_suspend(dev, PMSG_SUSPEND);
+		ret = runtime_suspend(dev);
 	else if (p_dev->suspended && !strncmp(buf, "on", 2))
-		dpm_runtime_resume(dev);
+		runtime_resume(dev);
 
 	return ret ? ret : count;
 }
@@ -1305,10 +1333,10 @@ static int pcmcia_bus_suspend_callback(s
 	struct pcmcia_socket *skt = _data;
 	struct pcmcia_device *p_dev = to_pcmcia_dev(dev);
 
-	if (p_dev->socket != skt)
+	if (p_dev->socket != skt || p_dev->suspended)
 		return 0;
 
-	return dpm_runtime_suspend(dev, PMSG_SUSPEND);
+	return runtime_suspend(dev);
 }
 
 static int pcmcia_bus_resume_callback(struct device *dev, void * _data)
@@ -1316,10 +1344,10 @@ static int pcmcia_bus_resume_callback(st
 	struct pcmcia_socket *skt = _data;
 	struct pcmcia_device *p_dev = to_pcmcia_dev(dev);
 
-	if (p_dev->socket != skt)
+	if (p_dev->socket != skt || !p_dev->suspended)
 		return 0;
 
-	dpm_runtime_resume(dev);
+	runtime_resume(dev);
 
 	return 0;
 }
diff -puN include/linux/pm.h~pm-remove-deprecated-dpm_runtime_-routines include/linux/pm.h
--- a/include/linux/pm.h~pm-remove-deprecated-dpm_runtime_-routines
+++ a/include/linux/pm.h
@@ -285,8 +285,6 @@ extern int device_prepare_suspend(pm_mes
 #define device_may_wakeup(dev) \
 	(device_can_wakeup(dev) && (dev)->power.should_wakeup)
 
-extern int dpm_runtime_suspend(struct device *, pm_message_t);
-extern void dpm_runtime_resume(struct device *);
 extern void __suspend_report_result(const char *function, void *fn, int ret);
 
 #define suspend_report_result(fn, ret)					\
@@ -318,15 +316,6 @@ static inline int device_suspend(pm_mess
 #define device_set_wakeup_enable(dev,val)	do{}while(0)
 #define device_may_wakeup(dev)			(0)
 
-static inline int dpm_runtime_suspend(struct device * dev, pm_message_t state)
-{
-	return 0;
-}
-
-static inline void dpm_runtime_resume(struct device * dev)
-{
-}
-
 #define suspend_report_result(fn, ret) do { } while (0)
 
 static inline int call_platform_enable_wakeup(struct device *dev, int is_on)
_

Patches currently in -mm which might be from stern@rowland.harvard.edu are

origin.patch
make-alt-sysrq-p-display-the-debug-register-contents.patch
freezer-run-show_state-when-freezing-times-out.patch
pm-remove-deprecated-sysfs-files.patch
pm-remove-deprecated-dpm_runtime_-routines.patch
