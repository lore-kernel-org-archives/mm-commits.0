From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch removed from
 -mm tree
Date: Wed, 16 Mar 2016 12:55:21 -0700
Message-ID: <56e9ba29.QhyGK2EZE76szXrO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38658 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934026AbcCPTzW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:55:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, izumi.taku@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: rework code layout in memmap_init_zone()
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/page_alloc.c: rework code layout in memmap_init_zone()

This function is getting full of weird tricks to avoid word-wrapping.  Use
a goto to eliminate a tab stop then use the new space

Cc: Taku Izumi <izumi.taku@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   79 ++++++++++++++++++++++------------------------
 1 file changed, 38 insertions(+), 41 deletions(-)

diff -puN mm/page_alloc.c~mm-page_allocc-rework-code-layout-in-memmap_init_zone mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_allocc-rework-code-layout-in-memmap_init_zone
+++ a/mm/page_alloc.c
@@ -4508,54 +4508,51 @@ void __meminit memmap_init_zone(unsigned
 
 	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
 		/*
-		 * There can be holes in boot-time mem_map[]s
-		 * handed to this function.  They do not
-		 * exist on hotplugged memory.
+		 * There can be holes in boot-time mem_map[]s handed to this
+		 * function.  They do not exist on hotplugged memory.
 		 */
-		if (context == MEMMAP_EARLY) {
-			if (!early_pfn_valid(pfn))
-				continue;
-			if (!early_pfn_in_nid(pfn, nid))
-				continue;
-			if (!update_defer_init(pgdat, pfn, end_pfn,
-						&nr_initialised))
-				break;
+		if (context != MEMMAP_EARLY)
+			goto not_early;
+
+		if (!early_pfn_valid(pfn))
+			continue;
+		if (!early_pfn_in_nid(pfn, nid))
+			continue;
+		if (!update_defer_init(pgdat, pfn, end_pfn, &nr_initialised))
+			break;
 
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
-			/*
-			 * if not mirrored_kernelcore and ZONE_MOVABLE exists,
-			 * range from zone_movable_pfn[nid] to end of each node
-			 * should be ZONE_MOVABLE not ZONE_NORMAL. skip it.
-			 */
-			if (!mirrored_kernelcore && zone_movable_pfn[nid])
-				if (zone == ZONE_NORMAL &&
-				    pfn >= zone_movable_pfn[nid])
-					continue;
+		/*
+		 * If not mirrored_kernelcore and ZONE_MOVABLE exists, range
+		 * from zone_movable_pfn[nid] to end of each node should be
+		 * ZONE_MOVABLE not ZONE_NORMAL. skip it.
+		 */
+		if (!mirrored_kernelcore && zone_movable_pfn[nid])
+			if (zone == ZONE_NORMAL && pfn >= zone_movable_pfn[nid])
+				continue;
 
-			/*
-			 * check given memblock attribute by firmware which
-			 * can affect kernel memory layout.
-			 * if zone==ZONE_MOVABLE but memory is mirrored,
-			 * it's an overlapped memmap init. skip it.
-			 */
-			if (mirrored_kernelcore && zone == ZONE_MOVABLE) {
-				if (!r ||
-				    pfn >= memblock_region_memory_end_pfn(r)) {
-					for_each_memblock(memory, tmp)
-						if (pfn < memblock_region_memory_end_pfn(tmp))
-							break;
-					r = tmp;
-				}
-				if (pfn >= memblock_region_memory_base_pfn(r) &&
-				    memblock_is_mirror(r)) {
-					/* already initialized as NORMAL */
-					pfn = memblock_region_memory_end_pfn(r);
-					continue;
-				}
+		/*
+		 * Check given memblock attribute by firmware which can affect
+		 * kernel memory layout.  If zone==ZONE_MOVABLE but memory is
+		 * mirrored, it's an overlapped memmap init. skip it.
+		 */
+		if (mirrored_kernelcore && zone == ZONE_MOVABLE) {
+			if (!r || pfn >= memblock_region_memory_end_pfn(r)) {
+				for_each_memblock(memory, tmp)
+					if (pfn < memblock_region_memory_end_pfn(tmp))
+						break;
+				r = tmp;
+			}
+			if (pfn >= memblock_region_memory_base_pfn(r) &&
+			    memblock_is_mirror(r)) {
+				/* already initialized as NORMAL */
+				pfn = memblock_region_memory_end_pfn(r);
+				continue;
 			}
-#endif
 		}
+#endif
 
+not_early:
 		/*
 		 * Mark the block movable so that blocks are reserved for
 		 * movable at startup. This will force kernel allocations
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-code-clean-up-for-direct-io-fix.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
ocfs2-dlm-move-lock-to-the-tail-of-grant-queue-while-doing-in-place-convert-fix.patch
mm.patch
sched-add-schedule_timeout_idle.patch
mm-oom_reaper-report-success-failure-fix.patch
proc-kpageflags-return-kpf_buddy-for-tail-buddy-pages-fix-fix.patch
mm-vmalloc-query-dynamic-debug_pagealloc-setting-fix.patch
mm-slub-query-dynamic-debug_pagealloc-setting-fix.patch
sound-query-dynamic-debug_pagealloc-setting-fix.patch
mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-3-fix.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab-fix.patch
zram-export-the-number-of-available-comp-streams-fix.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
mn10300-c6x-config_generic_bug-must-depend-on-config_bug.patch
arch-mn10300-kernel-fpu-nofpuc-needs-asm-elfh.patch
btrfs-use-radix_tree_iter_retry-fix.patch
sscanf-implement-basic-character-sets-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix-fix.patch
rapidio-add-mport-char-device-driver-fix.patch
kernel-add-kcov-code-coverage-fix.patch
kernel-add-kcov-code-coverage-fix-2.patch
kernel-add-kcov-code-coverage-makefile-tweaks.patch
linux-next-git-rejects.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
dma-rename-dma__writecombine-to-dma__wc-checkpatch-fixes.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

