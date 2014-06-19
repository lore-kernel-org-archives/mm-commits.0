From: akpm@linux-foundation.org
Subject: + fork-exec-cleanup-mm-initialization.patch added to -mm tree
Date: Thu, 19 Jun 2014 13:59:20 -0700
Message-ID: <53a34f28.09iO57v1WrG5XB9H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51430 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932343AbaFSU7V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Jun 2014 16:59:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, oleg@redhat.com, cl@linux.com, vdavydov@parallels.com


The patch titled
     Subject: fork/exec: cleanup mm initialization
has been added to the -mm tree.  Its filename is
     fork-exec-cleanup-mm-initialization.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fork-exec-cleanup-mm-initialization.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fork-exec-cleanup-mm-initialization.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: fork/exec: cleanup mm initialization

mm initialization on fork/exec is spread all over the place, which makes
the code look inconsistent.

We have mm_init(), which is supposed to init/nullify mm's internals, but
it doesn't init all the fields it should:

 - on fork ->mmap,mm_rb,vmacache_seqnum,map_count,mm_cpumask,locked_vm
   are zeroed in dup_mmap();

 - on fork ->pmd_huge_pte is zeroed in dup_mm(), immediately before
   calling mm_init();

 - ->cpu_vm_mask_var ptr is initialized by mm_init_cpumask(), which is
   called before mm_init() on both fork and exec;

 - ->context is initialized by init_new_context(), which is called after
   mm_init() on both fork and exec;

Let's consolidate all the initializations in mm_init() to make the code
look cleaner.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c                |    4 ---
 include/linux/mm_types.h |    1 
 kernel/fork.c            |   47 +++++++++++++++----------------------
 3 files changed, 21 insertions(+), 31 deletions(-)

