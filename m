From: akpm@linux-foundation.org
Subject: - freezer-remove-pf_nofreeze-from-rcutorture-thread.patch removed from -mm tree
Date: Fri, 11 May 2007 12:28:40 -0700
Message-ID: <200705111928.l4BJSeeg024557@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35236 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759723AbXEKT3u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 May 2007 15:29:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paulmck@linux.vnet.ibm.com, aneesh.kumar@gmail.com, ego@in.ibm.com, oleg@tv-sign.ru, pavel@ucw.cz, rjw@sisk.pl, vatsa@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     freezer: remove PF_NOFREEZE from rcutorture thread
has been removed from the -mm tree.  Its filename was
     freezer-remove-pf_nofreeze-from-rcutorture-thread.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: freezer: remove PF_NOFREEZE from rcutorture thread
From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Remove PF_NOFREEZE from the rcutorture thread, adding a try_to_freeze() call
as required.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Aneesh Kumar <aneesh.kumar@gmail.com>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/rcutorture.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/rcutorture.c~freezer-remove-pf_nofreeze-from-rcutorture-thread kernel/rcutorture.c
--- a/kernel/rcutorture.c~freezer-remove-pf_nofreeze-from-rcutorture-thread
+++ a/kernel/rcutorture.c
@@ -46,6 +46,7 @@
 #include <linux/byteorder/swabb.h>
 #include <linux/stat.h>
 #include <linux/srcu.h>
+#include <linux/freezer.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Paul E. McKenney <paulmck@us.ibm.com> and "
@@ -518,7 +519,6 @@ rcu_torture_writer(void *arg)
 
 	VERBOSE_PRINTK_STRING("rcu_torture_writer task started");
 	set_user_nice(current, 19);
-	current->flags |= PF_NOFREEZE;
 
 	do {
 		schedule_timeout_uninterruptible(1);
@@ -540,6 +540,7 @@ rcu_torture_writer(void *arg)
 		}
 		rcu_torture_current_version++;
 		oldbatch = cur_ops->completed();
+		try_to_freeze();
 	} while (!kthread_should_stop() && !fullstop);
 	VERBOSE_PRINTK_STRING("rcu_torture_writer task stopping");
 	while (!kthread_should_stop())
_

Patches currently in -mm which might be from paulmck@linux.vnet.ibm.com are

freezer-remove-pf_nofreeze-from-rcutorture-thread.patch
freezer-remove-pf_nofreeze-from-bluetooth-threads.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
