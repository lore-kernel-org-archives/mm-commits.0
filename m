From: akpm@linux-foundation.org
Subject: + add-the-pagefault-count-into-memcg-stats.patch added to -mm tree
Date: Tue, 24 May 2011 11:09:45 -0700
Message-ID: <201105241808.p4OI8ISH005881@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55814 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753298Ab1EXSIr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 May 2011 14:08:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yinghan@google.com, balbir@linux.vnet.ibm.com, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: add the pagefault count into memcg stats
has been added to the -mm tree.  Its filename is
     add-the-pagefault-count-into-memcg-stats.patch

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
Subject: memcg: add the pagefault count into memcg stats
From: Ying Han <yinghan@google.com>

Two new stats in per-memcg memory.stat which tracks the number of page
faults and number of major page faults.

"pgfault"
"pgmajfault"

They are different from "pgpgin"/"pgpgout" stat which count number of
pages charged/discharged to the cgroup and have no meaning of reading/
writing page to disk.

It is valuable to track the two stats for both measuring application's
performance as well as the efficiency of the kernel page reclaim path. 
Counting pagefaults per process is useful, but we also need the aggregated
value since processes are monitored and controlled in cgroup basis in
memcg.

Functional test: check the total number of pgfault/pgmajfault of all
memcgs and compare with global vmstat value:

$ cat /proc/vmstat | grep fault
pgfault 1070751
pgmajfault 553

$ cat /dev/cgroup/memory.stat | grep fault
pgfault 1071138
pgmajfault 553
total_pgfault 1071142
total_pgmajfault 553

$ cat /dev/cgroup/A/memory.stat | grep fault
pgfault 199
pgmajfault 0
total_pgfault 199
total_pgmajfault 0

Performance test: run page fault test(pft) wit 16 thread on faulting in
15G anon pages in 16G container.  There is no regression noticed on the
"flt/cpu/s"

Sample output from pft:
TAG pft:anon-sys-default:
  Gb  Thr CLine   User     System     Wall    flt/cpu/s fault/wsec
  15   16   1     0.67s   233.41s    14.76s   16798.546 266356.260

+-------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x  10     16682.962     17344.027     16913.524     16928.812      166.5362
+  10     16695.568     16923.896     16820.604     16824.652     84.816568
No difference proven at 95.0% confidence

[akpm@linux-foundation.org: fix build]
[hughd@google.com: shmem fix]
Signed-off-by: Ying Han <yinghan@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ncpfs/mmap.c            |    2 +
 include/linux/memcontrol.h |    7 +++++
 mm/filemap.c               |    1 
 mm/memcontrol.c            |   47 +++++++++++++++++++++++++++++++++++
 mm/memory.c                |    2 +
 mm/shmem.c                 |   11 ++++----
 6 files changed, 65 insertions(+), 5 deletions(-)

diff -puN fs/ncpfs/mmap.c~add-the-pagefault-count-into-memcg-stats fs/ncpfs/mmap.c
--- a/fs/ncpfs/mmap.c~add-the-pagefault-count-into-memcg-stats
+++ a/fs/ncpfs/mmap.c
@@ -16,6 +16,7 @@
 #include <linux/mman.h>
 #include <linux/string.h>
 #include <linux/fcntl.h>
+#include <linux/memcontrol.h>
 
 #include <asm/uaccess.h>
 #include <asm/system.h>
@@ -92,6 +93,7 @@ static int ncp_file_mmap_fault(struct vm
 	 * -- wli
 	 */
 	count_vm_event(PGMAJFAULT);
+	mem_cgroup_count_vm_event(area->vm_mm, PGMAJFAULT);
 	return VM_FAULT_MAJOR;
 }
 
diff -puN include/linux/memcontrol.h~add-the-pagefault-count-into-memcg-stats include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~add-the-pagefault-count-into-memcg-stats
+++ a/include/linux/memcontrol.h
@@ -20,6 +20,8 @@
 #ifndef _LINUX_MEMCONTROL_H
 #define _LINUX_MEMCONTROL_H
 #include <linux/cgroup.h>
+#include <linux/vm_event_item.h>
+
 struct mem_cgroup;
 struct page_cgroup;
 struct page;
@@ -150,6 +152,7 @@ unsigned long mem_cgroup_soft_limit_recl
 						unsigned long *total_scanned);
 u64 mem_cgroup_get_limit(struct mem_cgroup *mem);
 
