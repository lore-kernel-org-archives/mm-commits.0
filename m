From: akpm@linux-foundation.org
Subject: [merged] blackfin-spi-driver-fix-null-pointer-crash.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:06:57 -0700
Message-ID: <200904071906.n37J6vPt011071@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36812 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760724AbZDGTKi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:10:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier.adi@gmail.com, cooloney@kernel.org, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     Blackfin SPI Driver: fix NULL pointer crash
has been removed from the -mm tree.  Its filename was
     blackfin-spi-driver-fix-null-pointer-crash.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Blackfin SPI Driver: fix NULL pointer crash
From: Mike Frysinger <vapier.adi@gmail.com>

Fix NULL pointer crash when cleaning up from invalid platform resources

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
@@ -1178,6 +1178,9 @@ static void bfin_spi_cleanup(struct spi_
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
linux-next.patch

