From: akpm@linux-foundation.org
Subject: + memcg-optimize-per-cpu-statistics.patch added to -mm tree
Date: Fri, 10 Oct 2008 16:49:16 -0700
Message-ID: <200810102349.m9ANnGpv018355@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57137 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753474AbYJJXuN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Oct 2008 19:50:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: optimize per-cpu statistics
has been added to the -mm tree.  Its filename is
     memcg-optimize-per-cpu-statistics.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: optimize per-cpu statistics
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Some obvious optimization to memcg.

I found mem_cgroup_charge_statistics() is a little big (in object) and
does unnecessary address calclation.  This patch is for optimization to
reduce the size of this function.

And res_counter_charge() is 'likely' to succeed.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff -puN mm/memcontrol.c~memcg-optimize-per-cpu-statistics mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-optimize-per-cpu-statistics
+++ a/mm/memcontrol.c
@@ -66,11 +66,10 @@ struct mem_cgroup_stat {
 /*
  * For accounting under irq disable, no need for increment preempt count.
  */
-static void __mem_cgroup_stat_add_safe(struct mem_cgroup_stat *stat,
+static inline void __mem_cgroup_stat_add_safe(struct mem_cgroup_stat_cpu *stat,
 		enum mem_cgroup_stat_index idx, int val)
 {
-	int cpu = smp_processor_id();
-	stat->cpustat[cpu].count[idx] += val;
+	stat->count[idx] += val;
 }
 
 static s64 mem_cgroup_read_stat(struct mem_cgroup_stat *stat,
@@ -190,18 +189,21 @@ static void mem_cgroup_charge_statistics
 {
 	int val = (charge)? 1 : -1;
 	struct mem_cgroup_stat *stat = &mem->stat;
+	struct mem_cgroup_stat_cpu *cpustat;
 
 	VM_BUG_ON(!irqs_disabled());
+
+	cpustat = &stat->cpustat[smp_processor_id()];
 	if (flags & PAGE_CGROUP_FLAG_CACHE)
-		__mem_cgroup_stat_add_safe(stat, MEM_CGROUP_STAT_CACHE, val);
+		__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_CACHE, val);
 	else
-		__mem_cgroup_stat_add_safe(stat, MEM_CGROUP_STAT_RSS, val);
+		__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_RSS, val);
 
 	if (charge)
-		__mem_cgroup_stat_add_safe(stat,
+		__mem_cgroup_stat_add_safe(cpustat,
 				MEM_CGROUP_STAT_PGPGIN_COUNT, 1);
 	else
-		__mem_cgroup_stat_add_safe(stat,
+		__mem_cgroup_stat_add_safe(cpustat,
 				MEM_CGROUP_STAT_PGPGOUT_COUNT, 1);
 }
 
@@ -558,7 +560,7 @@ static int mem_cgroup_charge_common(stru
 		css_get(&memcg->css);
 	}
 
-	while (res_counter_charge(&mem->res, PAGE_SIZE)) {
+	while (unlikely(res_counter_charge(&mem->res, PAGE_SIZE))) {
 		if (!(gfp_mask & __GFP_WAIT))
 			goto out;
 
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

drivers-mfd-ucb1400_corec-further-unbork.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
vmscan-split-lru-lists-into-anon-file-sets-memcg-fix-handling-of-shmem-migrationv2.patch
vmscan-second-chance-replacement-for-anonymous-pages.patch
unevictable-lru-infrastructure.patch
unevictable-lru-infrastructure-remember-pages-active-state.patch
unevictable-lru-infrastructure-defer-vm-event-counting.patch
unevictable-infrastructure-lru-add-event-counting-with-statistics.patch
shm_locked-pages-are-unevictable-add-event-counts-to-list-scan.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
vmstat-mlocked-pages-statistics-mlocked-pages-add-event-counting-with-statistics.patch
mm-rewrite-vmap-layer-fix-fix.patch
mm-rewrite-vmap-layer-fix-fix-fix.patch
setup_per_zone_pages_min-take-zone-lock-instead-of-zone-lru_lock.patch
documentation-clarify-dirty_ratio-and-dirty_background_ratio-description-v2.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-cgroups-eliminate-race-in-css_set-refcounting.patch
cgroups-convert-tasks-file-to-use-a-seq_file-with-shared-pid-array.patch
memcg-move-charge-swapin-under-lock.patch
memcg-make-page-mapping-null-before-uncharge.patch
memcg-avoid-accounting-special-pages.patch
memcg-optimize-per-cpu-statistics.patch
memcg-atomic-ops-for-page_cgroup-flags.patch
memcg-allocate-all-page_cgroup-at-boot.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-setup-the-memrlimit-controller-mm_owner-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-enhance-mm_owner_changed-callback-to-deal-with-exited-owner.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix-checkpatch-fixes.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-fix-crash-on-fork.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch

