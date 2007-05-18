From: akpm@linux-foundation.org
Subject: - swsusp-fix-sysfs-interface.patch removed from -mm tree
Date: Fri, 18 May 2007 00:06:43 -0700
Message-ID: <200705180706.l4I76gkA010202@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50133 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758031AbXERHJl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 May 2007 03:09:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, Peter.Moulder@infotech.monash.edu.au, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     swsusp: fix sysfs interface
has been removed from the -mm tree.  Its filename was
     swsusp-fix-sysfs-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: swsusp: fix sysfs interface
From: Rafael J. Wysocki <rjw@sisk.pl>

The sysfs files /sys/power/disk and /sys/power/state do not work as
documented, since they allow the user to write only a few initial
characters of the input string to trigger the option (eg.  'echo pl >
/sys/power/disk' activates the platform mode of hibernation).  Fix it.

Special thanks to Peter Moulder <Peter.Moulder@infotech.monash.edu.au> for
pointing out the problem.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/disk.c |    3 ++-
 kernel/power/main.c |    4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN kernel/power/disk.c~swsusp-fix-sysfs-interface kernel/power/disk.c
--- a/kernel/power/disk.c~swsusp-fix-sysfs-interface
+++ a/kernel/power/disk.c
@@ -416,7 +416,8 @@ static ssize_t disk_store(struct kset *k
 
 	mutex_lock(&pm_mutex);
 	for (i = HIBERNATION_FIRST; i <= HIBERNATION_MAX; i++) {
-		if (!strncmp(buf, hibernation_modes[i], len)) {
+		if (len == strlen(hibernation_modes[i])
+		    && !strncmp(buf, hibernation_modes[i], len)) {
 			mode = i;
 			break;
 		}
diff -puN kernel/power/main.c~swsusp-fix-sysfs-interface kernel/power/main.c
--- a/kernel/power/main.c~swsusp-fix-sysfs-interface
+++ a/kernel/power/main.c
@@ -290,13 +290,13 @@ static ssize_t state_store(struct kset *
 	len = p ? p - buf : n;
 
 	/* First, check if we are requested to hibernate */
-	if (!strncmp(buf, "disk", len)) {
+	if (len == 4 && !strncmp(buf, "disk", len)) {
 		error = hibernate();
 		return error ? error : n;
 	}
 
 	for (s = &pm_states[state]; state < PM_SUSPEND_MAX; s++, state++) {
-		if (*s && !strncmp(buf, *s, len))
+		if (*s && len == strlen(*s) && !strncmp(buf, *s, len))
 			break;
 	}
 	if (state < PM_SUSPEND_MAX && *s)
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
at91-fix-enable-disable_irq_wake-symmetry-in-pcmcia-driver.patch
freezer-close-potential-race-between-refrigerator-and-thaw_tasks.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
freezer-fix-kthread_create-vs-freezer-theoretical-race.patch
freezer-fix-pf_nofreeze-vs-freezeable-race.patch
freezer-move-frozen_process-to-kernel-power-processc.patch
add-common-orderly_poweroff.patch
add-suspend-related-notifications-for-cpu-hotplug-statistics.patch
shrink_slab-handle-bad-shrinkers.patch
