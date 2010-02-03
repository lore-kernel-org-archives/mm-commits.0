From: akpm@linux-foundation.org
Subject: [obsolete] mm-count-lowmem-rss.patch removed from -mm tree
Date: Wed, 03 Feb 2010 15:22:33 -0800
Message-ID: <201002032322.o13NMXqP025691@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57879 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757652Ab0BCXWn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 18:22:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, cl@linux-foundation.org, lee.schermerhorn@hp.com, minchan.kim@gmail.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     mm: count lowmem rss
has been removed from the -mm tree.  Its filename was
     mm-count-lowmem-rss.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: count lowmem rss
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Some case of OOM-Kill are caused by memory shortage in lowmem area.  For
example, NORMAL_ZONE is exhausted on x86-32/HIGHMEM kernel.

Presently, oom-killer doesn't have lowmem usage information of processes
and selects victim processes based on global memory usage information.  In
bad case, this can cause chains of kills of innocent processes without
progress, oom-serial-killer.

For making oom-killer lowmem aware, this patch adds counters for
accounting lowmem usage per process.  (patches for oom-killer is not
included in this.)

Adding counter is easy but one of concern is the cost for new counter. 
But this patch doesn't adds # of counting cost but adds an "if" statement
to check if a page is lowmem.  With micro benchmark, almost no regression.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c       |    4 -
 include/linux/mm.h       |   27 ++++++++++--
 include/linux/mm_types.h |    7 ++-
 mm/filemap_xip.c         |    2 
 mm/fremap.c              |    2 
 mm/memory.c              |   81 ++++++++++++++++++++++++++++---------
 mm/oom_kill.c            |    8 ++-
 mm/rmap.c                |   10 ++--
 mm/swapfile.c            |    2 
 9 files changed, 106 insertions(+), 37 deletions(-)

