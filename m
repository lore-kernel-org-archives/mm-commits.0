From: akpm@linux-foundation.org
Subject: [merged] drivers-power-ds2780_batteryc-fix-deadlock-upon-insertion-and-removal.patch removed from -mm tree
Date: Mon, 07 Nov 2011 12:29:40 -0800
Message-ID: <201111072029.pA7KTeZe022023@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:47740 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab1KGU3x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2011 15:29:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cabarnes@indesign-llc.com, stable@kernel.org, stable@vger.kernel.org, zbr@ioremap.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/power/ds2780_battery.c: fix deadlock upon insertion and removal
has been removed from the -mm tree.  Its filename was
     drivers-power-ds2780_batteryc-fix-deadlock-upon-insertion-and-removal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Clifton Barnes <cabarnes@indesign-llc.com>
Subject: drivers/power/ds2780_battery.c: fix deadlock upon insertion and removal

Fixes the deadlock when inserting and removing the ds2780.

Signed-off-by: Clifton Barnes <cabarnes@indesign-llc.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: <stable@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/power/ds2780_battery.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN drivers/power/ds2780_battery.c~drivers-power-ds2780_batteryc-fix-deadlock-upon-insertion-and-removal drivers/power/ds2780_battery.c
--- a/drivers/power/ds2780_battery.c~drivers-power-ds2780_batteryc-fix-deadlock-upon-insertion-and-removal
+++ a/drivers/power/ds2780_battery.c
@@ -39,6 +39,7 @@ struct ds2780_device_info {
 	struct device *dev;
 	struct power_supply bat;
 	struct device *w1_dev;
+	struct task_struct *mutex_holder;
 };
 
 enum current_types {
@@ -63,6 +64,9 @@ static inline struct power_supply *to_po
 static inline int ds2780_battery_io(struct ds2780_device_info *dev_info,
 	char *buf, int addr, size_t count, int io)
 {
+	if (dev_info->mutex_holder == current)
+		return w1_ds2780_io_nolock(dev_info->w1_dev, buf, addr, count, io);
+	else
 		return w1_ds2780_io(dev_info->w1_dev, buf, addr, count, io);
 }
 
@@ -775,6 +779,7 @@ static int __devinit ds2780_battery_prob
 	dev_info->bat.properties	= ds2780_battery_props;
 	dev_info->bat.num_properties	= ARRAY_SIZE(ds2780_battery_props);
 	dev_info->bat.get_property	= ds2780_battery_get_property;
+	dev_info->mutex_holder		= current;
 
 	ret = power_supply_register(&pdev->dev, &dev_info->bat);
 	if (ret) {
@@ -804,6 +809,8 @@ static int __devinit ds2780_battery_prob
 		goto fail_remove_bin_file;
 	}
 
+	dev_info->mutex_holder = NULL;
+
 	return 0;
 
 fail_remove_bin_file:
@@ -823,6 +830,8 @@ static int __devexit ds2780_battery_remo
 {
 	struct ds2780_device_info *dev_info = platform_get_drvdata(pdev);
 
+	dev_info->mutex_holder = current;
+
 	/* remove attributes */
 	sysfs_remove_group(&dev_info->bat.dev->kobj, &ds2780_attr_group);
 
_

Patches currently in -mm which might be from cabarnes@indesign-llc.com are

origin.patch
linux-next.patch

