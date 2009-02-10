From: akpm@linux-foundation.org
Subject: + memcg-remove-mem_cgroup_reclaim_imbalance-remnants.patch added to -mm tree
Date: Tue, 10 Feb 2009 15:15:45 -0800
Message-ID: <200902102315.n1ANFjh0031638@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41357 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755909AbZBJXPu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Feb 2009 18:15:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     memcg: remove mem_cgroup_reclaim_imbalance() remnants
has been added to the -mm tree.  Its filename is
     memcg-remove-mem_cgroup_reclaim_imbalance-remnants.patch

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
Subject: memcg: remove mem_cgroup_reclaim_imbalance() remnants
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

commit 4f98a2fee8acdb4ac84545df98cccecfd130f8db (vmscan: split LRU lists
into anon & file sets) removed mem_cgroup_reclaim_imbalance(), but there
are some leftovers in memcontrol.h.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    7 -------
 1 file changed, 7 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-remove-mem_cgroup_reclaim_imbalance-remnants include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-remove-mem_cgroup_reclaim_imbalance-remnants
+++ a/include/linux/memcontrol.h
@@ -88,8 +88,6 @@ extern void mem_cgroup_end_migration(str
 /*
  * For memory reclaim.
  */
-extern long mem_cgroup_reclaim_imbalance(struct mem_cgroup *mem);
-
 extern int mem_cgroup_get_reclaim_priority(struct mem_cgroup *mem);
 extern void mem_cgroup_note_reclaim_priority(struct mem_cgroup *mem,
 							int priority);
@@ -210,11 +208,6 @@ static inline void mem_cgroup_end_migrat
 {
 }
 
-static inline int mem_cgroup_reclaim_imbalance(struct mem_cgroup *mem)
-{
-	return 0;
-}
-
 static inline int mem_cgroup_get_reclaim_priority(struct mem_cgroup *mem)
 {
 	return 0;
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
memcg-remove-mem_cgroup_reclaim_imbalance-remnants.patch
ia64-implement-interrupt-enabling-rwlocks.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

