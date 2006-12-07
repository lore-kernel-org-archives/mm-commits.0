From: akpm@osdl.org
Subject: - cciss-version-change.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:00:19 -0800
Message-ID: <200612072300.kB7N0J5r029628@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51246 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163718AbWLGXAd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:00:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.miller@hp.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     cciss: version change
has been removed from the -mm tree.  Its filename was
     cciss-version-change.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cciss: version change
From: Mike Miller <mike.miller@hp.com>

Change the cciss version number to 3.6.14 to reflect the following
functionality changes added by the rest of the set.  They include:

Support to fire up on any HP RAID class controller
Increase nr_cmds to 512 for most controllers by adding it to the product table
PCI subsystem ID fix fix was pulled
Disable DMA prefetch for the P600 on IPF platforms
Change from 512 to 2048 sector_size for performance
Fix in cciss_open for consistency
Remove the no longer used revalidate_allvol function
Bug fix for busy configuring
Support for more than 16 logical volumes
Cleanups in cciss_interrupt_mode
Fix for iostats, it's been broken for several kernel releases

Signed-off-by: Mike Miller <mike.miller@hp.com>
Acked-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/block/cciss.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/block/cciss.c~cciss-version-change drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-version-change
+++ a/drivers/block/cciss.c
@@ -47,14 +47,15 @@
 #include <linux/completion.h>
 
 #define CCISS_DRIVER_VERSION(maj,min,submin) ((maj<<16)|(min<<8)|(submin))
-#define DRIVER_NAME "HP CISS Driver (v 3.6.10)"
-#define DRIVER_VERSION CCISS_DRIVER_VERSION(3,6,10)
+#define DRIVER_NAME "HP CISS Driver (v 3.6.14)"
+#define DRIVER_VERSION CCISS_DRIVER_VERSION(3,6,14)
 
 /* Embedded module documentation macros - see modules.h */
 MODULE_AUTHOR("Hewlett-Packard Company");
-MODULE_DESCRIPTION("Driver for HP Controller SA5xxx SA6xxx version 3.6.10");
+MODULE_DESCRIPTION("Driver for HP Controller SA5xxx SA6xxx version 3.6.14");
 MODULE_SUPPORTED_DEVICE("HP SA5i SA5i+ SA532 SA5300 SA5312 SA641 SA642 SA6400"
 			" SA6i P600 P800 P400 P400i E200 E200i E500");
+MODULE_VERSION("3.6.14");
 MODULE_LICENSE("GPL");
 
 #include "cciss_cmd.h"
_

Patches currently in -mm which might be from mike.miller@hp.com are

origin.patch

