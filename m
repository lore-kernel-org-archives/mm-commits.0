From: akpm@linux-foundation.org
Subject: [patch 73/78] mm: add new mmget() helper
Date: Mon, 27 Feb 2017 14:30:10 -0800
Message-ID: <58b4a872.fQLei8cfxeSW9SH7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45690 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751606AbdB0Wp1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 17:45:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, vegard.nossum@oracle.com, mhocko@suse.com, peterz@infradead.org, rientjes@google.com

From: Vegard Nossum <vegard.nossum@oracle.com>
Subject: mm: add new mmget() helper

Apart from adding the helper function itself, the rest of the kernel is
converted mechanically using:

  git grep -l 'atomic_inc.*mm_users' | xargs sed -i 's/atomic_inc(&\(.*\)->mm_users);/mmget\(\1\);/'
  git grep -l 'atomic_inc.*mm_users' | xargs sed -i 's/atomic_inc(&\(.*\)\.mm_users);/mmget\(\&\1\);/'

This is needed for a later patch that hooks into the helper, but might be
a worthwhile cleanup on its own.

(Michal Hocko provided most of the kerneldoc comment.)

Link: http://lkml.kernel.org/r/20161218123229.22952-2-vegard.nossum@oracle.com
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/kernel/smp.c           |    2 +-
 arch/blackfin/mach-common/smp.c |    2 +-
 arch/frv/mm/mmu-context.c       |    2 +-
 arch/metag/kernel/smp.c         |    2 +-
 arch/sh/kernel/smp.c            |    2 +-
 arch/xtensa/kernel/smp.c        |    2 +-
 include/linux/sched.h           |   21 +++++++++++++++++++++
 kernel/fork.c                   |    4 ++--
 mm/swapfile.c                   |   10 +++++-----
 virt/kvm/async_pf.c             |    2 +-
 10 files changed, 35 insertions(+), 14 deletions(-)

diff -puN arch/arc/kernel/smp.c~mm-add-new-mmget-helper arch/arc/kernel/smp.c
--- a/arch/arc/kernel/smp.c~mm-add-new-mmget-helper
+++ a/arch/arc/kernel/smp.c
@@ -139,7 +139,7 @@ void start_kernel_secondary(void)
 	/* MMU, Caches, Vector Table, Interrupts etc */
 	setup_processor();
 
-	atomic_inc(&mm->mm_users);
+	mmget(mm);
 	mmgrab(mm);
 	current->active_mm = mm;
 	cpumask_set_cpu(cpu, mm_cpumask(mm));
diff -puN arch/blackfin/mach-common/smp.c~mm-add-new-mmget-helper arch/blackfin/mach-common/smp.c
--- a/arch/blackfin/mach-common/smp.c~mm-add-new-mmget-helper
+++ a/arch/blackfin/mach-common/smp.c
@@ -307,7 +307,7 @@ void secondary_start_kernel(void)
 	local_irq_disable();
 
 	/* Attach the new idle task to the global mm. */
-	atomic_inc(&mm->mm_users);
+	mmget(mm);
 	mmgrab(mm);
 	current->active_mm = mm;
 
diff -puN arch/frv/mm/mmu-context.c~mm-add-new-mmget-helper arch/frv/mm/mmu-context.c
--- a/arch/frv/mm/mmu-context.c~mm-add-new-mmget-helper
+++ a/arch/frv/mm/mmu-context.c
@@ -188,7 +188,7 @@ int cxn_pin_by_pid(pid_t pid)
 		task_lock(tsk);
 		if (tsk->mm) {
 			mm = tsk->mm;
-			atomic_inc(&mm->mm_users);
+			mmget(mm);
 			ret = 0;
 		}
 		task_unlock(tsk);
diff -puN arch/metag/kernel/smp.c~mm-add-new-mmget-helper arch/metag/kernel/smp.c
--- a/arch/metag/kernel/smp.c~mm-add-new-mmget-helper
+++ a/arch/metag/kernel/smp.c
@@ -344,7 +344,7 @@ asmlinkage void secondary_start_kernel(v
 	 * All kernel threads share the same mm context; grab a
 	 * reference and switch to it.
 	 */
-	atomic_inc(&mm->mm_users);
+	mmget(mm);
 	mmgrab(mm);
 	current->active_mm = mm;
 	cpumask_set_cpu(cpu, mm_cpumask(mm));
diff -puN arch/sh/kernel/smp.c~mm-add-new-mmget-helper arch/sh/kernel/smp.c
--- a/arch/sh/kernel/smp.c~mm-add-new-mmget-helper
+++ a/arch/sh/kernel/smp.c
@@ -179,7 +179,7 @@ asmlinkage void start_secondary(void)
 
 	enable_mmu();
 	mmgrab(mm);
-	atomic_inc(&mm->mm_users);
+	mmget(mm);
 	current->active_mm = mm;
 #ifdef CONFIG_MMU
 	enter_lazy_tlb(mm, current);
diff -puN arch/xtensa/kernel/smp.c~mm-add-new-mmget-helper arch/xtensa/kernel/smp.c
--- a/arch/xtensa/kernel/smp.c~mm-add-new-mmget-helper
+++ a/arch/xtensa/kernel/smp.c
@@ -135,7 +135,7 @@ void secondary_start_kernel(void)
 
 	/* All kernel threads share the same mm context. */
 
-	atomic_inc(&mm->mm_users);
+	mmget(mm);
 	mmgrab(mm);
 	current->active_mm = mm;
 	cpumask_set_cpu(cpu, mm_cpumask(mm));
diff -puN include/linux/sched.h~mm-add-new-mmget-helper include/linux/sched.h
--- a/include/linux/sched.h~mm-add-new-mmget-helper
+++ a/include/linux/sched.h
@@ -2948,6 +2948,27 @@ static inline void mmdrop_async(struct m
 	}
 }
 
