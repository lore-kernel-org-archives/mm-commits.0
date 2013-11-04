From: akpm@linux-foundation.org
Subject: +
 sound-soc-pxa-mmp-pcmc-use-gen_pool_dma_alloc-to-allocate-dma-buffer.patch
 added to -mm tree
Date: Mon, 04 Nov 2013 14:17:15 -0800
Message-ID: <52781ceb.W4drMGwRPNNG+aU5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48797 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab3KDWRQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Nov 2013 17:17:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, linux@arm.linux.org.uk, lgirdwood@gmail.com, haojian.zhuang@gmail.com, eric.y.miao@gmail.com, broonie@kernel.org, b42378@freescale.com

Subject: + sound-soc-pxa-mmp-pcmc-use-gen_pool_dma_alloc-to-allocate-dma-buffer.patch added to -mm tree
To: b42378@freescale.com,broonie@kernel.org,eric.y.miao@gmail.com,haojian.zhuang@gmail.com,lgirdwood@gmail.com,linux@arm.linux.org.uk
From: akpm@linux-foundation.org
Date: Mon, 04 Nov 2013 14:17:15 -0800


The patch titled
     Subject: sound/soc/pxa/mmp-pcm.c: use gen_pool_dma_alloc() to allocate dma buffer
has been added to the -mm tree.  Its filename is
     sound-soc-pxa-mmp-pcmc-use-gen_pool_dma_alloc-to-allocate-dma-buffer.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sound-soc-pxa-mmp-pcmc-use-gen_pool_dma_alloc-to-allocate-dma-buffer.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sound-soc-pxa-mmp-pcmc-use-gen_pool_dma_alloc-to-allocate-dma-buffer.patch

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
Subject: sound/soc/pxa/mmp-pcm.c: use gen_pool_dma_alloc() to allocate dma buffer

Since gen_pool_dma_alloc() is introduced, we implement it to simplify code.

Signed-off-by: Nicolin Chen <b42378@freescale.com>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/soc/pxa/mmp-pcm.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN sound/soc/pxa/mmp-pcm.c~sound-soc-pxa-mmp-pcmc-use-gen_pool_dma_alloc-to-allocate-dma-buffer sound/soc/pxa/mmp-pcm.c
--- a/sound/soc/pxa/mmp-pcm.c~sound-soc-pxa-mmp-pcmc-use-gen_pool_dma_alloc-to-allocate-dma-buffer
+++ a/sound/soc/pxa/mmp-pcm.c
@@ -201,10 +201,9 @@ static int mmp_pcm_preallocate_dma_buffe
 	if (!gpool)
 		return -ENOMEM;
 
-	buf->area = (unsigned char *)gen_pool_alloc(gpool, size);
+	buf->area = gen_pool_dma_alloc(gpool, size, &buf->addr);
 	if (!buf->area)
 		return -ENOMEM;
-	buf->addr = gen_pool_virt_to_phys(gpool, (unsigned long)buf->area);
 	buf->bytes = size;
 	return 0;
 }
_

Patches currently in -mm which might be from b42378@freescale.com are

linux-next.patch
lib-genalloc-add-a-helper-function-for-dma-buffer-allocation.patch
arch-arm-mach-davinci-sramc-use-gen_pool_dma_alloc-to-sramc.patch
drivers-dma-mmp_tdmac-use-gen_pool_dma_alloc-to-allocate-descriptor.patch
drivers-media-platform-codac-use-gen_pool_dma_alloc-to-allocate-iram-buffer.patch
drivers-uio-uio_prussc-use-gen_pool_dma_alloc-to-allocate-sram-memory.patch
sound-soc-davinci-davinci-pcmc-use-gen_pool_dma_alloc-in-davinci-pcmc.patch
sound-soc-pxa-mmp-pcmc-use-gen_pool_dma_alloc-to-allocate-dma-buffer.patch
sound-core-memallocc-use-gen_pool_dma_alloc-to-allocate-iram-buffer.patch

