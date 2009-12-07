From: akpm@linux-foundation.org
Subject: + spi-fix-spidev-compilation-failure-when-verbose-is-defined.patch added to -mm tree
Date: Mon, 07 Dec 2009 15:23:08 -0800
Message-ID: <200912072323.nB7NN8px020072@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49333 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758339AbZLGXXK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Dec 2009 18:23:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ffainelli@freebox.fr, david-b@pacbell.net, grant.likely@secretlab.ca


The patch titled
     spi: fix spidev compilation failure when VERBOSE is defined
has been added to the -mm tree.  Its filename is
     spi-fix-spidev-compilation-failure-when-verbose-is-defined.patch

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
Subject: spi: fix spidev compilation failure when VERBOSE is defined
From: Florian Fainelli <ffainelli@freebox.fr>

When VERBOSE is defined in the spidev module, the compilation will throw
an error on 'spi' not being defined:

CC [M]  drivers/spi/spidev.o
drivers/spi/spidev.c: In function 'spidev_message':
drivers/spi/spidev.c:266: error: 'spi' undeclared (first use in this function)
drivers/spi/spidev.c:266: error: (Each undeclared identifier is reported only once
drivers/spi/spidev.c:266: error: for each function it appears in.)

instead of using spi-> we should actually use spidev->spi.  This patch
fixes the build failure.

Signed-off-by: Florian Fainelli <ffainelli@freebox.fr>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spidev.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/spi/spidev.c~spi-fix-spidev-compilation-failure-when-verbose-is-defined drivers/spi/spidev.c
--- a/drivers/spi/spidev.c~spi-fix-spidev-compilation-failure-when-verbose-is-defined
+++ a/drivers/spi/spidev.c
@@ -267,15 +267,15 @@ static int spidev_message(struct spidev_
 		k_tmp->delay_usecs = u_tmp->delay_usecs;
 		k_tmp->speed_hz = u_tmp->speed_hz;
 #ifdef VERBOSE
-		dev_dbg(&spi->dev,
+		dev_dbg(&spidev->spi->dev,
 			"  xfer len %zd %s%s%s%dbits %u usec %uHz\n",
 			u_tmp->len,
 			u_tmp->rx_buf ? "rx " : "",
 			u_tmp->tx_buf ? "tx " : "",
 			u_tmp->cs_change ? "cs " : "",
-			u_tmp->bits_per_word ? : spi->bits_per_word,
+			u_tmp->bits_per_word ? : spidev->spi->bits_per_word,
 			u_tmp->delay_usecs,
-			u_tmp->speed_hz ? : spi->max_speed_hz);
+			u_tmp->speed_hz ? : spidev->spi->max_speed_hz);
 #endif
 		spi_message_add_tail(k_tmp, &msg);
 	}
_

Patches currently in -mm which might be from ffainelli@freebox.fr are

spi-fix-spidev-compilation-failure-when-verbose-is-defined.patch

