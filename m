From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-fix-lru-balancing-effect-of-new-transparent-huge-pages.patch added to
 -mm tree
Date: Wed, 20 May 2020 20:31:43 -0700
Message-ID: <20200521033143.KEmY-5bEY%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727958AbgEUDbp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 20 May 2020 23:31:45 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, riel@redhat.com


The patch titled
     Subject: mm: fix LRU balancing effect of new transparent huge pages
has been added to the -mm tree.  Its filename is
     mm-fix-lru-balancing-effect-of-new-transparent-huge-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-lru-balancing-effect-of-new-transparent-huge-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-lru-balancing-effect-of-new-transparent-huge-pages.patch

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
Subject: mm: fix LRU balancing effect of new transparent huge pages

The reclaim code that balances between swapping and cache reclaim tries to
predict likely reuse based on in-memory reference patterns alone.  This
works in many cases, but when it fails it cannot detect when the cache is
thrashing pathologically, or when we're in the middle of a swap storm.

The high seek cost of rotational drives under which the algorithm evolved
also meant that mistakes could quickly result in lockups from too
aggressive swapping (which is predominantly random IO).  As a result, the
balancing code has been tuned over time to a point where it mostly goes
for page cache and defers swapping until the VM is under significant
memory pressure.

The resulting strategy doesn't make optimal caching decisions - where
optimal is the least amount of IO required to execute the workload.

The proliferation of fast random IO devices such as SSDs, in-memory
compression such as zswap, and persistent memory technologies on the
horizon, has made this undesirable behavior very noticable: Even in the
presence of large amounts of cold anonymous memory and a capable swap
device, the VM refuses to even seriously scan these pages, and can leave
the page cache thrashing needlessly.

This series sets out to address this.  Since commit ("a528910e12ec mm:
thrash detection-based file cache sizing") we have exact tracking of
refault IO - the ultimate cost of reclaiming the wrong pages.  This allows
us to use an IO cost based balancing model that is more aggressive about
scanning anonymous memory when the cache is thrashing, while being able to
avoid unnecessary swap storms.

These patches base the LRU balance on the rate of refaults on each list,
times the relative IO cost between swap device and filesystem
(swappiness), in order to optimize reclaim for least IO cost incurred.

	History

I floated these changes in 2016.  At the time they were incomplete and
full of workarounds due to a lack of infrastructure in the reclaim code:
We didn't have PageWorkingset, we didn't have hierarchical cgroup
statistics, and problems with the cgroup swap controller.  As swapping
wasn't too high a priority then, the patches stalled out.  With all
dependencies in place now, here we are again with much cleaner,
feature-complete patches.

I kept the acks for patches that stayed materially the same :-)

Below is a series of test results that demonstrate certain problematic
behavior of the current code, as well as showcase the new code's more
predictable and appropriate balancing decisions.

	Test #1: No convergence

This test shows an edge case where the VM currently doesn't converge at
all on a new file workingset with a stale anon/tmpfs set.

The test sets up a cold anon set the size of 3/4 RAM, then tries to
establish a new file set half the size of RAM (flat access pattern).

The vanilla kernel refuses to even scan anon pages and never converges. 
The file set is perpetually served from the filesystem.

The first test kernel is with the series up to the workingset patch
applied.  This allows thrashing page cache to challenge the anonymous
workingset.  The VM then scans the lists based on the current
scanned/rotated balancing algorithm.  It converges on a stable state where
all cold anon pages are pushed out and the fileset is served entirely from
cache:

			    noconverge/5.7-rc5-mm	noconverge/5.7-rc5-mm-workingset