+/**
+ * mmget() - Pin the address space associated with a &struct mm_struct.
+ * @mm: The address space to pin.
+ *
+ * Make sure that the address space of the given &struct mm_struct doesn't
+ * go away. This does not protect against parts of the address space being
+ * modified or freed, however.
+ *
+ * Never use this function to pin this address space for an
+ * unbounded/indefinite amount of time.
+ *
+ * Use mmput() to release the reference acquired by mmget().
+ *
+ * See also <Documentation/vm/active_mm.txt> for an in-depth explanation
+ * of &mm_struct.mm_count vs &mm_struct.mm_users.
+ */
+static inline void mmget(struct mm_struct *mm)
+{
+	atomic_inc(&mm->mm_users);
+}
+
 static inline bool mmget_not_zero(struct mm_struct *mm)
 {
 	return atomic_inc_not_zero(&mm->mm_users);
diff -puN kernel/fork.c~mm-add-new-mmget-helper kernel/fork.c
--- a/kernel/fork.c~mm-add-new-mmget-helper
+++ a/kernel/fork.c
@@ -1000,7 +1000,7 @@ struct mm_struct *get_task_mm(struct tas
 		if (task->flags & PF_KTHREAD)
 			mm = NULL;
 		else
-			atomic_inc(&mm->mm_users);
+			mmget(mm);
 	}
 	task_unlock(task);
 	return mm;
@@ -1188,7 +1188,7 @@ static int copy_mm(unsigned long clone_f
 	vmacache_flush(tsk);
 
 	if (clone_flags & CLONE_VM) {
-		atomic_inc(&oldmm->mm_users);
+		mmget(oldmm);
 		mm = oldmm;
 		goto good_mm;
 	}
diff -puN mm/swapfile.c~mm-add-new-mmget-helper mm/swapfile.c
--- a/mm/swapfile.c~mm-add-new-mmget-helper
+++ a/mm/swapfile.c
@@ -1671,7 +1671,7 @@ int try_to_unuse(unsigned int type, bool
 	 * that.
 	 */
 	start_mm = &init_mm;
-	atomic_inc(&init_mm.mm_users);
+	mmget(&init_mm);
 
 	/*
 	 * Keep on scanning until all entries have gone.  Usually,
@@ -1720,7 +1720,7 @@ int try_to_unuse(unsigned int type, bool
 		if (atomic_read(&start_mm->mm_users) == 1) {
 			mmput(start_mm);
 			start_mm = &init_mm;
-			atomic_inc(&init_mm.mm_users);
+			mmget(&init_mm);
 		}
 
 		/*
@@ -1757,8 +1757,8 @@ int try_to_unuse(unsigned int type, bool
 			struct mm_struct *prev_mm = start_mm;
 			struct mm_struct *mm;
 
-			atomic_inc(&new_start_mm->mm_users);
-			atomic_inc(&prev_mm->mm_users);
+			mmget(new_start_mm);
+			mmget(prev_mm);
 			spin_lock(&mmlist_lock);
 			while (swap_count(*swap_map) && !retval &&
 					(p = p->next) != &start_mm->mmlist) {
@@ -1781,7 +1781,7 @@ int try_to_unuse(unsigned int type, bool
 
 				if (set_start_mm && *swap_map < swcount) {
 					mmput(new_start_mm);
-					atomic_inc(&mm->mm_users);
+					mmget(mm);
 					new_start_mm = mm;
 					set_start_mm = 0;
 				}
diff -puN virt/kvm/async_pf.c~mm-add-new-mmget-helper virt/kvm/async_pf.c
--- a/virt/kvm/async_pf.c~mm-add-new-mmget-helper
+++ a/virt/kvm/async_pf.c
@@ -204,7 +204,7 @@ int kvm_setup_async_pf(struct kvm_vcpu *
 	work->addr = hva;
 	work->arch = *arch;
 	work->mm = current->mm;
-	atomic_inc(&work->mm->mm_users);
+	mmget(work->mm);
 	kvm_get_kvm(work->vcpu->kvm);
 
 	/* this can't really happen otherwise gfn_to_pfn_async
_
