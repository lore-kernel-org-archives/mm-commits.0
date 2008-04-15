From: akpm@linux-foundation.org
Subject: + spi-spi_s3c24xx-driver-must-init-completion.patch added to -mm tree
Date: Tue, 15 Apr 2008 12:30:47 -0700
Message-ID: <200804151930.m3FJUlQv011548@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36189 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754163AbYDOTb7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 15:31:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben-linux@fluff.org, dbrownell@users.sourceforge.net


The patch titled
     spi: spi_s3c24xx driver must init completion
has been added to the -mm tree.  Its filename is
     spi-spi_s3c24xx-driver-must-init-completion.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi: spi_s3c24xx driver must init completion
From: Ben Dooks <ben-linux@fluff.org>

The s3c24xx_spi_txrx() function should initialise the completion each time
before using it, otherwise we end up with the possibility of returning success
before the interrupt handler has processed all the data.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_s3c24xx.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/spi/spi_s3c24xx.c~spi-spi_s3c24xx-driver-must-init-completion drivers/spi/spi_s3c24xx.c
--- a/drivers/spi/spi_s3c24xx.c~spi-spi_s3c24xx-driver-must-init-completion
+++ a/drivers/spi/spi_s3c24xx.c
@@ -192,8 +192,11 @@ static int s3c24xx_spi_txrx(struct spi_d
 	hw->len = t->len;
 	hw->count = 0;
 
+	init_completion(&hw->done);
+
 	/* send the first byte */
 	writeb(hw_txbyte(hw, 0), hw->regs + S3C2410_SPTDAT);
+
 	wait_for_completion(&hw->done);
 
 	return hw->count;
_

Patches currently in -mm which might be from ben-linux@fluff.org are

spi-spi_s3c24xx-driver-must-init-completion.patch
spi-spi_s3c24xx-must-initialize-bus_num.patch
spi-spi_s3c24xx-must-initialize-num_chipselect.patch
net-drivers-fix-platform-driver-hotplug-coldplug.patch
sm501-add-uart-support.patch
video-replace-remaining-__function__-occurrences.patch
drivers-replace-remaining-__function__-occurrences.patch

