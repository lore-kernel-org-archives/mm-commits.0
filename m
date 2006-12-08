From: akpm@osdl.org
Subject: - mm-fallback_alloc-cpuset_zone_allowed-irq-fix.patch removed from -mm tree
Date: Fri, 08 Dec 2006 11:59:16 -0800
Message-ID: <200612081959.kB8JxGIn001609@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56301 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426166AbWLHT7W (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 14:59:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pj@sgi.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     mm: fallback_alloc cpuset_zone_allowed irq fix
has been removed from the -mm tree.  Its filename was
     mm-fallback_alloc-cpuset_zone_allowed-irq-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
mm-fallback_alloc-cpuset_zone_allowed-irq-fix.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch

