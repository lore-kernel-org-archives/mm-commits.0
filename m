From: akpm@linux-foundation.org
Subject: + spi_bitbang-short-transfer-status-fix.patch added to -mm tree
Date: Tue, 11 Mar 2008 10:58:15 -0700
Message-ID: <200803111758.m2BHwFvh019672@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34832 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752373AbYCKR6Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Mar 2008 13:58:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jan.nikitenko@gmail.com, dbrownell@users.sourceforge.net


The patch titled
     spi_bitbang: short transfer status fix
has been added to the -mm tree.  Its filename is
     spi_bitbang-short-transfer-status-fix.patch

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
Subject: spi_bitbang: short transfer status fix
From: Jan Nikitenko <jan.nikitenko@gmail.com>

SPI controller drivers return number of bytes actually transfered from
bitbang->txrx_bufs() method.  This updates handling of short transfers (where
the transfer size is less than requested):

 - Even zero byte short transfers should report errors;
 - Include short transfers in the total of transferred bytes;
 - Use EREMOTEIO (like USB) not EMSGSIZE to report short transfers

Short transfers don't normally mean invalid message sizes, but if the
underlying controller driver needs to use EMSGSIZE it can still do so.

[db: fix two more minor issues]
Signed-off-by: Jan Nikitenko <jan.nikitenko@gmail.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bitbang.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/spi/spi_bitbang.c~spi_bitbang-short-transfer-status-fix drivers/spi/spi_bitbang.c
--- a/drivers/spi/spi_bitbang.c~spi_bitbang-short-transfer-status-fix
+++ a/drivers/spi/spi_bitbang.c
@@ -344,12 +344,14 @@ static void bitbang_work(struct work_str
 					t->rx_dma = t->tx_dma = 0;
 				status = bitbang->txrx_bufs(spi, t);
 			}
+			if (status > 0)
+				m->actual_length += status;
 			if (status != t->len) {
-				if (status > 0)
-					status = -EMSGSIZE;
+				/* always report some kind of error */
+				if (status >= 0)
+					status = -EREMOTEIO;
 				break;
 			}
-			m->actual_length += status;
 			status = 0;
 
 			/* protocol tweaks before next transfer */
_

Patches currently in -mm which might be from jan.nikitenko@gmail.com are

au1550_spi-fix-prototype-of-irq-handler.patch
spi_bitbang-short-transfer-status-fix.patch

