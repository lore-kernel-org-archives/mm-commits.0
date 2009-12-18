From: akpm@linux-foundation.org
Subject: [merged] spidev-use-declare_bitmap-instead-of-declaring-the-array.patch removed from -mm tree
Date: Fri, 18 Dec 2009 12:27:27 -0800
Message-ID: <200912182027.nBIKRRZg016641@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42766 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932852AbZLRU1q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Dec 2009 15:27:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cascardo@holoscopio.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spidev: use DECLARE_BITMAP instead of declaring the array
has been removed from the -mm tree.  Its filename was
     spidev-use-declare_bitmap-instead-of-declaring-the-array.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spidev: use DECLARE_BITMAP instead of declaring the array
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spidev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/spi/spidev.c~spidev-use-declare_bitmap-instead-of-declaring-the-array drivers/spi/spidev.c
--- a/drivers/spi/spidev.c~spidev-use-declare_bitmap-instead-of-declaring-the-array
+++ a/drivers/spi/spidev.c
@@ -53,7 +53,7 @@
 #define SPIDEV_MAJOR			153	/* assigned */
 #define N_SPI_MINORS			32	/* ... up to 256 */
 
-static unsigned long	minors[N_SPI_MINORS / BITS_PER_LONG];
+static DECLARE_BITMAP(minors, N_SPI_MINORS);
 
 
 /* Bit masks for spi_device.mode management.  Note that incorrect
_

Patches currently in -mm which might be from cascardo@holoscopio.com are

linux-next.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-checkpatch-fixes.patch

