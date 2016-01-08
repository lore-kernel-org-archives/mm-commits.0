From: akpm@linux-foundation.org
Subject: + mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch
 added to -mm tree
Date: Fri, 08 Jan 2016 15:16:46 -0800
Message-ID: <5690435e.bEzZrKeHsC3Qx1nc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49413 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756177AbcAHXQr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jan 2016 18:16:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, izumi.taku@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: rework code layout in memmap_init_zone()
has been added to the -mm tree.  Its filename is
     mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch

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
Subject: mm/page_alloc.c: rework code layout in memmap_init_zone()

This function is getting full of weird tricks to avoid word-wrapping.  Use
a goto to eliminate a tab stop then use the new space

Cc: Taku Izumi <izumi.taku@jp.fujitsu.com>.
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   79 ++++++++++++++++++++++------------------------
 1 file changed, 38 insertions(+), 41 deletions(-)

diff -puN mm/page_alloc.c~mm-page_allocc-rework-code-layout-in-memmap_init_zone mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_allocc-rework-code-layout-in-memmap_init_zone
+++ a/mm/page_alloc.c
@@ -4614,54 +4614,51 @@ void __meminit memmap_init_zone(unsigned
 	z = &pgdat->node_zones[zone];
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

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
ocfs2-fix-slot-overwritten-if-storage-link-down-during-mount-checkpatch-fixes.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
include-linux-dcacheh-remove-semicolons-from-hash_len_declare.patch
mm.patch
account-certain-kmem-allocations-to-memcg-checkpatch-fixes.patch
include-define-__phys_to_pfn-as-phys_pfn-fix.patch
mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix-2.patch
mm-zonelist-enumerate-zonelists-array-index-checkpatch-fixes.patch
mm-zonelist-enumerate-zonelists-array-index-fix.patch
mm-get-rid-of-__alloc_pages_high_priority-checkpatch-fixes.patch
fs-block_devc-bdev_write_page-use-blk_queue_enter-gfp_noio.patch
arm64-mm-support-arch_mmap_rnd_bits-fix.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
thp-add-debugfs-handle-to-split-all-huge-pages-fix.patch
mm-support-madvisemadv_free-fix-2-fix.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix-fix-2.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix-fix-2-fix-3.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
sched-add-schedule_timeout_idle.patch
mm-oom-introduce-oom-reaper-fix-fix.patch
mm-oom-introduce-oom-reaper-fix-fix-2.patch
mm-oom-introduce-oom-reaper-checkpatch-fixes.patch
mm-oom-introduce-oom-reaper-fix-3.patch
mm-oom-introduce-oom-reaper-fix-4-fix.patch
mm-oom-introduce-oom-reaper-fix-5-fix.patch
mm-mlockc-change-can_do_mlock-return-value-type-to-boolean-fix.patch
mm-page_allocc-introduce-kernelcore=mirror-option-fix.patch
mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch
kernel-stop_machinec-remove-config_smp-dependencies.patch
kernel-stop_machinec-remove-config_smp-dependencies-fix.patch
lib-vsprintfc-expand-field_width-to-24-bits-fix.patch
lib-test_printfc-test-dentry-printing-fix.patch
printk-help-pr_debug-and-pr_devel-to-optimize-out-arguments-fix.patch
printk-nmi-generic-solution-for-safe-printk-in-nmi-v4-fix-fix.patch
printk-nmi-warn-when-some-message-has-been-lost-in-nmi-context-fix.patch
ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task-fix.patch
ptrace-use-fsuid-fsgid-effective-creds-for-fs-access-checks-fix.patch
fs-coredump-prevent-core-path-components-fix.patch
ubsan-run-time-undefined-behavior-sanity-checker-fix.patch
ubsan-run-time-undefined-behavior-sanity-checker-fix-3.patch
linux-next-rejects.patch
fs-overlayfs-superc-needs-pagemaph.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
fs-adfs-adfsh-tidy-up-comments.patch
net-drop-tcp_memcontrolc-fix.patch
mm-memcontrol-reign-in-the-config-space-madness-fix.patch
mm-memcontrol-reign-in-the-config-space-madness-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

