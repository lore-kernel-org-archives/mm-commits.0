From: akpm@linux-foundation.org
Subject: + lis3-use-input_polled_device-fix-2.patch added to -mm tree
Date: Fri, 05 Jun 2009 13:32:52 -0700
Message-ID: <200906052032.n55KWqB5002811@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42390 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751637AbZFEUd3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Jun 2009 16:33:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, eric.piel@tremplin-utc.net, pavel@ucw.cz


The patch titled
     lis3: fix polldev build error
has been added to the -mm tree.  Its filename is
     lis3-use-input_polled_device-fix-2.patch

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

linux-next.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
menu-fix-embedded-menu-presentation.patch
scripts-allow-docproc-invocation-from-external.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
qla2x-fix-printk-format-warnings.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
hexdump-remove-the-trailing-space.patch
kmap_types-make-most-arches-use-generic-header-file.patch
irqs-add-irqf_sample_random-to-the-feature-removal-scheduletxt-deprecated-list.patch
lis3-use-input_polled_device-fix.patch
lis3-use-input_polled_device-fix-2.patch
cgroups-make-messages-more-readable.patch
rapidio-fix-kerneldoc-for-rio_mem_ops.patch
linuxpps-core-support.patch
reiser4-export-remove_from_page_cache-fix.patch

