From: akpm@osdl.org
Subject: - cciss-reference-driver-support.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:00:21 -0800
Message-ID: <200612072300.kB7N0L9V029634@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51254 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163648AbWLGXAg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:00:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.miller@hp.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     cciss: reference driver support
has been removed from the -mm tree.  Its filename was
     cciss-reference-driver-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cciss: reference driver support
From: Mike Miller <mike.miller@hp.com>

Add the support to fire up on any HP RAID class device that has a valid cciss
signature.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Acked-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/block/cciss.c |   30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff -puN drivers/block/cciss.c~cciss-reference-driver-support drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-reference-driver-support
+++ a/drivers/block/cciss.c
@@ -83,6 +83,8 @@ static const struct pci_device_id cciss_
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSD,     0x103C, 0x3214},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSD,     0x103C, 0x3215},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSC,     0x103C, 0x3233},
+	{PCI_VENDOR_ID_HP,     PCI_ANY_ID,	PCI_ANY_ID, PCI_ANY_ID,
+		PCI_CLASS_STORAGE_RAID << 8, 0xffff << 8, 0},
 	{0,}
 };
 
@@ -112,6 +114,7 @@ static struct board_type products[] = {
 	{0x3214103C, "Smart Array E200i", &SA5_access},
 	{0x3215103C, "Smart Array E200i", &SA5_access},
 	{0x3233103C, "Smart Array E500", &SA5_access},
+	{0xFFFF103C, "Unknown Smart Array", &SA5_access},
 };
 
 /* How long to wait (in milliseconds) for board to go into simple mode */
@@ -2960,13 +2963,6 @@ static int cciss_pci_init(ctlr_info_t *c
 			break;
 		}
 	}
-	if (i == ARRAY_SIZE(products)) {
-		printk(KERN_WARNING "cciss: Sorry, I don't know how"
-		       " to access the Smart Array controller %08lx\n",
-		       (unsigned long)board_id);
-		err = -ENODEV;
-		goto err_out_free_res;
-	}
 	if ((readb(&c->cfgtable->Signature[0]) != 'C') ||
 	    (readb(&c->cfgtable->Signature[1]) != 'I') ||
 	    (readb(&c->cfgtable->Signature[2]) != 'S') ||
@@ -2975,6 +2971,26 @@ static int cciss_pci_init(ctlr_info_t *c
 		err = -ENODEV;
 		goto err_out_free_res;
 	}
+	/* We didn't find the controller in our list. We know the
+	 * signature is valid. If it's an HP device let's try to
+	 * bind to the device and fire it up. Otherwise we bail.
+	 */
+	if (i == ARRAY_SIZE(products)) {
+		if (subsystem_vendor_id == PCI_VENDOR_ID_HP) {
+			c->product_name = products[i-1].product_name;
+			c->access = *(products[i-1].access);
+			printk(KERN_WARNING "cciss: This is an unknown "
+				"Smart Array controller.\n"
+				"cciss: Please update to the latest driver "
+				"available from www.hp.com.\n");
+		} else {
+			printk(KERN_WARNING "cciss: Sorry, I don't know how"
+				" to access the Smart Array controller %08lx\n"
+					, (unsigned long)board_id);
+			err = -ENODEV;
+			goto err_out_free_res;
+		}
+	}
 #ifdef CONFIG_X86
 	{
 		/* Need to enable prefetch in the SCSI core for 6400 in x86 */
_

Patches currently in -mm which might be from mike.miller@hp.com are

origin.patch

