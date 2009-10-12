From: akpm@linux-foundation.org
Subject: + cciss-add-cciss_allow_hpsa-module-parameter.patch added to -mm tree
Date: Mon, 12 Oct 2009 15:08:07 -0700
Message-ID: <200910122208.n9CM87qC030503@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56597 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933467AbZJLWJn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Oct 2009 18:09:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: scameron@beardog.cce.hp.com, jens.axboe@oracle.com, mike.miller@hp.com


The patch titled
     cciss: add cciss_allow_hpsa module parameter
has been added to the -mm tree.  Its filename is
     cciss-add-cciss_allow_hpsa-module-parameter.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cciss: add cciss_allow_hpsa module parameter
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>

Add cciss_allow_hpsa module parameter.  This parameter causes the cciss
driver to ignore any Smart Array devices known to be supported by the hpsa
driver.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: Mike Miller <mike.miller@hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/block/cciss.c~cciss-add-cciss_allow_hpsa-module-parameter drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-add-cciss_allow_hpsa-module-parameter
+++ a/drivers/block/cciss.c
@@ -68,6 +68,12 @@ MODULE_SUPPORTED_DEVICE("HP SA5i SA5i+ S
 MODULE_VERSION("3.6.20");
 MODULE_LICENSE("GPL");
 
+static int cciss_allow_hpsa;
+module_param(cciss_allow_hpsa, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(cciss_allow_hpsa,
+	"Prevent cciss driver from accessing hardware known to be "
+	" supported by the hpsa driver");
+
 #include "cciss_cmd.h"
 #include "cciss.h"
 #include <linux/cciss_ioctl.h>
@@ -101,8 +107,6 @@ static const struct pci_device_id cciss_
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3249},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x324A},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x324B},
-	{PCI_VENDOR_ID_HP,     PCI_ANY_ID,	PCI_ANY_ID, PCI_ANY_ID,
-		PCI_CLASS_STORAGE_RAID << 8, 0xffff << 8, 0},
 	{0,}
 };
 
