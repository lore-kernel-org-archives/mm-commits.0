From: akpm@linux-foundation.org
Subject: + procfs-mark-thread-stack-correctly-in-proc-pid-fix-rcu-locking-in-vm_is_stack.patch added to -mm tree
Date: Tue, 06 Mar 2012 12:37:48 -0800
Message-ID: <20120306203748.9AC41A02CD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vw0-f74.google.com ([209.85.212.74]:61845 "EHLO
	mail-vw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965262Ab2CFUhu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Mar 2012 15:37:50 -0500
Received: by vbnl22 with SMTP id l22so688240vbn.1
        for <mm-commits@vger.kernel.org>; Tue, 06 Mar 2012 12:37:49 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: siddhesh.poyarekar@gmail.com, msalter@redhat.com, oleg@redhat.com, paul.gortmaker@windriver.com


The patch titled
     Subject: mm/linux-next: Fix rcu locking in vm_is_stack
has been added to the -mm tree.  Its filename is
     procfs-mark-thread-stack-correctly-in-proc-pid-fix-rcu-locking-in-vm_is_stack.patch

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
Subject: Subject: mm/linux-next: Fix rcu locking in vm_is_stack

Patches currently in -mm which might be from siddhesh.poyarekar@gmail.com are

linux-next.patch
procfs-mark-thread-stack-correctly-in-proc-pid-maps.patch
procfs-mark-thread-stack-correctly-in-proc-pid-maps-fix-task_nommu-build-regression-in-linux-next.patch
procfs-mark-thread-stack-correctly-in-proc-pid-fix-rcu-locking-in-vm_is_stack.patch

