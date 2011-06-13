From: akpm@linux-foundation.org
Subject: + memcg-clear-mm-owner-when-last-possible-owner-leaves.patch added to -mm tree
Date: Mon, 13 Jun 2011 14:23:42 -0700
Message-ID: <201106132123.p5DLNg3d022718@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49046 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754345Ab1FMVYd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Jun 2011 17:24:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, aarcange@redhat.com, davej@redhat.com, hannes@cmpxchg.org, hughd@google.com


The patch titled
     memcg: clear mm->owner when last possible owner leaves
has been added to the -mm tree.  Its filename is
     memcg-clear-mm-owner-when-last-possible-owner-leaves.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: clear mm->owner when last possible owner leaves
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

The following crash was reported:

> Call Trace:
> [<ffffffff81139792>] mem_cgroup_from_task+0x15/0x17
> [<ffffffff8113a75a>] __mem_cgroup_try_charge+0x148/0x4b4
> [<ffffffff810493f3>] ? need_resched+0x23/0x2d
> [<ffffffff814cbf43>] ? preempt_schedule+0x46/0x4f
> [<ffffffff8113afe8>] mem_cgroup_charge_common+0x9a/0xce
> [<ffffffff8113b6d1>] mem_cgroup_newpage_charge+0x5d/0x5f
> [<ffffffff81134024>] khugepaged+0x5da/0xfaf
> [<ffffffff81078ea0>] ? __init_waitqueue_head+0x4b/0x4b
> [<ffffffff81133a4a>] ? add_mm_counter.constprop.5+0x13/0x13
> [<ffffffff81078625>] kthread+0xa8/0xb0
> [<ffffffff814d13e8>] ? sub_preempt_count+0xa1/0xb4
> [<ffffffff814d5664>] kernel_thread_helper+0x4/0x10
> [<ffffffff814ce858>] ? retint_restore_args+0x13/0x13
> [<ffffffff8107857d>] ? __init_kthread_worker+0x5a/0x5a

What happens is that khugepaged tries to charge a huge page against an mm
whose last possible owner has already exited, and the memory controller
crashes when the stale mm->owner is used to look up the cgroup to charge.

mm->owner has never been set to NULL with the last owner going away, but
nobody cared until khugepaged came along.

Even then it wasn't a problem because the final mmput() on an mm was
forced to acquire and release mmap_sem in write-mode, preventing an
exiting owner to go away while the mmap_sem was held, and until "692e0b3
mm: thp: optimize memcg charge in khugepaged", the memory cgroup charge
was protected by mmap_sem in read-mode.

Instead of going back to relying on the mmap_sem to enforce lifetime of a
task, this patch ensures that mm->owner is properly set to NULL when the
last possible owner is exiting, which the memory controller can handle
just fine.

Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Hugh Dickins <hughd@google.com>
Reported-by: Dave Jones <davej@redhat.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff -puN kernel/exit.c~memcg-clear-mm-owner-when-last-possible-owner-leaves kernel/exit.c
--- a/kernel/exit.c~memcg-clear-mm-owner-when-last-possible-owner-leaves
+++ a/kernel/exit.c
@@ -561,29 +561,28 @@ void exit_files(struct task_struct *tsk)
 
 #ifdef CONFIG_MM_OWNER
 /*
- * Task p is exiting and it owned mm, lets find a new owner for it
+ * A task is exiting and if it owned mm, lets find a new owner for it
  */
-static inline int
-mm_need_new_owner(struct mm_struct *mm, struct task_struct *p)
-{
-	/*
-	 * If there are other users of the mm and the owner (us) is exiting
-	 * we need to find a new owner to take on the responsibility.
-	 */
-	if (atomic_read(&mm->mm_users) <= 1)
-		return 0;
-	if (mm->owner != p)
-		return 0;
-	return 1;
-}
-
 void mm_update_next_owner(struct mm_struct *mm)
 {
 	struct task_struct *c, *g, *p = current;
 
 retry:
-	if (!mm_need_new_owner(mm, p))
+	/*
+	 * If the exiting or execing task is not the owner, it's
+	 * someone else's problem.
+	 */
+	if (mm->owner != p)
 		return;
+	/*
+	 * The current owner is exiting/execing and there are no other
+	 * candidates.  Do not leave the mm pointing to a possibly
+	 * freed task structure.
+	 */
+	if (atomic_read(&mm->mm_users) <= 1) {
+		mm->owner = NULL;
+		return;
+	}
 
 	read_lock(&tasklist_lock);
 	/*
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

vmscanmemcg-memcg-aware-swap-token.patch
vmscanmemcg-memcg-aware-swap-token-fix.patch
vmscan-implement-swap-token-trace.patch
vmscan-implement-swap-token-priority-aging.patch
memcg-add-documentation-for-the-memorynumastat-api.patch
memcg-add-documentation-for-the-memorynumastat-api-fix.patch
mm-increase-reclaim_distance-to-30.patch
mm-fix-wrong-kunmap_atomic-pointer.patch
mm-memory_hotplugc-fix-building-of-node-hotplug-zonelist.patch
mm-memorynuma_stat-fix-file-permission.patch
memcg-fix-init_page_cgroup-nid-with-sparsemem.patch
memcg-fix-init_page_cgroup-nid-with-sparsemem-fix.patch
memcg-clear-mm-owner-when-last-possible-owner-leaves.patch
memcg-clear-mm-owner-when-last-possible-owner-leaves-fix.patch
memcg-fix-wrong-check-of-noswap-with-softlimit.patch
memcg-fix-percpu-cached-charge-draining-frequency.patch
memcg-fix-percpu-cached-charge-draining-frequency-fix.patch
memcg-do-not-expose-uninitialized-mem_cgroup_per_node-to-world.patch

