From: akpm@linux-foundation.org
Subject: - slub-remove-nr_cpu_ids-hack.patch removed from -mm tree
Date: Fri, 11 May 2007 22:15:31 -0700
Message-ID: <200705120515.l4C5FVmK001758@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47157 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756357AbXELFPf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:15:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     SLUB: remove nr_cpu_ids hack
has been removed from the -mm tree.  Its filename was
     slub-remove-nr_cpu_ids-hack.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SLUB: remove nr_cpu_ids hack
From: Christoph Lameter <clameter@sgi.com>

This was in SLUB in order to head off trouble while the nr_cpu_ids
functionality was not merged.  Its merged now so no need to still have this.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/slub.c~slub-remove-nr_cpu_ids-hack mm/slub.c
--- a/mm/slub.c~slub-remove-nr_cpu_ids-hack
+++ a/mm/slub.c
@@ -2445,9 +2445,8 @@ void __init kmem_cache_init(void)
 	register_cpu_notifier(&slab_notifier);
 #endif
 
-	if (nr_cpu_ids)	/* Remove when nr_cpu_ids is fixed upstream ! */
-		kmem_size = offsetof(struct kmem_cache, cpu_slab)
-			 + nr_cpu_ids * sizeof(struct page *);
+	kmem_size = offsetof(struct kmem_cache, cpu_slab) +
+				nr_cpu_ids * sizeof(struct page *);
 
 	printk(KERN_INFO "SLUB: Genslabs=%d, HWalign=%d, Order=%d-%d, MinObjects=%d,"
 		" Processors=%d, Nodes=%d\n",
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
vm-statistics-make-timer-deferrable.patch
quicklist-support-for-ia64.patch
ubi-remove-inverted-check-in-ltree_entry_ctor.patch
quicklist-support-for-x86_64.patch
slub-i386-support.patch
slab-allocators-drop-support-for-destructors.patch
remove-slab_ctor_constructor.patch
remove-constructor-from-buffer_head.patch
remove-slab_ctor_constructor-fix.patch
change-zonelist-order-zonelist-order-selection-logic.patch
change-zonelist-order-v6-zonelist-fix.patch
change-zonelist-order-auto-configuration.patch
change-zonelist-order-documentaion.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-reduce-antifrag-max-order.patch
slub-reduce-antifrag-max-order-use-antifrag-constant-instead-of-hardcoding-page-order.patch
define-percpu-smp-cacheline-align-interface.patch
call-percpu-smp-cacheline-algin-interface.patch
mm-implement-swap-prefetching.patch
revoke-core-code.patch
