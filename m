From: akpm@linux-foundation.org
Subject: [merged]
 mempolicy-fix-show_numa_map-vs-exec-do_set_mempolicy-race.patch removed
 from -mm tree
Date: Mon, 13 Oct 2014 11:20:13 -0700
Message-ID: <543c17dd.LCdPqByIist18y93%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60540 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754822AbaJMSUN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:20:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, andi@firstfloor.org, ebiederm@xmission.com, gorcunov@openvz.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kirill.shutemov@linux.intel.com, kosaki.motohiro@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com, peterz@infradead.org, rientjes@google.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mempolicy: fix show_numa_map() vs exec() + do_set_mempolicy() race
has been removed from the -mm tree.  Its filename was
     mempolicy-fix-show_numa_map-vs-exec-do_set_mempolicy-race.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: mempolicy: fix show_numa_map() vs exec() + do_set_mempolicy() race

9e7814404b77 "hold task->mempolicy while numa_maps scans." fixed the
race with the exiting task but this is not enough.

The current code assumes that get_vma_policy(task) should either see
task->mempolicy == NULL or it should be equal to ->task_mempolicy saved
by hold_task_mempolicy(), so we can never race with __mpol_put(). But
this can only work if we can't race with do_set_mempolicy(), and thus
we can't race with another do_set_mempolicy() or do_exit() after that.

However, do_set_mempolicy()->down_write(mmap_sem) can not prevent this
race. This task can exec, change it's ->mm, and call do_set_mempolicy()
after that; in this case they take 2 different locks.

Change hold_task_mempolicy() to use get_task_policy(), it never returns
NULL, and change show_numa_map() to use __get_vma_policy() or fall back
to proc_priv->task_mempolicy.

Note: this is the minimal fix, we will cleanup this code later. I think
hold_task_mempolicy() and release_task_mempolicy() should die, we can
move this logic into show_numa_map(). Or we can move get_task_policy()
outside of ->mmap_sem and !CONFIG_NUMA code at least.

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

 fs/proc/task_mmu.c |   33 +++++++++------------------------
 1 file changed, 9 insertions(+), 24 deletions(-)

diff -puN fs/proc/task_mmu.c~mempolicy-fix-show_numa_map-vs-exec-do_set_mempolicy-race fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mempolicy-fix-show_numa_map-vs-exec-do_set_mempolicy-race
+++ a/fs/proc/task_mmu.c
@@ -87,32 +87,14 @@ unsigned long task_statm(struct mm_struc
 
 #ifdef CONFIG_NUMA
 /*
- * These functions are for numa_maps but called in generic **maps seq_file
- * ->start(), ->stop() ops.
- *
- * numa_maps scans all vmas under mmap_sem and checks their mempolicy.
- * Each mempolicy object is controlled by reference counting. The problem here
- * is how to avoid accessing dead mempolicy object.
- *
- * Because we're holding mmap_sem while reading seq_file, it's safe to access
- * each vma's mempolicy, no vma objects will never drop refs to mempolicy.
- *
- * A task's mempolicy (task->mempolicy) has different behavior. task->mempolicy
- * is set and replaced under mmap_sem but unrefed and cleared under task_lock().
- * So, without task_lock(), we cannot trust get_vma_policy() because we cannot
- * gurantee the task never exits under us. But taking task_lock() around
- * get_vma_plicy() causes lock order problem.
- *
- * To access task->mempolicy without lock, we hold a reference count of an
- * object pointed by task->mempolicy and remember it. This will guarantee
- * that task->mempolicy points to an alive object or NULL in numa_maps accesses.
+ * Save get_task_policy() for show_numa_map().
  */
 static void hold_task_mempolicy(struct proc_maps_private *priv)
 {
 	struct task_struct *task = priv->task;
 
 	task_lock(task);
-	priv->task_mempolicy = task->mempolicy;
+	priv->task_mempolicy = get_task_policy(task);
 	mpol_get(priv->task_mempolicy);
 	task_unlock(task);
 }
@@ -1431,7 +1413,6 @@ static int show_numa_map(struct seq_file
 	struct vm_area_struct *vma = v;
 	struct numa_maps *md = &numa_priv->md;
 	struct file *file = vma->vm_file;
-	struct task_struct *task = proc_priv->task;
 	struct mm_struct *mm = vma->vm_mm;
 	struct mm_walk walk = {};
 	struct mempolicy *pol;
@@ -1451,9 +1432,13 @@ static int show_numa_map(struct seq_file
 	walk.private = md;
 	walk.mm = mm;
 
-	pol = get_vma_policy(task, vma, vma->vm_start);
-	mpol_to_str(buffer, sizeof(buffer), pol);
-	mpol_cond_put(pol);
+	pol = __get_vma_policy(vma, vma->vm_start);
+	if (pol) {
+		mpol_to_str(buffer, sizeof(buffer), pol);
+		mpol_cond_put(pol);
+	} else {
+		mpol_to_str(buffer, sizeof(buffer), proc_priv->task_mempolicy);
+	}
 
 	seq_printf(m, "%08lx %s", vma->vm_start, buffer);
 
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
signal-use-build_bug-instead-of-_nsig_words_is_unsupported_size.patch
signal-use-build_bug-instead-of-_nsig_words_is_unsupported_sizefix.patch
coredump-add-%i-%i-in-core_pattern-to-report-the-tid-of-the-crashed-thread.patch
ipc-shm-kill-the-historical-wrong-mm-start_stack-check.patch
linux-next.patch

