From: akpm@linux-foundation.org
Subject: + make-proc-acpi-ac_adapter-dependent-on-acpi_procfs.patch added to -mm tree
Date: Mon, 05 Nov 2007 14:55:21 -0800
Message-ID: <200711052255.lA5MtLqp023840@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45224 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754332AbXKEWzn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 17:55:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arvidjaar@mail.ru, astarikovskiy@suse.de, lenb@kernel.org


The patch titled
     make /proc/acpi/ac_adapter dependent on ACPI_PROCFS
has been added to the -mm tree.  Its filename is
     make-proc-acpi-ac_adapter-dependent-on-acpi_procfs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: make /proc/acpi/ac_adapter dependent on ACPI_PROCFS
From: Andrey Borzenkov <arvidjaar@mail.ru>

Do not provide /proc/acpi/ac_adapter if ACPI_PROCFS is not defined.  This
eliminates duplicated power adapters in HAL and makes it consistent with
battery module

Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>
Acked-by: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/ac.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff -puN drivers/acpi/ac.c~make-proc-acpi-ac_adapter-dependent-on-acpi_procfs drivers/acpi/ac.c
--- a/drivers/acpi/ac.c~make-proc-acpi-ac_adapter-dependent-on-acpi_procfs
+++ a/drivers/acpi/ac.c
@@ -27,8 +27,10 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/types.h>
+#ifdef CONFIG_ACPI_PROCFS
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
+#endif
 #include <linux/power_supply.h>
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
@@ -49,12 +51,14 @@ MODULE_AUTHOR("Paul Diefenbaugh");
 MODULE_DESCRIPTION("ACPI AC Adapter Driver");
 MODULE_LICENSE("GPL");
 
+#ifdef CONFIG_ACPI_PROCFS
 extern struct proc_dir_entry *acpi_lock_ac_dir(void);
 extern void *acpi_unlock_ac_dir(struct proc_dir_entry *acpi_ac_dir);
+static int acpi_ac_open_fs(struct inode *inode, struct file *file);
+#endif
 
 static int acpi_ac_add(struct acpi_device *device);
 static int acpi_ac_remove(struct acpi_device *device, int type);
-static int acpi_ac_open_fs(struct inode *inode, struct file *file);
 
 const static struct acpi_device_id ac_device_ids[] = {
 	{"ACPI0003", 0},
@@ -80,12 +84,15 @@ struct acpi_ac {
 
 #define to_acpi_ac(x) container_of(x, struct acpi_ac, charger);
 
+#ifdef CONFIG_ACPI_PROCFS
 static const struct file_operations acpi_ac_fops = {
 	.open = acpi_ac_open_fs,
 	.read = seq_read,
 	.llseek = seq_lseek,
 	.release = single_release,
 };
+#endif
+
 static int get_ac_property(struct power_supply *psy,
 			   enum power_supply_property psp,
 			   union power_supply_propval *val)
@@ -127,6 +134,7 @@ static int acpi_ac_get_state(struct acpi
 	return 0;
 }
 
+#ifdef CONFIG_ACPI_PROCFS
 /* --------------------------------------------------------------------------
                               FS Interface (/proc)
    -------------------------------------------------------------------------- */
@@ -206,6 +214,7 @@ static int acpi_ac_remove_fs(struct acpi
 
 	return 0;
 }
+#endif
 
 /* --------------------------------------------------------------------------
                                    Driver Model
@@ -264,7 +273,9 @@ static int acpi_ac_add(struct acpi_devic
 	if (result)
 		goto end;
 
+#ifdef CONFIG_ACPI_PROCFS
 	result = acpi_ac_add_fs(device);
+#endif
 	if (result)
 		goto end;
 	ac->charger.name = acpi_device_bid(device);
@@ -287,7 +298,9 @@ static int acpi_ac_add(struct acpi_devic
 
       end:
 	if (result) {
+#ifdef CONFIG_ACPI_PROCFS
 		acpi_ac_remove_fs(device);
+#endif
 		kfree(ac);
 	}
 
@@ -309,7 +322,9 @@ static int acpi_ac_remove(struct acpi_de
 					    ACPI_ALL_NOTIFY, acpi_ac_notify);
 	if (ac->charger.dev)
 		power_supply_unregister(&ac->charger);
+#ifdef CONFIG_ACPI_PROCFS
 	acpi_ac_remove_fs(device);
+#endif
 
 	kfree(ac);
 
@@ -323,13 +338,17 @@ static int __init acpi_ac_init(void)
 	if (acpi_disabled)
 		return -ENODEV;
 
+#ifdef CONFIG_ACPI_PROCFS
 	acpi_ac_dir = acpi_lock_ac_dir();
 	if (!acpi_ac_dir)
 		return -ENODEV;
+#endif
 
 	result = acpi_bus_register_driver(&acpi_ac_driver);
 	if (result < 0) {
+#ifdef CONFIG_ACPI_PROCFS
 		acpi_unlock_ac_dir(acpi_ac_dir);
+#endif
 		return -ENODEV;
 	}
 
@@ -341,7 +360,9 @@ static void __exit acpi_ac_exit(void)
 
 	acpi_bus_unregister_driver(&acpi_ac_driver);
 
+#ifdef CONFIG_ACPI_PROCFS
 	acpi_unlock_ac_dir(acpi_ac_dir);
+#endif
 
 	return;
 }
_

Patches currently in -mm which might be from arvidjaar@mail.ru are

origin.patch
make-proc-acpi-ac_adapter-dependent-on-acpi_procfs.patch
