From: akpm@linux-foundation.org
Subject: - use-menuconfig-objects-pnp.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:52:48 -0700
Message-ID: <200707162052.l6GKqm2q001570@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33959 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761703AbXGPVfr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:35:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@linux01.gwdg.de, ambx1@neo.rr.com, bjorn.helgaas@hp.com, jengelh@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Use menuconfig objects: PNP
has been removed from the -mm tree.  Its filename was
     use-menuconfig-objects-pnp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Use menuconfig objects: PNP
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Use menuconfigs instead of menus, so the whole menu can be disabled at once
instead of going through all options.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/Kconfig         |   13 +++++--------
 drivers/pnp/isapnp/Kconfig  |    2 +-
 drivers/pnp/pnpbios/Kconfig |    2 +-
 3 files changed, 7 insertions(+), 10 deletions(-)

diff -puN drivers/pnp/Kconfig~use-menuconfig-objects-pnp drivers/pnp/Kconfig
--- a/drivers/pnp/Kconfig~use-menuconfig-objects-pnp
+++ a/drivers/pnp/Kconfig
@@ -2,11 +2,9 @@
 # Plug and Play configuration
 #
 
-menu "Plug and Play support"
-	depends on HAS_IOMEM
-
-config PNP
+menuconfig PNP
 	bool "Plug and Play support"
+	depends on HAS_IOMEM
 	depends on ISA || ACPI
 	---help---
 	  Plug and Play (PnP) is a standard for peripherals which allows those
@@ -22,15 +20,15 @@ config PNP
 
 	  If unsure, say Y.
 
+if PNP
+
 config PNP_DEBUG
 	bool "PnP Debug Messages"
-	depends on PNP
 	help
 	  Say Y if you want the Plug and Play Layer to print debug messages.
 	  This is useful if you are developing a PnP driver or troubleshooting.
 
 comment "Protocols"
-	depends on PNP
 
 source "drivers/pnp/isapnp/Kconfig"
 
@@ -38,5 +36,4 @@ source "drivers/pnp/pnpbios/Kconfig"
 
 source "drivers/pnp/pnpacpi/Kconfig"
 
-endmenu
-
+endif # PNP
diff -puN drivers/pnp/isapnp/Kconfig~use-menuconfig-objects-pnp drivers/pnp/isapnp/Kconfig
--- a/drivers/pnp/isapnp/Kconfig~use-menuconfig-objects-pnp
+++ a/drivers/pnp/isapnp/Kconfig
@@ -3,7 +3,7 @@
 #
 config ISAPNP
 	bool "ISA Plug and Play support"
-	depends on PNP && ISA
+	depends on ISA
 	help
 	  Say Y here if you would like support for ISA Plug and Play devices.
 	  Some information is in <file:Documentation/isapnp.txt>.
diff -puN drivers/pnp/pnpbios/Kconfig~use-menuconfig-objects-pnp drivers/pnp/pnpbios/Kconfig
--- a/drivers/pnp/pnpbios/Kconfig~use-menuconfig-objects-pnp
+++ a/drivers/pnp/pnpbios/Kconfig
@@ -3,7 +3,7 @@
 #
 config PNPBIOS
 	bool "Plug and Play BIOS support (EXPERIMENTAL)"
-	depends on PNP && ISA && X86 && EXPERIMENTAL
+	depends on ISA && X86 && EXPERIMENTAL
 	default n
 	---help---
 	  Linux uses the PNPBIOS as defined in "Plug and Play BIOS
_

Patches currently in -mm which might be from jengelh@linux01.gwdg.de are

origin.patch
git-acpi.patch
git-kvm.patch
use-menuconfig-objects-pcmcia.patch
use-menuconfig-objects-ii-scsi.patch
use-menuconfig-objects-isdn-config_isdn.patch
use-menuconfig-objects-isdn-config_isdn_capi.patch
use-menuconfig-objects-isdn-config_capi_avm.patch
use-menuconfig-objects-isdn-config_capi_eicon.patch
use-menuconfig-objects-ii-md.patch
