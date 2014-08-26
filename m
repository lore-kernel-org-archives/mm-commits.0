From: akpm@linux-foundation.org
Subject: + ipc-shm-kill-the-historical-wrong-mm-start_stack-check.patch
 added to -mm tree
Date: Tue, 26 Aug 2014 15:29:46 -0700
Message-ID: <53fd0a5a.7t//pXe43L8k1TB3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:59013 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755908AbaHZW3r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Aug 2014 18:29:47 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so4011102pab.5
        for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2014 15:29:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, davidlohr.bueso@hp.com, gorcunov@gmail.com, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/shm: kill the historical/wrong mm->start_stack check
has been added to the -mm tree.  Its filename is
     ipc-shm-kill-the-historical-wrong-mm-start_stack-check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-shm-kill-the-historical-wrong-mm-start_stack-check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-shm-kill-the-historical-wrong-mm-start_stack-check.patch

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
Subject: ipc/shm: kill the historical/wrong mm->start_stack check

do_shmat() is the only user of ->start_stack (proc just reports its
value), and this check looks ugly and wrong.

The reason for this check is not clear at all, and it wrongly assumes that
the stack can only grow down.

But the main problem is that in general mm->start_stack has nothing to do
with stack_vma->vm_start.  Not only the application can switch to another
stack and even unmap this area, setup_arg_pages() expands the stack
without updating mm->start_stack during exec().  This means that in the
likely case "addr > start_stack - size - PAGE_SIZE * 5" is simply
impossible after find_vma_intersection() == F, or the stack can't grow
anyway because of RLIMIT_STACK.

Many thanks to Hugh for his explanations.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |    7 -------
 1 file changed, 7 deletions(-)

diff -puN ipc/shm.c~ipc-shm-kill-the-historical-wrong-mm-start_stack-check ipc/shm.c
--- a/ipc/shm.c~ipc-shm-kill-the-historical-wrong-mm-start_stack-check
+++ a/ipc/shm.c
@@ -1172,13 +1172,6 @@ long do_shmat(int shmid, char __user *sh
 
 		if (find_vma_intersection(current->mm, addr, addr + size))
 			goto invalid;
-		/*
-		 * If shm segment goes below stack, make sure there is some
-		 * space left for the stack to grow (at least 4 pages).
-		 */
-		if (addr < current->mm->start_stack &&
-		    addr > current->mm->start_stack - size - PAGE_SIZE * 5)
-			goto invalid;
 	}
 
 	addr = do_mmap_pgoff(file, addr, size, prot, flags, 0, &populate);
_

Patches currently in -mm which might be from oleg@redhat.com are

prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v4.patch
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
ipc-shm-kill-the-historical-wrong-mm-start_stack-check.patch
linux-next.patch

