From: akpm@linux-foundation.org
Subject: - use-menuconfig-objects-arcnet.patch removed from -mm tree
Date: Tue, 29 May 2007 11:54:51 -0700
Message-ID: <200705291854.l4TIsosN008553@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:51112 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752384AbXE2SzZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:55:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@linux01.gwdg.de, jengelh@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Use menuconfig objects: ARCNET
has been removed from the -mm tree.  Its filename was
     use-menuconfig-objects-arcnet.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Use menuconfig objects: ARCNET
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Use menuconfigs instead of menus, so the whole menu can be disabled at once
instead of going through all options.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/arcnet/Kconfig |   17 ++++-------------
 1 files changed, 4 insertions(+), 13 deletions(-)

diff -puN drivers/net/arcnet/Kconfig~use-menuconfig-objects-arcnet drivers/net/arcnet/Kconfig
--- a/drivers/net/arcnet/Kconfig~use-menuconfig-objects-arcnet
+++ a/drivers/net/arcnet/Kconfig
@@ -2,10 +2,8 @@
 # Arcnet configuration
 #
 
-menu "ARCnet devices"
+menuconfig ARCNET
 	depends on NETDEVICES && (ISA || PCI)
-
-config ARCNET
 	tristate "ARCnet support"
 	---help---
 	  If you have a network card of this type, say Y and check out the
@@ -25,9 +23,10 @@ config ARCNET
 	  <file:Documentation/networking/net-modules.txt>.  The module will
 	  be called arcnet.
 
+if ARCNET
+
 config ARCNET_1201
 	tristate "Enable standard ARCNet packet format (RFC 1201)"
-	depends on ARCNET
 	help
 	  This allows you to use RFC1201 with your ARCnet card via the virtual
 	  arc0 device.  You need to say Y here to communicate with
@@ -38,7 +37,6 @@ config ARCNET_1201
 
 config ARCNET_1051
 	tristate "Enable old ARCNet packet format (RFC 1051)"
-	depends on ARCNET
 	---help---
 	  This allows you to use RFC1051 with your ARCnet card via the virtual
 	  arc0s device. You only need arc0s if you want to talk to ARCnet
@@ -53,7 +51,6 @@ config ARCNET_1051
 
 config ARCNET_RAW
 	tristate "Enable raw mode packet interface"
-	depends on ARCNET
 	help
 	  ARCnet "raw mode" packet encapsulation, no soft headers.  Unlikely
 	  to work unless talking to a copy of the same Linux arcnet driver,
@@ -61,7 +58,6 @@ config ARCNET_RAW
 
 config ARCNET_CAP
 	tristate "Enable CAP mode packet interface"
-	depends on ARCNET
 	help
 	  ARCnet "cap mode" packet encapsulation. Used to get the hardware
           acknowledge back to userspace. After the initial protocol byte every
@@ -80,7 +76,6 @@ config ARCNET_CAP
 
 config ARCNET_COM90xx
 	tristate "ARCnet COM90xx (normal) chipset driver"
-	depends on ARCNET
 	help
 	  This is the chipset driver for the standard COM90xx cards. If you
 	  have always used the old ARCnet driver without knowing what type of
@@ -92,7 +87,6 @@ config ARCNET_COM90xx
 
 config ARCNET_COM90xxIO
 	tristate "ARCnet COM90xx (IO mapped) chipset driver"
-	depends on ARCNET
 	---help---
 	  This is the chipset driver for the COM90xx cards, using them in
 	  IO-mapped mode instead of memory-mapped mode. This is slower than
@@ -105,7 +99,6 @@ config ARCNET_COM90xxIO
 
 config ARCNET_RIM_I
 	tristate "ARCnet COM90xx (RIM I) chipset driver"
-	depends on ARCNET
 	---help---
 	  This is yet another chipset driver for the COM90xx cards, but this
 	  time only using memory-mapped mode, and no IO ports at all. This
@@ -118,7 +111,6 @@ config ARCNET_RIM_I
 
 config ARCNET_COM20020
 	tristate "ARCnet COM20020 chipset driver"
-	depends on ARCNET
 	help
 	  This is the driver for the new COM20020 chipset. It supports such
 	  things as promiscuous mode, so packet sniffing is possible, and
@@ -136,5 +128,4 @@ config ARCNET_COM20020_PCI
 	tristate "Support for COM20020 on PCI"
 	depends on ARCNET_COM20020 && PCI
 
-endmenu
-
+endif # ARCNET
_

Patches currently in -mm which might be from jengelh@linux01.gwdg.de are

use-menuconfig-objects-acpi.patch
git-hid.patch
use-menuconfig-objects-ii-infiniband.patch
git-kvm.patch
use-menuconfig-objects-ii-netdev-general100mbit.patch
use-menuconfig-objects-pcmcia.patch
use-menuconfig-objects-ii-scsi.patch
use-menuconfig-objects-oldcd.patch
use-menuconfig-objects-block-layer.patch
use-menuconfig-objects-ib-block.patch
use-menuconfig-objects-ii-block-devices.patch
use-menuconfig-objects-ii-auxdisplay.patch
use-menuconfig-objects-ii-edac.patch
use-menuconfig-objects-ii-ipmi.patch
use-menuconfig-objects-ii-misc-strange-dev.patch
use-menuconfig-objects-ii-module-menu.patch
use-menuconfig-objects-ii-oprofile.patch
use-menuconfig-objects-ii-telephony.patch
use-menuconfig-objects-ii-tpm.patch
use-menuconfig-objects-connector.patch
use-menuconfig-objects-crypto-hw.patch
use-menuconfig-objects-i2o.patch
use-menuconfig-objects-parport.patch
use-menuconfig-objects-pnp.patch
use-menuconfig-objects-w1.patch
use-menuconfig-objects-ii-isdn.patch
use-menuconfig-objects-ii-md.patch
