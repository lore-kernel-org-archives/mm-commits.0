From: akpm@linux-foundation.org
Subject: + pm-remove-deprecated-sysfs-files.patch added to -mm tree
Date: Thu, 12 Jul 2007 14:14:24 -0700
Message-ID: <200707122114.l6CLEOQj003588@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44478 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935383AbXGLVOt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jul 2007 17:14:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stern@rowland.harvard.edu, greg@kroah.com, linux@dominikbrodowski.net, nigel@nigel.suspend2.net, pavel@ucw.cz, rjw@sisk.pl


The patch titled
     PM: remove deprecated sysfs files
has been added to the -mm tree.  Its filename is
     pm-remove-deprecated-sysfs-files.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PM: remove deprecated sysfs files
From: Alan Stern <stern@rowland.harvard.edu>

This patch (as932) removes the deprecated sysfs .../power/state
attribute files.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/feature-removal-schedule.txt |    3 
 drivers/base/power/sysfs.c                 |   66 -------------------
 kernel/power/Kconfig                       |   12 ---
 3 files changed, 1 insertion(+), 80 deletions(-)

diff -puN Documentation/feature-removal-schedule.txt~pm-remove-deprecated-sysfs-files Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~pm-remove-deprecated-sysfs-files
+++ a/Documentation/feature-removal-schedule.txt
@@ -26,8 +26,7 @@ Who:	Hans Verkuil <hverkuil@xs4all.nl> a
 
 ---------------------------
 
-What:	/sys/devices/.../power/state
-	dev->power.power_state
+What:	dev->power.power_state
 	dpm_runtime_{suspend,resume)()
 When:	July 2007
 Why:	Broken design for runtime control over driver power states, confusing
diff -puN drivers/base/power/sysfs.c~pm-remove-deprecated-sysfs-files drivers/base/power/sysfs.c
--- a/drivers/base/power/sysfs.c~pm-remove-deprecated-sysfs-files
+++ a/drivers/base/power/sysfs.c
@@ -7,69 +7,6 @@
 #include "power.h"
 
 
-#ifdef	CONFIG_PM_SYSFS_DEPRECATED
-
-/**
- *	state - Control current power state of device
- *
- *	show() returns the current power state of the device. '0' indicates
- *	the device is on. Other values (2) indicate the device is in some low
- *	power state.
- *
- *	store() sets the current power state, which is an integer valued
- *	0, 2, or 3.  Devices with bus.suspend_late(), or bus.resume_early()
- *	methods fail this operation; those methods couldn't be called.
- *	Otherwise,
- *
- *	- If the recorded dev->power.power_state.event matches the
- *	  target value, nothing is done.
- *	- If the recorded event code is nonzero, the device is reactivated
- *	  by calling bus.resume() and/or class.resume().
- *	- If the target value is nonzero, the device is suspended by
- *	  calling class.suspend() and/or bus.suspend() with event code
- *	  PM_EVENT_SUSPEND.
- *
- *	This mechanism is DEPRECATED and should only be used for testing.
- */
-
-static ssize_t state_show(struct device * dev, struct device_attribute *attr, char * buf)
-{
-	if (dev->power.power_state.event)
-		return sprintf(buf, "2\n");
-	else
-		return sprintf(buf, "0\n");
-}
-
-static ssize_t state_store(struct device * dev, struct device_attribute *attr, const char * buf, size_t n)
-{
-	pm_message_t state;
-	int error = -EINVAL;
-
-	/* disallow incomplete suspend sequences */
-	if (dev->bus && (dev->bus->suspend_late || dev->bus->resume_early))
-		return error;
-
-	state.event = PM_EVENT_SUSPEND;
-	/* Older apps expected to write "3" here - confused with PCI D3 */
-	if ((n == 1) && !strcmp(buf, "3"))
-		error = dpm_runtime_suspend(dev, state);
-
-	if ((n == 1) && !strcmp(buf, "2"))
-		error = dpm_runtime_suspend(dev, state);
-
-	if ((n == 1) && !strcmp(buf, "0")) {
-		dpm_runtime_resume(dev);
-		error = 0;
-	}
-
-	return error ? error : n;
-}
-
-static DEVICE_ATTR(state, 0644, state_show, state_store);
-
-
-#endif	/* CONFIG_PM_SYSFS_DEPRECATED */
-
 /*
  *	wakeup - Report/change current wakeup option for device
  *
@@ -143,9 +80,6 @@ static DEVICE_ATTR(wakeup, 0644, wake_sh
 
 
 static struct attribute * power_attrs[] = {
-#ifdef	CONFIG_PM_SYSFS_DEPRECATED
-	&dev_attr_state.attr,
-#endif
 	&dev_attr_wakeup.attr,
 	NULL,
 };
diff -puN kernel/power/Kconfig~pm-remove-deprecated-sysfs-files kernel/power/Kconfig
--- a/kernel/power/Kconfig~pm-remove-deprecated-sysfs-files
+++ a/kernel/power/Kconfig
@@ -72,18 +72,6 @@ config PM_TRACE
 	CAUTION: this option will cause your machine's real-time clock to be
 	set to an invalid time after a resume.
 
-config PM_SYSFS_DEPRECATED
-	bool "Driver model /sys/devices/.../power/state files (DEPRECATED)"
-	depends on PM && SYSFS
-	default n
-	help
-	  The driver model started out with a sysfs file intended to provide
-	  a userspace hook for device power management.  This feature has never
-	  worked very well, except for limited testing purposes, and so it will
-	  be removed.   It's not clear that a generic mechanism could really
-	  handle the wide variability of device power states; any replacements
-	  are likely to be bus or driver specific.
-
 config SOFTWARE_SUSPEND
 	bool "Software Suspend (Hibernation)"
 	depends on PM && SWAP && (((X86 || PPC64_SWSUSP) && (!SMP || SUSPEND_SMP)) || ((FRV || PPC32) && !SMP))
_

Patches currently in -mm which might be from stern@rowland.harvard.edu are

origin.patch
make-alt-sysrq-p-display-the-debug-register-contents.patch
freezer-run-show_state-when-freezing-times-out.patch
pm-remove-deprecated-sysfs-files.patch
pm-remove-deprecated-dpm_runtime_-routines.patch
