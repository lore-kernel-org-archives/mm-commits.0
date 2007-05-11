From: akpm@linux-foundation.org
Subject: - freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch removed from -mm tree
Date: Fri, 11 May 2007 12:28:30 -0700
Message-ID: <200705111928.l4BJSVXA024538@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58458 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761959AbXEKT3n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 May 2007 15:29:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, aneesh.kumar@gmail.com, ego@in.ibm.com, oleg@tv-sign.ru, paulmck@linux.vnet.ibm.com, pavel@ucw.cz, vatsa@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     freezer: read PF_BORROWED_MM in a nonracy way
has been removed from the -mm tree.  Its filename was
     freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: freezer: read PF_BORROWED_MM in a nonracy way
From: Rafael J. Wysocki <rjw@sisk.pl>

The reading of PF_BORROWED_MM in is_user_space() without task_lock() is racy. 
Fix it.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Aneesh Kumar <aneesh.kumar@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/process.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN kernel/power/process.c~freezer-read-pf_borrowed_mm-in-a-nonracy-way kernel/power/process.c
--- a/kernel/power/process.c~freezer-read-pf_borrowed_mm-in-a-nonracy-way
+++ a/kernel/power/process.c
@@ -8,6 +8,7 @@
 
 #undef DEBUG
 
+#include <linux/sched.h>
 #include <linux/interrupt.h>
 #include <linux/suspend.h>
 #include <linux/module.h>
@@ -88,7 +89,12 @@ static void cancel_freezing(struct task_
 
 static inline int is_user_space(struct task_struct *p)
 {
-	return p->mm && !(p->flags & PF_BORROWED_MM);
+	int ret;
+
+	task_lock(p);
+	ret = p->mm && !(p->flags & PF_BORROWED_MM);
+	task_unlock(p);
+	return ret;
 }
 
 static unsigned int try_to_freeze_tasks(int freeze_user_space)
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
at91-fix-enable-disable_irq_wake-symmetry-in-pcmcia-driver.patch
freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch
freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks.patch
freezer-remove-pf_nofreeze-from-rcutorture-thread.patch
freezer-remove-pf_nofreeze-from-bluetooth-threads.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
fix-pf_nofreeze-and-freezeable-race-2.patch
freezer-document-task_lock-in-thaw_process.patch
move-frozen_process-to-kernel-power-processc.patch
separate-freezer-from-pm-code-rev-2.patch
introduce-freezer-flags-rev-2.patch
add-common-orderly_poweroff.patch
add-suspend-related-notifications-for-cpu-hotplug-statistics.patch
shrink_slab-handle-bad-shrinkers.patch
