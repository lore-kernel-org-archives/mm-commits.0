From: akpm@linux-foundation.org
Subject: + mm-thp-__get_page_tail_foll-can-use-get_huge_page_tail.patch
 added to -mm tree
Date: Mon, 16 Dec 2013 14:43:10 -0800
Message-ID: <52af81fe.vQ9tzXKjRoj4YJy3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46361 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab3LPWnL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Dec 2013 17:43:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, peterz@infradead.org, mgorman@suse.de, dvhart@linux.intel.com, davej@redhat.com, aarcange@redhat.com, oleg@redhat.com

Subject: + mm-thp-__get_page_tail_foll-can-use-get_huge_page_tail.patch added to -mm tree
To: oleg@redhat.com,aarcange@redhat.com,davej@redhat.com,dvhart@linux.intel.com,mgorman@suse.de,peterz@infradead.org,tglx@linutronix.de
From: akpm@linux-foundation.org
Date: Mon, 16 Dec 2013 14:43:10 -0800


The patch titled
     Subject: mm: thp: __get_page_tail_foll() can use get_huge_page_tail()
has been added to the -mm tree.  Its filename is
     mm-thp-__get_page_tail_foll-can-use-get_huge_page_tail.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-__get_page_tail_foll-can-use-get_huge_page_tail.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-__get_page_tail_foll-can-use-get_huge_page_tail.patch

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
Subject: mm: thp: __get_page_tail_foll() can use get_huge_page_tail()

Cleanup. Change __get_page_tail_foll() to use get_huge_page_tail()
to avoid the code duplication.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Dave Jones <davej@redhat.com>
Cc: Darren Hart <dvhart@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Acked-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN mm/internal.h~mm-thp-__get_page_tail_foll-can-use-get_huge_page_tail mm/internal.h
--- a/mm/internal.h~mm-thp-__get_page_tail_foll-can-use-get_huge_page_tail
+++ a/mm/internal.h
@@ -47,12 +47,9 @@ static inline void __get_page_tail_foll(
 	 * page_cache_get_speculative()) on tail pages.
 	 */
 	VM_BUG_ON(atomic_read(&page->first_page->_count) <= 0);
-	VM_BUG_ON(atomic_read(&page->_count) != 0);
-	VM_BUG_ON(page_mapcount(page) < 0);
 	if (get_page_head)
 		atomic_inc(&page->first_page->_count);
-	if (compound_tail_refcounted(page->first_page))
-		atomic_inc(&page->_mapcount);
+	get_huge_page_tail(page);
 }
 
 /*
_

Patches currently in -mm which might be from oleg@redhat.com are

mm-thp-__get_page_tail_foll-can-use-get_huge_page_tail.patch
mm-thp-turn-compound_head-into-bug_onpagetail-in-get_huge_page_tail.patch
introduce-for_each_thread-to-replace-the-buggy-while_each_thread.patch
oom_kill-change-oom_killc-to-use-for_each_thread.patch
oom_kill-has_intersects_mems_allowed-needs-rcu_read_lock.patch
oom_kill-add-rcu_read_lock-into-find_lock_task_mm.patch
autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace.patch
autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch
coredump-set_dumpable-fix-the-theoretical-race-with-itself.patch
coredump-kill-mmf_dumpable-and-mmf_dump_securely.patch
coredump-make-__get_dumpable-get_dumpable-inline-kill-fs-coredumph.patch
proc-cleanup-simplify-get_task_state-task_state_array.patch
proc-fix-the-potential-use-after-free-in-first_tid.patch
proc-change-first_tid-to-use-while_each_thread-rather-than-next_thread.patch
proc-dont-abuse-group_leader-in-proc_task_readdir-paths.patch
proc-fix-f_pos-overflows-in-first_tid.patch
kernel-forkc-remove-redundant-null-check-in-dup_mm.patch
exec-check_unsafe_exec-use-while_each_thread-rather-than-next_thread.patch
exec-check_unsafe_exec-kill-the-dead-eagain-and-clear_in_exec-logic.patch
exec-move-the-final-allow_write_access-fput-into-free_bprm.patch
exec-kill-task_struct-did_exec.patch
fs-proc-arrayc-change-do_task_stat-to-use-while_each_thread.patch
kernel-sysc-k_getrusage-can-use-while_each_thread.patch
kernel-signalc-change-do_signal_stop-do_sigaction-to-use-while_each_thread.patch
linux-next.patch

