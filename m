From: akpm@linux-foundation.org
Subject: [merged] revert-mm-remove-__gfp_no_kswapd.patch removed from -mm tree
Date: Fri, 30 Nov 2012 13:28:27 -0800
Message-ID: <20121130212828.44B32200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:48433 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab2K3V2b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 30 Nov 2012 16:28:31 -0500
Received: by mail-ee0-f74.google.com with SMTP id t10so65058eei.1
        for <mm-commits@vger.kernel.org>; Fri, 30 Nov 2012 13:28:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, Valdis.Kletnieks@vt.edu, jirislaby@gmail.com, rcj@linux.vnet.ibm.com, riel@redhat.com, sjenning@linux.vnet.ibm.com, zkabelac@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "mm: remove __GFP_NO_KSWAPD"
has been removed from the -mm tree.  Its filename was
     revert-mm-remove-__gfp_no_kswapd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: Revert "mm: remove __GFP_NO_KSWAPD"

With "mm: vmscan: scale number of pages reclaimed by reclaim/compaction
based on failures" reverted, Zdenek Kabelac reported the following

	Hmm,  so it's just took longer to hit the problem and observe
	kswapd0 spinning on my CPU again - it's not as endless like before -
	but still it easily eats minutes - it helps to	turn off  Firefox
	or TB  (memory hungry apps) so kswapd0 stops soon - and restart
	those apps again.  (And I still have like >1GB of cached memory)

	kswapd0         R  running task        0    30      2 0x00000000
	 ffff8801331efae8 0000000000000082 0000000000000018 0000000000000246
	 ffff880135b9a340 ffff8801331effd8 ffff8801331effd8 ffff8801331effd8
	 ffff880055dfa340 ffff880135b9a340 00000000331efad8 ffff8801331ee000
	Call Trace:
	 [<ffffffff81555bf2>] preempt_schedule+0x42/0x60
	 [<ffffffff81557a95>] _raw_spin_unlock+0x55/0x60
	 [<ffffffff81192971>] put_super+0x31/0x40
	 [<ffffffff81192a42>] drop_super+0x22/0x30
	 [<ffffffff81193b89>] prune_super+0x149/0x1b0
	 [<ffffffff81141e2a>] shrink_slab+0xba/0x510

The sysrq+m indicates the system has no swap so it'll never reclaim
anonymous pages as part of reclaim/compaction. That is one part of the
problem but not the root cause as file-backed pages could also be reclaimed.

The likely underlying problem is that kswapd is woken up or kept awake
for each THP allocation request in the page allocator slow path.

If compaction fails for the requesting process then compaction will be
deferred for a time and direct reclaim is avoided. However, if there
are a storm of THP requests that are simply rejected, it will still
be the the case that kswapd is awake for a prolonged period of time
as pgdat->kswapd_max_order is updated each time. This is noticed by
the main kswapd() loop and it will not call kswapd_try_to_sleep().
Instead it will loopp, shrinking a small number of pages and calling
shrink_slab() on each iteration.

The temptation is to supply a patch that checks if kswapd was woken for
THP and if so ignore pgdat->kswapd_max_order but it'll be a hack and not
backed up by proper testing. As 3.7 is very close to release and this is
not a bug we should release with, a safer path is to revert "mm: remove
__GFP_NO_KSWAPD" for now and revisit it with the view to ironing out the
balance_pgdat() logic in general.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Zdenek Kabelac <zkabelac@redhat.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Robert Jennings <rcj@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/mtdcore.c           |    6 ++++--
 include/linux/gfp.h             |    5 ++++-
 include/trace/events/gfpflags.h |    1 +
 mm/page_alloc.c                 |    7 ++++---
 4 files changed, 13 insertions(+), 6 deletions(-)

diff -puN drivers/mtd/mtdcore.c~revert-mm-remove-__gfp_no_kswapd drivers/mtd/mtdcore.c
--- a/drivers/mtd/mtdcore.c~revert-mm-remove-__gfp_no_kswapd
+++ a/drivers/mtd/mtdcore.c
@@ -1077,7 +1077,8 @@ EXPORT_SYMBOL_GPL(mtd_writev);
  * until the request succeeds or until the allocation size falls below
  * the system page size. This attempts to make sure it does not adversely
  * impact system performance, so when allocating more than one page, we
- * ask the memory allocator to avoid re-trying.
+ * ask the memory allocator to avoid re-trying, swapping, writing back
+ * or performing I/O.
  *
  * Note, this function also makes sure that the allocated buffer is aligned to
  * the MTD device's min. I/O unit, i.e. the "mtd->writesize" value.
