From: akpm@linux-foundation.org
Subject: [merged] mm-count-swap-usage.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:03:08 -0800
Message-ID: <201003091903.o29J38p0030931@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46837 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751829Ab0CITDU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:03:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, cl@linux-foundation.org, lee.schermerhorn@hp.com, minchan.kim@gmail.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     mm: count swap usage
has been removed from the -mm tree.  Its filename was
     mm-count-swap-usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: count swap usage
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

A frequent questions from users about memory management is what numbers of
swap ents are user for processes.  And this information will give some
hints to oom-killer.

Besides we can count the number of swapents per a process by scanning
/proc/<pid>/smaps, this is very slow and not good for usual process
information handler which works like 'ps' or 'top'.  (ps or top is now
enough slow..)

This patch adds a counter of swapents to mm_counter and update is at each
swap events.  Information is exported via /proc/<pid>/status file as

[kamezawa@bluextal memory]$ cat /proc/self/status
Name:   cat
State:  R (running)
Tgid:   2910
Pid:    2910
PPid:   2823
TracerPid:      0
Uid:    500     500     500     500
Gid:    500     500     500     500
FDSize: 256
Groups: 500
VmPeak:    82696 kB
VmSize:    82696 kB
VmLck:         0 kB
VmHWM:       432 kB
VmRSS:       432 kB
VmData:      172 kB
VmStk:        84 kB
VmExe:        48 kB
VmLib:      1568 kB
VmPTE:        40 kB
VmSwap:        0 kB <=============== this.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    2 ++
 fs/proc/task_mmu.c                 |    9 ++++++---
 include/linux/mm_types.h           |    1 +
 mm/memory.c                        |   16 ++++++++++++----
 mm/rmap.c                          |    1 +
 mm/swapfile.c                      |    1 +
 6 files changed, 23 insertions(+), 7 deletions(-)

diff -puN Documentation/filesystems/proc.txt~mm-count-swap-usage Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~mm-count-swap-usage
+++ a/Documentation/filesystems/proc.txt
@@ -164,6 +164,7 @@ read the file /proc/PID/status:
   VmExe:        68 kB
   VmLib:      1412 kB
   VmPTE:        20 kb
+  VmSwap:        0 kB
   Threads:        1
   SigQ:   0/28578
   SigPnd: 0000000000000000
