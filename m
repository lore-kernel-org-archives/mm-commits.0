From: akpm@linux-foundation.org
Subject: + hptiop-use-pci-vendor-symbol.patch added to -mm tree
Date: Fri, 17 Aug 2007 11:26:57 -0700
Message-ID: <200708171826.l7HIQv5U023438@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56269 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754448AbXHQS1k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Aug 2007 14:27:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org, James.Bottomley@SteelEye.com, linux@highpoint-tech.com


The patch titled
     hptiop: Use PCI vendor symbol
has been added to the -mm tree.  Its filename is
     hptiop-use-pci-vendor-symbol.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: hptiop: Use PCI vendor symbol
From: Jean Delvare <khali@linux-fr.org>

Use the PCI vendor symbol instead of a numeric value in the
scsi/hptiop driver.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: HighPoint Linux Team <linux@highpoint-tech.com>
Cc: "James E.J. Bottomley" <James.Bottomley@SteelEye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hptiop.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/hptiop.c~hptiop-use-pci-vendor-symbol drivers/scsi/hptiop.c
--- a/drivers/scsi/hptiop.c~hptiop-use-pci-vendor-symbol
+++ a/drivers/scsi/hptiop.c
@@ -879,8 +879,8 @@ static void hptiop_remove(struct pci_dev
 }
 
 static struct pci_device_id hptiop_id_table[] = {
-	{ PCI_DEVICE(0x1103, 0x3220) },
-	{ PCI_DEVICE(0x1103, 0x3320) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_TTI, 0x3220) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_TTI, 0x3320) },
 	{},
 };
 
_

Patches currently in -mm which might be from khali@linux-fr.org are

origin.patch
git-dvb.patch
git-hwmon.patch
hdaps-switch-to-using-input-polldev.patch
applesmc-switch-to-using-input-polldev.patch
ams-switch-to-using-input-polldev.patch
hptiop-use-pci-vendor-symbol.patch
