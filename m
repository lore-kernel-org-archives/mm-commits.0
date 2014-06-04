From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-page_alloc-use-jump-labels-to-avoid-checking-number_of_cpusets-fix.patch removed from -mm tree
Date: Wed, 04 Jun 2014 15:32:13 -0700
Message-ID: <538f9e6d.0TSuexN6CqMWa2be%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39270 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbaFDWcN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2014 18:32:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sfr@canb.auug.org.au, mgorman@suse.de

Subject: [folded-merged] mm-page_alloc-use-jump-labels-to-avoid-checking-number_of_cpusets-fix.patch removed from -mm tree
To: mgorman@suse.de,sfr@canb.auug.org.au,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 04 Jun 2014 15:32:13 -0700


The patch titled
     Subject: mm-page_alloc-use-jump-labels-to-avoid-checking-number_of_cpusets-fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-use-jump-labels-to-avoid-checking-number_of_cpusets-fix.patch

This patch was dropped because it was folded into mm-page_alloc-use-jump-labels-to-avoid-checking-number_of_cpusets.patch

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm-page_alloc-use-jump-labels-to-avoid-checking-number_of_cpusets-fix

Stephen Rothwell reported the following build failure on -next.

In file included from arch/powerpc/mm/numa.c:23:0:
include/linux/cpuset.h: In function 'cpusets_enabled':
include/linux/cpuset.h:21:2: error: implicit declaration of function 'static_key_false' [-Werror=implicit-function-declaration]
  return static_key_false(&cpusets_enabled_key);
  ^
include/linux/cpuset.h: In function 'nr_cpusets':
include/linux/cpuset.h:27:2: error: implicit declaration of function 'static_key_count' [-Werror=implicit-function-declaration]
  return static_key_count(&cpusets_enabled_key) + 1;
  ^
include/linux/cpuset.h: In function 'cpuset_inc':
include/linux/cpuset.h:32:2: error: implicit declaration of function 'static_key_slow_inc' [-Werror=implicit-function-declaration]
  static_key_slow_inc(&cpusets_enabled_key);
  ^
include/linux/cpuset.h: In function 'cpuset_dec':
include/linux/cpuset.h:37:2: error: implicit declaration of function 'static_key_slow_dec' [-Werror=implicit-function-declaration]
  static_key_slow_dec(&cpusets_enabled_key);
  ^

This is a fix to the mmotm patch mm-page_alloc-use-jump-labels-to-avoid-checking-number_of_cpusets.patch.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpuset.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/cpuset.h~mm-page_alloc-use-jump-labels-to-avoid-checking-number_of_cpusets-fix include/linux/cpuset.h
--- a/include/linux/cpuset.h~mm-page_alloc-use-jump-labels-to-avoid-checking-number_of_cpusets-fix
+++ a/include/linux/cpuset.h
@@ -12,6 +12,7 @@
 #include <linux/cpumask.h>
 #include <linux/nodemask.h>
 #include <linux/mm.h>
+#include <linux/jump_label.h>
 
 #ifdef CONFIG_CPUSETS
 
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
x86-require-x86-64-for-automatic-numa-balancing.patch
x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels.patch
mm-only-force-scan-in-reclaim-when-none-of-the-lrus-are-big-enough.patch
mm-huge_memoryc-complete-conversion-to-pr_foo.patch
mm-disable-zone_reclaim_mode-by-default.patch
mm-page_alloc-do-not-cache-reclaim-distances.patch
mm-page_alloc-prevent-migrate_reserve-pages-from-being-misplaced.patch
mm-compaction-clean-up-unused-code-lines.patch
mm-compaction-cleanup-isolate_freepages.patch
mm-swapc-clean-up-lru_cache_add-functions.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal.patch
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
mm-page_alloc-calculate-classzone_idx-once-from-the-zonelist-ref.patch
mm-page_alloc-calculate-classzone_idx-once-from-the-zonelist-ref-fix.patch
mm-avoid-unnecessary-atomic-operations-during-end_page_writeback.patch
mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention.patch
fs-superblock-unregister-sb-shrinker-before-kill_sb.patch
fs-superblock-avoid-locking-counting-inodes-and-dentries-before-reclaiming-them.patch
mm-vmscan-use-proportional-scanning-during-direct-reclaim-and-full-scan-at-def_priority.patch
mm-nominate-faultaround-area-in-bytes-rather-then-page-order.patch

