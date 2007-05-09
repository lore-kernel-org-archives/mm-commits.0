From: akpm@linux-foundation.org
Subject: - slub-after-object-padding-only-needed-for-redzoning.patch removed from -mm tree
Date: Wed, 09 May 2007 14:47:49 -0700
Message-ID: <200705092147.l49Lln5M002512@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55835 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755877AbXEIVrv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:47:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     SLUB: after object padding only needed for Redzoning
has been removed from the -mm tree.  Its filename was
     slub-after-object-padding-only-needed-for-redzoning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SLUB: after object padding only needed for Redzoning
From: Christoph Lameter <clameter@sgi.com>

If no redzoning is selected then we do not need padding before the next
object.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slub.c~slub-after-object-padding-only-needed-for-redzoning mm/slub.c
--- a/mm/slub.c~slub-after-object-padding-only-needed-for-redzoning
+++ a/mm/slub.c
@@ -1661,7 +1661,7 @@ static int calculate_sizes(struct kmem_c
 		 */
 		size += 2 * sizeof(struct track);
 
-	if (flags & DEBUG_DEFAULT_FLAGS)
+	if (flags & SLAB_RED_ZONE)
 		/*
 		 * Add some empty padding so that we can catch
 		 * overwrites from earlier objects rather than let
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
slub-support-concurrent-local-and-remote-frees-and-allocs-on-a-slab.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-reduce-antifrag-max-order.patch
slub-i386-support.patch
define-percpu-smp-cacheline-align-interface.patch
call-percpu-smp-cacheline-algin-interface.patch
remove-constructor-from-buffer_head.patch
mm-implement-swap-prefetching.patch
revoke-core-code.patch
