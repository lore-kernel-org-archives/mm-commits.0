From: akpm@linux-foundation.org
Subject: + s2ram-warn-when-interrupts-should-be-disabled-but-are-not.patch added to -mm tree
Date: Mon, 14 Apr 2008 23:48:46 -0700
Message-ID: <200804150648.m3F6mkeG015451@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51642 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756855AbYDOGtZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 02:49:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pavel@ucw.cz, greg@kroah.com, pavel@suse.cz, rjw@sisk.pl


The patch titled
     s2ram: warn when interrupts should be disabled but are not
has been added to the -mm tree.  Its filename is
     s2ram-warn-when-interrupts-should-be-disabled-but-are-not.patch

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

git-acpi.patch
git-x86.patch
pm-introduce-new-top-level-suspend-and-hibernation-callbacks.patch
pm-new-suspend-and-hibernation-callbacks-for-platform-bus-type.patch
pm-new-suspend-and-hibernation-callbacks-for-pci-bus-type.patch
s2ram-warn-when-interrupts-should-be-disabled-but-are-not.patch
git-hrt.patch
git-net.patch
hci_usb-do-not-initialize-static-variables-to-0.patch
hci_usb-remove-code-obfuscation.patch
hci_usbh-fix-hard-to-trigger-race.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch-fix.patch

