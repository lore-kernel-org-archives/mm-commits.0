From: akpm@linux-foundation.org
Subject: - freezer-document-task_lock-in-thaw_process.patch removed from -mm tree
Date: Fri, 11 May 2007 12:29:14 -0700
Message-ID: <200705111929.l4BJTE0L024588@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56803 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759395AbXEKTaM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 May 2007 15:30:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, ego@in.ibm.com, oleg@tv-sign.ru, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     freezer: document task_lock in thaw_process
has been removed from the -mm tree.  Its filename was
     freezer-document-task_lock-in-thaw_process.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: freezer: document task_lock in thaw_process
From: Rafael J. Wysocki <rjw@sisk.pl>

The task_lock() in include/linux/freezer.h:thaw_process() looks as though
it were protecting p->flags, which is not the case.  Add a comment that
explains why it's there.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/freezer.h |    6 ++++++
 1 file changed, 6 insertions(+)

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

origin.patch
at91-fix-enable-disable_irq_wake-symmetry-in-pcmcia-driver.patch
freezer-document-task_lock-in-thaw_process.patch
move-frozen_process-to-kernel-power-processc.patch
separate-freezer-from-pm-code-rev-2.patch
introduce-freezer-flags-rev-2.patch
add-common-orderly_poweroff.patch
add-suspend-related-notifications-for-cpu-hotplug-statistics.patch
shrink_slab-handle-bad-shrinkers.patch
