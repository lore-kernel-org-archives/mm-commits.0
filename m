From: akpm@linux-foundation.org
Subject: [merged] power-convert-to-idr_alloc.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:14:57 -0800
Message-ID: <20130228201457.AD7B731C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:44275 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060Ab3B1UO6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:14:58 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so244865ghb.3
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:14:58 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, cbou@mail.ru, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: power: convert to idr_alloc()
has been removed from the -mm tree.  Its filename was
     power-convert-to-idr_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: power: convert to idr_alloc()

Convert to the much saner new idr interface.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Anton Vorontsov <cbou@mail.ru>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/power/bq2415x_charger.c |   11 +++--------
 drivers/power/bq27x00_battery.c |    9 +++------
 drivers/power/ds2782_battery.c  |    9 ++-------
 3 files changed, 8 insertions(+), 21 deletions(-)

diff -puN drivers/power/bq2415x_charger.c~power-convert-to-idr_alloc drivers/power/bq2415x_charger.c
--- a/drivers/power/bq2415x_charger.c~power-convert-to-idr_alloc
+++ a/drivers/power/bq2415x_charger.c
@@ -1515,16 +1515,11 @@ static int bq2415x_probe(struct i2c_clie
 	}
 
 	/* Get new ID for the new device */
-	ret = idr_pre_get(&bq2415x_id, GFP_KERNEL);
-	if (ret == 0)
-		return -ENOMEM;
-
 	mutex_lock(&bq2415x_id_mutex);
-	ret = idr_get_new(&bq2415x_id, client, &num);
+	num = idr_alloc(&bq2415x_id, client, 0, 0, GFP_KERNEL);
 	mutex_unlock(&bq2415x_id_mutex);
-
-	if (ret < 0)
-		return ret;
+	if (num < 0)
+		return num;
 
 	name = kasprintf(GFP_KERNEL, "%s-%d", id->name, num);
 	if (!name) {
diff -puN drivers/power/bq27x00_battery.c~power-convert-to-idr_alloc drivers/power/bq27x00_battery.c
--- a/drivers/power/bq27x00_battery.c~power-convert-to-idr_alloc
+++ a/drivers/power/bq27x00_battery.c
@@ -791,14 +791,11 @@ static int bq27x00_battery_probe(struct 
 	int retval = 0;
 
 	/* Get new ID for the new battery device */
-	retval = idr_pre_get(&battery_id, GFP_KERNEL);
-	if (retval == 0)
-		return -ENOMEM;
 	mutex_lock(&battery_mutex);
-	retval = idr_get_new(&battery_id, client, &num);
+	num = idr_alloc(&battery_id, client, 0, 0, GFP_KERNEL);
 	mutex_unlock(&battery_mutex);
-	if (retval < 0)
-		return retval;
+	if (num < 0)
+		return num;
 
 	name = kasprintf(GFP_KERNEL, "%s-%d", id->name, num);
 	if (!name) {
diff -puN drivers/power/ds2782_battery.c~power-convert-to-idr_alloc drivers/power/ds2782_battery.c
--- a/drivers/power/ds2782_battery.c~power-convert-to-idr_alloc
+++ a/drivers/power/ds2782_battery.c
@@ -395,17 +395,12 @@ static int ds278x_battery_probe(struct i
 	}
 
 	/* Get an ID for this battery */
-	ret = idr_pre_get(&battery_id, GFP_KERNEL);
-	if (ret == 0) {
-		ret = -ENOMEM;
-		goto fail_id;
-	}
-
 	mutex_lock(&battery_lock);
-	ret = idr_get_new(&battery_id, client, &num);
+	ret = idr_alloc(&battery_id, client, 0, 0, GFP_KERNEL);
 	mutex_unlock(&battery_lock);
 	if (ret < 0)
 		goto fail_id;
+	num = ret;
 
 	info = kzalloc(sizeof(*info), GFP_KERNEL);
 	if (!info) {
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
linux-next.patch
slub-correctly-bootstrap-boot-caches.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-factor-out-the-setting-of-pf_dumpcore.patch
freezer-do-not-send-a-fake-signal-to-a-pf_dumpcore-thread.patch
coredump-make-wait_for_dump_helpers-freezable.patch
nfsd-idr_destroy-no-longer-needs-idr_remove_all.patch

