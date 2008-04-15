From: akpm@linux-foundation.org
Subject: + acpi-use-non-racy-method-for-proc-entries-creation.patch added to -mm tree
Date: Tue, 15 Apr 2008 16:56:37 -0700
Message-ID: <200804152356.m3FNucKE022558@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44483 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753764AbYDOX5B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 19:57:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: den@openvz.org, adobriyan@gmail.com, ebiederm@xmission.com, lenb@kernel.org


The patch titled
     acpi: use non-racy method for proc entries creation
has been added to the -mm tree.  Its filename is
     acpi-use-non-racy-method-for-proc-entries-creation.patch

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
Subject: acpi: use non-racy method for proc entries creation
From: "Denis V. Lunev" <den@openvz.org>

Use proc_create()/proc_create_data() to make sure that ->proc_fops and ->data
be setup before gluing PDE to main tree.

Add correct ->owner to proc_fops to fix reading/module unloading race.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Len Brown <lenb@kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/ac.c                   |   12 --
 drivers/acpi/battery.c              |   12 +-
 drivers/acpi/button.c               |   24 ++---
 drivers/acpi/ec.c                   |   11 --
 drivers/acpi/event.c                |    8 -
 drivers/acpi/fan.c                  |   14 +--
 drivers/acpi/power.c                |   11 --
 drivers/acpi/processor_core.c       |   39 +++------
 drivers/acpi/processor_idle.c       |   13 +--
 drivers/acpi/processor_perflib.c    |   13 ---
 drivers/acpi/processor_thermal.c    |    1 
 drivers/acpi/processor_throttling.c |    1 
 drivers/acpi/sbs.c                  |   35 ++------
 drivers/acpi/sleep/proc.c           |   26 ++----
 drivers/acpi/system.c               |   27 ++----
 drivers/acpi/thermal.c              |   67 ++++++---------
 drivers/acpi/video.c                |  112 ++++++++++----------------
 17 files changed, 162 insertions(+), 264 deletions(-)

diff -puN drivers/acpi/ac.c~acpi-use-non-racy-method-for-proc-entries-creation drivers/acpi/ac.c
--- a/drivers/acpi/ac.c~acpi-use-non-racy-method-for-proc-entries-creation
+++ a/drivers/acpi/ac.c
@@ -92,6 +92,7 @@ struct acpi_ac {
 
 #ifdef CONFIG_ACPI_PROCFS_POWER
 static const struct file_operations acpi_ac_fops = {
+	.owner = THIS_MODULE,
 	.open = acpi_ac_open_fs,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -195,16 +196,11 @@ static int acpi_ac_add_fs(struct acpi_de
 	}
 
 	/* 'state' [R] */
-	entry = create_proc_entry(ACPI_AC_FILE_STATE,
-				  S_IRUGO, acpi_device_dir(device));
+	entry = proc_create_data(ACPI_AC_FILE_STATE,
+				 S_IRUGO, acpi_device_dir(device),
+				 &acpi_ac_fops, acpi_driver_data(device));
 	if (!entry)
 		return -ENODEV;
-	else {
-		entry->proc_fops = &acpi_ac_fops;
-		entry->data = acpi_driver_data(device);
-		entry->owner = THIS_MODULE;
-	}
-
 	return 0;
 }
 
diff -puN drivers/acpi/battery.c~acpi-use-non-racy-method-for-proc-entries-creation drivers/acpi/battery.c
--- a/drivers/acpi/battery.c~acpi-use-non-racy-method-for-proc-entries-creation
+++ a/drivers/acpi/battery.c
@@ -741,15 +741,13 @@ static int acpi_battery_add_fs(struct ac
 	}
 
 	for (i = 0; i < ACPI_BATTERY_NUMFILES; ++i) {
-		entry = create_proc_entry(acpi_battery_file[i].name,
-				  acpi_battery_file[i].mode, acpi_device_dir(device));
+		entry = proc_create_data(acpi_battery_file[i].name,
+					 acpi_battery_file[i].mode,
+					 acpi_device_dir(device),
+					 &acpi_battery_file[i].ops,
+					 acpi_driver_data(device));
 		if (!entry)
 			return -ENODEV;
-		else {
-			entry->proc_fops = &acpi_battery_file[i].ops;
-			entry->data = acpi_driver_data(device);
-			entry->owner = THIS_MODULE;
-		}
 	}
 	return 0;
 }
