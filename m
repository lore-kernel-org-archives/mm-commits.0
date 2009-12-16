From: akpm@linux-foundation.org
Subject: [merged] memcg-make-memcgs-file-mapped-consistent-with-global-vm.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:37:36 -0800
Message-ID: <200912162037.nBGKbajb013353@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37010 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964830AbZLPUht (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:37:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: make memcg's file mapped consistent with global VM
has been removed from the -mm tree.  Its filename was
     memcg-make-memcgs-file-mapped-consistent-with-global-vm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: make memcg's file mapped consistent with global VM
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

In global VM, FILE_MAPPED is used but memcg uses MAPPED_FILE.  This makes
grep difficult.  Replace memcg's MAPPED_FILE with FILE_MAPPED

And in global VM, mapped shared memory is accounted into FILE_MAPPED.
But memcg doesn't. fix it.
Note:
  page_is_file_cache() just checks SwapBacked or not.
  So, we need to check PageAnon.

Cc: Balbir Singh <balbir@in.ibm.com>
Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    4 ++--
 mm/memcontrol.c            |   21 +++++++++------------
 mm/rmap.c                  |    4 ++--
 3 files changed, 13 insertions(+), 16 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-make-memcgs-file-mapped-consistent-with-global-vm include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-make-memcgs-file-mapped-consistent-with-global-vm
+++ a/include/linux/memcontrol.h
@@ -122,7 +122,7 @@ static inline bool mem_cgroup_disabled(v
 }
 
 extern bool mem_cgroup_oom_called(struct task_struct *task);
-void mem_cgroup_update_mapped_file_stat(struct page *page, int val);
+void mem_cgroup_update_file_mapped(struct page *page, int val);
 unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
 						gfp_t gfp_mask, int nid,
 						int zid);
