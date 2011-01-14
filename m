From: akpm@linux-foundation.org
Subject: [merged] mm-dmapoolc-take-lock-only-once-in-dma_pool_free.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:49:06 -0800
Message-ID: <201101142251.p0EMpuRA005557@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54968 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753965Ab1ANWwL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:52:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eike-kernel@sf-tec.de, mm-commits@vger.kernel.org


The patch titled
     mm/dmapool.c: take lock only once in dma_pool_free()
has been removed from the -mm tree.  Its filename was
     mm-dmapoolc-take-lock-only-once-in-dma_pool_free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/dmapool.c: take lock only once in dma_pool_free()
From: Rolf Eike Beer <eike-kernel@sf-tec.de>

dma_pool_free() scans for the page to free in the pool list holding the
pool lock.  Then it releases the lock basically to acquire it immediately
again.  Modify the code to only take the lock once.

This will do some additional loops and computations with the lock held in
if memory debugging is activated.  If it is not activated the only new
operations with this lock is one if and one substraction.

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/dmapool.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN mm/dmapool.c~mm-dmapoolc-take-lock-only-once-in-dma_pool_free mm/dmapool.c
--- a/mm/dmapool.c~mm-dmapoolc-take-lock-only-once-in-dma_pool_free
+++ a/mm/dmapool.c
@@ -355,20 +355,15 @@ EXPORT_SYMBOL(dma_pool_alloc);
 
 static struct dma_page *pool_find_page(struct dma_pool *pool, dma_addr_t dma)
 {
-	unsigned long flags;
 	struct dma_page *page;
 
-	spin_lock_irqsave(&pool->lock, flags);
 	list_for_each_entry(page, &pool->page_list, page_list) {
 		if (dma < page->dma)
 			continue;
 		if (dma < (page->dma + pool->allocation))
-			goto done;
+			return page;
 	}
-	page = NULL;
- done:
-	spin_unlock_irqrestore(&pool->lock, flags);
-	return page;
+	return NULL;
 }
 
 /**
@@ -386,8 +381,10 @@ void dma_pool_free(struct dma_pool *pool
 	unsigned long flags;
 	unsigned int offset;
 
+	spin_lock_irqsave(&pool->lock, flags);
 	page = pool_find_page(pool, dma);
 	if (!page) {
+		spin_unlock_irqrestore(&pool->lock, flags);
 		if (pool->dev)
 			dev_err(pool->dev,
 				"dma_pool_free %s, %p/%lx (bad dma)\n",
@@ -401,6 +398,7 @@ void dma_pool_free(struct dma_pool *pool
 	offset = vaddr - page->vaddr;
 #ifdef	DMAPOOL_DEBUG
 	if ((dma - page->dma) != offset) {
+		spin_unlock_irqrestore(&pool->lock, flags);
 		if (pool->dev)
 			dev_err(pool->dev,
 				"dma_pool_free %s, %p (bad vaddr)/%Lx\n",
@@ -418,6 +416,7 @@ void dma_pool_free(struct dma_pool *pool
 				chain = *(int *)(page->vaddr + chain);
 				continue;
 			}
+			spin_unlock_irqrestore(&pool->lock, flags);
 			if (pool->dev)
 				dev_err(pool->dev, "dma_pool_free %s, dma %Lx "
 					"already free\n", pool->name,
@@ -432,7 +431,6 @@ void dma_pool_free(struct dma_pool *pool
 	memset(vaddr, POOL_POISON_FREED, pool->size);
 #endif
 
-	spin_lock_irqsave(&pool->lock, flags);
 	page->in_use--;
 	*(int *)vaddr = page->offset;
 	page->offset = offset;
_

Patches currently in -mm which might be from eike-kernel@sf-tec.de are

origin.patch

