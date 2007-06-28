From: akpm@linux-foundation.org
Subject: - use-menuconfig-objects-ii-scsi-fix.patch removed from -mm tree
Date: Thu, 28 Jun 2007 12:17:24 -0700
Message-ID: <200706281917.l5SJHOqN032258@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46364 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764201AbXF1TRd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Jun 2007 15:17:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@computergmbh.de, mm-commits@vger.kernel.org


The patch titled
     use-menuconfig-objects-ii-scsi fix
has been removed from the -mm tree.  Its filename was
     use-menuconfig-objects-ii-scsi-fix.patch

This patch was dropped because it causes oldconfig pain

------------------------------------------------------
Subject: use-menuconfig-objects-ii-scsi fix
From: Jan Engelhardt <jengelh@computergmbh.de>


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/Kconfig        |    1 -
 drivers/scsi/pcmcia/Kconfig |    3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/scsi/Kconfig~use-menuconfig-objects-ii-scsi-fix drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig~use-menuconfig-objects-ii-scsi-fix
+++ a/drivers/scsi/Kconfig
@@ -293,7 +293,6 @@ endmenu
 menuconfig SCSI_LOWLEVEL
 	bool "SCSI low-level drivers"
 	depends on SCSI!=n
-	default y
 
 if SCSI_LOWLEVEL
 
diff -puN drivers/scsi/pcmcia/Kconfig~use-menuconfig-objects-ii-scsi-fix drivers/scsi/pcmcia/Kconfig
--- a/drivers/scsi/pcmcia/Kconfig~use-menuconfig-objects-ii-scsi-fix
+++ a/drivers/scsi/pcmcia/Kconfig
@@ -5,9 +5,8 @@
 menuconfig SCSI_LOWLEVEL_PCMCIA
 	bool "PCMCIA SCSI adapter support"
 	depends on SCSI!=n && PCMCIA!=n
-	default y
 
-if SCSI_LOWLEVEL_PCMCIA
+if SCSI_LOWLEVEL_PCMCIA && SCSI && PCMCIA
 
 config PCMCIA_AHA152X
 	tristate "Adaptec AHA152X PCMCIA support"
_

Patches currently in -mm which might be from jengelh@computergmbh.de are

use-menuconfig-objects-ii-scsi-fix.patch
fix-gregkh-usb-usb-use-menuconfig-objects.patch
use-menuconfig-objects-ii-auxdisplay-fix.patch
use-menuconfig-objects-ii-misc-strange-dev-fix.patch
use-menuconfig-objects-ii-oprofile-fix.patch
use-menuconfig-objects-crypto-hw-fix.patch
