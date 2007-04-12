From: akpm@linux-foundation.org
Subject: + use-menuconfig-objects-crypto-hw.patch added to -mm tree
Date: Thu, 12 Apr 2007 15:47:32 -0700
Message-ID: <200704122247.l3CMlW84018703@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35500 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057AbXDLWrk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Apr 2007 18:47:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jengelh@linux01.gwdg.de, jengelh@gmx.de


The patch titled
     Use menuconfig objects: crypto hw
has been added to the -mm tree.  Its filename is
     use-menuconfig-objects-crypto-hw.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use menuconfig objects: crypto hw
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Use menuconfigs instead of menus, so the whole menu can be disabled at once
instead of going through all options.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/crypto/Kconfig |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff -puN drivers/crypto/Kconfig~use-menuconfig-objects-crypto-hw drivers/crypto/Kconfig
--- a/drivers/crypto/Kconfig~use-menuconfig-objects-crypto-hw
+++ a/drivers/crypto/Kconfig
@@ -1,4 +1,9 @@
-menu "Hardware crypto devices"
+
+menuconfig CRYPTO_HW
+	bool "Hardware crypto devices"
+	default y
+
+if CRYPTO_HW
 
 config CRYPTO_DEV_PADLOCK
 	tristate "Support for VIA PadLock ACE"
@@ -66,4 +71,4 @@ config CRYPTO_DEV_GEODE
 	  To compile this driver as a module, choose M here: the module
 	  will be called geode-aes.
 
-endmenu
+endif # CRYPTO_HW
_

Patches currently in -mm which might be from jengelh@linux01.gwdg.de are

git-kbuild.patch
remove-artificial-software-max_loop-limit.patch
fix-kevents-childs-priority-greediness.patch
vt-allow-for-the-palette-to-be-exposed-and-changed-via-sysfs.patch
vt-add-color-support-to-the-underline-and-italic-attributes.patch
vt-expose-system-wide-utf-8-default-setting-via-sysfs.patch
use-menuconfig-objects-acpi.patch
use-menuconfig-objects-libata.patch
use-menuconfig-objects-block-layer.patch
use-menuconfig-objects-connector.patch
use-menuconfig-objects-crypto.patch
use-menuconfig-objects-crypto-hw.patch
use-menuconfig-objects-dccp.patch
use-menuconfig-objects-i2o.patch
use-menuconfig-objects-ide.patch
use-menuconfig-objects-mtd.patch
use-menuconfig-objects-ipvs.patch
use-menuconfig-objects-sctp.patch
use-menuconfig-objects-tipc.patch
use-menuconfig-objects-arcnet.patch
use-menuconfig-objects-phy.patch
use-menuconfig-objects-toeknring.patch
use-menuconfig-objects-netdev.patch
use-menuconfig-objects-oldcd.patch
use-menuconfig-objects-parport.patch
use-menuconfig-objects-pcihotplug.patch
use-menuconfig-objects-pcmcia.patch
use-menuconfig-objects-pnp.patch
use-menuconfig-objects-w1.patch
