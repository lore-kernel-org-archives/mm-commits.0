From: akpm@linux-foundation.org
Subject: + backlight-fix-s6e63m0-kconfig.patch added to -mm tree
Date: Thu, 20 May 2010 14:13:37 -0700
Message-ID: <201005202113.o4KLDb6q005608@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46968 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753938Ab0ETVOV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 May 2010 17:14:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, inki.dae@samsung.com, rpurdie@rpsys.net


The patch titled
     backlight: fix s6e63m0 kconfig
has been added to the -mm tree.  Its filename is
     backlight-fix-s6e63m0-kconfig.patch

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
Subject: backlight: fix s6e63m0 kconfig
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kconfig file dependency and help text.
Move the driver's Kconfig symbol inside the LCD_CLASS_DEVICE block.

When CONFIG_BACKLIGHT_CLASS_DEVICE is not enabled:
ERROR: "backlight_device_register" [drivers/video/backlight/s6e63m0.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: InKi Dae  <inki.dae@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/Kconfig |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN drivers/video/backlight/Kconfig~backlight-fix-s6e63m0-kconfig drivers/video/backlight/Kconfig
--- a/drivers/video/backlight/Kconfig~backlight-fix-s6e63m0-kconfig
+++ a/drivers/video/backlight/Kconfig
@@ -101,14 +101,16 @@ config LCD_HP700
 	  If you have an HP Jornada 700 series handheld (710/720/728)
 	  say Y to enable LCD control driver.
 
-endif # LCD_CLASS_DEVICE
-
 config LCD_S6E63M0
 	tristate "S6E63M0 AMOLED LCD Driver"
-	depends on LCD_CLASS_DEVICE && SPI
+	depends on SPI && BACKLIGHT_CLASS_DEVICE
 	default n
 	help
-	  If you have an S6E63M0 LCD Panel say Y to enable LCD control driver
+	  If you have an S6E63M0 LCD Panel, say Y to enable its
+	  LCD control driver.
+
+endif # LCD_CLASS_DEVICE
+
 #
 # Backlight
 #
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
dib3000mc-reduce-large-stack-usage-fix.patch
media-ak881x-needs-slabh.patch
led-driver-for-the-soekris-net5501-board.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-fix-s6e63m0-kconfig.patch
backlight-fix-s6e63m0-device-attr-function-return-types.patch
scsi-fix-pmcraid-build-errors.patch
scsi-fix-be2iscsi-build.patch
scsi-fix-bnx2i-build-errors.patch
virtio_9ph-include-linux-typesh.patch
mmcompaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed.patch
ad525x_dpot-add-support-for-spi-parts-fix-ad525x_dpot-build.patch
lib-hexdumpc-reduce-stack-variable-size-and-cleanups.patch
xen-fix-build-when-sysrq-is-disabled.patch
rtc-cmos-do-dev_set_drvdata-earlier-in-the-initialization.patch
documentation-submittingdrivers-resources.patch
memcg-move-charge-of-file-pages-fix-2.patch
memcg-update-documentation-v8.patch
aio-fix-the-compat-vectored-operations-fix.patch
numa-update-documentation-vm-numa-add-memoryless-node-info.patch
numa-update-documentation-vm-numa-add-memoryless-node-info-fix1.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

