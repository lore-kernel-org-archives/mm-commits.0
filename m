From: akpm@linux-foundation.org
Subject: - slab-allocators-remove-multiple-alignment-specifications.patch removed from -mm tree
Date: Mon, 07 May 2007 17:03:29 -0700
Message-ID: <200705080003.l4803ThA008955@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39513 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967339AbXEHADv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:03:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     slab allocators: remove multiple alignment specifications
has been removed from the -mm tree.  Its filename was
     slab-allocators-remove-multiple-alignment-specifications.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: slab allocators: remove multiple alignment specifications
From: Christoph Lameter <clameter@sgi.com>

It is not necessary to tell the slab allocators to align to a cacheline
if an explicit alignment was already specified. It is rather confusing
to specify multiple alignments.

Make sure that the call sites only use one form of alignment.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/hugetlbpage.c |    2 +-
 arch/powerpc/mm/init_64.c     |    2 +-
 arch/sparc64/mm/tsb.c         |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/powerpc/mm/hugetlbpage.c~slab-allocators-remove-multiple-alignment-specifications arch/powerpc/mm/hugetlbpage.c
--- a/arch/powerpc/mm/hugetlbpage.c~slab-allocators-remove-multiple-alignment-specifications
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -1057,7 +1057,7 @@ static int __init hugetlbpage_init(void)
 	huge_pgtable_cache = kmem_cache_create("hugepte_cache",
 					       HUGEPTE_TABLE_SIZE,
 					       HUGEPTE_TABLE_SIZE,
-					       SLAB_HWCACHE_ALIGN,
+					       0,
 					       zero_ctor, NULL);
 	if (! huge_pgtable_cache)
 		panic("hugetlbpage_init(): could not create hugepte cache\n");
diff -puN arch/powerpc/mm/init_64.c~slab-allocators-remove-multiple-alignment-specifications arch/powerpc/mm/init_64.c
--- a/arch/powerpc/mm/init_64.c~slab-allocators-remove-multiple-alignment-specifications
+++ a/arch/powerpc/mm/init_64.c
@@ -183,7 +183,7 @@ void pgtable_cache_init(void)
 		    "for size: %08x...\n", name, i, size);
 		pgtable_cache[i] = kmem_cache_create(name,
 						     size, size,
-						     SLAB_HWCACHE_ALIGN,
+						     0,
 						     zero_ctor,
 						     NULL);
 		if (! pgtable_cache[i])
diff -puN arch/sparc64/mm/tsb.c~slab-allocators-remove-multiple-alignment-specifications arch/sparc64/mm/tsb.c
--- a/arch/sparc64/mm/tsb.c~slab-allocators-remove-multiple-alignment-specifications
+++ a/arch/sparc64/mm/tsb.c
@@ -262,7 +262,7 @@ void __init pgtable_cache_init(void)
 
 		tsb_caches[i] = kmem_cache_create(name,
 						  size, size,
-						  SLAB_HWCACHE_ALIGN,
+						  0,
 						  NULL, NULL);
 		if (!tsb_caches[i]) {
 			prom_printf("Could not create %s cache\n", name);
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-i386-support.patch
remove-constructor-from-buffer_head.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
revoke-core-code-slab-allocators-remove-slab_debug_initial-flag-revoke.patch
vmstat-use-our-own-timer-events.patch
make-vm-statistics-update-interval-configurable.patch
make-vm-statistics-update-interval-configurable-fix.patch
readahead-state-based-method-aging-accounting.patch
