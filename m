From: akpm@linux-foundation.org
Subject: [merged]
 mm-shmem-add-internal-shmem-resident-memory-accounting.patch removed from
 -mm tree
Date: Fri, 15 Jan 2016 14:33:17 -0800
Message-ID: <569973ad.TbihIRf5csjS74CD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59353 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689AbcAOWdS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:33:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jmarchan@redhat.com, hughd@google.com, khlebnikov@yandex-team.ru, mhocko@suse.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, shmem: add internal shmem resident memory accounting
has been removed from the -mm tree.  Its filename was
     mm-shmem-add-internal-shmem-resident-memory-accounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jerome Marchand <jmarchan@redhat.com>
Subject: mm, shmem: add internal shmem resident memory accounting

Currently looking at /proc/<pid>/status or statm, there is no way to
distinguish shmem pages from pages mapped to a regular file (shmem pages
are mapped to /dev/zero), even though their implication in actual memory
use is quite different.

The internal accounting currently counts shmem pages together with regular
files.  As a preparation to extend the userspace interfaces, this patch
adds MM_SHMEMPAGES counter to mm_rss_stat to account for shmem pages
separately from MM_FILEPAGES.  The next patch will expose it to userspace
- this patch doesn't change the exported values yet, by adding up
MM_SHMEMPAGES to MM_FILEPAGES at places where MM_FILEPAGES was used
before.  The only user-visible change after this patch is the OOM killer
message that separates the reported "shmem-rss" from "file-rss".

[vbabka@suse.cz: forward-porting, tweak changelog]
Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/pgtable.c   |    5 +----
 fs/proc/task_mmu.c       |    3 ++-
 include/linux/mm.h       |   18 +++++++++++++++++-
 include/linux/mm_types.h |    7 ++++---
 kernel/events/uprobes.c  |    2 +-
 mm/memory.c              |   30 ++++++++++--------------------
 mm/oom_kill.c            |    5 +++--
 mm/rmap.c                |   12 +++---------
 8 files changed, 41 insertions(+), 41 deletions(-)

diff -puN arch/s390/mm/pgtable.c~mm-shmem-add-internal-shmem-resident-memory-accounting arch/s390/mm/pgtable.c
--- a/arch/s390/mm/pgtable.c~mm-shmem-add-internal-shmem-resident-memory-accounting
+++ a/arch/s390/mm/pgtable.c
@@ -603,10 +603,7 @@ static void gmap_zap_swap_entry(swp_entr
 	else if (is_migration_entry(entry)) {
 		struct page *page = migration_entry_to_page(entry);
 
-		if (PageAnon(page))
-			dec_mm_counter(mm, MM_ANONPAGES);
-		else
-			dec_mm_counter(mm, MM_FILEPAGES);
+		dec_mm_counter(mm, mm_counter(page));
 	}
 	free_swap_and_cache(entry);
 }
