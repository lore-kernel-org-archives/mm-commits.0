From: akpm@linux-foundation.org
Subject: - freezer-use-__set_current_state-in-refrigerator.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:00:13 -0700
Message-ID: <200707192000.l6JK0DkE019429@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38863 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932151AbXGSU1a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:27:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, ego@in.ibm.com, oleg@tv-sign.ru, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     Freezer: use __set_current_state in refrigerator
has been removed from the -mm tree.  Its filename was
     freezer-use-__set_current_state-in-refrigerator.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Freezer: use __set_current_state in refrigerator
From: Rafael J. Wysocki <rjw@sisk.pl>

Use __set_current_state() as appropriate in refrigerator() instead of
accessing current->state directly.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/process.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/power/process.c~freezer-use-__set_current_state-in-refrigerator kernel/power/process.c
--- a/kernel/power/process.c~freezer-use-__set_current_state-in-refrigerator
+++ a/kernel/power/process.c
@@ -72,7 +72,7 @@ void refrigerator(void)
 		schedule();
 	}
 	pr_debug("%s left refrigerator\n", current->comm);
-	current->state = save;
+	__set_current_state(save);
 }
 
 static void freeze_task(struct task_struct *p)
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
