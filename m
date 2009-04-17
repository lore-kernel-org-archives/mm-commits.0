From: akpm@linux-foundation.org
Subject: + pxa2xx_spi-fix-kernel-freeze-regression.patch added to -mm tree
Date: Fri, 17 Apr 2009 11:38:35 -0700
Message-ID: <200904171838.n3HIcZDQ030988@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36500 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758837AbZDQSlS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Apr 2009 14:41:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: drwyrm@gmail.com, dbrownell@users.sourceforge.net, eric.miao@marvell.com


The patch titled
     pxa2xx_spi: fix kernel freeze regression
has been added to the -mm tree.  Its filename is
     pxa2xx_spi-fix-kernel-freeze-regression.patch

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
Subject: pxa2xx_spi: fix kernel freeze regression
From: Daniel Ribeiro <drwyrm@gmail.com>

a7bb3909b3293d503211d7f6af8ed62c1644b686 ("spi: pxa2xx_spi: introduce
chipselect GPIO to simplify the common cases") introduced a serious
regression in the PXA SPI driver, for boards not using that new mechanism.
 On one board this caused a kernel frees on system startup.

Fix is trivial:  correct typo on pxa2xx-spi.c cs_deassert.

Signed-off-by: Daniel Ribeiro <drwyrm@gmail.com>
Acked-by: Eric Miao <eric.miao@marvell.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/pxa2xx_spi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/spi/pxa2xx_spi.c~pxa2xx_spi-fix-kernel-freeze-regression drivers/spi/pxa2xx_spi.c
--- a/drivers/spi/pxa2xx_spi.c~pxa2xx_spi-fix-kernel-freeze-regression
+++ a/drivers/spi/pxa2xx_spi.c
@@ -182,7 +182,7 @@ static void cs_assert(struct driver_data
 	struct chip_data *chip = drv_data->cur_chip;
 
 	if (chip->cs_control) {
-		chip->cs_control(PXA2XX_CS_ASSERT);
+		chip->cs_control(PXA2XX_CS_DEASSERT);
 		return;
 	}
 
_

Patches currently in -mm which might be from drwyrm@gmail.com are

pxa2xx_spi-fix-kernel-freeze-regression.patch
linux-next.patch

