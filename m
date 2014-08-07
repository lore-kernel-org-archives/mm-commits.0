From: akpm@linux-foundation.org
Subject: [merged] mm-oom-remove-unnecessary-exit_state-check.patch removed from -mm tree
Date: Thu, 07 Aug 2014 13:06:23 -0700
Message-ID: <53e3dc3f.20RYUrNqTRKfxslG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:62661 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbaHGUGY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:06:24 -0400
Received: by mail-ob0-f201.google.com with SMTP id nu7so839506obb.4
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:06:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: remove unnecessary exit_state check
has been removed from the -mm tree.  Its filename was
     mm-oom-remove-unnecessary-exit_state-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, oom: remove unnecessary exit_state check

The oom killer scans each process and determines whether it is eligible for oom
kill or whether the oom killer should abort because of concurrent memory
freeing.  It will abort when an eligible process is found to have TIF_MEMDIE
set, meaning it has already been oom killed and we're waiting for it to exit.

Processes with task->mm == NULL should not be considered because they are either
kthreads or have already detached their memory and killing them would not lead
to memory freeing.  That memory is only freed after exit_mm() has returned,
however, and not when task->mm is first set to NULL.

Clear TIF_MEMDIE after exit_mm()'s mmput() so that an oom killed process is no
longer considered for oom kill, but only until exit_mm() has returned.  This was
fragile in the past because it relied on exit_notify() to be reached before no
longer considering TIF_MEMDIE processes.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    1 +
 mm/oom_kill.c |    2 --
 2 files changed, 1 insertion(+), 2 deletions(-)

diff -puN kernel/exit.c~mm-oom-remove-unnecessary-exit_state-check kernel/exit.c
--- a/kernel/exit.c~mm-oom-remove-unnecessary-exit_state-check
+++ a/kernel/exit.c
@@ -455,6 +455,7 @@ static void exit_mm(struct task_struct *
 	task_unlock(tsk);
 	mm_update_next_owner(mm);
 	mmput(mm);
+	clear_thread_flag(TIF_MEMDIE);
 }
 
 /*
diff -puN mm/oom_kill.c~mm-oom-remove-unnecessary-exit_state-check mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-remove-unnecessary-exit_state-check
+++ a/mm/oom_kill.c
@@ -258,8 +258,6 @@ enum oom_scan_t oom_scan_process_thread(
 		unsigned long totalpages, const nodemask_t *nodemask,
 		bool force_kill)
 {
-	if (task->exit_state)
-		return OOM_SCAN_CONTINUE;
 	if (oom_unkillable_task(task, NULL, nodemask))
 		return OOM_SCAN_CONTINUE;
 
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
x86-numa-setup_node_data-drop-dead-code-and-rename-function.patch
x86-numa-setup_node_data-drop-dead-code-and-rename-function-v2.patch
mm-hugetlb-take-refcount-under-page-table-lock-in-follow_huge_pmd.patch
mm-hugetlb-use-get_page_unless_zero-in-hugetlb_fault.patch
mm-hugetlb-add-migration-entry-check-in-hugetlb_change_protection.patch
mm-hugetlb-remove-unused-argument-of-follow_huge_pmdpud.patch
include-kernelh-rewrite-min3-max3-and-clamp-using-min-and-max.patch
mm-utilc-add-kstrimdup.patch
fs-proc-kcorec-use-page_align-instead-of-alignpage_size.patch
fork-exec-cleanup-mm-initialization.patch
fork-reset-mm-pinned_vm.patch
fork-copy-mms-vm-usage-counters-under-mmap_sem.patch
linux-next.patch

