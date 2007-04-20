From: akpm@linux-foundation.org
Subject: + freezer-document-task_lock-in-thaw_process.patch added to -mm tree
Date: Fri, 20 Apr 2007 15:24:05 -0700
Message-ID: <200704202224.l3KMO5EX025254@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54545 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751615AbXDTWYf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 18:24:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, ego@in.ibm.com, oleg@tv-sign.ru


The patch titled
     freezer: document task_lock in thaw_process
has been added to the -mm tree.  Its filename is
     freezer-document-task_lock-in-thaw_process.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: freezer: document task_lock in thaw_process
From: Rafael J. Wysocki <rjw@sisk.pl>

The task_lock() in include/linux/freezer.h:thaw_process() looks as though
it were protecting p->flags, which is not the case.  Add a comment that
explains why it's there.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/freezer.h |    6 ++++++
 1 files changed, 6 insertions(+)

diff -puN include/linux/freezer.h~freezer-document-task_lock-in-thaw_process include/linux/freezer.h
--- a/include/linux/freezer.h~freezer-document-task_lock-in-thaw_process
+++ a/include/linux/freezer.h
@@ -37,6 +37,12 @@ static inline void do_not_freeze(struct 
 
 /*
  * Wake up a frozen process
+ *
+ * task_lock() is taken to prevent the race with refrigerator() which may
+ * occur if the freezing of tasks fails.  Namely, without the lock, if the
+ * freezing of tasks failed, thaw_tasks() might have run before a task in
+ * refrigerator() could call frozen_process(), in which case the task would be
+ * frozen and no one would thaw it.
  */
 static inline int thaw_process(struct task_struct *p)
 {
_

Patches currently in -mm which might be from rjw@sisk.pl are

fix-refrigerator-vs-thaw_process-race.patch
swsusp-use-inline-functions-for-changing-page-flags.patch
swsusp-do-not-use-page-flags.patch
mm-remove-unused-page-flags.patch
swsusp-fix-error-paths-in-snapshot_open.patch
swsusp-use-gfp_kernel-for-creating-basic-data-structures.patch
rework-pm_ops-pm_disk_mode-kill-misuse.patch
power-management-remove-firmware-disk-mode.patch
power-management-implement-pm_opsvalid-for-everybody.patch
power-management-force-pm_opsvalid-callback-to-be.patch
freezer-remove-pf_nofreeze-from-handle_initrd.patch
swsusp-use-rbtree-for-tracking-allocated-swap.patch
freezer-fix-racy-usage-of-try_to_freeze-in-kswapd.patch
remove-software_suspend.patch
power-management-change-sys-power-disk-display.patch
freezer-task-exit_state-should-be-treated-as-bolean.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch
freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks.patch
freezer-remove-pf_nofreeze-from-rcutorture-thread.patch
freezer-remove-pf_nofreeze-from-bluetooth-threads.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
fix-pf_nofreeze-and-freezeable-race.patch
freezer-document-task_lock-in-thaw_process.patch
shrink_slab-handle-bad-shrinkers.patch
