From: akpm@linux-foundation.org
Subject: [merged] dmapool-make-dmapool_debug-detect-corruption-of-free-marker.patch removed from -mm tree
Date: Wed, 12 Dec 2012 11:58:49 -0800
Message-ID: <20121212195849.A18C582004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:33172 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab2LLT6u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 14:58:50 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so118441ghb.1
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 11:58:49 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthieu.castet@parrot.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dmapool: make DMAPOOL_DEBUG detect corruption of free marker
has been removed from the -mm tree.  Its filename was
     dmapool-make-dmapool_debug-detect-corruption-of-free-marker.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthieu CASTET <matthieu.castet@parrot.com>
Subject: dmapool: make DMAPOOL_DEBUG detect corruption of free marker

This can help to catch the case where hardware is writing after dma free.

[akpm@linux-foundation.org: tidy code, fix comment, use sizeof(page->offset), use pr_err()]
Signed-off-by: Matthieu Castet <matthieu.castet@parrot.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/dmapool.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff -puN mm/dmapool.c~dmapool-make-dmapool_debug-detect-corruption-of-free-marker mm/dmapool.c
--- a/mm/dmapool.c~dmapool-make-dmapool_debug-detect-corruption-of-free-marker
+++ a/mm/dmapool.c
@@ -332,6 +332,30 @@ void *dma_pool_alloc(struct dma_pool *po
 	retval = offset + page->vaddr;
 	*handle = offset + page->dma;
 #ifdef	DMAPOOL_DEBUG
+	{
+		int i;
+		u8 *data = retval;
+		/* page->offset is stored in first 4 bytes */
+		for (i = sizeof(page->offset); i < pool->size; i++) {
+			if (data[i] == POOL_POISON_FREED)
+				continue;
+			if (pool->dev)
+				dev_err(pool->dev,
+					"dma_pool_alloc %s, %p (corruped)\n",
+					pool->name, retval);
+			else
+				pr_err("dma_pool_alloc %s, %p (corruped)\n",
+					pool->name, retval);
+
+			/*
+			 * Dump the first 4 bytes even if they are not
+			 * POOL_POISON_FREED
+			 */
+			print_hex_dump(KERN_ERR, "", DUMP_PREFIX_OFFSET, 16, 1,
+					data, pool->size, 1);
+			break;
+		}
+	}
 	memset(retval, POOL_POISON_ALLOCATED, pool->size);
 #endif
 	spin_unlock_irqrestore(&pool->lock, flags);
_

Patches currently in -mm which might be from matthieu.castet@parrot.com are

origin.patch
linux-next.patch

