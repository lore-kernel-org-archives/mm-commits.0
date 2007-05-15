From: akpm@linux-foundation.org
Subject: + slab-warn-on-zero-length-allocations.patch added to -mm tree
Date: Tue, 15 May 2007 12:02:55 -0700
Message-ID: <200705151902.l4FJ2tgu015229@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37167 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755947AbXEOTDD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 15:03:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     slab: warn on zero-length allocations
has been added to the -mm tree.  Its filename is
     slab-warn-on-zero-length-allocations.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: slab: warn on zero-length allocations
From: Christoph Lameter <clameter@sgi.com>

slub warns on this, and we're working on making kmalloc(0) return NULL. 
Let's make slab warn as well so our testers detect such callers more
rapidly.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN mm/slab.c~slab-warn-on-zero-length-allocations mm/slab.c
--- a/mm/slab.c~slab-warn-on-zero-length-allocations
+++ a/mm/slab.c
@@ -789,6 +789,7 @@ static inline struct kmem_cache *__find_
 	 */
 	BUG_ON(malloc_sizes[INDEX_AC].cs_cachep == NULL);
 #endif
+	WARN_ON_ONCE(size == 0);
 	while (size > csizep->cs_size)
 		csizep++;
 
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
git-ubi.patch
quicklist-support-for-x86_64.patch
slab-allocators-drop-support-for-destructors.patch
remove-slab_ctor_constructor.patch
remove-constructor-from-buffer_head.patch
remove-slab_ctor_constructor-fix.patch
slub-remove-depends-on-experimental-and-arch_uses_slab_page_struct.patch
slab-move-two-remaining-slab-specific-definitions-to-slab_defh.patch
slub-define-functions-for-cpu-slab-handling-instead-of-using.patch
slub-define-functions-for-cpu-slab-handling-instead-of-using-fix.patch
slab-warn-on-zero-length-allocations.patch
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
define-percpu-smp-cacheline-align-interface.patch
call-percpu-smp-cacheline-algin-interface.patch
mm-implement-swap-prefetching.patch
revoke-core-code.patch
