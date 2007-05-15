From: akpm@linux-foundation.org
Subject: + have-kswapd-keep-a-minimum-order-free-other-than-order-0-fix.patch added to -mm tree
Date: Mon, 14 May 2007 22:58:44 -0700
Message-ID: <200705150558.l4F5whN2002727@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58318 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756111AbXEOF7o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 01:59:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, apw@shadowen.org, mel@csn.ul.ie


The patch titled
     have-kswapd-keep-a-minimum-order-free-other-than-order-0 fix
has been added to the -mm tree.  Its filename is
     have-kswapd-keep-a-minimum-order-free-other-than-order-0-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: have-kswapd-keep-a-minimum-order-free-other-than-order-0 fix
From: Christoph Lameter <clameter@sgi.com>

On third thought: The trouble with this solution is that we will now set
the order to that used by the largest kmalloc cache.  Bad...  this could be
6 on i386 to 13 if CONFIG_LARGE_ALLOCs is set.  The large kmalloc caches
are rarely used and we are used to OOMing if those are utilized to
frequently.

I guess we should only set this for non kmalloc caches then.  So move the
call into kmem_cache_create?  Would make the min order 3 on most of my mm
machines.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/slub.c~have-kswapd-keep-a-minimum-order-free-other-than-order-0-fix mm/slub.c
--- a/mm/slub.c~have-kswapd-keep-a-minimum-order-free-other-than-order-0-fix
+++ a/mm/slub.c
@@ -2006,8 +2006,6 @@ static int kmem_cache_open(struct kmem_c
 #ifdef CONFIG_NUMA
 	s->defrag_ratio = 100;
 #endif
-	raise_kswapd_order(s->order);
-
 	if (init_kmem_cache_nodes(s, gfpflags & ~SLUB_DMA))
 		return 1;
 error:
@@ -2561,6 +2559,7 @@ struct kmem_cache *kmem_cache_create(con
 				goto err;
 			}
 			list_add(&s->list, &slab_caches);
+			raise_kswapd_order(s->order);
 		} else
 			kfree(s);
 	}
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
slab-move-two-remaining-slab-specific-definitions-to-slab_defh.patch
slub-define-functions-for-cpu-slab-handling-instead-of-using.patch
slub-define-functions-for-cpu-slab-handling-instead-of-using-fix.patch
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
