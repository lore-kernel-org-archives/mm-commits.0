From: akpm@linux-foundation.org
Subject: [folded] lis3-use-input_polled_device-fix-2.patch removed from -mm tree
Date: Tue, 16 Jun 2009 15:07:32 -0700
Message-ID: <200906162207.n5GM7W8t003648@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37413 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752096AbZFPWHi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Jun 2009 18:07:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, eric.piel@tremplin-utc.net, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     lis3: fix polldev build error
has been removed from the -mm tree.  Its filename was
     lis3-use-input_polled_device-fix-2.patch

This patch was dropped because it was folded into lis3-use-input_polled_device.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lis3: fix polldev build error
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix lis3 (spi version) Kconfig to prevent build error:

(.text+0x874fb): undefined reference to `input_unregister_polled_device'
(.text+0x87896): undefined reference to `input_allocate_polled_device'
(.text+0x879d3): undefined reference to `input_register_polled_device'
(.text+0x879e9): undefined reference to `input_free_polled_device'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Eric Piel <eric.piel@tremplin-utc.net>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/hwmon/Kconfig~lis3-use-input_polled_device-fix-2 drivers/hwmon/Kconfig
--- a/drivers/hwmon/Kconfig~lis3-use-input_polled_device-fix-2
+++ a/drivers/hwmon/Kconfig
@@ -978,6 +978,7 @@ config SENSORS_LIS3LV02D
 config SENSORS_LIS3_SPI
 	tristate "STMicroeletronics LIS3LV02Dx three-axis digital accelerometer (SPI)"
 	depends on !ACPI && SPI_MASTER && INPUT
+	select INPUT_POLLDEV
 	default n
 	help
 	  This driver provides support for the LIS3LV02Dx accelerometer connected
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
hexdump-remove-the-trailing-space.patch
kmap_types-make-most-arches-use-generic-header-file.patch
lis3-use-input_polled_device.patch
lis3-use-input_polled_device-fix-2.patch

