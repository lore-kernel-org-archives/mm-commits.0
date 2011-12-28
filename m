From: akpm@linux-foundation.org
Subject: [merged] block-an-exiting-task-should-be-allowed-to-create-io_context.patch removed from -mm tree
Date: Wed, 28 Dec 2011 14:04:57 -0800
Message-ID: <20111228220458.1BFD5200083@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:51712 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612Ab1L1WE7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Dec 2011 17:04:59 -0500
Received: by mail-ey0-f202.google.com with SMTP id k10so176839eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 28 Dec 2011 14:04:59 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, akpm@linux-foundation.org, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: block: an exiting task should be allowed to create io_context
has been removed from the -mm tree.  Its filename was
     block-an-exiting-task-should-be-allowed-to-create-io_context.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: block: an exiting task should be allowed to create io_context

While fixing io_context creation / task exit race condition, 6e736be7f2
"block: make ioc get/put interface more conventional and fix race on
alloction" also prevented an exiting (%PF_EXITING) task from creating its
own io_context.  This is incorrect as exit path may issue IOs, e.g.  from
exit_files(), and if those IOs are the first ones issued by the task,
io_context needs to be created to process the IOs.

Combined with the existing problem of io_context / io_cq creation failure
having the possibility of stalling IO, this problem results in
deterministic full IO lockup with certain workloads.

Fix it by allowing io_context creation regardless of %PF_EXITING for
%current.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-ioc.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN block/blk-ioc.c~block-an-exiting-task-should-be-allowed-to-create-io_context block/blk-ioc.c
--- a/block/blk-ioc.c~block-an-exiting-task-should-be-allowed-to-create-io_context
+++ a/block/blk-ioc.c
@@ -281,9 +281,16 @@ void create_io_context_slowpath(struct t
 	INIT_HLIST_HEAD(&ioc->icq_list);
 	INIT_WORK(&ioc->release_work, ioc_release_fn);
 
-	/* try to install, somebody might already have beaten us to it */
+	/*
+	 * Try to install.  ioc shouldn't be installed if someone else
+	 * already did or @task, which isn't %current, is exiting.  Note
+	 * that we need to allow ioc creation on exiting %current as exit
+	 * path may issue IOs from e.g. exit_files().  The exit path is
+	 * responsible for not issuing IO after exit_io_context().
+	 */
 	task_lock(task);
-	if (!task->io_context && !(task->flags & PF_EXITING))
+	if (!task->io_context &&
+	    (task == current || !(task->flags & PF_EXITING)))
 		task->io_context = ioc;
 	else
 		kmem_cache_free(iocontext_cachep, ioc);
_

Patches currently in -mm which might be from tj@kernel.org are

linux-next.patch
mm-page_alloc-generalize-order-handling-in-__free_pages_bootmem.patch
mm-bootmem-drop-superfluous-range-check-when-freeing-pages-in-bulk.patch
mm-bootmem-try-harder-to-free-pages-in-bulk.patch
mempool-fix-and-document-synchronization-and-memory-barrier-usage.patch
mempool-drop-unnecessary-and-incorrect-bug_on-from-mempool_destroy.patch
mempool-fix-first-round-failure-behavior.patch
mempool-fix-first-round-failure-behavior-fix.patch
procfs-make-proc_get_link-to-use-dentry-instead-of-inode.patch
procfs-introduce-the-proc-pid-map_files-directory.patch
procfs-introduce-the-proc-pid-map_files-directory-make-proc-pid-map_files-being-checkpoint_restore-dependent.patch
workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name.patch
workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-fix.patch
sysctl-add-the-kernelns_last_pid-control.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update.patch
scatterlist-new-helper-functions-update-fix.patch
c-r-introduce-checkpoint_restore-symbol.patch
c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4.patch
c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4-fix.patch
c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries.patch
c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries-fix.patch

