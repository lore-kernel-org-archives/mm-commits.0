From: akpm@osdl.org
Subject: - kbuild-make-fusion-mpt-selectable-from-device-drivers.patch removed from -mm tree
Date: Thu, 14 Dec 2006 00:47:59 -0800
Message-ID: <200612140848.kBE8m1uC005391@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:60639 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932074AbWLNIsW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 03:48:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, Eric.Moore@lsil.com, James.Bottomley@steeleye.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     kbuild : Make Fusion MPT selectable from "Device drivers" menu
has been removed from the -mm tree.  Its filename was
     kbuild-make-fusion-mpt-selectable-from-device-drivers.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: kbuild : Make Fusion MPT selectable from "Device drivers" menu
From: "Robert P. J. Day" <rpjday@mindspring.com>

Rewrite the Fusion MPT Kconfig file so that all of MPT functionality is
entirely selectable from "Device drivers."

The original Kconfig file seems to have an odd structure, as you can see
from the first part of the file:

========================================================
menu "Fusion MPT device support"

config FUSION
        bool
        default n

config FUSION_SPI
        tristate "Fusion MPT ScsiHost drivers for SPI"
        depends on PCI && SCSI
        select FUSION
        select SCSI_SPI_ATTRS
        ...
========================================================

Note how the majority of entries in that file don't directly *depend* on
FUSION.  instead, they depend on *external* config variables, and *select*
FUSION, and this is not the only place i've noticed that kind of dependency
wording.

Is that a regular feature?  having that structure certainly makes it
slightly more difficult to rewrite the menu entries, and it's not clear
there's any obvious advantage to doing it that way.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/message/fusion/Kconfig |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff -puN drivers/message/fusion/Kconfig~kbuild-make-fusion-mpt-selectable-from-device-drivers drivers/message/fusion/Kconfig
--- a/drivers/message/fusion/Kconfig~kbuild-make-fusion-mpt-selectable-from-device-drivers
+++ a/drivers/message/fusion/Kconfig
@@ -1,14 +1,12 @@
-
-menu "Fusion MPT device support"
-
-config FUSION
-	bool
+menuconfig FUSION
+	bool "Fusion MPT device support"
 	default n
 
+if FUSION
+
 config FUSION_SPI
 	tristate "Fusion MPT ScsiHost drivers for SPI"
 	depends on PCI && SCSI
-	select FUSION
 	select SCSI_SPI_ATTRS
 	---help---
 	  SCSI HOST support for a parallel SCSI host adapters.
@@ -23,7 +21,6 @@ config FUSION_SPI
 config FUSION_FC
 	tristate "Fusion MPT ScsiHost drivers for FC"
 	depends on PCI && SCSI
-	select FUSION
 	select SCSI_FC_ATTRS
 	---help---
 	  SCSI HOST support for a Fiber Channel host adapters.
@@ -40,7 +37,6 @@ config FUSION_FC
 config FUSION_SAS
 	tristate "Fusion MPT ScsiHost drivers for SAS"
 	depends on PCI && SCSI
- 	select FUSION
 	select SCSI_SAS_ATTRS
 	---help---
 	  SCSI HOST support for a SAS host adapters.
@@ -100,4 +96,4 @@ config FUSION_LAN
 
 	  If unsure whether you really want or need this, say N.
 
-endmenu
+endif
_

Patches currently in -mm which might be from rpjday@mindspring.com are

kbuild-make-fusion-mpt-selectable-from-device-drivers.patch

