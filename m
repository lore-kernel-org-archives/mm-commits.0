From: akpm@linux-foundation.org
Subject: [folded] mm-fix-page-faults-detection-in-swap-token-logic.patch removed from -mm tree
Date: Tue, 10 Apr 2012 12:30:04 -0700
Message-ID: <20120410193004.ECF39A03B2@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:44592 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755934Ab2DJTaH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Apr 2012 15:30:07 -0400
Received: by faaa19 with SMTP id a19so13175faa.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Apr 2012 12:30:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@openvz.org, hannes@cmpxchg.org, hughd@google.com, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix page-faults detection in swap-token logic
has been removed from the -mm tree.  Its filename was
     mm-fix-page-faults-detection-in-swap-token-logic.patch

This patch was dropped because it was folded into remove-swap-token-code.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: mm: fix page-faults detection in swap-token logic

After commit v2.6.36-5896-gd065bd8 "mm: retry page fault when blocking on
disk transfer" we usually wait in page-faults without mmap_sem held, so
all swap-token logic was broken, because it based on using
rwsem_is_locked(&mm->mmap_sem) as sign of in progress page-faults.

Add an atomic counter of in progress page-faults for mm to the mm_struct
with swap-token.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    1 +
 include/linux/swap.h     |   34 ++++++++++++++++++++++++++++++++++
 kernel/fork.c            |    1 +
 mm/memory.c              |   13 +++++++++++++
 mm/rmap.c                |    3 +--
 5 files changed, 50 insertions(+), 2 deletions(-)

diff -puN include/linux/mm_types.h~mm-fix-page-faults-detection-in-swap-token-logic include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-fix-page-faults-detection-in-swap-token-logic
+++ a/include/linux/mm_types.h
@@ -355,6 +355,7 @@ struct mm_struct {
 	unsigned int faultstamp;
 	unsigned int token_priority;
 	unsigned int last_interval;
+	atomic_t active_swap_token;
 
 	unsigned long flags; /* Must use atomic bitops to access the bits */
 
diff -puN include/linux/swap.h~mm-fix-page-faults-detection-in-swap-token-logic include/linux/swap.h
--- a/include/linux/swap.h~mm-fix-page-faults-detection-in-swap-token-logic
+++ a/include/linux/swap.h
@@ -369,6 +369,26 @@ static inline void put_swap_token(struct
 		__put_swap_token(mm);
 }
 
+static inline bool has_active_swap_token(struct mm_struct *mm)
+{
+	return has_swap_token(mm) && atomic_read(&mm->active_swap_token);
+}
+
+static inline bool activate_swap_token(struct mm_struct *mm)
+{
+	if (has_swap_token(mm)) {
+		atomic_inc(&mm->active_swap_token);
+		return true;
+	}
+	return false;
+}
+
+static inline void deactivate_swap_token(struct mm_struct *mm, bool swap_token)
+{
+	if (swap_token)
+		atomic_dec(&mm->active_swap_token);
+}
+
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
 extern void
 mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent, bool swapout);
@@ -494,6 +514,20 @@ static inline int has_swap_token(struct 
 	return 0;
 }
 
+static inline bool has_active_swap_token(struct mm_struct *mm)
+{
+	return false;
+}
+
+static inline bool activate_swap_token(struct mm_struct *mm)
+{
+	return false;
+}
+
+static inline void deactivate_swap_token(struct mm_struct *mm, bool swap_token)
+{
+}
+
 static inline void disable_swap_token(struct mem_cgroup *memcg)
 {
 }
