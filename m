From: akpm@linux-foundation.org
Subject: + revert-hwmon-f71882fg-add-support-for-the-fintek-f71808e.patch added to -mm tree
Date: Wed, 18 Aug 2010 11:36:22 -0700
Message-ID: <201008181836.o7IIaMA0005318@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44188 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752891Ab0HRShQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Aug 2010 14:37:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, hdegoede@redhat.com, jic23@cam.ac.uk, khali@linux-fr.org, me@mortis.eu, torvalds@linux-foundation.org


The patch titled
     revert "hwmon: f71882fg: add support for the Fintek F71808E"
has been added to the -mm tree.  Its filename is
     revert-hwmon-f71882fg-add-support-for-the-fintek-f71808e.patch

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
Subject: revert "hwmon: f71882fg: add support for the Fintek F71808E"
From: Andrew Morton <akpm@linux-foundation.org>

Revert

: commit 7721fea3d0fd93fb4d000eb737b444369358d6d3
: Author:     Giel van Schijndel <me@mortis.eu>
: AuthorDate: Mon Aug 9 17:21:13 2010 -0700
: Commit:     Linus Torvalds <torvalds@linux-foundation.org>
: CommitDate: Mon Aug 9 20:45:10 2010 -0700
: 
:     hwmon: f71882fg: add support for the Fintek F71808E

Hans said:

: A second review after I've received a data sheet for this device from
: Fintek has turned up a few bugs.
: 
: Unfortunately Giel (nor I) have time to fix this in time for the 2.6.36
: cycle.  Therefor I would like to see this patch reverted as not having any
: support for the hwmon function of this superio chip is better then having
: unreliable support.

Cc: Giel van Schijndel <me@mortis.eu>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/hwmon/f71882fg |    4 -
 drivers/hwmon/Kconfig        |    6 +-
 drivers/hwmon/f71882fg.c     |   83 +++------------------------------
 3 files changed, 11 insertions(+), 82 deletions(-)

diff -puN Documentation/hwmon/f71882fg~revert-hwmon-f71882fg-add-support-for-the-fintek-f71808e Documentation/hwmon/f71882fg
--- a/Documentation/hwmon/f71882fg~revert-hwmon-f71882fg-add-support-for-the-fintek-f71808e
+++ a/Documentation/hwmon/f71882fg
@@ -2,10 +2,6 @@ Kernel driver f71882fg
 ======================
 
 Supported chips:
-  * Fintek F71808E
-    Prefix: 'f71808fg'
-    Addresses scanned: none, address read from Super I/O config space
-    Datasheet: Not public
   * Fintek F71858FG
     Prefix: 'f71858fg'
     Addresses scanned: none, address read from Super I/O config space
diff -puN drivers/hwmon/Kconfig~revert-hwmon-f71882fg-add-support-for-the-fintek-f71808e drivers/hwmon/Kconfig
--- a/drivers/hwmon/Kconfig~revert-hwmon-f71882fg-add-support-for-the-fintek-f71808e
+++ a/drivers/hwmon/Kconfig
@@ -332,11 +332,11 @@ config SENSORS_F71805F
 	  will be called f71805f.
 
 config SENSORS_F71882FG
-	tristate "Fintek F71808E, F71858FG, F71862FG, F71882FG, F71889FG and F8000"
+	tristate "Fintek F71858FG, F71862FG, F71882FG, F71889FG and F8000"
 	depends on EXPERIMENTAL
 	help
-	  If you say yes here you get support for hardware monitoring features
-	  of the Fintek F71808E, F71858FG, F71862FG/71863FG, F71882FG/F71883FG,
+	  If you say yes here you get support for hardware monitoring
+	  features of the Fintek F71858FG, F71862FG/71863FG, F71882FG/F71883FG,
 	  F71889FG and F8000 Super-I/O chips.
 
 	  This driver can also be built as a module.  If so, the module
diff -puN drivers/hwmon/f71882fg.c~revert-hwmon-f71882fg-add-support-for-the-fintek-f71808e drivers/hwmon/f71882fg.c
--- a/drivers/hwmon/f71882fg.c~revert-hwmon-f71882fg-add-support-for-the-fintek-f71808e
+++ a/drivers/hwmon/f71882fg.c
@@ -45,7 +45,6 @@
 #define SIO_REG_ADDR		0x60	/* Logical device address (2 bytes) */
 
 #define SIO_FINTEK_ID		0x1934	/* Manufacturers ID */
-#define SIO_F71808_ID		0x0901  /* Chipset ID */
 #define SIO_F71858_ID		0x0507  /* Chipset ID */
 #define SIO_F71862_ID		0x0601	/* Chipset ID */
 #define SIO_F71882_ID		0x0541	/* Chipset ID */
