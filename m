From: akpm@linux-foundation.org
Subject: + mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t.patch added to -mm tree
Date: Wed, 20 Apr 2011 14:12:05 -0700
Message-ID: <201104202112.p3KLC61B027284@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37134 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752651Ab1DTVM0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Apr 2011 17:12:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, cmetcalf@tilera.com, dhowells@redhat.com, hughd@google.com, yasutake.koichi@jp.panasonic.com


The patch titled
     mm: convert mm->cpu_vm_cpumask into cpumask_var_t
has been added to the -mm tree.  Its filename is
     mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t.patch

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
Subject: mm: convert mm->cpu_vm_cpumask into cpumask_var_t
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

cpumask_t is very big struct and cpu_vm_mask is placed wrong position.
It might lead to reduce cache hit ratio.

This patch has two change.
1) Move the place of cpumask into last of mm_struct. Because usually cpumask
   is accessed only front bits when the system has cpu-hotplug capability
2) Convert cpu_vm_mask into cpumask_var_t. It may help to reduce memory
   footprint if cpumask_size() will use nr_cpumask_bits properly in future.

In addition, this patch change the name of cpu_vm_mask with cpu_vm_mask_var.
It may help to detect out of tree cpu_vm_mask users.

This patch has no functional change.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cachetlb.txt |    2 -
 include/linux/mm_types.h   |    9 +++++---
 include/linux/sched.h      |    1 
 init/main.c                |    2 +
 kernel/fork.c              |   37 ++++++++++++++++++++++++++++++++---
 mm/init-mm.c               |    1 
 6 files changed, 44 insertions(+), 8 deletions(-)

diff -puN Documentation/cachetlb.txt~mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t Documentation/cachetlb.txt
--- a/Documentation/cachetlb.txt~mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t
+++ a/Documentation/cachetlb.txt
@@ -16,7 +16,7 @@ on all processors in the system.  Don't 
 thinking SMP cache/tlb flushing must be so inefficient, this is in
 fact an area where many optimizations are possible.  For example,
 if it can be proven that a user address space has never executed
-on a cpu (see vma->cpu_vm_mask), one need not perform a flush
+on a cpu (see mm_cpumask()), one need not perform a flush
 for this address space on that cpu.
 
 First, the TLB flushing interfaces, since they are the simplest.  The
