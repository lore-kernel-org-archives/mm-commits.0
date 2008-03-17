From: akpm@linux-foundation.org
Subject: - driver-core-call-device_pm_add-after-bus_add_device-in-device_add.patch removed from -mm tree
Date: Mon, 17 Mar 2008 13:59:42 -0700
Message-ID: <200803172059.m2HKxg9U030770@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57870 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755684AbYCQVBD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 17:01:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, david-b@pacbell.net, greg@kroah.com, pavel@ucw.cz, stern@rowland.harvard.edu, mm-commits@vger.kernel.org


The patch titled
     Driver core: Call device_pm_add() after bus_add_device() in device_add()
has been removed from the -mm tree.  Its filename was
     driver-core-call-device_pm_add-after-bus_add_device-in-device_add.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Driver core: Call device_pm_add() after bus_add_device() in device_add()
From: Rafael J. Wysocki <rjw@sisk.pl>

Include dpm_sysfs_add() into device_pm_add(), in analogy with
device_pm_remove(), and modify device_add() to call the latter after
bus_add_device(), to avoid situations in which the PM core may attempt to
suspend a device the registration of which has not been successful.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: David Brownell <david-b@pacbell.net>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/core.c       |   15 +++++----------
 drivers/base/power/main.c |    4 +++-
 2 files changed, 8 insertions(+), 11 deletions(-)

diff -puN drivers/base/core.c~driver-core-call-device_pm_add-after-bus_add_device-in-device_add drivers/base/core.c
--- a/drivers/base/core.c~driver-core-call-device_pm_add-after-bus_add_device-in-device_add
+++ a/drivers/base/core.c
@@ -818,17 +818,12 @@ int device_add(struct device *dev)
 	error = device_add_attrs(dev);
 	if (error)
 		goto AttrsError;
-	error = dpm_sysfs_add(dev);
-	if (error)
-		goto PMError;
-	error = device_pm_add(dev);
-	if (error) {
-		dpm_sysfs_remove(dev);
-		goto PMError;
-	}
 	error = bus_add_device(dev);
 	if (error)
 		goto BusError;
+	error = device_pm_add(dev);
+	if (error)
+		goto PMError;
 	kobject_uevent(&dev->kobj, KOBJ_ADD);
 	bus_attach_device(dev);
 	if (parent)
@@ -848,9 +843,9 @@ int device_add(struct device *dev)
  Done:
 	put_device(dev);
 	return error;
- BusError:
-	device_pm_remove(dev);
  PMError:
+	bus_remove_device(dev);
+ BusError:
 	if (dev->bus)
 		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
 					     BUS_NOTIFY_DEL_DEVICE, dev);
diff -puN drivers/base/power/main.c~driver-core-call-device_pm_add-after-bus_add_device-in-device_add drivers/base/power/main.c
--- a/drivers/base/power/main.c~driver-core-call-device_pm_add-after-bus_add_device-in-device_add
+++ a/drivers/base/power/main.c
@@ -81,7 +81,9 @@ int device_pm_add(struct device *dev)
 		WARN_ON(true);
 		error = -EBUSY;
 	} else {
-		list_add_tail(&dev->power.entry, &dpm_active);
+		error = dpm_sysfs_add(dev);
+		if (!error)
+			list_add_tail(&dev->power.entry, &dpm_active);
 	}
 	mutex_unlock(&dpm_list_mtx);
 	return error;
_

Patches currently in -mm which might be from rjw@sisk.pl are

git-acpi.patch
pm-remove-legacy-pm.patch
mips-alchemy-crapectomy-after-removal-of-pm_send_all-calls.patch
pm-make-wakeup-flags-available-whenever-config_pm-is-set-checkpatch-fixes.patch
x86-fix-aperture-vs-suspend-problem.patch
x86-fix-aperture-vs-suspend-problem-checkpatch-fixes.patch
revert-pcie-utilize-pcie-transaction-pending-bit.patch
power-replace-remaining-__function__-occurrences.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch.patch
shrink_slab-handle-bad-shrinkers.patch