diff -puN fs/exec.c~fork-exec-cleanup-mm-initialization fs/exec.c
--- a/fs/exec.c~fork-exec-cleanup-mm-initialization
+++ a/fs/exec.c
@@ -368,10 +368,6 @@ static int bprm_mm_init(struct linux_bin
 	if (!mm)
 		goto err;
 
-	err = init_new_context(current, mm);
-	if (err)
-		goto err;
-
 	err = __bprm_mm_init(bprm);
 	if (err)
 		goto err;
diff -puN include/linux/mm_types.h~fork-exec-cleanup-mm-initialization include/linux/mm_types.h
--- a/include/linux/mm_types.h~fork-exec-cleanup-mm-initialization
+++ a/include/linux/mm_types.h
@@ -461,6 +461,7 @@ static inline void mm_init_cpumask(struc
 #ifdef CONFIG_CPUMASK_OFFSTACK
 	mm->cpu_vm_mask_var = &mm->cpumask_allocation;
 #endif
+	cpumask_clear(mm->cpu_vm_mask_var);
 }
 
 /* Future-safe accessor for struct mm_struct's cpu_vm_mask. */
diff -puN kernel/fork.c~fork-exec-cleanup-mm-initialization kernel/fork.c
--- a/kernel/fork.c~fork-exec-cleanup-mm-initialization
+++ a/kernel/fork.c
@@ -365,12 +365,6 @@ static int dup_mmap(struct mm_struct *mm
 	 */
 	down_write_nested(&mm->mmap_sem, SINGLE_DEPTH_NESTING);
 
-	mm->locked_vm = 0;
-	mm->mmap = NULL;
-	mm->vmacache_seqnum = 0;
-	mm->map_count = 0;
-	cpumask_clear(mm_cpumask(mm));
-	mm->mm_rb = RB_ROOT;
 	rb_link = &mm->mm_rb.rb_node;
 	rb_parent = NULL;
 	pprev = &mm->mmap;
@@ -529,17 +523,27 @@ static void mm_init_aio(struct mm_struct
 
 static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p)
 {
+	mm->mmap = NULL;
+	mm->mm_rb = RB_ROOT;
+	mm->vmacache_seqnum = 0;
 	atomic_set(&mm->mm_users, 1);
 	atomic_set(&mm->mm_count, 1);
 	init_rwsem(&mm->mmap_sem);
 	INIT_LIST_HEAD(&mm->mmlist);
 	mm->core_state = NULL;
 	atomic_long_set(&mm->nr_ptes, 0);
+	mm->map_count = 0;
+	mm->locked_vm = 0;
 	memset(&mm->rss_stat, 0, sizeof(mm->rss_stat));
 	spin_lock_init(&mm->page_table_lock);
+	mm_init_cpumask(mm);
 	mm_init_aio(mm);
 	mm_init_owner(mm, p);
+	mmu_notifier_mm_init(mm);
 	clear_tlb_flush_pending(mm);
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && !USE_SPLIT_PMD_PTLOCKS
+	mm->pmd_huge_pte = NULL;
+#endif
 
 	if (current->mm) {
 		mm->flags = current->mm->flags & MMF_INIT_MASK;
@@ -549,11 +553,17 @@ static struct mm_struct *mm_init(struct
 		mm->def_flags = 0;
 	}
 
-	if (likely(!mm_alloc_pgd(mm))) {
-		mmu_notifier_mm_init(mm);
-		return mm;
-	}
+	if (mm_alloc_pgd(mm))
+		goto fail_nopgd;
+
+	if (init_new_context(p, mm))
+		goto fail_nocontext;
 
+	return mm;
+
+fail_nocontext:
+	mm_free_pgd(mm);
+fail_nopgd:
 	free_mm(mm);
 	return NULL;
 }
@@ -587,7 +597,6 @@ struct mm_struct *mm_alloc(void)
 		return NULL;
 
 	memset(mm, 0, sizeof(*mm));
-	mm_init_cpumask(mm);
 	return mm_init(mm, current);
 }
 
@@ -819,17 +828,10 @@ static struct mm_struct *dup_mm(struct t
 		goto fail_nomem;
 
 	memcpy(mm, oldmm, sizeof(*mm));
-	mm_init_cpumask(mm);
 
-#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && !USE_SPLIT_PMD_PTLOCKS
-	mm->pmd_huge_pte = NULL;
-#endif
 	if (!mm_init(mm, tsk))
 		goto fail_nomem;
 
-	if (init_new_context(tsk, mm))
-		goto fail_nocontext;
-
 	dup_mm_exe_file(oldmm, mm);
 
 	err = dup_mmap(mm, oldmm);
@@ -851,15 +853,6 @@ free_pt:
 
 fail_nomem:
 	return NULL;
-
-fail_nocontext:
-	/*
-	 * If init_new_context() failed, we cannot use mmput() to free the mm
-	 * because it calls destroy_context()
-	 */
-	mm_free_pgd(mm);
-	free_mm(mm);
-	return NULL;
 }
 
 static int copy_mm(unsigned long clone_flags, struct task_struct *tsk)
_

Patches currently in -mm which might be from vdavydov@parallels.com are

slab-fix-oops-when-reading-proc-slab_allocators.patch
slab-fix-oops-when-reading-proc-slab_allocators-v2.patch
memcg-cleanup-memcg_cache_params-refcnt-usage.patch
memcg-destroy-kmem-caches-when-last-slab-is-freed.patch
memcg-mark-caches-that-belong-to-offline-memcgs-as-dead.patch
slub-dont-fail-kmem_cache_shrink-if-slab-placement-optimization-fails.patch
slub-make-slab_free-non-preemptable.patch
memcg-wait-for-kfrees-to-finish-before-destroying-cache.patch
slub-make-dead-memcg-caches-discard-free-slabs-immediately.patch
slab-do-not-keep-free-objects-slabs-on-dead-memcg-caches.patch
mm-memcontrol-fold-mem_cgroup_do_charge.patch
mm-memcontrol-rearrange-charging-fast-path.patch
mm-memcontrol-reclaim-at-least-once-for-__gfp_noretry.patch
mm-huge_memory-use-gfp_transhuge-when-charging-huge-pages.patch
mm-memcontrol-retry-reclaim-for-oom-disabled-and-__gfp_nofail-charges.patch
mm-memcontrol-remove-explicit-oom-parameter-in-charge-path.patch
mm-memcontrol-simplify-move-precharge-function.patch
mm-memcontrol-catch-root-bypass-in-move-precharge.patch
mm-memcontrol-use-root_mem_cgroup-res_counter.patch
mm-memcontrol-remove-ordering-between-pc-mem_cgroup-and-pagecgroupused.patch
mm-memcontrol-do-not-acquire-page_cgroup-lock-for-kmem-pages.patch
mm-memcontrol-rewrite-charge-api.patch
mm-memcontrol-rewrite-uncharge-api.patch
fork-exec-cleanup-mm-initialization.patch
fork-reset-mm-pinned_vm.patch
fork-copy-mms-vm-usage-counters-under-mmap_sem.patch
linux-next.patch