@@ -123,8 +127,6 @@ static struct board_type products[] = {
 	{0x409D0E11, "Smart Array 6400 EM", &SA5_access},
 	{0x40910E11, "Smart Array 6i", &SA5_access},
 	{0x3225103C, "Smart Array P600", &SA5_access},
-	{0x3223103C, "Smart Array P800", &SA5_access},
-	{0x3234103C, "Smart Array P400", &SA5_access},
 	{0x3235103C, "Smart Array P400i", &SA5_access},
 	{0x3211103C, "Smart Array E200i", &SA5_access},
 	{0x3212103C, "Smart Array E200", &SA5_access},
@@ -132,6 +134,10 @@ static struct board_type products[] = {
 	{0x3214103C, "Smart Array E200i", &SA5_access},
 	{0x3215103C, "Smart Array E200i", &SA5_access},
 	{0x3237103C, "Smart Array E500", &SA5_access},
+/* controllers below this line are also supported by the hpsa driver. */
+#define HPSA_BOUNDARY 0x3223103C
+	{0x3223103C, "Smart Array P800", &SA5_access},
+	{0x3234103C, "Smart Array P400", &SA5_access},
 	{0x323D103C, "Smart Array P700m", &SA5_access},
 	{0x3241103C, "Smart Array P212", &SA5_access},
 	{0x3243103C, "Smart Array P410", &SA5_access},
@@ -140,7 +146,6 @@ static struct board_type products[] = {
 	{0x3249103C, "Smart Array P812", &SA5_access},
 	{0x324A103C, "Smart Array P712m", &SA5_access},
 	{0x324B103C, "Smart Array P711m", &SA5_access},
-	{0xFFFF103C, "Unknown Smart Array", &SA5_access},
 };
 
 /* How long to wait (in milliseconds) for board to go into simple mode */
@@ -3754,7 +3759,27 @@ static int __devinit cciss_pci_init(ctlr
 	__u64 cfg_offset;
 	__u32 cfg_base_addr;
 	__u64 cfg_base_addr_index;
-	int i, err;
+	int i, prod_index, err;
+
+	subsystem_vendor_id = pdev->subsystem_vendor;
+	subsystem_device_id = pdev->subsystem_device;
+	board_id = (((__u32) (subsystem_device_id << 16) & 0xffff0000) |
+		    subsystem_vendor_id);
+
+	for (i = 0; i < ARRAY_SIZE(products); i++) {
+		/* Stand aside for hpsa driver on request */
+		if (cciss_allow_hpsa && products[i].board_id == HPSA_BOUNDARY)
+			return -ENODEV;
+		if (board_id == products[i].board_id)
+			break;
+	}
+	prod_index = i;
+	if (prod_index == ARRAY_SIZE(products)) {
+		dev_warn(&pdev->dev,
+			"unrecognized board ID: 0x%08lx, ignoring.\n",
+			(unsigned long) board_id);
+		return -ENODEV;
+	}
 
 	/* check to see if controller has been disabled */
 	/* BEFORE trying to enable it */
@@ -3778,11 +3803,6 @@ static int __devinit cciss_pci_init(ctlr
 		return err;
 	}
 
-	subsystem_vendor_id = pdev->subsystem_vendor;
-	subsystem_device_id = pdev->subsystem_device;
-	board_id = (((__u32) (subsystem_device_id << 16) & 0xffff0000) |
-		    subsystem_vendor_id);
-
 #ifdef CCISS_DEBUG
 	printk("command = %x\n", command);
 	printk("irq = %x\n", pdev->irq);
@@ -3868,14 +3888,9 @@ static int __devinit cciss_pci_init(ctlr
 	 * leave a little room for ioctl calls.
 	 */
 	c->max_commands = readl(&(c->cfgtable->CmdsOutMax));
-	for (i = 0; i < ARRAY_SIZE(products); i++) {
-		if (board_id == products[i].board_id) {
-			c->product_name = products[i].product_name;
-			c->access = *(products[i].access);
-			c->nr_cmds = c->max_commands - 4;
-			break;
-		}
-	}
+	c->product_name = products[prod_index].product_name;
+	c->access = *(products[prod_index].access);
+	c->nr_cmds = c->max_commands - 4;
 	if ((readb(&c->cfgtable->Signature[0]) != 'C') ||
 	    (readb(&c->cfgtable->Signature[1]) != 'I') ||
 	    (readb(&c->cfgtable->Signature[2]) != 'S') ||
@@ -3884,27 +3899,6 @@ static int __devinit cciss_pci_init(ctlr
 		err = -ENODEV;
 		goto err_out_free_res;
 	}
-	/* We didn't find the controller in our list. We know the
-	 * signature is valid. If it's an HP device let's try to
-	 * bind to the device and fire it up. Otherwise we bail.
-	 */
-	if (i == ARRAY_SIZE(products)) {
-		if (subsystem_vendor_id == PCI_VENDOR_ID_HP) {
-			c->product_name = products[i-1].product_name;
-			c->access = *(products[i-1].access);
-			c->nr_cmds = c->max_commands - 4;
-			printk(KERN_WARNING "cciss: This is an unknown "
-				"Smart Array controller.\n"
-				"cciss: Please update to the latest driver "
-				"available from www.hp.com.\n");
-		} else {
-			printk(KERN_WARNING "cciss: Sorry, I don't know how"
-				" to access the Smart Array controller %08lx\n"
-					, (unsigned long)board_id);
-			err = -ENODEV;
-			goto err_out_free_res;
-		}
-	}
 #ifdef CONFIG_X86
 	{
 		/* Need to enable prefetch in the SCSI core for 6400 in x86 */
_

Patches currently in -mm which might be from scameron@beardog.cce.hp.com are

scsi-add-hpsa-driver-for-hp-smart-array-controllers.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers-fix-hpsa_allow_any-test-for-vendor-id.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers-fix.patch
cciss-fix-multiple-calls-to-pci_release_regions.patch
cciss-add-cciss_allow_hpsa-module-parameter.patch

