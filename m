From: akpm@linux-foundation.org
Subject: [merged] mm-dedupclicate-memory-overcommitment-code.patch removed from -mm tree
Date: Mon, 21 Mar 2016 11:39:06 -0700
Message-ID: <56f03fca.KzVKc7JlFvygAyKW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53450 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932400AbcCUT4g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:56:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: deduplicate memory overcommitment code
has been removed from the -mm tree.  Its filename was
     mm-dedupclicate-memory-overcommitment-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: mm: deduplicate memory overcommitment code

Currently we have two copies of the same code which implements memory
overcommitment logic.  Let's move it into mm/util.c and hence avoid
duplication.  No functional changes here.

Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c  |  124 ---------------------------------------------------
 mm/nommu.c |  116 -----------------------------------------------
 mm/util.c  |  124 +++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 124 insertions(+), 240 deletions(-)

diff -puN mm/mmap.c~mm-dedupclicate-memory-overcommitment-code mm/mmap.c
--- a/mm/mmap.c~mm-dedupclicate-memory-overcommitment-code
+++ a/mm/mmap.c
@@ -122,130 +122,6 @@ void vma_set_page_prot(struct vm_area_st
 	}
 }
 
-
-int sysctl_overcommit_memory __read_mostly = OVERCOMMIT_GUESS;  /* heuristic overcommit */
-int sysctl_overcommit_ratio __read_mostly = 50;	/* default is 50% */
-unsigned long sysctl_overcommit_kbytes __read_mostly;
-int sysctl_max_map_count __read_mostly = DEFAULT_MAX_MAP_COUNT;
-unsigned long sysctl_user_reserve_kbytes __read_mostly = 1UL << 17; /* 128MB */
-unsigned long sysctl_admin_reserve_kbytes __read_mostly = 1UL << 13; /* 8MB */
-/*
- * Make sure vm_committed_as in one cacheline and not cacheline shared with
- * other variables. It can be updated by several CPUs frequently.
- */
-struct percpu_counter vm_committed_as ____cacheline_aligned_in_smp;
-
-/*
- * The global memory commitment made in the system can be a metric
- * that can be used to drive ballooning decisions when Linux is hosted
- * as a guest. On Hyper-V, the host implements a policy engine for dynamically
- * balancing memory across competing virtual machines that are hosted.
- * Several metrics drive this policy engine including the guest reported
- * memory commitment.
- */
-unsigned long vm_memory_committed(void)
-{
-	return percpu_counter_read_positive(&vm_committed_as);
-}
-EXPORT_SYMBOL_GPL(vm_memory_committed);
-
-/*
- * Check that a process has enough memory to allocate a new virtual
- * mapping. 0 means there is enough memory for the allocation to
- * succeed and -ENOMEM implies there is not.
- *
- * We currently support three overcommit policies, which are set via the
- * vm.overcommit_memory sysctl.  See Documentation/vm/overcommit-accounting
- *
- * Strict overcommit modes added 2002 Feb 26 by Alan Cox.
- * Additional code 2002 Jul 20 by Robert Love.
- *
- * cap_sys_admin is 1 if the process has admin privileges, 0 otherwise.
- *
- * Note this is a helper function intended to be used by LSMs which
- * wish to use this logic.
- */
-int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
-{
-	long free, allowed, reserve;
-
-	VM_WARN_ONCE(percpu_counter_read(&vm_committed_as) <
-			-(s64)vm_committed_as_batch * num_online_cpus(),
-			"memory commitment underflow");
-
-	vm_acct_memory(pages);
-
-	/*
-	 * Sometimes we want to use more memory than we have
-	 */
-	if (sysctl_overcommit_memory == OVERCOMMIT_ALWAYS)
-		return 0;
-
-	if (sysctl_overcommit_memory == OVERCOMMIT_GUESS) {
-		free = global_page_state(NR_FREE_PAGES);
-		free += global_page_state(NR_FILE_PAGES);
-
-		/*
-		 * shmem pages shouldn't be counted as free in this
-		 * case, they can't be purged, only swapped out, and
-		 * that won't affect the overall amount of available
-		 * memory in the system.
-		 */
-		free -= global_page_state(NR_SHMEM);
-
-		free += get_nr_swap_pages();
-
-		/*
-		 * Any slabs which are created with the
-		 * SLAB_RECLAIM_ACCOUNT flag claim to have contents
-		 * which are reclaimable, under pressure.  The dentry
-		 * cache and most inode caches should fall into this
-		 */
-		free += global_page_state(NR_SLAB_RECLAIMABLE);
-
-		/*
-		 * Leave reserved pages. The pages are not for anonymous pages.
-		 */
-		if (free <= totalreserve_pages)
-			goto error;
-		else
-			free -= totalreserve_pages;
-
-		/*
-		 * Reserve some for root
-		 */
-		if (!cap_sys_admin)
-			free -= sysctl_admin_reserve_kbytes >> (PAGE_SHIFT - 10);
-
-		if (free > pages)
-			return 0;
-
-		goto error;
-	}
-
-	allowed = vm_commit_limit();
-	/*
-	 * Reserve some for root
-	 */
-	if (!cap_sys_admin)
-		allowed -= sysctl_admin_reserve_kbytes >> (PAGE_SHIFT - 10);
-
-	/*
-	 * Don't let a single process grow so big a user can't recover
-	 */
-	if (mm) {
-		reserve = sysctl_user_reserve_kbytes >> (PAGE_SHIFT - 10);
-		allowed -= min_t(long, mm->total_vm / 32, reserve);
-	}
-
-	if (percpu_counter_read_positive(&vm_committed_as) < allowed)
-		return 0;
-error:
-	vm_unacct_memory(pages);
-
-	return -ENOMEM;
-}
-
 /*
  * Requires inode->i_mapping->i_mmap_rwsem
  */
