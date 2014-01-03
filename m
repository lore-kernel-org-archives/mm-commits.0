From: akpm@linux-foundation.org
Subject: +
 mm-fix-the-theoretical-compound_lock-vs-prep_new_page-race.patch added to
 -mm tree
Date: Fri, 03 Jan 2014 13:00:37 -0800
Message-ID: <52c724f5.2igc01a5jqVoAja8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50781 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892AbaACVAi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jan 2014 16:00:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, aarcange@redhat.com, oleg@redhat.com

Subject: + mm-fix-the-theoretical-compound_lock-vs-prep_new_page-race.patch added to -mm tree
To: oleg@redhat.com,aarcange@redhat.com
From: akpm@linux-foundation.org
Date: Fri, 03 Jan 2014 13:00:37 -0800


The patch titled
     Subject: mm: fix the theoretical compound_lock() vs prep_new_page() race
has been added to the -mm tree.  Its filename is
     mm-fix-the-theoretical-compound_lock-vs-prep_new_page-race.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-the-theoretical-compound_lock-vs-prep_new_page-race.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-the-theoretical-compound_lock-vs-prep_new_page-race.patch

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
Subject: mm: fix the theoretical compound_lock() vs prep_new_page() race

get/put_page(thp_tail) paths do get_page_unless_zero(page_head) +
compound_lock().  In theory this page_head can be already freed and
reallocated as alloc_pages(__GFP_COMP, smaller_order).  In this case
get_page_unless_zero() can succeed right after set_page_refcounted(), and
compound_lock() can race with the non-atomic __SetPageHead().

Perhaps we should rework the thp locking (under discussion), but until
then this patch moves set_page_refcounted() and adds wmb() to ensure that
page->_count != 0 comes as a last change.

I am not sure about other callers of set_page_refcounted(), but at first
glance they look fine to me.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-fix-the-theoretical-compound_lock-vs-prep_new_page-race mm/page_alloc.c
--- a/mm/page_alloc.c~mm-fix-the-theoretical-compound_lock-vs-prep_new_page-race
+++ a/mm/page_alloc.c
@@ -890,8 +890,6 @@ static int prep_new_page(struct page *pa
 	}
 
 	set_page_private(page, 0);
-	set_page_refcounted(page);
-
 	arch_alloc_page(page, order);
 	kernel_map_pages(page, 1 << order, 1);
 
@@ -901,6 +899,16 @@ static int prep_new_page(struct page *pa
 	if (order && (gfp_flags & __GFP_COMP))
 		prep_compound_page(page, order);
 
+	/*
+	 * Make sure the caller of get_page_unless_zero() will see the
+	 * fully initialized page. Say, to ensure that compound_lock()
+	 * can't race with the non-atomic __SetPage*() above.
+	 */
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	smp_wmb();
+#endif
+	set_page_refcounted(page);
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from oleg@redhat.com are

mm-thp-__get_page_tail_foll-can-use-get_huge_page_tail.patch
mm-thp-turn-compound_head-into-bug_onpagetail-in-get_huge_page_tail.patch
introduce-for_each_thread-to-replace-the-buggy-while_each_thread.patch
oom_kill-change-oom_killc-to-use-for_each_thread.patch
oom_kill-has_intersects_mems_allowed-needs-rcu_read_lock.patch
oom_kill-add-rcu_read_lock-into-find_lock_task_mm.patch
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
linux-next.patch

