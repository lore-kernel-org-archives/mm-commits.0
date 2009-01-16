From: akpm@linux-foundation.org
Subject: [merged] atmel_spi-allow-transfer-when-max_speed_hz-=-0.patch removed from -mm tree
Date: Fri, 16 Jan 2009 11:16:15 -0800
Message-ID: <200901161916.n0GJGFDa024702@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49631 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759294AbZAPTQm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 14:16:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stf_xl@wp.pl, david-b@pacbell.net, haavard.skinnemoen@atmel.com, mm-commits@vger.kernel.org


The patch titled
     atmel_spi: allow transfer when max_speed_hz = 0
has been removed from the -mm tree.  Its filename was
     atmel_spi-allow-transfer-when-max_speed_hz-=-0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atmel_spi: allow transfer when max_speed_hz = 0
From: Stanislaw Gruszka <stf_xl@wp.pl>

For some reason I have to slowdown clock to touchscreen device.

In atmel_spi_setup() there is comment that max_speed_hz == 0 means as slow
as possible and divider is set to maximum value.  But in
atmel_spi_transfer() function is check against not zero max_speed_hz with
EINVAL returned.

Probably driver should setup divider for each transfer based on
transfer->speed_hz value, but I think that would be not necessary overhead
as all used devices have constant clock.

Below patch works fine for me.

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/atmel_spi.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/spi/atmel_spi.c~atmel_spi-allow-transfer-when-max_speed_hz-=-0 drivers/spi/atmel_spi.c
--- a/drivers/spi/atmel_spi.c~atmel_spi-allow-transfer-when-max_speed_hz-=-0
+++ a/drivers/spi/atmel_spi.c
@@ -670,8 +670,7 @@ static int atmel_spi_transfer(struct spi
 	dev_dbg(controller, "new message %p submitted for %s\n",
 			msg, spi->dev.bus_id);
 
-	if (unlikely(list_empty(&msg->transfers)
-			|| !spi->max_speed_hz))
+	if (unlikely(list_empty(&msg->transfers)))
 		return -EINVAL;
 
 	if (as->stopping)
_

Patches currently in -mm which might be from stf_xl@wp.pl are

origin.patch
arm-at91-fix-nr_aic_irqs-undeclared.patch