diff -puN mm/nommu.c~mm-dedupclicate-memory-overcommitment-code mm/nommu.c
--- a/mm/nommu.c~mm-dedupclicate-memory-overcommitment-code
+++ a/mm/nommu.c
@@ -47,33 +47,11 @@ struct page *mem_map;
 unsigned long max_mapnr;
 EXPORT_SYMBOL(max_mapnr);
 unsigned long highest_memmap_pfn;
-struct percpu_counter vm_committed_as;
-int sysctl_overcommit_memory = OVERCOMMIT_GUESS; /* heuristic overcommit */
-int sysctl_overcommit_ratio = 50; /* default is 50% */
-unsigned long sysctl_overcommit_kbytes __read_mostly;
-int sysctl_max_map_count = DEFAULT_MAX_MAP_COUNT;
 int sysctl_nr_trim_pages = CONFIG_NOMMU_INITIAL_TRIM_EXCESS;
-unsigned long sysctl_user_reserve_kbytes __read_mostly = 1UL << 17; /* 128MB */
-unsigned long sysctl_admin_reserve_kbytes __read_mostly = 1UL << 13; /* 8MB */
 int heap_stack_gap = 0;
 
 atomic_long_t mmap_pages_allocated;
 
-/*
- * The global memory commitment made in the system can be a metric
- * that can be used to drive ballooning decisions when Linux is hosted
- * as a guest. On Hyper-V, the host implements a policy engine for dynamically
- * balancing memory across competing virtual machines that are hosted.
- * Several metrics drive this policy engine including the guest reported
- * memory commitment.
- */
-unsigned long vm_memory_committed(void)
-{
-	return percpu_counter_read_positive(&vm_committed_as);
-}
-
-EXPORT_SYMBOL_GPL(vm_memory_committed);
-
 EXPORT_SYMBOL(mem_map);
 
 /* list of mapped, potentially shareable regions */
@@ -1828,100 +1806,6 @@ void unmap_mapping_range(struct address_
 }
 EXPORT_SYMBOL(unmap_mapping_range);
 
