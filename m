From: akpm@linux-foundation.org
Subject: + hibernation-introduce-begin-and-end-callbacks.patch added to -mm tree
Date: Mon, 07 Jan 2008 16:14:45 -0800
Message-ID: <200801080014.m080EjND019376@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48346 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755524AbYAHAPZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2008 19:15:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl


The patch titled
     Hibernation: Introduce begin() and end() callbacks
has been added to the -mm tree.  Its filename is
     hibernation-introduce-begin-and-end-callbacks.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Hibernation: Introduce begin() and end() callbacks
From: Rafael J. Wysocki <rjw@sisk.pl>

Introduce global hibernation callback .end() and rename global hibernation
callback .start() to .begin(), in analogy with the recent modifications of the
global suspend callbacks.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/sleep/main.c |   14 ++++++++++++--
 include/linux/suspend.h   |   14 +++++++++-----
 kernel/power/disk.c       |   33 ++++++++++++++++++++++++---------
 3 files changed, 45 insertions(+), 16 deletions(-)

diff -puN drivers/acpi/sleep/main.c~hibernation-introduce-begin-and-end-callbacks drivers/acpi/sleep/main.c
--- a/drivers/acpi/sleep/main.c~hibernation-introduce-begin-and-end-callbacks
+++ a/drivers/acpi/sleep/main.c
@@ -281,7 +281,7 @@ static struct dmi_system_id __initdata a
 #endif /* CONFIG_SUSPEND */
 
 #ifdef CONFIG_HIBERNATION
