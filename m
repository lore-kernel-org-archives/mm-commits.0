From: akpm@linux-foundation.org
Subject: + use-menuconfig-objects-ii-scsi-fix.patch added to -mm tree
Date: Thu, 28 Jun 2007 13:39:37 -0700
Message-ID: <200706282039.l5SKdc99001083@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57369 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765710AbXF1Ujs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Jun 2007 16:39:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jengelh@computergmbh.de


The patch titled
     use-menuconfig-objects-ii-scsi fix
has been added to the -mm tree.  Its filename is
     use-menuconfig-objects-ii-scsi-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: use-menuconfig-objects-ii-scsi fix
From: Jan Engelhardt <jengelh@computergmbh.de>


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/Kconfig        |    1 -
 drivers/scsi/pcmcia/Kconfig |    3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

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
