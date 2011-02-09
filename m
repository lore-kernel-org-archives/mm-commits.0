From: akpm@linux-foundation.org
Subject: + memcg-remove-memcg-reclaim_param_lock.patch added to -mm tree
Date: Wed, 09 Feb 2011 13:39:55 -0800
Message-ID: <201102092139.p19Ldt6O023698@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60312 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755823Ab1BIVkG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Feb 2011 16:40:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: remove memcg->reclaim_param_lock
has been added to the -mm tree.  Its filename is
     memcg-remove-memcg-reclaim_param_lock.patch

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
Subject: memcg: remove memcg->reclaim_param_lock
From: Johannes Weiner <hannes@cmpxchg.org>

The reclaim_param_lock is only taken around single reads and writes to
integer variables and is thus superfluous.  Drop it.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff -puN mm/memcontrol.c~memcg-remove-memcg-reclaim_param_lock mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-memcg-reclaim_param_lock
+++ a/mm/memcontrol.c
@@ -218,12 +218,6 @@ struct mem_cgroup {
 	 * per zone LRU lists.
 	 */
 	struct mem_cgroup_lru_info info;
-
-	/*
-	  protect against reclaim related member.
-	*/
-	spinlock_t reclaim_param_lock;
-
 	/*
 	 * While reclaiming in a hierarchy, we cache the last child we
 	 * reclaimed from.
@@ -1104,17 +1098,12 @@ static unsigned long long mem_cgroup_mar
 static unsigned int get_swappiness(struct mem_cgroup *memcg)
 {
 	struct cgroup *cgrp = memcg->css.cgroup;
-	unsigned int swappiness;
 
 	/* root ? */
 	if (cgrp->parent == NULL)
 		return vm_swappiness;
 
-	spin_lock(&memcg->reclaim_param_lock);
-	swappiness = memcg->swappiness;
-	spin_unlock(&memcg->reclaim_param_lock);
-
-	return swappiness;
+	return memcg->swappiness;
 }
 
 static void mem_cgroup_start_move(struct mem_cgroup *mem)
@@ -1330,13 +1319,11 @@ mem_cgroup_select_victim(struct mem_cgro
 
 		rcu_read_unlock();
 		/* Updates scanning parameter */
-		spin_lock(&root_mem->reclaim_param_lock);
 		if (!css) {
 			/* this means start scan from ID:1 */
 			root_mem->last_scanned_child = 0;
 		} else
 			root_mem->last_scanned_child = found;
-		spin_unlock(&root_mem->reclaim_param_lock);
 	}
 
 	return ret;
@@ -3842,9 +3829,7 @@ static int mem_cgroup_swappiness_write(s
 		return -EINVAL;
 	}
 
-	spin_lock(&memcg->reclaim_param_lock);
 	memcg->swappiness = val;
-	spin_unlock(&memcg->reclaim_param_lock);
 
 	cgroup_unlock();
 
@@ -4500,7 +4485,6 @@ mem_cgroup_create(struct cgroup_subsys *
 		res_counter_init(&mem->memsw, NULL);
 	}
 	mem->last_scanned_child = 0;
-	spin_lock_init(&mem->reclaim_param_lock);
 	INIT_LIST_HEAD(&mem->oom_notify);
 
 	if (parent)
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

vmscan-fix-zone-shrinking-exit-when-scan-work-is-done.patch
mm-introduce-delete_from_page_cache.patch
mm-hugetlbfs-change-remove_from_page_cache.patch
mm-shmem-change-remove_from_page_cache.patch
mm-truncate-change-remove_from_page_cache.patch
mm-good-bye-remove_from_page_cache.patch
mm-change-__remove_from_page_cache.patch
mm-batch-free-pcp-list-if-possible.patch
mm-batch-free-pcp-list-if-possible-fix.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path-fix.patch
memcg-res_counter_read_u64-fix-potential-races-on-32-bit-machines.patch
memcg-fix-ugly-initialization-of-return-value-is-in-caller.patch
memcg-soft-limit-reclaim-should-end-at-limit-not-below.patch
memcg-simplify-the-way-memory-limits-are-checked.patch
memcg-remove-unused-page-flag-bitfield-defines.patch
memcg-remove-impossible-conditional-when-committing.patch
memcg-remove-null-check-from-lookup_page_cgroup-result.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages-update.patch
memcg-no-uncharged-pages-reach-page_cgroup_zoneinfo.patch
memcg-change-page_cgroup_zoneinfo-signature.patch
memcg-fold-__mem_cgroup_move_account-into-caller.patch
memcg-condense-page_cgroup-to-page-lookup-points.patch
memcg-remove-direct-page_cgroup-to-page-pointer.patch
memcg-remove-direct-page_cgroup-to-page-pointer-fix.patch
memcg-remove-direct-page_cgroup-to-page-pointer-fix-fix.patch
memcg-charged-pages-always-have-valid-per-memcg-zone-info.patch
memcg-remove-memcg-reclaim_param_lock.patch
memcg-keep-only-one-charge-cancelling-function.patch
memcg-convert-per-cpu-stock-from-bytes-to-page-granularity.patch
memcg-convert-uncharge-batching-from-bytes-to-page-granularity.patch
memcg-unify-charge-uncharge-quantities-to-units-of-pages.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch

