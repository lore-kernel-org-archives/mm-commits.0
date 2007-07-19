From: akpm@linux-foundation.org
Subject: - freezer-remove-redundant-check-in-try_to_freeze_tasks.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:00:17 -0700
Message-ID: <200707192000.l6JK0HXW019435@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53964 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932215AbXGSU1c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:27:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, ego@in.ibm.com, oleg@tv-sign.ru, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     Freezer: remove redundant check in try_to_freeze_tasks
has been removed from the -mm tree.  Its filename was
     freezer-remove-redundant-check-in-try_to_freeze_tasks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Freezer: remove redundant check in try_to_freeze_tasks
From: Rafael J. Wysocki <rjw@sisk.pl>

We don't need to check if todo is positive before calling time_after() in
try_to_freeze_tasks(), because if todo is zero at this point, the loop will be
broken anyway due to the while () condition being false.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/process.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/power/process.c~freezer-remove-redundant-check-in-try_to_freeze_tasks kernel/power/process.c
--- a/kernel/power/process.c~freezer-remove-redundant-check-in-try_to_freeze_tasks
+++ a/kernel/power/process.c
@@ -149,7 +149,7 @@ static int try_to_freeze_tasks(int freez
 		} while_each_thread(g, p);
 		read_unlock(&tasklist_lock);
 		yield();			/* Yield is okay here */
-		if (todo && time_after(jiffies, end_time))
+		if (time_after(jiffies, end_time))
 			break;
 	} while (todo);
 
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
acpi-implement-the-set_target-callback-from-pm_ops.patch
acpi-add-acpi_pm_device_sleep_state-helper-routine.patch
pm-move-definition-of-struct-pm_ops-to-suspendh.patch
pm-rename-struct-pm_ops-and-related-things.patch
pm-rework-struct-platform_suspend_ops.patch
pm-fix-compilation-of-suspend-code-if-config_pm-is-unset.patch
pm-make-suspend_ops-static.patch
pm-rework-struct-hibernation_ops.patch
pm-rename-hibernation_ops-to-platform_hibernation_ops.patch
shrink_slab-handle-bad-shrinkers.patch
