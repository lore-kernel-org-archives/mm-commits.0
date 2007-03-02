From: akpm@linux-foundation.org
Subject: + freezer-take-kernel_execve-into-consideration.patch added to -mm tree
Date: Thu, 01 Mar 2007 16:55:38 -0800
Message-ID: <200703020055.l220tc5Q028058@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60852 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422670AbXCBA4K (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 19:56:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, aneesh.kumar@gmail.com, ego@in.ibm.com, oleg@tv-sign.ru, paulmck@linux.vnet.ibm.com, pavel@ucw.cz, vatsa@in.ibm.com


The patch titled
     freezer: take kernel_execve into consideration
has been added to the -mm tree.  Its filename is
     freezer-take-kernel_execve-into-consideration.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: freezer: take kernel_execve into consideration
From: Rafael J. Wysocki <rjw@sisk.pl>

Kernel threads can become userland processes by calling kernel_execve().  In
particular, this may happen right after
try_to_freeze_tasks(FREEZER_USER_SPACE) has returned, so try_to_freeze_tasks()
needs to take userspace processes into consideration even if it is called with
FREEZER_KERNEL_THREADS.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Aneesh Kumar <aneesh.kumar@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/process.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/power/process.c~freezer-take-kernel_execve-into-consideration kernel/power/process.c
--- a/kernel/power/process.c~freezer-take-kernel_execve-into-consideration
+++ a/kernel/power/process.c
@@ -127,7 +127,7 @@ static unsigned int try_to_freeze_tasks(
 				cancel_freezing(p);
 				continue;
 			}
-			if (is_user_space(p) == !freeze_user_space)
+			if (freeze_user_space && !is_user_space(p))
 				continue;
 
 			freeze_process(p);
@@ -154,7 +154,7 @@ static unsigned int try_to_freeze_tasks(
 				TIMEOUT / HZ, todo);
 		read_lock(&tasklist_lock);
 		do_each_thread(g, p) {
-			if (is_user_space(p) == !freeze_user_space)
+			if (freeze_user_space && !is_user_space(p))
 				continue;
 
 			task_lock(p);
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
