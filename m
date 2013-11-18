From: akpm@linux-foundation.org
Subject: +
 mm-memcg-avoid-oom-notification-when-current-needs-access-to-memory-reserves.patch added to -mm tree
Date: Mon, 18 Nov 2013 13:42:45 -0800
Message-ID: <528a89d5.+t4ko3p+o7+AoGFu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58755 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab3KRVmq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 18 Nov 2013 16:42:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, rientjes@google.com

Subject: + mm-memcg-avoid-oom-notification-when-current-needs-access-to-memory-reserves.patch added to -mm tree
To: rientjes@google.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz
From: akpm@linux-foundation.org
Date: Mon, 18 Nov 2013 13:42:45 -0800


The patch titled
     Subject: mm, memcg: avoid oom notification when current needs access to memory reserves
has been added to the -mm tree.  Its filename is
     mm-memcg-avoid-oom-notification-when-current-needs-access-to-memory-reserves.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-avoid-oom-notification-when-current-needs-access-to-memory-reserves.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-avoid-oom-notification-when-current-needs-access-to-memory-reserves.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, memcg: avoid oom notification when current needs access to memory reserves

When current has a pending SIGKILL or is already in the exit path, it only
needs access to memory reserves to fully exit.  In that sense, the memcg
is not actually oom for current, it simply needs to bypass memory charges
to exit and free its memory, which is guarantee itself that memory will be
freed.

We only want to notify userspace for actionable oom conditions where
something needs to be done (and all oom handling can already be deferred
to userspace through this method by disabling the memcg oom killer with
memory.oom_control), not simply when a memcg has reached its limit, which
would actually have to happen before memcg reclaim actually frees memory
for charges.

Signed-off-by: David Rientjes <rientjes@google.com>
Reported-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-avoid-oom-notification-when-current-needs-access-to-memory-reserves mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-avoid-oom-notification-when-current-needs-access-to-memory-reserves
+++ a/mm/memcontrol.c
@@ -1783,16 +1783,6 @@ static void mem_cgroup_out_of_memory(str
 	unsigned int points = 0;
 	struct task_struct *chosen = NULL;
 
-	/*
-	 * If current has a pending SIGKILL or is exiting, then automatically
-	 * select it.  The goal is to allow it to allocate so that it may
-	 * quickly exit and free its memory.
-	 */
-	if (fatal_signal_pending(current) || current->flags & PF_EXITING) {
-		set_thread_flag(TIF_MEMDIE);
-		return;
-	}
-
 	check_panic_on_oom(CONSTRAINT_MEMCG, gfp_mask, order, NULL);
 	totalpages = mem_cgroup_get_limit(memcg) >> PAGE_SHIFT ? : 1;
 	for_each_mem_cgroup_tree(iter, memcg) {
@@ -2243,6 +2233,16 @@ bool mem_cgroup_oom_synchronize(bool han
 	if (!handle)
 		goto cleanup;
 
+	/*
+	 * If current has a pending SIGKILL or is exiting, then automatically
+	 * select it.  The goal is to allow it to allocate so that it may
+	 * quickly exit and free its memory.
+	 */
+	if (fatal_signal_pending(current) || current->flags & PF_EXITING) {
+		set_thread_flag(TIF_MEMDIE);
+		goto cleanup;
+	}
+
 	owait.memcg = memcg;
 	owait.wait.flags = 0;
 	owait.wait.func = memcg_oom_wake_function;
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
x86-srat-use-numa_no_node.patch
mm-memcg-avoid-oom-notification-when-current-needs-access-to-memory-reserves.patch
mm-memcg-add-memoryoom_control-notification-for-system-oom.patch

