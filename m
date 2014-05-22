From: akpm@linux-foundation.org
Subject: +
 mm-vmscan-use-proportional-scanning-during-direct-reclaim-and-full-scan-at-def_priority.patch added to -mm tree
Date: Thu, 22 May 2014 11:05:19 -0700
Message-ID: <537e3c5f.hxl0p0uYe6qyxMFt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58912 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbaEVSFU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 May 2014 14:05:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yuanhan.liu@linux.intel.com, viro@zeniv.linux.org.uk, tim.c.chen@linux.intel.com, riel@redhat.com, jack@suse.cz, hughd@google.com, hannes@cmpxchg.org, david@fromorbit.com, bob.liu@oracle.com, mgorman@suse.de

Subject: + mm-vmscan-use-proportional-scanning-during-direct-reclaim-and-full-scan-at-def_priority.patch added to -mm tree
To: mgorman@suse.de,bob.liu@oracle.com,david@fromorbit.com,hannes@cmpxchg.org,hughd@google.com,jack@suse.cz,riel@redhat.com,tim.c.chen@linux.intel.com,viro@zeniv.linux.org.uk,yuanhan.liu@linux.intel.com
From: akpm@linux-foundation.org
Date: Thu, 22 May 2014 11:05:19 -0700


The patch titled
     Subject: mm: vmscan: use proportional scanning during direct reclaim and full scan at DEF_PRIORITY
has been added to the -mm tree.  Its filename is
     mm-vmscan-use-proportional-scanning-during-direct-reclaim-and-full-scan-at-def_priority.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-use-proportional-scanning-during-direct-reclaim-and-full-scan-at-def_priority.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-use-proportional-scanning-during-direct-reclaim-and-full-scan-at-def_priority.patch

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
Subject: mm: vmscan: use proportional scanning during direct reclaim and full scan at DEF_PRIORITY

Commit "mm: vmscan: obey proportional scanning requirements for kswapd"
ensured that file/anon lists were scanned proportionally for reclaim from
kswapd but ignored it for direct reclaim.  The intent was to minimse
direct reclaim latency but Yuanhan Liu pointer out that it substitutes one
long stall for many small stalls and distorts aging for normal workloads
like streaming readers/writers.  Hugh Dickins pointed out that a
side-effect of the same commit was that when one LRU list dropped to zero
that the entirety of the other list was shrunk leading to excessive
reclaim in memcgs.  This patch scans the file/anon lists proportionally
for direct reclaim to similarly age page whether reclaimed by kswapd or
direct reclaim but takes care to abort reclaim if one LRU drops to zero
after reclaiming the requested number of pages.

Based on ext4 and using the Intel VM scalability test

                                              3.15.0-rc5            3.15.0-rc5
                                                shrinker            proportion
Unit  lru-file-readonce    elapsed      5.3500 (  0.00%)      5.4200 ( -1.31%)
Unit  lru-file-readonce time_range      0.2700 (  0.00%)      0.1400 ( 48.15%)
Unit  lru-file-readonce time_stddv      0.1148 (  0.00%)      0.0536 ( 53.33%)
Unit lru-file-readtwice    elapsed      8.1700 (  0.00%)      8.1700 (  0.00%)
Unit lru-file-readtwice time_range      0.4300 (  0.00%)      0.2300 ( 46.51%)
Unit lru-file-readtwice time_stddv      0.1650 (  0.00%)      0.0971 ( 41.16%)

The test cases are running multiple dd instances reading sparse files. The results are within
the noise for the small test machine. The impact of the patch is more noticable from the vmstats

                            3.15.0-rc5  3.15.0-rc5
                              shrinker  proportion
Minor Faults                     35154       36784
Major Faults                       611        1305
Swap Ins                           394        1651
Swap Outs                         4394        5891
Allocation stalls               118616       44781
Direct pages scanned           4935171     4602313
Kswapd pages scanned          15921292    16258483
Kswapd pages reclaimed        15913301    16248305
Direct pages reclaimed         4933368     4601133
Kswapd efficiency                  99%         99%
Kswapd velocity             670088.047  682555.961
Direct efficiency                  99%         99%
Direct velocity             207709.217  193212.133
Percentage direct scans            23%         22%
Page writes by reclaim        4858.000    6232.000
Page writes file                   464         341
Page writes anon                  4394        5891

