From: akpm@linux-foundation.org
Subject: [merged] spi_bfin5xx-limit-reaches-1.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:44:00 -0700
Message-ID: <200906182244.n5IMi0Qs003109@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41524 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758166AbZFRWpD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:45:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, cooloney@kernel.org, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi_bfin5xx: limit reaches -1
has been removed from the -mm tree.  Its filename was
     spi_bfin5xx-limit-reaches-1.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi_bfin5xx: limit reaches -1
From: Roel Kluin <roel.kluin@gmail.com>

bfin_spi_flush() returns limit, which reaches -1 upon timeout.  but in
function bfin_spi_pump_transfers() it is compared with 0.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bfin5xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/spi/spi_bfin5xx.c~spi_bfin5xx-limit-reaches-1 drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~spi_bfin5xx-limit-reaches-1
+++ a/drivers/spi/spi_bfin5xx.c
@@ -169,7 +169,7 @@ static int bfin_spi_flush(struct driver_
 	unsigned long limit = loops_per_jiffy << 1;
 
 	/* wait for stop and clear stat */
-	while (!(read_STAT(drv_data) & BIT_STAT_SPIF) && limit--)
+	while (!(read_STAT(drv_data) & BIT_STAT_SPIF) && --limit)
 		cpu_relax();
 
 	write_STAT(drv_data, BIT_STAT_CLR);
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
dtlk-off-by-one-in-readwrite_tts.patch
linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
serial-fix-off-by-one-errors.patch
usb-mutually-exclusive-port_status.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
platinumfb-misplaced-parenthesis.patch