@@ -1091,7 +1092,8 @@ EXPORT_SYMBOL_GPL(mtd_writev);
  */
 void *mtd_kmalloc_up_to(const struct mtd_info *mtd, size_t *size)
 {
-	gfp_t flags = __GFP_NOWARN | __GFP_WAIT | __GFP_NORETRY;
+	gfp_t flags = __GFP_NOWARN | __GFP_WAIT |
+		       __GFP_NORETRY | __GFP_NO_KSWAPD;
 	size_t min_alloc = max_t(size_t, mtd->writesize, PAGE_SIZE);
 	void *kbuf;
 
diff -puN include/linux/gfp.h~revert-mm-remove-__gfp_no_kswapd include/linux/gfp.h
--- a/include/linux/gfp.h~revert-mm-remove-__gfp_no_kswapd
+++ a/include/linux/gfp.h
@@ -31,6 +31,7 @@ struct vm_area_struct;
 #define ___GFP_THISNODE		0x40000u
 #define ___GFP_RECLAIMABLE	0x80000u
 #define ___GFP_NOTRACK		0x200000u
+#define ___GFP_NO_KSWAPD	0x400000u
 #define ___GFP_OTHER_NODE	0x800000u
 #define ___GFP_WRITE		0x1000000u
 
@@ -85,6 +86,7 @@ struct vm_area_struct;
 #define __GFP_RECLAIMABLE ((__force gfp_t)___GFP_RECLAIMABLE) /* Page is reclaimable */
 #define __GFP_NOTRACK	((__force gfp_t)___GFP_NOTRACK)  /* Don't track with kmemcheck */
 
+#define __GFP_NO_KSWAPD	((__force gfp_t)___GFP_NO_KSWAPD)
 #define __GFP_OTHER_NODE ((__force gfp_t)___GFP_OTHER_NODE) /* On behalf of other node */
 #define __GFP_WRITE	((__force gfp_t)___GFP_WRITE)	/* Allocator intends to dirty page */
 
@@ -114,7 +116,8 @@ struct vm_area_struct;
 				 __GFP_MOVABLE)
 #define GFP_IOFS	(__GFP_IO | __GFP_FS)
 #define GFP_TRANSHUGE	(GFP_HIGHUSER_MOVABLE | __GFP_COMP | \
-			 __GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_NOWARN)
+			 __GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_NOWARN | \
+			 __GFP_NO_KSWAPD)
 
 #ifdef CONFIG_NUMA
 #define GFP_THISNODE	(__GFP_THISNODE | __GFP_NOWARN | __GFP_NORETRY)
diff -puN include/trace/events/gfpflags.h~revert-mm-remove-__gfp_no_kswapd include/trace/events/gfpflags.h
--- a/include/trace/events/gfpflags.h~revert-mm-remove-__gfp_no_kswapd
+++ a/include/trace/events/gfpflags.h
@@ -36,6 +36,7 @@
 	{(unsigned long)__GFP_RECLAIMABLE,	"GFP_RECLAIMABLE"},	\
 	{(unsigned long)__GFP_MOVABLE,		"GFP_MOVABLE"},		\
 	{(unsigned long)__GFP_NOTRACK,		"GFP_NOTRACK"},		\
+	{(unsigned long)__GFP_NO_KSWAPD,	"GFP_NO_KSWAPD"},	\
 	{(unsigned long)__GFP_OTHER_NODE,	"GFP_OTHER_NODE"}	\
 	) : "GFP_NOWAIT"
 
diff -puN mm/page_alloc.c~revert-mm-remove-__gfp_no_kswapd mm/page_alloc.c
--- a/mm/page_alloc.c~revert-mm-remove-__gfp_no_kswapd
+++ a/mm/page_alloc.c
@@ -2416,8 +2416,9 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 		goto nopage;
 
 restart:
-	wake_all_kswapd(order, zonelist, high_zoneidx,
-					zone_idx(preferred_zone));
+	if (!(gfp_mask & __GFP_NO_KSWAPD))
+		wake_all_kswapd(order, zonelist, high_zoneidx,
+						zone_idx(preferred_zone));
 
 	/*
 	 * OK, we're below the kswapd watermark and have kicked background
@@ -2494,7 +2495,7 @@ rebalance:
 	 * system then fail the allocation instead of entering direct reclaim.
 	 */
 	if ((deferred_compaction || contended_compaction) &&
-	    (gfp_mask & (__GFP_MOVABLE|__GFP_REPEAT)) == __GFP_MOVABLE)
+						(gfp_mask & __GFP_NO_KSWAPD))
 		goto nopage;
 
 	/* Try direct reclaim and then allocating */
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
linux-next.patch
memory_hotplug-fix-possible-incorrect-node_states.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
mm-add-comment-on-storage-key-dirty-bit-semantics.patch
mm-refactor-reinsert-of-swap_info-in-sys_swapoff.patch
mm-do-not-call-frontswap_init-during-swapoff.patch
mm-memmap_init_zone-performance-improvement.patch
mm-allocate-kernel-pages-to-the-right-memcg.patch
mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory.patch
memory_hotplug-handle-empty-zone-when-online_movable-online_kernel.patch
memory_hotplug-ensure-every-online-node-has-normal-memory.patch
mm-compaction-fix-compiler-warning.patch
mm-add-a-reminder-comment-for-__gfp_bits_shift.patch
numa-add-config_movable_node-for-movable-dedicated-node.patch
numa-add-config_movable_node-for-movable-dedicated-node-fix.patch
memory_hotplug-allow-online-offline-memory-to-result-movable-node.patch
mm-introduce-new-field-managed_pages-to-struct-zone.patch
mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap.patch
mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap-fix.patch

