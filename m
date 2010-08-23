From: akpm@linux-foundation.org
Subject: + stop_machine-convert-cpu-notifier-to-return-encapsulate-errno-value.patch added to -mm tree
Date: Mon, 23 Aug 2010 16:36:56 -0700
Message-ID: <201008232336.o7NNaueu021255@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38617 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751681Ab0HWXhb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Aug 2010 19:37:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, rusty@rustcorp.com.au, tj@kernel.org


The patch titled
     stop_machine: convert cpu notifier to return encapsulate errno value
has been added to the -mm tree.  Its filename is
     stop_machine-convert-cpu-notifier-to-return-encapsulate-errno-value.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: stop_machine: convert cpu notifier to return encapsulate errno value
From: Akinobu Mita <akinobu.mita@gmail.com>

In commit e6bde73b07edeb703d4c89c1daabc09c303de11f ("cpu-hotplug: return
better errno on cpu hotplug failure"), the cpu notifier can return an
encapsulated errno value.

This converts the cpu notifier to return an encapsulated errno value for
stop_machine().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/stop_machine.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/stop_machine.c~stop_machine-convert-cpu-notifier-to-return-encapsulate-errno-value kernel/stop_machine.c
--- a/kernel/stop_machine.c~stop_machine-convert-cpu-notifier-to-return-encapsulate-errno-value
+++ a/kernel/stop_machine.c
@@ -303,7 +303,7 @@ static int __cpuinit cpu_stop_cpu_callba
 		p = kthread_create(cpu_stopper_thread, stopper, "migration/%d",
 				   cpu);
 		if (IS_ERR(p))
-			return NOTIFY_BAD;
+			return notifier_from_errno(PTR_ERR(p));
 		sched_setscheduler_nocheck(p, SCHED_FIFO, &param);
 		get_task_struct(p);
 		stopper->thread = p;
@@ -370,7 +370,7 @@ static int __init cpu_stop_init(void)
 	/* start one for the boot cpu */
 	err = cpu_stop_cpu_callback(&cpu_stop_cpu_notifier, CPU_UP_PREPARE,
 				    bcpu);
-	BUG_ON(err == NOTIFY_BAD);
+	BUG_ON(err != NOTIFY_OK);
 	cpu_stop_cpu_callback(&cpu_stop_cpu_notifier, CPU_ONLINE, bcpu);
 	register_cpu_notifier(&cpu_stop_cpu_notifier);
 
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

stop_machine-convert-cpu-notifier-to-return-encapsulate-errno-value.patch

