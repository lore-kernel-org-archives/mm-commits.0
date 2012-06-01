From: akpm@linux-foundation.org
Subject: [merged] um-properly-check-all-process-threads-for-a-live-mm.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:34:28 -0700
Message-ID: <20120601193428.5D3F6A013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:42114 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932804Ab2FATe3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:34:29 -0400
Received: by mail-we0-f202.google.com with SMTP id e53so140327wer.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:34:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anton.vorontsov@linaro.org, oleg@redhat.com, richard@nod.at, mm-commits@vger.kernel.org


The patch titled
     Subject: um: properly check all process' threads for a live mm
has been removed from the -mm tree.  Its filename was
     um-properly-check-all-process-threads-for-a-live-mm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from anton.vorontsov@linaro.org are

origin.patch
kernel-cpuc-document-clear_tasks_mm_cpumask.patch

