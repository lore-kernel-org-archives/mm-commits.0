From: akpm@linux-foundation.org
Subject: + remove-software_suspend.patch added to -mm tree
Date: Wed, 11 Apr 2007 13:22:05 -0700
Message-ID: <200704112022.l3BKM7wn013496@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59257 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965337AbXDKUWS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 16:22:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johannes@sipsolutions.net, pavel@ucw.cz, rjw@sisk.pl


The patch titled
     remove software_suspend()
has been added to the -mm tree.  Its filename is
     remove-software_suspend.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: remove software_suspend()
From: Johannes Berg <johannes@sipsolutions.net>

Remove software_suspend() and all its users since
pm_suspend(PM_SUSPEND_DISK) should be equivalent and there's no point in
having two interfaces for the same thing.

The patch also changes the valid_state function to return 0 (false) for
PM_SUSPEND_DISK when SOFTWARE_SUSPEND is not configured instead of
accepting it and having the whole thing fail later.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/sleep/proc.c    |    2 +-
 drivers/i2c/chips/tps65010.c |    4 +++-
 include/linux/init.h         |    2 +-
 include/linux/suspend.h      |    8 --------
 kernel/power/main.c          |   21 +++++++--------------
 kernel/sys.c                 |    2 +-
 6 files changed, 13 insertions(+), 26 deletions(-)

diff -puN drivers/acpi/sleep/proc.c~remove-software_suspend drivers/acpi/sleep/proc.c
--- a/drivers/acpi/sleep/proc.c~remove-software_suspend
+++ a/drivers/acpi/sleep/proc.c
@@ -60,7 +60,7 @@ acpi_system_write_sleep(struct file *fil
 	state = simple_strtoul(str, NULL, 0);
 #ifdef CONFIG_SOFTWARE_SUSPEND
 	if (state == 4) {
-		error = software_suspend();
+		error = pm_suspend(PM_SUSPEND_DISK);
 		goto Done;
 	}
 #endif
diff -puN drivers/i2c/chips/tps65010.c~remove-software_suspend drivers/i2c/chips/tps65010.c
--- a/drivers/i2c/chips/tps65010.c~remove-software_suspend
+++ a/drivers/i2c/chips/tps65010.c
@@ -351,8 +351,10 @@ static void tps65010_interrupt(struct tp
 #if 0
 			/* REVISIT:  this might need its own workqueue
 			 * plus tweaks including deadlock avoidance ...
+			 * also needs to get error handling and probably
+			 * an #ifdef CONFIG_SOFTWARE_SUSPEND
 			 */
-			software_suspend();
+			pm_suspend(PM_SUSPEND_DISK);
 #endif
 			poll = 1;
 		}
diff -puN include/linux/init.h~remove-software_suspend include/linux/init.h
--- a/include/linux/init.h~remove-software_suspend
+++ a/include/linux/init.h
@@ -228,7 +228,7 @@ void __init parse_early_param(void);
 #define __obsolete_setup(str) 			/* nothing */
 #endif
 
-/* Data marked not to be saved by software_suspend() */
+/* Data marked not to be saved by software suspend */
 #define __nosavedata __attribute__ ((__section__ (".data.nosave")))
 
 /* This means "can be init if no module support, otherwise module load
diff -puN include/linux/suspend.h~remove-software_suspend include/linux/suspend.h
--- a/include/linux/suspend.h~remove-software_suspend
+++ a/include/linux/suspend.h
@@ -33,8 +33,6 @@ static inline void pm_restore_console(vo
 #endif
 
 #if defined(CONFIG_PM) && defined(CONFIG_SOFTWARE_SUSPEND)
-/* kernel/power/swsusp.c */
-extern int software_suspend(void);
 /* kernel/power/snapshot.c */
 extern void __init register_nosave_region(unsigned long, unsigned long);
 extern int swsusp_page_is_forbidden(struct page *);
@@ -42,12 +40,6 @@ extern void swsusp_set_page_free(struct 
 extern void swsusp_unset_page_free(struct page *);
 extern unsigned long get_safe_page(gfp_t gfp_mask);
 #else
-static inline int software_suspend(void)
-{
-	printk("Warning: fake suspend called\n");
-	return -ENOSYS;
-}
-
 static inline void register_nosave_region(unsigned long b, unsigned long e) {}
 static inline int swsusp_page_is_forbidden(struct page *p) { return 0; }
 static inline void swsusp_set_page_free(struct page *p) {}
diff -puN kernel/power/main.c~remove-software_suspend kernel/power/main.c
--- a/kernel/power/main.c~remove-software_suspend
+++ a/kernel/power/main.c
@@ -172,17 +172,21 @@ static void suspend_finish(suspend_state
 static const char * const pm_states[PM_SUSPEND_MAX] = {
 	[PM_SUSPEND_STANDBY]	= "standby",
 	[PM_SUSPEND_MEM]	= "mem",
-#ifdef CONFIG_SOFTWARE_SUSPEND
 	[PM_SUSPEND_DISK]	= "disk",
-#endif
 };
 
 static inline int valid_state(suspend_state_t state)
 {
 	/* Suspend-to-disk does not really need low-level support.
-	 * It can work with reboot if needed. */
+	 * It can work with shutdown/reboot if needed. If it isn't
+	 * configured, then it cannot be supported.
+	 */
 	if (state == PM_SUSPEND_DISK)
+#ifdef CONFIG_SOFTWARE_SUSPEND
 		return 1;
+#else
+		return 0;
+#endif
 
 	/* all other states need lowlevel support and need to be
 	 * valid to the lowlevel implementation, no valid callback
@@ -232,17 +236,6 @@ static int enter_state(suspend_state_t s
 	return error;
 }
 
-#ifdef CONFIG_SOFTWARE_SUSPEND
-/*
- * This is main interface to the outside world. It needs to be
- * called from process context.
- */
-int software_suspend(void)
-{
-	return enter_state(PM_SUSPEND_DISK);
-}
-#endif
-
 
 /**
  *	pm_suspend - Externally visible function for suspending system.
diff -puN kernel/sys.c~remove-software_suspend kernel/sys.c
--- a/kernel/sys.c~remove-software_suspend
+++ a/kernel/sys.c
@@ -881,7 +881,7 @@ asmlinkage long sys_reboot(int magic1, i
 #ifdef CONFIG_SOFTWARE_SUSPEND
 	case LINUX_REBOOT_CMD_SW_SUSPEND:
 		{
-			int ret = software_suspend();
+			int ret = pm_suspend(PM_SUSPEND_DISK);
 			unlock_kernel();
 			return ret;
 		}
_

Patches currently in -mm which might be from johannes@sipsolutions.net are

git-alsa.patch
git-powerpc.patch
git-powerpc-arch-powerpc-sysdev-timerc-build-fix.patch
git-net.patch
git-wireless.patch
rework-pm_ops-pm_disk_mode-kill-misuse.patch
power-management-remove-firmware-disk-mode.patch
power-management-implement-pm_opsvalid-for-everybody.patch
power-management-force-pm_opsvalid-callback-to-be.patch
remove-software_suspend.patch
fix-sscanf-%n-match-at-end-of-input-string.patch
fix-sscanf-%n-match-at-end-of-input-string-tidy.patch
