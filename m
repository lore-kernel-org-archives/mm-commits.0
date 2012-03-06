From: akpm@linux-foundation.org
Subject: + procfs-mark-thread-stack-correctly-in-proc-pid-maps-fix-task_nommu-build-regression-in-linux-next.patch added to -mm tree
Date: Tue, 06 Mar 2012 12:40:08 -0800
Message-ID: <20120306204008.7BD69A02CD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:63944 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031036Ab2CFUkL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Mar 2012 15:40:11 -0500
Received: by faaa19 with SMTP id a19so208872faa.1
        for <mm-commits@vger.kernel.org>; Tue, 06 Mar 2012 12:40:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: siddhesh.poyarekar@gmail.com, msalter@redhat.com, oleg@redhat.com, paul.gortmaker@windriver.com


The patch titled
     Subject: mm: Fix task_nommu build regression in linux-next
has been added to the -mm tree.  Its filename is
     procfs-mark-thread-stack-correctly-in-proc-pid-maps-fix-task_nommu-build-regression-in-linux-next.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
Subject: mm: Fix task_nommu build regression in linux-next

Commit b7b2a0afacada237005068294cb0ccc49d32889e resulted in a build
failure for nommu builds:

fs/built-in.o: In function `nommu_vma_show':
task_nommu.c:(.text+0x564a0): undefined reference to `vm_is_stack'
make[1]: *** [.tmp_vmlinux1] Error 1

Fix is to provide definitions of vm_is_stack() and
vm_is_stack_for_task() for nommu as well. This patch also adds an
explicit include of sched.h based on observations and patch submission
by Paul Gortmaker <paul.gortmaker@windriver.com>:

https://lkml.org/lkml/2012/3/5/326

Signed-off-by: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
Cc: Mark Salter <msalter@redhat.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    1 +
 mm/nommu.c  |   40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+)

diff -puN mm/memory.c~procfs-mark-thread-stack-correctly-in-proc-pid-maps-fix-task_nommu-build-regression-in-linux-next mm/memory.c
--- a/mm/memory.c~procfs-mark-thread-stack-correctly-in-proc-pid-maps-fix-task_nommu-build-regression-in-linux-next
+++ a/mm/memory.c
@@ -57,6 +57,7 @@
 #include <linux/swapops.h>
 #include <linux/elf.h>
 #include <linux/gfp.h>
+#include <linux/sched.h>
 
 #include <asm/io.h>
 #include <asm/pgalloc.h>
diff -puN mm/nommu.c~procfs-mark-thread-stack-correctly-in-proc-pid-maps-fix-task_nommu-build-regression-in-linux-next mm/nommu.c
--- a/mm/nommu.c~procfs-mark-thread-stack-correctly-in-proc-pid-maps-fix-task_nommu-build-regression-in-linux-next
+++ a/mm/nommu.c
@@ -29,6 +29,7 @@
 #include <linux/security.h>
 #include <linux/syscalls.h>
 #include <linux/audit.h>
+#include <linux/sched.h>
 
 #include <asm/uaccess.h>
 #include <asm/tlb.h>
@@ -2094,3 +2095,42 @@ int nommu_shrink_inode_mappings(struct i
 	up_write(&nommu_region_sem);
 	return 0;
 }
+
+/* Check if the vma is being used as a stack by this task */
+static int vm_is_stack_for_task(struct task_struct *t,
+				struct vm_area_struct *vma)
+{
+	return (vma->vm_start <= KSTK_ESP(t) && vma->vm_end >= KSTK_ESP(t));
+}
+
+/*
+ * Check if the vma is being used as a stack.
+ * If is_group is non-zero, check in the entire thread group or else
+ * just check in the current task. Returns the pid of the task that
+ * the vma is stack for.
+ */
+pid_t vm_is_stack(struct task_struct *task,
+		  struct vm_area_struct *vma, int in_group)
+{
+	pid_t ret = 0;
+
+	if (vm_is_stack_for_task(task, vma))
+		return task->pid;
+
+	if (in_group) {
+		struct task_struct *t;
+		rcu_read_lock();
+		t = list_first_entry_rcu(&task->thread_group,
+					 struct task_struct, thread_group);
+		do {
+			if (vm_is_stack_for_task(t, vma)) {
+				ret = t->pid;
+				goto done;
+			}
+		} while_each_thread(task, t);
+done:
+		rcu_read_unlock();
+	}
+
+	return ret;
+}
_
Subject: Subject: mm: Fix task_nommu build regression in linux-next

Patches currently in -mm which might be from siddhesh.poyarekar@gmail.com are

linux-next.patch
procfs-mark-thread-stack-correctly-in-proc-pid-maps.patch
procfs-mark-thread-stack-correctly-in-proc-pid-maps-fix-task_nommu-build-regression-in-linux-next.patch
procfs-mark-thread-stack-correctly-in-proc-pid-fix-rcu-locking-in-vm_is_stack.patch

