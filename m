From: akpm@linux-foundation.org
Subject: + power-replace-remaining-__function__-occurrences.patch added to -mm tree
Date: Wed, 05 Mar 2008 19:50:20 -0800
Message-ID: <200803060350.m263oKnV007350@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37308 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752020AbYCFD6t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 22:58:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, greg@kroah.com, lenb@kernel.org, rjw@sisk.pl


The patch titled
     power: replace remaining __FUNCTION__ occurrences
has been added to the -mm tree.  Its filename is
     power-replace-remaining-__function__-occurrences.patch

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

git-x86.patch
git-alsa.patch
sound-replace-remaining-__function__-occurences.patch
agp-fix-shadowed-variable-warning-in-amd-k7-agpc.patch
arm-replace-remaining-__function__-occurences.patch
cifs-remove-global_extern-macro.patch
cifs-replace-remaining-__function__-occurrences.patch
powerpc-replace-remaining-__function__-occurences.patch
ppc-replace-remaining-__function__-occurences.patch
drivers-base-replace-remaining-__function__-occurrences.patch
radeon-fix-integer-as-null-pointer-warnings-in-radeon_memc.patch
git-dvb.patch
git-dlm.patch
ia64-remove-remaining-__function__-occurences.patch
infiniband-replace-remaining-__function__-occurrences.patch
input-replace-remaining-__function__-occurrences.patch
jfs-replace-__inline-with-inline.patch
git-kvm.patch
pata_amd-fix-sparse-warning.patch
mips-replace-remaining-__function__-occurences.patch
mips-replace-__inline-with-inline.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
git-ubi.patch
net-replace-__inline-with-inline.patch
irda-replace-__inline-with-inline.patch
blackfin-replace-remaining-__function__-occurences.patch
nfs-replace-remaining-__function__-occurrences.patch
git-nfsd.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
drivers-s390-replace-remaining-__function__-occurrences.patch
sh-replace-remaining-__function__-occurences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-stc-make-class-attributes-static.patch
scsi-osstc-make-class-attributes-static.patch
scsi-chc-fix-shadowed-variable-warnings.patch
scsi-chc-fix-shadowed-variable-warnings-checkpatch-fixes.patch
xfs-replace-remaining-__function__-occurrences.patch
xfs-replace-__inline-with-inline.patch
xtensa-replace-remaining-__function__-occurences.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
smack-fix-integer-as-null-pointer-warning-in-smack_lsmc.patch
alpha-remove-remaining-__function__-occurences.patch
alpha-replace-__inline-with-inline.patch
m68k-replace-remaining-__function__-occurences.patch
uml-replace-remaining-__function__-occurences.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
kernel-add-clamp-and-clamp_t-macros.patch
kernel-add-clamp-and-clamp_t-macros-checkpatch-fixes.patch
kernel-add-clamp-and-clamp_t-macros-fix.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
serial-remove-double-initializer.patch
char-make-functions-static-in-synclinkmpc.patch
capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
avm-fix-sparse-warning-using-integer-as-null-pointer.patch
eicon-fix-sparse-integer-as-null-pointer-warnings.patch
isdn-replace-remaining-__function__-occurrences.patch
isdn-replace-__inline-with-inline.patch
xen-make-blkif_getgeo-static.patch
ecryptfs-replace-remaining-__function__-occurrences.patch
rtc-replace-remaining-__function__-occurrences.patch
fbcon-replace-mono_col-macro-with-static-inline.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
video-replace-remaining-__function__-occurrences.patch
md-fix-integer-as-null-pointer-warnings-in-mdc.patch
ext2-replace-remaining-__function__-occurrences.patch
jbd-sparse-warnings-in-revokec-journalc.patch
ext3-replace-remaining-__function__-occurrences.patch
jbd-replace-remaining-__function__-occurrences.patch
ufs-replace-remaining-__function__-occurrences.patch
ufs-replace-__inline-with-inline.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-fix_nodec.patch
reiserfs-fix-sparse-warnings-in-do_balanc.patch
reiserfs-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-lbalancec.patch
reiserfs-fix-sparse-warning-in-journalc.patch
reiserfs-fix-more-sparse-warnings-in-do_balanc.patch
reiserfs-replace-remaining-__function__-occurrences.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
ext4-replace-remaining-__function__-occurrences.patch
jdb2-replace-remaining-__function__-occurrences.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
security-replace-remaining-__function__-occurences.patch
security-replace-remaining-__function__-occurences-checkpatch-fixes.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch
acpi-replace-remaining-__function__-occurrences.patch
ata-replace-remaining-__function__-occurrences.patch
block-replace-remaining-__function__-occurrences.patch
iop-admac-replace-remaining-__function__-occurrences.patch
ieee1394-replace-remaining-__function__-occurrences.patch
firmware-replace-remaining-__function__-occurrences.patch
mtd-replace-remaining-__function__-occurrences.patch
md-replace-remaining-__function__-occurrences.patch
drivers-misc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
ioc3c-replace-remaining-__function__-occurrences.patch
watchdog-replace-remaining-__function__-occurrences.patch
spi-replace-remaining-__function__-occurrences.patch
power-replace-remaining-__function__-occurrences.patch
drivers-replace-remaining-__function__-occurrences.patch