@@ -97,10 +96,9 @@ static unsigned short force_id;
 module_param(force_id, ushort, 0);
 MODULE_PARM_DESC(force_id, "Override the detected device ID");
 
-enum chips { f71808fg, f71858fg, f71862fg, f71882fg, f71889fg, f8000 };
+enum chips { f71858fg, f71862fg, f71882fg, f71889fg, f8000 };
 
 static const char *f71882fg_names[] = {
-	"f71808fg",
 	"f71858fg",
 	"f71862fg",
 	"f71882fg",
@@ -308,8 +306,8 @@ static struct sensor_device_attribute_2 
 	SENSOR_ATTR_2(temp3_fault, S_IRUGO, show_temp_fault, NULL, 0, 2),
 };
 
-/* In attr common to the f71862fg, f71882fg and f71889fg */
-static struct sensor_device_attribute_2 fxxxx_in_attr[] = {
+/* Temp and in attr common to the f71862fg, f71882fg and f71889fg */
+static struct sensor_device_attribute_2 fxxxx_in_temp_attr[] = {
 	SENSOR_ATTR_2(in0_input, S_IRUGO, show_in, NULL, 0, 0),
 	SENSOR_ATTR_2(in1_input, S_IRUGO, show_in, NULL, 0, 1),
 	SENSOR_ATTR_2(in2_input, S_IRUGO, show_in, NULL, 0, 2),
@@ -319,22 +317,6 @@ static struct sensor_device_attribute_2 
 	SENSOR_ATTR_2(in6_input, S_IRUGO, show_in, NULL, 0, 6),
 	SENSOR_ATTR_2(in7_input, S_IRUGO, show_in, NULL, 0, 7),
 	SENSOR_ATTR_2(in8_input, S_IRUGO, show_in, NULL, 0, 8),
-};
-
-/* In attr for the f71808fg */
-static struct sensor_device_attribute_2 f71808_in_attr[] = {
-	SENSOR_ATTR_2(in0_input, S_IRUGO, show_in, NULL, 0, 0),
-	SENSOR_ATTR_2(in1_input, S_IRUGO, show_in, NULL, 0, 1),
-	SENSOR_ATTR_2(in2_input, S_IRUGO, show_in, NULL, 0, 2),
-	SENSOR_ATTR_2(in3_input, S_IRUGO, show_in, NULL, 0, 3),
-	SENSOR_ATTR_2(in4_input, S_IRUGO, show_in, NULL, 0, 4),
-	SENSOR_ATTR_2(in5_input, S_IRUGO, show_in, NULL, 0, 5),
-	SENSOR_ATTR_2(in6_input, S_IRUGO, show_in, NULL, 0, 7),
-	SENSOR_ATTR_2(in7_input, S_IRUGO, show_in, NULL, 0, 8),
-};
-
-/* Temp attr common to the f71808fg, f71862fg, f71882fg and f71889fg */
-static struct sensor_device_attribute_2 fxxxx_temp_attr[] = {
 	SENSOR_ATTR_2(temp1_input, S_IRUGO, show_temp, NULL, 0, 1),
 	SENSOR_ATTR_2(temp1_max, S_IRUGO|S_IWUSR, show_temp_max,
 		store_temp_max, 0, 1),
@@ -373,10 +355,6 @@ static struct sensor_device_attribute_2 
 		store_temp_beep, 0, 6),
 	SENSOR_ATTR_2(temp2_type, S_IRUGO, show_temp_type, NULL, 0, 2),
 	SENSOR_ATTR_2(temp2_fault, S_IRUGO, show_temp_fault, NULL, 0, 2),
-};
-
-/* Temp and in attr common to the f71862fg, f71882fg and f71889fg */
-static struct sensor_device_attribute_2 f71862_temp_attr[] = {
 	SENSOR_ATTR_2(temp3_input, S_IRUGO, show_temp, NULL, 0, 3),
 	SENSOR_ATTR_2(temp3_max, S_IRUGO|S_IWUSR, show_temp_max,
 		store_temp_max, 0, 3),
@@ -1011,11 +989,6 @@ static struct f71882fg_data *f71882fg_up
 				data->temp_type[1] = 6;
 				break;
 			}
