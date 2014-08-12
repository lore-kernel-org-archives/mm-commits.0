From: akpm@linux-foundation.org
Subject: [merged]
 vm_is_stack-use-for_each_thread-rather-then-buggy-while_each_thread.patch
 removed from -mm tree
Date: Tue, 12 Aug 2014 12:37:54 -0700
Message-ID: <53ea6d12.NXLxoHFnKFplh7t3%akpm__31491.4157883779$1407872291$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f201.google.com ([209.85.192.201]:43839 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866AbaHLThz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:37:55 -0400
Received: by mail-pd0-f201.google.com with SMTP id g10so2669126pdj.2
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:37:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, alex.besogonov@gmail.com, rientjes@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: vm_is_stack: use for_each_thread() rather then buggy while_each_thread()
has been removed from the -mm tree.  Its filename was
     vm_is_stack-use-for_each_thread-rather-then-buggy-while_each_thread.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -183,17 +183,14 @@ pid_t vm_is_stack(struct task_struct *ta
 
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
linux-next.patch

