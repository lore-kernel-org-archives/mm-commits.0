From: akpm@linux-foundation.org
Subject: + kthread-reduce-stack-pressure-in-create_kthread-and-kthreadd.patch added to -mm tree
Date: Fri, 11 Jul 2008 11:43:19 -0700
Message-ID: <200807111849.m6BIn05t031170@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58582 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755795AbYGKStC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 14:49:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: travis@sgi.com


The patch titled
     kthread: reduce stack pressure in create_kthread and kthreadd
has been added to the -mm tree.  Its filename is
     kthread-reduce-stack-pressure-in-create_kthread-and-kthreadd.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
kthread-reduce-stack-pressure-in-create_kthread-and-kthreadd.patch

