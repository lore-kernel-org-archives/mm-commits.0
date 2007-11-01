From: akpm@linux-foundation.org
Subject: + quirk_vialatency-omit-reading-pci-revision-id.patch added to -mm tree
Date: Thu, 01 Nov 2007 16:52:17 -0700
Message-ID: <200711012352.lA1NqHNG021970@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55697 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754634AbXKAXw2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2007 19:52:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: auke-jan.h.kok@intel.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com


The patch titled
     quirk_vialatency: Omit reading pci revision ID
has been added to the -mm tree.  Its filename is
     quirk_vialatency-omit-reading-pci-revision-id.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: quirk_vialatency: Omit reading pci revision ID
From: Auke Kok <auke-jan.h.kok@intel.com>

Don't read the revision ID unnecessary since the PCI subsystem
fills this field in already.

Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/quirks.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN drivers/pci/quirks.c~quirk_vialatency-omit-reading-pci-revision-id drivers/pci/quirks.c
--- a/drivers/pci/quirks.c~quirk_vialatency-omit-reading-pci-revision-id
+++ a/drivers/pci/quirks.c
@@ -139,25 +139,22 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_IN
 static void quirk_vialatency(struct pci_dev *dev)
 {
 	struct pci_dev *p;
-	u8 rev;
 	u8 busarb;
 	/* Ok we have a potential problem chipset here. Now see if we have
 	   a buggy southbridge */
 	   
 	p = pci_get_device(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_82C686, NULL);
 	if (p!=NULL) {
-		pci_read_config_byte(p, PCI_CLASS_REVISION, &rev);
 		/* 0x40 - 0x4f == 686B, 0x10 - 0x2f == 686A; thanks Dan Hollis */
 		/* Check for buggy part revisions */
-		if (rev < 0x40 || rev > 0x42)
+		if (p->revision < 0x40 || p->revision > 0x42)
 			goto exit;
 	} else {
 		p = pci_get_device(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_8231, NULL);
 		if (p==NULL)	/* No problem parts */
 			goto exit;
-		pci_read_config_byte(p, PCI_CLASS_REVISION, &rev);
 		/* Check for buggy part revisions */
-		if (rev < 0x10 || rev > 0x12) 
+		if (p->revision < 0x10 || p->revision > 0x12) 
 			goto exit;
 	}
 	
_

Patches currently in -mm which might be from auke-jan.h.kok@intel.com are

origin.patch
quirk_vialatency-omit-reading-pci-revision-id.patch
