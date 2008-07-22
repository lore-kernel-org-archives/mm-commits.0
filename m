From: akpm@linux-foundation.org
Subject: - kthread-reduce-stack-pressure-in-create_kthread-and-kthreadd.patch removed from -mm tree
Date: Tue, 22 Jul 2008 14:32:43 -0700
Message-ID: <200807222132.m6MLWh5K018743@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45959 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753387AbYGVVdM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jul 2008 17:33:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: travis@sgi.com, mm-commits@vger.kernel.org


The patch titled
     kthread: reduce stack pressure in create_kthread and kthreadd
has been removed from the -mm tree.  Its filename was
     kthread-reduce-stack-pressure-in-create_kthread-and-kthreadd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kthread: reduce stack pressure in create_kthread and kthreadd
From: Mike Travis <travis@sgi.com>

Replace:

  	set_cpus_allowed(..., CPU_MASK_ALL)

with:

  	set_cpus_allowed_ptr(..., CPU_MASK_ALL_PTR)

to remove excessive stack requirements when NR_CPUS=4096.

Signed-off-by: Mike Travis <travis@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/kthread.c~kthread-reduce-stack-pressure-in-create_kthread-and-kthreadd kernel/kthread.c
--- a/kernel/kthread.c~kthread-reduce-stack-pressure-in-create_kthread-and-kthreadd
+++ a/kernel/kthread.c
@@ -106,7 +106,7 @@ static void create_kthread(struct kthrea
 		 */
 		sched_setscheduler(create->result, SCHED_NORMAL, &param);
 		set_user_nice(create->result, KTHREAD_NICE_LEVEL);
-		set_cpus_allowed(create->result, CPU_MASK_ALL);
+		set_cpus_allowed_ptr(create->result, CPU_MASK_ALL_PTR);
 	}
 	complete(&create->done);
 }
@@ -214,7 +214,7 @@ int kthreadd(void *unused)
 	set_task_comm(tsk, "kthreadd");
 	ignore_signals(tsk);
 	set_user_nice(tsk, KTHREAD_NICE_LEVEL);
-	set_cpus_allowed(tsk, CPU_MASK_ALL);
+	set_cpus_allowed_ptr(tsk, CPU_MASK_ALL_PTR);
 
 	current->flags |= PF_NOFREEZE | PF_FREEZER_NOSIG;
 
_

Patches currently in -mm which might be from travis@sgi.com are

origin.patch
linux-next.patch

