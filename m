From: akpm@linux-foundation.org
Subject: + mempolicy-kill-do_set_mempolicy-down_writemm-mmap_sem.patch
 added to -mm tree
Date: Tue, 26 Aug 2014 16:48:39 -0700
Message-ID: <53fd1cd7.hX8/OC7HYgHKUK4Z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f74.google.com ([209.85.219.74]:56450 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756029AbaHZXsk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Aug 2014 19:48:40 -0400
Received: by mail-oa0-f74.google.com with SMTP id eb12so3060642oac.5
        for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2014 16:48:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, andi@firstfloor.org, ebiederm@xmission.com, gorcunov@openvz.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kirill.shutemov@linux.intel.com, kosaki.motohiro@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com, peterz@infradead.org, rientjes@google.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mempolicy: kill do_set_mempolicy()->down_write(&mm->mmap_sem)
has been added to the -mm tree.  Its filename is
     mempolicy-kill-do_set_mempolicy-down_writemm-mmap_sem.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mempolicy-kill-do_set_mempolicy-down_writemm-mmap_sem.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mempolicy-kill-do_set_mempolicy-down_writemm-mmap_sem.patch

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
Subject: mempolicy: kill do_set_mempolicy()->down_write(&mm->mmap_sem)

Remove down_write(&mm->mmap_sem) in do_set_mempolicy(). This logic
was never correct and it is no longer needed, see the previous patch.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff -puN mm/mempolicy.c~mempolicy-kill-do_set_mempolicy-down_writemm-mmap_sem mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-kill-do_set_mempolicy-down_writemm-mmap_sem
+++ a/mm/mempolicy.c
@@ -802,7 +802,6 @@ static long do_set_mempolicy(unsigned sh
 			     nodemask_t *nodes)
 {
 	struct mempolicy *new, *old;
-	struct mm_struct *mm = current->mm;
 	NODEMASK_SCRATCH(scratch);
 	int ret;
 
@@ -814,20 +813,11 @@ static long do_set_mempolicy(unsigned sh
 		ret = PTR_ERR(new);
 		goto out;
 	}
-	/*
-	 * prevent changing our mempolicy while show_numa_maps()
-	 * is using it.
-	 * Note:  do_set_mempolicy() can be called at init time
-	 * with no 'mm'.
-	 */
-	if (mm)
-		down_write(&mm->mmap_sem);
+
 	task_lock(current);
 	ret = mpol_set_nodemask(new, nodes, scratch);
 	if (ret) {
 		task_unlock(current);
-		if (mm)
-			up_write(&mm->mmap_sem);
 		mpol_put(new);
 		goto out;
 	}
@@ -837,9 +827,6 @@ static long do_set_mempolicy(unsigned sh
 	    nodes_weight(new->v.nodes))
 		current->il_next = first_node(new->v.nodes);
 	task_unlock(current);
-	if (mm)
-		up_write(&mm->mmap_sem);
-
 	mpol_put(old);
 	ret = 0;
 out:
_

Patches currently in -mm which might be from oleg@redhat.com are

prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v4.patch
mempolicy-change-alloc_pages_vma-to-use-mpol_cond_put.patch
mempolicy-change-get_task_policy-to-return-default_policy-rather-than-null.patch
mempolicy-sanitize-the-usage-of-get_task_policy.patch
mempolicy-remove-the-task-arg-of-vma_policy_mof-and-simplify-it.patch
mempolicy-introduce-__get_vma_policy-export-get_task_policy.patch
mempolicy-fix-show_numa_map-vs-exec-do_set_mempolicy-race.patch
mempolicy-kill-do_set_mempolicy-down_writemm-mmap_sem.patch
mempolicy-unexport-get_vma_policy-and-remove-its-task-arg.patch
earlyprintk-re-enable-earlyprintk-calling-early_param.patch
fs-proc-task_mmuc-dont-use-task-mm-in-m_start-and-show_map.patch
fs-proc-task_mmuc-unify-simplify-do_maps_open-and-numa_maps_open.patch
proc-introduce-proc_mem_open.patch
fs-proc-task_mmuc-shift-mm_access-from-m_start-to-proc_maps_open.patch
fs-proc-task_mmuc-shift-mm_access-from-m_start-to-proc_maps_open-checkpatch-fixes.patch
fs-proc-task_mmuc-simplify-the-vma_stop-logic.patch
fs-proc-task_mmuc-simplify-the-vma_stop-logic-checkpatch-fixes.patch
fs-proc-task_mmuc-cleanup-the-tail_vma-horror-in-m_next.patch
fs-proc-task_mmuc-shift-priv-task-=-null-from-m_start-to-m_stop.patch
fs-proc-task_mmuc-kill-the-suboptimal-and-confusing-m-version-logic.patch
fs-proc-task_mmuc-simplify-m_start-to-make-it-readable.patch
fs-proc-task_mmuc-introduce-m_next_vma-helper.patch
fs-proc-task_mmuc-reintroduce-m-version-logic.patch
fs-proc-task_mmuc-update-m-version-in-the-main-loop-in-m_start.patch
fs-proc-task_nommuc-change-maps_open-to-use-__seq_open_private.patch
fs-proc-task_nommuc-shift-mm_access-from-m_start-to-proc_maps_open.patch
fs-proc-task_nommuc-shift-mm_access-from-m_start-to-proc_maps_open-checkpatch-fixes.patch
fs-proc-task_nommuc-dont-use-priv-task-mm.patch
proc-maps-replace-proc_maps_private-pid-with-struct-inode-inode.patch
proc-maps-make-vm_is_stack-logic-namespace-friendly.patch
ipc-shm-kill-the-historical-wrong-mm-start_stack-check.patch
linux-next.patch