-		} else if (data->type == f71808fg) {
-			reg  = f71882fg_read8(data, F71882FG_REG_TEMP_TYPE);
-			data->temp_type[1] = (reg & 0x02) ? 2 : 4;
-			data->temp_type[2] = (reg & 0x04) ? 2 : 4;
-
 		} else {
 			reg2 = f71882fg_read8(data, F71882FG_REG_PECI);
 			if ((reg2 & 0x03) == 0x01)
@@ -1898,8 +1871,7 @@ static ssize_t store_pwm_auto_point_temp
 
 	val /= 1000;
 
-	if (data->type == f71889fg
-	 || data->type == f71808fg)
+	if (data->type == f71889fg)
 		val = SENSORS_LIMIT(val, -128, 127);
 	else
 		val = SENSORS_LIMIT(val, 0, 127);
@@ -2002,28 +1974,8 @@ static int __devinit f71882fg_probe(stru
 			/* fall through! */
 		case f71862fg:
 			err = f71882fg_create_sysfs_files(pdev,
-					f71862_temp_attr,
-					ARRAY_SIZE(f71862_temp_attr));
-			if (err)
-				goto exit_unregister_sysfs;
-			err = f71882fg_create_sysfs_files(pdev,
-					fxxxx_in_attr,
-					ARRAY_SIZE(fxxxx_in_attr));
-			if (err)
-				goto exit_unregister_sysfs;
-			err = f71882fg_create_sysfs_files(pdev,
-					fxxxx_temp_attr,
-					ARRAY_SIZE(fxxxx_temp_attr));
-			break;
-		case f71808fg:
-			err = f71882fg_create_sysfs_files(pdev,
-					f71808_in_attr,
-					ARRAY_SIZE(f71808_in_attr));
-			if (err)
-				goto exit_unregister_sysfs;
-			err = f71882fg_create_sysfs_files(pdev,
-					fxxxx_temp_attr,
-					ARRAY_SIZE(fxxxx_temp_attr));
+					fxxxx_in_temp_attr,
+					ARRAY_SIZE(fxxxx_in_temp_attr));
 			break;
 		case f8000:
 			err = f71882fg_create_sysfs_files(pdev,
@@ -2050,7 +2002,6 @@ static int __devinit f71882fg_probe(stru
 		case f71862fg:
 			err = (data->pwm_enable & 0x15) != 0x15;
 			break;
-		case f71808fg:
 		case f71882fg:
 		case f71889fg:
 			err = 0;
@@ -2096,7 +2047,6 @@ static int __devinit f71882fg_probe(stru
 					f8000_auto_pwm_attr,
 					ARRAY_SIZE(f8000_auto_pwm_attr));
 			break;
-		case f71808fg:
 		case f71889fg:
 			for (i = 0; i < nr_fans; i++) {
 				data->pwm_auto_point_mapping[i] =
@@ -2176,22 +2126,8 @@ static int f71882fg_remove(struct platfo
 			/* fall through! */
 		case f71862fg:
 			f71882fg_remove_sysfs_files(pdev,
-					f71862_temp_attr,
-					ARRAY_SIZE(f71862_temp_attr));
-			f71882fg_remove_sysfs_files(pdev,
-					fxxxx_in_attr,
-					ARRAY_SIZE(fxxxx_in_attr));
-			f71882fg_remove_sysfs_files(pdev,
-					fxxxx_temp_attr,
-					ARRAY_SIZE(fxxxx_temp_attr));
-			break;
-		case f71808fg:
-			f71882fg_remove_sysfs_files(pdev,
-					f71808_in_attr,
-					ARRAY_SIZE(f71808_in_attr));
-			f71882fg_remove_sysfs_files(pdev,
-					fxxxx_temp_attr,
-					ARRAY_SIZE(fxxxx_temp_attr));
+					fxxxx_in_temp_attr,
+					ARRAY_SIZE(fxxxx_in_temp_attr));
 			break;
 		case f8000:
 			f71882fg_remove_sysfs_files(pdev,
@@ -2259,9 +2195,6 @@ static int __init f71882fg_find(int sioa
 
 	devid = force_id ? force_id : superio_inw(sioaddr, SIO_REG_DEVID);
 	switch (devid) {
-	case SIO_F71808_ID:
-		sio_data->type = f71808fg;
-		break;
 	case SIO_F71858_ID:
 		sio_data->type = f71858fg;
 		break;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
revert-hwmon-f71882fg-add-support-for-the-fintek-f71808e.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
fs-inodec-work-around-bug.patch
i-need-old-gcc.patch
mm-vmap-area-cache.patch
parport-prevent-arm-boards-frmo-crashing-when-cups-is-loaded-fix.patch
gcc-46-btrfs-clean-up-unused-variables-bugs.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
security-add-const-to-security_task_setscheduler.patch
sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch
drivers-scsi-qla4xxx-fix-build.patch
fs-bio-integrityc-return-enomem-on-kmalloc-failure.patch
usb-storage-add-new-no_read_disc_info-quirk-fix.patch
mm.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
sdhci-get-rid-of-card-detect-work-fix.patch
cgroup_freezer-update_freezer_state-does-incorrect-state-transitions-checkpatch-fixes.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
pps-add-async-pps-event-handler-fix.patch
memstick-add-driver-for-ricoh-r5c592-card-reader-cleanups.patch
vfs-add-super-operation-writeback_inodes-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4-export-find_get_pages.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch

