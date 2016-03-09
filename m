From: akpm@linux-foundation.org
Subject: + mm-oom_kill-dont-ignore-oom-score-on-exiting-tasks.patch added
 to -mm tree
Date: Wed, 09 Mar 2016 14:33:06 -0800
Message-ID: <56e0a4a2.+Fd9cP+LrQLOxK6i%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59123 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbcCIWdI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Mar 2016 17:33:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, andrea@kernel.org, hughd@google.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, mhocko@suse.com, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, riel@redhat.com, rientjes@google.com, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: oom_kill: don't ignore oom score on exiting tasks
has been added to the -mm tree.  Its filename is
     mm-oom_kill-dont-ignore-oom-score-on-exiting-tasks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom_kill-dont-ignore-oom-score-on-exiting-tasks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom_kill-dont-ignore-oom-score-on-exiting-tasks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: oom_kill: don't ignore oom score on exiting tasks

Currently, oom_scan_process_thread() returns OOM_SCAN_ABORT when there is
a thread which is exiting. But it is possible that that thread is blocked
at down_read(&mm->mmap_sem) in exit_mm() called from do_exit() whereas
one of threads sharing that memory is doing a GFP_KERNEL allocation
between down_write(&mm->mmap_sem) and up_write(&mm->mmap_sem)
(e.g. mmap()).

----------
T1                  T2
                    Calls mmap()
Calls _exit(0)
                    Arrives at vm_mmap_pgoff()
Arrives at do_exit()
Gets PF_EXITING via exit_signals()
                    Calls down_write(&mm->mmap_sem)
                    Calls do_mmap_pgoff()
Calls down_read(&mm->mmap_sem) from exit_mm()
                    Calls out of memory via a GFP_KERNEL allocation but
                    oom_scan_process_thread(T1) returns OOM_SCAN_ABORT
----------

down_read(&mm->mmap_sem) by T1 is waiting for up_write(&mm->mmap_sem) by
T2 while oom_scan_process_thread() by T2 is waiting for T1 to set
T1->mm = NULL. Under such situation, the OOM killer does not choose
a victim, which results in silent OOM livelock problem.

This patch changes oom_scan_process_thread() not to return OOM_SCAN_ABORT
when there is a thread which is exiting.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Argangeli <andrea@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN mm/oom_kill.c~mm-oom_kill-dont-ignore-oom-score-on-exiting-tasks mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom_kill-dont-ignore-oom-score-on-exiting-tasks
+++ a/mm/oom_kill.c
@@ -292,9 +292,6 @@ enum oom_scan_t oom_scan_process_thread(
 	if (oom_task_origin(task))
 		return OOM_SCAN_SELECT;
 
-	if (task_will_free_mem(task) && !is_sysrq_oom(oc))
-		return OOM_SCAN_ABORT;
