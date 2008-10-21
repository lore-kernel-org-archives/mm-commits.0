From: akpm@linux-foundation.org
Subject: - memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-fix-crash-on-fork.patch removed from -mm tree
Date: Mon, 20 Oct 2008 17:19:28 -0700
Message-ID: <200810210019.m9L0JSbO019695@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43714 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752678AbYJUAT7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 20:19:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: balbir@linux.vnet.ibm.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, rientjes@google.com, skumar@linux.vnet.ibm.com, vgoyal@redhat.com


The patch titled
     Memory rlimit: fix crash on fork
has been removed from the -mm tree.  Its filename was
     memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-fix-crash-on-fork.patch

This patch was dropped because it was folded into memrlimit-add-memrlimit-controller-accounting-and-control.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Memory rlimit: fix crash on fork
From: Balbir Singh <balbir@linux.vnet.ibm.com>

Remove changes from unmap_vmas(), don't call the remaining operations
in exit_mmap() if mm->mmap is NULL.

This patch fixes a crash that occurs when kernbench is set with memrlimit
set to 500M on my x86_64 box. The root cause for the failure is

1. We don't set mm->mmap to NULL for the process for which fork() failed
2. mmput() dereferences vma (in unmap_vmas, vma->vm_mm).

This patch fixes the problem by

1. Initializing mm->mmap to NULL prior to failing dup_mmap()
2. Check early if mm->mmap is NULL in exit_mmap() and return

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Sudhir Kumar <skumar@linux.vnet.ibm.com>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Pavel Emelianov <xemul@openvz.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |   19 ++++++++++---------
 mm/mmap.c     |    9 +++++++++
 2 files changed, 19 insertions(+), 9 deletions(-)

diff -puN kernel/fork.c~memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-fix-crash-on-fork kernel/fork.c
--- a/kernel/fork.c~memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-fix-crash-on-fork
+++ a/kernel/fork.c
@@ -274,15 +274,6 @@ static int dup_mmap(struct mm_struct *mm
 	 */
 	down_write_nested(&mm->mmap_sem, SINGLE_DEPTH_NESTING);
 
-	/*
-	 * Uncharging as a result of failure is done by mmput()
-	 * in dup_mm()
-	 */
-	if (memrlimit_cgroup_charge_as(oldmm, oldmm->total_vm)) {
-		retval = -ENOMEM;
-		goto out;
-	}
-
 	mm->locked_vm = 0;
 	mm->mmap = NULL;
 	mm->mmap_cache = NULL;
@@ -295,6 +286,16 @@ static int dup_mmap(struct mm_struct *mm
 	rb_parent = NULL;
 	pprev = &mm->mmap;
 
+	/*
+	 * Called after mm->mmap is set to NULL, so that the routines
+	 * following this function understand that fork failed (read
+	 * mmput).
+	 */
+	if (memrlimit_cgroup_charge_as(oldmm, oldmm->total_vm)) {
+		retval = -ENOMEM;
+		goto out;
+	}
+
 	for (mpnt = oldmm->mmap; mpnt; mpnt = mpnt->vm_next) {
 		struct file *file;
 
diff -puN mm/mmap.c~memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-fix-crash-on-fork mm/mmap.c
--- a/mm/mmap.c~memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-fix-crash-on-fork
+++ a/mm/mmap.c
@@ -2101,6 +2101,15 @@ void exit_mmap(struct mm_struct *mm)
 		}
 	}
 	vma = mm->mmap;
+
+	/*
+	 * In the case that dup_mm() failed, mm->mmap is NULL and
+	 * we never really setup the mm. We don't have much to do,
+	 * we might as well return early
+	 */
+	if (!vma)
+		return;
+
 	lru_add_drain();
 	flush_cache_mm(mm);
 	tlb = tlb_gather_mmu(mm, 1);
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

origin.patch
linux-next.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-fix-crash-on-fork.patch
memrlimit-add-memrlimit-controller-accounting-and-control-fix-task_lock-recursive-locking-v2.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch

