From: akpm@linux-foundation.org
Subject: +
 mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous-fix.patch added to -mm tree
Date: Thu, 04 Feb 2016 16:49:37 -0800
Message-ID: <56b3f1a1.FSHfNOqBcpN+udFU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43404 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbcBEAti (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Feb 2016 19:49:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aaron.lu@intel.com, iamjoonsoo.kim@lge.com, mgorman@suse.de, riel@redhat.com, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     
has been added to the -mm tree.  Its filename is
     mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>

Move CONFIG_MEMORY_HOTPLUG code into memory_hotplug.c, fix
CONFIG_MEMORY_HOTPLUG=n build.

Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Aaron Lu <aaron.lu@intel.com>
Cc: Aaron Lu <aaron.lu@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory_hotplug.h |   12 +++++++++++-
 include/linux/mmzone.h         |    2 ++
 mm/memory_hotplug.c            |   27 +++++++++++++++++++++++++++
 mm/page_alloc.c                |   27 ---------------------------
 4 files changed, 40 insertions(+), 28 deletions(-)

diff -puN include/linux/memory_hotplug.h~mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous-fix include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous-fix
+++ a/include/linux/memory_hotplug.h
@@ -200,7 +200,10 @@ void mem_hotplug_done(void);
 
 extern void set_zone_contiguous(struct zone *zone);
 extern void clear_zone_contiguous(struct zone *zone);
-
+static inline bool zone_contiguous(struct zone *zone)
+{
+	return zone->contiguous;
+}
 #else /* ! CONFIG_MEMORY_HOTPLUG */
 /*
  * Stub functions for when hotplug is off
@@ -243,6 +246,13 @@ static inline void put_online_mems(void)
 static inline void mem_hotplug_begin(void) {}
 static inline void mem_hotplug_done(void) {}
 
+static inline void set_zone_contiguous(struct zone *zone) {}
+static inline void clear_zone_contiguous(struct zone *zone) {}
+static inline bool zone_contiguous(struct zone *zone)
+{
+	return false;
+}
+
 #endif /* ! CONFIG_MEMORY_HOTPLUG */
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
diff -puN include/linux/mmzone.h~mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous-fix include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous-fix
+++ a/include/linux/mmzone.h
@@ -522,7 +522,9 @@ struct zone {
 	bool			compact_blockskip_flush;
 #endif
 
+#ifdef CONFIG_MEMORY_HOTPLUG
 	bool			contiguous;
+#endif
 
 	ZONE_PADDING(_pad3_)
 	/* Zone statistics */
diff -puN mm/memory_hotplug.c~mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous-fix mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous-fix
+++ a/mm/memory_hotplug.c
@@ -130,6 +130,33 @@ void mem_hotplug_done(void)
 	memhp_lock_release();
 }
 
+void set_zone_contiguous(struct zone *zone)
+{
+	unsigned long block_start_pfn = zone->zone_start_pfn;
+	unsigned long block_end_pfn;
+	unsigned long pfn;
+
+	block_end_pfn = ALIGN(block_start_pfn + 1, pageblock_nr_pages);
+	for (; block_start_pfn < zone_end_pfn(zone);
+		block_start_pfn = block_end_pfn,
+		block_end_pfn += pageblock_nr_pages) {
+
+		block_end_pfn = min(block_end_pfn, zone_end_pfn(zone));
+
+		if (!__pageblock_pfn_to_page(block_start_pfn,
+					block_end_pfn, zone))
+			return;
+	}
+
+	/* We confirm that there is no hole */
+	zone->contiguous = true;
+}
+
+void clear_zone_contiguous(struct zone *zone)
+{
+	zone->contiguous = false;
+}
+
 /* add this memory to iomem resource */
 static struct resource *register_memory_resource(u64 start, u64 size)
 {
diff -puN mm/page_alloc.c~mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous-fix
+++ a/mm/page_alloc.c
@@ -1347,33 +1347,6 @@ struct page *__pageblock_pfn_to_page(uns
 	return start_page;
 }
 
-void set_zone_contiguous(struct zone *zone)
-{
-	unsigned long block_start_pfn = zone->zone_start_pfn;
-	unsigned long block_end_pfn;
-	unsigned long pfn;
-
-	block_end_pfn = ALIGN(block_start_pfn + 1, pageblock_nr_pages);
-	for (; block_start_pfn < zone_end_pfn(zone);
-		block_start_pfn = block_end_pfn,
-		block_end_pfn += pageblock_nr_pages) {
-
-		block_end_pfn = min(block_end_pfn, zone_end_pfn(zone));
-
-		if (!__pageblock_pfn_to_page(block_start_pfn,
-					block_end_pfn, zone))
-			return;
-	}
-
-	/* We confirm that there is no hole */
-	zone->contiguous = true;
-}
-
-void clear_zone_contiguous(struct zone *zone)
-{
-	zone->contiguous = false;
-}
-
 #ifdef CONFIG_CMA
 /* Free whole pageblock and set its migration type to MIGRATE_CMA. */
 void __init init_cma_reserved_pageblock(struct page *page)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
kernel-locking-lockdepc-convert-hash-tables-to-hlists.patch
kernel-locking-lockdepc-convert-hash-tables-to-hlists-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-code-clean-up-for-direct-io-fix.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
ocfs2-dlm-move-lock-to-the-tail-of-grant-queue-while-doing-in-place-convert-fix.patch
mm.patch
mm-slab-clean-up-debug_pagealloc-processing-code-fix.patch
mm-slab-put-the-freelist-at-the-end-of-slab-page-fix.patch
fs-mpagec-mpage_readpages-use-lru_to_page-helper.patch
mm-page_allocc-introduce-kernelcore=mirror-option-fix.patch
mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch
mm-debug-pageallocc-split-out-page-poisoning-from-debug-page_alloc-checkpatch-fixes.patch
mm-page_poisonc-enable-page_poisoning-as-a-separate-option-fix.patch
mm-page_poisoningc-allow-for-zero-poisoning-checkpatch-fixes.patch
mm-madvise-update-comment-on-sys_madvise-fix.patch
mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages-fix.patch
mm-simplify-lock_page_memcg-fix.patch
sched-add-schedule_timeout_idle.patch
mm-oom_reaper-report-success-failure-fix.patch
mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous-fix.patch
proc-kpageflags-return-kpf_buddy-for-tail-buddy-pages-fix-fix.patch
mm-vmalloc-query-dynamic-debug_pagealloc-setting-fix.patch
mm-slub-query-dynamic-debug_pagealloc-setting-fix.patch
sound-query-dynamic-debug_pagealloc-setting-fix.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
zram-export-the-number-of-available-comp-streams-fix.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
btrfs-use-radix_tree_iter_retry-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix-fix.patch
dma-rename-dma__writecombine-to-dma__wc-checkpatch-fixes.patch
kernel-add-kcov-code-coverage-fix.patch
kernel-add-kcov-code-coverage-fix-2.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

