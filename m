From: akpm@linux-foundation.org
Subject: [merged] mm-clean-up-mm_counter.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:03:02 -0800
Message-ID: <201003091903.o29J32Ut030918@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56826 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755336Ab0CITDV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:03:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, cl@linux-foundation.org, lee.schermerhorn@hp.com, minchan.kim@gmail.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     mm: clean up mm_counter
has been removed from the -mm tree.  Its filename was
     mm-clean-up-mm_counter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: clean up mm_counter
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Presently, per-mm statistics counter is defined by macro in sched.h

This patch modifies it to
  - defined in mm.h as inlinf functions
  - use array instead of macro's name creation.

This patch is for reducing patch size in future patch to modify
implementation of per-mm counter.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c       |    4 -
 include/linux/mm.h       |  104 +++++++++++++++++++++++++++++++++++++
 include/linux/mm_types.h |   33 +++++++----
 include/linux/sched.h    |   54 -------------------
 kernel/fork.c            |    3 -
 kernel/tsacct.c          |    1 
 mm/filemap_xip.c         |    2 
 mm/fremap.c              |    2 
 mm/memory.c              |   56 ++++++++++++-------
 mm/oom_kill.c            |    4 -
 mm/rmap.c                |   10 +--
 mm/swapfile.c            |    2 
 12 files changed, 174 insertions(+), 101 deletions(-)

