From: akpm@linux-foundation.org
Subject: + dma-coherent-catch-oversized-requests-to-dma_alloc_from_coherent.patch added to -mm tree
Date: Tue, 23 Dec 2008 23:37:38 -0800
Message-ID: <200812240737.mBO7bc79014498@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56418 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752731AbYLXHiX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Dec 2008 02:38:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, dbaryshkov@gmail.com, jbarnes@virtuousgeek.org, lg@denx.de, penberg@cs.helsinki.fi, penguin-kernel@i-love.sakura.ne.jp


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

mm-more-likely-reclaim-madv_sequential-mappings.patch
mm-apply_to_range-call-pte-function-with-lazy-updates.patch
vmscan-shrink_active_list-reduce-lru_lock-hold-time.patch
dma_alloc_coherent-clean-it-up.patch
dma-coherent-catch-oversized-requests-to-dma_alloc_from_coherent.patch

