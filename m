From: akpm@linux-foundation.org
Subject: +
 mm-move-zone-lock-to-a-different-cache-line-than-order-0-free-page-lists.patch added to -mm tree
Date: Fri, 27 Mar 2015 14:41:41 -0700
Message-ID: <5515ce95.nzeH2xF2hOqZiL9l%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49317 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257AbbC0Vlm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Mar 2015 17:41:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move zone lock to a different cache line than order-0 free page lists
has been added to the -mm tree.  Its filename is
     mm-move-zone-lock-to-a-different-cache-line-than-order-0-free-page-lists.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-move-zone-lock-to-a-different-cache-line-than-order-0-free-page-lists.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-move-zone-lock-to-a-different-cache-line-than-order-0-free-page-lists.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: move zone lock to a different cache line than order-0 free page lists

Huang Ying reported the following problem due to commit 3484b2de9499 ("mm:
rearrange zone fields into read-only, page alloc, statistics and page
reclaim lines") from the Intel performance tests

    24b7e5819ad5cbef  3484b2de9499df23c4604a513b
    ----------------  --------------------------
             %stddev     %change         %stddev
                 \          |                \
        152288 \261  0%     -46.2%      81911 \261  0%  aim7.jobs-per-min
           237 \261  0%     +85.6%        440 \261  0%  aim7.time.elapsed_time
           237 \261  0%     +85.6%        440 \261  0%  aim7.time.elapsed_time.max
         25026 \261  0%     +70.7%      42712 \261  0%  aim7.time.system_time
       2186645 \261  5%     +32.0%    2885949 \261  4%  aim7.time.voluntary_context_switches
       4576561 \261  1%     +24.9%    5715773 \261  0%  aim7.time.involuntary_context_switches

The problem is specific to very large machines under stress.  It was not
reproducible with the machines I had used to justify the original patch
because large numbers of CPUs are required.  When pressure is high enough,
the cache line is bouncing between CPUs trying to acquire the lock and the
holder of the lock adjusting free lists.  The intention was that the
acquirer of the lock would automatically have the cache line holding the
free lists but according to Huang, this is not a universal win.

One possibility is to move the zone lock to its own cache line but it
increases the size of the zone.  This patch moves the lock to the other
end of the free lists where they do not contend under high pressure.  It
does mean the page allocator paths now require more cache lines but Huang
reports that it restores performance to previous levels on large machines

             %stddev     %change         %stddev
                 \          |                \
         84568 \261  1%     +94.3%     164280 \261  1%  aim7.jobs-per-min
       2881944 \261  2%     -35.1%    1870386 \261  8%  aim7.time.voluntary_context_switches
           681 \261  1%      -3.4%        658 \261  0%  aim7.time.user_time
       5538139 \261  0%     -12.1%    4867884 \261  0%  aim7.time.involuntary_context_switches
         44174 \261  1%     -46.0%      23848 \261  1%  aim7.time.system_time
           426 \261  1%     -48.4%        219 \261  1%  aim7.time.elapsed_time
           426 \261  1%     -48.4%        219 \261  1%  aim7.time.elapsed_time.max
           468 \261  1%     -43.1%        266 \261  2%  uptime.boot

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reported-by: Huang Ying <ying.huang@intel.com>
Tested-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN include/linux/mmzone.h~mm-move-zone-lock-to-a-different-cache-line-than-order-0-free-page-lists include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-move-zone-lock-to-a-different-cache-line-than-order-0-free-page-lists
+++ a/include/linux/mmzone.h
@@ -474,16 +474,15 @@ struct zone {
 	unsigned long		wait_table_bits;
 
 	ZONE_PADDING(_pad1_)
-
-	/* Write-intensive fields used from the page allocator */
-	spinlock_t		lock;
-
 	/* free areas of different sizes */
 	struct free_area	free_area[MAX_ORDER];
 
 	/* zone flags, see below */
 	unsigned long		flags;
 
+	/* Write-intensive fields used from the page allocator */
+	spinlock_t		lock;
+
 	ZONE_PADDING(_pad2_)
 
 	/* Write-intensive fields used by page reclaim */
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-move-zone-lock-to-a-different-cache-line-than-order-0-free-page-lists.patch
cxgb4-drop-__gfp_nofail-allocation.patch
jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail.patch
mm-cma-change-fallback-behaviour-for-cma-freepage.patch
mm-page_alloc-factor-out-fallback-freepage-checking.patch
mm-compaction-enhance-compaction-finish-condition.patch
mm-compaction-enhance-compaction-finish-condition-fix.patch
mm-refactor-do_wp_page-extract-the-reuse-case.patch
mm-refactor-do_wp_page-rewrite-the-unlock-flow.patch
mm-refactor-do_wp_page-extract-the-page-copy-flow.patch
mm-refactor-do_wp_page-handling-of-shared-vma-into-a-function.patch
mm-remove-gfp_thisnode.patch
mm-thp-really-limit-transparent-hugepage-allocation-to-local-node.patch
kernel-cpuset-remove-exception-for-__gfp_thisnode.patch
mm-clarify-__gfp_nofail-deprecation-status.patch
sparc-clarify-__gfp_nofail-allocation.patch
mm-numa-remove-migrate_ratelimited.patch
mm-consolidate-all-page-flags-helpers-in-linux-page-flagsh.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
allow-compaction-of-unevictable-pages.patch
mm-change-deactivate_page-with-deactivate_file_page.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-move-lazy-free-pages-to-inactive-list.patch
kernelh-implement-div_round_closest_ull.patch
cpuidle-menu-use-div_round_closest_ull.patch
linux-next.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

