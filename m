From: akpm@linux-foundation.org
Subject: + oom-__task_cred-need-rcu_read_lock.patch added to -mm tree
Date: Thu, 19 Aug 2010 09:28:34 -0700
Message-ID: <201008191625.o7JGPmvO028435@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39313 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751150Ab0HSQ0H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Aug 2010 12:26:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, dhowells@redhat.com, paulmck@linux.vnet.ibm.com, rientjes@google.com


The patch titled
     oom: __task_cred() need rcu_read_lock()
has been added to the -mm tree.  Its filename is
     oom-__task_cred-need-rcu_read_lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oom: __task_cred() need rcu_read_lock()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

dump_tasks() needs to hold the RCU read lock around its access of the
target task's UID.  To this end it should use task_uid() as it only needs
that one thing from the creds.

The fact that dump_tasks() holds tasklist_lock is insufficient to prevent the
target process replacing its credentials on another CPU.

Then, this patch change to call rcu_read_lock() explicitly.

	===================================================
	[ INFO: suspicious rcu_dereference_check() usage. ]
	---------------------------------------------------
	mm/oom_kill.c:410 invoked rcu_dereference_check() without protection!

	other info that might help us debug this:

	rcu_scheduler_active = 1, debug_locks = 1
	4 locks held by kworker/1:2/651:
	 #0:  (events){+.+.+.}, at: [<ffffffff8106aae7>]
	process_one_work+0x137/0x4a0
	 #1:  (moom_work){+.+...}, at: [<ffffffff8106aae7>]
	process_one_work+0x137/0x4a0
	 #2:  (tasklist_lock){.+.+..}, at: [<ffffffff810fafd4>]
	out_of_memory+0x164/0x3f0
	 #3:  (&(&p->alloc_lock)->rlock){+.+...}, at: [<ffffffff810fa48e>]
	find_lock_task_mm+0x2e/0x70

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/oom_kill.c~oom-__task_cred-need-rcu_read_lock mm/oom_kill.c
--- a/mm/oom_kill.c~oom-__task_cred-need-rcu_read_lock
+++ a/mm/oom_kill.c
@@ -372,7 +372,7 @@ static void dump_tasks(const struct mem_
 		}
 
 		pr_info("[%5d] %5d %5d %8lu %8lu %3u     %3d         %5d %s\n",
-			task->pid, __task_cred(task)->uid, task->tgid,
+			task->pid, task_uid(task), task->tgid,
 			task->mm->total_vm, get_mm_rss(task->mm),
 			task_cpu(task), task->signal->oom_adj,
 			task->signal->oom_score_adj, task->comm);
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

oom-fix-null-pointer-dereference.patch
oom-fix-tasklist_lock-leak.patch
oom-__task_cred-need-rcu_read_lock.patch
security-add-const-to-security_task_setscheduler.patch
sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch
vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch
vmscan-kick-flusher-threads-to-clean-pages-when-reclaim-is-encountering-dirty-pages.patch
reiser4.patch