diff -puN drivers/acpi/button.c~acpi-use-non-racy-method-for-proc-entries-creation drivers/acpi/button.c
--- a/drivers/acpi/button.c~acpi-use-non-racy-method-for-proc-entries-creation
+++ a/drivers/acpi/button.c
@@ -102,6 +102,7 @@ struct acpi_button {
 };
 
 static const struct file_operations acpi_button_info_fops = {
+	.owner = THIS_MODULE,
 	.open = acpi_button_info_open_fs,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -109,6 +110,7 @@ static const struct file_operations acpi
 };
 
 static const struct file_operations acpi_button_state_fops = {
+	.owner = THIS_MODULE,
 	.open = acpi_button_state_open_fs,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -207,27 +209,21 @@ static int acpi_button_add_fs(struct acp
 	acpi_device_dir(device)->owner = THIS_MODULE;
 
 	/* 'info' [R] */
-	entry = create_proc_entry(ACPI_BUTTON_FILE_INFO,
-				  S_IRUGO, acpi_device_dir(device));
+	entry = proc_create_data(ACPI_BUTTON_FILE_INFO,
+				 S_IRUGO, acpi_device_dir(device),
+				 &acpi_button_info_fops,
+				 acpi_driver_data(device));
 	if (!entry)
 		return -ENODEV;
-	else {
-		entry->proc_fops = &acpi_button_info_fops;
-		entry->data = acpi_driver_data(device);
-		entry->owner = THIS_MODULE;
-	}
 
 	/* show lid state [R] */
 	if (button->type == ACPI_BUTTON_TYPE_LID) {
-		entry = create_proc_entry(ACPI_BUTTON_FILE_STATE,
-					  S_IRUGO, acpi_device_dir(device));
+		entry = proc_create_data(ACPI_BUTTON_FILE_STATE,
+					 S_IRUGO, acpi_device_dir(device),
+					 &acpi_button_state_fops,
+					 acpi_driver_data(device));
 		if (!entry)
 			return -ENODEV;
-		else {
-			entry->proc_fops = &acpi_button_state_fops;
-			entry->data = acpi_driver_data(device);
-			entry->owner = THIS_MODULE;
-		}
 	}
 
 	return 0;
diff -puN drivers/acpi/ec.c~acpi-use-non-racy-method-for-proc-entries-creation drivers/acpi/ec.c
--- a/drivers/acpi/ec.c~acpi-use-non-racy-method-for-proc-entries-creation
+++ a/drivers/acpi/ec.c
@@ -634,16 +634,11 @@ static int acpi_ec_add_fs(struct acpi_de
 			return -ENODEV;
 	}
 
-	entry = create_proc_entry(ACPI_EC_FILE_INFO, S_IRUGO,
-				  acpi_device_dir(device));
+	entry = proc_create_data(ACPI_EC_FILE_INFO, S_IRUGO,
+				 acpi_device_dir(device),
+				 &acpi_ec_info_ops, acpi_driver_data(device));
 	if (!entry)
 		return -ENODEV;
-	else {
-		entry->proc_fops = &acpi_ec_info_ops;
-		entry->data = acpi_driver_data(device);
-		entry->owner = THIS_MODULE;
-	}
-
 	return 0;
 }
 
diff -puN drivers/acpi/event.c~acpi-use-non-racy-method-for-proc-entries-creation drivers/acpi/event.c
--- a/drivers/acpi/event.c~acpi-use-non-racy-method-for-proc-entries-creation
+++ a/drivers/acpi/event.c
@@ -102,6 +102,7 @@ static unsigned int acpi_system_poll_eve
 }
 
 static const struct file_operations acpi_system_event_ops = {
+	.owner = THIS_MODULE,
 	.open = acpi_system_open_event,
 	.read = acpi_system_read_event,
 	.release = acpi_system_close_event,
@@ -294,10 +295,9 @@ static int __init acpi_event_init(void)
 
 #ifdef CONFIG_ACPI_PROC_EVENT
 	/* 'event' [R] */
-	entry = create_proc_entry("event", S_IRUSR, acpi_root_dir);
-	if (entry)
-		entry->proc_fops = &acpi_system_event_ops;
-	else
+	entry = proc_create("event", S_IRUSR, acpi_root_dir,
+			    &acpi_system_event_ops);
+	if (!entry)
 		return -ENODEV;
 #endif
 
diff -puN drivers/acpi/fan.c~acpi-use-non-racy-method-for-proc-entries-creation drivers/acpi/fan.c
--- a/drivers/acpi/fan.c~acpi-use-non-racy-method-for-proc-entries-creation
+++ a/drivers/acpi/fan.c
@@ -192,17 +192,13 @@ static int acpi_fan_add_fs(struct acpi_d
 	}
 
 	/* 'status' [R/W] */
-	entry = create_proc_entry(ACPI_FAN_FILE_STATE,
-				  S_IFREG | S_IRUGO | S_IWUSR,
-				  acpi_device_dir(device));
+	entry = proc_create_data(ACPI_FAN_FILE_STATE,
+				 S_IFREG | S_IRUGO | S_IWUSR,
+				 acpi_device_dir(device),
+				 &acpi_fan_state_ops,
+				 device);
 	if (!entry)
 		return -ENODEV;
-	else {
-		entry->proc_fops = &acpi_fan_state_ops;
-		entry->data = device;
-		entry->owner = THIS_MODULE;
-	}
-
 	return 0;
 }
 
