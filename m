From: akpm@linux-foundation.org
Subject: + orion_spi-handle-88f6183-erratum.patch added to -mm tree
Date: Thu, 02 Oct 2008 16:37:23 -0700
Message-ID: <200810022337.m92NbNcS032694@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47955 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753487AbYJBXh7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Oct 2008 19:37:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: buytenh@wantstofly.org, buytenh@marvell.com, dbrownell@users.sourceforge.net


The patch titled
     orion_spi: handle 88F6183 erratum
has been added to the -mm tree.  Its filename is
     orion_spi-handle-88f6183-erratum.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: orion_spi: handle 88F6183 erratum
From: Lennert Buytenhek <buytenh@wantstofly.org>

Add support to orion_spi for the 88F6183 ARM SoC by adding code to work
around a 6183-specific erratum.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/orion_spi.c       |    5 +++++
 include/linux/spi/orion_spi.h |    1 +
 2 files changed, 6 insertions(+)

diff -puN drivers/spi/orion_spi.c~orion_spi-handle-88f6183-erratum drivers/spi/orion_spi.c
--- a/drivers/spi/orion_spi.c~orion_spi-handle-88f6183-erratum
+++ a/drivers/spi/orion_spi.c
@@ -364,6 +364,11 @@ static int orion_spi_setup(struct spi_de
 		return -EINVAL;
 	}
 
+	/* Fix ac timing if required.   */
+	if (orion_spi->spi_info->enable_clock_fix)
+		orion_spi_setbits(orion_spi, ORION_SPI_IF_CONFIG_REG,
+				  (1 << 14));
+
 	if (spi->bits_per_word == 0)
 		spi->bits_per_word = 8;
 
diff -puN include/linux/spi/orion_spi.h~orion_spi-handle-88f6183-erratum include/linux/spi/orion_spi.h
--- a/include/linux/spi/orion_spi.h~orion_spi-handle-88f6183-erratum
+++ a/include/linux/spi/orion_spi.h
@@ -11,6 +11,7 @@
 
 struct orion_spi_info {
 	u32	tclk;		/* no <linux/clk.h> support yet */
+	u32	enable_clock_fix;
 };
 
 
_

Patches currently in -mm which might be from buytenh@wantstofly.org are

orion_spi-fix-handling-of-default-transfer-speed.patch
git-arm.patch
git-net.patch
orion_spi-handle-88f6183-erratum.patch

