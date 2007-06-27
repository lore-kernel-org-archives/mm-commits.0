From: akpm@linux-foundation.org
Subject: + use-menuconfig-objects-ii-scsi-fix.patch added to -mm tree
Date: Wed, 27 Jun 2007 14:13:33 -0700
Message-ID: <200706272113.l5RLDXrM007260@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51355 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751600AbXF0VNn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jun 2007 17:13:43 -0400
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
