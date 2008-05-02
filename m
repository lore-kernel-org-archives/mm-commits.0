From: akpm@linux-foundation.org
Subject: - s2ram-warn-when-interrupts-should-be-disabled-but-are-not.patch removed from -mm tree
Date: Fri, 02 May 2008 13:34:23 -0700
Message-ID: <200805022034.m42KYNWq013283@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40816 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935855AbYEBUli (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 16:41:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@ucw.cz, greg@kroah.com, pavel@suse.cz, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     s2ram: warn when interrupts should be disabled but are not
has been removed from the -mm tree.  Its filename was
     s2ram-warn-when-interrupts-should-be-disabled-but-are-not.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: s2ram: warn when interrupts should be disabled but are not
From: Pavel Machek <pavel@ucw.cz>

sysdevs should be suspended/resumed with IRQs disabled; if something
reenables them by mistake, we want to know early.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/sys.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/base/sys.c~s2ram-warn-when-interrupts-should-be-disabled-but-are-not drivers/base/sys.c
--- a/drivers/base/sys.c~s2ram-warn-when-interrupts-should-be-disabled-but-are-not
+++ a/drivers/base/sys.c
@@ -22,6 +22,7 @@
 #include <linux/pm.h>
 #include <linux/device.h>
 #include <linux/mutex.h>
+#include <linux/hardirq.h>
 
 #include "base.h"
 
@@ -383,6 +384,7 @@ int sysdev_suspend(pm_message_t state)
 			/* Call auxillary drivers first */
 			list_for_each_entry(drv, &cls->drivers, entry) {
 				if (drv->suspend) {
+					WARN_ON(!irqs_disabled());
 					ret = drv->suspend(sysdev, state);
 					if (ret)
 						goto aux_driver;
@@ -458,6 +460,7 @@ int sysdev_resume(void)
 		list_for_each_entry(sysdev, &cls->kset.list, kobj.entry) {
 			pr_debug(" %s\n", kobject_name(&sysdev->kobj));
 
+			WARN_ON(!irqs_disabled());
 			__sysdev_resume(sysdev);
 		}
 	}
_

Patches currently in -mm which might be from pavel@ucw.cz are

origin.patch
acpi_pm_device_sleep_state-cleanup.patch
s2ram-warn-when-interrupts-should-be-disabled-but-are-not.patch
hci_usbh-fix-hard-to-trigger-race.patch

