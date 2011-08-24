From: akpm@linux-foundation.org
Subject: + drivers-power-ds2780_batteryc-fix-deadlock-upon-insertion-and-removal.patch added to -mm tree
Date: Wed, 24 Aug 2011 11:51:06 -0700
Message-ID: <201108241851.p7OIp67H032566@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33844 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753752Ab1HXSvS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Aug 2011 14:51:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cabarnes@indesign-llc.com, zbr@ioremap.net


The patch titled
     drivers/power/ds2780_battery.c: fix deadlock upon insertion and removal
has been added to the -mm tree.  Its filename is
     drivers-power-ds2780_batteryc-fix-deadlock-upon-insertion-and-removal.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/power/ds2780_battery.c: fix deadlock upon insertion and removal
From: Clifton Barnes <cabarnes@indesign-llc.com>

Fixes the deadlock when inserting and removing the ds2780.

Signed-off-by: Clifton Barnes <cabarnes@indesign-llc.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
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

linux-next.patch
w1-ds2760-and-ds2780-use-ida-for-id-and-ida_simple_get-to-get-it.patch
drivers-power-ds2780_batteryc-create-central-point-for-calling-w1-interface.patch
drivers-power-ds2780_batteryc-add-a-nolock-function-to-w1-interface.patch
drivers-power-ds2780_batteryc-fix-deadlock-upon-insertion-and-removal.patch

