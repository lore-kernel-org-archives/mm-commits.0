From: akpm@linux-foundation.org
Subject: + mm-remove-up-version-lru_add_drain_all.patch added to -mm tree
Date: Sat, 06 Dec 2008 23:07:22 -0800
Message-ID: <200812070707.mB777Mvv013874@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50539 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752143AbYLGHHe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 7 Dec 2008 02:07:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, Lee.Schermerhorn@hp.com, cl@linux-foundation.org, dave@linux.vnet.ibm.com, gerald.schaefer@de.ibm.com


The patch titled
     mm: remove UP version of lru_add_drain_all()
has been added to the -mm tree.  Its filename is
     mm-remove-up-version-lru_add_drain_all.patch

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
Subject: mm: remove UP version of lru_add_drain_all()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Currently, lru_add_drain_all() has two version.
  (1) use schedule_on_each_cpu()
  (2) don't use schedule_on_each_cpu()

Gerald Schaefer reported it doesn't works well on SMP (not NUMA) S390 machine.

  offline_pages() calls lru_add_drain_all() followed by drain_all_pages().
  While drain_all_pages() works on each cpu, lru_add_drain_all() only runs
  on the current cpu for architectures w/o CONFIG_NUMA. This let us run
  into the BUG_ON(!PageBuddy(page)) in __offline_isolated_pages() during
  memory hotplug stress test on s390. The page in question was still on the
  pcp list, because of a race with lru_add_drain_all() and drain_all_pages()
  on different cpus.

Actually, Almost machine has CONFIG_UNEVICTABLE_LRU=y. Then almost machine use
(1) version lru_add_drain_all although the machine is UP.

Then this ifdef is not valueable.
simple removing is better.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Acked-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   13 -------------
 1 file changed, 13 deletions(-)

diff -puN mm/swap.c~mm-remove-up-version-lru_add_drain_all mm/swap.c
--- a/mm/swap.c~mm-remove-up-version-lru_add_drain_all
+++ a/mm/swap.c
@@ -299,7 +299,6 @@ void lru_add_drain(void)
 	put_cpu();
 }
 
-#if defined(CONFIG_NUMA) || defined(CONFIG_UNEVICTABLE_LRU)
 static void lru_add_drain_per_cpu(struct work_struct *dummy)
 {
 	lru_add_drain();
@@ -313,18 +312,6 @@ int lru_add_drain_all(void)
 	return schedule_on_each_cpu(lru_add_drain_per_cpu);
 }
 
-#else
-
-/*
- * Returns 0 for success
- */
-int lru_add_drain_all(void)
-{
-	lru_add_drain();
-	return 0;
-}
-#endif
-
 /*
  * Batched page_cache_release().  Decrement the reference count on all the
  * passed pages.  If it fell to zero then remove the page from the LRU and
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
mm-remove-up-version-lru_add_drain_all.patch
linux-next.patch
arch-ia64-kernel-iosapicc-fix-warnings.patch
mm-report-the-pagesize-backing-a-vma-in-proc-pid-smaps.patch
mm-report-the-mmu-pagesize-in-proc-pid-smaps.patch
oom-fix-zone_scan_mutex-name.patch
mm-get-rid-of-pagevec_release_nonlru.patch
cleanup-get-rid-of-ifdef-config_migration.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
mm-make-page_lock_anon_vma-static.patch
memcg-reclaim-shouldnt-change-zone-recent_rotated-statistics.patch
mm-make-init_section_page_cgroup-static.patch
mm-make-maddr-__iomem.patch
mm-make-mem_cgroup_resize_limit-static.patch
mm-make-scan_all_zones_unevictable_pages-static.patch
mm-make-scan_zone_unevictable_pages-static.patch
mm-make-setup_per_zone_inactive_ratio-static.patch
mm-make-vread-and-vwrite-declaration.patch
vmscan-bail-out-of-direct-reclaim-after-swap_cluster_max-pages.patch
vmscan-improve-reclaim-throughput-to-bail-out-patch.patch
mm-kill-zone_is_near_oom.patch
mm-make-get_user_pages-interruptible.patch
mm-make-get_user_pages-interruptible-mmotm-ignore-sigkill-in-get_user_pages-during-munlock.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
memcg-new-force_empty-to-free-pages-under-group-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
memcg-revert-gfp-mask-fix.patch
memcg-check-group-leader-fix.patch
memcg-memoryswap-controller-fix-limit-check.patch
memcg-swapout-refcnt-fix.patch
memcg-hierarchy-avoid-unnecessary-reclaim.patch
inactive_anon_is_low-move-to-vmscan.patch
mm-introduce-zone_reclaim-struct.patch
mm-add-zone-nr_pages-helper-function.patch
mm-make-get_scan_ratio-safe-for-memcg.patch
memcg-add-null-check-to-page_cgroup_zoneinfo.patch
memcg-add-inactive_anon_is_low.patch
memcg-add-mem_cgroup_zone_nr_pages.patch
memcg-add-zone_reclaim_stat.patch
memcg-remove-mem_cgroup_cal_reclaim.patch
memcg-show-reclaim-stat.patch
memcg-rename-scan-global-lru.patch
memcg-protect-prev_priority.patch
memcg-swappiness.patch
memcg-explain-details-and-test-document.patch

