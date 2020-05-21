From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 =?US-ASCII?Q?mm-allow-swappiness-that-prefers-reclaiming-anon-over-the-f?=
 =?US-ASCII?Q?ile-workingset.patch?= added to -mm tree
Date: Wed, 20 May 2020 20:31:49 -0700
Message-ID: <20200521033149.EqT3ATBEJ%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727998AbgEUDbv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 20 May 2020 23:31:51 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, riel@redhat.com


The patch titled
     Subject: mm: allow swappiness that prefers reclaiming anon over the file workingset
has been added to the -mm tree.  Its filename is
     mm-allow-swappiness-that-prefers-reclaiming-anon-over-the-file-workingset.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-allow-swappiness-that-prefers-reclaiming-anon-over-the-file-workingset.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-allow-swappiness-that-prefers-reclaiming-anon-over-the-file-workingset.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: allow swappiness that prefers reclaiming anon over the file workingset

With the advent of fast random IO devices (SSDs, PMEM) and in-memory swap
devices such as zswap, it's possible for swap to be much faster than
filesystems, and for swapping to be preferable over thrashing filesystem
caches.

Allow setting swappiness - which defines the rough relative IO cost of
cache misses between page cache and swap-backed pages - to reflect such
situations by making the swap-preferred range configurable.

Link: http://lkml.kernel.org/r/20200520232525.798933-4-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/vm.rst |   23 +++++++++++++++++-----
 kernel/sysctl.c                         |    3 +-
 mm/vmscan.c                             |    2 -
 3 files changed, 21 insertions(+), 7 deletions(-)

--- a/Documentation/admin-guide/sysctl/vm.rst~mm-allow-swappiness-that-prefers-reclaiming-anon-over-the-file-workingset
+++ a/Documentation/admin-guide/sysctl/vm.rst
@@ -831,14 +831,27 @@ tooling to work, you can do::
 swappiness
 ==========
 
-This control is used to define how aggressive the kernel will swap
-memory pages.  Higher values will increase aggressiveness, lower values
-decrease the amount of swap.  A value of 0 instructs the kernel not to
-initiate swap until the amount of free and file-backed pages is less
-than the high water mark in a zone.
+This control is used to define the rough relative IO cost of swapping
+and filesystem paging, as a value between 0 and 200. At 100, the VM
+assumes equal IO cost and will thus apply memory pressure to the page
+cache and swap-backed pages equally; lower values signify more
+expensive swap IO, higher values indicates cheaper.
+
+Keep in mind that filesystem IO patterns under memory pressure tend to
+be more efficient than swap's random IO. An optimal value will require
+experimentation and will also be workload-dependent.
 
 The default value is 60.
 
+For in-memory swap, like zram or zswap, as well as hybrid setups that
+have swap on faster devices than the filesystem, values beyond 100 can
+be considered. For example, if the random IO against the swap device
+is on average 2x faster than IO from the filesystem, swappiness should
+be 133 (x + 2x = 200, 2x = 133.33).
+
+At 0, the kernel will not initiate swap until the amount of free and
+file-backed pages is less than the high watermark in a zone.
+
 
 unprivileged_userfaultfd
 ========================
--- a/kernel/sysctl.c~mm-allow-swappiness-that-prefers-reclaiming-anon-over-the-file-workingset
+++ a/kernel/sysctl.c
@@ -131,6 +131,7 @@ static unsigned long zero_ul;
 static unsigned long one_ul = 1;
 static unsigned long long_max = LONG_MAX;
 static int one_hundred = 100;
+static int two_hundred = 200;
 static int one_thousand = 1000;
 #ifdef CONFIG_PRINTK
 static int ten_thousand = 10000;
@@ -1391,7 +1392,7 @@ static struct ctl_table vm_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &one_hundred,
+		.extra2		= &two_hundred,
 	},
 #ifdef CONFIG_HUGETLB_PAGE
 	{
--- a/mm/vmscan.c~mm-allow-swappiness-that-prefers-reclaiming-anon-over-the-file-workingset
+++ a/mm/vmscan.c
@@ -161,7 +161,7 @@ struct scan_control {
 #endif
 
 /*
- * From 0 .. 100.  Higher means more swappy.
+ * From 0 .. 200.  Higher means more swappy.
  */
 int vm_swappiness = 60;
 /*
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
mm-memcontrol-switch-to-native-nr_anon_thps-counter-fix.patch
mm-memcontrol-convert-anon-and-file-thp-to-new-mem_cgroup_charge-api.patch
mm-memcontrol-convert-anon-and-file-thp-to-new-mem_cgroup_charge-api-fix.patch
mm-memcontrol-drop-unused-try-commit-cancel-charge-api.patch
mm-memcontrol-prepare-swap-controller-setup-for-integration.patch
mm-memcontrol-make-swap-tracking-an-integral-part-of-memory-control.patch
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
