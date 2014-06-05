From: akpm@linux-foundation.org
Subject: [merged]
 memcg-optimize-the-search-everything-else-loop-in-mm_update_next_owner.patch removed from -mm tree
Date: Thu, 05 Jun 2014 12:50:48 -0700
Message-ID: <5390ca18.jmpgIGZ52mi1aUyi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56048 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbaFETut (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:50:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, pchiang@nvidia.com, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, bsingharora@gmail.com, oleg@redhat.com

Subject: [merged] memcg-optimize-the-search-everything-else-loop-in-mm_update_next_owner.patch removed from -mm tree
To: oleg@redhat.com,bsingharora@gmail.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,pchiang@nvidia.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:50:48 -0700


The patch titled
     Subject: memcg: optimize the "Search everything else" loop in mm_update_next_owner()
has been removed from the -mm tree.  Its filename was
     memcg-optimize-the-search-everything-else-loop-in-mm_update_next_owner.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: memcg: optimize the "Search everything else" loop in mm_update_next_owner()

for_each_process_thread() is sub-optimal. All threads share the same
->mm, we can swicth to the next process once we found a thread with
->mm != NULL and ->mm != mm.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Peter Chiang <pchiang@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff -puN kernel/exit.c~memcg-optimize-the-search-everything-else-loop-in-mm_update_next_owner kernel/exit.c
--- a/kernel/exit.c~memcg-optimize-the-search-everything-else-loop-in-mm_update_next_owner
+++ a/kernel/exit.c
@@ -397,9 +397,15 @@ retry:
 	/*
 	 * Search through everything else, we should not get here often.
 	 */
-	for_each_process_thread(g, c) {
-		if (!(c->flags & PF_KTHREAD) && c->mm == mm)
-			goto assign_new_owner;
+	for_each_process(g) {
+		if (g->flags & PF_KTHREAD)
+			continue;
+		for_each_thread(g, c) {
+			if (c->mm == mm)
+				goto assign_new_owner;
+			if (c->mm)
+				break;
+		}
 	}
 	read_unlock(&tasklist_lock);
 	/*
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
ptrace-fix-fork-event-messages-across-pid-namespaces.patch
ptrace-task_clear_jobctl_trapping-wake_up_bit-needs-mb.patch
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
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-fix.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-v5.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch
kernel-user_namespacec-kernel-doc-checkpatch-fixes.patch
linux-next.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix.patch
nmi-provide-the-option-to-issue-an-nmi-back-trace-to-every-cpu-but-current.patch
nmi-provide-the-option-to-issue-an-nmi-back-trace-to-every-cpu-but-current-fix.patch

