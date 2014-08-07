From: akpm@linux-foundation.org
Subject: +
 vm_is_stack-use-for_each_thread-rather-then-buggy-while_each_thread.patch
 added to -mm tree
Date: Thu, 07 Aug 2014 15:28:57 -0700
Message-ID: <53e3fda9.wly1uQxAkbOcwlPT%akpm__19354.3509034955$1407450561$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f202.google.com ([209.85.213.202]:60013 "EHLO
	mail-ig0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755948AbaHGW27 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 18:28:59 -0400
Received: by mail-ig0-f202.google.com with SMTP id r2so26198igi.3
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 15:28:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, alex.besogonov@gmail.com, rientjes@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: vm_is_stack: use for_each_thread() rather then buggy while_each_thread()
has been added to the -mm tree.  Its filename is
     vm_is_stack-use-for_each_thread-rather-then-buggy-while_each_thread.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vm_is_stack-use-for_each_thread-rather-then-buggy-while_each_thread.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vm_is_stack-use-for_each_thread-rather-then-buggy-while_each_thread.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: vm_is_stack: use for_each_thread() rather then buggy while_each_thread()

Aleksei hit the soft lockup during reading /proc/PID/smaps.  David
investigated the problem and suggested the right fix.

while_each_thread() is racy and should die, this patch updates
vm_is_stack().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Aleksei Besogonov <alex.besogonov@gmail.com>
Tested-by: Aleksei Besogonov <alex.besogonov@gmail.com>
Suggested-by: David Rientjes <rientjes@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN mm/util.c~vm_is_stack-use-for_each_thread-rather-then-buggy-while_each_thread mm/util.c
--- a/mm/util.c~vm_is_stack-use-for_each_thread-rather-then-buggy-while_each_thread
+++ a/mm/util.c
@@ -213,17 +213,14 @@ pid_t vm_is_stack(struct task_struct *ta
 
 	if (in_group) {
 		struct task_struct *t;
-		rcu_read_lock();
-		if (!pid_alive(task))
-			goto done;
 
-		t = task;
-		do {
+		rcu_read_lock();
+		for_each_thread(task, t) {
 			if (vm_is_stack_for_task(t, vma)) {
 				ret = t->pid;
 				goto done;
 			}
-		} while_each_thread(task, t);
+		}
 done:
 		rcu_read_unlock();
 	}
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
vm_is_stack-use-for_each_thread-rather-then-buggy-while_each_thread.patch
fork-exec-cleanup-mm-initialization.patch
fork-reset-mm-pinned_vm.patch
fork-copy-mms-vm-usage-counters-under-mmap_sem.patch
linux-next.patch

