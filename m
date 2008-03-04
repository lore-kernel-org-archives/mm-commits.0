From: akpm@linux-foundation.org
Subject: + device-core-remove-dpm_sysfs_remove-from-error-path-of-device_add.patch added to -mm tree
Date: Tue, 04 Mar 2008 11:44:59 -0800
Message-ID: <200803041944.m24Jixb0025532@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45730 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758662AbYCDTp2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2008 14:45:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, greg@kroah.com


The patch titled
     Device core: Remove dpm_sysfs_remove() from error path of device_add()
has been added to the -mm tree.  Its filename is
     device-core-remove-dpm_sysfs_remove-from-error-path-of-device_add.patch

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
Subject: Device core: Remove dpm_sysfs_remove() from error path of device_add()
From: Rafael J. Wysocki <rjw@sisk.pl>

Since device_pm_remove(dev) calls dpm_sysfs_remove(dev), it's incorrect to
call the latter after the former in the device_add() error path.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/core.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/base/core.c~device-core-remove-dpm_sysfs_remove-from-error-path-of-device_add drivers/base/core.c
--- a/drivers/base/core.c~device-core-remove-dpm_sysfs_remove-from-error-path-of-device_add
+++ a/drivers/base/core.c
@@ -845,7 +845,6 @@ int device_add(struct device *dev)
 	return error;
  BusError:
 	device_pm_remove(dev);
-	dpm_sysfs_remove(dev);
  PMError:
 	if (dev->bus)
 		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
git-acpi.patch
acpi-thinkpad-acpi-fix-hotkey_get_tablet_mode.patch
pm-do-not-acquire-device-semaphores-upfront-during-suspend.patch
pm-do-not-acquire-device-semaphores-upfront-during-suspend-fix.patch
acpi-ec-fix-regression.patch
time-dont-touch-an-offlined-cpus-ts-tick_stopped-in-tick_cancel_sched_timer.patch
device-core-remove-dpm_sysfs_remove-from-error-path-of-device_add.patch
shrink_slab-handle-bad-shrinkers.patch