diff -puN include/linux/mm_types.h~mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t
+++ a/include/linux/mm_types.h
@@ -266,8 +266,6 @@ struct mm_struct {
 
 	struct linux_binfmt *binfmt;
 
-	cpumask_t cpu_vm_mask;
-
 	/* Architecture-specific MM context */
 	mm_context_t context;
 
@@ -317,9 +315,14 @@ struct mm_struct {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	pgtable_t pmd_huge_pte; /* protected by page_table_lock */
 #endif
+
+	cpumask_var_t cpu_vm_mask_var;
 };
 
 /* Future-safe accessor for struct mm_struct's cpu_vm_mask. */
-#define mm_cpumask(mm) (&(mm)->cpu_vm_mask)
+static inline cpumask_t* mm_cpumask(struct mm_struct *mm)
+{
+	return mm->cpu_vm_mask_var;
+}
 
 #endif /* _LINUX_MM_TYPES_H */
diff -puN include/linux/sched.h~mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t include/linux/sched.h
--- a/include/linux/sched.h~mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t
+++ a/include/linux/sched.h
@@ -2159,6 +2159,7 @@ static inline void mmdrop(struct mm_stru
 	if (unlikely(atomic_dec_and_test(&mm->mm_count)))
 		__mmdrop(mm);
 }
+extern int mm_init_cpumask(struct mm_struct *mm, struct mm_struct *oldmm);
 
 /* mmput gets rid of the mappings and all user-space */
 extern void mmput(struct mm_struct *);
diff -puN init/main.c~mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t init/main.c
--- a/init/main.c~mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t
+++ a/init/main.c
@@ -509,6 +509,8 @@ asmlinkage void __init start_kernel(void
 	sort_main_extable();
 	trap_init();
 	mm_init();
+	BUG_ON(mm_init_cpumask(&init_mm, 0));
+
 	/*
 	 * Set up the scheduler prior starting any interrupts (such as the
 	 * timer interrupt). Full topology setup happens at smp_init()
diff -puN kernel/fork.c~mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t kernel/fork.c
--- a/kernel/fork.c~mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t
+++ a/kernel/fork.c
@@ -485,6 +485,20 @@ static void mm_init_aio(struct mm_struct
 #endif
 }
 
+int mm_init_cpumask(struct mm_struct *mm, struct mm_struct *oldmm)
+{
+#ifdef CONFIG_CPUMASK_OFFSTACK
+	if (!alloc_cpumask_var(&mm->cpu_vm_mask_var, GFP_KERNEL))
+		return -ENOMEM;
+
+	if (oldmm)
+		cpumask_copy(mm_cpumask(mm), mm_cpumask(oldmm));
+	else
+		memset(mm_cpumask(mm), 0, cpumask_size());
+#endif
+	return 0;
+}
+
 static struct mm_struct * mm_init(struct mm_struct * mm, struct task_struct *p)
 {
 	atomic_set(&mm->mm_users, 1);
@@ -521,10 +535,20 @@ struct mm_struct * mm_alloc(void)
 	struct mm_struct * mm;
 
 	mm = allocate_mm();
-	if (mm) {
-		memset(mm, 0, sizeof(*mm));
-		mm = mm_init(mm, current);
+	if (!mm)
+		return NULL;
+
+	memset(mm, 0, sizeof(*mm));
+	mm = mm_init(mm, current);
+	if (!mm)
+		return NULL;
+
+	if (mm_init_cpumask(mm, NULL)) {
+		mm_free_pgd(mm);
+		free_mm(mm);
+		return NULL;
 	}
+
 	return mm;
 }
 
@@ -536,6 +560,7 @@ struct mm_struct * mm_alloc(void)
 void __mmdrop(struct mm_struct *mm)
 {
 	BUG_ON(mm == &init_mm);
+	free_cpumask_var(mm->cpu_vm_mask_var);
 	mm_free_pgd(mm);
 	destroy_context(mm);
 	mmu_notifier_mm_destroy(mm);
@@ -690,6 +715,9 @@ struct mm_struct *dup_mm(struct task_str
 	if (!mm_init(mm, tsk))
 		goto fail_nomem;
 
+	if (mm_init_cpumask(mm, oldmm))
+		goto fail_nocpumask;
+
 	if (init_new_context(tsk, mm))
 		goto fail_nocontext;
 
@@ -716,6 +744,9 @@ fail_nomem:
 	return NULL;
 
 fail_nocontext:
+	free_cpumask_var(mm->cpu_vm_mask_var);
+
+fail_nocpumask:
 	/*
 	 * If init_new_context() failed, we cannot use mmput() to free the mm
 	 * because it calls destroy_context()
diff -puN mm/init-mm.c~mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t mm/init-mm.c
--- a/mm/init-mm.c~mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t
+++ a/mm/init-mm.c
@@ -21,6 +21,5 @@ struct mm_struct init_mm = {
 	.mmap_sem	= __RWSEM_INITIALIZER(init_mm.mmap_sem),
 	.page_table_lock =  __SPIN_LOCK_UNLOCKED(init_mm.page_table_lock),
 	.mmlist		= LIST_HEAD_INIT(init_mm.mmlist),
-	.cpu_vm_mask	= CPU_MASK_ALL,
 	INIT_MM_CONTEXT(init_mm)
 };
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

mm-per-node-vmstat-show-proper-vmstats.patch
mm-per-node-vmstat-show-proper-vmstats-fix.patch
mm-increase-reclaim_distance-to-30.patch
mm-introduce-wait_on_page_locked_killable.patch
x86mm-make-pagefault-killable.patch
mm-mem-hotplug-fix-section-mismatch-setup_per_zone_inactive_ratio-should-be-__meminit.patch
mm-mem-hotplug-recalculate-lowmem_reserve-when-memory-hotplug-occur.patch
mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur.patch
mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur-fix.patch
mm-convert-vma-vm_flags-to-64-bit.patch
mm-add-__nocast-attribute-to-vm_flags.patch
fremap-convert-vm_flags-to-unsigned-long-long.patch
procfs-convert-vm_flags-to-unsigned-long-long.patch
oom-replace-pf_oom_origin-with-toggling-oom_score_adj.patch
oom-replace-pf_oom_origin-with-toggling-oom_score_adj-update.patch
mm-mmu_gather-rework.patch
powerpc-mmu_gather-rework.patch
sparc-mmu_gather-rework.patch
s390-mmu_gather-rework.patch
arm-mmu_gather-rework.patch
sh-mmu_gather-rework.patch
ia64-mmu_gather-rework.patch
um-mmu_gather-rework.patch
mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage.patch
mm-powerpc-move-the-rcu-page-table-freeing-into-generic-code.patch
mm-extended-batches-for-generic-mmu_gather.patch
lockdep-mutex-provide-mutex_lock_nest_lock.patch
mm-remove-i_mmap_lock-lockbreak.patch
mm-convert-i_mmap_lock-to-a-mutex.patch
mm-revert-page_lock_anon_vma-lock-annotation.patch
mm-improve-page_lock_anon_vma-comment.patch
mm-use-refcounts-for-page_lock_anon_vma.patch
mm-convert-anon_vma-lock-to-a-mutex.patch
mm-optimize-page_lock_anon_vma-fast-path.patch
mn10300-replace-mm-cpu_vm_mask-with-mm_cpumask.patch
tile-replace-mm-cpu_vm_mask-with-mm_cpumask.patch
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
sparse-define-dummy-build_bug_on-definition-for-sparse.patch
sparse-define-__must_be_array-for-__checker__.patch
sparse-undef-__compiletime_warningerror-if-__checker__-is-defined.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-count-the-soft_limit-reclaim-in-global-background-reclaim.patch
memcg-add-stats-to-monitor-soft_limit-reclaim.patch
add-the-pagefault-count-into-memcg-stats.patch
add-the-pagefault-count-into-memcg-stats-fix.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily.patch
kexec-remove-kmsg_dump_kexec.patch
kexec-remove-kmsg_dump_kexec-fix.patch