diff -puN kernel/fork.c~mm-fix-page-faults-detection-in-swap-token-logic kernel/fork.c
--- a/kernel/fork.c~mm-fix-page-faults-detection-in-swap-token-logic
+++ a/kernel/fork.c
@@ -804,6 +804,7 @@ struct mm_struct *dup_mm(struct task_str
 	/* Initializing for Swap token stuff */
 	mm->token_priority = 0;
 	mm->last_interval = 0;
+	atomic_set(&mm->active_swap_token, 0);
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	mm->pmd_huge_pte = NULL;
diff -puN mm/memory.c~mm-fix-page-faults-detection-in-swap-token-logic mm/memory.c
--- a/mm/memory.c~mm-fix-page-faults-detection-in-swap-token-logic
+++ a/mm/memory.c
@@ -2892,6 +2892,7 @@ static int do_swap_page(struct mm_struct
 	struct mem_cgroup *ptr;
 	int exclusive = 0;
 	int ret = 0;
+	bool swap_token;
 
 	if (!pte_unmap_same(mm, pmd, page_table, orig_pte))
 		goto out;
@@ -2940,7 +2941,12 @@ static int do_swap_page(struct mm_struct
 		goto out_release;
 	}
 
+	swap_token = activate_swap_token(mm);
+
 	locked = lock_page_or_retry(page, mm, flags);
+
+	deactivate_swap_token(mm, swap_token);
+
 	delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
 	if (!locked) {
 		ret |= VM_FAULT_RETRY;
@@ -3187,6 +3193,7 @@ static int __do_fault(struct mm_struct *
 	struct vm_fault vmf;
 	int ret;
 	int page_mkwrite = 0;
+	bool swap_token;
 
 	/*
 	 * If we do COW later, allocate page befor taking lock_page()
@@ -3208,6 +3215,8 @@ static int __do_fault(struct mm_struct *
 	} else
 		cow_page = NULL;
 
+	swap_token = activate_swap_token(mm);
+
 	vmf.virtual_address = (void __user *)(address & PAGE_MASK);
 	vmf.pgoff = pgoff;
 	vmf.flags = flags;
@@ -3276,6 +3285,8 @@ static int __do_fault(struct mm_struct *
 
 	}
 
+	deactivate_swap_token(mm, swap_token);
+
 	page_table = pte_offset_map_lock(mm, pmd, address, &ptl);
 
 	/*
@@ -3347,9 +3358,11 @@ static int __do_fault(struct mm_struct *
 	return ret;
 
 unwritable_page:
+	deactivate_swap_token(mm, swap_token);
 	page_cache_release(page);
 	return ret;
 uncharge_out:
+	deactivate_swap_token(mm, swap_token);
 	/* fs's fault handler get error */
 	if (cow_page) {
 		mem_cgroup_uncharge_page(cow_page);
diff -puN mm/rmap.c~mm-fix-page-faults-detection-in-swap-token-logic mm/rmap.c
--- a/mm/rmap.c~mm-fix-page-faults-detection-in-swap-token-logic
+++ a/mm/rmap.c
@@ -757,8 +757,7 @@ int page_referenced_one(struct page *pag
 
 	/* Pretend the page is referenced if the task has the
 	   swap token and is in the middle of a page fault. */
-	if (mm != current->mm && has_swap_token(mm) &&
-			rwsem_is_locked(&mm->mmap_sem))
+	if (mm != current->mm && has_active_swap_token(mm))
 		referenced++;
 
 	(*mapcount)--;
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

linux-next.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
mm-correctly-synchronize-rss-counters-at-exit-exec-fix.patch
mm-vmscan-remove-lumpy-reclaim.patch
mm-vmscan-remove-reclaim_mode_t.patch
remove-swap-token-code.patch
mm-memcg-scanning_global_lru-means-mem_cgroup_disabled.patch
mm-memcg-move-reclaim_stat-into-lruvec.patch
mm-push-lru-index-into-shrink_active_list.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
mm-mark-mm-inline-functions-as-__always_inline.patch
mm-remove-lru-type-checks-from-__isolate_lru_page.patch
mm-memcg-kill-mem_cgroup_lru_del.patch
mm-memcg-use-vm_swappiness-from-target-memory-cgroup.patch

