From: akpm@linux-foundation.org
Subject: - sound-soc-ioremap-iounmap-balancing.patch removed from -mm tree
Date: Mon, 06 Aug 2007 00:53:02 -0700
Message-ID: <200708060753.l767r2la016304@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42929 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759937AbXHFHxv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Aug 2007 03:53:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: postfail@hushmail.com, perex@suse.cz, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     sound/soc ioremap/iounmap balancing
has been removed from the -mm tree.  Its filename was
     sound-soc-ioremap-iounmap-balancing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sound/soc ioremap/iounmap balancing
From: "Scott Thompson" <postfail@hushmail.com>

ioremap / iounmap balancing in sound/soc tree

Signed-off-by: Scott Thompson <postfail <at> hushmail.com>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/soc/s3c24xx/s3c24xx-i2s.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN sound/soc/s3c24xx/s3c24xx-i2s.c~sound-soc-ioremap-iounmap-balancing sound/soc/s3c24xx/s3c24xx-i2s.c
--- a/sound/soc/s3c24xx/s3c24xx-i2s.c~sound-soc-ioremap-iounmap-balancing
+++ a/sound/soc/s3c24xx/s3c24xx-i2s.c
@@ -385,6 +385,7 @@ static int s3c24xx_i2s_probe(struct plat
 	s3c24xx_i2s.iis_clk=clk_get(&pdev->dev, "iis");
 	if (s3c24xx_i2s.iis_clk == NULL) {
 		DBG("failed to get iis_clock\n");
+		iounmap(s3c24xx_i2s.regs);
 		return -ENODEV;
 	}
 	clk_enable(s3c24xx_i2s.iis_clk);
_

Patches currently in -mm which might be from postfail@hushmail.com are

git-alsa.patch
sound-pci-ioremap-iounmap-balancing.patch
