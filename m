From: akpm@linux-foundation.org
Subject: + slub-remove-nr_cpu_ids-hack.patch added to -mm tree
Date: Wed, 09 May 2007 21:29:56 -0700
Message-ID: <200705100429.l4A4Tuea011978@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49824 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754627AbXEJEaF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 00:30:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     SLUB: remove nr_cpu_ids hack
has been added to the -mm tree.  Its filename is
     slub-remove-nr_cpu_ids-hack.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
slub-support-concurrent-local-and-remote-frees-and-allocs-on-a-slab.patch
slub-slub_debug-must-depend-on-slub.patch
slub-remove-nr_cpu_ids-hack.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
slub-i386-support.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-reduce-antifrag-max-order.patch
slub-use-antifrag-constant-instead-of-hardcoding-page-order.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
define-percpu-smp-cacheline-align-interface.patch
call-percpu-smp-cacheline-algin-interface.patch
remove-constructor-from-buffer_head.patch
mm-implement-swap-prefetching.patch
revoke-core-code.patch
