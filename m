From: akpm@linux-foundation.org
Subject: + slub-config_large_allocs-must-consider-max_order-limit.patch added to -mm tree
Date: Mon, 14 May 2007 17:16:29 -0700
Message-ID: <200705150016.l4F0GTvd029884@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57788 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756968AbXEOAQw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 May 2007 20:16:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, davem@davemloft.net


The patch titled
     SLUB: CONFIG_LARGE_ALLOCS must consider MAX_ORDER limit
has been added to the -mm tree.  Its filename is
     slub-config_large_allocs-must-consider-max_order-limit.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SLUB: CONFIG_LARGE_ALLOCS must consider MAX_ORDER limit
From: Christoph Lameter <clameter@sgi.com>

Take MAX_ORDER into consideration when determining KMALLOC_SHIFT_HIGH. 
Otherwise we may run into a situation where we attempt to create general
slabs larger than MAX_ORDER.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slub_def.h |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletion(-)

diff -puN include/linux/slub_def.h~slub-config_large_allocs-must-consider-max_order-limit include/linux/slub_def.h
--- a/include/linux/slub_def.h~slub-config_large_allocs-must-consider-max_order-limit
+++ a/include/linux/slub_def.h
@@ -60,7 +60,8 @@ struct kmem_cache {
 #define KMALLOC_SHIFT_LOW 3
 
 #ifdef CONFIG_LARGE_ALLOCS
-#define KMALLOC_SHIFT_HIGH 25
+#define KMALLOC_SHIFT_HIGH ((MAX_ORDER + PAGE_SHIFT) =< 25 ? \
+				MAX_ORDER + PAGE_SHIFT - 1 : 25)
 #else
 #if !defined(CONFIG_MMU) || NR_CPUS > 512 || MAX_NUMNODES > 256
 #define KMALLOC_SHIFT_HIGH 20
@@ -87,6 +88,9 @@ static inline int kmalloc_index(int size
 	 */
 	WARN_ON_ONCE(size == 0);
 
+	if (size >= (1UL << KMALLOC_SHIFT_HIGH))
+		return -1;
+
 	if (size > 64 && size <= 96)
 		return 1;
 	if (size > 128 && size <= 192)
_

Patches currently in -mm which might be from clameter@sgi.com are

slub-config_large_allocs-must-consider-max_order-limit.patch
slub-config_large_allocs-must-consider-max_order-limit-fix.patch
git-ubi.patch
quicklist-support-for-x86_64.patch
slab-allocators-drop-support-for-destructors.patch
remove-slab_ctor_constructor.patch
remove-constructor-from-buffer_head.patch
remove-slab_ctor_constructor-fix.patch
slub-remove-depends-on-experimental-and-arch_uses_slab_page_struct.patch
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
