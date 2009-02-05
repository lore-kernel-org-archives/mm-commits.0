From: akpm@linux-foundation.org
Subject: + video-framebuffer-move-the-probe-func-into-devinittext-in-blackfin-lcd-driver.patch added to -mm tree
Date: Wed, 04 Feb 2009 23:32:41 -0800
Message-ID: <200902050732.n157Wf9A011346@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50929 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752721AbZBEHdh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Feb 2009 02:33:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ukleinek@strlen.de, cooloney@kernel.org, vapier.adi@gmail.com


The patch titled
     video/framebuffer: move the probe func into .devinit.text in Blackfin LCD driver
has been added to the -mm tree.  Its filename is
     video-framebuffer-move-the-probe-func-into-devinittext-in-blackfin-lcd-driver.patch

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
Subject: video/framebuffer: move the probe func into .devinit.text in Blackfin LCD driver
From: Uwe Kleine-Koenig <ukleinek@strlen.de>

Signed-off-by: Uwe Kleine-Koenig <ukleinek@strlen.de>
Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/bfin-t350mcqb-fb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/bfin-t350mcqb-fb.c~video-framebuffer-move-the-probe-func-into-devinittext-in-blackfin-lcd-driver drivers/video/bfin-t350mcqb-fb.c
--- a/drivers/video/bfin-t350mcqb-fb.c~video-framebuffer-move-the-probe-func-into-devinittext-in-blackfin-lcd-driver
+++ a/drivers/video/bfin-t350mcqb-fb.c
@@ -447,7 +447,7 @@ static irqreturn_t bfin_t350mcqb_irq_err
 	return IRQ_HANDLED;
 }
 
-static int __init bfin_t350mcqb_probe(struct platform_device *pdev)
+static int __devinit bfin_t350mcqb_probe(struct platform_device *pdev)
 {
 	struct bfin_t350mcqbfb_info *info;
 	struct fb_info *fbinfo;
_

Patches currently in -mm which might be from ukleinek@strlen.de are

origin.patch
linux-next.patch
gpio_free-might-sleep-blackfin-architecture.patch
video-framebuffer-move-the-probe-func-into-devinittext-in-blackfin-lcd-driver.patch

