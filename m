From: akpm@linux-foundation.org
Subject: - mtd-m25p80-fix-bug-atmel-spi-flash-fails-to-be-copied-to-fix-up.patch removed from -mm tree
Date: Mon, 09 Jun 2008 16:49:45 -0700
Message-ID: <200806092349.m59NnjIC015699@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52094 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754929AbYFIXuY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2008 19:50:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael.hennerich@analog.com, cooloney@kernel.org, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     mtd m25p80: fix bug - ATmel spi flash fails to be copied to - fix up
has been removed from the -mm tree.  Its filename was
     mtd-m25p80-fix-bug-atmel-spi-flash-fails-to-be-copied-to-fix-up.patch

This patch was dropped because it was folded into mtd-m25p80-fix-bug-atmel-spi-flash-fails-to-be-copied-to.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd m25p80: fix bug - ATmel spi flash fails to be copied to - fix up
From: Michael Hennerich <michael.hennerich@analog.com>

remove duplicate code.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/devices/m25p80.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/mtd/devices/m25p80.c~mtd-m25p80-fix-bug-atmel-spi-flash-fails-to-be-copied-to-fix-up drivers/mtd/devices/m25p80.c
--- a/drivers/mtd/devices/m25p80.c~mtd-m25p80-fix-bug-atmel-spi-flash-fails-to-be-copied-to-fix-up
+++ a/drivers/mtd/devices/m25p80.c
@@ -122,8 +122,6 @@ static int write_sr(struct m25p *flash, 
 	flash->command[0] = OPCODE_WRSR;
 	flash->command[1] = val;
 
-	spi_write(flash->spi, flash->command, 2);