-static int acpi_hibernation_start(void)
+static int acpi_hibernation_begin(void)
 {
 	acpi_target_sleep_state = ACPI_STATE_S4;
 	return 0;
@@ -341,6 +341,15 @@ static void acpi_hibernation_finish(void
 	acpi_target_sleep_state = ACPI_STATE_S0;
 }
 
+static void acpi_hibernation_end(void)
+{
+	/*
+	 * This is necessary in case acpi_hibernation_finish() is not called
+	 * during a failing transition to the sleep state.
+	 */
+	acpi_target_sleep_state = ACPI_STATE_S0;
+}
+
 static int acpi_hibernation_pre_restore(void)
 {
 	acpi_status status;
@@ -356,7 +365,8 @@ static void acpi_hibernation_restore_cle
 }
 
 static struct platform_hibernation_ops acpi_hibernation_ops = {
-	.start = acpi_hibernation_start,
+	.begin = acpi_hibernation_begin,
+	.end = acpi_hibernation_end,
 	.pre_snapshot = acpi_hibernation_prepare,
 	.finish = acpi_hibernation_finish,
 	.prepare = acpi_hibernation_prepare,
diff -puN include/linux/suspend.h~hibernation-introduce-begin-and-end-callbacks include/linux/suspend.h
--- a/include/linux/suspend.h~hibernation-introduce-begin-and-end-callbacks
+++ a/include/linux/suspend.h
@@ -136,14 +136,17 @@ extern void mark_free_pages(struct zone 
 /**
  * struct platform_hibernation_ops - hibernation platform support
  *
- * The methods in this structure allow a platform to override the default
- * mechanism of shutting down the machine during a hibernation transition.
+ * The methods in this structure allow a platform to carry out special
+ * operations required by it during a hibernation transition.
  *
- * All three methods must be assigned.
+ * All the methods below must be implemented.
  *
- * @start: Tell the platform driver that we're starting hibernation.
+ * @begin: Tell the platform driver that we're starting hibernation.
  *	Called right after shrinking memory and before freezing devices.
  *
+ * @end: Called by the PM core right after resuming devices, to indicate to
+ *	the platform that the system has returned to the working state.
+ *
  * @pre_snapshot: Prepare the platform for creating the hibernation image.
  *	Called right after devices have been frozen and before the nonboot
  *	CPUs are disabled (runs with IRQs on).
@@ -178,7 +181,8 @@ extern void mark_free_pages(struct zone 
  *	thawing devices (runs with IRQs on).
  */
 struct platform_hibernation_ops {
-	int (*start)(void);
+	int (*begin)(void);
+	void (*end)(void);
 	int (*pre_snapshot)(void);
 	void (*finish)(void);
 	int (*prepare)(void);
diff -puN kernel/power/disk.c~hibernation-introduce-begin-and-end-callbacks kernel/power/disk.c
--- a/kernel/power/disk.c~hibernation-introduce-begin-and-end-callbacks
+++ a/kernel/power/disk.c
@@ -54,8 +54,8 @@ static struct platform_hibernation_ops *
 
 void hibernation_set_ops(struct platform_hibernation_ops *ops)
 {
-	if (ops && !(ops->start && ops->pre_snapshot && ops->finish
-	    && ops->prepare && ops->enter && ops->pre_restore
+	if (ops && !(ops->begin && ops->end &&  ops->pre_snapshot
+	    && ops->prepare && ops->finish && ops->enter && ops->pre_restore
 	    && ops->restore_cleanup)) {
 		WARN_ON(1);
 		return;
@@ -100,14 +100,25 @@ static int hibernation_test(int level) {
 #endif /* !CONFIG_PM_DEBUG */
 
 /**
- *	platform_start - tell the platform driver that we're starting
+ *	platform_begin - tell the platform driver that we're starting
  *	hibernation
  */
 
-static int platform_start(int platform_mode)
+static int platform_begin(int platform_mode)
 {
 	return (platform_mode && hibernation_ops) ?
-		hibernation_ops->start() : 0;
+		hibernation_ops->begin() : 0;
+}
+
+/**
+ *	platform_end - tell the platform driver that we've entered the
+ *	working state
+ */
+
+static void platform_end(int platform_mode)
+{
+	if (platform_mode && hibernation_ops)
+		hibernation_ops->end();
 }
 
 /**
@@ -237,9 +248,9 @@ int hibernation_snapshot(int platform_mo
 	if (error)
 		return error;
 
-	error = platform_start(platform_mode);
+	error = platform_begin(platform_mode);
 	if (error)
-		return error;
+		goto Close;
 
 	suspend_console();
 	error = device_suspend(PMSG_FREEZE);
@@ -272,6 +283,8 @@ int hibernation_snapshot(int platform_mo
 	device_resume();
  Resume_console:
 	resume_console();
+ Close:
+	platform_end(platform_mode);
 	return error;
 }
 
@@ -373,9 +386,9 @@ int hibernation_platform_enter(void)
 	 * hibernation_ops->finish() before saving the image, so we should let
 	 * the firmware know that we're going to enter the sleep state after all
 	 */
-	error = hibernation_ops->start();
+	error = hibernation_ops->begin();
 	if (error)
-		return error;
+		goto Close;
 
 	suspend_console();
 	error = device_suspend(PMSG_SUSPEND);
@@ -409,6 +422,8 @@ int hibernation_platform_enter(void)
 	device_resume();
  Resume_console:
 	resume_console();
+ Close:
+	hibernation_ops->end();
 	return error;
 }
 
_

Patches currently in -mm which might be from rjw@sisk.pl are

git-acpi.patch
suspend-introduce-begin-and-end-callbacks.patch
acpi-separate-invocations-of-_gts-and-_bfs-from-_pts-and-_wak.patch
acpi-separate-disabling-of-gpes-from-_pts.patch
acpi-suspend-call-_pts-before-suspending-devices.patch
hibernation-introduce-begin-and-end-callbacks.patch
acpi-hibernation-call-_pts-before-suspending-devices.patch
acpi-print-message-before-calling-_pts.patch
revert-gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch
gregkh-driver-kset-convert-to-kobj_sysfs_ops-vs-git-acpi.patch
git-x86.patch
git-xfs.patch
cpufreq-initialise-default-governor-before-use.patch
page-allocator-clean-up-pcp-draining-functions.patch
page-allocator-clean-up-pcp-draining-functions-swsusp-fix.patch
page-allocator-clean-up-pcp-draining-functions-swsusp-fix-fix.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
pnp-do-not-stop-start-devices-in-suspend-resume-path.patch
proc-fix-the-threaded-proc-self.patch
shrink_slab-handle-bad-shrinkers.patch
