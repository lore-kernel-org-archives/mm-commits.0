From: akpm@linux-foundation.org
Subject: + procfs-mark-thread-stack-correctly-in-proc-pid-maps-take-rcu-read-lock-when-iterating-through-thread-group.patch added to -mm tree
Date: Thu, 01 Mar 2012 15:17:32 -0800
Message-ID: <20120301231733.566EAA02AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:63338 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758268Ab2CAXRe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Mar 2012 18:17:34 -0500
Received: by yhgm50 with SMTP id m50so153839yhg.1
        for <mm-commits@vger.kernel.org>; Thu, 01 Mar 2012 15:17:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: siddhesh.poyarekar@gmail.com, adobriyan@gmail.com, jamie@shareable.org, kosaki.motohiro@gmail.com, mpm@selenic.com, oleg@redhat.com, vapier@gentoo.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: Take rcu read lock when iterating through thread group
has been added to the -mm tree.  Its filename is
     procfs-mark-thread-stack-correctly-in-proc-pid-maps-take-rcu-read-lock-when-iterating-through-thread-group.patch

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
Subject: Take rcu read lock when iterating through thread group

Protect the iteration through thread group with rcu_read_lock when
looking for tasks in the group that use the current vma as
stack. Thanks KOSAKI Motohiro (kosaki.motohiro@gmail.com) for pointing
it out.

Signed-off-by: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jamie Lokier <jamie@shareable.org>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff -puN mm/memory.c~procfs-mark-thread-stack-correctly-in-proc-pid-maps-take-rcu-read-lock-when-iterating-through-thread-group mm/memory.c
--- a/mm/memory.c~procfs-mark-thread-stack-correctly-in-proc-pid-maps-take-rcu-read-lock-when-iterating-through-thread-group
+++ a/mm/memory.c
@@ -3904,20 +3904,27 @@ void print_vma_addr(char *prefix, unsign
  * just check in the current task.
  */
 int vm_is_stack(struct task_struct *task,
-			      struct vm_area_struct *vma, int in_group)
+		struct vm_area_struct *vma, int in_group)
 {
+	int ret = 0;
+
 	if (vm_is_stack_for_task(task, vma))
 		return 1;
 
 	if (in_group) {
 		struct task_struct *t = task;
+		rcu_read_lock();
 		while_each_thread(task, t) {
-			if (vm_is_stack_for_task(t, vma))
-				return 1;
+			if (vm_is_stack_for_task(t, vma)) {
+				ret = 1;
+				goto done;
+			}
 		}
 	}
 
-	return 0;
+done:
+	rcu_read_unlock();
+	return ret;
 }
 
 #ifdef CONFIG_PROVE_LOCKING
_
Subject: Subject: Take rcu read lock when iterating through thread group

Patches currently in -mm which might be from siddhesh.poyarekar@gmail.com are

linux-next.patch
procfs-mark-thread-stack-correctly-in-proc-pid-maps.patch
procfs-mark-thread-stack-correctly-in-proc-pid-maps-checkpatch-fixes.patch
procfs-mark-thread-stack-correctly-in-proc-pid-maps-fix.patch
procfs-mark-thread-stack-correctly-in-proc-pid-maps-take-rcu-read-lock-when-iterating-through-thread-group.patch
procfs-mark-stack-vma-with-pid-of-the-owning-task.patch
procfs-mark-stack-vma-with-pid-of-the-owning-task-fix.patch

