From: akpm@linux-foundation.org
Subject: [merged]
 sound-core-memallocc-use-gen_pool_dma_alloc-to-allocate-iram-buffer.patch
 removed from -mm tree
Date: Fri, 15 Nov 2013 12:09:27 -0800
Message-ID: <52867f77.GFSOQa6fB6OmWJ6p%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35828 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303Ab3KOUJ1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 15:09:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tiwai@suse.de, b42378@freescale.com

Subject: [merged] sound-core-memallocc-use-gen_pool_dma_alloc-to-allocate-iram-buffer.patch removed from -mm tree
To: b42378@freescale.com,tiwai@suse.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 12:09:27 -0800


The patch titled
     Subject: sound/core/memalloc.c: use gen_pool_dma_alloc() to allocate iram buffer
has been removed from the -mm tree.  Its filename was
     sound-core-memallocc-use-gen_pool_dma_alloc-to-allocate-iram-buffer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nicolin Chen <b42378@freescale.com>
Subject: sound/core/memalloc.c: use gen_pool_dma_alloc() to allocate iram buffer

Since gen_pool_dma_alloc() is introduced, we implement it to simplify code.

Signed-off-by: Nicolin Chen <b42378@freescale.com>
Acked-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/core/memalloc.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN sound/core/memalloc.c~sound-core-memallocc-use-gen_pool_dma_alloc-to-allocate-iram-buffer sound/core/memalloc.c
--- a/sound/core/memalloc.c~sound-core-memallocc-use-gen_pool_dma_alloc-to-allocate-iram-buffer
+++ a/sound/core/memalloc.c
@@ -184,11 +184,7 @@ static void snd_malloc_dev_iram(struct s
 	/* Assign the pool into private_data field */
 	dmab->private_data = pool;
 
-	dmab->area = (void *)gen_pool_alloc(pool, size);
-	if (!dmab->area)
-		return;
