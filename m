From: akpm@linux-foundation.org
Subject: +
 sound-soc-davinci-davinci-pcmc-use-gen_pool_dma_alloc-in-davinci-pcmc.patch added to -mm tree
Date: Mon, 04 Nov 2013 14:17:14 -0800
Message-ID: <52781cea.9yNcU1INQ62jBIey%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48793 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab3KDWRP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Nov 2013 17:17:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tiwai@suse.de, perex@perex.cz, lgirdwood@gmail.com, broonie@kernel.org, b42378@freescale.com

Subject: + sound-soc-davinci-davinci-pcmc-use-gen_pool_dma_alloc-in-davinci-pcmc.patch added to -mm tree
To: b42378@freescale.com,broonie@kernel.org,lgirdwood@gmail.com,perex@perex.cz,tiwai@suse.de
From: akpm@linux-foundation.org
Date: Mon, 04 Nov 2013 14:17:14 -0800


The patch titled
     Subject: sound/soc/davinci/davinci-pcm.c: use gen_pool_dma_alloc() in davinci-pcm.c
has been added to the -mm tree.  Its filename is
     sound-soc-davinci-davinci-pcmc-use-gen_pool_dma_alloc-in-davinci-pcmc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sound-soc-davinci-davinci-pcmc-use-gen_pool_dma_alloc-in-davinci-pcmc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sound-soc-davinci-davinci-pcmc-use-gen_pool_dma_alloc-in-davinci-pcmc.patch

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
Subject: sound/soc/davinci/davinci-pcm.c: use gen_pool_dma_alloc() in davinci-pcm.c

Since gen_pool_dma_alloc() is introduced, we implement it to simplify code.

Signed-off-by: Nicolin Chen <b42378@freescale.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/soc/davinci/davinci-pcm.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN sound/soc/davinci/davinci-pcm.c~sound-soc-davinci-davinci-pcmc-use-gen_pool_dma_alloc-in-davinci-pcmc sound/soc/davinci/davinci-pcm.c
--- a/sound/soc/davinci/davinci-pcm.c~sound-soc-davinci-davinci-pcmc-use-gen_pool_dma_alloc-in-davinci-pcmc
+++ a/sound/soc/davinci/davinci-pcm.c
@@ -267,10 +267,9 @@ static int allocate_sram(struct snd_pcm_
 		return 0;
 
 	ppcm->period_bytes_max = size;
-	iram_virt = (void *)gen_pool_alloc(sram_pool, size);
+	iram_virt = gen_pool_dma_alloc(sram_pool, size, &iram_phys);
 	if (!iram_virt)
 		goto exit1;
-	iram_phys = gen_pool_virt_to_phys(sram_pool, (unsigned)iram_virt);
 	iram_dma = kzalloc(sizeof(*iram_dma), GFP_KERNEL);
 	if (!iram_dma)
 		goto exit2;
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

