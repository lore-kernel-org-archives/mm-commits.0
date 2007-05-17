From: akpm@linux-foundation.org
Subject: - remove-constructor-from-buffer_head.patch removed from -mm tree
Date: Wed, 16 May 2007 20:32:32 -0700
Message-ID: <200705170332.l4H3WWft016329@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51608 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754214AbXEQDds (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 May 2007 23:33:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Remove constructor from buffer_head
has been removed from the -mm tree.  Its filename was
     remove-constructor-from-buffer_head.patch

This patch was dropped because it was folded into remove-slab_ctor_constructor.patch

------------------------------------------------------
Subject: Remove constructor from buffer_head
From: Christoph Lameter <clameter@sgi.com>

needs changelog

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

diff -puN fs/buffer.c~remove-constructor-from-buffer_head fs/buffer.c
--- a/fs/buffer.c~remove-constructor-from-buffer_head
+++ a/fs/buffer.c
@@ -2898,8 +2898,9 @@ static void recalc_bh_state(void)
 	
 struct buffer_head *alloc_buffer_head(gfp_t gfp_flags)
 {
-	struct buffer_head *ret = kmem_cache_alloc(bh_cachep, gfp_flags);
+	struct buffer_head *ret = kmem_cache_zalloc(bh_cachep, gfp_flags);
 	if (ret) {
+		INIT_LIST_HEAD(&ret->b_assoc_buffers);
 		get_cpu_var(bh_accounting).nr++;
 		recalc_bh_state();
 		put_cpu_var(bh_accounting);
@@ -2918,17 +2919,6 @@ void free_buffer_head(struct buffer_head
 }
 EXPORT_SYMBOL(free_buffer_head);
 
-static void
-init_buffer_head(void *data, struct kmem_cache *cachep, unsigned long flags)
-{
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		struct buffer_head * bh = (struct buffer_head *)data;
-
-		memset(bh, 0, sizeof(*bh));
-		INIT_LIST_HEAD(&bh->b_assoc_buffers);
-	}
-}
-
 static void buffer_exit_cpu(int cpu)
 {
 	int i;
@@ -2955,12 +2945,8 @@ void __init buffer_init(void)
 {
 	int nrpages;
 
-	bh_cachep = kmem_cache_create("buffer_head",
-					sizeof(struct buffer_head), 0,
-					(SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|
-					SLAB_MEM_SPREAD),
-					init_buffer_head,
-					NULL);
+	bh_cachep = KMEM_CACHE(buffer_head,
+			SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|SLAB_MEM_SPREAD);
 
 	/*
 	 * Limit the bh occupancy to 10% of ZONE_NORMAL
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
slub-it-is-legit-to-allocate-a-slab-of-the-maximum-permitted-size.patch
slub-dont-confuse-ctor-and-dtor.patch
slab-allocators-drop-support-for-destructors.patch
slub-remove-depends-on-experimental-and-arch_uses_slab_page_struct.patch
slab-move-two-remaining-slab-specific-definitions-to-slab_defh.patch
slub-define-functions-for-cpu-slab-handling-instead-of-using.patch
slub-define-functions-for-cpu-slab-handling-instead-of-using-fix.patch
slab-warn-on-zero-length-allocations.patch
slub-fix-handling-of-oversized-slabs.patch
slub-slabinfo-fixes.patch
slub-do-our-own-flags-based-on-pg_active-and-pg_error.patch
remove-slab_ctor_constructor.patch
remove-constructor-from-buffer_head.patch
remove-slab_ctor_constructor-fix.patch
slub-simplify-debug-code.patch
slab-allocators-define-common-size-limitations.patch
fix-find_or_create_page-skips-cpuset-memory-spreading.patch
i386-dont-check_pgt_cache-in-flush_tlb_mm.patch
fix-page-allocation-flags-in-grow_dev_page.patch
git-ubi.patch
quicklist-support-for-x86_64.patch
compat_core_sys_select-avoid-kmalloc0.patch
change-zonelist-order-zonelist-order-selection-logic.patch
change-zonelist-order-v6-zonelist-fix.patch
change-zonelist-order-auto-configuration.patch
change-zonelist-order-documentaion.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0-fix.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-reduce-antifrag-max-order.patch
slub-reduce-antifrag-max-order-use-antifrag-constant-instead-of-hardcoding-page-order.patch
mm-implement-swap-prefetching.patch
revoke-core-code.patch
