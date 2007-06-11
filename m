From: akpm@linux-foundation.org
Subject: + swsusp-fix-userland-interface.patch added to -mm tree
Date: Mon, 11 Jun 2007 12:55:46 -0700
Message-ID: <200706111955.l5BJtkuV027804@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56450 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756205AbXFKTz4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jun 2007 15:55:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl


The patch titled
     swsusp: Fix userland interface
has been added to the -mm tree.  Its filename is
     swsusp-fix-userland-interface.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: swsusp: Fix userland interface
From: Rafael J. Wysocki <rjw@sisk.pl>

Fix oops caused by 'cat /dev/snapshot', reported by Arkadiusz Miskiewicz,
and make it impossible to thaw tasks with the help of the swsusp userland
interface while there is a snapshot image ready to save.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/user.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

diff -puN kernel/power/user.c~swsusp-fix-userland-interface kernel/power/user.c
--- a/kernel/power/user.c~swsusp-fix-userland-interface
+++ a/kernel/power/user.c
@@ -99,6 +99,8 @@ static ssize_t snapshot_read(struct file
 	ssize_t res;
 
 	data = filp->private_data;
+	if (!data->ready)
+		return -ENODATA;
 	res = snapshot_read_next(&data->handle, count);
 	if (res > 0) {
 		if (copy_to_user(buf, data_of(data->handle), res))
@@ -245,7 +247,7 @@ static int snapshot_ioctl(struct inode *
 		break;
 
 	case SNAPSHOT_UNFREEZE:
-		if (!data->frozen)
+		if (!data->frozen || data->ready)
 			break;
 		mutex_lock(&pm_mutex);
 		thaw_processes();
_

Patches currently in -mm which might be from rjw@sisk.pl are

swsusp-fix-userland-interface.patch
x86_64-pm_trace-support.patch
i386-do-not-restore-reserved-memory-after-hibernation.patch
i386-do-not-restore-reserved-memory-after-hibernation-fix.patch
acpi-preserve-the-ebx-value-in-acpi_copy_wakeup_routine.patch
freezer-make-kernel-threads-nonfreezable-by-default.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix-fix.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix-2.patch
freezer-run-show_state-when-freezing-times-out.patch
pm-do-not-require-dev-spew-to-get-pm_debug.patch
swsusp-remove-incorrect-code-from-userc.patch
swsusp-remove-code-duplication-between-diskc-and-userc.patch
swsusp-remove-code-duplication-between-diskc-and-userc-fix.patch
swsusp-introduce-restore-platform-operations.patch
swsusp-fix-hibernation-code-ordering.patch
hibernation-prepare-to-enter-the-low-power-state.patch
freezer-avoid-freezing-kernel-threads-prematurely.patch
freezer-use-__set_current_state-in-refrigerator.patch
freezer-return-int-from-freeze_processes.patch
freezer-remove-redundant-check-in-try_to_freeze_tasks.patch
pm-introduce-hibernation-and-suspend-notifiers.patch
pm-introduce-hibernation-and-suspend-notifiers-fix.patch
pm-introduce-hibernation-and-suspend-notifiers-tidy.patch
pm-introduce-hibernation-and-suspend-notifiers-fix-fix.patch
pm-disable-usermode-helper-before-hibernation-and-suspend.patch
pm-disable-usermode-helper-before-hibernation-and-suspend-fix.patch
shrink_slab-handle-bad-shrinkers.patch
beeping-patch-for-debugging-acpi-sleep.patch
