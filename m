From: akpm@linux-foundation.org
Subject: [merged] mm-add-dma_pool_zalloc-call-to-dma-api.patch removed
 from -mm tree
Date: Wed, 09 Sep 2015 12:46:59 -0700
Message-ID: <55f08cb3.RqohFK81pWCs/AOI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39514 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371AbbIITrA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:47:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sean.stalley@intel.com, Gilles.Muller@lip6.fr, bhelgaas@google.com, bigeasy@linutronix.de, corbet@lwn.net, mmarek@suse.cz, nicolas.palix@imag.fr, vinod.koul@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add dma_pool_zalloc() call to DMA API
has been removed from the -mm tree.  Its filename was
     mm-add-dma_pool_zalloc-call-to-dma-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Sean O. Stalley" <sean.stalley@intel.com>
Subject: mm: add dma_pool_zalloc() call to DMA API

Add a wrapper function for dma_pool_alloc() to get zeroed memory.

Signed-off-by: Sean O. Stalley <sean.stalley@intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Gilles Muller <Gilles.Muller@lip6.fr>
Cc: Nicolas Palix <nicolas.palix@imag.fr>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DMA-API.txt |    7 +++++++
 include/linux/dmapool.h   |    6 ++++++
 2 files changed, 13 insertions(+)

diff -puN Documentation/DMA-API.txt~mm-add-dma_pool_zalloc-call-to-dma-api Documentation/DMA-API.txt
--- a/Documentation/DMA-API.txt~mm-add-dma_pool_zalloc-call-to-dma-api
+++ a/Documentation/DMA-API.txt
@@ -104,6 +104,13 @@ crossing restrictions, pass 0 for alloc;
 from this pool must not cross 4KByte boundaries.
 
 
+	void *dma_pool_zalloc(struct dma_pool *pool, gfp_t mem_flags,
+			      dma_addr_t *handle)
+
+Wraps dma_pool_alloc() and also zeroes the returned memory if the
+allocation attempt succeeded.
+
+
 	void *dma_pool_alloc(struct dma_pool *pool, gfp_t gfp_flags,
 			dma_addr_t *dma_handle);
 
diff -puN include/linux/dmapool.h~mm-add-dma_pool_zalloc-call-to-dma-api include/linux/dmapool.h
--- a/include/linux/dmapool.h~mm-add-dma_pool_zalloc-call-to-dma-api
+++ a/include/linux/dmapool.h
@@ -24,6 +24,12 @@ void dma_pool_destroy(struct dma_pool *p
 void *dma_pool_alloc(struct dma_pool *pool, gfp_t mem_flags,
 		     dma_addr_t *handle);
 
+static inline void *dma_pool_zalloc(struct dma_pool *pool, gfp_t mem_flags,
+				    dma_addr_t *handle)
+{
+	return dma_pool_alloc(pool, mem_flags | __GFP_ZERO, handle);
+}
+
 void dma_pool_free(struct dma_pool *pool, void *vaddr, dma_addr_t addr);
 
 /*
_

Patches currently in -mm which might be from sean.stalley@intel.com are


