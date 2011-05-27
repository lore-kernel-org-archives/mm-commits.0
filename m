From: akpm@linux-foundation.org
Subject: [merged] mm-move-enum-vm_event_item-into-a-standalone-header-file.patch removed from -mm tree
Date: Fri, 27 May 2011 12:57:51 -0700
Message-ID: <201105271955.p4RJtuB2017496@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55836 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757091Ab1E0T4i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 15:56:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp, yinghan@googl


The patch titled
     mm: move enum vm_event_item into a standalone header file
has been removed from the -mm tree.  Its filename was
     mm-move-enum-vm_event_item-into-a-standalone-header-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: move enum vm_event_item into a standalone header file
From: Andrew Morton <akpm@linux-foundation.org>

enums are problematic because they cannot be forward-declared:

akpm2:/home/akpm> cat t.c

enum foo;

static inline void bar(enum foo f)
{
}
akpm2:/home/akpm> gcc -c t.c
t.c:4: error: parameter 1 ('f') has incomplete type

So move the enum's definition into a standalone header file which can be used
wherever its definition is needed.  

Cc: Ying Han <yinghan@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vm_event_item.h |   64 ++++++++++++++++++++++++++++++++
 include/linux/vmstat.h        |   62 -------------------------------
 2 files changed, 65 insertions(+), 61 deletions(-)

diff -puN /dev/null include/linux/vm_event_item.h
--- /dev/null
+++ a/include/linux/vm_event_item.h
@@ -0,0 +1,64 @@
+#ifndef VM_EVENT_ITEM_H_INCLUDED
+#define VM_EVENT_ITEM_H_INCLUDED
+
+#ifdef CONFIG_ZONE_DMA
+#define DMA_ZONE(xx) xx##_DMA,
+#else
+#define DMA_ZONE(xx)
+#endif
+
+#ifdef CONFIG_ZONE_DMA32
+#define DMA32_ZONE(xx) xx##_DMA32,
+#else
+#define DMA32_ZONE(xx)
+#endif
+
+#ifdef CONFIG_HIGHMEM
+#define HIGHMEM_ZONE(xx) , xx##_HIGH
+#else
+#define HIGHMEM_ZONE(xx)
+#endif
+
+#define FOR_ALL_ZONES(xx) DMA_ZONE(xx) DMA32_ZONE(xx) xx##_NORMAL HIGHMEM_ZONE(xx) , xx##_MOVABLE
+
+enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
+		FOR_ALL_ZONES(PGALLOC),
+		PGFREE, PGACTIVATE, PGDEACTIVATE,
+		PGFAULT, PGMAJFAULT,
+		FOR_ALL_ZONES(PGREFILL),
+		FOR_ALL_ZONES(PGSTEAL),
+		FOR_ALL_ZONES(PGSCAN_KSWAPD),
+		FOR_ALL_ZONES(PGSCAN_DIRECT),
+#ifdef CONFIG_NUMA
+		PGSCAN_ZONE_RECLAIM_FAILED,
+#endif
+		PGINODESTEAL, SLABS_SCANNED, KSWAPD_STEAL, KSWAPD_INODESTEAL,
+		KSWAPD_LOW_WMARK_HIT_QUICKLY, KSWAPD_HIGH_WMARK_HIT_QUICKLY,
+		KSWAPD_SKIP_CONGESTION_WAIT,
+		PAGEOUTRUN, ALLOCSTALL, PGROTATED,
+#ifdef CONFIG_COMPACTION
+		COMPACTBLOCKS, COMPACTPAGES, COMPACTPAGEFAILED,
+		COMPACTSTALL, COMPACTFAIL, COMPACTSUCCESS,
+#endif
+#ifdef CONFIG_HUGETLB_PAGE
+		HTLB_BUDDY_PGALLOC, HTLB_BUDDY_PGALLOC_FAIL,
+#endif
+		UNEVICTABLE_PGCULLED,	/* culled to noreclaim list */
+		UNEVICTABLE_PGSCANNED,	/* scanned for reclaimability */
+		UNEVICTABLE_PGRESCUED,	/* rescued from noreclaim list */
+		UNEVICTABLE_PGMLOCKED,
+		UNEVICTABLE_PGMUNLOCKED,
+		UNEVICTABLE_PGCLEARED,	/* on COW, page truncate */
+		UNEVICTABLE_PGSTRANDED,	/* unable to isolate on unlock */
+		UNEVICTABLE_MLOCKFREED,
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+		THP_FAULT_ALLOC,
+		THP_FAULT_FALLBACK,
+		THP_COLLAPSE_ALLOC,
+		THP_COLLAPSE_ALLOC_FAILED,
+		THP_SPLIT,
+#endif
+		NR_VM_EVENT_ITEMS
+};
+
+#endif		/* VM_EVENT_ITEM_H_INCLUDED */
diff -puN include/linux/vmstat.h~mm-move-enum-vm_event_item-into-a-standalone-header-file include/linux/vmstat.h
--- a/include/linux/vmstat.h~mm-move-enum-vm_event_item-into-a-standalone-header-file
+++ a/include/linux/vmstat.h
@@ -5,69 +5,9 @@
 #include <linux/percpu.h>
 #include <linux/mm.h>
 #include <linux/mmzone.h>
