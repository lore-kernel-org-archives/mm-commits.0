From: akpm@linux-foundation.org
Subject: + cciss-new-controller-support-and-bump-driver-version.patch added to -mm tree
Date: Wed, 02 Jun 2010 12:58:09 -0700
Message-ID: <201006021958.o52Jw9uu013733@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59656 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932493Ab0FBT6V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jun 2010 15:58:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mike.miller@hp.com, jens.axboe@oracle.com, scameron@beardog.cce.hp.com


The patch titled
     cciss: new controller support and bump driver version
has been added to the -mm tree.  Its filename is
     cciss-new-controller-support-and-bump-driver-version.patch

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
Subject: cciss: new controller support and bump driver version
From: Mike Miller <mike.miller@hp.com>

Add support for new controllers due out next year.  HP must continue to
support new controllers in older distros.  All vendors require support be
upstream.  These controllers support only 16 commands in simple mode but
can support up to 1024 in performant mode.  See patch 5/6/ We have no
marketing names yet.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Cc: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff -puN drivers/block/cciss.c~cciss-new-controller-support-and-bump-driver-version drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-new-controller-support-and-bump-driver-version
+++ a/drivers/block/cciss.c
@@ -56,16 +56,14 @@
 #include <linux/kthread.h>
 
 #define CCISS_DRIVER_VERSION(maj,min,submin) ((maj<<16)|(min<<8)|(submin))
-#define DRIVER_NAME "HP CISS Driver (v 3.6.20)"
-#define DRIVER_VERSION CCISS_DRIVER_VERSION(3, 6, 20)
+#define DRIVER_NAME "HP CISS Driver (v 3.6.26)"
+#define DRIVER_VERSION CCISS_DRIVER_VERSION(3, 6, 26)
 
 /* Embedded module documentation macros - see modules.h */
 MODULE_AUTHOR("Hewlett-Packard Company");
 MODULE_DESCRIPTION("Driver for HP Smart Array Controllers");
-MODULE_SUPPORTED_DEVICE("HP SA5i SA5i+ SA532 SA5300 SA5312 SA641 SA642 SA6400"
-			" SA6i P600 P800 P400 P400i E200 E200i E500 P700m"
-			" Smart Array G2 Series SAS/SATA Controllers");
-MODULE_VERSION("3.6.20");
+MODULE_SUPPORTED_DEVICE("HP Smart Array Controllers");
+MODULE_VERSION("3.6.26");
 MODULE_LICENSE("GPL");
 
 static int cciss_allow_hpsa;
@@ -107,6 +105,11 @@ static const struct pci_device_id cciss_
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3249},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x324A},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x324B},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3250},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3251},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3252},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3253},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3254},
 	{0,}
 };
 
@@ -146,6 +149,11 @@ static struct board_type products[] = {
 	{0x3249103C, "Smart Array P812", &SA5_access},
 	{0x324A103C, "Smart Array P712m", &SA5_access},
 	{0x324B103C, "Smart Array P711m", &SA5_access},
+	{0x3250103C, "Smart Array", &SA5_access},
+	{0x3251103C, "Smart Array", &SA5_access},
+	{0x3252103C, "Smart Array", &SA5_access},
+	{0x3253103C, "Smart Array", &SA5_access},
+	{0x3254103C, "Smart Array", &SA5_access},
 };
 
 /* How long to wait (in milliseconds) for board to go into simple mode */
_

Patches currently in -mm which might be from mike.miller@hp.com are

cciss-enqueue-and-submit-io.patch
cciss-clean-up-interrupt-handler.patch
cciss-check-for-msi-in-interrupt_not_for_us.patch
cciss-make-interrupt-access-methods-return-type-bool.patch
cciss-add-performant-mode-support-for-stars-sirius.patch
cciss-new-controller-support-and-bump-driver-version.patch

