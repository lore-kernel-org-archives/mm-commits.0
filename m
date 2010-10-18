From: akpm@linux-foundation.org
Subject: + cciss-fix-pci-ids-for-new-smart-array-controllers.patch added to -mm tree
Date: Mon, 18 Oct 2010 12:55:53 -0700
Message-ID: <201010181955.o9IJtrGK030852@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41181 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933123Ab0JRTz4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Oct 2010 15:55:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mike.miller@hp.com, axboe@kernel.dk


The patch titled
     cciss: fix PCI IDs for new Smart Array controllers
has been added to the -mm tree.  Its filename is
     cciss-fix-pci-ids-for-new-smart-array-controllers.patch

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
Subject: cciss: fix PCI IDs for new Smart Array controllers
From: Mike Miller <mike.miller@hp.com>

Fix the botched up PCI IDs of new controllers.  Please consider this patch
for inclusion.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c   |   22 ++++++++++++----------
 include/linux/pci_ids.h |    1 +
 2 files changed, 13 insertions(+), 10 deletions(-)

diff -puN drivers/block/cciss.c~cciss-fix-pci-ids-for-new-smart-array-controllers drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-fix-pci-ids-for-new-smart-array-controllers
+++ a/drivers/block/cciss.c
@@ -105,11 +105,12 @@ static const struct pci_device_id cciss_
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3249},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x324A},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x324B},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3250},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3251},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3252},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3253},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3254},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3350},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3351},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3352},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3353},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3354},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3355},
 	{0,}
 };
 
@@ -149,11 +150,12 @@ static struct board_type products[] = {
 	{0x3249103C, "Smart Array P812", &SA5_access},
 	{0x324A103C, "Smart Array P712m", &SA5_access},
 	{0x324B103C, "Smart Array P711m", &SA5_access},
-	{0x3250103C, "Smart Array", &SA5_access},
-	{0x3251103C, "Smart Array", &SA5_access},
-	{0x3252103C, "Smart Array", &SA5_access},
-	{0x3253103C, "Smart Array", &SA5_access},
-	{0x3254103C, "Smart Array", &SA5_access},
+	{0x3350103C, "Smart Array", &SA5_access},
+	{0x3351103C, "Smart Array", &SA5_access},
+	{0x3352103C, "Smart Array", &SA5_access},
+	{0x3353103C, "Smart Array", &SA5_access},
+	{0x3354103C, "Smart Array", &SA5_access},
+	{0x3355103C, "Smart Array", &SA5_access},
 };
 
 /* How long to wait (in milliseconds) for board to go into simple mode */
diff -puN include/linux/pci_ids.h~cciss-fix-pci-ids-for-new-smart-array-controllers include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~cciss-fix-pci-ids-for-new-smart-array-controllers
+++ a/include/linux/pci_ids.h
@@ -743,6 +743,7 @@
 #define PCI_DEVICE_ID_HP_CISSC		0x3230
 #define PCI_DEVICE_ID_HP_CISSD		0x3238
 #define PCI_DEVICE_ID_HP_CISSE		0x323a
+#define PCI_DEVICE_ID_HP_CISSF		0x323b
 #define PCI_DEVICE_ID_HP_ZX2_IOC	0x4031
 
 #define PCI_VENDOR_ID_PCTECH		0x1042
_

Patches currently in -mm which might be from mike.miller@hp.com are

cciss-fix-pci-ids-for-new-smart-array-controllers.patch

