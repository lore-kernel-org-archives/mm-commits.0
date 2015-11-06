From: akpm@linux-foundation.org
Subject: [merged]
 mm-slab-only-move-management-objects-off-slab-for-sizes-larger-than-kmalloc_min_size.patch removed from -mm tree
Date: Fri, 06 Nov 2015 12:07:08 -0800
Message-ID: <563d086c.iU3kpq0eK9GVpBN1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48622 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757522AbbKFUHJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:07:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, cl@linux.com, geert@linux-m68k.org, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: slab: only move management objects off-slab for sizes larger than KMALLOC_MIN_SIZE
has been removed from the -mm tree.  Its filename was
     mm-slab-only-move-management-objects-off-slab-for-sizes-larger-than-kmalloc_min_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: mm: slab: only move management objects off-slab for sizes larger than KMALLOC_MIN_SIZE

On systems with a KMALLOC_MIN_SIZE of 128 (arm64, some mips and powerpc
configurations defining ARCH_DMA_MINALIGN to 128), the first
kmalloc_caches[] entry to be initialised after slab_early_init = 0 is
"kmalloc-128" with index 7.  Depending on the debug kernel configuration,
sizeof(struct kmem_cache) can be larger than 128 resulting in an
INDEX_NODE of 8.

Commit 8fc9cf420b36 ("slab: make more slab management structure off the
slab") enables off-slab management objects for sizes starting with
PAGE_SIZE >> 5 (128 bytes for a 4KB page configuration) and the creation
of the "kmalloc-128" cache would try to place the management objects
off-slab.  However, since KMALLOC_MIN_SIZE is already 128 and
freelist_size == 32 in __kmem_cache_create(), kmalloc_slab(freelist_size)
returns NULL (kmalloc_caches[7] not populated yet).  This triggers the
following bug on arm64:

[    0.000000] kernel BUG at /work/Linux/linux-2.6-aarch64/mm/slab.c:2283!
[    0.000000] Internal error: Oops - BUG: 0 [#1] SMP
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 4.3.0-rc4+ #540
[    0.000000] Hardware name: Juno (DT)
[    0.000000] task: ffffffc0006962b0 ti: ffffffc00068c000 task.ti: ffffffc00068c000
[    0.000000] PC is at __kmem_cache_create+0x21c/0x280
[    0.000000] LR is at __kmem_cache_create+0x210/0x280
[...]
[    0.000000] Call trace:
[    0.000000] [<ffffffc000154948>] __kmem_cache_create+0x21c/0x280
[    0.000000] [<ffffffc000652da4>] create_boot_cache+0x48/0x80
[    0.000000] [<ffffffc000652e2c>] create_kmalloc_cache+0x50/0x88
[    0.000000] [<ffffffc000652f14>] create_kmalloc_caches+0x4c/0xf4
[    0.000000] [<ffffffc000654a9c>] kmem_cache_init+0x100/0x118
[    0.000000] [<ffffffc0006447d4>] start_kernel+0x214/0x33c

This patch introduces an OFF_SLAB_MIN_SIZE definition to avoid off-slab
management objects for sizes equal to or smaller than KMALLOC_MIN_SIZE.

Fixes: 8fc9cf420b36 ("slab: make more slab management structure off the slab")
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: <stable@vger.kernel.org>	[3.15+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/slab.c~mm-slab-only-move-management-objects-off-slab-for-sizes-larger-than-kmalloc_min_size mm/slab.c
--- a/mm/slab.c~mm-slab-only-move-management-objects-off-slab-for-sizes-larger-than-kmalloc_min_size
+++ a/mm/slab.c
@@ -282,6 +282,7 @@ static void kmem_cache_node_init(struct
 
 #define CFLGS_OFF_SLAB		(0x80000000UL)
 #define	OFF_SLAB(x)	((x)->flags & CFLGS_OFF_SLAB)
+#define OFF_SLAB_MIN_SIZE (max_t(size_t, PAGE_SIZE >> 5, KMALLOC_MIN_SIZE + 1))
 
 #define BATCHREFILL_LIMIT	16
 /*
@@ -2212,7 +2213,7 @@ __kmem_cache_create (struct kmem_cache *
 	 * it too early on. Always use on-slab management when
 	 * SLAB_NOLEAKTRACE to avoid recursive calls into kmemleak)
 	 */
-	if ((size >= (PAGE_SIZE >> 5)) && !slab_early_init &&
+	if (size >= OFF_SLAB_MIN_SIZE && !slab_early_init &&
 	    !(flags & SLAB_NOLEAKTRACE))
 		/*
 		 * Size is large, assume best to place the slab management obj
@@ -2276,7 +2277,7 @@ __kmem_cache_create (struct kmem_cache *
 		/*
 		 * This is a possibility for one of the kmalloc_{dma,}_caches.
 		 * But since we go off slab only for object size greater than
-		 * PAGE_SIZE/8, and kmalloc_{dma,}_caches get created
+		 * OFF_SLAB_MIN_SIZE, and kmalloc_{dma,}_caches get created
 		 * in ascending order,this should not happen at all.
 		 * But leave a BUG_ON for some lucky dude.
 		 */
_

Patches currently in -mm which might be from catalin.marinas@arm.com are