Scanned			417719308.00 (    +0.00%)		64091155.00 (   -84.66%)
Reclaimed		417711094.00 (    +0.00%)		61640308.00 (   -85.24%)
Reclaim efficiency %	      100.00 (    +0.00%)		      96.18 (    -3.78%)
Scanned file		417719308.00 (    +0.00%)		59211118.00 (   -85.83%)
Scanned anon			0.00 (    +0.00%)	         4880037.00 (          )
Swapouts			0.00 (    +0.00%)	         2439957.00 (          )
Swapins				0.00 (    +0.00%)		     257.00 (          )
Refaults		415246605.00 (    +0.00%)		59183722.00 (   -85.75%)
Restore refaults		0.00 (    +0.00%)	        54988252.00 (          )

The second test kernel is with the full patch series applied, which
replaces the scanned/rotated ratios with refault/swapin rate-based
balancing.  It evicts the cold anon pages more aggressively in the
presence of a thrashing cache and the absence of swapins, and so converges
with about 60% of the IO and reclaim activity:

			noconverge/5.7-rc5-mm-workingset	noconverge/5.7-rc5-mm-lrubalance
Scanned				64091155.00 (    +0.00%)		37579741.00 (   -41.37%)
Reclaimed			61640308.00 (    +0.00%)		35129293.00 (   -43.01%)
Reclaim efficiency %		      96.18 (    +0.00%)		      93.48 (    -2.78%)
Scanned file			59211118.00 (    +0.00%)		32708385.00 (   -44.76%)
Scanned anon			 4880037.00 (    +0.00%)		 4871356.00 (    -0.18%)
Swapouts			 2439957.00 (    +0.00%)		 2435565.00 (    -0.18%)
Swapins				     257.00 (    +0.00%)		     262.00 (    +1.94%)
Refaults			59183722.00 (    +0.00%)		32675667.00 (   -44.79%)
Restore refaults		54988252.00 (    +0.00%)		28480430.00 (   -48.21%)

We're triggering this case in host sideloading scenarios: When a host's
primary workload is not saturating the machine (primary load is usually
driven by user activity), we can optimistically sideload a batch job; if
user activity picks up and the primary workload needs the whole host
during this time, we freeze the sideload and rely on it getting pushed to
swap.  Frequently that swapping doesn't happen and the completely inactive
sideload simply stays resident while the expanding primary worklad is
struggling to gain ground.

	Test #2: Kernel build

This test is a a kernel build that is slightly memory-restricted (make -j4
inside a 400M cgroup).

Despite the very aggressive swapping of cold anon pages in test #1, this
test shows that the new kernel carefully balances swap against cache
refaults when both the file and the cache set are pressured.

It shows the patched kernel to be slightly better at finding the coldest
memory from the combined anon and file set to evict under pressure.  The
result is lower aggregate reclaim and paging activity:

z				    5.7-rc5-mm	5.7-rc5-mm-lrubalance
Real time		   210.60 (    +0.00%)	   210.97 (    +0.18%)
User time		   745.42 (    +0.00%)	   746.48 (    +0.14%)
System time		    69.78 (    +0.00%)	    69.79 (    +0.02%)
Scanned file		354682.00 (    +0.00%)	293661.00 (   -17.20%)
Scanned anon		465381.00 (    +0.00%)	378144.00 (   -18.75%)
Swapouts		185920.00 (    +0.00%)	147801.00 (   -20.50%)
Swapins			 34583.00 (    +0.00%)	 32491.00 (    -6.05%)
Refaults		212664.00 (    +0.00%)	172409.00 (   -18.93%)
Restore refaults	 48861.00 (    +0.00%)	 80091.00 (   +63.91%)
Total paging IO		433167.00 (    +0.00%)	352701.00 (   -18.58%)

	Test #3: Overload

This next test is not about performance, but rather about the
predictability of the algorithm.  The current balancing behavior doesn't
always lead to comprehensible results, which makes performance analysis
and parameter tuning (swappiness e.g.) very difficult.

The test shows the balancing behavior under equivalent anon and file
input.  Anon and file sets are created of equal size (3/4 RAM), have the
same access patterns (a hot-cold gradient), and synchronized access rates.
Swappiness is raised from the default of 60 to 100 to indicate equal IO
cost between swap and cache.

