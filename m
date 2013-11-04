From: akpm@linux-foundation.org
Subject: +
 sound-core-memallocc-use-gen_pool_dma_alloc-to-allocate-iram-buffer.patch
 added to -mm tree
Date: Mon, 04 Nov 2013 14:17:16 -0800
Message-ID: <52781cec.uvItoH417p9xbuSc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48803 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab3KDWRR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Nov 2013 17:17:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tiwai@suse.de, b42378@freescale.com

Subject: + sound-core-memallocc-use-gen_pool_dma_alloc-to-allocate-iram-buffer.patch added to -mm tree
To: b42378@freescale.com,tiwai@suse.de
From: akpm@linux-foundation.org
Date: Mon, 04 Nov 2013 14:17:16 -0800


The patch titled
     Subject: sound/core/memalloc.c: use gen_pool_dma_alloc() to allocate iram buffer
has been added to the -mm tree.  Its filename is
     sound-core-memallocc-use-gen_pool_dma_alloc-to-allocate-iram-buffer.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sound-core-memallocc-use-gen_pool_dma_alloc-to-allocate-iram-buffer.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sound-core-memallocc-use-gen_pool_dma_alloc-to-allocate-iram-buffer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
