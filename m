From: akpm@linux-foundation.org
Subject: [folded] w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support-v3-fix.patch removed from -mm tree
Date: Thu, 26 May 2011 16:20:17 -0700
Message-ID: <201105262320.p4QNKHZB026555@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42963 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754820Ab1EZXUe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 May 2011 19:20:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cabarnes@indesign-llc.com, haojian.zhuang@gmail.com, johnpol@2ka.mipt.ru, ryan@bluewatersys.com, mm-commits@vger.kernel.org


The patch titled
     w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support-v3-fix
has been removed from the -mm tree.  Its filename was
     w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support-v3-fix.patch

This patch was dropped because it was folded into w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support-v3-fix
From: Andrew Morton <akpm@linux-foundation.org>

use min_t()

Cc: Clifton Barnes <cabarnes@indesign-llc.com>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Ryan Mallon <ryan@bluewatersys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/power/ds2780_battery.c |    8 ++++----
 drivers/w1/slaves/w1_ds2780.c  |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/power/ds2780_battery.c~w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support-v3-fix drivers/power/ds2780_battery.c
--- a/drivers/power/ds2780_battery.c~w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support-v3-fix
+++ a/drivers/power/ds2780_battery.c
@@ -628,7 +628,7 @@ static ssize_t ds2780_read_param_eeprom_
 	struct power_supply *psy = to_power_supply(dev);
 	struct ds2780_device_info *dev_info = to_ds2780_device_info(psy);
 
-	count = min((loff_t)count,
+	count = min_t(loff_t, count,
 		DS2780_EEPROM_BLOCK1_END -
 		DS2780_EEPROM_BLOCK1_START + 1 - off);
 
@@ -646,7 +646,7 @@ static ssize_t ds2780_write_param_eeprom
 	struct ds2780_device_info *dev_info = to_ds2780_device_info(psy);
 	int ret;
 
-	count = min((loff_t)count,
+	count = min_t(loff_t, count,
 		DS2780_EEPROM_BLOCK1_END -
 		DS2780_EEPROM_BLOCK1_START + 1 - off);
 
@@ -681,7 +681,7 @@ static ssize_t ds2780_read_user_eeprom_b
 	struct power_supply *psy = to_power_supply(dev);
 	struct ds2780_device_info *dev_info = to_ds2780_device_info(psy);
 
-	count = min((loff_t)count,
+	count = min_t(loff_t, count,
 		DS2780_EEPROM_BLOCK0_END -
 		DS2780_EEPROM_BLOCK0_START + 1 - off);
 
@@ -700,7 +700,7 @@ static ssize_t ds2780_write_user_eeprom_
 	struct ds2780_device_info *dev_info = to_ds2780_device_info(psy);
 	int ret;
 
-	count = min((loff_t)count,
+	count = min_t(loff_t, count,
 		DS2780_EEPROM_BLOCK0_END -
 		DS2780_EEPROM_BLOCK0_START + 1 - off);
 
diff -puN drivers/w1/slaves/w1_ds2780.c~w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support-v3-fix drivers/w1/slaves/w1_ds2780.c
--- a/drivers/w1/slaves/w1_ds2780.c~w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support-v3-fix
+++ a/drivers/w1/slaves/w1_ds2780.c
@@ -40,7 +40,7 @@ int w1_ds2780_io(struct device *dev, cha
 		count = 0;
 		goto out;
 	}
-	count = min((int)count, DS2780_DATA_SIZE - addr);
+	count = min_t(int, count, DS2780_DATA_SIZE - addr);
 
 	if (w1_reset_select_slave(sl) == 0) {
 		if (io) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-video-mb862xx-mb862xxfbdrvc-needs-uaccessh.patch
drivers-bcma-host_pcic-needs-slabh.patch
include-linux-hugetlbh-needs-mm_typesh.patch
drivers-rtc-rtc-mrstc-use-release_mem_region-after-request_mem_region.patch
drivers-rtc-rtc-mxcc-remove-defines-already-included-in-rtch.patch
ufs-truncated-values-handling-64-bit-metadata.patch
documentation-accounting-getdelaysc-handle-sendto-failures.patch
documentation-configfs-examples-crash-fix.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-reclaim-memory-from-nodes-in-round-robin-order.patch
add-the-pagefault-count-into-memcg-stats.patch
fs-partitions-efic-corrupted-guid-partition-tables-can-cause-kernel-oops.patch
kernel-profilec-remove-some-duplicate-code-from-profile_hits-fix.patch
w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support.patch

