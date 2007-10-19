From: akpm@linux-foundation.org
Subject: + null-terminate-the-pci_device_ids-in-pasemi_edac.patch added to -mm tree
Date: Thu, 18 Oct 2007 22:18:37 -0700
Message-ID: <200710190518.l9J5IbH4016888@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55952 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752234AbXJSFSo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 01:18:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sfr@canb.auug.org.au, dougthompson@xmission.com


The patch titled
     NULL terminate the pci_device_ids in pasemi_edac
has been added to the -mm tree.  Its filename is
     null-terminate-the-pci_device_ids-in-pasemi_edac.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: NULL terminate the pci_device_ids in pasemi_edac
From: Stephen Rothwell <sfr@canb.auug.org.au>

Fixes:
drivers/edac/pasemi_edac: struct pci_device_id is 32 bytes.  The last of 1 is:
0x00 0x00 0x19 0x59 0x00 0x00 0xa0 0x0a 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff
0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00
FATAL: drivers/edac/pasemi_edac: struct pci_device_id is not terminated with a NULL entry!

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Douglas Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/pasemi_edac.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/edac/pasemi_edac.c~null-terminate-the-pci_device_ids-in-pasemi_edac drivers/edac/pasemi_edac.c
--- a/drivers/edac/pasemi_edac.c~null-terminate-the-pci_device_ids-in-pasemi_edac
+++ a/drivers/edac/pasemi_edac.c
@@ -270,6 +270,7 @@ static void __devexit pasemi_edac_remove
 
 static const struct pci_device_id pasemi_edac_pci_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_PASEMI, 0xa00a) },
+	{ }
 };
 
 MODULE_DEVICE_TABLE(pci, pasemi_edac_pci_tbl);
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
null-terminate-the-pci_device_ids-in-pasemi_edac.patch
