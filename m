From: akpm@linux-foundation.org
Subject: - dma-coherent-catch-oversized-requests-to-dma_alloc_from_coherent.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:21:03 -0800
Message-ID: <200901072221.n07ML3HX020267@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43451 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762074AbZAGWWB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:22:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, dbaryshkov@gmail.com, jbarnes@virtuousgeek.org, lg@denx.de, penberg@cs.helsinki.fi, penguin-kernel@i-love.sakura.ne.jp, mm-commits@vger.kernel.org


The patch titled
     dma-coherent: catch oversized requests to dma_alloc_from_coherent()
has been removed from the -mm tree.  Its filename was
     dma-coherent-catch-oversized-requests-to-dma_alloc_from_coherent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dma-coherent: catch oversized requests to dma_alloc_from_coherent()
From: Johannes Weiner <hannes@cmpxchg.org>

Prevent passing an order to bitmap_find_free_region() that is larger than
the actual bitmap can represent.

These requests can come from device drivers that have no idea how big the
dma region is and need to rely on dma_alloc_from_coherent() to sort it out
for them.

Reported-by: Guennadi Liakhovetski <lg@denx.de>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/dma-coherent.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/dma-coherent.c~dma-coherent-catch-oversized-requests-to-dma_alloc_from_coherent kernel/dma-coherent.c
--- a/kernel/dma-coherent.c~dma-coherent-catch-oversized-requests-to-dma_alloc_from_coherent
+++ a/kernel/dma-coherent.c
@@ -118,6 +118,8 @@ int dma_alloc_from_coherent(struct devic
 	mem = dev->dma_mem;
 	if (!mem)
 		return 0;
+	if (unlikely(size > mem->size))
+ 		return 0;
 
 	pageno = bitmap_find_free_region(mem->bitmap, mem->size, order);
 	if (pageno >= 0) {
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch

