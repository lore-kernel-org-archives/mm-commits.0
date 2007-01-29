From: akpm@osdl.org
Subject: - sound-isa-gus-gus_mainc-use-abs-instead-of-x-0-x-x.patch removed from -mm tree
Date: Mon, 29 Jan 2007 13:17:11 -0800
Message-ID: <200701292117.l0TLHBD2031162@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57191 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572AbXA2VRW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jan 2007 16:17:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: s022018@student.dtu.dk, perex@suse.cz, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     sound/isa/gus/gus_main.c: Use abs() instead of x < 0 ? -x : x.
has been removed from the -mm tree.  Its filename was
     sound-isa-gus-gus_mainc-use-abs-instead-of-x-0-x-x.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sound/isa/gus/gus_main.c: Use abs() instead of x < 0 ? -x : x.
From: "Peter Eriksen" <s022018@student.dtu.dk>

Signed-off-by: Peter Eriksen <s022018@student.dtu.dk>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 sound/isa/gus/gus_main.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN sound/isa/gus/gus_main.c~sound-isa-gus-gus_mainc-use-abs-instead-of-x-0-x-x sound/isa/gus/gus_main.c
--- a/sound/isa/gus/gus_main.c~sound-isa-gus-gus_mainc-use-abs-instead-of-x-0-x-x
+++ a/sound/isa/gus/gus_main.c
@@ -294,10 +294,10 @@ static int snd_gus_init_dma_irq(struct s
 		gus->mix_cntrl_reg |= 4;	/* enable MIC */
 	}
 	dma1 = gus->gf1.dma1;
-	dma1 = dma1 < 0 ? -dma1 : dma1;
+	dma1 = abs(dma1);
 	dma1 = dmas[dma1 & 7];
 	dma2 = gus->gf1.dma2;
-	dma2 = dma2 < 0 ? -dma2 : dma2;
+	dma2 = abs(dma2);
 	dma2 = dmas[dma2 & 7];
 	dma1 |= gus->equal_dma ? 0x40 : (dma2 << 3);
 
@@ -306,7 +306,7 @@ static int snd_gus_init_dma_irq(struct s
 		return -EINVAL;
 	}
 	irq = gus->gf1.irq;
-	irq = irq < 0 ? -irq : irq;
+	irq = abs(irq);
 	irq = irqs[irq & 0x0f];
 	if (irq == 0) {
 		snd_printk(KERN_ERR "Error! IRQ isn't defined.\n");
_

Patches currently in -mm which might be from s022018@student.dtu.dk are

git-alsa.patch