+#include <linux/vm_event_item.h>
 #include <asm/atomic.h>
 
-#ifdef CONFIG_ZONE_DMA
-#define DMA_ZONE(xx) xx##_DMA,
-#else
-#define DMA_ZONE(xx)
-#endif
-
-#ifdef CONFIG_ZONE_DMA32
-#define DMA32_ZONE(xx) xx##_DMA32,
-#else
-#define DMA32_ZONE(xx)
-#endif
-
-#ifdef CONFIG_HIGHMEM
-#define HIGHMEM_ZONE(xx) , xx##_HIGH
-#else
-#define HIGHMEM_ZONE(xx)
-#endif
-
-
-#define FOR_ALL_ZONES(xx) DMA_ZONE(xx) DMA32_ZONE(xx) xx##_NORMAL HIGHMEM_ZONE(xx) , xx##_MOVABLE
-
-enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
-		FOR_ALL_ZONES(PGALLOC),
-		PGFREE, PGACTIVATE, PGDEACTIVATE,
-		PGFAULT, PGMAJFAULT,
-		FOR_ALL_ZONES(PGREFILL),
-		FOR_ALL_ZONES(PGSTEAL),
-		FOR_ALL_ZONES(PGSCAN_KSWAPD),
-		FOR_ALL_ZONES(PGSCAN_DIRECT),
-#ifdef CONFIG_NUMA
-		PGSCAN_ZONE_RECLAIM_FAILED,
-#endif
-		PGINODESTEAL, SLABS_SCANNED, KSWAPD_STEAL, KSWAPD_INODESTEAL,
-		KSWAPD_LOW_WMARK_HIT_QUICKLY, KSWAPD_HIGH_WMARK_HIT_QUICKLY,
-		KSWAPD_SKIP_CONGESTION_WAIT,
-		PAGEOUTRUN, ALLOCSTALL, PGROTATED,
-#ifdef CONFIG_COMPACTION
-		COMPACTBLOCKS, COMPACTPAGES, COMPACTPAGEFAILED,
-		COMPACTSTALL, COMPACTFAIL, COMPACTSUCCESS,
-#endif
-#ifdef CONFIG_HUGETLB_PAGE
-		HTLB_BUDDY_PGALLOC, HTLB_BUDDY_PGALLOC_FAIL,
-#endif
-		UNEVICTABLE_PGCULLED,	/* culled to noreclaim list */
-		UNEVICTABLE_PGSCANNED,	/* scanned for reclaimability */
-		UNEVICTABLE_PGRESCUED,	/* rescued from noreclaim list */
-		UNEVICTABLE_PGMLOCKED,
-		UNEVICTABLE_PGMUNLOCKED,
-		UNEVICTABLE_PGCLEARED,	/* on COW, page truncate */
-		UNEVICTABLE_PGSTRANDED,	/* unable to isolate on unlock */
-		UNEVICTABLE_MLOCKFREED,
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-		THP_FAULT_ALLOC,
-		THP_FAULT_FALLBACK,
-		THP_COLLAPSE_ALLOC,
-		THP_COLLAPSE_ALLOC_FAILED,
-		THP_SPLIT,
-#endif
-		NR_VM_EVENT_ITEMS
-};
-
 extern int sysctl_stat_interval;
 
 #ifdef CONFIG_VM_EVENT_COUNTERS
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
backlight-add-backlight-type-fix.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-base-platformc-dont-mark-platform_device_register_resndata-as-__init_or_module.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
rfcomm-corec-avoid-dangling-pointer-check-session-exists-checkpatch-fixes.patch
slab-use-numa_no_node.patch
mm.patch
writeback-sync-expired-inodes-first-in-background-writeback-fix.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
checkpatch-suggest-using-min_t-or-max_t.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
rtc-driver-for-pt7c4338-chip-checkpatch-fixes.patch
rtc-driver-for-pt7c4338-chip-fix.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