With the vanilla balancing code, anon scans make up around 9% of the total
pages scanned, or a ~1:10 ratio.  This is a surprisingly skewed ratio, and
it's an outcome that is hard to explain given the input parameters to the
VM.

The new balancing model targets a 1:2 balance: All else being equal,
reclaiming a file page costs one page IO - the refault; reclaiming an anon
page costs two IOs - the swapout and the swapin.  In the test we observe a
~1:3 balance.

The scanned and paging IO numbers indicate that the anon LRU algorithm we
have in place right now does a slightly worse job at picking the coldest
pages compared to the file algorithm.  There is ongoing work to improve
this, like Joonsoo's anon workingset patches; however, it's difficult to
compare the two aging strategies when the balancing between them is
behaving unintuitively.

The slightly less efficient anon reclaim results in a deviation from the
optimal 1:2 scan ratio we would like to see here - however, 1:3 is much
closer to what we'd want to see in this test than the vanilla kernel's
aging of 10+ cache pages for every anonymous one:

			overload-100/5.7-rc5-mm-workingset	overload-100/5.7-rc5-mm-lrubalance-realfile
Scanned				 533633725.00 (    +0.00%)			  595687785.00 (   +11.63%)
Reclaimed			 494325440.00 (    +0.00%)			  518154380.00 (    +4.82%)
Reclaim efficiency %			92.63 (    +0.00%)				 86.98 (    -6.03%)
Scanned file			 484532894.00 (    +0.00%)			  456937722.00 (    -5.70%)
Scanned anon			  49100831.00 (    +0.00%)			  138750063.00 (  +182.58%)
Swapouts			   8096423.00 (    +0.00%)			   48982142.00 (  +504.98%)
Swapins				  10027384.00 (    +0.00%)			   62325044.00 (  +521.55%)
Refaults			 479819973.00 (    +0.00%)			  451309483.00 (    -5.94%)
Restore refaults		 426422087.00 (    +0.00%)			  399914067.00 (    -6.22%)
Total paging IO			 497943780.00 (    +0.00%)			  562616669.00 (   +12.99%)

	Test #4: Parallel IO

It's important to note that these patches only affect the situation where
the kernel has to reclaim workingset memory, which is usually a
transitionary period.  The vast majority of page reclaim occuring in a
system is from trimming the ever-expanding page cache.

These patches don't affect cache trimming behavior.  We never swap as long
as we only have use-once cache moving through the file LRU, we only
consider swapping when the cache is actively thrashing.

The following test demonstrates this.  It has an anon workingset that
takes up half of RAM and then writes a file that is twice the size of RAM
out to disk.

As the cache is funneled through the inactive file list, no anon pages are
scanned (aside from apparently some background noise of 10 pages):

					  5.7-rc5-mm		          5.7-rc5-mm-lrubalance
Scanned			    10714722.00 (    +0.00%)		       10723445.00 (    +0.08%)
Reclaimed		    10703596.00 (    +0.00%)		       10712166.00 (    +0.08%)
Reclaim efficiency %		  99.90 (    +0.00%)			     99.89 (    -0.00%)
Scanned file		    10714722.00 (    +0.00%)		       10723435.00 (    +0.08%)
Scanned anon			   0.00 (    +0.00%)			     10.00 (          )
Swapouts			   0.00 (    +0.00%)			      7.00 (          )
Swapins				   0.00 (    +0.00%)			      0.00 (    +0.00%)
Refaults			  92.00 (    +0.00%)			     41.00 (   -54.84%)
Restore refaults		   0.00 (    +0.00%)			      0.00 (    +0.00%)
Total paging IO			  92.00 (    +0.00%)			     48.00 (   -47.31%)


This patch (of 14):

Currently, THP are counted as single pages until they are split right
before being swapped out.  However, at that point the VM is already in the
middle of reclaim, and adjusting the LRU balance then is useless.

Always account THP by the number of basepages, and remove the fixup from
the splitting path.

