From: akpm@linux-foundation.org
Subject: + oom-check-pf_kthread-instead-of-mm-to-skip-kthreads.patch added to -mm tree
Date: Tue, 08 Jun 2010 16:50:57 -0700
Message-ID: <201006082350.o58NovSr032191@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56267 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750925Ab0FHXvV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Jun 2010 19:51:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, rientjes@google.com


The patch titled
     oom: check PF_KTHREAD instead of !mm to skip kthreads
has been added to the -mm tree.  Its filename is
     oom-check-pf_kthread-instead-of-mm-to-skip-kthreads.patch

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
Subject: oom: check PF_KTHREAD instead of !mm to skip kthreads
From: Oleg Nesterov <oleg@redhat.com>

select_bad_process() thinks a kernel thread can't have ->mm != NULL, this
is not true due to use_mm().

Change the code to check PF_KTHREAD.

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN mm/oom_kill.c~oom-check-pf_kthread-instead-of-mm-to-skip-kthreads mm/oom_kill.c
--- a/mm/oom_kill.c~oom-check-pf_kthread-instead-of-mm-to-skip-kthreads
+++ a/mm/oom_kill.c
@@ -256,14 +256,11 @@ static struct task_struct *select_bad_pr
 	for_each_process(p) {
 		unsigned long points;
 
-		/*
-		 * skip kernel threads and tasks which have already released
-		 * their mm.
-		 */
+		/* skip tasks that have already released their mm */
 		if (!p->mm)
 			continue;
-		/* skip the init task */
-		if (is_global_init(p))
+		/* skip the init task and kthreads */
+		if (is_global_init(p) || (p->flags & PF_KTHREAD))
 			continue;
 		if (mem && !task_in_mem_cgroup(p, mem))
 			continue;
_

Patches currently in -mm which might be from oleg@redhat.com are

oom-check-pf_kthread-instead-of-mm-to-skip-kthreads.patch
oom-pf_exiting-check-should-take-mm-into-account.patch
oom-introduce-find_lock_task_mm-to-fix-mm-false-positives.patch
oom-dump_tasks-use-find_lock_task_mm-too.patch
sys_personality-remove-the-bogus-checks-in-sys_personality-__set_personality-path.patch

