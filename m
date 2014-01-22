From: akpm@linux-foundation.org
Subject: [merged]
 mm-thp-turn-compound_head-into-bug_onpagetail-in-get_huge_page_tail.patch
 removed from -mm tree
Date: Wed, 22 Jan 2014 12:12:34 -0800
Message-ID: <52e02632.uJEbMxHK/dpWCvhk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54324 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810AbaAVUMf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:12:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, peterz@infradead.org, mgorman@suse.de, dvhart@linux.intel.com, davej@redhat.com, aarcange@redhat.com, oleg@redhat.com

Subject: [merged] mm-thp-turn-compound_head-into-bug_onpagetail-in-get_huge_page_tail.patch removed from -mm tree
To: oleg@redhat.com,aarcange@redhat.com,davej@redhat.com,dvhart@linux.intel.com,mgorman@suse.de,peterz@infradead.org,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:12:34 -0800


The patch titled
     Subject: mm: thp: turn compound_head() into BUG_ON(!PageTail) in get_huge_page_tail()
has been removed from the -mm tree.  Its filename was
     mm-thp-turn-compound_head-into-bug_onpagetail-in-get_huge_page_tail.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: mm: thp: turn compound_head() into BUG_ON(!PageTail) in get_huge_page_tail()

get_huge_page_tail()->compound_head() looks confusing.  Every caller must
check PageTail(page), otherwise atomic_inc(&page->_mapcount) is simply
wrong if this page is compound-trans-head.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Dave Jones <davej@redhat.com>
Cc: Darren Hart <dvhart@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Acked-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN include/linux/mm.h~mm-thp-turn-compound_head-into-bug_onpagetail-in-get_huge_page_tail include/linux/mm.h
--- a/include/linux/mm.h~mm-thp-turn-compound_head-into-bug_onpagetail-in-get_huge_page_tail
+++ a/include/linux/mm.h
@@ -445,13 +445,12 @@ static inline bool compound_tail_refcoun
 static inline void get_huge_page_tail(struct page *page)
 {
 	/*
-	 * __split_huge_page_refcount() cannot run
-	 * from under us.
-	 * In turn no need of compound_trans_head here.
+	 * __split_huge_page_refcount() cannot run from under us.
 	 */
+	VM_BUG_ON(!PageTail(page));
 	VM_BUG_ON(page_mapcount(page) < 0);
 	VM_BUG_ON(atomic_read(&page->_count) != 0);
-	if (compound_tail_refcounted(compound_head(page)))
+	if (compound_tail_refcounted(page->first_page))
 		atomic_inc(&page->_mapcount);
 }
 
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

