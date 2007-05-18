From: akpm@linux-foundation.org
Subject: - spi-fix-spidev-for-sizeoflong-32-devices.patch removed from -mm tree
Date: Fri, 18 May 2007 00:05:55 -0700
Message-ID: <200705180705.l4I75sWY010133@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57903 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755063AbXERHjL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 May 2007 03:39:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: domen@coderock.org, dbrownell@users.sourceforge.net, domen.puncer@telargo.com, mm-commits@vger.kernel.org


The patch titled
     spi: fix spidev for >sizeof(long)/32 devices
has been removed from the -mm tree.  Its filename was
     spi-fix-spidev-for-sizeoflong-32-devices.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: spi: fix spidev for >sizeof(long)/32 devices
From: Domen Puncer <domen@coderock.org>

find_first_zero_bit accepts number of bits, not longs.

Signed-off-by: Domen Puncer <domen.puncer@telargo.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spidev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/spi/spidev.c~spi-fix-spidev-for-sizeoflong-32-devices drivers/spi/spidev.c
--- a/drivers/spi/spidev.c~spi-fix-spidev-for-sizeoflong-32-devices
+++ a/drivers/spi/spidev.c
@@ -484,7 +484,7 @@ static int spidev_probe(struct spi_devic
 	 * Reusing minors is fine so long as udev or mdev is working.
 	 */
 	mutex_lock(&device_list_lock);
-	minor = find_first_zero_bit(minors, ARRAY_SIZE(minors));
+	minor = find_first_zero_bit(minors, N_SPI_MINORS);
 	if (minor < N_SPI_MINORS) {
 		spidev->dev.parent = &spi->dev;
 		spidev->dev.class = &spidev_class;
_

Patches currently in -mm which might be from domen@coderock.org are

origin.patch
