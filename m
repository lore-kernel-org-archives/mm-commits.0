From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged]
 =?US-ASCII?Q?mm-memcontrol-convert-anon-and-file-thp-to-new-mem=5Fcgr?=
 =?US-ASCII?Q?oup=5Fcharge-api-fix.patch?= removed from -mm tree
Date: Wed, 03 Jun 2020 15:17:30 -0700
Message-ID: <20200603221730.mUWTVh762%akpm@linux-foundation.org>
References: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726354AbgFCWRc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 18:17:32 -0400
In-Reply-To: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bsingharora@gmail.com, cai@lca.pw, hannes@cmpxchg.org, mm-commits@vger.kernel.org, sfr@canb.auug.org.au


The patch titled
     Subject: mm-memcontrol-convert-anon-and-file-thp-to-new-mem_cgroup_charge-api-fix
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-convert-anon-and-file-thp-to-new-mem_cgroup_charge-api-fix.patch

This patch was dropped because it was folded into mm-memcontrol-convert-anon-and-file-thp-to-new-mem_cgroup_charge-api.patch

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm-memcontrol-convert-anon-and-file-thp-to-new-mem_cgroup_charge-api-fix

Fix crash.  If you have CONFIG_NUMA and the allocation fails, *hpage could
contain an ERR_PTR instead of being NULL.

Link: http://lkml.kernel.org/r/20200512215813.GA487759@cmpxchg.org
Reported-by: Qian Cai <cai@lca.pw>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Balbir Singh <bsingharora@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/khugepaged.c~mm-memcontrol-convert-anon-and-file-thp-to-new-mem_cgroup_charge-api-fix
+++ a/mm/khugepaged.c
@@ -1186,7 +1186,7 @@ static void collapse_huge_page(struct mm
 out_up_write:
 	up_write(&mm->mmap_sem);
 out_nolock:
-	if (*hpage)
+	if (!IS_ERR_OR_NULL(*hpage))
 		mem_cgroup_uncharge(*hpage);
 	trace_mm_collapse_huge_page(mm, isolated, result);
 	return;
@@ -1938,7 +1938,7 @@ xa_unlocked:
 	unlock_page(new_page);
 out:
 	VM_BUG_ON(!list_empty(&pagelist));
-	if (*hpage)
+	if (!IS_ERR_OR_NULL(*hpage))
 		mem_cgroup_uncharge(*hpage);
 	/* TODO: tracepoints */
 }
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-fix-numa-node-file-count-error-in-replace_page_cache.patch
mm-memcontrol-fix-stat-corrupting-race-in-charge-moving.patch
mm-memcontrol-drop-compound-parameter-from-memcg-charging-api.patch
mm-shmem-remove-rare-optimization-when-swapin-races-with-hole-punching.patch
mm-memcontrol-move-out-cgroup-swaprate-throttling.patch
mm-memcontrol-convert-page-cache-to-a-new-mem_cgroup_charge-api.patch
mm-memcontrol-prepare-uncharging-for-removal-of-private-page-type-counters.patch
mm-memcontrol-prepare-move_account-for-removal-of-private-page-type-counters.patch
mm-memcontrol-prepare-cgroup-vmstat-infrastructure-for-native-anon-counters.patch
mm-memcontrol-switch-to-native-nr_file_pages-and-nr_shmem-counters.patch
mm-memcontrol-switch-to-native-nr_anon_mapped-counter.patch
mm-memcontrol-switch-to-native-nr_anon_thps-counter.patch
mm-memcontrol-convert-anon-and-file-thp-to-new-mem_cgroup_charge-api.patch
mm-memcontrol-drop-unused-try-commit-cancel-charge-api.patch
mm-memcontrol-prepare-swap-controller-setup-for-integration.patch
mm-memcontrol-make-swap-tracking-an-integral-part-of-memory-control.patch
mm-memcontrol-make-swap-tracking-an-integral-part-of-memory-control-fix-v2.patch
mm-memcontrol-charge-swapin-pages-on-instantiation.patch
mm-memcontrol-delete-unused-lrucare-handling.patch
mm-memcontrol-update-page-mem_cgroup-stability-rules.patch
mm-fix-lru-balancing-effect-of-new-transparent-huge-pages.patch
mm-keep-separate-anon-and-file-statistics-on-page-reclaim-activity.patch
mm-allow-swappiness-that-prefers-reclaiming-anon-over-the-file-workingset.patch
mm-fold-and-remove-lru_cache_add_anon-and-lru_cache_add_file.patch
mm-workingset-let-cache-workingset-challenge-anon.patch
mm-remove-use-once-cache-bias-from-lru-balancing.patch
mm-vmscan-drop-unnecessary-div0-avoidance-rounding-in-get_scan_count.patch
mm-base-lru-balancing-on-an-explicit-cost-model.patch
mm-deactivations-shouldnt-bias-the-lru-balance.patch
mm-only-count-actual-rotations-as-lru-reclaim-cost.patch
mm-balance-lru-lists-based-on-relative-thrashing.patch
mm-vmscan-determine-anon-file-pressure-balance-at-the-reclaim-root.patch
mm-vmscan-reclaim-writepage-is-io-cost.patch
mm-vmscan-limit-the-range-of-lru-type-balancing.patch
