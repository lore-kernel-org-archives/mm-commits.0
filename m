From: akpm@linux-foundation.org
Subject: + spi_mpc83xx-quieten-down-the-requested-speed-is-too-low-message.patch added to -mm tree
Date: Mon, 04 May 2009 13:56:11 -0700
Message-ID: <200905042056.n44KuCv4016685@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40799 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754459AbZEDVAE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2009 17:00:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com, benh@kernel.crashing.org, david-b@pacbell.net, galak@gate.crashing.org


The patch titled
     spi_mpc83xx: quieten down the "Requested speed is too low" message
has been added to the -mm tree.  Its filename is
     spi_mpc83xx-quieten-down-the-requested-speed-is-too-low-message.patch

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
Subject: spi_mpc83xx: quieten down the "Requested speed is too low" message
From: Anton Vorontsov <avorontsov@ru.mvista.com>

When a platform is running at high frequencies it's not always possible to
scale-down a frequency to a requested value, and using mmc_spi driver this
leads to the following printk flood during card polling:

  ...
  mmc_spi spi32766.0: Requested speed is too low: 400000 Hz. Will use
  520828 Hz instead.
  mmc_spi spi32766.0: Requested speed is too low: 400000 Hz. Will use
  520828 Hz instead.
  ...

Fix this by using WARN_ONCE(), it's better than the flood, and also better
than turning dev_err() into dev_dbg(), since we actually want to warn that
some things may not work correctly.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: David Brownell <david-b@pacbell.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_mpc83xx.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN drivers/spi/spi_mpc83xx.c~spi_mpc83xx-quieten-down-the-requested-speed-is-too-low-message drivers/spi/spi_mpc83xx.c
--- a/drivers/spi/spi_mpc83xx.c~spi_mpc83xx-quieten-down-the-requested-speed-is-too-low-message
+++ a/drivers/spi/spi_mpc83xx.c
@@ -14,6 +14,7 @@
 #include <linux/init.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
+#include <linux/bug.h>
 #include <linux/errno.h>
 #include <linux/err.h>
 #include <linux/completion.h>
@@ -275,12 +276,12 @@ int mpc83xx_spi_setup_transfer(struct sp
 	if ((mpc83xx_spi->spibrg / hz) > 64) {
 		cs->hw_mode |= SPMODE_DIV16;
 		pm = mpc83xx_spi->spibrg / (hz * 64);
-		if (pm > 16) {
-			dev_err(&spi->dev, "Requested speed is too "
-				"low: %d Hz. Will use %d Hz instead.\n",
-				hz, mpc83xx_spi->spibrg / 1024);
+
+		WARN_ONCE(pm > 16, "%s: Requested speed is too low: %d Hz. "
+			  "Will use %d Hz instead.\n", dev_name(&spi->dev),
+			  hz, mpc83xx_spi->spibrg / 1024);
+		if (pm > 16)
 			pm = 16;
-		}
 	} else
 		pm = mpc83xx_spi->spibrg / (hz * 4);
 	if (pm)
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

linux-next.patch
mpc52xx_psc_spi-convert-to-cs_control-callback.patch
spi_mpc83xx-handle-other-freescale-processors.patch
spi_mpc83xx-quieten-down-the-requested-speed-is-too-low-message.patch
spi_mpc83xx-add-small-delay-after-asserting-chip-select-line.patch
powerpc-86xx-add-mmc-spi-support-for-mpc8610hpcd-boards.patch
spi_mpc83xx-fix-checkpatch-issues.patch
spi_mpc83xx-split-mpc83xx_spi_work-into-two-routines.patch
spi_mpc83xx-remove-dead-code.patch
spi_mpc83xx-rename-spi_83xxc-to-spi_8xxxc.patch
spi_mpc8xxx-s-83xx-8xxx-g.patch

