From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-use-jump-labels-to-avoid-checking-number_of_cpusets-fix.patch added to -mm tree
Date: Wed, 14 May 2014 14:50:57 -0700
Message-ID: <5373e541.JP88HGgeC8vdpHKh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48477 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbaENVu6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 May 2014 17:50:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sfr@canb.auug.org.au, mgorman@suse.de

Subject: + mm-page_alloc-use-jump-labels-to-avoid-checking-number_of_cpusets-fix.patch added to -mm tree
To: mgorman@suse.de,sfr@canb.auug.org.au
From: akpm@linux-foundation.org
Date: Wed, 14 May 2014 14:50:57 -0700


The patch titled
     Subject: mm-page_alloc-use-jump-labels-to-avoid-checking-number_of_cpusets-fix
has been added to the -mm tree.  Its filename is
     mm-page_alloc-use-jump-labels-to-avoid-checking-number_of_cpusets-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-use-jump-labels-to-avoid-checking-number_of_cpusets-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-use-jump-labels-to-avoid-checking-number_of_cpusets-fix.patch

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
do_shared_fault-check-that-mmap_sem-is-held.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-fix.patch
cpu-hotplug-stop-machine-plug-race-window-that-leads-to-ipi-to-offline-cpu.patch
cpu-hotplug-stop-machine-plug-race-window-that-leads-to-ipi-to-offline-cpu-v3.patch
linux-next.patch