diff -puN fs/proc/task_mmu.c~mm-count-lowmem-rss fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-count-lowmem-rss
+++ a/fs/proc/task_mmu.c
@@ -68,11 +68,11 @@ unsigned long task_vsize(struct mm_struc
 int task_statm(struct mm_struct *mm, int *shared, int *text,
 	       int *data, int *resident)
 {
-	*shared = get_mm_counter(mm, MM_FILEPAGES);
+	*shared = get_file_rss(mm);
 	*text = (PAGE_ALIGN(mm->end_code) - (mm->start_code & PAGE_MASK))
 								>> PAGE_SHIFT;
 	*data = mm->total_vm - mm->shared_vm;
-	*resident = *shared + get_mm_counter(mm, MM_ANONPAGES);
+	*resident = *shared + get_anon_rss(mm);
 	return mm->total_vm;
 }
 
diff -puN include/linux/mm.h~mm-count-lowmem-rss include/linux/mm.h
--- a/include/linux/mm.h~mm-count-lowmem-rss
+++ a/include/linux/mm.h
@@ -938,11 +938,10 @@ static inline void dec_mm_counter(struct
 
 #endif /* !USE_SPLIT_PTLOCKS */
 
-static inline unsigned long get_mm_rss(struct mm_struct *mm)
-{
-	return get_mm_counter(mm, MM_FILEPAGES) +
-		get_mm_counter(mm, MM_ANONPAGES);
-}
+unsigned long get_mm_rss(struct mm_struct *mm);
+unsigned long get_file_rss(struct mm_struct *mm);
+unsigned long get_anon_rss(struct mm_struct *mm);
+unsigned long get_low_rss(struct mm_struct *mm);
 
 static inline unsigned long get_mm_hiwater_rss(struct mm_struct *mm)
 {
@@ -977,6 +976,23 @@ static inline void setmax_mm_hiwater_rss
 		*maxrss = hiwater_rss;
 }
 
+/* Utility for lowmem counting */
+static inline void
+inc_mm_counter_page(struct mm_struct *mm, int member, struct page *page)
+{
+	if (unlikely(is_lowmem_page(page)))
+		member += LOWMEM_COUNTER;
+	inc_mm_counter(mm, member);
+}
+
+static inline void
+dec_mm_counter_page(struct mm_struct *mm, int member, struct page *page)
+{
+	if (unlikely(is_lowmem_page(page)))
+		member += LOWMEM_COUNTER;
+	dec_mm_counter(mm, member);
+}
+
 void sync_mm_rss(struct task_struct *task, struct mm_struct *mm);
 
 /*
@@ -1033,6 +1049,7 @@ int __pmd_alloc(struct mm_struct *mm, pu
 int __pte_alloc(struct mm_struct *mm, pmd_t *pmd, unsigned long address);
 int __pte_alloc_kernel(pmd_t *pmd, unsigned long address);
 
+
 /*
  * The following ifdef needed to get the 4level-fixup.h header to work.
  * Remove it when 4level-fixup.h has been removed.
diff -puN include/linux/mm_types.h~mm-count-lowmem-rss include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-count-lowmem-rss
+++ a/include/linux/mm_types.h
@@ -194,11 +194,14 @@ struct core_state {
 };
 
 enum {
-	MM_FILEPAGES,
-	MM_ANONPAGES,
+	MM_FILEPAGES,	/* file's rss is MM_FILEPAGES + MM_LOW_FILEPAGES */
+	MM_ANONPAGES,   /* anon`'s rss is MM_FILEPAGES + MM_LOW_FILEPAGES */
+	MM_FILE_LOWPAGES, /* pages from lower zones in file rss*/
+	MM_ANON_LOWPAGES, /* pages from lower zones in anon rss*/
 	MM_SWAPENTS,
 	NR_MM_COUNTERS
 };
+#define LOWMEM_COUNTER	2
 
 #if USE_SPLIT_PTLOCKS
 #define SPLIT_RSS_COUNTING
diff -puN mm/filemap_xip.c~mm-count-lowmem-rss mm/filemap_xip.c
--- a/mm/filemap_xip.c~mm-count-lowmem-rss
+++ a/mm/filemap_xip.c
@@ -194,7 +194,7 @@ retry:
 			flush_cache_page(vma, address, pte_pfn(*pte));
 			pteval = ptep_clear_flush_notify(vma, address, pte);
 			page_remove_rmap(page);
-			dec_mm_counter(mm, MM_FILEPAGES);
+			dec_mm_counter_page(mm, MM_FILEPAGES, page);
 			BUG_ON(pte_dirty(pteval));
 			pte_unmap_unlock(pte, ptl);
 			page_cache_release(page);
diff -puN mm/fremap.c~mm-count-lowmem-rss mm/fremap.c
--- a/mm/fremap.c~mm-count-lowmem-rss
+++ a/mm/fremap.c
@@ -40,7 +40,7 @@ static void zap_pte(struct mm_struct *mm
 			page_remove_rmap(page);
 			page_cache_release(page);
 			update_hiwater_rss(mm);
-			dec_mm_counter(mm, MM_FILEPAGES);
+			dec_mm_counter_page(mm, MM_FILEPAGES, page);
 		}
 	} else {
 		if (!pte_file(pte))
diff -puN mm/memory.c~mm-count-lowmem-rss mm/memory.c
--- a/mm/memory.c~mm-count-lowmem-rss
+++ a/mm/memory.c
@@ -137,7 +137,7 @@ void __sync_task_rss_stat(struct task_st
 	task->rss_stat.events = 0;
 }
 
-static void add_mm_counter_fast(struct mm_struct *mm, int member, int val)
+static void __add_mm_counter_fast(struct mm_struct *mm, int member, int val)
 {
 	struct task_struct *task = current;
 
@@ -146,8 +146,17 @@ static void add_mm_counter_fast(struct m
 	else
 		add_mm_counter(mm, member, val);
 }
-#define inc_mm_counter_fast(mm, member) add_mm_counter_fast(mm, member, 1)
-#define dec_mm_counter_fast(mm, member) add_mm_counter_fast(mm, member, -1)
+static void add_mm_counter_fast(struct mm_struct *mm, int member,
+	int val, struct page *page)
+{
+	if (is_lowmem_page(page))
+		member += LOWMEM_COUNTER;
+	__add_mm_counter_fast(mm, member, val);
+}
+#define inc_mm_counter_fast(mm, member, page)\
+	add_mm_counter_fast(mm, member,1, page)
+#define dec_mm_counter_fast(mm, member, page)\
+	add_mm_counter_fast(mm, member,-1, page)
 
 /* sync counter once per 64 page faults */
 #define TASK_RSS_EVENTS_THRESH	(64)
@@ -183,8 +192,9 @@ void sync_mm_rss(struct task_struct *tas
 }
 #else
 
-#define inc_mm_counter_fast(mm, member) inc_mm_counter(mm, member)
-#define dec_mm_counter_fast(mm, member) dec_mm_counter(mm, member)
+#define inc_mm_counter_fast(mm, member, page) inc_mm_counter_page(mm, member, page)
+#define dec_mm_counter_fast(mm, member, page) dec_mm_counter_page(mm, member, page)
+#define __add_mm_counter_fast(mm, member, val) add_mm_counter(mm, member, val)
 
 static void check_sync_rss_stat(struct task_struct *task)
 {
@@ -195,6 +205,30 @@ void sync_mm_rss(struct task_struct *tas
 }
 #endif
 
+unsigned long get_file_rss(struct mm_struct *mm)
+{
+	return get_mm_counter(mm, MM_ANONPAGES)
+		+ get_mm_counter(mm, MM_ANON_LOWPAGES);
+}
+
+unsigned long get_anon_rss(struct mm_struct *mm)
+{
+	return get_mm_counter(mm, MM_FILEPAGES)
+		+ get_mm_counter(mm, MM_FILE_LOWPAGES);
+}
+
+unsigned long get_low_rss(struct mm_struct *mm)
+{
+	return get_mm_counter(mm, MM_ANON_LOWPAGES)
+		+ get_mm_counter(mm, MM_FILE_LOWPAGES);
+}
+
+unsigned long get_mm_rss(struct mm_struct *mm)
+{
+	return get_file_rss(mm) + get_anon_rss(mm);
+}
+
+
 /*
  * If a p?d_bad entry is found while walking page tables, report
  * the error, before resetting entry to p?d_none.  Usually (but
@@ -714,12 +748,17 @@ copy_one_pte(struct mm_struct *dst_mm, s
 
 	page = vm_normal_page(vma, addr, pte);
 	if (page) {
+		int type;
+
 		get_page(page);
 		page_dup_rmap(page);
 		if (PageAnon(page))
-			rss[MM_ANONPAGES]++;
+			type = MM_ANONPAGES;
 		else
-			rss[MM_FILEPAGES]++;
+			type = MM_FILEPAGES;
+		if (is_lowmem_page(page))
+			type += LOWMEM_COUNTER;
+		rss[type]++;
 	}
 
 out_set_pte:
@@ -905,6 +944,7 @@ static unsigned long zap_pte_range(struc
 	pte_t *pte;
 	spinlock_t *ptl;
 	int rss[NR_MM_COUNTERS];
+	int type;
 
 	init_rss_vec(rss);
 
@@ -952,15 +992,18 @@ static unsigned long zap_pte_range(struc
 				set_pte_at(mm, addr, pte,
 					   pgoff_to_pte(page->index));
 			if (PageAnon(page))
-				rss[MM_ANONPAGES]--;
+				type = MM_ANONPAGES;
 			else {
 				if (pte_dirty(ptent))
 					set_page_dirty(page);
 				if (pte_young(ptent) &&
 				    likely(!VM_SequentialReadHint(vma)))
 					mark_page_accessed(page);
-				rss[MM_FILEPAGES]--;
+				type = MM_FILEPAGES;
 			}
+			if (is_lowmem_page(page))
+				type += LOWMEM_COUNTER;
+			rss[type]--;
 			page_remove_rmap(page);
 			if (unlikely(page_mapcount(page) < 0))
 				print_bad_pte(vma, addr, ptent, page);
@@ -1621,7 +1664,7 @@ static int insert_page(struct vm_area_st
 
 	/* Ok, finally just insert the thing.. */
 	get_page(page);
-	inc_mm_counter_fast(mm, MM_FILEPAGES);
+	inc_mm_counter_fast(mm, MM_FILEPAGES, page);
 	page_add_file_rmap(page);
 	set_pte_at(mm, addr, pte, mk_pte(page, prot));
 
@@ -2257,11 +2300,12 @@ gotten:
 	if (likely(pte_same(*page_table, orig_pte))) {
 		if (old_page) {
 			if (!PageAnon(old_page)) {
-				dec_mm_counter_fast(mm, MM_FILEPAGES);
-				inc_mm_counter_fast(mm, MM_ANONPAGES);
+				dec_mm_counter_fast(mm, MM_FILEPAGES, old_page);
+				inc_mm_counter_fast(mm, MM_ANONPAGES, new_page);
 			}
 		} else
-			inc_mm_counter_fast(mm, MM_ANONPAGES);
+			inc_mm_counter_fast(mm, MM_ANONPAGES, new_page);
+
 		flush_cache_page(vma, address, pte_pfn(orig_pte));
 		entry = mk_pte(new_page, vma->vm_page_prot);
 		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
@@ -2698,8 +2742,9 @@ static int do_swap_page(struct mm_struct
 	 * discarded at swap_free().
 	 */
 
-	inc_mm_counter_fast(mm, MM_ANONPAGES);
-	dec_mm_counter_fast(mm, MM_SWAPENTS);
+	inc_mm_counter_fast(mm, MM_ANONPAGES, page);
+	/* SWAPENTS counter is not related to page..then use bare call */
+	__add_mm_counter_fast(mm, MM_SWAPENTS, -1);
 	pte = mk_pte(page, vma->vm_page_prot);
 	if ((flags & FAULT_FLAG_WRITE) && reuse_swap_page(page)) {
 		pte = maybe_mkwrite(pte_mkdirty(pte), vma);
@@ -2783,7 +2828,7 @@ static int do_anonymous_page(struct mm_s
 	if (!pte_none(*page_table))
 		goto release;
 
-	inc_mm_counter_fast(mm, MM_ANONPAGES);
+	inc_mm_counter_fast(mm, MM_ANONPAGES, page);
 	page_add_new_anon_rmap(page, vma, address);
 setpte:
 	set_pte_at(mm, address, page_table, entry);
@@ -2937,10 +2982,10 @@ static int __do_fault(struct mm_struct *
 		if (flags & FAULT_FLAG_WRITE)
 			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
 		if (anon) {
-			inc_mm_counter_fast(mm, MM_ANONPAGES);
+			inc_mm_counter_fast(mm, MM_ANONPAGES, page);
 			page_add_new_anon_rmap(page, vma, address);
 		} else {
-			inc_mm_counter_fast(mm, MM_FILEPAGES);
+			inc_mm_counter_fast(mm, MM_FILEPAGES, page);
 			page_add_file_rmap(page);
 			if (flags & FAULT_FLAG_WRITE) {
 				dirty_page = page;
diff -puN mm/oom_kill.c~mm-count-lowmem-rss mm/oom_kill.c
--- a/mm/oom_kill.c~mm-count-lowmem-rss
+++ a/mm/oom_kill.c
@@ -398,11 +398,13 @@ static void __oom_kill_task(struct task_
 
 	if (verbose)
 		printk(KERN_ERR "Killed process %d (%s) "
-		       "vsz:%lukB, anon-rss:%lukB, file-rss:%lukB\n",
+		       "vsz:%lukB, anon-rss:%lukB, file-rss:%lukB "
+			"lowmem %lukB\n",
 		       task_pid_nr(p), p->comm,
 		       K(p->mm->total_vm),
-		       K(get_mm_counter(p->mm, MM_ANONPAGES)),
-		       K(get_mm_counter(p->mm, MM_FILEPAGES)));
+		       K(get_anon_rss(p->mm)),
+		       K(get_file_rss(p->mm)),
+			K(get_low_rss(p->mm)));
 	task_unlock(p);
 
 	/*
diff -puN mm/rmap.c~mm-count-lowmem-rss mm/rmap.c
--- a/mm/rmap.c~mm-count-lowmem-rss
+++ a/mm/rmap.c
@@ -815,9 +815,9 @@ int try_to_unmap_one(struct page *page, 
 
 	if (PageHWPoison(page) && !(flags & TTU_IGNORE_HWPOISON)) {
 		if (PageAnon(page))
-			dec_mm_counter(mm, MM_ANONPAGES);
+			dec_mm_counter_page(mm, MM_ANONPAGES, page);
 		else
-			dec_mm_counter(mm, MM_FILEPAGES);
+			dec_mm_counter_page(mm, MM_FILEPAGES, page);
 		set_pte_at(mm, address, pte,
 				swp_entry_to_pte(make_hwpoison_entry(page)));
 	} else if (PageAnon(page)) {
@@ -839,7 +839,7 @@ int try_to_unmap_one(struct page *page, 
 					list_add(&mm->mmlist, &init_mm.mmlist);
 				spin_unlock(&mmlist_lock);
 			}
-			dec_mm_counter(mm, MM_ANONPAGES);
+			dec_mm_counter_page(mm, MM_ANONPAGES, page);
 			inc_mm_counter(mm, MM_SWAPENTS);
 		} else if (PAGE_MIGRATION) {
 			/*
@@ -858,7 +858,7 @@ int try_to_unmap_one(struct page *page, 
 		entry = make_migration_entry(page, pte_write(pteval));
 		set_pte_at(mm, address, pte, swp_entry_to_pte(entry));
 	} else
-		dec_mm_counter(mm, MM_FILEPAGES);
+		dec_mm_counter_page(mm, MM_FILEPAGES, page);
 
 	page_remove_rmap(page);
 	page_cache_release(page);
@@ -998,6 +998,8 @@ static int try_to_unmap_cluster(unsigned
 		page_remove_rmap(page);
 		page_cache_release(page);
 		dec_mm_counter(mm, MM_FILEPAGES);
+		if (is_lowmem_page(page))
+			dec_mm_counter(mm, MM_FILEPAGES);
 		(*mapcount)--;
 	}
 	pte_unmap_unlock(pte - 1, ptl);
diff -puN mm/swapfile.c~mm-count-lowmem-rss mm/swapfile.c
--- a/mm/swapfile.c~mm-count-lowmem-rss
+++ a/mm/swapfile.c
@@ -841,7 +841,7 @@ static int unuse_pte(struct vm_area_stru
 	}
 
 	dec_mm_counter(vma->vm_mm, MM_SWAPENTS);
-	inc_mm_counter(vma->vm_mm, MM_ANONPAGES);
+	inc_mm_counter_page(vma->vm_mm, MM_ANONPAGES, page);
 	get_page(page);
 	set_pte_at(vma->vm_mm, addr, pte,
 		   pte_mkold(mk_pte(page, vma->vm_page_prot)));
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
mm-clean-up-mm_counter.patch
mm-avoid-false-sharing-of-mm_counter.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage.patch
mm-count-swap-usage-checkpatch-fixes.patch
mm-add-lowmem-detection-logic.patch
mm-add-lowmem-detection-logic-fix.patch
mm-count-lowmem-rss.patch
mm-count-lowmem-rss-checkpatch-fixes.patch
vmscan-get_scan_ratio-cleanup.patch
mm-restore-zone-all_unreclaimable-to-independence-word.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix-2.patch
mm-migratec-kill-anon-local-variable-from-migrate_page_copy.patch
nodemaskh-remove-macro-any_online_node.patch
resources-introduce-generic-page_is_ram.patch
x86-remove-bios-data-range-from-e820.patch
x86-use-the-generic-page_is_ram.patch
cgroup-introduce-cancel_attach.patch
cgroup-introduce-coalesce-css_get-and-css_put.patch
cgroups-revamp-subsys-array.patch
cgroups-subsystem-module-loading-interface.patch
cgroups-subsystem-module-loading-interface-fix.patch
cgroups-subsystem-module-unloading.patch
cgroups-net_cls-as-module.patch
cgroups-blkio-subsystem-as-module.patch
cgroups-clean-up-cgroup_pidlist_find-a-bit.patch
memcg-add-interface-to-move-charge-at-task-migration.patch
memcg-move-charges-of-anonymous-page.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-improve-performance-in-moving-charge.patch
memcg-avoid-oom-during-moving-charge.patch
memcg-move-charges-of-anonymous-swap.patch
memcg-move-charges-of-anonymous-swap-fix.patch
memcg-improve-performance-in-moving-swap-charge.patch
memcg-improve-performance-in-moving-swap-charge-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-kconfig-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-fixes.patch
memcg-extract-mem_group_usage-from-mem_cgroup_read.patch
memcg-rework-usage-of-stats-by-soft-limit.patch
memcg-implement-memory-thresholds.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
memcg-implement-memory-thresholds-checkpatch-fixes-fix.patch
memcg-typo-in-comment-to-mem_cgroup_print_oom_info.patch
sysctl-clean-up-vm-related-variable-declarations.patch

