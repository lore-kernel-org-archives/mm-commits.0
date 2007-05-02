From: akpm@linux-foundation.org
Subject: + add-the-combined-mode-for-ati-sb700.patch added to -mm tree
Date: Tue, 01 May 2007 17:14:18 -0700
Message-ID: <200705020014.l420EIZa009872@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42726 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946128AbXEBAOa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 May 2007 20:14:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: henry.su@amd.com, htejun@gmail.com, jeff@garzik.org, luugi.marsan@amd.com


The patch titled
     Add the combined mode for ATI SB700
has been added to the -mm tree.  Its filename is
     add-the-combined-mode-for-ati-sb700.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add the combined mode for ATI SB700
From: "Henry Su" <henry.su@amd.com>

Besides those modes in ATI SB600 SATA controller, ATI SB700 supports one
more mode:the combined mode.

The combined mode is a Legacy IDE mode used for compatibility with some old
OS without AHCI driver, but now it is not necessary for Linux since the
kernel has supported AHCI.

Signed-off-by: Luugi Marsan <luugi.marsan@amd.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/quirks.c    |    1 +
 include/linux/pci_ids.h |    1 +
 2 files changed, 2 insertions(+)

diff -puN drivers/pci/quirks.c~add-the-combined-mode-for-ati-sb700 drivers/pci/quirks.c
--- a/drivers/pci/quirks.c~add-the-combined-mode-for-ati-sb700
+++ a/drivers/pci/quirks.c
@@ -875,6 +875,7 @@ static void __devinit quirk_sb600_sata(s
 	}
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP600_SATA, quirk_sb600_sata);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP700_SATA, quirk_sb600_sata);
 
 /*
  *	Serverworks CSB5 IDE does not fully support native mode
diff -puN include/linux/pci_ids.h~add-the-combined-mode-for-ati-sb700 include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~add-the-combined-mode-for-ati-sb700
+++ a/include/linux/pci_ids.h
@@ -370,6 +370,7 @@
 #define PCI_DEVICE_ID_ATI_IXP600_SATA	0x4380
 #define PCI_DEVICE_ID_ATI_IXP600_SMBUS	0x4385
 #define PCI_DEVICE_ID_ATI_IXP600_IDE	0x438c
+#define PCI_DEVICE_ID_ATI_IXP700_SATA	0x4390
 
 #define PCI_VENDOR_ID_VLSI		0x1004
 #define PCI_DEVICE_ID_VLSI_82C592	0x0005
_

Patches currently in -mm which might be from henry.su@amd.com are

add-the-combined-mode-for-ati-sb700.patch
