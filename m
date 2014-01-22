From: akpm@linux-foundation.org
Subject: [merged]
 mm-thp-__get_page_tail_foll-can-use-get_huge_page_tail.patch removed from
 -mm tree
Date: Wed, 22 Jan 2014 12:12:32 -0800
Message-ID: <52e02630.u7clkvPIQaFrZS/t%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54315 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810AbaAVUMd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:12:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, peterz@infradead.org, mgorman@suse.de, dvhart@linux.intel.com, davej@redhat.com, aarcange@redhat.com, oleg@redhat.com

Subject: [merged] mm-thp-__get_page_tail_foll-can-use-get_huge_page_tail.patch removed from -mm tree
To: oleg@redhat.com,aarcange@redhat.com,davej@redhat.com,dvhart@linux.intel.com,mgorman@suse.de,peterz@infradead.org,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:12:32 -0800


The patch titled
     Subject: mm: thp: __get_page_tail_foll() can use get_huge_page_tail()
has been removed from the -mm tree.  Its filename was
     mm-thp-__get_page_tail_foll-can-use-get_huge_page_tail.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
mm-fix-the-theoretical-compound_lock-vs-prep_new_page-race.patch
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
exec-avoid-propagating-pf_no_setaffinity-into-userspace-child.patch
linux-next.patch

