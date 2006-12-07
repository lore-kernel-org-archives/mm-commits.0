From: akpm@osdl.org
Subject: - cciss-fix-pci-ssid-for-the-e500-controller.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:00:26 -0800
Message-ID: <200612072300.kB7N0QcE029640@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51283 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163662AbWLGXAu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:00:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.miller@hp.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     cciss: fix pci ssid for the E500 controller
has been removed from the -mm tree.  Its filename was
     cciss-fix-pci-ssid-for-the-e500-controller.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cciss: fix pci ssid for the E500 controller
From: Mike Miller <mike.miller@hp.com>

Change the SSID on the E500 as a workaround for a firmware bug.  It looks like
the original patch was backed out between rc2 and rc4.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Acked-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/block/cciss.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/block/cciss.c~cciss-fix-pci-ssid-for-the-e500-controller drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-fix-pci-ssid-for-the-e500-controller
+++ a/drivers/block/cciss.c
@@ -82,7 +82,7 @@ static const struct pci_device_id cciss_
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSD,     0x103C, 0x3213},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSD,     0x103C, 0x3214},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSD,     0x103C, 0x3215},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSC,     0x103C, 0x3233},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSC,     0x103C, 0x3237},
 	{PCI_VENDOR_ID_HP,     PCI_ANY_ID,	PCI_ANY_ID, PCI_ANY_ID,
 		PCI_CLASS_STORAGE_RAID << 8, 0xffff << 8, 0},
 	{0,}
@@ -114,7 +114,7 @@ static struct board_type products[] = {
 	{0x3213103C, "Smart Array E200i", &SA5_access, 120},
 	{0x3214103C, "Smart Array E200i", &SA5_access, 120},
 	{0x3215103C, "Smart Array E200i", &SA5_access, 120},
-	{0x3233103C, "Smart Array E500", &SA5_access, 512},
+	{0x3237103C, "Smart Array E500", &SA5_access, 512},
 	{0xFFFF103C, "Unknown Smart Array", &SA5_access, 120},
 };
 
_

Patches currently in -mm which might be from mike.miller@hp.com are

origin.patch

