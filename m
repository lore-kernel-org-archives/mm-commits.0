From: akpm@linux-foundation.org
Subject: - new-sata_promise-209-fails-to-identify-st3400832as.patch removed from -mm tree
Date: Fri, 31 Aug 2007 09:56:48 -0700
Message-ID: <200708311656.l7VGumVO017514@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58458 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932325AbXHaRIv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 13:08:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mikpe@it.uu.se, jeff@garzik.org, michal.k.k.piotrowski@gmail.com, sziemba@ecn.purdue.edu, mm-commits@vger.kernel.org


The patch titled
     sata_promise 2.09 fails to identify ST3400832AS
has been removed from the -mm tree.  Its filename was
     new-sata_promise-209-fails-to-identify-st3400832as.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sata_promise 2.09 fails to identify ST3400832AS
From: Mikael Pettersson <mikpe@it.uu.se>

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=8936

According to the lspci the boards are FastTrak TX4200 with DID 0x3519. 
Unfortunately these aren't publicly documented, but judging from what little
information there is in Promise's partial-source FT TX4200 driver, DID 0x3519
is a second-generation chip.

However, sata_promise.c declares it as a first-generation chip, which changes
some details.  This didn't matter too much before, but with the hotplug
changes in 2.6.23-rc1, it matters more because the location of the SATA
hotplug register is different in 1st and 2nd generation chips.  (There are
also some "failed to resume link for reset" errors with the 2.08 driver that
may be caused by the 1st-vs-2nd generation confusion.)

I suspect that correcting the driver to mark DID 0x3515/0x3519 as
2nd-generation should fix the problem.

Thanks to Stephen Ziemba for reporting the bug and for testing the fix.

Cc: Stephen Ziemba <sziemba@ecn.purdue.edu>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/sata_promise.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/ata/sata_promise.c~new-sata_promise-209-fails-to-identify-st3400832as drivers/ata/sata_promise.c
--- a/drivers/ata/sata_promise.c~new-sata_promise-209-fails-to-identify-st3400832as
+++ a/drivers/ata/sata_promise.c
@@ -45,7 +45,7 @@
 #include "sata_promise.h"
 
 #define DRV_NAME	"sata_promise"
-#define DRV_VERSION	"2.09"
+#define DRV_VERSION	"2.10"
 
 enum {
 	PDC_MAX_PORTS		= 4,
@@ -322,8 +322,8 @@ static const struct pci_device_id pdc_at
 
 	{ PCI_VDEVICE(PROMISE, 0x3318), board_20319 },
 	{ PCI_VDEVICE(PROMISE, 0x3319), board_20319 },
-	{ PCI_VDEVICE(PROMISE, 0x3515), board_20319 },
-	{ PCI_VDEVICE(PROMISE, 0x3519), board_20319 },
+	{ PCI_VDEVICE(PROMISE, 0x3515), board_40518 },
+	{ PCI_VDEVICE(PROMISE, 0x3519), board_40518 },
 	{ PCI_VDEVICE(PROMISE, 0x3d17), board_40518 },
 	{ PCI_VDEVICE(PROMISE, 0x3d18), board_40518 },
 
_

Patches currently in -mm which might be from mikpe@it.uu.se are

git-libata-all.patch
