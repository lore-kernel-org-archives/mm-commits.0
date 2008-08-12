From: akpm@linux-foundation.org
Subject: + memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-fix-crash-on-fork.patch added to -mm tree
Date: Mon, 11 Aug 2008 17:33:53 -0700
Message-ID: <200808120033.m7C0XrOu030384@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39651 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751966AbYHLAee (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Aug 2008 20:34:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balbir@linux.vnet.ibm.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, rientjes@google.com, skumar@linux.vnet.ibm.com, vgoyal@redhat.com, xemul@openvz.org, yamamoto@valinux.co.jp


The patch titled
     Memory rlimit: fix crash on fork
has been added to the -mm tree.  Its filename is
     memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-fix-crash-on-fork.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Memory rlimit: fix crash on fork
From: Balbir Singh <balbir@linux.vnet.ibm.com>

This patch fixes a crash that occurs when kernbench is set with memrlimit
set to 500M on my x86_64 box.  The root cause for the failure is

1. We don't set mm->mmap to NULL for the process for which fork() failed
2. mmput() dereferences vma (in unmap_vmas, vma->vm_mm).

This patch fixes the problem by

1. Initializing mm->mmap to NULL prior to failing dup_mmap()
2. unmap_vmas() check if mm->mmap is NULL (vma is NULL)
3. Don't uncharge when do_fork() fails in exit_mmap()

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
 mm/memory.c   |    6 +++++-
 mm/mmap.c     |    6 +++++-
 3 files changed, 20 insertions(+), 11 deletions(-)

diff -puN kernel/fork.c~memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-fix-crash-on-fork kernel/fork.c
--- a/kernel/fork.c~memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-fix-crash-on-fork
+++ a/kernel/fork.c
@@ -273,15 +273,6 @@ static int dup_mmap(struct mm_struct *mm
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
@@ -294,6 +285,16 @@ static int dup_mmap(struct mm_struct *mm
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
 
diff -puN mm/memory.c~memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-fix-crash-on-fork mm/memory.c
--- a/mm/memory.c~memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-fix-crash-on-fork
+++ a/mm/memory.c
@@ -901,8 +901,12 @@ unsigned long unmap_vmas(struct mmu_gath
 	unsigned long start = start_addr;
 	spinlock_t *i_mmap_lock = details? details->i_mmap_lock: NULL;
 	int fullmm = (*tlbp)->fullmm;
-	struct mm_struct *mm = vma->vm_mm;
+	struct mm_struct *mm;
+
+	if (!vma)
+		return;
 
+	mm = vma->vm_mm;
 	mmu_notifier_invalidate_range_start(mm, start_addr, end_addr);
 	for ( ; vma && vma->vm_start < end_addr; vma = vma->vm_next) {
 		unsigned long end;
diff -puN mm/mmap.c~memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-fix-crash-on-fork mm/mmap.c
--- a/mm/mmap.c~memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-fix-crash-on-fork
+++ a/mm/mmap.c
@@ -2086,6 +2086,7 @@ void exit_mmap(struct mm_struct *mm)
 	struct vm_area_struct *vma;
 	unsigned long nr_accounted = 0;
 	unsigned long end;
+	bool uncharge_as = true;
 
 	/* mm's last user has gone, and its about to be pulled down */
 	arch_exit_mmap(mm);
@@ -2100,6 +2101,8 @@ void exit_mmap(struct mm_struct *mm)
 		}
 	}
 	vma = mm->mmap;
+	if (!vma)
+		uncharge_as = false;
 	lru_add_drain();
 	flush_cache_mm(mm);
 	tlb = tlb_gather_mmu(mm, 1);
@@ -2107,7 +2110,8 @@ void exit_mmap(struct mm_struct *mm)
 	/* Use -1 here to ensure all VMAs in the mm are unmapped */
 	end = unmap_vmas(&tlb, vma, 0, -1, &nr_accounted, NULL);
 	vm_unacct_memory(nr_accounted);
-	memrlimit_cgroup_uncharge_as(mm, mm->total_vm);
+	if (uncharge_as)
+		memrlimit_cgroup_uncharge_as(mm, mm->total_vm);
 	free_pgtables(tlb, vma, FIRST_USER_ADDRESS, 0);
 	tlb_finish_mmu(tlb, 0, end);
 
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

memcg-fix-oops-in-mem_cgroup_shrink_usage.patch
linux-next.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-fix-crash-on-fork.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
mm-owner-fix-race-between-swap-and-exit.patch
memory-rlimit-enhance-mm_owner_changed-callback-to-deal-with-exited-owner.patch
gcov-architecture-specific-compile-flag-adjustments-x86_64-fix.patch

