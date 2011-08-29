From: akpm@linux-foundation.org
Subject: + mm-fix-page-faults-detection-in-swap-token-logic.patch added to -mm tree
Date: Mon, 29 Aug 2011 16:11:27 -0700
Message-ID: <201108292311.p7TNBRsE007332@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47849 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755403Ab1H2XMG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Aug 2011 19:12:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org, riel@redhat.com


The patch titled
     mm: fix page-faults detection in swap-token logic
has been added to the -mm tree.  Its filename is
     mm-fix-page-faults-detection-in-swap-token-logic.patch

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
Subject: mm: fix page-faults detection in swap-token logic
From: Konstantin Khlebnikov <khlebnikov@openvz.org>

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
@@ -331,6 +331,7 @@ struct mm_struct {
 	unsigned int faultstamp;
 	unsigned int token_priority;
 	unsigned int last_interval;
+	atomic_t active_swap_token;
 
 	/* How many tasks sharing this mm are OOM_DISABLE */
 	atomic_t oom_disable_count;
diff -puN include/linux/swap.h~mm-fix-page-faults-detection-in-swap-token-logic include/linux/swap.h
--- a/include/linux/swap.h~mm-fix-page-faults-detection-in-swap-token-logic
+++ a/include/linux/swap.h
@@ -357,6 +357,26 @@ static inline void put_swap_token(struct
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
@@ -482,6 +502,20 @@ static inline int has_swap_token(struct 
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
@@ -764,6 +764,7 @@ struct mm_struct *dup_mm(struct task_str
 	/* Initializing for Swap token stuff */
 	mm->token_priority = 0;
 	mm->last_interval = 0;
+	atomic_set(&mm->active_swap_token, 0);
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	mm->pmd_huge_pte = NULL;
diff -puN mm/memory.c~mm-fix-page-faults-detection-in-swap-token-logic mm/memory.c
--- a/mm/memory.c~mm-fix-page-faults-detection-in-swap-token-logic
+++ a/mm/memory.c
@@ -2861,6 +2861,7 @@ static int do_swap_page(struct mm_struct
 	struct mem_cgroup *ptr;
 	int exclusive = 0;
 	int ret = 0;
+	bool swap_token;
 
 	if (!pte_unmap_same(mm, pmd, page_table, orig_pte))
 		goto out;
@@ -2909,7 +2910,12 @@ static int do_swap_page(struct mm_struct
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
@@ -3156,6 +3162,7 @@ static int __do_fault(struct mm_struct *
 	struct vm_fault vmf;
 	int ret;
 	int page_mkwrite = 0;
+	bool swap_token;
 
 	/*
 	 * If we do COW later, allocate page befor taking lock_page()
@@ -3177,6 +3184,8 @@ static int __do_fault(struct mm_struct *
 	} else
 		cow_page = NULL;
 
+	swap_token = activate_swap_token(mm);
+
 	vmf.virtual_address = (void __user *)(address & PAGE_MASK);
 	vmf.pgoff = pgoff;
 	vmf.flags = flags;
@@ -3245,6 +3254,8 @@ static int __do_fault(struct mm_struct *
 
 	}
 
+	deactivate_swap_token(mm, swap_token);
+
 	page_table = pte_offset_map_lock(mm, pmd, address, &ptl);
 
 	/*
@@ -3316,9 +3327,11 @@ static int __do_fault(struct mm_struct *
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
@@ -715,8 +715,7 @@ int page_referenced_one(struct page *pag
 
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
vmscan-fix-initial-shrinker-size-handling.patch
vmscan-use-atomic-long-for-shrinker-batching.patch
vmscan-use-atomic-long-for-shrinker-batching-fix.patch
vmscan-promote-shared-file-mapped-pages.patch
vmscan-activate-executable-pages-after-first-usage.patch
mm-add-free_hot_cold_page_list-helper.patch
mm-fix-page-faults-detection-in-swap-token-logic.patch

