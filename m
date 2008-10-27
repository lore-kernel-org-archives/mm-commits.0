From: akpm@linux-foundation.org
Subject: + cciss-new-hardware-support.patch added to -mm tree
Date: Sun, 26 Oct 2008 23:43:00 -0700
Message-ID: <200810270643.m9R6h0lP026862@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33861 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751568AbYJ0Gn7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Oct 2008 02:43:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mike.miller@hp.com, jens.axboe@oracle.com


The patch titled
     cciss: new hardware support
has been added to the -mm tree.  Its filename is
     cciss-new-hardware-support.patch

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
Subject: cciss: new hardware support
From: Mike Miller <mike.miller@hp.com>

Add support for 2 new SAS/SATA controllers.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cciss.txt |    2 ++
 drivers/block/cciss.c   |    4 ++++
 2 files changed, 6 insertions(+)

diff -puN Documentation/cciss.txt~cciss-new-hardware-support Documentation/cciss.txt
--- a/Documentation/cciss.txt~cciss-new-hardware-support
+++ a/Documentation/cciss.txt
@@ -26,6 +26,8 @@ This driver is known to work with the fo
 	* SA P410i
 	* SA P411
 	* SA P812
+	* SA P712m
+	* SA P711m
 
 Detecting drive failures:
 -------------------------
diff -puN drivers/block/cciss.c~cciss-new-hardware-support drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-new-hardware-support
+++ a/drivers/block/cciss.c
@@ -96,6 +96,8 @@ static const struct pci_device_id cciss_
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3245},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3247},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3249},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x324A},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x324B},
 	{PCI_VENDOR_ID_HP,     PCI_ANY_ID,	PCI_ANY_ID, PCI_ANY_ID,
 		PCI_CLASS_STORAGE_RAID << 8, 0xffff << 8, 0},
 	{0,}
@@ -133,6 +135,8 @@ static struct board_type products[] = {
 	{0x3245103C, "Smart Array P410i", &SA5_access},
 	{0x3247103C, "Smart Array P411", &SA5_access},
 	{0x3249103C, "Smart Array P812", &SA5_access},
+	{0x324A103C, "Smart Array P712m", &SA5_access},
+	{0x324B103C, "Smart Array P711m", &SA5_access},
 	{0xFFFF103C, "Unknown Smart Array", &SA5_access},
 };
 
_

Patches currently in -mm which might be from mike.miller@hp.com are

cciss-fix-regression-firmware-not-displayed-in-procfs-again-and-again.patch
cciss-new-hardware-support.patch