-/*
- * Check that a process has enough memory to allocate a new virtual
- * mapping. 0 means there is enough memory for the allocation to
- * succeed and -ENOMEM implies there is not.
- *
- * We currently support three overcommit policies, which are set via the
- * vm.overcommit_memory sysctl.  See Documentation/vm/overcommit-accounting
- *
- * Strict overcommit modes added 2002 Feb 26 by Alan Cox.
- * Additional code 2002 Jul 20 by Robert Love.
- *
- * cap_sys_admin is 1 if the process has admin privileges, 0 otherwise.
- *
- * Note this is a helper function intended to be used by LSMs which
- * wish to use this logic.
- */
-int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
-{
-	long free, allowed, reserve;
-
-	vm_acct_memory(pages);
-
-	/*
-	 * Sometimes we want to use more memory than we have
-	 */
-	if (sysctl_overcommit_memory == OVERCOMMIT_ALWAYS)
-		return 0;
-
-	if (sysctl_overcommit_memory == OVERCOMMIT_GUESS) {
-		free = global_page_state(NR_FREE_PAGES);
-		free += global_page_state(NR_FILE_PAGES);
-
-		/*
-		 * shmem pages shouldn't be counted as free in this
-		 * case, they can't be purged, only swapped out, and
-		 * that won't affect the overall amount of available
-		 * memory in the system.
-		 */
-		free -= global_page_state(NR_SHMEM);
-
-		free += get_nr_swap_pages();
-
-		/*
-		 * Any slabs which are created with the
-		 * SLAB_RECLAIM_ACCOUNT flag claim to have contents
-		 * which are reclaimable, under pressure.  The dentry
-		 * cache and most inode caches should fall into this
-		 */
-		free += global_page_state(NR_SLAB_RECLAIMABLE);
-
-		/*
-		 * Leave reserved pages. The pages are not for anonymous pages.
-		 */
-		if (free <= totalreserve_pages)
-			goto error;
-		else
-			free -= totalreserve_pages;
-
-		/*
-		 * Reserve some for root
-		 */
-		if (!cap_sys_admin)
-			free -= sysctl_admin_reserve_kbytes >> (PAGE_SHIFT - 10);
-
-		if (free > pages)
-			return 0;
-
-		goto error;
-	}
-
-	allowed = vm_commit_limit();
-	/*
-	 * Reserve some 3% for root
-	 */
-	if (!cap_sys_admin)
-		allowed -= sysctl_admin_reserve_kbytes >> (PAGE_SHIFT - 10);
-
-	/*
-	 * Don't let a single process grow so big a user can't recover
-	 */
-	if (mm) {
-		reserve = sysctl_user_reserve_kbytes >> (PAGE_SHIFT - 10);
-		allowed -= min_t(long, mm->total_vm / 32, reserve);
-	}
-
-	if (percpu_counter_read_positive(&vm_committed_as) < allowed)
-		return 0;
-
-error:
-	vm_unacct_memory(pages);
-
-	return -ENOMEM;
-}
-
 int filemap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	BUG();
diff -puN mm/util.c~mm-dedupclicate-memory-overcommitment-code mm/util.c
--- a/mm/util.c~mm-dedupclicate-memory-overcommitment-code
+++ a/mm/util.c
@@ -396,6 +396,13 @@ int __page_mapcount(struct page *page)
 }
 EXPORT_SYMBOL_GPL(__page_mapcount);
 
+int sysctl_overcommit_memory __read_mostly = OVERCOMMIT_GUESS;
+int sysctl_overcommit_ratio __read_mostly = 50;
+unsigned long sysctl_overcommit_kbytes __read_mostly;
+int sysctl_max_map_count __read_mostly = DEFAULT_MAX_MAP_COUNT;
+unsigned long sysctl_user_reserve_kbytes __read_mostly = 1UL << 17; /* 128MB */
+unsigned long sysctl_admin_reserve_kbytes __read_mostly = 1UL << 13; /* 8MB */
+
 int overcommit_ratio_handler(struct ctl_table *table, int write,
 			     void __user *buffer, size_t *lenp,
 			     loff_t *ppos)
@@ -437,6 +444,123 @@ unsigned long vm_commit_limit(void)
 	return allowed;
 }
 
