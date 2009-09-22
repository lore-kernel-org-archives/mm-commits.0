From: akpm@linux-foundation.org
Subject: [merged] oom-oom_kill-doesnt-kill-vfork-parentor-child.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:42:25 -0700
Message-ID: <200909222042.n8MKgPlO009562@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35295 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752871AbZIVUmj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:42:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, oleg@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     oom: oom_kill doesn't kill vfork parent (or child)
has been removed from the -mm tree.  Its filename was
     oom-oom_kill-doesnt-kill-vfork-parentor-child.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oom: oom_kill doesn't kill vfork parent (or child)
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Current oom_kill doesn't only kill the victim process, but also kill all
thas shread the same mm.  it mean vfork parent will be killed.

This is definitely incorrect.  another process have another oom_adj.  we
shouldn't ignore their oom_adj (it might have OOM_DISABLE).

following caller hit the minefield.

===============================
        switch (constraint) {
        case CONSTRAINT_MEMORY_POLICY:
                oom_kill_process(current, gfp_mask, order, 0, NULL,
                                "No available memory (MPOL_BIND)");
                break;

Note: force_sig(SIGKILL) send SIGKILL to all thread in the process.
We don't need to care multi thread in here.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff -puN mm/oom_kill.c~oom-oom_kill-doesnt-kill-vfork-parentor-child mm/oom_kill.c
--- a/mm/oom_kill.c~oom-oom_kill-doesnt-kill-vfork-parentor-child
+++ a/mm/oom_kill.c
@@ -373,11 +373,6 @@ static void __oom_kill_task(struct task_
 
 static int oom_kill_task(struct task_struct *p)
 {
-	struct mm_struct *mm;
-	struct task_struct *g, *q;
-
-	mm = p->mm;
-
 	/* WARNING: mm may not be dereferenced since we did not obtain its
 	 * value from get_task_mm(p).  This is OK since all we need to do is
 	 * compare mm to q->mm below.
@@ -386,21 +381,11 @@ static int oom_kill_task(struct task_str
 	 * change to NULL at any time since we do not hold task_lock(p).
 	 * However, this is of no concern to us.
 	 */
-	if (!mm || p->signal->oom_adj == OOM_DISABLE)
+	if (!p->mm || p->signal->oom_adj == OOM_DISABLE)
 		return 1;
 
 	__oom_kill_task(p, 1);
 
-	/*
-	 * kill all processes that share the ->mm (i.e. all threads),
-	 * but are in a different thread group. Don't let them have access
-	 * to memory reserves though, otherwise we might deplete all memory.
-	 */
-	do_each_thread(g, q) {
-		if (q->mm == mm && !same_thread_group(q, p))
-			force_sig(SIGKILL, q);
-	} while_each_thread(g, q);
-
 	return 0;
 }
 
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
linux-next.patch
revert-staging-android-lowmemorykillerc-fix-it-for-oom-move-oom_adj-value-from-task_struct-to-mm_struct.patch
readahead-add-blk_run_backing_dev.patch
oom-move-oom_adj-value-from-task_struct-to-signal_struct-fix.patch
mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value.patch
getrusage-fill-ru_maxrss-value.patch
kcore-use-registerd-physmem-information-ia64-fix.patch
memory-controller-soft-limit-documentation-v9.patch
memory-controller-soft-limit-interface-v9.patch
memory-controller-soft-limit-organize-cgroups-v9.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
memory-controller-soft-limit-refactor-reclaim-flags-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling-fix.patch
memcg-improve-resource-counter-scalability.patch
memcg-improve-resource-counter-scalability-v5.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

