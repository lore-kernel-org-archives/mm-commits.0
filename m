From: akpm@linux-foundation.org
Subject: + memcg-create-extensible-page-stat-update-routines.patch added to -mm tree
Date: Fri, 29 Oct 2010 13:19:43 -0700
Message-ID: <201010292019.o9TKJhAw014953@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49319 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759243Ab0J2UUU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Oct 2010 16:20:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gthelen@google.com, arighi@develer.com, balbir@linux.vnet.ibm.com, fengguang.wu@intel.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: create extensible page stat update routines
has been added to the -mm tree.  Its filename is
     memcg-create-extensible-page-stat-update-routines.patch

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
Subject: memcg: create extensible page stat update routines
From: Greg Thelen <gthelen@google.com>

Replace usage of the mem_cgroup_update_file_mapped() memcg
statistic update routine with two new routines:
* mem_cgroup_inc_page_stat()
* mem_cgroup_dec_page_stat()

As before, only the file_mapped statistic is managed.  However, these more
general interfaces allow for new statistics to be more easily added.  New
statistics are added with memcg dirty page accounting.

Signed-off-by: Greg Thelen <gthelen@google.com>
Signed-off-by: Andrea Righi <arighi@develer.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   31 ++++++++++++++++++++++++++++---
 mm/memcontrol.c            |   16 +++++++---------
 mm/rmap.c                  |    4 ++--
 3 files changed, 37 insertions(+), 14 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-create-extensible-page-stat-update-routines include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-create-extensible-page-stat-update-routines
+++ a/include/linux/memcontrol.h
@@ -25,6 +25,11 @@ struct page_cgroup;
 struct page;
 struct mm_struct;
 
+/* Stats that can be updated by kernel. */
+enum mem_cgroup_page_stat_item {
+	MEMCG_NR_FILE_MAPPED, /* # of pages charged as file rss */
+};
+
 extern unsigned long mem_cgroup_isolate_pages(unsigned long nr_to_scan,
 					struct list_head *dst,
 					unsigned long *scanned, int order,
@@ -121,7 +126,22 @@ static inline bool mem_cgroup_disabled(v
 	return false;
 }
 
-void mem_cgroup_update_file_mapped(struct page *page, int val);
+void mem_cgroup_update_page_stat(struct page *page,
+				 enum mem_cgroup_page_stat_item idx,
+				 int val);
+
+static inline void mem_cgroup_inc_page_stat(struct page *page,
+					    enum mem_cgroup_page_stat_item idx)
+{
+	mem_cgroup_update_page_stat(page, idx, 1);
+}
+
+static inline void mem_cgroup_dec_page_stat(struct page *page,
+					    enum mem_cgroup_page_stat_item idx)
+{
+	mem_cgroup_update_page_stat(page, idx, -1);
+}
+
 unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
 						gfp_t gfp_mask);
 u64 mem_cgroup_get_limit(struct mem_cgroup *mem);
@@ -293,8 +313,13 @@ mem_cgroup_print_oom_info(struct mem_cgr
 {
 }
 
-static inline void mem_cgroup_update_file_mapped(struct page *page,
-							int val)
+static inline void mem_cgroup_inc_page_stat(struct page *page,
+					    enum mem_cgroup_page_stat_item idx)
+{
+}
+
+static inline void mem_cgroup_dec_page_stat(struct page *page,
+					    enum mem_cgroup_page_stat_item idx)
 {
 }
 
diff -puN mm/memcontrol.c~memcg-create-extensible-page-stat-update-routines mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-create-extensible-page-stat-update-routines
+++ a/mm/memcontrol.c
@@ -1592,7 +1592,8 @@ bool mem_cgroup_handle_oom(struct mem_cg
  * possibility of race condition. If there is, we take a lock.
  */
 
-static void mem_cgroup_update_file_stat(struct page *page, int idx, int val)
+void mem_cgroup_update_page_stat(struct page *page,
+				 enum mem_cgroup_page_stat_item idx, int val)
 {
 	struct mem_cgroup *mem;
 	struct page_cgroup *pc = lookup_page_cgroup(page);
@@ -1615,30 +1616,27 @@ static void mem_cgroup_update_file_stat(
 			goto out;
 	}
 
-	this_cpu_add(mem->stat->count[idx], val);
-
 	switch (idx) {
-	case MEM_CGROUP_STAT_FILE_MAPPED:
+	case MEMCG_NR_FILE_MAPPED:
 		if (val > 0)
 			SetPageCgroupFileMapped(pc);
 		else if (!page_mapped(page))
 			ClearPageCgroupFileMapped(pc);
+		idx = MEM_CGROUP_STAT_FILE_MAPPED;
 		break;
 	default:
 		BUG();
 	}
 
+	this_cpu_add(mem->stat->count[idx], val);
+
 out:
 	if (unlikely(need_unlock))
 		unlock_page_cgroup(pc);
 	rcu_read_unlock();
 	return;
 }
-
-void mem_cgroup_update_file_mapped(struct page *page, int val)
-{
-	mem_cgroup_update_file_stat(page, MEM_CGROUP_STAT_FILE_MAPPED, val);
-}
+EXPORT_SYMBOL(mem_cgroup_update_page_stat);
 
 /*
  * size of first charge trial. "32" comes from vmscan.c's magic value.
diff -puN mm/rmap.c~memcg-create-extensible-page-stat-update-routines mm/rmap.c
--- a/mm/rmap.c~memcg-create-extensible-page-stat-update-routines
+++ a/mm/rmap.c
@@ -911,7 +911,7 @@ void page_add_file_rmap(struct page *pag
 {
 	if (atomic_inc_and_test(&page->_mapcount)) {
 		__inc_zone_page_state(page, NR_FILE_MAPPED);
-		mem_cgroup_update_file_mapped(page, 1);
+		mem_cgroup_inc_page_stat(page, MEMCG_NR_FILE_MAPPED);
 	}
 }
 
@@ -949,7 +949,7 @@ void page_remove_rmap(struct page *page)
 		__dec_zone_page_state(page, NR_ANON_PAGES);
 	} else {
 		__dec_zone_page_state(page, NR_FILE_MAPPED);
-		mem_cgroup_update_file_mapped(page, -1);
+		mem_cgroup_dec_page_stat(page, MEMCG_NR_FILE_MAPPED);
 	}
 	/*
 	 * It would be tidy to reset the PageAnon mapping here,
_

Patches currently in -mm which might be from gthelen@google.com are

origin.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
memcg-create-extensible-page-stat-update-routines.patch
memcg-add-lock-to-synchronize-page-accounting-and-migration.patch
writeback-create-dirty_info-structure.patch
memcg-add-dirty-page-accounting-infrastructure.patch
memcg-add-kernel-calls-for-memcg-dirty-page-stats.patch
memcg-add-dirty-limits-to-mem_cgroup.patch
memcg-cpu-hotplug-lockdep-warning-fix.patch
memcg-add-cgroupfs-interface-to-memcg-dirty-limits.patch
memcg-check-memcg-dirty-limits-in-page-writeback.patch

