From: akpm@linux-foundation.org
Subject: [folded] lis3-use-input_polled_device-fix.patch removed from -mm tree
Date: Tue, 16 Jun 2009 15:07:29 -0700
Message-ID: <200906162207.n5GM7TA3003645@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55805 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753422AbZFPWHj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Jun 2009 18:07:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, eric.piel@tremplin-utc.net, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     lis3: uses input polldev functions
has been removed from the -mm tree.  Its filename was
     lis3-use-input_polled_device-fix.patch

This patch was dropped because it was folded into lis3-use-input_polled_device.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lis3: uses input polldev functions
From: Randy Dunlap <randy.dunlap@oracle.com>

This driver uses input-polldev (library) functions, so it needs
to select that kconfig symbol so that it builds without errors.

drivers/built-in.o: In function `lis3lv02d_joystick_disable':
(.text+0x19d9d0): undefined reference to `input_unregister_polled_device'
drivers/built-in.o: In function `lis3lv02d_joystick_enable':
(.text+0x19d9fc): undefined reference to `input_allocate_polled_device'
drivers/built-in.o: In function `lis3lv02d_joystick_enable':
(.text+0x19daaf): undefined reference to `input_register_polled_device'
drivers/built-in.o: In function `lis3lv02d_joystick_enable':
(.text+0x19dabf): undefined reference to `input_free_polled_device'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Eric Piel <eric.piel@tremplin-utc.net>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/hwmon/Kconfig~lis3-use-input_polled_device-fix drivers/hwmon/Kconfig
--- a/drivers/hwmon/Kconfig~lis3-use-input_polled_device-fix
+++ a/drivers/hwmon/Kconfig
@@ -950,6 +950,7 @@ config SENSORS_HDAPS
 config SENSORS_LIS3LV02D
 	tristate "STMicroeletronics LIS3LV02Dx three-axis digital accelerometer"
 	depends on ACPI && INPUT
+	select INPUT_POLLDEV
 	select NEW_LEDS
 	select LEDS_CLASS
 	default n
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
hexdump-remove-the-trailing-space.patch
kmap_types-make-most-arches-use-generic-header-file.patch
lis3-use-input_polled_device.patch
lis3-use-input_polled_device-fix.patch
lis3-use-input_polled_device-fix-2.patch

