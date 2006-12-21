From: akpm@osdl.org
Subject: + pm-change-code-ordering-in-mainc.patch added to -mm tree
Date: Wed, 20 Dec 2006 22:20:10 -0800
Message-ID: <200612210620.kBL6KANC017532@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:41976 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422754AbWLUGUg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Dec 2006 01:20:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, greg@kroah.com, mochel@digitalimplant.org, nigel@suspend2.net, pavel@ucw.cz


The patch titled
     PM: Change code ordering in main.c
has been added to the -mm tree.  Its filename is
     pm-change-code-ordering-in-mainc.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PM: Change code ordering in main.c
From: "Rafael J. Wysocki" <rjw@sisk.pl>

As indicated in a recent thread on Linux-PM, it's necessary to call
pm_ops->finish() before devce_resume(), but enable_nonboot_cpus() has to be
called before pm_ops->finish() (cf. 
http://lists.osdl.org/pipermail/linux-pm/2006-November/004164.html).  For
consistency, it seems reasonable to call disable_nonboot_cpus() after
device_suspend().

This way the suspend code will remain symmetrical with respect to the resume
code and it may allow us to speed up things in the future by suspending and
resuming devices and/or saving the suspend image in many threads.

The following series of patches reorders the suspend and resume code so that
nonboot CPUs are disabled after devices have been suspended and enabled before
the devices are resumed.  It also causes pm_ops->finish() to be called after
enable_nonboot_cpus() wherever necessary.


This patch:

Change the ordering of code in kernel/power/main.c so that device_suspend()
is called before disable_nonboot_cpus() and pm_ops->finish() is called after
enable_nonboot_cpus() and before device_resume(), as indicated by recent
discussion on Linux-PM
(cf. http://lists.osdl.org/pipermail/linux-pm/2006-November/004164.html).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Greg KH <greg@kroah.com>
Cc: Nigel Cunningham <nigel@suspend2.net>
Cc: Patrick Mochel <mochel@digitalimplant.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/power/main.c |   34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff -puN kernel/power/main.c~pm-change-code-ordering-in-mainc kernel/power/main.c
--- a/kernel/power/main.c~pm-change-code-ordering-in-mainc
+++ a/kernel/power/main.c
@@ -43,6 +43,11 @@ void pm_set_ops(struct pm_ops * ops)
 	mutex_unlock(&pm_mutex);
 }
 
+static inline void pm_finish(suspend_state_t state)
+{
+	if (pm_ops->finish)
+		pm_ops->finish(state);
+}
 
 /**
  *	suspend_prepare - Do prep work before entering low-power state.
@@ -63,10 +68,6 @@ static int suspend_prepare(suspend_state
 
 	pm_prepare_console();
 
-	error = disable_nonboot_cpus();
-	if (error)
-		goto Enable_cpu;
-
 	if (freeze_processes()) {
 		error = -EAGAIN;
 		goto Thaw;
@@ -88,18 +89,22 @@ static int suspend_prepare(suspend_state
 	}
 
 	suspend_console();
-	if ((error = device_suspend(PMSG_SUSPEND))) {
+	error = device_suspend(PMSG_SUSPEND);
+	if (error) {
 		printk(KERN_ERR "Some devices failed to suspend\n");
-		goto Finish;
+		goto Resume_devices;
 	}
-	return 0;
- Finish:
-	if (pm_ops->finish)
-		pm_ops->finish(state);
+	error = disable_nonboot_cpus();
+	if (!error)
+		return 0;
+
+	enable_nonboot_cpus();
+ Resume_devices:
+	pm_finish(state);
+	device_resume();
+	resume_console();
  Thaw:
 	thaw_processes();
- Enable_cpu:
-	enable_nonboot_cpus();
 	pm_restore_console();
 	return error;
 }
@@ -134,12 +139,11 @@ int suspend_enter(suspend_state_t state)
 
 static void suspend_finish(suspend_state_t state)
 {
+	enable_nonboot_cpus();
+	pm_finish(state);
 	device_resume();
 	resume_console();
 	thaw_processes();
-	enable_nonboot_cpus();
-	if (pm_ops && pm_ops->finish)
-		pm_ops->finish(state);
 	pm_restore_console();
 }
 
_

Patches currently in -mm which might be from rjw@sisk.pl are

fix-swapped-parameters-in-mm-vmscanc.patch
shrink_all_memory-fix-lru_pages-handling.patch
git-acpi.patch
pm-change-code-ordering-in-mainc.patch
swsusp-change-code-ordering-in-diskc.patch
swsusp-change-code-ordering-in-userc.patch
swsusp-change-code-ordering-in-userc-sanity.patch
swsusp-change-pm_ops-handling-by-userland-interface.patch
shrink_slab-handle-bad-shrinkers.patch

