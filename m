From: akpm@linux-foundation.org
Subject: +
 mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible-fix.patch added to -mm tree
Date: Tue, 20 May 2014 12:35:26 -0700
Message-ID: <537bae7e.09jsXttcgXaLho9d%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34156 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125AbaETTf1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 May 2014 15:35:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, prabhakar.csengg@gmail.com, mgorman@suse.de

Subject: + mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible-fix.patch added to -mm tree
To: mgorman@suse.de,prabhakar.csengg@gmail.com
From: akpm@linux-foundation.org
Date: Tue, 20 May 2014 12:35:26 -0700


The patch titled
     Subject: mm: non-atomically mark page accessed during page cache allocation where possible -fix
has been added to the -mm tree.  Its filename is
     mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible-fix.patch

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
Subject: mm: non-atomically mark page accessed during page cache allocation where possible -fix

Prabhakar Lad reported the following problem

  I see following issue on DA850 evm,
  git bisect points me to
  commit id: 975c3a671f11279441006a29a19f55ccc15fb320
  ( mm: non-atomically mark page accessed during page cache allocation
  where possible)

  Unable to handle kernel paging request at virtual address 30e03501
  pgd = c68cc000
  [30e03501] *pgd=00000000
  Internal error: Oops: 1 [#1] PREEMPT ARM
  Modules linked in:
  CPU: 0 PID: 1015 Comm: network.sh Not tainted 3.15.0-rc5-00323-g975c3a6 #9
  task: c70c4e00 ti: c73d0000 task.ti: c73d0000
  PC is at init_page_accessed+0xc/0x24
  LR is at shmem_write_begin+0x54/0x60
  pc : [<c0088aa0>]    lr : [<c00923e8>]    psr: 20000013
  sp : c73d1d90  ip : c73d1da0  fp : c73d1d9c
  r10: c73d1dec  r9 : 00000000  r8 : 00000000
  r7 : c73d1e6c  r6 : c694d7bc  r5 : ffffffe4  r4 : c73d1dec
  r3 : c73d0000  r2 : 00000001  r1 : 00000000  r0 : 30e03501
  Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
  Control: 0005317f  Table: c68cc000  DAC: 00000015
  Process network.sh (pid: 1015, stack limit = 0xc73d01c0)

pagep is set but not pointing to anywhere valid as it's an uninitialised
stack variable. This patch is a fix to
mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible.patch

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reported-by: Prabhakar Lad <prabhakar.csengg@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/filemap.c~mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible-fix mm/filemap.c
--- a/mm/filemap.c~mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible-fix
+++ a/mm/filemap.c
@@ -2485,7 +2485,7 @@ ssize_t generic_perform_write(struct fil
 		flags |= AOP_FLAG_UNINTERRUPTIBLE;
 
 	do {
-		struct page *page;
+		struct page *page = NULL;
 		unsigned long offset;	/* Offset into pagecache page */
 		unsigned long bytes;	/* Bytes to write to page */
 		size_t copied;		/* Bytes copied from user */
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
do_shared_fault-check-that-mmap_sem-is-held.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-fix.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-v5.patch
cpu-hotplug-stop-machine-plug-race-window-that-leads-to-ipi-to-offline-cpu.patch
cpu-hotplug-stop-machine-plug-race-window-that-leads-to-ipi-to-offline-cpu-v3.patch
cpu-hotplug-stop-machine-plug-race-window-that-leads-to-ipi-to-offline-cpu-v5.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch
linux-next.patch

