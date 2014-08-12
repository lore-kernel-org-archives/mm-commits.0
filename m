From: akpm@linux-foundation.org
Subject: [merged] fork-exec-cleanup-mm-initialization.patch removed from
 -mm tree
Date: Tue, 12 Aug 2014 12:40:18 -0700
Message-ID: <53ea6da2.63XmVjkp7BfhEJ47%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f202.google.com ([209.85.192.202]:44996 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907AbaHLTkT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:40:19 -0400
Received: by mail-pd0-f202.google.com with SMTP id w10so2668825pde.5
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:40:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, oleg@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fork/exec: cleanup mm initialization
has been removed from the -mm tree.  Its filename was
     fork-exec-cleanup-mm-initialization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -374,12 +374,6 @@ static int dup_mmap(struct mm_struct *mm
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
@@ -538,17 +532,27 @@ static void mm_init_aio(struct mm_struct
 
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
@@ -558,11 +562,17 @@ static struct mm_struct *mm_init(struct
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
@@ -596,7 +606,6 @@ struct mm_struct *mm_alloc(void)
 		return NULL;
 
 	memset(mm, 0, sizeof(*mm));
-	mm_init_cpumask(mm);
 	return mm_init(mm, current);
 }
 
@@ -828,17 +837,10 @@ static struct mm_struct *dup_mm(struct t
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
@@ -860,15 +862,6 @@ free_pt:
 
 fail_nomem:
 	return NULL;