diff -puN fs/proc/task_mmu.c~mm-clean-up-mm_counter fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-clean-up-mm_counter
+++ a/fs/proc/task_mmu.c
@@ -65,11 +65,11 @@ unsigned long task_vsize(struct mm_struc
 int task_statm(struct mm_struct *mm, int *shared, int *text,
 	       int *data, int *resident)
 {
-	*shared = get_mm_counter(mm, file_rss);
+	*shared = get_mm_counter(mm, MM_FILEPAGES);
 	*text = (PAGE_ALIGN(mm->end_code) - (mm->start_code & PAGE_MASK))
 								>> PAGE_SHIFT;
 	*data = mm->total_vm - mm->shared_vm;
-	*resident = *shared + get_mm_counter(mm, anon_rss);
+	*resident = *shared + get_mm_counter(mm, MM_ANONPAGES);
 	return mm->total_vm;
 }
 
diff -puN include/linux/mm.h~mm-clean-up-mm_counter include/linux/mm.h
--- a/include/linux/mm.h~mm-clean-up-mm_counter
+++ a/include/linux/mm.h
@@ -870,6 +870,110 @@ extern int mprotect_fixup(struct vm_area
  */
 int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
 			  struct page **pages);
+/*
+ * per-process(per-mm_struct) statistics.
+ */
+#if USE_SPLIT_PTLOCKS
+/*
+ * The mm counters are not protected by its page_table_lock,
+ * so must be incremented atomically.
+ */
+static inline void set_mm_counter(struct mm_struct *mm, int member, long value)
+{
+	atomic_long_set(&mm->rss_stat.count[member], value);
+}
+
+static inline unsigned long get_mm_counter(struct mm_struct *mm, int member)
+{
+	return (unsigned long)atomic_long_read(&mm->rss_stat.count[member]);
+}
+
+static inline void add_mm_counter(struct mm_struct *mm, int member, long value)
+{
+	atomic_long_add(value, &mm->rss_stat.count[member]);
+}
+
+static inline void inc_mm_counter(struct mm_struct *mm, int member)
+{
+	atomic_long_inc(&mm->rss_stat.count[member]);
+}
+
+static inline void dec_mm_counter(struct mm_struct *mm, int member)
+{
+	atomic_long_dec(&mm->rss_stat.count[member]);
+}
+
+#else  /* !USE_SPLIT_PTLOCKS */
+/*
+ * The mm counters are protected by its page_table_lock,
+ * so can be incremented directly.
+ */
+static inline void set_mm_counter(struct mm_struct *mm, int member, long value)
+{
+	mm->rss_stat.count[member] = value;
+}
+
+static inline unsigned long get_mm_counter(struct mm_struct *mm, int member)
+{
+	return mm->rss_stat.count[member];
+}
+
+static inline void add_mm_counter(struct mm_struct *mm, int member, long value)
+{
+	mm->rss_stat.count[member] += value;
+}
+
+static inline void inc_mm_counter(struct mm_struct *mm, int member)
+{
+	mm->rss_stat.count[member]++;
+}
+
+static inline void dec_mm_counter(struct mm_struct *mm, int member)
+{
+	mm->rss_stat.count[member]--;
+}
+
+#endif /* !USE_SPLIT_PTLOCKS */
+
+static inline unsigned long get_mm_rss(struct mm_struct *mm)
+{
+	return get_mm_counter(mm, MM_FILEPAGES) +
+		get_mm_counter(mm, MM_ANONPAGES);
+}
+
+static inline unsigned long get_mm_hiwater_rss(struct mm_struct *mm)
+{
+	return max(mm->hiwater_rss, get_mm_rss(mm));
+}
+
+static inline unsigned long get_mm_hiwater_vm(struct mm_struct *mm)
+{
+	return max(mm->hiwater_vm, mm->total_vm);
+}
+
+static inline void update_hiwater_rss(struct mm_struct *mm)
+{
+	unsigned long _rss = get_mm_rss(mm);
+
+	if ((mm)->hiwater_rss < _rss)
+		(mm)->hiwater_rss = _rss;
+}
+
+static inline void update_hiwater_vm(struct mm_struct *mm)
+{
+	if (mm->hiwater_vm < mm->total_vm)
+		mm->hiwater_vm = mm->total_vm;
+}
+
+static inline void setmax_mm_hiwater_rss(unsigned long *maxrss,
+					 struct mm_struct *mm)
+{
+	unsigned long hiwater_rss = get_mm_hiwater_rss(mm);
+
+	if (*maxrss < hiwater_rss)
+		*maxrss = hiwater_rss;
+}
+
 
 /*
  * A callback you can register to apply pressure to ageable caches.
diff -puN include/linux/mm_types.h~mm-clean-up-mm_counter include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-clean-up-mm_counter
+++ a/include/linux/mm_types.h
@@ -24,12 +24,6 @@ struct address_space;
 
 #define USE_SPLIT_PTLOCKS	(NR_CPUS >= CONFIG_SPLIT_PTLOCK_CPUS)
 
-#if USE_SPLIT_PTLOCKS
-typedef atomic_long_t mm_counter_t;
-#else  /* !USE_SPLIT_PTLOCKS */
-typedef unsigned long mm_counter_t;
-#endif /* !USE_SPLIT_PTLOCKS */
-
 /*
  * Each physical page in the system has a struct page associated with
  * it to keep track of whatever it is we are using the page for at the
@@ -201,6 +195,22 @@ struct core_state {
 	struct completion startup;
 };
 
+enum {
+	MM_FILEPAGES,
+	MM_ANONPAGES,
+	NR_MM_COUNTERS
+};
+
+#if USE_SPLIT_PTLOCKS
+struct mm_rss_stat {
+	atomic_long_t count[NR_MM_COUNTERS];
+};
+#else  /* !USE_SPLIT_PTLOCKS */
+struct mm_rss_stat {
+	unsigned long count[NR_MM_COUNTERS];
+};
+#endif /* !USE_SPLIT_PTLOCKS */
+
 struct mm_struct {
 	struct vm_area_struct * mmap;		/* list of VMAs */
 	struct rb_root mm_rb;
@@ -227,11 +237,6 @@ struct mm_struct {
 						 * by mmlist_lock
 						 */
 
-	/* Special counters, in some configurations protected by the
-	 * page_table_lock, in other configurations by being atomic.
-	 */
-	mm_counter_t _file_rss;
-	mm_counter_t _anon_rss;
 
 	unsigned long hiwater_rss;	/* High-watermark of RSS usage */
 	unsigned long hiwater_vm;	/* High-water virtual memory usage */
@@ -244,6 +249,12 @@ struct mm_struct {
 
 	unsigned long saved_auxv[AT_VECTOR_SIZE]; /* for /proc/PID/auxv */
 
+	/*
+	 * Special counters, in some configurations protected by the
+	 * page_table_lock, in other configurations by being atomic.
+	 */
+	struct mm_rss_stat rss_stat;
+
 	struct linux_binfmt *binfmt;
 
 	cpumask_t cpu_vm_mask;
diff -puN include/linux/sched.h~mm-clean-up-mm_counter include/linux/sched.h
--- a/include/linux/sched.h~mm-clean-up-mm_counter
+++ a/include/linux/sched.h
@@ -396,60 +396,6 @@ extern void arch_unmap_area_topdown(stru
 static inline void arch_pick_mmap_layout(struct mm_struct *mm) {}
 #endif
 
-#if USE_SPLIT_PTLOCKS
-/*
- * The mm counters are not protected by its page_table_lock,
- * so must be incremented atomically.
- */
-#define set_mm_counter(mm, member, value) atomic_long_set(&(mm)->_##member, value)
-#define get_mm_counter(mm, member) ((unsigned long)atomic_long_read(&(mm)->_##member))
-#define add_mm_counter(mm, member, value) atomic_long_add(value, &(mm)->_##member)
-#define inc_mm_counter(mm, member) atomic_long_inc(&(mm)->_##member)
-#define dec_mm_counter(mm, member) atomic_long_dec(&(mm)->_##member)
-
-#else  /* !USE_SPLIT_PTLOCKS */
-/*
- * The mm counters are protected by its page_table_lock,
- * so can be incremented directly.
- */
-#define set_mm_counter(mm, member, value) (mm)->_##member = (value)
-#define get_mm_counter(mm, member) ((mm)->_##member)
-#define add_mm_counter(mm, member, value) (mm)->_##member += (value)
-#define inc_mm_counter(mm, member) (mm)->_##member++
-#define dec_mm_counter(mm, member) (mm)->_##member--
-
-#endif /* !USE_SPLIT_PTLOCKS */
-
-#define get_mm_rss(mm)					\
-	(get_mm_counter(mm, file_rss) + get_mm_counter(mm, anon_rss))
-#define update_hiwater_rss(mm)	do {			\
-	unsigned long _rss = get_mm_rss(mm);		\
-	if ((mm)->hiwater_rss < _rss)			\
-		(mm)->hiwater_rss = _rss;		\
-} while (0)
-#define update_hiwater_vm(mm)	do {			\
-	if ((mm)->hiwater_vm < (mm)->total_vm)		\
-		(mm)->hiwater_vm = (mm)->total_vm;	\
-} while (0)
-
-static inline unsigned long get_mm_hiwater_rss(struct mm_struct *mm)
-{
-	return max(mm->hiwater_rss, get_mm_rss(mm));
-}
-
-static inline void setmax_mm_hiwater_rss(unsigned long *maxrss,
-					 struct mm_struct *mm)
-{
-	unsigned long hiwater_rss = get_mm_hiwater_rss(mm);
-
-	if (*maxrss < hiwater_rss)
-		*maxrss = hiwater_rss;
-}
-
-static inline unsigned long get_mm_hiwater_vm(struct mm_struct *mm)
-{
-	return max(mm->hiwater_vm, mm->total_vm);
-}
 
 extern void set_dumpable(struct mm_struct *mm, int value);
 extern int get_dumpable(struct mm_struct *mm);
diff -puN kernel/fork.c~mm-clean-up-mm_counter kernel/fork.c
--- a/kernel/fork.c~mm-clean-up-mm_counter
+++ a/kernel/fork.c
@@ -455,8 +455,7 @@ static struct mm_struct * mm_init(struct
 		(current->mm->flags & MMF_INIT_MASK) : default_dump_filter;
 	mm->core_state = NULL;
 	mm->nr_ptes = 0;
-	set_mm_counter(mm, file_rss, 0);
-	set_mm_counter(mm, anon_rss, 0);
+	memset(&mm->rss_stat, 0, sizeof(mm->rss_stat));
 	spin_lock_init(&mm->page_table_lock);
 	mm->free_area_cache = TASK_UNMAPPED_BASE;
 	mm->cached_hole_size = ~0UL;
diff -puN kernel/tsacct.c~mm-clean-up-mm_counter kernel/tsacct.c
--- a/kernel/tsacct.c~mm-clean-up-mm_counter
+++ a/kernel/tsacct.c
@@ -21,6 +21,7 @@
 #include <linux/tsacct_kern.h>
 #include <linux/acct.h>
 #include <linux/jiffies.h>
+#include <linux/mm.h>
 
 /*
  * fill in basic accounting fields
diff -puN mm/filemap_xip.c~mm-clean-up-mm_counter mm/filemap_xip.c
--- a/mm/filemap_xip.c~mm-clean-up-mm_counter
+++ a/mm/filemap_xip.c
@@ -194,7 +194,7 @@ retry:
 			flush_cache_page(vma, address, pte_pfn(*pte));
 			pteval = ptep_clear_flush_notify(vma, address, pte);
 			page_remove_rmap(page);
-			dec_mm_counter(mm, file_rss);
+			dec_mm_counter(mm, MM_FILEPAGES);
 			BUG_ON(pte_dirty(pteval));
 			pte_unmap_unlock(pte, ptl);
 			page_cache_release(page);
diff -puN mm/fremap.c~mm-clean-up-mm_counter mm/fremap.c
--- a/mm/fremap.c~mm-clean-up-mm_counter
+++ a/mm/fremap.c
@@ -40,7 +40,7 @@ static void zap_pte(struct mm_struct *mm
 			page_remove_rmap(page);
 			page_cache_release(page);
 			update_hiwater_rss(mm);
-			dec_mm_counter(mm, file_rss);
+			dec_mm_counter(mm, MM_FILEPAGES);
 		}
 	} else {
 		if (!pte_file(pte))
diff -puN mm/memory.c~mm-clean-up-mm_counter mm/memory.c
--- a/mm/memory.c~mm-clean-up-mm_counter
+++ a/mm/memory.c
@@ -121,6 +121,7 @@ static int __init init_zero_pfn(void)
 }
 core_initcall(init_zero_pfn);
 
+
 /*
  * If a p?d_bad entry is found while walking page tables, report
  * the error, before resetting entry to p?d_none.  Usually (but
@@ -376,12 +377,18 @@ int __pte_alloc_kernel(pmd_t *pmd, unsig
 	return 0;
 }
 
-static inline void add_mm_rss(struct mm_struct *mm, int file_rss, int anon_rss)
+static inline void init_rss_vec(int *rss)
 {
-	if (file_rss)
-		add_mm_counter(mm, file_rss, file_rss);
-	if (anon_rss)
-		add_mm_counter(mm, anon_rss, anon_rss);
+	memset(rss, 0, sizeof(int) * NR_MM_COUNTERS);
+}
+
+static inline void add_mm_rss_vec(struct mm_struct *mm, int *rss)
+{
+	int i;
+
+	for (i = 0; i < NR_MM_COUNTERS; i++)
+		if (rss[i])
+			add_mm_counter(mm, i, rss[i]);
 }
 
 /*
@@ -632,7 +639,10 @@ copy_one_pte(struct mm_struct *dst_mm, s
 	if (page) {
 		get_page(page);
 		page_dup_rmap(page);
-		rss[PageAnon(page)]++;
+		if (PageAnon(page))
+			rss[MM_ANONPAGES]++;
+		else
+			rss[MM_FILEPAGES]++;
 	}
 
 out_set_pte:
@@ -648,11 +658,12 @@ static int copy_pte_range(struct mm_stru
 	pte_t *src_pte, *dst_pte;
 	spinlock_t *src_ptl, *dst_ptl;
 	int progress = 0;
-	int rss[2];
+	int rss[NR_MM_COUNTERS];
 	swp_entry_t entry = (swp_entry_t){0};
 
 again:
-	rss[1] = rss[0] = 0;
+	init_rss_vec(rss);
+
 	dst_pte = pte_alloc_map_lock(dst_mm, dst_pmd, addr, &dst_ptl);
 	if (!dst_pte)
 		return -ENOMEM;
@@ -688,7 +699,7 @@ again:
 	arch_leave_lazy_mmu_mode();
 	spin_unlock(src_ptl);
 	pte_unmap_nested(orig_src_pte);
-	add_mm_rss(dst_mm, rss[0], rss[1]);
+	add_mm_rss_vec(dst_mm, rss);
 	pte_unmap_unlock(orig_dst_pte, dst_ptl);
 	cond_resched();
 
@@ -816,8 +827,9 @@ static unsigned long zap_pte_range(struc
 	struct mm_struct *mm = tlb->mm;
 	pte_t *pte;
 	spinlock_t *ptl;
-	int file_rss = 0;
-	int anon_rss = 0;
+	int rss[NR_MM_COUNTERS];
+
+	init_rss_vec(rss);
 
 	pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
 	arch_enter_lazy_mmu_mode();
@@ -863,14 +875,14 @@ static unsigned long zap_pte_range(struc
 				set_pte_at(mm, addr, pte,
 					   pgoff_to_pte(page->index));
 			if (PageAnon(page))
-				anon_rss--;
+				rss[MM_ANONPAGES]--;
 			else {
 				if (pte_dirty(ptent))
 					set_page_dirty(page);
 				if (pte_young(ptent) &&
 				    likely(!VM_SequentialReadHint(vma)))
 					mark_page_accessed(page);
-				file_rss--;
+				rss[MM_FILEPAGES]--;
 			}
 			page_remove_rmap(page);
 			if (unlikely(page_mapcount(page) < 0))
@@ -893,7 +905,7 @@ static unsigned long zap_pte_range(struc
 		pte_clear_not_present_full(mm, addr, pte, tlb->fullmm);
 	} while (pte++, addr += PAGE_SIZE, (addr != end && *zap_work > 0));
 
-	add_mm_rss(mm, file_rss, anon_rss);
+	add_mm_rss_vec(mm, rss);
 	arch_leave_lazy_mmu_mode();
 	pte_unmap_unlock(pte - 1, ptl);
 
@@ -1527,7 +1539,7 @@ static int insert_page(struct vm_area_st
 
 	/* Ok, finally just insert the thing.. */
 	get_page(page);
-	inc_mm_counter(mm, file_rss);
+	inc_mm_counter(mm, MM_FILEPAGES);
 	page_add_file_rmap(page);
 	set_pte_at(mm, addr, pte, mk_pte(page, prot));
 
@@ -2163,11 +2175,11 @@ gotten:
 	if (likely(pte_same(*page_table, orig_pte))) {
 		if (old_page) {
 			if (!PageAnon(old_page)) {
-				dec_mm_counter(mm, file_rss);
-				inc_mm_counter(mm, anon_rss);
+				dec_mm_counter(mm, MM_FILEPAGES);
+				inc_mm_counter(mm, MM_ANONPAGES);
 			}
 		} else
-			inc_mm_counter(mm, anon_rss);
+			inc_mm_counter(mm, MM_ANONPAGES);
 		flush_cache_page(vma, address, pte_pfn(orig_pte));
 		entry = mk_pte(new_page, vma->vm_page_prot);
 		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
@@ -2604,7 +2616,7 @@ static int do_swap_page(struct mm_struct
 	 * discarded at swap_free().
 	 */
 
-	inc_mm_counter(mm, anon_rss);
+	inc_mm_counter(mm, MM_ANONPAGES);
 	pte = mk_pte(page, vma->vm_page_prot);
 	if ((flags & FAULT_FLAG_WRITE) && reuse_swap_page(page)) {
 		pte = maybe_mkwrite(pte_mkdirty(pte), vma);
@@ -2688,7 +2700,7 @@ static int do_anonymous_page(struct mm_s
 	if (!pte_none(*page_table))
 		goto release;
 
-	inc_mm_counter(mm, anon_rss);
+	inc_mm_counter(mm, MM_ANONPAGES);
 	page_add_new_anon_rmap(page, vma, address);
 setpte:
 	set_pte_at(mm, address, page_table, entry);
@@ -2842,10 +2854,10 @@ static int __do_fault(struct mm_struct *
 		if (flags & FAULT_FLAG_WRITE)
 			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
 		if (anon) {
-			inc_mm_counter(mm, anon_rss);
+			inc_mm_counter(mm, MM_ANONPAGES);
 			page_add_new_anon_rmap(page, vma, address);
 		} else {
-			inc_mm_counter(mm, file_rss);
+			inc_mm_counter(mm, MM_FILEPAGES);
 			page_add_file_rmap(page);
 			if (flags & FAULT_FLAG_WRITE) {
 				dirty_page = page;
diff -puN mm/oom_kill.c~mm-clean-up-mm_counter mm/oom_kill.c
--- a/mm/oom_kill.c~mm-clean-up-mm_counter
+++ a/mm/oom_kill.c
@@ -401,8 +401,8 @@ static void __oom_kill_task(struct task_
 		       "vsz:%lukB, anon-rss:%lukB, file-rss:%lukB\n",
 		       task_pid_nr(p), p->comm,
 		       K(p->mm->total_vm),
-		       K(get_mm_counter(p->mm, anon_rss)),
-		       K(get_mm_counter(p->mm, file_rss)));
+		       K(get_mm_counter(p->mm, MM_ANONPAGES)),
+		       K(get_mm_counter(p->mm, MM_FILEPAGES)));
 	task_unlock(p);
 
 	/*
diff -puN mm/rmap.c~mm-clean-up-mm_counter mm/rmap.c
--- a/mm/rmap.c~mm-clean-up-mm_counter
+++ a/mm/rmap.c
@@ -815,9 +815,9 @@ int try_to_unmap_one(struct page *page, 
 
 	if (PageHWPoison(page) && !(flags & TTU_IGNORE_HWPOISON)) {
 		if (PageAnon(page))
-			dec_mm_counter(mm, anon_rss);
+			dec_mm_counter(mm, MM_ANONPAGES);
 		else
-			dec_mm_counter(mm, file_rss);
+			dec_mm_counter(mm, MM_FILEPAGES);
 		set_pte_at(mm, address, pte,
 				swp_entry_to_pte(make_hwpoison_entry(page)));
 	} else if (PageAnon(page)) {
@@ -839,7 +839,7 @@ int try_to_unmap_one(struct page *page, 
 					list_add(&mm->mmlist, &init_mm.mmlist);
 				spin_unlock(&mmlist_lock);
 			}
-			dec_mm_counter(mm, anon_rss);
+			dec_mm_counter(mm, MM_ANONPAGES);
 		} else if (PAGE_MIGRATION) {
 			/*
 			 * Store the pfn of the page in a special migration
@@ -857,7 +857,7 @@ int try_to_unmap_one(struct page *page, 
 		entry = make_migration_entry(page, pte_write(pteval));
 		set_pte_at(mm, address, pte, swp_entry_to_pte(entry));
 	} else
-		dec_mm_counter(mm, file_rss);
+		dec_mm_counter(mm, MM_FILEPAGES);
 
 	page_remove_rmap(page);
 	page_cache_release(page);
@@ -996,7 +996,7 @@ static int try_to_unmap_cluster(unsigned
 
 		page_remove_rmap(page);
 		page_cache_release(page);
-		dec_mm_counter(mm, file_rss);
+		dec_mm_counter(mm, MM_FILEPAGES);
 		(*mapcount)--;
 	}
 	pte_unmap_unlock(pte - 1, ptl);
diff -puN mm/swapfile.c~mm-clean-up-mm_counter mm/swapfile.c
--- a/mm/swapfile.c~mm-clean-up-mm_counter
+++ a/mm/swapfile.c
@@ -840,7 +840,7 @@ static int unuse_pte(struct vm_area_stru
 		goto out;
 	}
 
-	inc_mm_counter(vma->vm_mm, anon_rss);
+	inc_mm_counter(vma->vm_mm, MM_ANONPAGES);
 	get_page(page);
 	set_pte_at(vma->vm_mm, addr, pte,
 		   pte_mkold(mk_pte(page, vma->vm_page_prot)));
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

linux-next.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
devmem-dont-allow-seek-to-last-page.patch
drivers-char-memc-cleanups.patch
drivers-char-memc-cleanups-fix.patch
drivers-char-memc-cleanups-fix-fix.patch
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
cgroup-implement-eventfd-based-generic-api-for-notifications-fixes-fix.patch
memcg-extract-mem_group_usage-from-mem_cgroup_read.patch
memcg-rework-usage-of-stats-by-soft-limit.patch
memcg-implement-memory-thresholds.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
memcg-implement-memory-thresholds-checkpatch-fixes-fix.patch
memcg-implement-memory-thresholds-check-if-first-threshold-crossed.patch
memcg-typo-in-comment-to-mem_cgroup_print_oom_info.patch
memcg-use-generic-percpu-instead-of-private-implementation.patch
memcg-update-threshold-and-softlimit-at-commit-v2.patch
memcg-share-event-counter-rather-than-duplicate-v2.patch
memcg-update-memcg_testtxt.patch
memcg-handle-panic_on_oom=always-case-v2.patch
cgroups-fix-race-between-userspace-and-kernelspace.patch
cgroups-add-simple-listener-of-cgroup-events-to-documentation.patch
cgroups-add-simple-listener-of-cgroup-events-to-documentation-fix.patch
memcg-update-memcg_testtxt-to-describe-memory-thresholds.patch
memcg-fix-oom-kill-behavior-v3.patch
memcg-fix-oom-kill-behavior-v4.patch
memcg-update-maintainer-list.patch
sysctl-clean-up-vm-related-variable-declarations.patch
sysctl-clean-up-vm-related-variable-declarations-fix.patch

