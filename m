From: akpm@linux-foundation.org
Subject: + introduce-get_mm_hiwater_xxx-fix-taskstats-hiwater_xxx-accounting.patch added to -mm tree
Date: Mon, 15 Dec 2008 16:21:55 -0800
Message-ID: <200812160021.mBG0LtpK008931@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51706 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755041AbYLPAXK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Dec 2008 19:23:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, balbir@linux.vnet.ibm.com, hugh@veritas.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     mm: introduce get_mm_hiwater_xxx(), fix taskstats->hiwater_xxx accounting
has been added to the -mm tree.  Its filename is
     introduce-get_mm_hiwater_xxx-fix-taskstats-hiwater_xxx-accounting.patch

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
Subject: mm: introduce get_mm_hiwater_xxx(), fix taskstats->hiwater_xxx accounting
From: Oleg Nesterov <oleg@redhat.com>

xacct_add_tsk() relies on do_exit()->update_hiwater_xxx() and uses
mm->hiwater_xxx directly, this leads to 2 problems:

- taskstats_user_cmd() can call fill_pid()->xacct_add_tsk() at any
  moment before the task exits, so we should check the current values of
  rss/vm anyway.

- do_exit()->update_hiwater_xxx() calls are racy.  An exiting thread can
  be preempted right before mm->hiwater_xxx = new_val, and another thread
  can use A_LOT of memory and exit in between.  When the first thread
  resumes it can be the last thread in the thread group, in that case we
  report the wrong hiwater_xxx values which do not take A_LOT into
  account.

Introduce get_mm_hiwater_rss() and get_mm_hiwater_vm() helpers and change
xacct_add_tsk() to use them.  The first helper will also be used by
rusage->ru_maxrss accounting.

Kill do_exit()->update_hiwater_xxx() calls.  Unless we are going to
decrease rss/vm there is no point to update mm->hiwater_xxx, and nobody
can look at this mm_struct when exit_mmap() actually unmaps the memory.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Hugh Dickins <hugh@veritas.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    3 +++
 kernel/exit.c         |    5 +----
 kernel/tsacct.c       |    4 ++--
 mm/mmap.c             |    2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff -puN include/linux/sched.h~introduce-get_mm_hiwater_xxx-fix-taskstats-hiwater_xxx-accounting include/linux/sched.h
--- a/include/linux/sched.h~introduce-get_mm_hiwater_xxx-fix-taskstats-hiwater_xxx-accounting
+++ a/include/linux/sched.h
@@ -386,6 +386,9 @@ extern void arch_unmap_area_topdown(stru
 		(mm)->hiwater_vm = (mm)->total_vm;	\
 } while (0)
 
+#define get_mm_hiwater_rss(mm)	max((mm)->hiwater_rss, get_mm_rss(mm))
+#define get_mm_hiwater_vm(mm)	max((mm)->hiwater_vm, (mm)->total_vm)
+
 extern void set_dumpable(struct mm_struct *mm, int value);
 extern int get_dumpable(struct mm_struct *mm);
 
diff -puN kernel/exit.c~introduce-get_mm_hiwater_xxx-fix-taskstats-hiwater_xxx-accounting kernel/exit.c
--- a/kernel/exit.c~introduce-get_mm_hiwater_xxx-fix-taskstats-hiwater_xxx-accounting
+++ a/kernel/exit.c
@@ -1048,10 +1048,7 @@ NORET_TYPE void do_exit(long code)
 				preempt_count());
 
 	acct_update_integrals(tsk);
-	if (tsk->mm) {
-		update_hiwater_rss(tsk->mm);
-		update_hiwater_vm(tsk->mm);
-	}
+
 	group_dead = atomic_dec_and_test(&tsk->signal->live);
 	if (group_dead) {
 		hrtimer_cancel(&tsk->signal->real_timer);
diff -puN kernel/tsacct.c~introduce-get_mm_hiwater_xxx-fix-taskstats-hiwater_xxx-accounting kernel/tsacct.c
--- a/kernel/tsacct.c~introduce-get_mm_hiwater_xxx-fix-taskstats-hiwater_xxx-accounting
+++ a/kernel/tsacct.c
@@ -92,8 +92,8 @@ void xacct_add_tsk(struct taskstats *sta
 	mm = get_task_mm(p);
 	if (mm) {
 		/* adjust to KB unit */
-		stats->hiwater_rss   = mm->hiwater_rss * PAGE_SIZE / KB;
-		stats->hiwater_vm    = mm->hiwater_vm * PAGE_SIZE / KB;
+		stats->hiwater_rss   = get_mm_hiwater_rss(mm) * PAGE_SIZE / KB;
+		stats->hiwater_vm    = get_mm_hiwater_vm(mm)  * PAGE_SIZE / KB;
 		mmput(mm);
 	}
 	stats->read_char	= p->ioac.rchar;
diff -puN mm/mmap.c~introduce-get_mm_hiwater_xxx-fix-taskstats-hiwater_xxx-accounting mm/mmap.c
--- a/mm/mmap.c~introduce-get_mm_hiwater_xxx-fix-taskstats-hiwater_xxx-accounting
+++ a/mm/mmap.c
@@ -2102,7 +2102,7 @@ void exit_mmap(struct mm_struct *mm)
 	lru_add_drain();
 	flush_cache_mm(mm);
 	tlb = tlb_gather_mmu(mm, 1);
-	/* Don't update_hiwater_rss(mm) here, do_exit already did */
+	/* update_hiwater_rss(mm) here? but nobody should be looking */
 	/* Use -1 here to ensure all VMAs in the mm are unmapped */
 	end = unmap_vmas(&tlb, vma, 0, -1, &nr_accounted, NULL);
 	vm_unacct_memory(nr_accounted);
_

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
introduce-get_mm_hiwater_xxx-fix-taskstats-hiwater_xxx-accounting.patch
forkc-cleanup-for-copy_sighand.patch
poll-allow-f_op-poll-to-sleep-take6.patch
workqueues-kill-cpu_singlethread_map-use-get_cpu_mask-instead.patch

