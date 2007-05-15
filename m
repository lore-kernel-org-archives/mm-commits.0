From: akpm@linux-foundation.org
Subject: + use-mutex-instead-of-semaphore-in-ide-driver.patch added to -mm tree
Date: Mon, 14 May 2007 20:00:43 -0700
Message-ID: <200705150300.l4F30hgg032697@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56049 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752674AbXEODA6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 May 2007 23:00:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias.kaehlcke@gmail.com, bzolnier@gmail.com


The patch titled
     Use mutex instead of semaphore in IDE driver
has been added to the -mm tree.  Its filename is
     use-mutex-instead-of-semaphore-in-ide-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use mutex instead of semaphore in IDE driver
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

The IDE driver uses a semaphore as mutex.  Use the mutex API instead of the
(binary) semaphore.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/ide-disk.c |    8 ++++----
 drivers/ide/ide-proc.c |   34 +++++++++++++++++-----------------
 drivers/ide/ide.c      |   12 ++++++------
 include/linux/ide.h    |    3 ++-
 4 files changed, 29 insertions(+), 28 deletions(-)

diff -puN drivers/ide/ide-disk.c~use-mutex-instead-of-semaphore-in-ide-driver drivers/ide/ide-disk.c
--- a/drivers/ide/ide-disk.c~use-mutex-instead-of-semaphore-in-ide-driver
+++ a/drivers/ide/ide-disk.c
@@ -1178,11 +1178,11 @@ static int idedisk_ioctl(struct inode *i
 	return generic_ide_ioctl(drive, file, bdev, cmd, arg);
 
 read_val:
-	down(&ide_setting_sem);
+	mutex_lock(&ide_setting_mtx);
 	spin_lock_irqsave(&ide_lock, flags);
 	err = *val;
 	spin_unlock_irqrestore(&ide_lock, flags);
-	up(&ide_setting_sem);
+	mutex_unlock(&ide_setting_mtx);
 	return err >= 0 ? put_user(err, (long __user *)arg) : err;
 
 set_val:
@@ -1192,9 +1192,9 @@ set_val:
 		if (!capable(CAP_SYS_ADMIN))
 			err = -EACCES;
 		else {
-			down(&ide_setting_sem);
+			mutex_lock(&ide_setting_mtx);
 			err = setfunc(drive, arg);
-			up(&ide_setting_sem);
+			mutex_unlock(&ide_setting_mtx);
 		}
 	}
 	return err;
