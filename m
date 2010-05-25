From: akpm@linux-foundation.org
Subject: + compal-laptop-uses-hwmon-interfaces-depends-on-hwmon.patch added to -mm tree
Date: Tue, 25 May 2010 16:14:17 -0700
Message-ID: <201005252314.o4PNEHdU020894@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34788 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932370Ab0EYXOY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 May 2010 19:14:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, mjg59@srcf.ucam.org, roald.frederickx@gmail.com


The patch titled
     compal-laptop: uses hwmon interfaces, depends on HWMON
has been added to the -mm tree.  Its filename is
     compal-laptop-uses-hwmon-interfaces-depends-on-hwmon.patch

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
Subject: compal-laptop: uses hwmon interfaces, depends on HWMON
From: Randy Dunlap <randy.dunlap@oracle.com>

compal-laptop uses hwmon interfaces, so it should depend on HWMON.

compal-laptop.c:(.devinit.text+0x4071f): undefined reference to `hwmon_device_register'
compal-laptop.c:(.devexit.text+0x6ec0): undefined reference to `hwmon_device_unregister'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Roald Frederickx <roald.frederickx@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/platform/x86/Kconfig~compal-laptop-uses-hwmon-interfaces-depends-on-hwmon drivers/platform/x86/Kconfig
--- a/drivers/platform/x86/Kconfig~compal-laptop-uses-hwmon-interfaces-depends-on-hwmon
+++ a/drivers/platform/x86/Kconfig
@@ -181,6 +181,7 @@ config COMPAL_LAPTOP
 	depends on ACPI
 	depends on BACKLIGHT_CLASS_DEVICE
 	depends on RFKILL
+	depends on HWMON
 	---help---
 	  This is a driver for laptops built by Compal:
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
compal-laptop-uses-hwmon-interfaces-depends-on-hwmon.patch
dib3000mc-reduce-large-stack-usage-fix.patch
media-ak881x-needs-slabh.patch
led-driver-for-the-soekris-net5501-board.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-s6e63m0-amoled-lcd-panel-driver.patch
scsi-fix-pmcraid-build-errors.patch
scsi-fix-be2iscsi-build.patch
scsi-fix-bnx2i-build-errors.patch
virtio_9ph-include-linux-typesh.patch
documentation-submittingdrivers-resources.patch
memcg-move-charge-of-file-pages-fix-2.patch
memcg-update-documentation-v8.patch
aio-fix-the-compat-vectored-operations-fix.patch
numa-update-documentation-vm-numa-add-memoryless-node-info.patch
numa-update-documentation-vm-numa-add-memoryless-node-info-fix1.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