@@ -219,6 +220,7 @@ Table 1-2: Contents of the statm files (
  VmExe                       size of text segment
  VmLib                       size of shared library code
  VmPTE                       size of page table entries
+ VmSwap                      size of swap usage (the number of referred swapents)
  Threads                     number of threads
  SigQ                        number of signals queued/max. number for queue
  SigPnd                      bitmap of pending signals for the thread
diff -puN fs/proc/task_mmu.c~mm-count-swap-usage fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-count-swap-usage
+++ a/fs/proc/task_mmu.c
@@ -16,7 +16,7 @@
 
 void task_mem(struct seq_file *m, struct mm_struct *mm)
 {
-	unsigned long data, text, lib;
+	unsigned long data, text, lib, swap;
 	unsigned long hiwater_vm, total_vm, hiwater_rss, total_rss;
 
 	/*
@@ -36,6 +36,7 @@ void task_mem(struct seq_file *m, struct
 	data = mm->total_vm - mm->shared_vm - mm->stack_vm;
 	text = (PAGE_ALIGN(mm->end_code) - (mm->start_code & PAGE_MASK)) >> 10;
 	lib = (mm->exec_vm << (PAGE_SHIFT-10)) - text;
+	swap = get_mm_counter(mm, MM_SWAPENTS);
 	seq_printf(m,
 		"VmPeak:\t%8lu kB\n"
 		"VmSize:\t%8lu kB\n"
@@ -46,7 +47,8 @@ void task_mem(struct seq_file *m, struct
 		"VmStk:\t%8lu kB\n"
 		"VmExe:\t%8lu kB\n"
 		"VmLib:\t%8lu kB\n"
-		"VmPTE:\t%8lu kB\n",
+		"VmPTE:\t%8lu kB\n"
+		"VmSwap:\t%8lu kB\n",
 		hiwater_vm << (PAGE_SHIFT-10),
 		(total_vm - mm->reserved_vm) << (PAGE_SHIFT-10),
 		mm->locked_vm << (PAGE_SHIFT-10),
@@ -54,7 +56,8 @@ void task_mem(struct seq_file *m, struct
 		total_rss << (PAGE_SHIFT-10),
 		data << (PAGE_SHIFT-10),
 		mm->stack_vm << (PAGE_SHIFT-10), text, lib,
-		(PTRS_PER_PTE*sizeof(pte_t)*mm->nr_ptes) >> 10);
+		(PTRS_PER_PTE*sizeof(pte_t)*mm->nr_ptes) >> 10,
+		swap << (PAGE_SHIFT-10));
 }
 
 unsigned long task_vsize(struct mm_struct *mm)
diff -puN include/linux/mm_types.h~mm-count-swap-usage include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-count-swap-usage
+++ a/include/linux/mm_types.h
@@ -198,6 +198,7 @@ struct core_state {
 enum {
 	MM_FILEPAGES,
 	MM_ANONPAGES,
+	MM_SWAPENTS,
 	NR_MM_COUNTERS
 };
 
diff -puN mm/memory.c~mm-count-swap-usage mm/memory.c
--- a/mm/memory.c~mm-count-swap-usage
+++ a/mm/memory.c
@@ -679,7 +679,9 @@ copy_one_pte(struct mm_struct *dst_mm, s
 						 &src_mm->mmlist);
 				spin_unlock(&mmlist_lock);
 			}
-			if (is_write_migration_entry(entry) &&
+			if (likely(!non_swap_entry(entry)))
+				rss[MM_SWAPENTS]++;
+			else if (is_write_migration_entry(entry) &&
 					is_cow_mapping(vm_flags)) {
 				/*
 				 * COW mappings require pages in both parent
@@ -974,9 +976,14 @@ static unsigned long zap_pte_range(struc
 		if (pte_file(ptent)) {
 			if (unlikely(!(vma->vm_flags & VM_NONLINEAR)))
 				print_bad_pte(vma, addr, ptent, NULL);
-		} else if
-		  (unlikely(!free_swap_and_cache(pte_to_swp_entry(ptent))))
-			print_bad_pte(vma, addr, ptent, NULL);
+		} else {
+			swp_entry_t entry = pte_to_swp_entry(ptent);
+
+			if (!non_swap_entry(entry))
+				rss[MM_SWAPENTS]--;
+			if (unlikely(!free_swap_and_cache(entry)))
+				print_bad_pte(vma, addr, ptent, NULL);
+		}
 		pte_clear_not_present_full(mm, addr, pte, tlb->fullmm);
 	} while (pte++, addr += PAGE_SIZE, (addr != end && *zap_work > 0));
 
@@ -2692,6 +2699,7 @@ static int do_swap_page(struct mm_struct
 	 */
 
 	inc_mm_counter_fast(mm, MM_ANONPAGES);
+	dec_mm_counter_fast(mm, MM_SWAPENTS);
 	pte = mk_pte(page, vma->vm_page_prot);
 	if ((flags & FAULT_FLAG_WRITE) && reuse_swap_page(page)) {
 		pte = maybe_mkwrite(pte_mkdirty(pte), vma);
diff -puN mm/rmap.c~mm-count-swap-usage mm/rmap.c
--- a/mm/rmap.c~mm-count-swap-usage
+++ a/mm/rmap.c
@@ -840,6 +840,7 @@ int try_to_unmap_one(struct page *page, 
 				spin_unlock(&mmlist_lock);
 			}
 			dec_mm_counter(mm, MM_ANONPAGES);
+			inc_mm_counter(mm, MM_SWAPENTS);
 		} else if (PAGE_MIGRATION) {
 			/*
 			 * Store the pfn of the page in a special migration
diff -puN mm/swapfile.c~mm-count-swap-usage mm/swapfile.c
--- a/mm/swapfile.c~mm-count-swap-usage
+++ a/mm/swapfile.c
@@ -840,6 +840,7 @@ static int unuse_pte(struct vm_area_stru
 		goto out;
 	}
 
+	dec_mm_counter(vma->vm_mm, MM_SWAPENTS);
 	inc_mm_counter(vma->vm_mm, MM_ANONPAGES);
 	get_page(page);
 	set_pte_at(vma->vm_mm, addr, pte,
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