diff -puN drivers/ide/ide-proc.c~use-mutex-instead-of-semaphore-in-ide-driver drivers/ide/ide-proc.c
--- a/drivers/ide/ide-proc.c~use-mutex-instead-of-semaphore-in-ide-driver
+++ a/drivers/ide/ide-proc.c
@@ -154,7 +154,7 @@ static int __ide_add_setting(ide_drive_t
 {
 	ide_settings_t **p = (ide_settings_t **) &drive->settings, *setting = NULL;
 
-	down(&ide_setting_sem);
+	mutex_lock(&ide_setting_mtx);
 	while ((*p) && strcmp((*p)->name, name) < 0)
 		p = &((*p)->next);
 	if ((setting = kzalloc(sizeof(*setting), GFP_KERNEL)) == NULL)
@@ -175,10 +175,10 @@ static int __ide_add_setting(ide_drive_t
 	if (auto_remove)
 		setting->auto_remove = 1;
 	*p = setting;
-	up(&ide_setting_sem);
+	mutex_unlock(&ide_setting_mtx);
 	return 0;
 abort:
-	up(&ide_setting_sem);
+	mutex_unlock(&ide_setting_mtx);
 	kfree(setting);
 	return -1;
 }
@@ -222,7 +222,7 @@ static void __ide_remove_setting (ide_dr
  *
  *	Automatically remove all the driver specific settings for this
  *	drive. This function may not be called from IRQ context. The
- *	caller must hold ide_setting_sem.
+ *	caller must hold ide_setting_mtx.
  */
 
 static void auto_remove_settings (ide_drive_t *drive)
@@ -267,7 +267,7 @@ static ide_settings_t *ide_find_setting_
  *	@setting: drive setting
  *
  *	Read a drive setting and return the value. The caller
- *	must hold the ide_setting_sem when making this call.
+ *	must hold the ide_setting_mtx when making this call.
  *
  *	BUGS: the data return and error are the same return value
  *	so an error -EINVAL and true return of the same value cannot
@@ -304,7 +304,7 @@ static int ide_read_setting(ide_drive_t 
  *	@val: value
  *
  *	Write a drive setting if it is possible. The caller
- *	must hold the ide_setting_sem when making this call.
+ *	must hold the ide_setting_mtx when making this call.
  *
  *	BUGS: the data return and error are the same return value
  *	so an error -EINVAL and true return of the same value cannot
@@ -365,7 +365,7 @@ static int set_xfer_rate (ide_drive_t *d
  *	@drive: drive being configured
  *
  *	Add the generic parts of the system settings to the /proc files.
- *	The caller must not be holding the ide_setting_sem.
+ *	The caller must not be holding the ide_setting_mtx.
  */
 
 void ide_add_generic_settings (ide_drive_t *drive)
@@ -406,7 +406,7 @@ static int proc_ide_read_settings
 
 	proc_ide_settings_warn();
 
-	down(&ide_setting_sem);
+	mutex_lock(&ide_setting_mtx);
 	out += sprintf(out, "name\t\t\tvalue\t\tmin\t\tmax\t\tmode\n");
 	out += sprintf(out, "----\t\t\t-----\t\t---\t\t---\t\t----\n");
 	while(setting) {
@@ -426,7 +426,7 @@ static int proc_ide_read_settings
 		setting = setting->next;
 	}
 	len = out - page;
-	up(&ide_setting_sem);
+	mutex_unlock(&ide_setting_mtx);
 	PROC_IDE_READ_RETURN(page,start,off,count,eof,len);
 }
 
@@ -506,16 +506,16 @@ static int proc_ide_write_settings(struc
 				++p;
 			}
 
-			down(&ide_setting_sem);
+			mutex_lock(&ide_setting_mtx);
 			setting = ide_find_setting_by_name(drive, name);
 			if (!setting)
 			{
-				up(&ide_setting_sem);
+				mutex_unlock(&ide_setting_mtx);
 				goto parse_error;
 			}
 			if (for_real)
 				ide_write_setting(drive, setting, val * setting->div_factor / setting->mul_factor);
-			up(&ide_setting_sem);
+			mutex_unlock(&ide_setting_mtx);
 		}
 	} while (!for_real++);
 	free_page((unsigned long)buf);
@@ -703,7 +703,7 @@ EXPORT_SYMBOL(ide_proc_register_driver);
  *	Clean up the driver specific /proc files and IDE settings
  *	for a given drive.
  *
- *	Takes ide_setting_sem and ide_lock.
+ *	Takes ide_setting_mtx and ide_lock.
  *	Caller must hold none of the locks.
  */
 
@@ -713,10 +713,10 @@ void ide_proc_unregister_driver(ide_driv
 
 	ide_remove_proc_entries(drive->proc, driver->proc);
 
-	down(&ide_setting_sem);
+	mutex_lock(&ide_setting_mtx);
 	spin_lock_irqsave(&ide_lock, flags);
 	/*
-	 * ide_setting_sem protects the settings list
+	 * ide_setting_mtx protects the settings list
 	 * ide_lock protects the use of settings
 	 *
 	 * so we need to hold both, ide_settings_sem because we want to
@@ -724,11 +724,11 @@ void ide_proc_unregister_driver(ide_driv
 	 * a setting out that is being used.
 	 *
 	 * OTOH both ide_{read,write}_setting are only ever used under
-	 * ide_setting_sem.
+	 * ide_setting_mtx.
 	 */
 	auto_remove_settings(drive);
 	spin_unlock_irqrestore(&ide_lock, flags);
-	up(&ide_setting_sem);
+	mutex_unlock(&ide_setting_mtx);
 }
 
 EXPORT_SYMBOL(ide_proc_unregister_driver);
diff -puN drivers/ide/ide.c~use-mutex-instead-of-semaphore-in-ide-driver drivers/ide/ide.c
--- a/drivers/ide/ide.c~use-mutex-instead-of-semaphore-in-ide-driver
+++ a/drivers/ide/ide.c
@@ -817,9 +817,9 @@ EXPORT_SYMBOL(ide_register_hw);
  *	Locks for IDE setting functionality
  */
 
-DECLARE_MUTEX(ide_setting_sem);
+DEFINE_MUTEX(ide_setting_mtx);
 
-EXPORT_SYMBOL_GPL(ide_setting_sem);
+EXPORT_SYMBOL_GPL(ide_setting_mtx);
 
 /**
  *	ide_spin_wait_hwgroup	-	wait for group
@@ -1182,11 +1182,11 @@ int generic_ide_ioctl(ide_drive_t *drive
 	}
 
 read_val:
-	down(&ide_setting_sem);
+	mutex_lock(&ide_setting_mtx);
 	spin_lock_irqsave(&ide_lock, flags);
 	err = *val;
 	spin_unlock_irqrestore(&ide_lock, flags);
-	up(&ide_setting_sem);
+	mutex_unlock(&ide_setting_mtx);
 	return err >= 0 ? put_user(err, (long __user *)arg) : err;
 
 set_val:
@@ -1196,9 +1196,9 @@ set_val:
 		if (!capable(CAP_SYS_ADMIN))
 			err = -EACCES;
 		else {
-			down(&ide_setting_sem);
+			mutex_lock(&ide_setting_mtx);
 			err = setfunc(drive, arg);
-			up(&ide_setting_sem);
+			mutex_unlock(&ide_setting_mtx);
 		}
 	}
 	return err;
diff -puN include/linux/ide.h~use-mutex-instead-of-semaphore-in-ide-driver include/linux/ide.h
--- a/include/linux/ide.h~use-mutex-instead-of-semaphore-in-ide-driver
+++ a/include/linux/ide.h
@@ -25,6 +25,7 @@
 #include <asm/system.h>
 #include <asm/io.h>
 #include <asm/semaphore.h>
+#include <asm/mutex.h>
 
 /******************************************************************************
  * IDE driver configuration options (play with these as desired):
@@ -863,7 +864,7 @@ typedef struct hwgroup_s {
 
 typedef struct ide_driver_s ide_driver_t;
 
-extern struct semaphore ide_setting_sem;
+extern struct mutex ide_setting_mtx;
 
 int set_io_32bit(ide_drive_t *, int);
 int set_pio_mode(ide_drive_t *, int);
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

kcopyd-use-mutex-instead-of-semaphore.patch
power-management-use-mutexes-instead-of-semaphores.patch
sysdev-use-mutex-instead-of-semaphore.patch
git-dvb.patch
use-mutex-instead-of-binary-semaphore-in-idt77252-driver.patch
use-mutex-instead-of-binary-semaphore-in-cdu-31a-driver.patch
use-mutex-instead-of-semaphore-in-sbpcd-driver.patch
use-mutexes-instead-of-semaphores-in-i2o-driver.patch
use-mutex-instead-of-semaphore-in-ide-driver.patch
use-mutex-instead-of-semaphore-in-capi-20-driver.patch
use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver.patch
use-mutex-instead-of-semaphore-in-the-mtd-dataflash-driver.patch
