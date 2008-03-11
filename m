From: akpm@linux-foundation.org
Subject: + dmapool-enable-debugging-for-config_slub_debug_on-too.patch added to -mm tree
Date: Mon, 10 Mar 2008 21:17:55 -0700
Message-ID: <200803110417.m2B4HtUu021738@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54570 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751264AbYCKESI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Mar 2008 00:18:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andi@firstfloor.org, ak@suse.de, clameter@sgi.com, matthew@wil.cx


The patch titled
     dmapool: enable debugging for CONFIG_SLUB_DEBUG_ON too
has been added to the -mm tree.  Its filename is
     dmapool-enable-debugging-for-config_slub_debug_on-too.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dmapool: enable debugging for CONFIG_SLUB_DEBUG_ON too
From: Andi Kleen <andi@firstfloor.org>

Previously it was only enabled for CONFIG_SLAB_DEBUG.

Not hooked into the slub runtime debug configuration, so you currently only
get it with CONFIG_SLUB_DEBUG_ON, not plain CONFIG_SLUB_DEBUG

Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Matthew Wilcox <matthew@wil.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/dmapool.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN mm/dmapool.c~dmapool-enable-debugging-for-config_slub_debug_on-too mm/dmapool.c
--- a/mm/dmapool.c~dmapool-enable-debugging-for-config_slub_debug_on-too
+++ a/mm/dmapool.c
@@ -37,6 +37,10 @@
 #include <linux/types.h>
 #include <linux/wait.h>
 
+#if defined(CONFIG_SLAB_DEBUG) || defined(CONFIG_SLUB_DEBUG_ON)
+#define DMAPOOL_DEBUG 1
+#endif
+
 struct dma_pool {		/* the pool */
 	struct list_head page_list;
 	spinlock_t lock;
@@ -216,7 +220,7 @@ static struct dma_page *pool_alloc_page(
 	page->vaddr = dma_alloc_coherent(pool->dev, pool->allocation,
 					 &page->dma, mem_flags);
 	if (page->vaddr) {
-#ifdef	CONFIG_DEBUG_SLAB
+#ifdef	DMAPOOL_DEBUG
 		memset(page->vaddr, POOL_POISON_FREED, pool->allocation);
 #endif
 		pool_initialise_page(pool, page);
@@ -239,7 +243,7 @@ static void pool_free_page(struct dma_po
 {
 	dma_addr_t dma = page->dma;
 
-#ifdef	CONFIG_DEBUG_SLAB
+#ifdef	DMAPOOL_DEBUG
 	memset(page->vaddr, POOL_POISON_FREED, pool->allocation);
 #endif
 	dma_free_coherent(pool->dev, pool->allocation, page->vaddr, dma);
@@ -336,7 +340,7 @@ void *dma_pool_alloc(struct dma_pool *po
 	page->offset = *(int *)(page->vaddr + offset);
 	retval = offset + page->vaddr;
 	*handle = offset + page->dma;
-#ifdef	CONFIG_DEBUG_SLAB
+#ifdef	DMAPOOL_DEBUG
 	memset(retval, POOL_POISON_ALLOCATED, pool->size);
 #endif
  done:
@@ -391,7 +395,7 @@ void dma_pool_free(struct dma_pool *pool
 	}
 
 	offset = vaddr - page->vaddr;
-#ifdef	CONFIG_DEBUG_SLAB
+#ifdef	DMAPOOL_DEBUG
 	if ((dma - page->dma) != offset) {
 		if (pool->dev)
 			dev_err(pool->dev,
_

Patches currently in -mm which might be from andi@firstfloor.org are

git-x86.patch
git-scsi-misc.patch
block-fix-memory-hotplug-and-bouncing-in-block-layer.patch
dmapool-enable-debugging-for-config_slub_debug_on-too.patch

