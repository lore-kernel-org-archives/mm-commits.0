From: akpm@linux-foundation.org
Subject: + libata-isolate-and-rework-cable-logic.patch added to -mm tree
Date: Fri, 08 Feb 2008 13:32:40 -0800
Message-ID: <200802082132.m18LWeDE014398@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40808 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752789AbYBHVdY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 16:33:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     libata: isolate and rework cable logic
has been added to the -mm tree.  Its filename is
     libata-isolate-and-rework-cable-logic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: libata: isolate and rework cable logic
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |   48 +++++++++++++++++++++++++++++++++---
 1 file changed, 44 insertions(+), 4 deletions(-)

diff -puN drivers/ata/libata-core.c~libata-isolate-and-rework-cable-logic drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-isolate-and-rework-cable-logic
+++ a/drivers/ata/libata-core.c
@@ -4256,6 +4256,49 @@ static int ata_is_40wire(struct ata_devi
 }
 
 /**
+ *	cable_is_40wire		-	40/80/SATA decider
+ *	@ap: port to consider
+ *
+ *	This function encapsulates the policy for speed management
+ *	in one place. At the moment we don't cache the result but
+ *	there is a good case for setting ap->cbl to the result when
+ *	we are called with unknown cables (and figuring out if it
+ *	impacts hotplug at all).
+ *
+ *	Return 1 if the cable appears to be 40 wire.
+ */
+
+static int cable_is_40wire(struct ata_port *ap)
+{
+	struct ata_link *link;
+	struct ata_device *dev;
+
+	/* If the controller thinks we are 40 wire, we are */
+	if (ap->cbl == ATA_CBL_PATA40)
+		return 1;
+	/* If the controller thinks we are 80 wire, we are */
+	if (ap->cbl == ATA_CBL_PATA80 || ap->cbl == ATA_CBL_SATA)
+		return 0;
+	/* If the controller doesn't know we scan
+	
+	   - Note: We look for all 40 wire detects at this point.
+	     Any 80 wire detect is taken to be 80 wire cable
+	     because
+	     - In many setups only the one drive (slave if present)
+               will give a valid detect
+             - If you have a non detect capable drive you don't
+               want it to colour the choice
+        */
+	ata_port_for_each_link(link, ap) {
+		ata_link_for_each_dev(dev, link) {
+			if (!ata_is_40wire(dev))
+				return 0;
+		}
+	}
+	return 1;
+}
+
+/**
  *	ata_dev_xfermask - Compute supported xfermask of the given device
  *	@dev: Device to compute xfermask for
  *
@@ -4323,10 +4366,7 @@ static void ata_dev_xfermask(struct ata_
 	 */
 	if (xfer_mask & (0xF8 << ATA_SHIFT_UDMA))
 		/* UDMA/44 or higher would be available */
-		if ((ap->cbl == ATA_CBL_PATA40) ||
-		    (ata_is_40wire(dev) &&
-		    (ap->cbl == ATA_CBL_PATA_UNK ||
-		     ap->cbl == ATA_CBL_PATA80))) {
+		if (cable_is_40wire(ap)) {
 			ata_dev_printk(dev, KERN_WARNING,
 				 "limited to UDMA/33 due to 40-wire cable\n");
 			xfer_mask &= ~(0xF8 << ATA_SHIFT_UDMA);
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
libata-isolate-and-rework-cable-logic.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
hci_ldisc-fix-null-pointer-deref.patch
parisc-new-termios-definitions.patch
git-sh.patch
git-watchdog.patch