diff -puN fs/proc/task_mmu.c~mm-shmem-add-internal-shmem-resident-memory-accounting fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-shmem-add-internal-shmem-resident-memory-accounting
+++ a/fs/proc/task_mmu.c
@@ -83,7 +83,8 @@ unsigned long task_statm(struct mm_struc
 			 unsigned long *shared, unsigned long *text,
 			 unsigned long *data, unsigned long *resident)
 {
-	*shared = get_mm_counter(mm, MM_FILEPAGES);
+	*shared = get_mm_counter(mm, MM_FILEPAGES) +
+			get_mm_counter(mm, MM_SHMEMPAGES);
 	*text = (PAGE_ALIGN(mm->end_code) - (mm->start_code & PAGE_MASK))
 								>> PAGE_SHIFT;
 	*data = mm->total_vm - mm->shared_vm;
diff -puN include/linux/mm.h~mm-shmem-add-internal-shmem-resident-memory-accounting include/linux/mm.h
--- a/include/linux/mm.h~mm-shmem-add-internal-shmem-resident-memory-accounting
+++ a/include/linux/mm.h
@@ -1361,10 +1361,26 @@ static inline void dec_mm_counter(struct
 	atomic_long_dec(&mm->rss_stat.count[member]);
 }
 
+/* Optimized variant when page is already known not to be PageAnon */
+static inline int mm_counter_file(struct page *page)
+{
+	if (PageSwapBacked(page))
+		return MM_SHMEMPAGES;
+	return MM_FILEPAGES;
+}
+
+static inline int mm_counter(struct page *page)
+{
+	if (PageAnon(page))
+		return MM_ANONPAGES;
+	return mm_counter_file(page);
+}
+
 static inline unsigned long get_mm_rss(struct mm_struct *mm)
 {
 	return get_mm_counter(mm, MM_FILEPAGES) +
-		get_mm_counter(mm, MM_ANONPAGES);
+		get_mm_counter(mm, MM_ANONPAGES) +
+		get_mm_counter(mm, MM_SHMEMPAGES);
 }
 
 static inline unsigned long get_mm_hiwater_rss(struct mm_struct *mm)
diff -puN include/linux/mm_types.h~mm-shmem-add-internal-shmem-resident-memory-accounting include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-shmem-add-internal-shmem-resident-memory-accounting
+++ a/include/linux/mm_types.h
@@ -369,9 +369,10 @@ struct core_state {
 };
 
 enum {
-	MM_FILEPAGES,
-	MM_ANONPAGES,
-	MM_SWAPENTS,
+	MM_FILEPAGES,	/* Resident file mapping pages */
+	MM_ANONPAGES,	/* Resident anonymous pages */
+	MM_SWAPENTS,	/* Anonymous swap entries */
+	MM_SHMEMPAGES,	/* Resident shared memory pages */
 	NR_MM_COUNTERS
 };
 
diff -puN kernel/events/uprobes.c~mm-shmem-add-internal-shmem-resident-memory-accounting kernel/events/uprobes.c
--- a/kernel/events/uprobes.c~mm-shmem-add-internal-shmem-resident-memory-accounting
+++ a/kernel/events/uprobes.c
@@ -180,7 +180,7 @@ static int __replace_page(struct vm_area
 	lru_cache_add_active_or_unevictable(kpage, vma);
 
 	if (!PageAnon(page)) {
-		dec_mm_counter(mm, MM_FILEPAGES);
+		dec_mm_counter(mm, mm_counter_file(page));
 		inc_mm_counter(mm, MM_ANONPAGES);
 	}
 
diff -puN mm/memory.c~mm-shmem-add-internal-shmem-resident-memory-accounting mm/memory.c
--- a/mm/memory.c~mm-shmem-add-internal-shmem-resident-memory-accounting
+++ a/mm/memory.c
@@ -832,10 +832,7 @@ copy_one_pte(struct mm_struct *dst_mm, s
 		} else if (is_migration_entry(entry)) {
 			page = migration_entry_to_page(entry);
 
-			if (PageAnon(page))
-				rss[MM_ANONPAGES]++;
-			else
-				rss[MM_FILEPAGES]++;
+			rss[mm_counter(page)]++;
 
 			if (is_write_migration_entry(entry) &&
 					is_cow_mapping(vm_flags)) {
@@ -874,10 +871,7 @@ copy_one_pte(struct mm_struct *dst_mm, s
 	if (page) {
 		get_page(page);
 		page_dup_rmap(page);
-		if (PageAnon(page))
-			rss[MM_ANONPAGES]++;
-		else
-			rss[MM_FILEPAGES]++;
+		rss[mm_counter(page)]++;
 	}
 
 out_set_pte:
@@ -1113,9 +1107,8 @@ again:
 			tlb_remove_tlb_entry(tlb, pte, addr);
 			if (unlikely(!page))
 				continue;
-			if (PageAnon(page))
-				rss[MM_ANONPAGES]--;
-			else {
+
+			if (!PageAnon(page)) {
 				if (pte_dirty(ptent)) {
 					force_flush = 1;
 					set_page_dirty(page);
@@ -1123,8 +1116,8 @@ again:
 				if (pte_young(ptent) &&
 				    likely(!(vma->vm_flags & VM_SEQ_READ)))
 					mark_page_accessed(page);
-				rss[MM_FILEPAGES]--;
 			}
+			rss[mm_counter(page)]--;
 			page_remove_rmap(page);
 			if (unlikely(page_mapcount(page) < 0))
 				print_bad_pte(vma, addr, ptent, page);
@@ -1146,11 +1139,7 @@ again:
 			struct page *page;
 
 			page = migration_entry_to_page(entry);
-
-			if (PageAnon(page))
-				rss[MM_ANONPAGES]--;
-			else
-				rss[MM_FILEPAGES]--;
+			rss[mm_counter(page)]--;
 		}
 		if (unlikely(!free_swap_and_cache(entry)))
 			print_bad_pte(vma, addr, ptent, NULL);
@@ -1460,7 +1449,7 @@ static int insert_page(struct vm_area_st
 
 	/* Ok, finally just insert the thing.. */
 	get_page(page);
-	inc_mm_counter_fast(mm, MM_FILEPAGES);
+	inc_mm_counter_fast(mm, mm_counter_file(page));
 	page_add_file_rmap(page);
 	set_pte_at(mm, addr, pte, mk_pte(page, prot));
 
@@ -2097,7 +2086,8 @@ static int wp_page_copy(struct mm_struct
 	if (likely(pte_same(*page_table, orig_pte))) {
 		if (old_page) {
 			if (!PageAnon(old_page)) {
-				dec_mm_counter_fast(mm, MM_FILEPAGES);
+				dec_mm_counter_fast(mm,
+						mm_counter_file(old_page));
 				inc_mm_counter_fast(mm, MM_ANONPAGES);
 			}
 		} else {
@@ -2820,7 +2810,7 @@ void do_set_pte(struct vm_area_struct *v
 		inc_mm_counter_fast(vma->vm_mm, MM_ANONPAGES);
 		page_add_new_anon_rmap(page, vma, address);
 	} else {
-		inc_mm_counter_fast(vma->vm_mm, MM_FILEPAGES);
+		inc_mm_counter_fast(vma->vm_mm, mm_counter_file(page));
 		page_add_file_rmap(page);
 	}
 	set_pte_at(vma->vm_mm, address, pte, entry);
diff -puN mm/oom_kill.c~mm-shmem-add-internal-shmem-resident-memory-accounting mm/oom_kill.c
--- a/mm/oom_kill.c~mm-shmem-add-internal-shmem-resident-memory-accounting
+++ a/mm/oom_kill.c
@@ -585,10 +585,11 @@ void oom_kill_process(struct oom_control
 	 */
 	do_send_sig_info(SIGKILL, SEND_SIG_FORCED, victim, true);
 	mark_oom_victim(victim);
-	pr_err("Killed process %d (%s) total-vm:%lukB, anon-rss:%lukB, file-rss:%lukB\n",
+	pr_err("Killed process %d (%s) total-vm:%lukB, anon-rss:%lukB, file-rss:%lukB, shmem-rss:%lukB\n",
 		task_pid_nr(victim), victim->comm, K(victim->mm->total_vm),
 		K(get_mm_counter(victim->mm, MM_ANONPAGES)),
-		K(get_mm_counter(victim->mm, MM_FILEPAGES)));
+		K(get_mm_counter(victim->mm, MM_FILEPAGES)),
+		K(get_mm_counter(victim->mm, MM_SHMEMPAGES)));
 	task_unlock(victim);
 
 	/*
diff -puN mm/rmap.c~mm-shmem-add-internal-shmem-resident-memory-accounting mm/rmap.c
--- a/mm/rmap.c~mm-shmem-add-internal-shmem-resident-memory-accounting
+++ a/mm/rmap.c
@@ -1364,10 +1364,7 @@ static int try_to_unmap_one(struct page
 		if (PageHuge(page)) {
 			hugetlb_count_sub(1 << compound_order(page), mm);
 		} else {
-			if (PageAnon(page))
-				dec_mm_counter(mm, MM_ANONPAGES);
-			else
-				dec_mm_counter(mm, MM_FILEPAGES);
+			dec_mm_counter(mm, mm_counter(page));
 		}
 		set_pte_at(mm, address, pte,
 			   swp_entry_to_pte(make_hwpoison_entry(page)));
@@ -1377,10 +1374,7 @@ static int try_to_unmap_one(struct page
 		 * interest anymore. Simply discard the pte, vmscan
 		 * will take care of the rest.
 		 */
-		if (PageAnon(page))
-			dec_mm_counter(mm, MM_ANONPAGES);
-		else
-			dec_mm_counter(mm, MM_FILEPAGES);
+		dec_mm_counter(mm, mm_counter(page));
 	} else if (IS_ENABLED(CONFIG_MIGRATION) && (flags & TTU_MIGRATION)) {
 		swp_entry_t entry;
 		pte_t swp_pte;
@@ -1420,7 +1414,7 @@ static int try_to_unmap_one(struct page
 			swp_pte = pte_swp_mksoft_dirty(swp_pte);
 		set_pte_at(mm, address, pte, swp_pte);
 	} else
-		dec_mm_counter(mm, MM_FILEPAGES);
+		dec_mm_counter(mm, mm_counter_file(page));
 
 	page_remove_rmap(page);
 	page_cache_release(page);
_

Patches currently in -mm which might be from jmarchan@redhat.com are

zram-dont-call-idr_remove-from-zram_remove.patch

