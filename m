From: akpm@linux-foundation.org
Subject: + um-should-hold-tasklist_lock-while-traversing-processes.patch added to -mm tree
Date: Thu, 26 Apr 2012 17:06:06 -0700
Message-ID: <20120427000607.0A778A042D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:58711 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757825Ab2D0AGH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Apr 2012 20:06:07 -0400
Received: by mail-yx0-f202.google.com with SMTP id q2so30545yen.1
        for <mm-commits@vger.kernel.org>; Thu, 26 Apr 2012 17:06:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anton.vorontsov@linaro.org, oleg@redhat.com, richard@nod.at


The patch titled
     Subject: um: should hold tasklist_lock while traversing processes
has been added to the -mm tree.  Its filename is
     um-should-hold-tasklist_lock-while-traversing-processes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: um: should hold tasklist_lock while traversing processes

Traversing the tasks requires holding tasklist_lock, otherwise it is
unsafe.

p.s.  However, I'm not sure that calling os_kill_ptraced_process() in the
atomic context is correct.  It seem to work, but please take a closer
look.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/reboot.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN arch/um/kernel/reboot.c~um-should-hold-tasklist_lock-while-traversing-processes arch/um/kernel/reboot.c
--- a/arch/um/kernel/reboot.c~um-should-hold-tasklist_lock-while-traversing-processes
+++ a/arch/um/kernel/reboot.c
@@ -4,6 +4,7 @@
  */
 
 #include "linux/sched.h"
+#include "linux/spinlock.h"
 #include "linux/slab.h"
 #include "kern_util.h"
 #include "os.h"
@@ -22,6 +23,7 @@ static void kill_off_processes(void)
 		struct task_struct *p;
 		int pid;
 
+		read_lock(&tasklist_lock);
 		for_each_process(p) {
 			if (p->mm == NULL)
 				continue;
@@ -29,6 +31,7 @@ static void kill_off_processes(void)
 			pid = p->mm->context.id.u.pid;
 			os_kill_ptraced_process(pid, 1);
 		}
+		read_unlock(&tasklist_lock);
 	}
 }
 
_
Subject: Subject: um: should hold tasklist_lock while traversing processes

Patches currently in -mm which might be from anton.vorontsov@linaro.org are

cpu-introduce-clear_tasks_mm_cpumask-helper.patch
arm-use-clear_tasks_mm_cpumask.patch
powerpc-use-clear_tasks_mm_cpumask.patch
sh-use-clear_tasks_mm_cpumask.patch
blackfin-a-couple-of-task-mm-handling-fixes.patch
blackfin-fix-possible-deadlock-in-decode_address.patch
um-should-hold-tasklist_lock-while-traversing-processes.patch
um-fix-possible-race-on-task-mm.patch
um-properly-check-all-process-threads-for-a-live-mm.patch

