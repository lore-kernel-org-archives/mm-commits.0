From: akpm@linux-foundation.org
Subject: + mm-dmapoolc-take-lock-only-once-in-dma_pool_free.patch added to -mm tree
Date: Tue, 04 Jan 2011 12:37:51 -0800
Message-ID: <201101042037.p04KbpXF023014@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57821 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751426Ab1ADUh6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Jan 2011 15:37:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eike-kernel@sf-tec.de


The patch titled
     mm/dmapool.c: take lock only once in dma_pool_free()
has been added to the -mm tree.  Its filename is
     mm-dmapoolc-take-lock-only-once-in-dma_pool_free.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
mm-dmapoolc-take-lock-only-once-in-dma_pool_free.patch
mm-dmapoolc-use-task_uninterruptible-in-dma_pool_alloc.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit-fix.patch

