From: akpm@linux-foundation.org
Subject: [merged] memcg-give-current-access-to-memory-reserves-if-its-trying-to-die.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:25:21 -0700
Message-ID: <201103250725.p2P7PFG2026008@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47276 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933936Ab1CYHZ0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:25:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: give current access to memory reserves if it's trying to die
has been removed from the -mm tree.  Its filename was
     memcg-give-current-access-to-memory-reserves-if-its-trying-to-die.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: give current access to memory reserves if it's trying to die
From: David Rientjes <rientjes@google.com>

When a memcg is oom and current has already received a SIGKILL, then give
it access to memory reserves with a higher scheduling priority so that it
may quickly exit and free its memory.

This is identical to the global oom killer and is done even before
checking for panic_on_oom: a pending SIGKILL here while panic_on_oom is
selected is guaranteed to have come from userspace; the thread only needs
access to memory reserves to exit and thus we don't unnecessarily panic
the machine until the kernel has no last resort to free memory.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN mm/oom_kill.c~memcg-give-current-access-to-memory-reserves-if-its-trying-to-die mm/oom_kill.c
--- a/mm/oom_kill.c~memcg-give-current-access-to-memory-reserves-if-its-trying-to-die
+++ a/mm/oom_kill.c
@@ -549,6 +549,17 @@ void mem_cgroup_out_of_memory(struct mem
 	unsigned int points = 0;
 	struct task_struct *p;
 
+	/*
+	 * If current has a pending SIGKILL, then automatically select it.  The
+	 * goal is to allow it to allocate so that it may quickly exit and free
+	 * its memory.
+	 */
+	if (fatal_signal_pending(current)) {
+		set_thread_flag(TIF_MEMDIE);
+		boost_dying_task_prio(current, NULL);
+		return;
+	}
+
 	check_panic_on_oom(CONSTRAINT_MEMCG, gfp_mask, 0, NULL);
 	limit = mem_cgroup_get_limit(mem) >> PAGE_SHIFT;
 	read_lock(&tasklist_lock);
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
jbd-remove-dependency-on-__gfp_nofail.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-add-dirty-page-accounting-infrastructure.patch
memcg-add-kernel-calls-for-memcg-dirty-page-stats.patch
memcg-add-dirty-limits-to-mem_cgroup.patch
memcg-add-cgroupfs-interface-to-memcg-dirty-limits.patch
memcg-add-dirty-limiting-routines.patch
memcg-check-memcg-dirty-limits-in-page-writeback.patch
memcg-make-background-writeback-memcg-aware.patch

