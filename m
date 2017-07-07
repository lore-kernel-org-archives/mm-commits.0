From: akpm@linux-foundation.org
Subject: [merged]
 mm-cpuset-always-use-seqlock-when-changing-tasks-nodemask.patch removed
 from -mm tree
Date: Fri, 07 Jul 2017 12:11:00 -0700
Message-ID: <20170707191100.Z8OTOVXdr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34362 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751438AbdGGTLD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jul 2017 15:11:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, cl@linux.com, hughd@google.com, khandual@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, lizefan@huawei.com, mgorman@techsingularity.net, mhocko@suse.com, mm-commits@vger.kernel.org, rientjes@google.com, sivanich@sgi.com, vbabka@suse.cz


The patch titled
     Subject: mm, cpuset: always use seqlock when changing task's nodemask
has been removed from the -mm tree.  Its filename was
     mm-cpuset-always-use-seqlock-when-changing-tasks-nodemask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, cpuset: always use seqlock when changing task's nodemask

When updating task's mems_allowed and rebinding its mempolicy due to
cpuset's mems being changed, we currently only take the seqlock for
writing when either the task has a mempolicy, or the new mems has no
intersection with the old mems.  This should be enough to prevent a
parallel allocation seeing no available nodes, but the optimization is
IMHO unnecessary (cpuset updates should not be frequent), and we still
potentially risk issues if the intersection of new and old nodes has
limited amount of free/reclaimable memory.  Let's just use the seqlock for
all tasks.

Link: http://lkml.kernel.org/r/20170517081140.30654-6-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dimitri Sivanich <sivanich@sgi.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup/cpuset.c |   29 ++++++++---------------------
 1 file changed, 8 insertions(+), 21 deletions(-)

diff -puN kernel/cgroup/cpuset.c~mm-cpuset-always-use-seqlock-when-changing-tasks-nodemask kernel/cgroup/cpuset.c
--- a/kernel/cgroup/cpuset.c~mm-cpuset-always-use-seqlock-when-changing-tasks-nodemask
+++ a/kernel/cgroup/cpuset.c
@@ -1038,38 +1038,25 @@ static void cpuset_post_attach(void)
  * @tsk: the task to change
  * @newmems: new nodes that the task will be set
  *
- * In order to avoid seeing no nodes if the old and new nodes are disjoint,
- * we structure updates as setting all new allowed nodes, then clearing newly
- * disallowed ones.
+ * We use the mems_allowed_seq seqlock to safely update both tsk->mems_allowed
+ * and rebind an eventual tasks' mempolicy. If the task is allocating in
+ * parallel, it might temporarily see an empty intersection, which results in
+ * a seqlock check and retry before OOM or allocation failure.
  */
 static void cpuset_change_task_nodemask(struct task_struct *tsk,
 					nodemask_t *newmems)
 {
-	bool need_loop;
-
 	task_lock(tsk);
-	/*
-	 * Determine if a loop is necessary if another thread is doing
-	 * read_mems_allowed_begin().  If at least one node remains unchanged and
-	 * tsk does not have a mempolicy, then an empty nodemask will not be
-	 * possible when mems_allowed is larger than a word.
-	 */
-	need_loop = task_has_mempolicy(tsk) ||
-			!nodes_intersects(*newmems, tsk->mems_allowed);
 
-	if (need_loop) {
-		local_irq_disable();
-		write_seqcount_begin(&tsk->mems_allowed_seq);
-	}
+	local_irq_disable();
+	write_seqcount_begin(&tsk->mems_allowed_seq);
 
 	nodes_or(tsk->mems_allowed, tsk->mems_allowed, *newmems);
 	mpol_rebind_task(tsk, newmems);
 	tsk->mems_allowed = *newmems;
 
-	if (need_loop) {
-		write_seqcount_end(&tsk->mems_allowed_seq);
-		local_irq_enable();
-	}
+	write_seqcount_end(&tsk->mems_allowed_seq);
+	local_irq_enable();
 
 	task_unlock(tsk);
 }
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-page_alloc-fallback-to-smallest-page-when-not-stealing-whole-pageblock.patch

