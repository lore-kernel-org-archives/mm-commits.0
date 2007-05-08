From: akpm@linux-foundation.org
Subject: - slub-slab-allocators-remove-useless-__gfp_no_grow-flag.patch removed from -mm tree
Date: Mon, 07 May 2007 17:09:07 -0700
Message-ID: <200705080009.l48098KJ009425@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60177 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967493AbXEHAiU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:38:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Slab allocators: remove useless __GFP_NO_GROW flag
has been removed from the -mm tree.  Its filename was
     slub-slab-allocators-remove-useless-__gfp_no_grow-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Slab allocators: remove useless __GFP_NO_GROW flag
From: Christoph Lameter <clameter@sgi.com>

There is no user remaining and I have never seen any use of that flag.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    3 ---
 1 files changed, 3 deletions(-)

diff -puN mm/slub.c~slub-slab-allocators-remove-useless-__gfp_no_grow-flag mm/slub.c
--- a/mm/slub.c~slub-slab-allocators-remove-useless-__gfp_no_grow-flag
+++ a/mm/slub.c
@@ -815,9 +815,6 @@ static struct page *new_slab(struct kmem
 	void *last;
 	void *p;
 
-	if (flags & __GFP_NO_GROW)
-		return NULL;
-
 	BUG_ON(flags & ~(GFP_DMA | GFP_LEVEL_MASK));
 
 	if (flags & __GFP_WAIT)
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
