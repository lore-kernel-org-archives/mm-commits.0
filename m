From: akpm@osdl.org
Subject: + mm-fallback_alloc-cpuset_zone_allowed-irq-fix.patch added to -mm tree
Date: Wed, 06 Dec 2006 21:22:58 -0800
Message-ID: <200612070523.kB75Mw2B031314@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49967 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968804AbWLGFXK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 00:23:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pj@sgi.com, menage@google.com


The patch titled
     mm: fallback_alloc cpuset_zone_allowed irq fix
has been added to the -mm tree.  Its filename is
     mm-fallback_alloc-cpuset_zone_allowed-irq-fix.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm: fallback_alloc cpuset_zone_allowed irq fix
From: Paul Jackson <pj@sgi.com>

fallback_alloc() could end up calling cpuset_zone_allowed() with interrupts
disabled (by code in kmem_cache_alloc_node()), but without __GFP_HARDWALL
set, leading to a possible call of a sleeping function with interrupts
disabled.

This results in the BUG report:

  BUG: sleeping function called from invalid context at kernel/cpuset.c:1520
in_atomic():0, irqs_disabled():1

Thanks to Paul Menage for catching this one.

Signed-off-by: Paul Jackson <pj@sgi.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/slab.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slab.c~mm-fallback_alloc-cpuset_zone_allowed-irq-fix mm/slab.c
--- a/mm/slab.c~mm-fallback_alloc-cpuset_zone_allowed-irq-fix
+++ a/mm/slab.c
@@ -3182,7 +3182,7 @@ retry:
 	for (z = zonelist->zones; *z && !obj; z++) {
 		nid = zone_to_nid(*z);
 
-		if (cpuset_zone_allowed(*z, flags) &&
+		if (cpuset_zone_allowed(*z, flags | __GFP_HARDWALL) &&
 			cache->nodelists[nid] &&
 			cache->nodelists[nid]->free_objects)
 				obj = ____cache_alloc_node(cache,
_

Patches currently in -mm which might be from pj@sgi.com are

memory-page-alloc-minor-cleanups.patch
memory-page_alloc-zonelist-caching-speedup.patch
memory-page_alloc-zonelist-caching-reorder-structure.patch
cpuset-minor-code-refinements.patch
cpuset-allow-a-larger-buffer-for-writes-to-cpuset-files.patch
mm-fallback_alloc-cpuset_zone_allowed-irq-fix.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch

