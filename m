From: akpm@linux-foundation.org
Subject: + slub-fix-locking-for-hotplug-callbacks.patch added to -mm tree
Date: Thu, 31 May 2007 16:28:22 -0700
Message-ID: <200705312328.l4VNSMlC030656@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:50736 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750822AbXEaX3B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 May 2007 19:29:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, michal.k.k.piotrowski@gmail.com


The patch titled
     SLUB: fix locking for hotplug callbacks
has been added to the -mm tree.  Its filename is
     slub-fix-locking-for-hotplug-callbacks.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SLUB: fix locking for hotplug callbacks
From: Christoph Lameter <clameter@sgi.com>

Hotplug callbacks are performed with interrupts enabled.  Slub requires
interrupts to be disabled for flushing caches.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletion(-)

diff -puN mm/slub.c~slub-fix-locking-for-hotplug-callbacks mm/slub.c
--- a/mm/slub.c~slub-fix-locking-for-hotplug-callbacks
+++ a/mm/slub.c
@@ -2608,6 +2608,19 @@ static void for_all_slabs(void (*func)(s
 }
 
 /*
+ * Version of __flush_cpu_slab for the case that interrupts
+ * are enabled.
+ */
+static void cpu_slab_flush(struct kmem_cache *s, int cpu)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	__flush_cpu_slab(s, cpu);
+	local_irq_restore(flags);
+}
+
+/*
  * Use the cpu notifier to insure that the cpu slabs are flushed when
  * necessary.
  */
@@ -2621,7 +2634,7 @@ static int __cpuinit slab_cpuup_callback
 	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
-		for_all_slabs(__flush_cpu_slab, cpu);
+		for_all_slabs(cpu_slab_flush, cpu);
 		break;
 	default:
 		break;
_

Patches currently in -mm which might be from clameter@sgi.com are

slub-more-documentation.patch
ntfs_init_locked_inode-fix-array-indexing.patch
slub-fix-numa--sysfs-bootstrap-issue.patch
fix-gregkh-driver-dmi-based-module-autoloading.patch
git-ubi.patch
quicklist-support-for-x86_64.patch
slub-fix-locking-for-hotplug-callbacks.patch
change-zonelist-order-zonelist-order-selection-logic.patch
change-zonelist-order-zonelist-order-selection-logic-add-check_highest_zone-to-build_zonelists_in_zone_order.patch
change-zonelist-order-v6-zonelist-fix.patch
change-zonelist-order-auto-configuration.patch
change-zonelist-order-documentaion.patch
make-proc-slabinfo-use-seq_list_xxx-helpers.patch
remove-the-deprecated-kmem_cache_t-typedef-from-slabh.patch
slub-use-ilog2-instead-of-series-of-constant-comparisons.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0-fix.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-reduce-antifrag-max-order.patch
slub-reduce-antifrag-max-order-use-antifrag-constant-instead-of-hardcoding-page-order.patch
slub-change-error-reporting-format-to-follow-lockdep-loosely.patch
slub-change-error-reporting-format-to-follow-lockdep-loosely-fix.patch
hexdump-more-output-formatting.patch
define-config_bounce-to-avoid-useless-inclusion-of-bounce-buffer.patch
define-new-percpu-interface-for-shared-data.patch
use-the-new-percpu-interface-for-shared-data.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
