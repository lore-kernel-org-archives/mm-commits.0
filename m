From: akpm@linux-foundation.org
Subject: + gpio-rdc321x-needs-to-select-mfd_core.patch added to -mm tree
Date: Wed, 12 May 2010 14:10:51 -0700
Message-ID: <201005122110.o4CLApKD020697@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38135 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752194Ab0ELVLD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 May 2010 17:11:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, florian@openwrt.org, sameo@linux.intel.com


The patch titled
     gpio: rdc321x needs to select MFD_CORE
has been added to the -mm tree.  Its filename is
     gpio-rdc321x-needs-to-select-mfd_core.patch

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
Subject: gpio: rdc321x needs to select MFD_CORE
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix rdc321x-southbridge build: GPIO_RDC321X needs to select MFD_CORE so
that the core is built at the same (or higher) tristate level.

rdc321x-southbridge.c:(.devinit.text+0x6103): undefined reference to `mfd_add_devices'
rdc321x-southbridge.c:(.devexit.text+0xe5f): undefined reference to `mfd_remove_devices'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Florian Fainelli <florian@openwrt.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/gpio/Kconfig~gpio-rdc321x-needs-to-select-mfd_core drivers/gpio/Kconfig
--- a/drivers/gpio/Kconfig~gpio-rdc321x-needs-to-select-mfd_core
+++ a/drivers/gpio/Kconfig
@@ -292,6 +292,7 @@ config GPIO_TIMBERDALE
 config GPIO_RDC321X
 	tristate "RDC R-321x GPIO support"
 	depends on PCI && GPIOLIB
+	select MFD_CORE
 	select MFD_RDC321X
 	help
 	  Support for the RDC R321x SoC GPIOs over southbridge
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
dib3000mc-reduce-large-stack-usage-fix.patch
led-driver-for-the-soekris-net5501-board.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-new-driver-for-the-adp8860-backlight-parts-fix-adp8860_bl-build-errors.patch
scsi-fix-convert-scsi_scanc-kernel-doc.patch
scsi-update-drivers-tools-url-references.patch
scsi-fix-pmcraid-build-errors.patch
scsi-fix-be2iscsi-build.patch
scsi-fix-bnx2i-build-errors.patch
virtio_9ph-include-linux-typesh.patch
mmcompaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed.patch
ad525x_dpot-add-support-for-spi-parts-fix-ad525x_dpot-build.patch
lib-hexdumpc-reduce-stack-variable-size-and-cleanups.patch
xen-fix-build-when-sysrq-is-disabled.patch
gpio-rdc321x-needs-to-select-mfd_core.patch
documentation-submittingdrivers-resources.patch
memcg-move-charge-of-file-pages-fix-2.patch
memcg-update-documentation-v8.patch
aio-fix-the-compat-vectored-operations-fix.patch
numa-update-documentation-vm-numa-add-memoryless-node-info.patch
numa-update-documentation-vm-numa-add-memoryless-node-info-fix1.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

