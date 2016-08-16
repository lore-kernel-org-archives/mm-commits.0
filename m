From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Tue, 16 Aug 2016 10:46:37 -0700
Message-ID: <57b3517d.oxfMIyUJDKC0YGSy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60760 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbcHPRr3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Aug 2016 13:47:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/thermal/thermal_core.c |   69 -------------------------------
 1 file changed, 69 deletions(-)

diff -puN drivers/thermal/thermal_core.c~linux-next-git-rejects drivers/thermal/thermal_core.c
--- a/drivers/thermal/thermal_core.c~linux-next-git-rejects
+++ a/drivers/thermal/thermal_core.c
@@ -1122,80 +1122,11 @@ static void bind_tz(struct thermal_zone_
 	struct thermal_cooling_device *pos = NULL;
 	const struct thermal_zone_params *tzp = tz->tzp;
 
-<<<<<<< HEAD
-	mutex_lock(&cdev->lock);
-	/* cooling device is updated*/
-	if (cdev->updated) {
-		mutex_unlock(&cdev->lock);
-=======
 	if (!tzp && !tz->ops->bind)
->>>>>>> linux-next/akpm-base
 		return;
 	}
 
-<<<<<<< HEAD
-	/* Make sure cdev enters the deepest cooling state */
-	list_for_each_entry(instance, &cdev->thermal_instances, cdev_node) {
-		dev_dbg(&cdev->device, "zone%d->target=%lu\n",
-				instance->tz->id, instance->target);
-		if (instance->target == THERMAL_NO_TARGET)
-			continue;
-		if (instance->target > target)
-			target = instance->target;
-	}
-	cdev->ops->set_cur_state(cdev, target);
-	cdev->updated = true;
-	mutex_unlock(&cdev->lock);
-	trace_cdev_update(cdev, target);
-	dev_dbg(&cdev->device, "set to state %lu\n", target);
-}
-EXPORT_SYMBOL(thermal_cdev_update);
-
-/**
- * thermal_notify_framework - Sensor drivers use this API to notify framework
- * @tz:		thermal zone device
- * @trip:	indicates which trip point has been crossed
- *
- * This function handles the trip events from sensor drivers. It starts
- * throttling the cooling devices according to the policy configured.
- * For CRITICAL and HOT trip points, this notifies the respective drivers,
- * and does actual throttling for other trip points i.e ACTIVE and PASSIVE.
- * The throttling policy is based on the configured platform data; if no
- * platform data is provided, this uses the step_wise throttling policy.
- */
-void thermal_notify_framework(struct thermal_zone_device *tz, int trip)
-{
-	handle_thermal_trip(tz, trip);
-}
-EXPORT_SYMBOL_GPL(thermal_notify_framework);
-
-/**
- * create_trip_attrs() - create attributes for trip points
- * @tz:		the thermal zone device
- * @mask:	Writeable trip point bitmap.
- *
- * helper function to instantiate sysfs entries for every trip
- * point and its properties of a struct thermal_zone_device.
- *
- * Return: 0 on success, the proper error value otherwise.
- */
-static int create_trip_attrs(struct thermal_zone_device *tz, int mask)
-{
-	int indx;
-	int size = sizeof(struct thermal_attr) * tz->trips;
-
-	tz->trip_type_attrs = kzalloc(size, GFP_KERNEL);
-	if (!tz->trip_type_attrs)
-		return -ENOMEM;
-
-	tz->trip_temp_attrs = kzalloc(size, GFP_KERNEL);
-	if (!tz->trip_temp_attrs) {
-		kfree(tz->trip_type_attrs);
-		return -ENOMEM;
-	}
-=======
 	mutex_lock(&thermal_list_lock);
->>>>>>> linux-next/akpm-base
 
 	/* If there is ops->bind, try to use ops->bind */
 	if (tz->ops->bind) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-vmalloc-fix-align-value-calculation-error-fix.patch
mm-vmalloc-fix-align-value-calculation-error-v2-fix.patch
mm-vmalloc-fix-align-value-calculation-error-v2-fix-fix.patch
mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions-checkpatch-fixes.patch
seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char-fix.patch
ipc-msg-avoid-waking-sender-upon-full-queue-checkpatch-fixes.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

