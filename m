From: akpm@linux-foundation.org
Subject: [folded-merged] mm-slab-support-slab-merge-fix.patch removed from -mm tree
Date: Thu, 09 Oct 2014 13:31:49 -0700
Message-ID: <5436f0b5.z238Nzy0uYWfEPc9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35429 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbaJIUbt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2014 16:31:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: adjust object_size in order to fix bug in slab merge
has been removed from the -mm tree.  Its filename was
     mm-slab-support-slab-merge-fix.patch

This patch was dropped because it was folded into mm-slab-support-slab-merge.patch

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/slab: adjust object_size in order to fix bug in slab merge

Fengguang reported following bug and his bisect result points
to this patch ('mm/slab: support slab merge') as root cause.

[    0.466034] BUG: unable to handle kernel paging request at 00010023
[    0.466989] IP: [<c117dcf9>] kernfs_add_one+0x89/0x130
[    0.467812] *pdpt = 0000000000000000 *pde = f000ff53f000ff53
[    0.468000] Oops: 0002 [#1] SMP
[    0.468000] Modules linked in:
[    0.468000] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.17.0-rc6-00089-g36fbfeb #1
[    0.468000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.468000] task: d303ec90 ti: d3040000 task.ti: d3040000
[    0.468000] EIP: 0060:[<c117dcf9>] EFLAGS: 00010286 CPU: 0
[    0.468000] EIP is at kernfs_add_one+0x89/0x130
[    0.468000] EAX: 542572cb EBX: 00010003 ECX: 00000008 EDX: 2c8de598
[    0.468000] ESI: d311de10 EDI: d311de70 EBP: d3041dd8 ESP: d3041db4
[    0.468000]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    0.468000] CR0: 8005003b CR2: 00010023 CR3: 01a8a000 CR4: 000006f0
[    0.468000] Stack:
[    0.468000]  d3006f00 00000202 d311de70 d311de10 d3041dd8 c117dba0 d311de10 c159a5c0
[    0.468000]  c1862a00 d3041df0 c117f0f2 00000000 c18629f4 d311de70 00000000 d3041e2c
[    0.468000]  c117f8b5 00001000 00000000 c159a5c0 c18629f4 00000000 00000001 c1862a00
[    0.468000] Call Trace:
[    0.468000]  [<c117dba0>] ? kernfs_new_node+0x30/0x40
[    0.468000]  [<c117f0f2>] __kernfs_create_file+0x92/0xc0
[    0.468000]  [<c117f8b5>] sysfs_add_file_mode_ns+0x95/0x190
[    0.468000]  [<c117f9d7>] sysfs_create_file_ns+0x27/0x40
[    0.468000]  [<c1252ef6>] kobject_add_internal+0x136/0x2c0
[    0.468000]  [<c125e360>] ? kvasprintf+0x40/0x50
[    0.468000]  [<c1252a92>] ? kobject_set_name_vargs+0x42/0x60
[    0.468000]  [<c12530b5>] kobject_init_and_add+0x35/0x50
[    0.468000]  [<c12ad04f>] acpi_sysfs_add_hotplug_profile+0x24/0x4a
[    0.468000]  [<c12a7280>] acpi_scan_add_handler_with_hotplug+0x21/0x28
[    0.468000]  [<c18df524>] acpi_pci_root_init+0x20/0x22
[    0.468000]  [<c18df0e1>] acpi_scan_init+0x24/0x16d
[    0.468000]  [<c18def73>] acpi_init+0x20c/0x224
[    0.468000]  [<c18ded67>] ? acpi_sleep_init+0xab/0xab
[    0.468000]  [<c100041e>] do_one_initcall+0x7e/0x1b0
[    0.468000]  [<c18ded67>] ? acpi_sleep_init+0xab/0xab
[    0.468000]  [<c18b24ba>] ? repair_env_string+0x12/0x54
[    0.468000]  [<c18b24a8>] ? initcall_blacklist+0x7c/0x7c
[    0.468000]  [<c105e100>] ? parse_args+0x160/0x3f0
[    0.468000]  [<c18b2bd1>] kernel_init_freeable+0xfc/0x179
[    0.468000]  [<c156782b>] kernel_init+0xb/0xd0
[    0.468000]  [<c1574601>] ret_from_kernel_thread+0x21/0x30
[    0.468000]  [<c1567820>] ? rest_init+0xb0/0xb0
[snip...]
[    0.468000] EIP: [<c117dcf9>] kernfs_add_one+0x89/0x130 SS:ESP 0068:d3041db4
[    0.468000] CR2: 0000000000010023
[    0.468000] ---[ end trace 4fa173691404b63f ]---
[    0.468000] Kernel panic - not syncing: Fatal exception

