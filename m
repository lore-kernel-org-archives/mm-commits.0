From: akpm@linux-foundation.org
Subject: + um-properly-check-all-process-threads-for-a-live-mm.patch added to -mm tree
Date: Thu, 26 Apr 2012 17:06:10 -0700
Message-ID: <20120427000611.040A3A042D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:41352 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758596Ab2D0AGL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Apr 2012 20:06:11 -0400
Received: by mail-qc0-f202.google.com with SMTP id p5so31074qcs.1
        for <mm-commits@vger.kernel.org>; Thu, 26 Apr 2012 17:06:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anton.vorontsov@linaro.org, oleg@redhat.com, richard@nod.at


The patch titled
     Subject: um: properly check all process' threads for a live mm
has been added to the -mm tree.  Its filename is
     um-properly-check-all-process-threads-for-a-live-mm.patch

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
Subject: um: properly check all process' threads for a live mm

kill_off_processes() might miss a valid process, this is because checking
for process->mm is not enough.  Process' main thread may exit or detach
its mm via use_mm(), but other threads may still have a valid mm.

To catch this we use find_lock_task_mm(), which walks up all threads and
returns an appropriate task (with task lock held).

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/reboot.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN arch/um/kernel/reboot.c~um-properly-check-all-process-threads-for-a-live-mm arch/um/kernel/reboot.c
--- a/arch/um/kernel/reboot.c~um-properly-check-all-process-threads-for-a-live-mm
+++ a/arch/um/kernel/reboot.c
@@ -6,6 +6,7 @@
 #include "linux/sched.h"
 #include "linux/spinlock.h"
 #include "linux/slab.h"
+#include "linux/oom.h"
 #include "kern_util.h"
 #include "os.h"
 #include "skas.h"
@@ -25,13 +26,13 @@ static void kill_off_processes(void)
 
 		read_lock(&tasklist_lock);
 		for_each_process(p) {
-			task_lock(p);
-			if (!p->mm) {
-				task_unlock(p);
+			struct task_struct *t;
+
+			t = find_lock_task_mm(p);
+			if (!t)
 				continue;
-			}
-			pid = p->mm->context.id.u.pid;
-			task_unlock(p);
+			pid = t->mm->context.id.u.pid;
+			task_unlock(t);
 			os_kill_ptraced_process(pid, 1);
 		}
 		read_unlock(&tasklist_lock);
_
Subject: Subject: um: properly check all process' threads for a live mm

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

