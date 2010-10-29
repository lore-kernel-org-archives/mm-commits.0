From: akpm@linux-foundation.org
Subject: + memcg-add-dirty-page-accounting-infrastructure.patch added to -mm tree
Date: Fri, 29 Oct 2010 13:19:49 -0700
Message-ID: <201010292019.o9TKJn9D014965@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54368 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761858Ab0J2U0q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Oct 2010 16:26:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gthelen@google.com, arighi@develer.com, balbir@linux.vnet.ibm.com, fengguang.wu@intel.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: add dirty page accounting infrastructure
has been added to the -mm tree.  Its filename is
     memcg-add-dirty-page-accounting-infrastructure.patch

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
Subject: memcg: add dirty page accounting infrastructure
From: Greg Thelen <gthelen@google.com>

Add memcg routines to track dirty, writeback, and unstable_NFS pages. 
These routines are not yet used by the kernel to count such pages.  A
later change adds kernel calls to these new routines.

Signed-off-by: Greg Thelen <gthelen@google.com>
Signed-off-by: Andrea Righi <arighi@develer.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    3 +
 mm/memcontrol.c            |   86 +++++++++++++++++++++++++++++++----
 2 files changed, 81 insertions(+), 8 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-add-dirty-page-accounting-infrastructure include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-add-dirty-page-accounting-infrastructure