@@ -287,7 +287,7 @@ mem_cgroup_print_oom_info(struct mem_cgr
 {
 }
 
-static inline void mem_cgroup_update_mapped_file_stat(struct page *page,
+static inline void mem_cgroup_update_file_mapped(struct page *page,
 							int val)
 {
 }
diff -puN mm/memcontrol.c~memcg-make-memcgs-file-mapped-consistent-with-global-vm mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-make-memcgs-file-mapped-consistent-with-global-vm
+++ a/mm/memcontrol.c
@@ -67,7 +67,7 @@ enum mem_cgroup_stat_index {
 	 */
 	MEM_CGROUP_STAT_CACHE, 	   /* # of pages charged as cache */
 	MEM_CGROUP_STAT_RSS,	   /* # of pages charged as anon rss */
-	MEM_CGROUP_STAT_MAPPED_FILE,  /* # of pages charged as file rss */
+	MEM_CGROUP_STAT_FILE_MAPPED,  /* # of pages charged as file rss */
 	MEM_CGROUP_STAT_PGPGIN_COUNT,	/* # of pages paged in */
 	MEM_CGROUP_STAT_PGPGOUT_COUNT,	/* # of pages paged out */
 	MEM_CGROUP_STAT_EVENTS,	/* sum of pagein + pageout for internal use */
@@ -1227,7 +1227,7 @@ static void record_last_oom(struct mem_c
  * Currently used to update mapped file statistics, but the routine can be
  * generalized to update other statistics as well.
  */
-void mem_cgroup_update_mapped_file_stat(struct page *page, int val)
+void mem_cgroup_update_file_mapped(struct page *page, int val)
 {
 	struct mem_cgroup *mem;
 	struct mem_cgroup_stat *stat;
@@ -1235,9 +1235,6 @@ void mem_cgroup_update_mapped_file_stat(
 	int cpu;
 	struct page_cgroup *pc;
 
-	if (!page_is_file_cache(page))
-		return;
-
 	pc = lookup_page_cgroup(page);
 	if (unlikely(!pc))
 		return;
@@ -1257,7 +1254,7 @@ void mem_cgroup_update_mapped_file_stat(
 	stat = &mem->stat;
 	cpustat = &stat->cpustat[cpu];
 
-	__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_MAPPED_FILE, val);
+	__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_FILE_MAPPED, val);
 done:
 	unlock_page_cgroup(pc);
 }
@@ -1654,18 +1651,18 @@ static int mem_cgroup_move_account(struc
 	mem_cgroup_charge_statistics(from, pc, false);
 
 	page = pc->page;
-	if (page_is_file_cache(page) && page_mapped(page)) {
+	if (page_mapped(page) && !PageAnon(page)) {
 		cpu = smp_processor_id();
 		/* Update mapped_file data for mem_cgroup "from" */
 		stat = &from->stat;
 		cpustat = &stat->cpustat[cpu];
-		__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_MAPPED_FILE,
+		__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_FILE_MAPPED,
 						-1);
 
 		/* Update mapped_file data for mem_cgroup "to" */
 		stat = &to->stat;
 		cpustat = &stat->cpustat[cpu];
-		__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_MAPPED_FILE,
+		__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_FILE_MAPPED,
 						1);
 	}
 
@@ -2889,7 +2886,7 @@ static int mem_cgroup_reset(struct cgrou
 enum {
 	MCS_CACHE,
 	MCS_RSS,
-	MCS_MAPPED_FILE,
+	MCS_FILE_MAPPED,
 	MCS_PGPGIN,
 	MCS_PGPGOUT,
 	MCS_SWAP,
@@ -2933,8 +2930,8 @@ static int mem_cgroup_get_local_stat(str
 	s->stat[MCS_CACHE] += val * PAGE_SIZE;
 	val = mem_cgroup_read_stat(&mem->stat, MEM_CGROUP_STAT_RSS);
 	s->stat[MCS_RSS] += val * PAGE_SIZE;
-	val = mem_cgroup_read_stat(&mem->stat, MEM_CGROUP_STAT_MAPPED_FILE);
-	s->stat[MCS_MAPPED_FILE] += val * PAGE_SIZE;
+	val = mem_cgroup_read_stat(&mem->stat, MEM_CGROUP_STAT_FILE_MAPPED);
+	s->stat[MCS_FILE_MAPPED] += val * PAGE_SIZE;
 	val = mem_cgroup_read_stat(&mem->stat, MEM_CGROUP_STAT_PGPGIN_COUNT);
 	s->stat[MCS_PGPGIN] += val;
 	val = mem_cgroup_read_stat(&mem->stat, MEM_CGROUP_STAT_PGPGOUT_COUNT);
diff -puN mm/rmap.c~memcg-make-memcgs-file-mapped-consistent-with-global-vm mm/rmap.c
--- a/mm/rmap.c~memcg-make-memcgs-file-mapped-consistent-with-global-vm
+++ a/mm/rmap.c
@@ -721,7 +721,7 @@ void page_add_file_rmap(struct page *pag
 {
 	if (atomic_inc_and_test(&page->_mapcount)) {
 		__inc_zone_page_state(page, NR_FILE_MAPPED);
-		mem_cgroup_update_mapped_file_stat(page, 1);
+		mem_cgroup_update_file_mapped(page, 1);
 	}
 }
 
@@ -753,8 +753,8 @@ void page_remove_rmap(struct page *page)
 		__dec_zone_page_state(page, NR_ANON_PAGES);
 	} else {
 		__dec_zone_page_state(page, NR_FILE_MAPPED);
+		mem_cgroup_update_file_mapped(page, -1);
 	}
-	mem_cgroup_update_mapped_file_stat(page, -1);
 	/*
 	 * It would be tidy to reset the PageAnon mapping here,
 	 * but that might overwrite a racing page_add_anon_rmap
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
linux-next.patch
mm-add-notifier-in-pageblock-isolation-for-balloon-drivers.patch
powerpc-make-the-cmm-memory-hotplug-aware.patch
powerpc-make-the-cmm-memory-hotplug-aware-update.patch

