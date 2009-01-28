From: akpm@linux-foundation.org
Subject: [merged] hibernation-introduce-system_entering_hibernation.patch removed from -mm tree
Date: Wed, 28 Jan 2009 15:28:46 -0800
Message-ID: <200901282328.n0SNSk48006653@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44897 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757555AbZA1X3q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Jan 2009 18:29:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, alan@lxorguk.ukuu.org.uk, elendil@planet.nl, fweisbec@gmail.com, jeff@garzik.org, maciej.rutecki@gmail.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     hibernation: introduce system_entering_hibernation
has been removed from the -mm tree.  Its filename was
     hibernation-introduce-system_entering_hibernation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hibernation: introduce system_entering_hibernation
From: Rafael J. Wysocki <rjw@sisk.pl>

Introduce boolean function system_entering_hibernation() returning 'true'
during the last phase of hibernation, in which devices are being put into
low power states and the sleep state (for example, ACPI S4) is finally
entered.

Some device drivers need such a function to check if the system is in the
final phase of hibernation.  In particular, some SATA drivers are going to
use it for blacklisting systems in which the disks should not be spun down
during the last phase of hibernation (the BIOS will do that anyway).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Tested-by: Maciej Rutecki <maciej.rutecki@gmail.com>
Tested-by: Frans Pop <elendil@planet.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/suspend.h |    2 ++
 kernel/power/disk.c     |   10 ++++++++++
 2 files changed, 12 insertions(+)

diff -puN include/linux/suspend.h~hibernation-introduce-system_entering_hibernation include/linux/suspend.h
--- a/include/linux/suspend.h~hibernation-introduce-system_entering_hibernation
+++ a/include/linux/suspend.h
@@ -237,6 +237,7 @@ extern int hibernate_nvs_alloc(void);
 extern void hibernate_nvs_free(void);
 extern void hibernate_nvs_save(void);
 extern void hibernate_nvs_restore(void);
+extern bool system_entering_hibernation(void);
 #else /* CONFIG_HIBERNATION */
 static inline int swsusp_page_is_forbidden(struct page *p) { return 0; }
 static inline void swsusp_set_page_free(struct page *p) {}
@@ -252,6 +253,7 @@ static inline int hibernate_nvs_alloc(vo
 static inline void hibernate_nvs_free(void) {}
 static inline void hibernate_nvs_save(void) {}
 static inline void hibernate_nvs_restore(void) {}
+static inline bool system_entering_hibernation(void) { return false; }
 #endif /* CONFIG_HIBERNATION */
 
 #ifdef CONFIG_PM_SLEEP
diff -puN kernel/power/disk.c~hibernation-introduce-system_entering_hibernation kernel/power/disk.c
--- a/kernel/power/disk.c~hibernation-introduce-system_entering_hibernation
+++ a/kernel/power/disk.c
@@ -71,6 +71,14 @@ void hibernation_set_ops(struct platform
 	mutex_unlock(&pm_mutex);
 }
 
+static bool entering_platform_hibernation;
+
+bool system_entering_hibernation(void)
+{
+	return entering_platform_hibernation;
+}
+EXPORT_SYMBOL(system_entering_hibernation);
+
 #ifdef CONFIG_PM_DEBUG
 static void hibernation_debug_sleep(void)
 {
@@ -411,6 +419,7 @@ int hibernation_platform_enter(void)
 	if (error)
 		goto Close;
 
+	entering_platform_hibernation = true;
 	suspend_console();
 	error = device_suspend(PMSG_HIBERNATE);
 	if (error) {
@@ -445,6 +454,7 @@ int hibernation_platform_enter(void)
  Finish:
 	hibernation_ops->finish();
  Resume_devices:
+	entering_platform_hibernation = false;
 	device_resume(PMSG_RESTORE);
 	resume_console();
  Close:
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
linux-next.patch
drivers-consolidate-driver_probe_done-loops-into-one-place.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-checkpatch-fixes.patch
resume-wait-for-device-probing-to-finish.patch
misc-dell-laptop-should-depend-on-power_supply.patch
fbmem-copy_from-to_user-with-mutex-held-v3.patch
sata-ahci-blacklist-system-that-spins-off-disks-during-acpi-power-off.patch
shrink_slab-handle-bad-shrinkers.patch

