From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-tracepoint-account-for-scanned-pages-similarly-for-both-ftrace-and-vmstat.patch removed from -mm tree
Date: Thu, 23 Dec 2010 14:36:20 -0800
Message-ID: <201012232240.oBNMe714015424@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58251 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751944Ab0LWWkc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Dec 2010 17:40:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     mm: vmscan: tracepoint: account for scanned pages similarly for both ftrace and vmstat
has been removed from the -mm tree.  Its filename was
     mm-vmscan-tracepoint-account-for-scanned-pages-similarly-for-both-ftrace-and-vmstat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: vmscan: tracepoint: account for scanned pages similarly for both ftrace and vmstat
From: Mel Gorman <mel@csn.ul.ie>

When correlating ftrace results with /proc/vmstat, I noticed that the
reporting scripts value for "pages scanned" differed significantly.  Both
values were "right" depending on how you look at it.

The difference is due to vmstat only counting scanning of the inactive
list towards pages scanned.  The analysis script for the tracepoint counts
active and inactive list yielding a far higher value than vmstat.  The
resulting scanning/reclaim ratio looks much worse.  The tracepoint is ok
but this patch updates the reporting script so that the report values for
scanned are similar to vmstat.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/trace/postprocess/trace-vmscan-postprocess.pl |   11 +++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN Documentation/trace/postprocess/trace-vmscan-postprocess.pl~mm-vmscan-tracepoint-account-for-scanned-pages-similarly-for-both-ftrace-and-vmstat Documentation/trace/postprocess/trace-vmscan-postprocess.pl
--- a/Documentation/trace/postprocess/trace-vmscan-postprocess.pl~mm-vmscan-tracepoint-account-for-scanned-pages-similarly-for-both-ftrace-and-vmstat
+++ a/Documentation/trace/postprocess/trace-vmscan-postprocess.pl
@@ -373,9 +373,18 @@ EVENT_PROCESS:
 				print "         $regex_lru_isolate/o\n";
 				next;
 			}
+			my $isolate_mode = $1;
 			my $nr_scanned = $4;
 			my $nr_contig_dirty = $7;
-			$perprocesspid{$process_pid}->{HIGH_NR_SCANNED} += $nr_scanned;
+
+			# To closer match vmstat scanning statistics, only count isolate_both
+			# and isolate_inactive as scanning. isolate_active is rotation
+			# isolate_inactive == 0
+			# isolate_active   == 1
+			# isolate_both     == 2
+			if ($isolate_mode != 1) {
+				$perprocesspid{$process_pid}->{HIGH_NR_SCANNED} += $nr_scanned;
+			}
 			$perprocesspid{$process_pid}->{HIGH_NR_CONTIG_DIRTY} += $nr_contig_dirty;
 		} elsif ($tracepoint eq "mm_vmscan_lru_shrink_inactive") {
 			$details = $5;
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
linux-next.patch
mm-page-allocator-adjust-the-per-cpu-counter-threshold-when-memory-is-low.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-update.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix-set_pgdat_percpu_threshold-dont-use-for_each_online_cpu.patch
writeback-io-less-balance_dirty_pages.patch
writeback-consolidate-variable-names-in-balance_dirty_pages.patch
writeback-per-task-rate-limit-on-balance_dirty_pages.patch
writeback-per-task-rate-limit-on-balance_dirty_pages-fix.patch
writeback-prevent-duplicate-balance_dirty_pages_ratelimited-calls.patch
writeback-account-per-bdi-accumulated-written-pages.patch
writeback-bdi-write-bandwidth-estimation.patch
writeback-bdi-write-bandwidth-estimation-fix.patch
writeback-show-bdi-write-bandwidth-in-debugfs.patch
writeback-quit-throttling-when-bdi-dirty-pages-dropped-low.patch
writeback-reduce-per-bdi-dirty-threshold-ramp-up-time.patch
writeback-make-reasonable-gap-between-the-dirty-background-thresholds.patch
writeback-scale-down-max-throttle-bandwidth-on-concurrent-dirtiers.patch
writeback-add-trace-event-for-balance_dirty_pages.patch
writeback-make-nr_to_write-a-per-file-limit.patch
writeback-make-nr_to_write-a-per-file-limit-fix.patch
vmscan-factor-out-kswapd-sleeping-logic-from-kswapd.patch
mm-compaction-add-trace-events-for-memory-compaction-activity.patch
mm-vmscan-convert-lumpy_mode-into-a-bitmask.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-fix.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path-fix.patch
mm-migration-cleanup-migrate_pages-api-by-matching-types-for-offlining-and-sync.patch
mm-compaction-perform-a-faster-migration-scan-when-migrating-asynchronously.patch
mm-vmscan-rename-lumpy_mode-to-reclaim_mode.patch
mm-vmscan-rename-lumpy_mode-to-reclaim_mode-fix.patch
mm-kswapd-stop-high-order-balancing-when-any-suitable-zone-is-balanced.patch
mm-kswapd-keep-kswapd-awake-for-high-order-allocations-until-a-percentage-of-the-node-is-balanced.patch
mm-kswapd-use-the-order-that-kswapd-was-reclaiming-at-for-sleeping_prematurely.patch
mm-kswapd-reset-kswapd_max_order-and-classzone_idx-after-reading.patch
mm-kswapd-treat-zone-all_unreclaimable-in-sleeping_prematurely-similar-to-balance_pgdat.patch
mm-kswapd-use-the-classzone-idx-that-kswapd-was-using-for-sleeping_prematurely.patch
thp-fix-bad_page-to-show-the-real-reason-the-page-is-bad.patch
thp-mm-define-madv_hugepage.patch
thp-alter-compound-get_page-put_page.patch
thp-update-futex-compound-knowledge.patch
thp-clear-compound-mapping.patch
thp-add-native_set_pmd_at.patch
thp-add-pmd-paravirt-ops.patch
thp-no-paravirt-version-of-pmd-ops.patch
thp-export-maybe_mkwrite.patch
thp-comment-reminder-in-destroy_compound_page.patch
thp-config_transparent_hugepage.patch
thp-config_transparent_hugepage-fix.patch
thp-special-pmd_trans_-functions.patch
thp-add-pmd-mangling-generic-functions.patch
thp-add-pmd-mangling-generic-functions-fix-pgtableh-build-for-um.patch
thp-bail-out-gup_fast-on-splitting-pmd.patch
thp-pte-alloc-trans-splitting.patch
thp-pte-alloc-trans-splitting-fix.patch
thp-clear-page-compound.patch
thp-add-pmd_huge_pte-to-mm_struct.patch
thp-split_huge_page_mm-vma.patch
thp-split_huge_page-paging.patch
thp-clear_copy_huge_page.patch
thp-_gfp_no_kswapd.patch
thp-dont-alloc-harder-for-gfp-nomemalloc-even-if-nowait.patch
thp-split_huge_page-anon_vma-ordering-dependency.patch
thp-verify-pmd_trans_huge-isnt-leaking.patch
thp-add-pagetranscompound.patch
thp-skip-transhuge-pages-in-ksm-for-now.patch
thp-enable-direct-defrag.patch
thp-select-config_compaction-if-transparent_hugepage-enabled.patch
thp-transhuge-isolate_migratepages.patch
thp-disable-transparent-hugepages-by-default-on-small-systems.patch
mm-migration-use-rcu_dereference_protected-when-dereferencing-the-radix-tree-slot-during-file-page-migration.patch
mm-migration-use-rcu_dereference_protected-when-dereferencing-the-radix-tree-slot-during-file-page-migration-fix.patch
add-debugging-aid-for-memory-initialisation-problems.patch

