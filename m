From: akpm@linux-foundation.org
Subject: [nacked] procfs-mark-thread-stack-correctly-in-proc-pid-fix-rcu-locking-in-vm_is_stack.patch removed from -mm tree
Date: Wed, 07 Mar 2012 14:55:41 -0800
Message-ID: <20120307225542.33332A00AB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:58948 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab2CGWzn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Mar 2012 17:55:43 -0500
Received: by yenq2 with SMTP id q2so870373yen.1
        for <mm-commits@vger.kernel.org>; Wed, 07 Mar 2012 14:55:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: siddhesh.poyarekar@gmail.com, msalter@redhat.com, oleg@redhat.com, paul.gortmaker@windriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/linux-next: Fix rcu locking in vm_is_stack
has been removed from the -mm tree.  Its filename was
     procfs-mark-thread-stack-correctly-in-proc-pid-fix-rcu-locking-in-vm_is_stack.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
Subject: mm/linux-next: Fix rcu locking in vm_is_stack

Take rcu read lock before we do anything at all with the threadgroup list.
 Also use list_first_entry_rcu to safely get the reference to the first
task in the list.

Signed-off-by: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
Cc: Mark Salter <msalter@redhat.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN mm/memory.c~procfs-mark-thread-stack-correctly-in-proc-pid-fix-rcu-locking-in-vm_is_stack mm/memory.c
--- a/mm/memory.c~procfs-mark-thread-stack-correctly-in-proc-pid-fix-rcu-locking-in-vm_is_stack
+++ a/mm/memory.c
@@ -3914,18 +3914,20 @@ pid_t vm_is_stack(struct task_struct *ta
 		return task->pid;
 
 	if (in_group) {
-		struct task_struct *t = task;
+		struct task_struct *t;
 		rcu_read_lock();
-		while_each_thread(task, t) {
+		t = list_first_entry_rcu(&task->thread_group,
+					 struct task_struct, thread_group);
+		do {
 			if (vm_is_stack_for_task(t, vma)) {
 				ret = t->pid;
 				goto done;
 			}
-		}
+		} while_each_thread(task, t);
+done:
+		rcu_read_unlock();
 	}
 
-done:
-	rcu_read_unlock();
 	return ret;
 }
 
_

Patches currently in -mm which might be from siddhesh.poyarekar@gmail.com are

linux-next.patch
procfs-mark-thread-stack-correctly-in-proc-pid-maps.patch
procfs-mark-thread-stack-correctly-in-proc-pid-maps-fix-task_nommu-build-regression-in-linux-next.patch