+/*
+ * Make sure vm_committed_as in one cacheline and not cacheline shared with
+ * other variables. It can be updated by several CPUs frequently.
+ */
+struct percpu_counter vm_committed_as ____cacheline_aligned_in_smp;
+
+/*
+ * The global memory commitment made in the system can be a metric
+ * that can be used to drive ballooning decisions when Linux is hosted
+ * as a guest. On Hyper-V, the host implements a policy engine for dynamically
+ * balancing memory across competing virtual machines that are hosted.
+ * Several metrics drive this policy engine including the guest reported
+ * memory commitment.
+ */
+unsigned long vm_memory_committed(void)
+{
+	return percpu_counter_read_positive(&vm_committed_as);
+}
+EXPORT_SYMBOL_GPL(vm_memory_committed);
+
+/*
+ * Check that a process has enough memory to allocate a new virtual
+ * mapping. 0 means there is enough memory for the allocation to
+ * succeed and -ENOMEM implies there is not.
+ *
+ * We currently support three overcommit policies, which are set via the
+ * vm.overcommit_memory sysctl.  See Documentation/vm/overcommit-accounting
+ *
+ * Strict overcommit modes added 2002 Feb 26 by Alan Cox.
+ * Additional code 2002 Jul 20 by Robert Love.
+ *
+ * cap_sys_admin is 1 if the process has admin privileges, 0 otherwise.
+ *
+ * Note this is a helper function intended to be used by LSMs which
+ * wish to use this logic.
+ */
+int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
+{
+	long free, allowed, reserve;
+
+	VM_WARN_ONCE(percpu_counter_read(&vm_committed_as) <
+			-(s64)vm_committed_as_batch * num_online_cpus(),
+			"memory commitment underflow");
+
+	vm_acct_memory(pages);
+
+	/*
+	 * Sometimes we want to use more memory than we have
+	 */
+	if (sysctl_overcommit_memory == OVERCOMMIT_ALWAYS)
+		return 0;
+
+	if (sysctl_overcommit_memory == OVERCOMMIT_GUESS) {
+		free = global_page_state(NR_FREE_PAGES);
+		free += global_page_state(NR_FILE_PAGES);
+
+		/*
+		 * shmem pages shouldn't be counted as free in this
+		 * case, they can't be purged, only swapped out, and
+		 * that won't affect the overall amount of available
+		 * memory in the system.
+		 */
+		free -= global_page_state(NR_SHMEM);
+
+		free += get_nr_swap_pages();
+
+		/*
+		 * Any slabs which are created with the
+		 * SLAB_RECLAIM_ACCOUNT flag claim to have contents
+		 * which are reclaimable, under pressure.  The dentry
+		 * cache and most inode caches should fall into this
+		 */
+		free += global_page_state(NR_SLAB_RECLAIMABLE);
+
+		/*
+		 * Leave reserved pages. The pages are not for anonymous pages.
+		 */
+		if (free <= totalreserve_pages)
+			goto error;
+		else
+			free -= totalreserve_pages;
+
+		/*
+		 * Reserve some for root
+		 */
+		if (!cap_sys_admin)
+			free -= sysctl_admin_reserve_kbytes >> (PAGE_SHIFT - 10);
+
+		if (free > pages)
+			return 0;
+
+		goto error;
+	}
+
+	allowed = vm_commit_limit();
+	/*
+	 * Reserve some for root
+	 */
+	if (!cap_sys_admin)
+		allowed -= sysctl_admin_reserve_kbytes >> (PAGE_SHIFT - 10);
+
+	/*
+	 * Don't let a single process grow so big a user can't recover
+	 */
+	if (mm) {
+		reserve = sysctl_user_reserve_kbytes >> (PAGE_SHIFT - 10);
+		allowed -= min_t(long, mm->total_vm / 32, reserve);
+	}
+
+	if (percpu_counter_read_positive(&vm_committed_as) < allowed)
+		return 0;
+error:
+	vm_unacct_memory(pages);
+
+	return -ENOMEM;
+}
+
 /**
  * get_cmdline() - copy the cmdline value to a buffer.
  * @task:     the task whose cmdline value to copy.
_

Patches currently in -mm which might be from aryabinin@virtuozzo.com are

ubsan-fix-tree-wide-wmaybe-uninitialized-false-positives.patch