Note that there are fewer allocation stalls even though the amount
of direct reclaim scanning is very approximately the same.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: Bob Liu <bob.liu@oracle.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   36 +++++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-use-proportional-scanning-during-direct-reclaim-and-full-scan-at-def_priority mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-use-proportional-scanning-during-direct-reclaim-and-full-scan-at-def_priority
+++ a/mm/vmscan.c
@@ -2064,13 +2064,27 @@ static void shrink_lruvec(struct lruvec
 	unsigned long nr_reclaimed = 0;
 	unsigned long nr_to_reclaim = sc->nr_to_reclaim;
 	struct blk_plug plug;
-	bool scan_adjusted = false;
+	bool scan_adjusted;
 
 	get_scan_count(lruvec, sc, nr);
 
 	/* Record the original scan target for proportional adjustments later */
 	memcpy(targets, nr, sizeof(nr));
 
+	/*
+	 * Global reclaiming within direct reclaim at DEF_PRIORITY is a normal
+	 * event that can occur when there is little memory pressure e.g.
+	 * multiple streaming readers/writers. Hence, we do not abort scanning
+	 * when the requested number of pages are reclaimed when scanning at
+	 * DEF_PRIORITY on the assumption that the fact we are direct
+	 * reclaiming implies that kswapd is not keeping up and it is best to
+	 * do a batch of work at once. For memcg reclaim one check is made to
+	 * abort proportional reclaim if either the file or anon lru has already
+	 * dropped to zero at the first pass.
+	 */
+	scan_adjusted = (global_reclaim(sc) && !current_is_kswapd() &&
+			 sc->priority == DEF_PRIORITY);
+
 	blk_start_plug(&plug);
 	while (nr[LRU_INACTIVE_ANON] || nr[LRU_ACTIVE_FILE] ||
 					nr[LRU_INACTIVE_FILE]) {
@@ -2091,17 +2105,8 @@ static void shrink_lruvec(struct lruvec
 			continue;
 
 		/*
-		 * For global direct reclaim, reclaim only the number of pages
-		 * requested. Less care is taken to scan proportionally as it
-		 * is more important to minimise direct reclaim stall latency
-		 * than it is to properly age the LRU lists.
-		 */
-		if (global_reclaim(sc) && !current_is_kswapd())
-			break;
-
-		/*
 		 * For kswapd and memcg, reclaim at least the number of pages
-		 * requested. Ensure that the anon and file LRUs shrink
+		 * requested. Ensure that the anon and file LRUs are scanned
 		 * proportionally what was requested by get_scan_count(). We
 		 * stop reclaiming one LRU and reduce the amount scanning
 		 * proportional to the original scan target.
@@ -2109,6 +2114,15 @@ static void shrink_lruvec(struct lruvec
 		nr_file = nr[LRU_INACTIVE_FILE] + nr[LRU_ACTIVE_FILE];
 		nr_anon = nr[LRU_INACTIVE_ANON] + nr[LRU_ACTIVE_ANON];
 
+		/*
+		 * It's just vindictive to attack the larger once the smaller
+		 * has gone to zero.  And given the way we stop scanning the
+		 * smaller below, this makes sure that we only make one nudge
+		 * towards proportionality once we've got nr_to_reclaim.
+		 */
+		if (!nr_file || !nr_anon)
+			break;
+
 		if (nr_file > nr_anon) {
 			unsigned long scan_target = targets[LRU_INACTIVE_ANON] +
 						targets[LRU_ACTIVE_ANON] + 1;
_

Patches currently in -mm which might be from mgorman@suse.de are

x86-require-x86-64-for-automatic-numa-balancing.patch
x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels.patch
x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels-fix-2.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-only-force-scan-in-reclaim-when-none-of-the-lrus-are-big-enough.patch
mm-huge_memoryc-complete-conversion-to-pr_foo.patch
mm-disable-zone_reclaim_mode-by-default.patch
mm-page_alloc-do-not-cache-reclaim-distances.patch
mm-page_alloc-do-not-cache-reclaim-distances-fix.patch
mm-page_alloc-prevent-migrate_reserve-pages-from-being-misplaced.patch
mm-compaction-clean-up-unused-code-lines.patch
mm-compaction-cleanup-isolate_freepages.patch
mm-compaction-cleanup-isolate_freepages-fix.patch
mm-compaction-cleanup-isolate_freepages-fix-2.patch
mm-compaction-cleanup-isolate_freepages-fix3.patch
mm-swapc-clean-up-lru_cache_add-functions.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal-checkpatch-fixes.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal-fix.patch
mm-numa-add-migrated-transhuge-pages-to-lru-the-same-way-as-base-pages.patch
mm-swapc-introduce-put_refcounted_compound_page-helpers-for-spliting-put_compound_page.patch
mm-swapc-split-put_compound_page-function.patch
mm-introdule-compound_head_by_tail.patch
mm-x86-pgtable-drop-unneeded-preprocessor-ifdef.patch
mm-x86-pgtable-require-x86_64-for-soft-dirty-tracker.patch
mm-mempolicyc-parameter-doc-uniformization.patch
mm-migration-add-destination-page-freeing-callback.patch
mm-compaction-return-failed-migration-target-pages-back-to-freelist.patch
mm-compaction-add-per-zone-migration-pfn-cache-for-async-compaction.patch
mm-compaction-embed-migration-mode-in-compact_control.patch
mm-thp-avoid-excessive-compaction-latency-during-fault.patch
mm-thp-avoid-excessive-compaction-latency-during-fault-fix.patch
mm-compaction-terminate-async-compaction-when-rescheduling.patch
mm-compaction-do-not-count-migratepages-when-unnecessary.patch
mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages.patch
swap-change-swap_info-singly-linked-list-to-list_head.patch
plist-add-helper-functions.patch
plist-add-plist_requeue.patch
swap-change-swap_list_head-to-plist-add-swap_avail_head.patch
mm-page_alloc-do-not-update-zlc-unless-the-zlc-is-active.patch
mm-page_alloc-do-not-treat-a-zone-that-cannot-be-used-for-dirty-pages-as-full.patch
jump_label-expose-the-reference-count.patch
mm-page_alloc-use-jump-labels-to-avoid-checking-number_of_cpusets.patch
mm-page_alloc-use-jump-labels-to-avoid-checking-number_of_cpusets-fix.patch
mm-page_alloc-only-check-the-zone-id-check-if-pages-are-buddies.patch
mm-page_alloc-only-check-the-alloc-flags-and-gfp_mask-for-dirty-once.patch
mm-page_alloc-take-the-alloc_no_watermark-check-out-of-the-fast-path.patch
mm-page_alloc-use-word-based-accesses-for-get-set-pageblock-bitmaps.patch
mm-page_alloc-reduce-number-of-times-page_to_pfn-is-called.patch
mm-page_alloc-lookup-pageblock-migratetype-with-irqs-enabled-during-free.patch
mm-page_alloc-use-unsigned-int-for-order-in-more-places.patch
mm-page_alloc-convert-hot-cold-parameter-and-immediate-callers-to-bool.patch
mm-shmem-avoid-atomic-operation-during-shmem_getpage_gfp.patch
mm-do-not-use-atomic-operations-when-releasing-pages.patch
mm-do-not-use-unnecessary-atomic-operations-when-adding-pages-to-the-lru.patch
fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers.patch
fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers-fix.patch
mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible.patch
mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possiblefix-2.patch
mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible-fix.patch
mm-page_alloc-calculate-classzone_idx-once-from-the-zonelist-ref.patch
mm-page_alloc-calculate-classzone_idx-once-from-the-zonelist-ref-fix.patch
mm-avoid-unnecessary-atomic-operations-during-end_page_writeback.patch
mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention.patch
fs-superblock-unregister-sb-shrinker-before-kill_sb.patch
fs-superblock-avoid-locking-counting-inodes-and-dentries-before-reclaiming-them.patch
mm-vmscan-use-proportional-scanning-during-direct-reclaim-and-full-scan-at-def_priority.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-fix.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-v5.patch
cpu-hotplug-stop-machine-plug-race-window-that-leads-to-ipi-to-offline-cpu.patch
cpu-hotplug-stop-machine-plug-race-window-that-leads-to-ipi-to-offline-cpu-v3.patch
cpu-hotplug-stop-machine-plug-race-window-that-leads-to-ipi-to-offline-cpu-v5.patch
linux-next.patch