diff -puN drivers/acpi/power.c~acpi-use-non-racy-method-for-proc-entries-creation drivers/acpi/power.c
--- a/drivers/acpi/power.c~acpi-use-non-racy-method-for-proc-entries-creation
+++ a/drivers/acpi/power.c
@@ -93,6 +93,7 @@ struct acpi_power_resource {
 static struct list_head acpi_power_resource_list;
 
 static const struct file_operations acpi_power_fops = {
+	.owner = THIS_MODULE,
 	.open = acpi_power_open_fs,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -543,15 +544,11 @@ static int acpi_power_add_fs(struct acpi
 	}
 
 	/* 'status' [R] */
-	entry = create_proc_entry(ACPI_POWER_FILE_STATUS,
-				  S_IRUGO, acpi_device_dir(device));
+	entry = proc_create_data(ACPI_POWER_FILE_STATUS,
+				 S_IRUGO, acpi_device_dir(device),
+				 &acpi_power_fops, acpi_driver_data(device));
 	if (!entry)
 		return -EIO;
-	else {
-		entry->proc_fops = &acpi_power_fops;
-		entry->data = acpi_driver_data(device);
-	}
-
 	return 0;
 }
 
diff -puN drivers/acpi/processor_core.c~acpi-use-non-racy-method-for-proc-entries-creation drivers/acpi/processor_core.c
--- a/drivers/acpi/processor_core.c~acpi-use-non-racy-method-for-proc-entries-creation
+++ a/drivers/acpi/processor_core.c
@@ -112,6 +112,7 @@ static struct acpi_driver acpi_processor
 #define UNINSTALL_NOTIFY_HANDLER	2
 
 static const struct file_operations acpi_processor_info_fops = {
+	.owner = THIS_MODULE,
 	.open = acpi_processor_info_open_fs,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -326,40 +327,30 @@ static int acpi_processor_add_fs(struct 
 	acpi_device_dir(device)->owner = THIS_MODULE;
 
 	/* 'info' [R] */
-	entry = create_proc_entry(ACPI_PROCESSOR_FILE_INFO,
-				  S_IRUGO, acpi_device_dir(device));
+	entry = proc_create_data(ACPI_PROCESSOR_FILE_INFO,
+				 S_IRUGO, acpi_device_dir(device),
+				 &acpi_processor_info_fops,
+				 acpi_driver_data(device));
 	if (!entry)
 		return -EIO;
-	else {
-		entry->proc_fops = &acpi_processor_info_fops;
-		entry->data = acpi_driver_data(device);
-		entry->owner = THIS_MODULE;
-	}
 
 	/* 'throttling' [R/W] */
-	entry = create_proc_entry(ACPI_PROCESSOR_FILE_THROTTLING,
-				  S_IFREG | S_IRUGO | S_IWUSR,
-				  acpi_device_dir(device));
+	entry = proc_create_data(ACPI_PROCESSOR_FILE_THROTTLING,
+				 S_IFREG | S_IRUGO | S_IWUSR,
+				 acpi_device_dir(device),
+				 &acpi_processor_throttling_fops,
+				 acpi_driver_data(device));
 	if (!entry)
 		return -EIO;
-	else {
-		entry->proc_fops = &acpi_processor_throttling_fops;
-		entry->data = acpi_driver_data(device);
-		entry->owner = THIS_MODULE;
-	}
 
 	/* 'limit' [R/W] */
-	entry = create_proc_entry(ACPI_PROCESSOR_FILE_LIMIT,
-				  S_IFREG | S_IRUGO | S_IWUSR,
-				  acpi_device_dir(device));
+	entry = proc_create_data(ACPI_PROCESSOR_FILE_LIMIT,
+				 S_IFREG | S_IRUGO | S_IWUSR,
+				 acpi_device_dir(device),
+				 &acpi_processor_limit_fops,
+				 acpi_driver_data(device));
 	if (!entry)
 		return -EIO;
-	else {
-		entry->proc_fops = &acpi_processor_limit_fops;
-		entry->data = acpi_driver_data(device);
-		entry->owner = THIS_MODULE;
-	}
-
 	return 0;
 }
 
diff -puN drivers/acpi/processor_idle.c~acpi-use-non-racy-method-for-proc-entries-creation drivers/acpi/processor_idle.c
--- a/drivers/acpi/processor_idle.c~acpi-use-non-racy-method-for-proc-entries-creation
+++ a/drivers/acpi/processor_idle.c
@@ -1306,6 +1306,7 @@ static int acpi_processor_power_open_fs(
 }
 
 static const struct file_operations acpi_processor_power_fops = {
+	.owner = THIS_MODULE,
 	.open = acpi_processor_power_open_fs,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -1846,16 +1847,12 @@ int __cpuinit acpi_processor_power_init(
 	}
 
 	/* 'power' [R] */
-	entry = create_proc_entry(ACPI_PROCESSOR_FILE_POWER,
-				  S_IRUGO, acpi_device_dir(device));
+	entry = proc_create_data(ACPI_PROCESSOR_FILE_POWER,
+				 S_IRUGO, acpi_device_dir(device),
+				 &acpi_processor_power_fops,
+				 acpi_driver_data(device));
 	if (!entry)
 		return -EIO;
-	else {
-		entry->proc_fops = &acpi_processor_power_fops;
-		entry->data = acpi_driver_data(device);
-		entry->owner = THIS_MODULE;
-	}
-
 	return 0;
 }
 
diff -puN drivers/acpi/processor_perflib.c~acpi-use-non-racy-method-for-proc-entries-creation drivers/acpi/processor_perflib.c
--- a/drivers/acpi/processor_perflib.c~acpi-use-non-racy-method-for-proc-entries-creation
+++ a/drivers/acpi/processor_perflib.c
@@ -411,6 +411,7 @@ EXPORT_SYMBOL(acpi_processor_notify_smm)
 
 static int acpi_processor_perf_open_fs(struct inode *inode, struct file *file);
 static struct file_operations acpi_processor_perf_fops = {
+	.owner = THIS_MODULE,
 	.open = acpi_processor_perf_open_fs,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -456,7 +457,6 @@ static int acpi_processor_perf_open_fs(s
 
 static void acpi_cpufreq_add_file(struct acpi_processor *pr)
 {
-	struct proc_dir_entry *entry = NULL;
 	struct acpi_device *device = NULL;
 
 
@@ -464,14 +464,9 @@ static void acpi_cpufreq_add_file(struct
 		return;
 
 	/* add file 'performance' [R/W] */
-	entry = create_proc_entry(ACPI_PROCESSOR_FILE_PERFORMANCE,
-				  S_IFREG | S_IRUGO,
-				  acpi_device_dir(device));
-	if (entry){
-		entry->proc_fops = &acpi_processor_perf_fops;
-		entry->data = acpi_driver_data(device);
-		entry->owner = THIS_MODULE;
-	}
+	proc_create_data(ACPI_PROCESSOR_FILE_PERFORMANCE, S_IFREG | S_IRUGO,
+			 acpi_device_dir(device),
+			 &acpi_processor_perf_fops, acpi_driver_data(device));
 	return;
 }
 
diff -puN drivers/acpi/processor_thermal.c~acpi-use-non-racy-method-for-proc-entries-creation drivers/acpi/processor_thermal.c
--- a/drivers/acpi/processor_thermal.c~acpi-use-non-racy-method-for-proc-entries-creation
+++ a/drivers/acpi/processor_thermal.c
@@ -509,6 +509,7 @@ static ssize_t acpi_processor_write_limi
 }
 
 struct file_operations acpi_processor_limit_fops = {
+	.owner = THIS_MODULE,
 	.open = acpi_processor_limit_open_fs,
 	.read = seq_read,
 	.write = acpi_processor_write_limit,
diff -puN drivers/acpi/processor_throttling.c~acpi-use-non-racy-method-for-proc-entries-creation drivers/acpi/processor_throttling.c
--- a/drivers/acpi/processor_throttling.c~acpi-use-non-racy-method-for-proc-entries-creation
+++ a/drivers/acpi/processor_throttling.c
@@ -1252,6 +1252,7 @@ static ssize_t acpi_processor_write_thro
 }
 
 struct file_operations acpi_processor_throttling_fops = {
+	.owner = THIS_MODULE,
 	.open = acpi_processor_throttling_open_fs,
 	.read = seq_read,
 	.write = acpi_processor_write_throttling,
diff -puN drivers/acpi/sbs.c~acpi-use-non-racy-method-for-proc-entries-creation drivers/acpi/sbs.c
--- a/drivers/acpi/sbs.c~acpi-use-non-racy-method-for-proc-entries-creation
+++ a/drivers/acpi/sbs.c
@@ -483,8 +483,6 @@ acpi_sbs_add_fs(struct proc_dir_entry **
 		struct file_operations *state_fops,
 		struct file_operations *alarm_fops, void *data)
 {
-	struct proc_dir_entry *entry = NULL;
-
 	if (!*dir) {
 		*dir = proc_mkdir(dir_name, parent_dir);
 		if (!*dir) {
@@ -494,34 +492,19 @@ acpi_sbs_add_fs(struct proc_dir_entry **
 	}
 
 	/* 'info' [R] */
-	if (info_fops) {
-		entry = create_proc_entry(ACPI_SBS_FILE_INFO, S_IRUGO, *dir);
-		if (entry) {
-			entry->proc_fops = info_fops;
-			entry->data = data;
-			entry->owner = THIS_MODULE;
-		}
-	}
+	if (info_fops)
+		proc_create_data(ACPI_SBS_FILE_INFO, S_IRUGO, *dir,
+				 info_fops, data);
 
 	/* 'state' [R] */
-	if (state_fops) {
-		entry = create_proc_entry(ACPI_SBS_FILE_STATE, S_IRUGO, *dir);
-		if (entry) {
-			entry->proc_fops = state_fops;
-			entry->data = data;
-			entry->owner = THIS_MODULE;
-		}
-	}
+	if (state_fops)
+		proc_create_data(ACPI_SBS_FILE_STATE, S_IRUGO, *dir,
+				 state_fops, data);
 
 	/* 'alarm' [R/W] */
-	if (alarm_fops) {
-		entry = create_proc_entry(ACPI_SBS_FILE_ALARM, S_IRUGO, *dir);
-		if (entry) {
-			entry->proc_fops = alarm_fops;
-			entry->data = data;
-			entry->owner = THIS_MODULE;
-		}
-	}
+	if (alarm_fops)
+		proc_create_data(ACPI_SBS_FILE_ALARM, S_IRUGO, *dir,
+				 alarm_fops, data);
 	return 0;
 }
 
diff -puN drivers/acpi/sleep/proc.c~acpi-use-non-racy-method-for-proc-entries-creation drivers/acpi/sleep/proc.c
--- a/drivers/acpi/sleep/proc.c~acpi-use-non-racy-method-for-proc-entries-creation
+++ a/drivers/acpi/sleep/proc.c
@@ -440,6 +440,7 @@ acpi_system_wakeup_device_open_fs(struct
 }
 
 static const struct file_operations acpi_system_wakeup_device_fops = {
+	.owner = THIS_MODULE,
 	.open = acpi_system_wakeup_device_open_fs,
 	.read = seq_read,
 	.write = acpi_system_write_wakeup_device,
@@ -449,6 +450,7 @@ static const struct file_operations acpi
 
 #ifdef	CONFIG_ACPI_PROCFS
 static const struct file_operations acpi_system_sleep_fops = {
+	.owner = THIS_MODULE,
 	.open = acpi_system_sleep_open_fs,
 	.read = seq_read,
 	.write = acpi_system_write_sleep,
@@ -459,6 +461,7 @@ static const struct file_operations acpi
 
 #ifdef	HAVE_ACPI_LEGACY_ALARM
 static const struct file_operations acpi_system_alarm_fops = {
+	.owner = THIS_MODULE,
 	.open = acpi_system_alarm_open_fs,
 	.read = seq_read,
 	.write = acpi_system_write_alarm,
@@ -477,37 +480,26 @@ static u32 rtc_handler(void *context)
 
 static int __init acpi_sleep_proc_init(void)
 {
-	struct proc_dir_entry *entry = NULL;
-
 	if (acpi_disabled)
 		return 0;
 
 #ifdef	CONFIG_ACPI_PROCFS
 	/* 'sleep' [R/W] */
-	entry =
-	    create_proc_entry("sleep", S_IFREG | S_IRUGO | S_IWUSR,
-			      acpi_root_dir);
-	if (entry)
-		entry->proc_fops = &acpi_system_sleep_fops;
+	proc_create("sleep", S_IFREG | S_IRUGO | S_IWUSR,
+		    acpi_root_dir, &acpi_system_sleep_fops);
 #endif				/* CONFIG_ACPI_PROCFS */
 
 #ifdef	HAVE_ACPI_LEGACY_ALARM
 	/* 'alarm' [R/W] */
-	entry =
-	    create_proc_entry("alarm", S_IFREG | S_IRUGO | S_IWUSR,
-			      acpi_root_dir);
-	if (entry)
-		entry->proc_fops = &acpi_system_alarm_fops;
+	proc_create("alarm", S_IFREG | S_IRUGO | S_IWUSR,
+		    acpi_root_dir, &acpi_system_alarm_fops);
 
 	acpi_install_fixed_event_handler(ACPI_EVENT_RTC, rtc_handler, NULL);
 #endif				/* HAVE_ACPI_LEGACY_ALARM */
 
 	/* 'wakeup device' [R/W] */
-	entry =
-	    create_proc_entry("wakeup", S_IFREG | S_IRUGO | S_IWUSR,
-			      acpi_root_dir);
-	if (entry)
-		entry->proc_fops = &acpi_system_wakeup_device_fops;
+	proc_create("wakeup", S_IFREG | S_IRUGO | S_IWUSR,
+		    acpi_root_dir, &acpi_system_wakeup_device_fops);
 
 	return 0;
 }
diff -puN drivers/acpi/system.c~acpi-use-non-racy-method-for-proc-entries-creation drivers/acpi/system.c
--- a/drivers/acpi/system.c~acpi-use-non-racy-method-for-proc-entries-creation
+++ a/drivers/acpi/system.c
@@ -396,6 +396,7 @@ static int acpi_system_info_open_fs(stru
 }
 
 static const struct file_operations acpi_system_info_ops = {
+	.owner = THIS_MODULE,
 	.open = acpi_system_info_open_fs,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -406,6 +407,7 @@ static ssize_t acpi_system_read_dsdt(str
 				     loff_t *);
 
 static const struct file_operations acpi_system_dsdt_ops = {
+	.owner = THIS_MODULE,
 	.read = acpi_system_read_dsdt,
 };
 
@@ -430,6 +432,7 @@ static ssize_t acpi_system_read_fadt(str
 				     loff_t *);
 
 static const struct file_operations acpi_system_fadt_ops = {
+	.owner = THIS_MODULE,
 	.read = acpi_system_read_fadt,
 };
 
@@ -454,31 +457,23 @@ static int acpi_system_procfs_init(void)
 {
 	struct proc_dir_entry *entry;
 	int error = 0;
-	char *name;
 
 	/* 'info' [R] */
-	name = ACPI_SYSTEM_FILE_INFO;
-	entry = create_proc_entry(name, S_IRUGO, acpi_root_dir);
+	entry = proc_create(ACPI_SYSTEM_FILE_INFO, S_IRUGO, acpi_root_dir,
+			    &acpi_system_info_ops);
 	if (!entry)
 		goto Error;
-	else {
-		entry->proc_fops = &acpi_system_info_ops;
-	}
 
 	/* 'dsdt' [R] */
-	name = ACPI_SYSTEM_FILE_DSDT;
-	entry = create_proc_entry(name, S_IRUSR, acpi_root_dir);
-	if (entry)
-		entry->proc_fops = &acpi_system_dsdt_ops;
-	else
+	entry = proc_create(ACPI_SYSTEM_FILE_DSDT, S_IRUSR, acpi_root_dir,
+			    &acpi_system_dsdt_ops);
+	if (!entry)
 		goto Error;
 
 	/* 'fadt' [R] */
-	name = ACPI_SYSTEM_FILE_FADT;
-	entry = create_proc_entry(name, S_IRUSR, acpi_root_dir);
-	if (entry)
-		entry->proc_fops = &acpi_system_fadt_ops;
-	else
+	entry = proc_create(ACPI_SYSTEM_FILE_FADT, S_IRUSR, acpi_root_dir,
+			    &acpi_system_fadt_ops);
+	if (!entry)
 		goto Error;
 
       Done:
diff -puN drivers/acpi/thermal.c~acpi-use-non-racy-method-for-proc-entries-creation drivers/acpi/thermal.c
--- a/drivers/acpi/thermal.c~acpi-use-non-racy-method-for-proc-entries-creation
+++ a/drivers/acpi/thermal.c
@@ -198,6 +198,7 @@ struct acpi_thermal {
 };
 
 static const struct file_operations acpi_thermal_state_fops = {
+	.owner = THIS_MODULE,
 	.open = acpi_thermal_state_open_fs,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -205,6 +206,7 @@ static const struct file_operations acpi
 };
 
 static const struct file_operations acpi_thermal_temp_fops = {
+	.owner = THIS_MODULE,
 	.open = acpi_thermal_temp_open_fs,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -212,6 +214,7 @@ static const struct file_operations acpi
 };
 
 static const struct file_operations acpi_thermal_trip_fops = {
+	.owner = THIS_MODULE,
 	.open = acpi_thermal_trip_open_fs,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -219,6 +222,7 @@ static const struct file_operations acpi
 };
 
 static const struct file_operations acpi_thermal_cooling_fops = {
+	.owner = THIS_MODULE,
 	.open = acpi_thermal_cooling_open_fs,
 	.read = seq_read,
 	.write = acpi_thermal_write_cooling_mode,
@@ -227,6 +231,7 @@ static const struct file_operations acpi
 };
 
 static const struct file_operations acpi_thermal_polling_fops = {
+	.owner = THIS_MODULE,
 	.open = acpi_thermal_polling_open_fs,
 	.read = seq_read,
 	.write = acpi_thermal_write_polling,
@@ -1419,63 +1424,47 @@ static int acpi_thermal_add_fs(struct ac
 	}
 
 	/* 'state' [R] */
-	entry = create_proc_entry(ACPI_THERMAL_FILE_STATE,
-				  S_IRUGO, acpi_device_dir(device));
+	entry = proc_create_data(ACPI_THERMAL_FILE_STATE,
+				 S_IRUGO, acpi_device_dir(device),
+				 &acpi_thermal_state_fops,
+				 acpi_driver_data(device));
 	if (!entry)
 		return -ENODEV;
-	else {
-		entry->proc_fops = &acpi_thermal_state_fops;
-		entry->data = acpi_driver_data(device);
-		entry->owner = THIS_MODULE;
-	}
 
 	/* 'temperature' [R] */
-	entry = create_proc_entry(ACPI_THERMAL_FILE_TEMPERATURE,
-				  S_IRUGO, acpi_device_dir(device));
+	entry = proc_create_data(ACPI_THERMAL_FILE_TEMPERATURE,
+				 S_IRUGO, acpi_device_dir(device),
+				 &acpi_thermal_temp_fops,
+				 acpi_driver_data(device));
 	if (!entry)
 		return -ENODEV;
-	else {
-		entry->proc_fops = &acpi_thermal_temp_fops;
-		entry->data = acpi_driver_data(device);
-		entry->owner = THIS_MODULE;
-	}
 
 	/* 'trip_points' [R] */
-	entry = create_proc_entry(ACPI_THERMAL_FILE_TRIP_POINTS,
-				  S_IRUGO,
-				  acpi_device_dir(device));
+	entry = proc_create_data(ACPI_THERMAL_FILE_TRIP_POINTS,
+				 S_IRUGO,
+				 acpi_device_dir(device),
+				 &acpi_thermal_trip_fops,
+				 acpi_driver_data(device));
 	if (!entry)
 		return -ENODEV;
-	else {
-		entry->proc_fops = &acpi_thermal_trip_fops;
-		entry->data = acpi_driver_data(device);
-		entry->owner = THIS_MODULE;
-	}
 
 	/* 'cooling_mode' [R/W] */
-	entry = create_proc_entry(ACPI_THERMAL_FILE_COOLING_MODE,
-				  S_IFREG | S_IRUGO | S_IWUSR,
-				  acpi_device_dir(device));
+	entry = proc_create_data(ACPI_THERMAL_FILE_COOLING_MODE,
+				 S_IFREG | S_IRUGO | S_IWUSR,
+				 acpi_device_dir(device),
+				 &acpi_thermal_cooling_fops,
+				 acpi_driver_data(device));
 	if (!entry)
 		return -ENODEV;
-	else {
-		entry->proc_fops = &acpi_thermal_cooling_fops;
-		entry->data = acpi_driver_data(device);
-		entry->owner = THIS_MODULE;
-	}
 
 	/* 'polling_frequency' [R/W] */
-	entry = create_proc_entry(ACPI_THERMAL_FILE_POLLING_FREQ,
-				  S_IFREG | S_IRUGO | S_IWUSR,
-				  acpi_device_dir(device));
+	entry = proc_create_data(ACPI_THERMAL_FILE_POLLING_FREQ,
+				 S_IFREG | S_IRUGO | S_IWUSR,
+				 acpi_device_dir(device),
+				 &acpi_thermal_polling_fops,
+				 acpi_driver_data(device));
 	if (!entry)
 		return -ENODEV;
-	else {
-		entry->proc_fops = &acpi_thermal_polling_fops;
-		entry->data = acpi_driver_data(device);
-		entry->owner = THIS_MODULE;
-	}
-
 	return 0;
 }
 
diff -puN drivers/acpi/video.c~acpi-use-non-racy-method-for-proc-entries-creation drivers/acpi/video.c
--- a/drivers/acpi/video.c~acpi-use-non-racy-method-for-proc-entries-creation
+++ a/drivers/acpi/video.c
@@ -192,6 +192,7 @@ struct acpi_video_device {
 /* bus */
 static int acpi_video_bus_info_open_fs(struct inode *inode, struct file *file);
 static struct file_operations acpi_video_bus_info_fops = {
+	.owner = THIS_MODULE,
 	.open = acpi_video_bus_info_open_fs,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -200,6 +201,7 @@ static struct file_operations acpi_video
 
 static int acpi_video_bus_ROM_open_fs(struct inode *inode, struct file *file);
 static struct file_operations acpi_video_bus_ROM_fops = {
+	.owner = THIS_MODULE,
 	.open = acpi_video_bus_ROM_open_fs,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -209,6 +211,7 @@ static struct file_operations acpi_video
 static int acpi_video_bus_POST_info_open_fs(struct inode *inode,
 					    struct file *file);
 static struct file_operations acpi_video_bus_POST_info_fops = {
+	.owner = THIS_MODULE,
 	.open = acpi_video_bus_POST_info_open_fs,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -217,6 +220,7 @@ static struct file_operations acpi_video
 
 static int acpi_video_bus_POST_open_fs(struct inode *inode, struct file *file);
 static struct file_operations acpi_video_bus_POST_fops = {
+	.owner = THIS_MODULE,
 	.open = acpi_video_bus_POST_open_fs,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -225,6 +229,7 @@ static struct file_operations acpi_video
 
 static int acpi_video_bus_DOS_open_fs(struct inode *inode, struct file *file);
 static struct file_operations acpi_video_bus_DOS_fops = {
+	.owner = THIS_MODULE,
 	.open = acpi_video_bus_DOS_open_fs,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -235,6 +240,7 @@ static struct file_operations acpi_video
 static int acpi_video_device_info_open_fs(struct inode *inode,
 					  struct file *file);
 static struct file_operations acpi_video_device_info_fops = {
+	.owner = THIS_MODULE,
 	.open = acpi_video_device_info_open_fs,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -244,6 +250,7 @@ static struct file_operations acpi_video
 static int acpi_video_device_state_open_fs(struct inode *inode,
 					   struct file *file);
 static struct file_operations acpi_video_device_state_fops = {
+	.owner = THIS_MODULE,
 	.open = acpi_video_device_state_open_fs,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -253,6 +260,7 @@ static struct file_operations acpi_video
 static int acpi_video_device_brightness_open_fs(struct inode *inode,
 						struct file *file);
 static struct file_operations acpi_video_device_brightness_fops = {
+	.owner = THIS_MODULE,
 	.open = acpi_video_device_brightness_open_fs,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -262,6 +270,7 @@ static struct file_operations acpi_video
 static int acpi_video_device_EDID_open_fs(struct inode *inode,
 					  struct file *file);
 static struct file_operations acpi_video_device_EDID_fops = {
+	.owner = THIS_MODULE,
 	.open = acpi_video_device_EDID_open_fs,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -1070,51 +1079,36 @@ static int acpi_video_device_add_fs(stru
 	}
 
 	/* 'info' [R] */
-	entry = create_proc_entry("info", S_IRUGO, acpi_device_dir(device));
+	entry = proc_create_data("info", S_IRUGO, acpi_device_dir(device),
+			&acpi_video_device_info_fops, acpi_driver_data(device));
 	if (!entry)
 		return -ENODEV;
-	else {
-		entry->proc_fops = &acpi_video_device_info_fops;
-		entry->data = acpi_driver_data(device);
-		entry->owner = THIS_MODULE;
-	}
 
 	/* 'state' [R/W] */
-	entry =
-	    create_proc_entry("state", S_IFREG | S_IRUGO | S_IWUSR,
-			      acpi_device_dir(device));
+	acpi_video_device_state_fops.write = acpi_video_device_write_state;
+	entry = proc_create_data("state", S_IFREG | S_IRUGO | S_IWUSR,
+				 acpi_device_dir(device),
+				 &acpi_video_device_state_fops,
+				 acpi_driver_data(device));
 	if (!entry)
 		return -ENODEV;
-	else {
-		acpi_video_device_state_fops.write = acpi_video_device_write_state;
-		entry->proc_fops = &acpi_video_device_state_fops;
-		entry->data = acpi_driver_data(device);
-		entry->owner = THIS_MODULE;
-	}
 
 	/* 'brightness' [R/W] */
-	entry =
-	    create_proc_entry("brightness", S_IFREG | S_IRUGO | S_IWUSR,
-			      acpi_device_dir(device));
+	acpi_video_device_brightness_fops.write =
+		acpi_video_device_write_brightness;
+	entry = proc_create_data("brightness", S_IFREG | S_IRUGO | S_IWUSR,
+				 acpi_device_dir(device),
+				 &acpi_video_device_brightness_fops,
+				 acpi_driver_data(device));
 	if (!entry)
 		return -ENODEV;
-	else {
-		acpi_video_device_brightness_fops.write = acpi_video_device_write_brightness;
-		entry->proc_fops = &acpi_video_device_brightness_fops;
-		entry->data = acpi_driver_data(device);
-		entry->owner = THIS_MODULE;
-	}
 
 	/* 'EDID' [R] */
-	entry = create_proc_entry("EDID", S_IRUGO, acpi_device_dir(device));
+	entry = proc_create_data("EDID", S_IRUGO, acpi_device_dir(device),
+				 &acpi_video_device_EDID_fops,
+				 acpi_driver_data(device));
 	if (!entry)
 		return -ENODEV;
-	else {
-		entry->proc_fops = &acpi_video_device_EDID_fops;
-		entry->data = acpi_driver_data(device);
-		entry->owner = THIS_MODULE;
-	}
-
 	return 0;
 }
 
@@ -1353,61 +1347,43 @@ static int acpi_video_bus_add_fs(struct 
 	}
 
 	/* 'info' [R] */
-	entry = create_proc_entry("info", S_IRUGO, acpi_device_dir(device));
+	entry = proc_create_data("info", S_IRUGO, acpi_device_dir(device),
+				 &acpi_video_bus_info_fops,
+				 acpi_driver_data(device));
 	if (!entry)
 		return -ENODEV;
-	else {
-		entry->proc_fops = &acpi_video_bus_info_fops;
-		entry->data = acpi_driver_data(device);
-		entry->owner = THIS_MODULE;
-	}
 
 	/* 'ROM' [R] */
-	entry = create_proc_entry("ROM", S_IRUGO, acpi_device_dir(device));
+	entry = proc_create_data("ROM", S_IRUGO, acpi_device_dir(device),
+				 &acpi_video_bus_ROM_fops,
+				 acpi_driver_data(device));
 	if (!entry)
 		return -ENODEV;
-	else {
-		entry->proc_fops = &acpi_video_bus_ROM_fops;
-		entry->data = acpi_driver_data(device);
-		entry->owner = THIS_MODULE;
-	}
 
 	/* 'POST_info' [R] */
-	entry =
-	    create_proc_entry("POST_info", S_IRUGO, acpi_device_dir(device));
+	entry = proc_create_data("POST_info", S_IRUGO, acpi_device_dir(device),
+				 &acpi_video_bus_POST_info_fops,
+				 acpi_driver_data(device));
 	if (!entry)
 		return -ENODEV;
-	else {
-		entry->proc_fops = &acpi_video_bus_POST_info_fops;
-		entry->data = acpi_driver_data(device);
-		entry->owner = THIS_MODULE;
-	}
 
 	/* 'POST' [R/W] */
-	entry =
-	    create_proc_entry("POST", S_IFREG | S_IRUGO | S_IRUSR,
-			      acpi_device_dir(device));
+	acpi_video_bus_POST_fops.write = acpi_video_bus_write_POST;
+	entry = proc_create_data("POST", S_IFREG | S_IRUGO | S_IRUSR,
+				 acpi_device_dir(device),
+				 &acpi_video_bus_POST_fops,
+				 acpi_driver_data(device));
 	if (!entry)
 		return -ENODEV;
-	else {
-		acpi_video_bus_POST_fops.write = acpi_video_bus_write_POST;
-		entry->proc_fops = &acpi_video_bus_POST_fops;
-		entry->data = acpi_driver_data(device);
-		entry->owner = THIS_MODULE;
-	}
 
 	/* 'DOS' [R/W] */
-	entry =
-	    create_proc_entry("DOS", S_IFREG | S_IRUGO | S_IRUSR,
-			      acpi_device_dir(device));
+	acpi_video_bus_DOS_fops.write = acpi_video_bus_write_DOS;
+	entry = proc_create_data("DOS", S_IFREG | S_IRUGO | S_IRUSR,
+				 acpi_device_dir(device),
+				 &acpi_video_bus_DOS_fops,
+				 acpi_driver_data(device));
 	if (!entry)
 		return -ENODEV;
-	else {
-		acpi_video_bus_DOS_fops.write = acpi_video_bus_write_DOS;
-		entry->proc_fops = &acpi_video_bus_DOS_fops;
-		entry->data = acpi_driver_data(device);
-		entry->owner = THIS_MODULE;
-	}
 
 	return 0;
 }
_

Patches currently in -mm which might be from den@openvz.org are

git-net.patch
proc-introduce-proc_create_data-to-setup-de-data.patch
nfsd-use-proc_create-to-setup-de-proc_fops.patch
nfs-use-proc_create-to-setup-de-proc_fops.patch
afs-use-non-racy-method-for-proc-entries-creation.patch
ext4-use-non-racy-method-for-proc-entries-creation.patch
reiserfs-use-non-racy-method-for-proc-entries-creation.patch
jbd2-use-non-racy-method-for-proc-entries-creation.patch
sysvipc-use-non-racy-method-for-proc-entries-creation.patch
mm-use-non-racy-method-for-proc-swaps-creation.patch
sound-use-non-racy-method-for-proc-driver-snd-page-alloc-creation.patch
zorro-use-non-racy-method-for-proc-entries-creation.patch
samples-use-non-racy-method-for-proc-marker-example-creation.patch
scsi-use-non-racy-method-for-proc-entries-creation.patch
usb-use-non-racy-method-for-proc-entries-creation.patch
s390-use-non-racy-method-for-proc-entries-creation.patch
arm-use-non-racy-method-for-proc-davinci_clocks-creation.patch
avr32-proc-use-non-racy-method-for-proc-tlb-creation.patch
cris-use-non-racy-method-for-proc-system_profile-creation.patch
ia64-use-non-racy-method-for-proc-entries-creation.patch
parisc-use-non-racy-method-for-proc-pcxl_dma-creation.patch
powerpc-use-non-racy-method-for-proc-entries-creation.patch
acpi-use-non-racy-method-for-proc-entries-creation.patch
netdev-use-non-racy-method-for-proc-entries-creation.patch
isdn-use-non-racy-method-for-proc-entries-creation.patch
kernel-use-non-racy-method-for-proc-entries-creation.patch
parisc-use-non-racy-method-for-proc-entries-creation.patch
drivers-use-non-racy-method-for-proc-entries-creation.patch
drivers-use-non-racy-method-for-proc-entries-creation-2.patch
sysctl-merge-equal-proc_sys_read-and-proc_sys_write.patch
sysctl-clean-from-unneeded-extern-and-forward-declarations.patch
sysctl-add-the-permissions-callback-on-the-ctl_table_root.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch

