From: akpm@linux-foundation.org
Subject: + cciss-dirty-hack.patch added to -mm tree
Date: Thu, 24 May 2007 13:21:45 -0700
Message-ID: <200705242021.l4OKLkFg001689@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:35462 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752793AbXEXUV5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 May 2007 16:21:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mikem@beardog.cca.cpqcorp.net


The patch titled
     cciss: dirty hack
has been added to the -mm tree.  Its filename is
     cciss-dirty-hack.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cciss: dirty hack
From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>

Not for merging - just to avoid impacting other -mm testing.


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |    2 +-
 drivers/block/cciss.h |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/block/cciss.c~cciss-dirty-hack drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-dirty-hack
+++ a/drivers/block/cciss.c
@@ -3494,7 +3494,7 @@ static void cciss_shutdown(struct pci_de
 	} else {
 		printk(KERN_WARNING "Error flushing cache on controller %d\n", i);
 	}
-	free_irq(hba[i]->intr[2], hba[i]);
+	free_irq(hba[i]->intr[SIMPLE_MODE_INT], hba[i]);
 }
 
 static void __devexit cciss_remove_one(struct pci_dev *pdev)
diff -puN drivers/block/cciss.h~cciss-dirty-hack drivers/block/cciss.h
--- a/drivers/block/cciss.h~cciss-dirty-hack
+++ a/drivers/block/cciss.h
@@ -70,8 +70,8 @@ struct ctlr_info 
 	int 	highest_lun;
 	int	usage_count;  /* number of opens all all minor devices */
 #	define DOORBELL_INT	0
-#	define PERF_MODE_INT	1
-#	define SIMPLE_MODE_INT	2
+#	define PERF_MODE_INT	2
+#	define SIMPLE_MODE_INT	1
 #	define MEMQ_MODE_INT	3
 	unsigned int intr[4];
 	unsigned int msix_vector;
_

Patches currently in -mm which might be from mikem@beardog.cca.cpqcorp.net are

cciss-dirty-hack.patch