Link: http://lkml.kernel.org/r/20200520232525.798933-1-hannes@cmpxchg.org
Link: http://lkml.kernel.org/r/20200520232525.798933-2-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, 
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

--- a/mm/swap.c~mm-fix-lru-balancing-effect-of-new-transparent-huge-pages
+++ a/mm/swap.c
@@ -263,13 +263,14 @@ void rotate_reclaimable_page(struct page
 }
 
 static void update_page_reclaim_stat(struct lruvec *lruvec,
-				     int file, int rotated)
+				     int file, int rotated,
+				     unsigned int nr_pages)
 {
 	struct zone_reclaim_stat *reclaim_stat = &lruvec->reclaim_stat;
 
-	reclaim_stat->recent_scanned[file]++;
+	reclaim_stat->recent_scanned[file] += nr_pages;
 	if (rotated)
-		reclaim_stat->recent_rotated[file]++;
+		reclaim_stat->recent_rotated[file] += nr_pages;
 }
 
 static void __activate_page(struct page *page, struct lruvec *lruvec,
@@ -286,7 +287,7 @@ static void __activate_page(struct page
 		trace_mm_lru_activate(page);
 
 		__count_vm_event(PGACTIVATE);
-		update_page_reclaim_stat(lruvec, file, 1);
+		update_page_reclaim_stat(lruvec, file, 1, hpage_nr_pages(page));
 	}
 }
 
@@ -541,7 +542,7 @@ static void lru_deactivate_file_fn(struc
 
 	if (active)
 		__count_vm_event(PGDEACTIVATE);
-	update_page_reclaim_stat(lruvec, file, 0);
+	update_page_reclaim_stat(lruvec, file, 0, hpage_nr_pages(page));
 }
 
 static void lru_deactivate_fn(struct page *page, struct lruvec *lruvec,
@@ -557,7 +558,7 @@ static void lru_deactivate_fn(struct pag
 		add_page_to_lru_list(page, lruvec, lru);
 
 		__count_vm_events(PGDEACTIVATE, hpage_nr_pages(page));
-		update_page_reclaim_stat(lruvec, file, 0);
+		update_page_reclaim_stat(lruvec, file, 0, hpage_nr_pages(page));
 	}
 }
 
@@ -582,7 +583,7 @@ static void lru_lazyfree_fn(struct page
 
 		__count_vm_events(PGLAZYFREE, hpage_nr_pages(page));
 		count_memcg_page_event(page, PGLAZYFREE);
-		update_page_reclaim_stat(lruvec, 1, 0);
+		update_page_reclaim_stat(lruvec, 1, 0, hpage_nr_pages(page));
 	}
 }
 
@@ -890,8 +891,6 @@ EXPORT_SYMBOL(__pagevec_release);
 void lru_add_page_tail(struct page *page, struct page *page_tail,
 		       struct lruvec *lruvec, struct list_head *list)
 {
-	const int file = 0;
-
 	VM_BUG_ON_PAGE(!PageHead(page), page);
 	VM_BUG_ON_PAGE(PageCompound(page_tail), page);
 	VM_BUG_ON_PAGE(PageLRU(page_tail), page);
@@ -917,9 +916,6 @@ void lru_add_page_tail(struct page *page
 		add_page_to_lru_list_tail(page_tail, lruvec,
 					  page_lru(page_tail));
 	}
-
-	if (!PageUnevictable(page))
-		update_page_reclaim_stat(lruvec, file, PageActive(page_tail));
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
@@ -962,8 +958,9 @@ static void __pagevec_lru_add_fn(struct
 
 	if (page_evictable(page)) {
 		lru = page_lru(page);
-		update_page_reclaim_stat(lruvec, page_is_file_lru(page),
-					 PageActive(page));
+		update_page_reclaim_stat(lruvec, is_file_lru(lru),
+					 PageActive(page),
+					 hpage_nr_pages(page));
 		if (was_unevictable)
 			count_vm_event(UNEVICTABLE_PGRESCUED);
 	} else {
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
