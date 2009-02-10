From: akpm@linux-foundation.org
Subject: + memcg-remove-mem_cgroup_calc_mapped_ratio-take2.patch added to -mm tree
Date: Tue, 10 Feb 2009 15:14:01 -0800
Message-ID: <200902102314.n1ANE1J9029325@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44370 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756326AbZBJXOQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Feb 2009 18:14:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, balbir@linux.vnet.ibm.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     memcg: remove mem_cgroup_calc_mapped_ratio()
has been added to the -mm tree.  Its filename is
     memcg-remove-mem_cgroup_calc_mapped_ratio-take2.patch

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
Subject: memcg: remove mem_cgroup_calc_mapped_ratio()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Currently, mem_cgroup_calc_mapped_ratio() is unused at all.  it can be
removed and KAMEZAWA-san suggested it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    6 ------
 mm/memcontrol.c            |   17 -----------------
 2 files changed, 23 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-remove-mem_cgroup_calc_mapped_ratio-take2 include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-remove-mem_cgroup_calc_mapped_ratio-take2
+++ a/include/linux/memcontrol.h
@@ -88,7 +88,6 @@ extern void mem_cgroup_end_migration(str
 /*
  * For memory reclaim.
  */
-extern int mem_cgroup_calc_mapped_ratio(struct mem_cgroup *mem);
 extern long mem_cgroup_reclaim_imbalance(struct mem_cgroup *mem);
 
 extern int mem_cgroup_get_reclaim_priority(struct mem_cgroup *mem);
@@ -211,11 +210,6 @@ static inline void mem_cgroup_end_migrat
 {
 }
 
-static inline int mem_cgroup_calc_mapped_ratio(struct mem_cgroup *mem)
-{
-	return 0;
-}
-
 static inline int mem_cgroup_reclaim_imbalance(struct mem_cgroup *mem)
 {
 	return 0;
diff -puN mm/memcontrol.c~memcg-remove-mem_cgroup_calc_mapped_ratio-take2 mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-mem_cgroup_calc_mapped_ratio-take2
+++ a/mm/memcontrol.c
@@ -508,23 +508,6 @@ int task_in_mem_cgroup(struct task_struc
 }
 
 /*
- * Calculate mapped_ratio under memory controller. This will be used in
- * vmscan.c for deteremining we have to reclaim mapped pages.
- */
-int mem_cgroup_calc_mapped_ratio(struct mem_cgroup *mem)
-{
-	long total, rss;
-
-	/*
-	 * usage is recorded in bytes. But, here, we assume the number of
-	 * physical pages can be represented by "long" on any arch.
-	 */
-	total = (long) (mem->res.usage >> PAGE_SHIFT) + 1L;
-	rss = (long)mem_cgroup_read_stat(&mem->stat, MEM_CGROUP_STAT_RSS);
-	return (int)((rss * 100L) / total);
-}
-
-/*
  * prev_priority control...this will be used in memory reclaim path.
  */
 int mem_cgroup_get_reclaim_priority(struct mem_cgroup *mem)
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

mm-fix-mlocked-page-counter-mismatch.patch
linux-next.patch
mm-fix-memmap-init-to-initialize-valid-memmap-for-memory-hole-fix.patch
get_mm_hiwater_xxx-trivial-s-define-inline.patch
swsusp-clean-up-shrink_all_zones.patch
swsusp-dont-fiddle-with-swappiness.patch
vmscan-rename-scmay_swap-to-may_unmap.patch
mm-introduce-for_each_populated_zone-macro.patch
mm-introduce-for_each_populated_zone-macro-cleanup.patch
getrusage-fill-ru_maxrss-value.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-export-statistics-for-softirq-to-proc-fix.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
memcg-remove-mem_cgroup_calc_mapped_ratio-take2.patch
ia64-implement-interrupt-enabling-rwlocks.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

