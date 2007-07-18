From: akpm@linux-foundation.org
Subject: - use-menuconfig-objects-ii-scsi.patch removed from -mm tree
Date: Wed, 18 Jul 2007 11:52:21 -0700
Message-ID: <200707181852.l6IIqLp5023666@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57537 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934656AbXGRSzM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 14:55:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@linux01.gwdg.de, James.Bottomley@steeleye.com, jengelh@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Use menuconfig objects II - SCSI
has been removed from the -mm tree.  Its filename was
     use-menuconfig-objects-ii-scsi.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Use menuconfig objects II - SCSI
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Make a "menuconfig" out of the Kconfig objects "menu, ..., endmenu",
so that the user can disable all the options in that menu at once
instead of having to disable each option separately.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/Kconfig        |    8 ++++++--
 drivers/scsi/pcmcia/Kconfig |    7 +++++--
 2 files changed, 11 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/Kconfig~use-menuconfig-objects-ii-scsi drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig~use-menuconfig-objects-ii-scsi
+++ a/drivers/scsi/Kconfig
@@ -291,8 +291,12 @@ source "drivers/scsi/libsas/Kconfig"
 
 endmenu
 
-menu "SCSI low-level drivers"
+menuconfig SCSI_LOWLEVEL
+	bool "SCSI low-level drivers"
 	depends on SCSI!=n
+	default y
+
+if SCSI_LOWLEVEL
 
 config ISCSI_TCP
 	tristate "iSCSI Initiator over TCP/IP"
@@ -1802,7 +1806,7 @@ config SCSI_SRP
 	  To compile this driver as a module, choose M here: the
 	  module will be called libsrp.
 
-endmenu
+endif # SCSI_LOWLEVEL
 
 source "drivers/scsi/pcmcia/Kconfig"
 
diff -puN drivers/scsi/pcmcia/Kconfig~use-menuconfig-objects-ii-scsi drivers/scsi/pcmcia/Kconfig
--- a/drivers/scsi/pcmcia/Kconfig~use-menuconfig-objects-ii-scsi
+++ a/drivers/scsi/pcmcia/Kconfig
@@ -2,9 +2,12 @@
 # PCMCIA SCSI adapter configuration
 #
 
-menu "PCMCIA SCSI adapter support"
+menuconfig SCSI_LOWLEVEL_PCMCIA
+	bool "PCMCIA SCSI adapter support"
 	depends on SCSI!=n && PCMCIA!=n
 
+if SCSI_LOWLEVEL_PCMCIA && SCSI && PCMCIA
+
 config PCMCIA_AHA152X
 	tristate "Adaptec AHA152X PCMCIA support"
 	depends on !64BIT
@@ -77,4 +80,4 @@ config PCMCIA_SYM53C500
 	  To compile this driver as a module, choose M here: the
 	  module will be called sym53c500_cs.
 
-endmenu
+endif # SCSI_LOWLEVEL_PCMCIA
_

Patches currently in -mm which might be from jengelh@linux01.gwdg.de are

origin.patch
git-acpi.patch
git-kvm.patch
use-menuconfig-objects-pcmcia.patch
git-scsi-misc.patch
