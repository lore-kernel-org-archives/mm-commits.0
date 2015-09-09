From: akpm@linux-foundation.org
Subject: [merged]
 mm-add-support-for-__gfp_zero-flag-to-dma_pool_alloc.patch removed from -mm tree
Date: Wed, 09 Sep 2015 12:46:56 -0700
Message-ID: <55f08cb0.vXEl63uACGUlBXCD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39477 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772AbbIITq5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:46:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sean.stalley@intel.com, Gilles.Muller@lip6.fr, bhelgaas@google.com, bigeasy@linutronix.de, corbet@lwn.net, mmarek@suse.cz, nicolas.palix@imag.fr, rientjes@google.com, vinod.koul@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add support for __GFP_ZERO flag to dma_pool_alloc()
has been removed from the -mm tree.  Its filename was
     mm-add-support-for-__gfp_zero-flag-to-dma_pool_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Sean O. Stalley" <sean.stalley@intel.com>
Subject: mm: add support for __GFP_ZERO flag to dma_pool_alloc()

Currently a call to dma_pool_alloc() with a ___GFP_ZERO flag returns a
non-zeroed memory region.

This patchset adds support for the __GFP_ZERO flag to dma_pool_alloc(),
adds 2 wrapper functions for allocing zeroed memory from a pool, and
provides a coccinelle script for finding & replacing instances of
dma_pool_alloc() followed by memset(0) with a single dma_pool_zalloc()
call.

There was some concern that this always calls memset() to zero,
instead of passing __GFP_ZERO into the page allocator.
[https://lkml.org/lkml/2015/7/15/881]

I ran a test on my system to get an idea of how often dma_pool_alloc()
calls into pool_alloc_page().

After Boot:	[   30.119863] alloc_calls:541, page_allocs:7
After an hour:	[ 3600.951031] alloc_calls:9566, page_allocs:12
After copying 1GB file onto a USB drive:
		[ 4260.657148] alloc_calls:17225, page_allocs:12

It doesn't look like dma_pool_alloc() calls down to the page allocator
very often (at least on my system).



This patch (of 4):

Currently the __GFP_ZERO flag is ignored by dma_pool_alloc().
Make dma_pool_alloc() zero the memory if this flag is set.

Signed-off-by: Sean O. Stalley <sean.stalley@intel.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Gilles Muller <Gilles.Muller@lip6.fr>
Cc: Nicolas Palix <nicolas.palix@imag.fr>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/dmapool.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN mm/dmapool.c~mm-add-support-for-__gfp_zero-flag-to-dma_pool_alloc mm/dmapool.c
--- a/mm/dmapool.c~mm-add-support-for-__gfp_zero-flag-to-dma_pool_alloc
+++ a/mm/dmapool.c
@@ -337,7 +337,7 @@ void *dma_pool_alloc(struct dma_pool *po
 	/* pool_alloc_page() might sleep, so temporarily drop &pool->lock */
 	spin_unlock_irqrestore(&pool->lock, flags);
 
-	page = pool_alloc_page(pool, mem_flags);
+	page = pool_alloc_page(pool, mem_flags & (~__GFP_ZERO));
 	if (!page)
 		return NULL;
 
@@ -375,9 +375,14 @@ void *dma_pool_alloc(struct dma_pool *po
 			break;
 		}
 	}
-	memset(retval, POOL_POISON_ALLOCATED, pool->size);
+	if (!(mem_flags & __GFP_ZERO))
+		memset(retval, POOL_POISON_ALLOCATED, pool->size);
 #endif
 	spin_unlock_irqrestore(&pool->lock, flags);
+
+	if (mem_flags & __GFP_ZERO)
+		memset(retval, 0, pool->size);
+
 	return retval;
 }
 EXPORT_SYMBOL(dma_pool_alloc);
_

Patches currently in -mm which might be from sean.stalley@intel.com are


