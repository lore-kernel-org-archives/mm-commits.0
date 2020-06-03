From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 105/131] mm: allow swappiness that prefers
 reclaiming anon over the file workingset
Date: Wed, 03 Jun 2020 16:02:37 -0700
Message-ID: <20200603230237.xj0G5g-t7%akpm@linux-foundation.org>
References: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726567AbgFCXIk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 19:08:40 -0400
In-Reply-To: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, linux-mm@kvack.org, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, riel@surriel.com, torvalds@linux-foundation.org

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
Cc: Rik van Riel <riel@surriel.com>
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
