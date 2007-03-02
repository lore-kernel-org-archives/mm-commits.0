From: akpm@linux-foundation.org
Subject: + freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch added to -mm tree
Date: Thu, 01 Mar 2007 16:55:22 -0800
Message-ID: <200703020055.l220tMxm028029@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:32856 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932518AbXCBA7C (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 19:59:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, aneesh.kumar@gmail.com, ego@in.ibm.com, oleg@tv-sign.ru, paulmck@linux.vnet.ibm.com, pavel@ucw.cz, vatsa@in.ibm.com


The patch titled
     freezer: read PF_BORROWED_MM in a nonracy way
has been added to the -mm tree.  Its filename is
     freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 7 insertions(+), 1 deletion(-)

diff -puN kernel/power/process.c~freezer-read-pf_borrowed_mm-in-a-nonracy-way kernel/power/process.c
--- a/kernel/power/process.c~freezer-read-pf_borrowed_mm-in-a-nonracy-way
+++ a/kernel/power/process.c
@@ -8,6 +8,7 @@
 
 #undef DEBUG
 
+#include <linux/sched.h>
 #include <linux/smp_lock.h>
 #include <linux/interrupt.h>
 #include <linux/suspend.h>
@@ -89,7 +90,12 @@ static void cancel_freezing(struct task_
 
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

make-xfs-workqueues-nonfreezable.patch
fix-refrigerator-vs-thaw_process-race.patch
freezer-task-exit_state-should-be-treated-as-bolean.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch
freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks.patch
freezer-remove-pf_nofreeze-from-rcutorture-thread.patch
freezer-remove-pf_nofreeze-from-bluetooth-threads.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
shrink_slab-handle-bad-shrinkers.patch
