From: akpm@linux-foundation.org
Subject: [merged] um-should-hold-tasklist_lock-while-traversing-processes.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:34:23 -0700
Message-ID: <20120601193423.5DF0CA013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:44792 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759178Ab2FATeY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:34:24 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so245076ghb.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:34:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anton.vorontsov@linaro.org, oleg@redhat.com, richard@nod.at, mm-commits@vger.kernel.org


The patch titled
     Subject: um: should hold tasklist_lock while traversing processes
has been removed from the -mm tree.  Its filename was
     um-should-hold-tasklist_lock-while-traversing-processes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from anton.vorontsov@linaro.org are

origin.patch
um-fix-possible-race-on-task-mm.patch
um-properly-check-all-process-threads-for-a-live-mm.patch
kernel-cpuc-document-clear_tasks_mm_cpumask.patch

