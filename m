From: akpm@linux-foundation.org
Subject: [merged] blackfin-a-couple-of-task-mm-handling-fixes.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:34:19 -0700
Message-ID: <20120601193419.636A3A013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:46196 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759178Ab2FATeU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:34:20 -0400
Received: by mail-vc0-f202.google.com with SMTP id fl13so245502vcb.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:34:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anton.vorontsov@linaro.org, oleg@redhat.com, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     Subject: blackfin: a couple of task->mm handling fixes
has been removed from the -mm tree.  Its filename was
     blackfin-a-couple-of-task-mm-handling-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: blackfin: a couple of task->mm handling fixes

The patch fixes two problems:

1. Working with task->mm w/o getting mm or grabing the task lock is
   dangerous as ->mm might disappear (exit_mm() assigns NULL under
   task_lock(), so tasklist lock is not enough).

   We can't use get_task_mm()/mmput() pair as mmput() might sleep,
   so we have to take the task lock while handle its mm.

2. Checking for process->mm is not enough because process' main
   thread may exit or detach its mm via use_mm(), but other threads
   may still have a valid mm.

   To catch this we use find_lock_task_mm(), which walks up all
   threads and returns an appropriate task (with task lock held).

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/kernel/trace.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff -puN arch/blackfin/kernel/trace.c~blackfin-a-couple-of-task-mm-handling-fixes arch/blackfin/kernel/trace.c
--- a/arch/blackfin/kernel/trace.c~blackfin-a-couple-of-task-mm-handling-fixes
+++ a/arch/blackfin/kernel/trace.c
@@ -10,6 +10,8 @@
 #include <linux/hardirq.h>
 #include <linux/thread_info.h>
 #include <linux/mm.h>
+#include <linux/oom.h>
+#include <linux/sched.h>
 #include <linux/uaccess.h>
 #include <linux/module.h>
 #include <linux/kallsyms.h>
@@ -28,7 +30,6 @@ void decode_address(char *buf, unsigned 
 	struct task_struct *p;
 	struct mm_struct *mm;
 	unsigned long flags, offset;
-	unsigned char in_atomic = (bfin_read_IPEND() & 0x10) || in_atomic();
 	struct rb_node *n;
 
 #ifdef CONFIG_KALLSYMS
@@ -114,15 +115,15 @@ void decode_address(char *buf, unsigned 
 	 */
 	write_lock_irqsave(&tasklist_lock, flags);
 	for_each_process(p) {
-		mm = (in_atomic ? p->mm : get_task_mm(p));
-		if (!mm)
-			continue;
+		struct task_struct *t;
 
-		if (!down_read_trylock(&mm->mmap_sem)) {
-			if (!in_atomic)
-				mmput(mm);
+		t = find_lock_task_mm(p);
+		if (!t)
 			continue;
-		}
+
+		mm = t->mm;
+		if (!down_read_trylock(&mm->mmap_sem))
+			goto __continue;
 
 		for (n = rb_first(&mm->mm_rb); n; n = rb_next(n)) {
 			struct vm_area_struct *vma;
@@ -131,7 +132,7 @@ void decode_address(char *buf, unsigned 
 
 			if (address >= vma->vm_start && address < vma->vm_end) {
 				char _tmpbuf[256];
-				char *name = p->comm;
+				char *name = t->comm;
 				struct file *file = vma->vm_file;
 
 				if (file) {
@@ -164,8 +165,7 @@ void decode_address(char *buf, unsigned 
 						name, vma->vm_start, vma->vm_end);
 
 				up_read(&mm->mmap_sem);
-				if (!in_atomic)
-					mmput(mm);
+				task_unlock(t);
 
 				if (buf[0] == '\0')
 					sprintf(buf, "[ %s ] dynamic memory", name);
@@ -175,8 +175,8 @@ void decode_address(char *buf, unsigned 
 		}
 
 		up_read(&mm->mmap_sem);
-		if (!in_atomic)
-			mmput(mm);
+__continue:
+		task_unlock(t);
 	}
 
 	/*
_

Patches currently in -mm which might be from anton.vorontsov@linaro.org are

origin.patch
blackfin-fix-possible-deadlock-in-decode_address.patch
um-should-hold-tasklist_lock-while-traversing-processes.patch
um-fix-possible-race-on-task-mm.patch
um-properly-check-all-process-threads-for-a-live-mm.patch
kernel-cpuc-document-clear_tasks_mm_cpumask.patch

