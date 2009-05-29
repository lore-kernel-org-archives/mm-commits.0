From: akpm@linux-foundation.org
Subject: + lis3-use-input_polled_device-fix.patch added to -mm tree
Date: Fri, 29 May 2009 12:32:38 -0700
Message-ID: <200905291932.n4TJWc7x013994@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54133 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752794AbZE2Tcu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 May 2009 15:32:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, eric.piel@tremplin-utc.net, pavel@ucw.cz


The patch titled
     lis3: uses input polldev functions
has been added to the -mm tree.  Its filename is
     lis3-use-input_polled_device-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
menu-fix-embedded-menu-presentation.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
qla2x-fix-printk-format-warnings.patch
hexdump-remove-the-trailing-space.patch
kmap_types-make-most-arches-use-generic-header-file.patch
irqs-add-irqf_sample_random-to-the-feature-removal-scheduletxt-deprecated-list.patch
lis3-use-input_polled_device-fix.patch
cgroups-make-messages-more-readable.patch
linuxpps-core-support.patch
reiser4-export-remove_from_page_cache-fix.patch

