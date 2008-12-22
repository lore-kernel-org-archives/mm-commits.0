From: akpm@linux-foundation.org
Subject: + dma-coherent-catch-oversized-requests-to-dma_alloc_from_coherent.patch added to -mm tree
Date: Mon, 22 Dec 2008 14:53:28 -0800
Message-ID: <200812222253.mBMMrSSQ002860@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44748 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754375AbYLVWxi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Dec 2008 17:53:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, dbaryshkov@gmail.com, jbarnes@virtuousgeek.org, lg@denx.de, penberg@cs.helsinki.fi


The patch titled
     dma-coherent: catch oversized requests to dma_alloc_from_coherent()
has been added to the -mm tree.  Its filename is
     dma-coherent-catch-oversized-requests-to-dma_alloc_from_coherent.patch

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/dma-coherent.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN kernel/dma-coherent.c~dma-coherent-catch-oversized-requests-to-dma_alloc_from_coherent kernel/dma-coherent.c
--- a/kernel/dma-coherent.c~dma-coherent-catch-oversized-requests-to-dma_alloc_from_coherent
+++ a/kernel/dma-coherent.c
@@ -112,6 +112,9 @@ int dma_alloc_from_coherent(struct devic
 	struct dma_coherent_mem *mem = dev ? dev->dma_mem : NULL;
 	int order = get_order(size);
 
+	if (unlikely(size > mem->size))
+		return 0;
+
 	if (mem) {
 		int page = bitmap_find_free_region(mem->bitmap, mem->size,
 						     order);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-more-likely-reclaim-madv_sequential-mappings.patch
mm-apply_to_range-call-pte-function-with-lazy-updates.patch
vmscan-shrink_active_list-reduce-lru_lock-hold-time.patch
dma-coherent-catch-oversized-requests-to-dma_alloc_from_coherent.patch

