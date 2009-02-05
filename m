From: akpm@linux-foundation.org
Subject: + blackfin-spi-driver-fix-null-pointer-crash.patch added to -mm tree
Date: Thu, 05 Feb 2009 14:13:13 -0800
Message-ID: <200902052213.n15MDDx6025720@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55270 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755005AbZBEWNY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Feb 2009 17:13:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier.adi@gmail.com, cooloney@kernel.org, david-b@pacbell.net


The patch titled
     Blackfin SPI Driver: fix NULL pointer crash
has been added to the -mm tree.  Its filename is
     blackfin-spi-driver-fix-null-pointer-crash.patch

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
Subject: Blackfin SPI Driver: fix NULL pointer crash
From: Mike Frysinger <vapier.adi@gmail.com>

Fix NULL pointer crash when cleaning up from invalid platform resources.

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bfin5xx.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/spi/spi_bfin5xx.c~blackfin-spi-driver-fix-null-pointer-crash drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~blackfin-spi-driver-fix-null-pointer-crash
+++ a/drivers/spi/spi_bfin5xx.c
@@ -1139,6 +1139,9 @@ static void cleanup(struct spi_device *s
 {
 	struct chip_data *chip = spi_get_ctldata(spi);
 
+	if (!chip)
+		return;
+
 	if ((chip->chip_select_num > 0)
 		&& (chip->chip_select_num <= spi->master->num_chipselect))
 		peripheral_free(ssel[spi->master->bus_num]
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

origin.patch
video-framebuffer-move-the-probe-func-into-devinittext-in-blackfin-lcd-driver.patch
linux-next.patch
blackfin-nfc-driver-do-not-clobber-dmac1_perimux.patch
blackfin-nfc-driver-mark-bf5xx_nand_add_partition-as-__devinit.patch
blackfin-nfc-driver-drop-pointless-casts-with-set_dma_callback.patch
mtd-maps-blackfin-async-flash-maps-fix-bug-dont-leak-resources-when-initializing-in-case-of-errors.patch
mtd-maps-blackfin-async-flash-maps-bfin-async-mtd-driver-needs-complex-mappings.patch
mtd-maps-blackfin-async-flash-maps-fix-up-memory-leak.patch
blackfin-spi-driver-add-comment-about-full-duplex-dma-according-to-david-brownell.patch
blackfin-spi-driver-fix-null-pointer-crash.patch
bin_elf_fdpic-check-the-return-value-of-clear_user.patch

