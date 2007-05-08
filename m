From: akpm@linux-foundation.org
Subject: + slub-add-support-for-dynamic-cacheline-size-determination.patch added to -mm tree
Date: Tue, 08 May 2007 14:48:35 -0700
Message-ID: <200705082148.l48LmZ1A002591@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37377 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968348AbXEHVsj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 17:48:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     SLUB: add support for dynamic cacheline size determination
has been added to the -mm tree.  Its filename is
     slub-add-support-for-dynamic-cacheline-size-determination.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SLUB: add support for dynamic cacheline size determination
From: Christoph Lameter <clameter@sgi.com>

SLUB currently assumes that the cacheline size is static.  However, i386 f.e. 
supports dynamic cache line size determination.

Use cache_line_size() instead of L1_CACHE_BYTES in the allocator.

That also explains the purpose of SLAB_HWCACHE_ALIGN.  So we will need to keep
that one around to allow dynamic aligning of objects depending on boot
determination of the cache line size.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/slub.c~slub-add-support-for-dynamic-cacheline-size-determination mm/slub.c
--- a/mm/slub.c~slub-add-support-for-dynamic-cacheline-size-determination
+++ a/mm/slub.c
@@ -1480,8 +1480,8 @@ static unsigned long calculate_alignment
 	 * then use it.
 	 */
 	if ((flags & SLAB_HWCACHE_ALIGN) &&
-			size > L1_CACHE_BYTES / 2)
-		return max_t(unsigned long, align, L1_CACHE_BYTES);
+			size > cache_line_size() / 2)
+		return max_t(unsigned long, align, cache_line_size());
 
 	if (align < ARCH_SLAB_MINALIGN)
 		return ARCH_SLAB_MINALIGN;
@@ -1667,8 +1667,8 @@ static int calculate_sizes(struct kmem_c
 		size += sizeof(void *);
 	/*
 	 * Determine the alignment based on various parameters that the
-	 * user specified (this is unecessarily complex due to the attempt
-	 * to be compatible with SLAB. Should be cleaned up some day).
+	 * user specified and the dynamic determination of cache line size
+	 * on bootup.
 	 */
 	align = calculate_alignment(flags, align, s->objsize);
 
@@ -2280,7 +2280,7 @@ void __init kmem_cache_init(void)
 
 	printk(KERN_INFO "SLUB: Genslabs=%d, HWalign=%d, Order=%d-%d, MinObjects=%d,"
 		" Processors=%d, Nodes=%d\n",
-		KMALLOC_SHIFT_HIGH, L1_CACHE_BYTES,
+		KMALLOC_SHIFT_HIGH, cache_line_size(),
 		slub_min_order, slub_max_order, slub_min_objects,
 		nr_cpu_ids, nr_node_ids);
 }
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
slub-add-support-for-dynamic-cacheline-size-determination.patch
slub-add-support-for-dynamic-cacheline-size-determination-fix.patch
slub-after-object-padding-only-needed-for-redzoning.patch
slub-slabinfo-upgrade.patch
slub-use-check_valid_pointer-in-kmem_ptr_validate.patch
slub-clean-up-krealloc.patch
slub-clean-up-krealloc-fix.patch
slub-get-rid-of-finish_bootstrap.patch
slub-update-comments.patch
slub-add-macros-for-scanning-objects-in-a-slab.patch
slub-move-resiliency-check-into-sysfs-section.patch
slub-introduce-debugslabpage.patch
slub-consolidate-trace-code.patch
slub-move-tracking-definitions-and-check_valid_pointer-away-from-debug-code.patch
slub-add-config_slub_debug.patch
slub-include-lifetime-stats-and-sets-of-cpus--nodes-in-tracking-output.patch
slub-include-lifetime-stats-and-sets-of-cpus--nodes-in-tracking-output-fix.patch
slub-rework-slab-order-determination.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-reduce-antifrag-max-order.patch
slub-i386-support.patch
remove-constructor-from-buffer_head.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
revoke-core-code-slab-allocators-remove-slab_debug_initial-flag-revoke.patch
vmstat-use-our-own-timer-events.patch
vmstat-use-our-own-timer-events-fix.patch
make-vm-statistics-update-interval-configurable.patch
make-vm-statistics-update-interval-configurable-fix.patch
move-remote-node-draining-out-of-slab-allocators.patch
