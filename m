From: akpm@linux-foundation.org
Subject: + spi-fix-spidev-for-sizeoflong-32-devices.patch added to -mm tree
Date: Tue, 15 May 2007 13:42:28 -0700
Message-ID: <200705152042.l4FKgShM017603@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34933 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751980AbXEOUoz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 16:44:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: domen@coderock.org, dbrownell@users.sourceforge.net, domen.puncer@telargo.com


The patch titled
     spi: fix spidev for >sizeof(long)/32 devices
has been added to the -mm tree.  Its filename is
     spi-fix-spidev-for-sizeoflong-32-devices.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spi: fix spidev for >sizeof(long)/32 devices
From: Domen Puncer <domen@coderock.org>

find_first_zero_bit accepts number of bits, not longs.

Signed-off-by: Domen Puncer <domen.puncer@telargo.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spidev.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

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

spi-fix-spidev-for-sizeoflong-32-devices.patch