This error is caused by wrongly initialized object due to slab merge.
Size of vm_area_struct is 92 bytes in this configuration, and, for better
alignment, this kmem_cache manage memory in 96 bytes unit. But, maybe for
performance reason, if user requests zeroing for this object, object is
cleared up to 92 bytes.

Meanwhile, size of kernfs_node_cache is 96 bytes so that it can be merged
with kmem_cache for vm_area_struct. In this situation, if user request
zeroing for objects for kernfs_node_cache, object is only cleared up to
92 bytes. So, kernfs_node had odd value on iattr field and this results in
de-referencing wrong address bug.

To fix this problem, object size is adjusted when merging occurs.
After this change, zeroing will be done to complete object so that
de-referencing wrong address can't happen.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN mm/slab.c~mm-slab-support-slab-merge-fix mm/slab.c
--- a/mm/slab.c~mm-slab-support-slab-merge-fix
+++ a/mm/slab.c
@@ -2118,9 +2118,15 @@ __kmem_cache_alias(const char *name, siz
 	struct kmem_cache *cachep;
 
 	cachep = find_mergeable(size, align, flags, name, ctor);
-	if (cachep)
+	if (cachep) {
 		cachep->refcount++;
 
+		/*
+		 * Adjust the object sizes so that we clear
+		 * the complete object on kzalloc.
+		 */
+		cachep->object_size = max_t(int, cachep->object_size, size);
+	}
 	return cachep;
 }
 
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-slab_commonc-suppress-warning.patch
mm-slab_common-move-kmem_cache-definition-to-internal-header.patch
mm-slb-always-track-caller-in-kmalloc_node_track_caller.patch
mm-slab-move-cache_flusharray-out-of-unlikelytext-section.patch
mm-slab-noinline-__ac_put_obj.patch
mm-slab-factor-out-unlikely-part-of-cache_free_alien.patch
slub-disable-tracing-and-failslab-for-merged-slabs.patch
topology-add-support-for-node_to_mem_node-to-determine-the-fallback-node.patch
slub-fallback-to-node_to_mem_node-node-if-allocating-on-memoryless-node.patch
partial-revert-of-81c98869faa5-kthread-ensure-locality-of-task_struct-allocations.patch
slab-fix-for_each_kmem_cache_node.patch
mm-slab_common-commonize-slab-merge-logic.patch
mm-slab-support-slab-merge.patch
mm-slab-use-percpu-allocator-for-cpu-cache.patch
mm-slab-use-percpu-allocator-for-cpu-cache-fix.patch
mm-cma-adjust-address-limit-to-avoid-hitting-low-high-memory-boundary.patch
arm-mm-dont-limit-default-cma-region-only-to-low-memory.patch
mm-page_alloc-determine-migratetype-only-once.patch
mm-thp-dont-hold-mmap_sem-in-khugepaged-when-allocating-thp.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone-fix.patch
mm-compaction-do-not-count-compact_stall-if-all-zones-skipped-compaction.patch
mm-compaction-do-not-recheck-suitable_migration_target-under-lock.patch
mm-compaction-move-pageblock-checks-up-from-isolate_migratepages_range.patch
mm-compaction-move-pageblock-checks-up-from-isolate_migratepages_range-fix.patch
mm-compaction-reduce-zone-checking-frequency-in-the-migration-scanner.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched-fix.patch
mm-compaction-remember-position-within-pageblock-in-free-pages-scanner.patch
mm-compaction-skip-buddy-pages-by-their-order-in-the-migrate-scanner.patch
mm-rename-allocflags_to_migratetype-for-clarity.patch
mm-compaction-pass-gfp-mask-to-compact_control.patch
mm-use-__seq_open_private-instead-of-seq_open.patch
memcg-move-memcg_allocfree_cache_params-to-slab_commonc.patch
memcg-dont-call-memcg_update_all_caches-if-new-cache-id-fits.patch
memcg-move-memcg_update_cache_size-to-slab_commonc.patch
cma-document-cma=0.patch
zsmalloc-move-pages_allocated-to-zs_pool.patch
zsmalloc-change-return-value-unit-of-zs_get_total_size_bytes.patch
zram-zram-memory-size-limitation.patch
zram-report-maximum-used-memory.patch