+void mem_cgroup_count_vm_event(struct mm_struct *mm, enum vm_event_item idx);
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 void mem_cgroup_split_huge_fixup(struct page *head, struct page *tail);
 #endif
@@ -363,6 +366,10 @@ static inline void mem_cgroup_split_huge
 {
 }
 
+static inline
+void mem_cgroup_count_vm_event(struct mm_struct *mm, enum vm_event_item idx)
+{
+}
 #endif /* CONFIG_CGROUP_MEM_CONT */
 
 #if !defined(CONFIG_CGROUP_MEM_RES_CTLR) || !defined(CONFIG_DEBUG_VM)
diff -puN mm/filemap.c~add-the-pagefault-count-into-memcg-stats mm/filemap.c
--- a/mm/filemap.c~add-the-pagefault-count-into-memcg-stats
+++ a/mm/filemap.c
@@ -1661,6 +1661,7 @@ int filemap_fault(struct vm_area_struct 
 		/* No page in the page cache at all */
 		do_sync_mmap_readahead(vma, ra, file, offset);
 		count_vm_event(PGMAJFAULT);
+		mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
 		ret = VM_FAULT_MAJOR;
 retry_find:
 		page = find_get_page(mapping, offset);
diff -puN mm/memcontrol.c~add-the-pagefault-count-into-memcg-stats mm/memcontrol.c
--- a/mm/memcontrol.c~add-the-pagefault-count-into-memcg-stats
+++ a/mm/memcontrol.c
@@ -94,6 +94,8 @@ enum mem_cgroup_events_index {
 	MEM_CGROUP_EVENTS_PGPGIN,	/* # of pages paged in */
 	MEM_CGROUP_EVENTS_PGPGOUT,	/* # of pages paged out */
 	MEM_CGROUP_EVENTS_COUNT,	/* # of pages paged in/out */
+	MEM_CGROUP_EVENTS_PGFAULT,	/* # of page-faults */
+	MEM_CGROUP_EVENTS_PGMAJFAULT,	/* # of major page-faults */
 	MEM_CGROUP_EVENTS_NSTATS,
 };
 /*
@@ -590,6 +592,16 @@ static void mem_cgroup_swap_statistics(s
 	this_cpu_add(mem->stat->count[MEM_CGROUP_STAT_SWAPOUT], val);
 }
 
+void mem_cgroup_pgfault(struct mem_cgroup *mem, int val)
+{
+	this_cpu_add(mem->stat->events[MEM_CGROUP_EVENTS_PGFAULT], val);
+}
+
+void mem_cgroup_pgmajfault(struct mem_cgroup *mem, int val)
+{
+	this_cpu_add(mem->stat->events[MEM_CGROUP_EVENTS_PGMAJFAULT], val);
+}
+
 static unsigned long mem_cgroup_read_events(struct mem_cgroup *mem,
 					    enum mem_cgroup_events_index idx)
 {
@@ -827,6 +839,33 @@ static inline bool mem_cgroup_is_root(st
 	return (mem == root_mem_cgroup);
 }
 
+void mem_cgroup_count_vm_event(struct mm_struct *mm, enum vm_event_item idx)
+{
+	struct mem_cgroup *mem;
+
+	if (!mm)
+		return;
+
+	rcu_read_lock();
+	mem = mem_cgroup_from_task(rcu_dereference(mm->owner));
+	if (unlikely(!mem))
+		goto out;
+
+	switch (idx) {
+	case PGMAJFAULT:
+		mem_cgroup_pgmajfault(mem, 1);
+		break;
+	case PGFAULT:
+		mem_cgroup_pgfault(mem, 1);
+		break;
+	default:
+		BUG();
+	}
+out:
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL(mem_cgroup_count_vm_event);
+
 /*
  * Following LRU functions are allowed to be used without PCG_LOCK.
  * Operations are called by routine of global LRU independently from memcg.
@@ -3958,6 +3997,8 @@ enum {
 	MCS_PGPGIN,
 	MCS_PGPGOUT,
 	MCS_SWAP,
+	MCS_PGFAULT,
+	MCS_PGMAJFAULT,
 	MCS_INACTIVE_ANON,
 	MCS_ACTIVE_ANON,
 	MCS_INACTIVE_FILE,
@@ -3980,6 +4021,8 @@ struct {
 	{"pgpgin", "total_pgpgin"},
 	{"pgpgout", "total_pgpgout"},
 	{"swap", "total_swap"},
+	{"pgfault", "total_pgfault"},
+	{"pgmajfault", "total_pgmajfault"},
 	{"inactive_anon", "total_inactive_anon"},
 	{"active_anon", "total_active_anon"},
 	{"inactive_file", "total_inactive_file"},
@@ -4008,6 +4051,10 @@ mem_cgroup_get_local_stat(struct mem_cgr
 		val = mem_cgroup_read_stat(mem, MEM_CGROUP_STAT_SWAPOUT);
 		s->stat[MCS_SWAP] += val * PAGE_SIZE;
 	}
+	val = mem_cgroup_read_events(mem, MEM_CGROUP_EVENTS_PGFAULT);
+	s->stat[MCS_PGFAULT] += val;
+	val = mem_cgroup_read_events(mem, MEM_CGROUP_EVENTS_PGMAJFAULT);
+	s->stat[MCS_PGMAJFAULT] += val;
 
 	/* per zone stat */
 	val = mem_cgroup_get_local_zonestat(mem, LRU_INACTIVE_ANON);
diff -puN mm/memory.c~add-the-pagefault-count-into-memcg-stats mm/memory.c
--- a/mm/memory.c~add-the-pagefault-count-into-memcg-stats
+++ a/mm/memory.c
@@ -2874,6 +2874,7 @@ static int do_swap_page(struct mm_struct
 		/* Had to read the page from swap area: Major fault */
 		ret = VM_FAULT_MAJOR;
 		count_vm_event(PGMAJFAULT);
+		mem_cgroup_count_vm_event(mm, PGMAJFAULT);
 	} else if (PageHWPoison(page)) {
 		/*
 		 * hwpoisoned dirty swapcache pages are kept for killing
@@ -3413,6 +3414,7 @@ int handle_mm_fault(struct mm_struct *mm
 	__set_current_state(TASK_RUNNING);
 
 	count_vm_event(PGFAULT);
+	mem_cgroup_count_vm_event(mm, PGFAULT);
 
 	/* do counter updates before entering really critical section. */
 	check_sync_rss_stat(current);
diff -puN mm/shmem.c~add-the-pagefault-count-into-memcg-stats mm/shmem.c
--- a/mm/shmem.c~add-the-pagefault-count-into-memcg-stats
+++ a/mm/shmem.c
@@ -1305,12 +1305,10 @@ repeat:
 		swappage = lookup_swap_cache(swap);
 		if (!swappage) {
 			shmem_swp_unmap(entry);
+			spin_unlock(&info->lock);
 			/* here we actually do the io */
-			if (type && !(*type & VM_FAULT_MAJOR)) {
-				__count_vm_event(PGMAJFAULT);
+			if (type)
 				*type |= VM_FAULT_MAJOR;
-			}
-			spin_unlock(&info->lock);
 			swappage = shmem_swapin(swap, gfp, info, idx);
 			if (!swappage) {
 				spin_lock(&info->lock);
@@ -1549,7 +1547,10 @@ static int shmem_fault(struct vm_area_st
 	error = shmem_getpage(inode, vmf->pgoff, &vmf->page, SGP_CACHE, &ret);
 	if (error)
 		return ((error == -ENOMEM) ? VM_FAULT_OOM : VM_FAULT_SIGBUS);
-
+	if (ret & VM_FAULT_MAJOR) {
+		count_vm_event(PGMAJFAULT);
+		mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
+	}
 	return ret | VM_FAULT_LOCKED;
 }
 
_

Patches currently in -mm which might be from yinghan@google.com are

vmscan-change-shrink_slab-interfaces-by-passing-shrink_control.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix-2.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-2.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-3.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-4.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-count-the-soft_limit-reclaim-in-global-background-reclaim.patch
memcg-add-the-soft_limit-reclaim-in-global-direct-reclaim.patch
memcg-reclaim-memory-from-nodes-in-round-robin-order.patch
memcg-reclaim-memory-from-nodes-in-round-robin-fix.patch
memcg-reclaim-memory-from-nodes-in-round-robin-fix-2.patch
memcg-reclaim-memory-from-nodes-in-round-robin-order-fix.patch
memcg-fix-get_scan_count-for-small-targets.patch
memcg-remove-unused-retry-signal-from-reclaim.patch
memcg-rename-mem_cgroup_zone_nr_pages-to-mem_cgroup_zone_nr_lru_pages.patch
memcg-add-memorynumastat-api-for-numa-statistics.patch
memcg-add-memorynumastat-api-for-numa-statistics-v5.patch
add-the-pagefault-count-into-memcg-stats.patch

