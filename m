From: akpm@linux-foundation.org
Subject: + memcg-mm_update_next_owner-should-skip-kthreads.patch added to
 -mm tree
Date: Mon, 28 Apr 2014 15:58:05 -0700
Message-ID: <535edcfd.cfKDFgF/2XZ+PRws%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50831 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242AbaD1W6G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Apr 2014 18:58:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, pchiang@nvidia.com, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, bsingharora@gmail.com, oleg@redhat.com

Subject: + memcg-mm_update_next_owner-should-skip-kthreads.patch added to -mm tree
To: oleg@redhat.com,bsingharora@gmail.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,pchiang@nvidia.com
From: akpm@linux-foundation.org
Date: Mon, 28 Apr 2014 15:58:05 -0700


The patch titled
     Subject: memcg: mm_update_next_owner() should skip kthreads
has been added to the -mm tree.  Its filename is
     memcg-mm_update_next_owner-should-skip-kthreads.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-mm_update_next_owner-should-skip-kthreads.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-mm_update_next_owner-should-skip-kthreads.patch

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
Subject: memcg: mm_update_next_owner() should skip kthreads

"Search through everything else" in mm_update_next_owner() can hit a
kthread which adopted this "mm" via use_mm(), it should not be used as
mm->owner.  Add the PF_KTHREAD check.

While at it, change this code to use for_each_process_thread()
instead of deprecated do_each_thread/while_each_thread.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Peter Chiang <pchiang@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN kernel/exit.c~memcg-mm_update_next_owner-should-skip-kthreads kernel/exit.c
--- a/kernel/exit.c~memcg-mm_update_next_owner-should-skip-kthreads
+++ a/kernel/exit.c
@@ -395,14 +395,12 @@ retry:
 	}
 
 	/*
-	 * Search through everything else. We should not get
-	 * here often
+	 * Search through everything else, we should not get here often.
 	 */
-	do_each_thread(g, c) {
-		if (c->mm == mm)
+	for_each_process_thread(g, c) {
+		if (!(c->flags & PF_KTHREAD) && c->mm == mm)
 			goto assign_new_owner;
-	} while_each_thread(g, c);
-
+	}
 	read_unlock(&tasklist_lock);
 	/*
 	 * We found no owner yet mm_users > 1: this implies that we are
_

Patches currently in -mm which might be from oleg@redhat.com are

nmi-provide-the-option-to-issue-an-nmi-back-trace-to-every-cpu-but-current.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix.patch
mmvmacache-optimize-overflow-system-wide-flushing.patch
memcg-kill-config_mm_owner.patch
memcg-mm_update_next_owner-should-skip-kthreads.patch
memcg-optimize-the-search-everything-else-loop-in-mm_update_next_owner.patch
memcg-kill-start_kernel-mm_init_ownerinit_mm.patch
sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall.patch
kthreads-kill-clone_kernel-change-kernel_threadkernel_init-to-avoid-clone_sighand.patch
signals-kill-sigfindinword.patch
signals-s-siginitset-sigemptyset-in-do_sigtimedwait.patch
signals-kill-rm_from_queue-change-prepare_signal-to-use-for_each_thread.patch
signals-rename-rm_from_queue_full-to-flush_sigqueue_mask.patch
signals-cleanup-the-usage-of-t-current-in-do_sigaction.patch
signals-mv-disallow_signal-from-schedh-exitc-to-signal.patch
signals-jffs2-fix-the-wrong-usage-of-disallow_signal.patch
signals-kill-the-obsolete-sigdelset-and-recalc_sigpending-in-allow_signal.patch
signals-disallow_signal-should-flush-the-potentially-pending-signal.patch
signals-introduce-kernel_sigaction.patch
signals-change-wait_for_helper-to-use-kernel_sigaction.patch
linux-next.patch

