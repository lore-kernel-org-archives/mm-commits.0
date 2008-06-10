From: akpm@linux-foundation.org
Subject: + cciss-add-new-hardware-support.patch added to -mm tree
Date: Tue, 10 Jun 2008 14:26:26 -0700
Message-ID: <200806102126.m5ALQRSs030226@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48636 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756770AbYFJV2R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Jun 2008 17:28:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mike.miller@hp.com, jens.axboe@oracle.com, stable@kernel.org


The patch titled
     cciss: add new hardware support
has been added to the -mm tree.  Its filename is
     cciss-add-new-hardware-support.patch

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
Subject: cciss: add new hardware support
From: Mike Miller <mike.miller@hp.com>

Add support for the next generation of HP Smart Array SAS/SATA
controllers.  Shipping date is late Fall 2008.

Bump the driver version to 3.6.20 to reflect the new hardware support from
patch 1 of this set.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cciss.txt |    5 +++++
 drivers/block/cciss.c   |   13 ++++++++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff -puN Documentation/cciss.txt~cciss-add-new-hardware-support Documentation/cciss.txt
--- a/Documentation/cciss.txt~cciss-add-new-hardware-support
+++ a/Documentation/cciss.txt
@@ -21,6 +21,11 @@ This driver is known to work with the fo
 	* SA E200
 	* SA E200i
 	* SA E500
+	* SA P212
+	* SA P410
+	* SA P410i
+	* SA P411
+	* SA P812
 
 Detecting drive failures:
 -------------------------
diff -puN drivers/block/cciss.c~cciss-add-new-hardware-support drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-add-new-hardware-support
+++ a/drivers/block/cciss.c
@@ -60,7 +60,8 @@
 MODULE_AUTHOR("Hewlett-Packard Company");
 MODULE_DESCRIPTION("Driver for HP Controller SA5xxx SA6xxx version 3.6.14");
 MODULE_SUPPORTED_DEVICE("HP SA5i SA5i+ SA532 SA5300 SA5312 SA641 SA642 SA6400"
-			" SA6i P600 P800 P400 P400i E200 E200i E500");
+			" SA6i P600 P800 P400 P400i E200 E200i E500 P700m"
+			" Smart Array G2 Series SAS/SATA Controllers");
 MODULE_VERSION("3.6.14");
 MODULE_LICENSE("GPL");
 
@@ -90,6 +91,11 @@ static const struct pci_device_id cciss_
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSD,     0x103C, 0x3215},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSC,     0x103C, 0x3237},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSC,     0x103C, 0x323D},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3241},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3243},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3245},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3247},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3249},
 	{PCI_VENDOR_ID_HP,     PCI_ANY_ID,	PCI_ANY_ID, PCI_ANY_ID,
 		PCI_CLASS_STORAGE_RAID << 8, 0xffff << 8, 0},
 	{0,}
@@ -123,6 +129,11 @@ static struct board_type products[] = {
 	{0x3215103C, "Smart Array E200i", &SA5_access, 120},
 	{0x3237103C, "Smart Array E500", &SA5_access, 512},
 	{0x323D103C, "Smart Array P700m", &SA5_access, 512},
+	{0x3241103C, "Smart Array P212", &SA5_access, 384},
+	{0x3243103C, "Smart Array P410", &SA5_access, 384},
+	{0x3245103C, "Smart Array P410i", &SA5_access, 384},
+	{0x3247103C, "Smart Array P411", &SA5_access, 384},
+	{0x3249103C, "Smart Array P812", &SA5_access, 384},
 	{0xFFFF103C, "Unknown Smart Array", &SA5_access, 120},
 };
 
_

Patches currently in -mm which might be from mike.miller@hp.com are

cciss-add-new-hardware-support.patch
cciss-add-new-hardware-support-fix.patch
cciss-bump-version-to-20-to-reflect-new-hw-support.patch

