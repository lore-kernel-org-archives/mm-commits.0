From: akpm@linux-foundation.org
Subject: - power-replace-remaining-__function__-occurrences.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:38:37 -0700
Message-ID: <200804300538.m3U5cbPr028762@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33470 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754899AbYD3FjH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:39:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, greg@kroah.com, lenb@kernel.org, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     power: replace remaining __FUNCTION__ occurrences
has been removed from the -mm tree.  Its filename was
     power-replace-remaining-__function__-occurrences.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: power: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Greg KH <greg@kroah.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/power/ds2760_battery.c    |    4 ++--
 drivers/power/power_supply_core.c |    6 +++---
 drivers/power/power_supply_leds.c |    4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/power/ds2760_battery.c~power-replace-remaining-__function__-occurrences drivers/power/ds2760_battery.c
--- a/drivers/power/ds2760_battery.c~power-replace-remaining-__function__-occurrences
+++ a/drivers/power/ds2760_battery.c
@@ -262,7 +262,7 @@ static void ds2760_battery_work(struct w
 		struct ds2760_device_info, monitor_work.work);
 	const int interval = HZ * 60;
 
-	dev_dbg(di->dev, "%s\n", __FUNCTION__);
+	dev_dbg(di->dev, "%s\n", __func__);
 
 	ds2760_battery_update_status(di);
 	queue_delayed_work(di->monitor_wqueue, &di->monitor_work, interval);
@@ -275,7 +275,7 @@ static void ds2760_battery_external_powe
 {
 	struct ds2760_device_info *di = to_ds2760_device_info(psy);
 
-	dev_dbg(di->dev, "%s\n", __FUNCTION__);
+	dev_dbg(di->dev, "%s\n", __func__);
 
 	cancel_delayed_work(&di->monitor_work);
 	queue_delayed_work(di->monitor_wqueue, &di->monitor_work, HZ/10);
diff -puN drivers/power/power_supply_core.c~power-replace-remaining-__function__-occurrences drivers/power/power_supply_core.c
--- a/drivers/power/power_supply_core.c~power-replace-remaining-__function__-occurrences
+++ a/drivers/power/power_supply_core.c
@@ -39,7 +39,7 @@ static void power_supply_changed_work(st
 	struct power_supply *psy = container_of(work, struct power_supply,
 						changed_work);
 
-	dev_dbg(psy->dev, "%s\n", __FUNCTION__);
+	dev_dbg(psy->dev, "%s\n", __func__);
 
 	class_for_each_device(power_supply_class, psy,
 			      __power_supply_changed_work);
@@ -51,7 +51,7 @@ static void power_supply_changed_work(st
 
 void power_supply_changed(struct power_supply *psy)
 {
-	dev_dbg(psy->dev, "%s\n", __FUNCTION__);
+	dev_dbg(psy->dev, "%s\n", __func__);
 
 	schedule_work(&psy->changed_work);
 }
@@ -82,7 +82,7 @@ int power_supply_am_i_supplied(struct po
 	error = class_for_each_device(power_supply_class, psy,
 				      __power_supply_am_i_supplied);
 
-	dev_dbg(psy->dev, "%s %d\n", __FUNCTION__, error);
+	dev_dbg(psy->dev, "%s %d\n", __func__, error);
 
 	return error;
 }
diff -puN drivers/power/power_supply_leds.c~power-replace-remaining-__function__-occurrences drivers/power/power_supply_leds.c
--- a/drivers/power/power_supply_leds.c~power-replace-remaining-__function__-occurrences
+++ a/drivers/power/power_supply_leds.c
@@ -24,7 +24,7 @@ static void power_supply_update_bat_leds
 	if (psy->get_property(psy, POWER_SUPPLY_PROP_STATUS, &status))
 		return;
 
-	dev_dbg(psy->dev, "%s %d\n", __FUNCTION__, status.intval);
+	dev_dbg(psy->dev, "%s %d\n", __func__, status.intval);
 
 	switch (status.intval) {
 	case POWER_SUPPLY_STATUS_FULL:
@@ -101,7 +101,7 @@ static void power_supply_update_gen_leds
 	if (psy->get_property(psy, POWER_SUPPLY_PROP_ONLINE, &online))
 		return;
 
-	dev_dbg(psy->dev, "%s %d\n", __FUNCTION__, online.intval);
+	dev_dbg(psy->dev, "%s %d\n", __func__, online.intval);
 
 	if (online.intval)
 		led_trigger_event(psy->online_trig, LED_FULL);
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
frv-fix-arch-frv-mm-unalignedo-build-error.patch
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
git-kvm.patch
git-mips.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
git-watchdog.patch
git-xfs.patch
xtensa-replace-remaining-__function__-occurences.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
add-macros-similar-to-min-max-min_t-max_t.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
fuse-use-clamp-rather-than-nested-min-max.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
drivers-replace-remaining-__function__-occurrences.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch

