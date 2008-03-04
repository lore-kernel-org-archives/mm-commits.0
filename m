From: akpm@linux-foundation.org
Subject: - device-core-remove-dpm_sysfs_remove-from-error-path-of-device_add.patch removed from -mm tree
Date: Tue, 04 Mar 2008 12:10:21 -0800
Message-ID: <200803042010.m24KALS2026901@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47659 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751722AbYCDUTC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2008 15:19:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     Device core: Remove dpm_sysfs_remove() from error path of device_add()
has been removed from the -mm tree.  Its filename was
     device-core-remove-dpm_sysfs_remove-from-error-path-of-device_add.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
acpi-ec-fix-regression.patch
time-dont-touch-an-offlined-cpus-ts-tick_stopped-in-tick_cancel_sched_timer.patch
shrink_slab-handle-bad-shrinkers.patch

