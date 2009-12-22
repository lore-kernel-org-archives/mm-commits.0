From: akpm@linux-foundation.org
Subject: + mm-count-swap-usage.patch added to -mm tree
Date: Mon, 21 Dec 2009 16:56:28 -0800
Message-ID: <200912220056.nBM0uSBn006752@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44975 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751008AbZLVA4g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Dec 2009 19:56:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, cl@linux-foundation.org, lee.schermerhorn@hp.com, minchan.kim@gmail.com, rientjes@google.com


The patch titled
     mm: count swap usage
has been added to the -mm tree.  Its filename is
     mm-count-swap-usage.patch

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
@@ -220,6 +221,7 @@ Table 1-2: Contents of the statm files (
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
@@ -196,6 +196,7 @@ struct core_state {
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
+		  	if (unlikely(!free_swap_and_cache(entry)))
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

mm-add-notifier-in-pageblock-isolation-for-balloon-drivers.patch
powerpc-make-the-cmm-memory-hotplug-aware.patch
mm-clean-up-mm_counter.patch
mm-avoid-false-sharing-of-mm_counter.patch
mm-count-swap-usage.patch
mm-add-lowmem-detection-logic.patch
mm-count-lowmem-rss.patch