+++ a/include/linux/memcontrol.h
@@ -28,6 +28,9 @@ struct mm_struct;
 /* Stats that can be updated by kernel. */
 enum mem_cgroup_page_stat_item {
 	MEMCG_NR_FILE_MAPPED, /* # of pages charged as file rss */
+	MEMCG_NR_FILE_DIRTY, /* # of dirty pages in page cache */
+	MEMCG_NR_FILE_WRITEBACK, /* # of pages under writeback */
+	MEMCG_NR_FILE_UNSTABLE_NFS, /* # of NFS unstable pages */
 };
 
 extern unsigned long mem_cgroup_isolate_pages(unsigned long nr_to_scan,
diff -puN mm/memcontrol.c~memcg-add-dirty-page-accounting-infrastructure mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-dirty-page-accounting-infrastructure
+++ a/mm/memcontrol.c
@@ -85,10 +85,13 @@ enum mem_cgroup_stat_index {
 	 */
 	MEM_CGROUP_STAT_CACHE, 	   /* # of pages charged as cache */
 	MEM_CGROUP_STAT_RSS,	   /* # of pages charged as anon rss */
-	MEM_CGROUP_STAT_FILE_MAPPED,  /* # of pages charged as file rss */
 	MEM_CGROUP_STAT_PGPGIN_COUNT,	/* # of pages paged in */
 	MEM_CGROUP_STAT_PGPGOUT_COUNT,	/* # of pages paged out */
 	MEM_CGROUP_STAT_SWAPOUT, /* # of pages, swapped out */
+	MEM_CGROUP_STAT_FILE_MAPPED,  /* # of pages charged as file rss */
+	MEM_CGROUP_STAT_FILE_DIRTY,	/* # of dirty pages in page cache */
+	MEM_CGROUP_STAT_FILE_WRITEBACK,		/* # of pages under writeback */
+	MEM_CGROUP_STAT_FILE_UNSTABLE_NFS,	/* # of NFS unstable pages */
 	MEM_CGROUP_STAT_DATA, /* end of data requires synchronization */
 	/* incremented at every  pagein/pageout */
 	MEM_CGROUP_EVENTS = MEM_CGROUP_STAT_DATA,
@@ -1625,6 +1628,44 @@ void mem_cgroup_update_page_stat(struct 
 			ClearPageCgroupFileMapped(pc);
 		idx = MEM_CGROUP_STAT_FILE_MAPPED;
 		break;
+
+	case MEMCG_NR_FILE_DIRTY:
+		/* Use Test{Set,Clear} to only un/charge the memcg once. */
+		if (val > 0) {
+			if (TestSetPageCgroupFileDirty(pc))
+				val = 0;
+		} else {
+			if (!TestClearPageCgroupFileDirty(pc))
+				val = 0;
+		}
+		idx = MEM_CGROUP_STAT_FILE_DIRTY;
+		break;
+
+	case MEMCG_NR_FILE_WRITEBACK:
+		/*
+		 * This counter is adjusted while holding the mapping's
+		 * tree_lock.  Therefore there is no race between settings and
+		 * clearing of this flag.
+		 */
+		if (val > 0)
+			SetPageCgroupFileWriteback(pc);
+		else
+			ClearPageCgroupFileWriteback(pc);
+		idx = MEM_CGROUP_STAT_FILE_WRITEBACK;
+		break;
+
+	case MEMCG_NR_FILE_UNSTABLE_NFS:
+		/* Use Test{Set,Clear} to only un/charge the memcg once. */
+		if (val > 0) {
+			if (TestSetPageCgroupFileUnstableNFS(pc))
+				val = 0;
+		} else {
+			if (!TestClearPageCgroupFileUnstableNFS(pc))
+				val = 0;
+		}
+		idx = MEM_CGROUP_STAT_FILE_UNSTABLE_NFS;
+		break;
+
 	default:
 		BUG();
 	}
@@ -2129,6 +2170,17 @@ static void __mem_cgroup_commit_charge(s
 	memcg_check_events(mem, pc->page);
 }
 
+static inline
+void mem_cgroup_move_account_page_stat(struct mem_cgroup *from,
+				       struct mem_cgroup *to,
+				       enum mem_cgroup_stat_index idx)
+{
+	preempt_disable();
+	__this_cpu_dec(from->stat->count[idx]);
+	__this_cpu_inc(to->stat->count[idx]);
+	preempt_enable();
+}
+
 /**
  * __mem_cgroup_move_account - move account of the page
  * @pc:	page_cgroup of the page.
@@ -2155,13 +2207,18 @@ static void __mem_cgroup_move_account(st
 	VM_BUG_ON(!PageCgroupUsed(pc));
 	VM_BUG_ON(pc->mem_cgroup != from);
 
-	if (PageCgroupFileMapped(pc)) {
-		/* Update mapped_file data for mem_cgroup */
-		preempt_disable();
-		__this_cpu_dec(from->stat->count[MEM_CGROUP_STAT_FILE_MAPPED]);
-		__this_cpu_inc(to->stat->count[MEM_CGROUP_STAT_FILE_MAPPED]);
-		preempt_enable();
-	}
+	if (PageCgroupFileMapped(pc))
+		mem_cgroup_move_account_page_stat(from, to,
+					MEM_CGROUP_STAT_FILE_MAPPED);
+	if (PageCgroupFileDirty(pc))
+		mem_cgroup_move_account_page_stat(from, to,
+					MEM_CGROUP_STAT_FILE_DIRTY);
+	if (PageCgroupFileWriteback(pc))
+		mem_cgroup_move_account_page_stat(from, to,
+					MEM_CGROUP_STAT_FILE_WRITEBACK);
+	if (PageCgroupFileUnstableNFS(pc))
+		mem_cgroup_move_account_page_stat(from, to,
+					MEM_CGROUP_STAT_FILE_UNSTABLE_NFS);
 	mem_cgroup_charge_statistics(from, pc, false);
 	if (uncharge)
 		/* This is not "cancel", but cancel_charge does all we need. */
@@ -3540,6 +3597,9 @@ enum {
 	MCS_PGPGIN,
 	MCS_PGPGOUT,
 	MCS_SWAP,
+	MCS_FILE_DIRTY,
+	MCS_WRITEBACK,
+	MCS_UNSTABLE_NFS,
 	MCS_INACTIVE_ANON,
 	MCS_ACTIVE_ANON,
 	MCS_INACTIVE_FILE,
@@ -3562,6 +3622,9 @@ struct {
 	{"pgpgin", "total_pgpgin"},
 	{"pgpgout", "total_pgpgout"},
 	{"swap", "total_swap"},
+	{"dirty", "total_dirty"},
+	{"writeback", "total_writeback"},
+	{"nfs_unstable", "total_nfs_unstable"},
 	{"inactive_anon", "total_inactive_anon"},
 	{"active_anon", "total_active_anon"},
 	{"inactive_file", "total_inactive_file"},
@@ -3591,6 +3654,13 @@ mem_cgroup_get_local_stat(struct mem_cgr
 		s->stat[MCS_SWAP] += val * PAGE_SIZE;
 	}
 
+	val = mem_cgroup_read_stat(mem, MEM_CGROUP_STAT_FILE_DIRTY);
+	s->stat[MCS_FILE_DIRTY] += val * PAGE_SIZE;
+	val = mem_cgroup_read_stat(mem, MEM_CGROUP_STAT_FILE_WRITEBACK);
+	s->stat[MCS_WRITEBACK] += val * PAGE_SIZE;
+	val = mem_cgroup_read_stat(mem, MEM_CGROUP_STAT_FILE_UNSTABLE_NFS);
+	s->stat[MCS_UNSTABLE_NFS] += val * PAGE_SIZE;
+
 	/* per zone stat */
 	val = mem_cgroup_get_local_zonestat(mem, LRU_INACTIVE_ANON);
 	s->stat[MCS_INACTIVE_ANON] += val * PAGE_SIZE;
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

