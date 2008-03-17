From: akpm@linux-foundation.org
Subject: - spi_bitbang-short-transfer-status-fix.patch removed from -mm tree
Date: Mon, 17 Mar 2008 13:57:32 -0700
Message-ID: <200803172057.m2HKvWod030633@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41317 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752635AbYCQVCM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 17:02:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.nikitenko@gmail.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi_bitbang: short transfer status fix
has been removed from the -mm tree.  Its filename was
     spi_bitbang-short-transfer-status-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


