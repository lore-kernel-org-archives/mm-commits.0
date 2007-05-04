From: akpm@linux-foundation.org
Subject: + drivers-scsi-aic7xxx_oldc-remove-redundant-gfp_atomic-from-kmalloc.patch added to -mm tree
Date: Fri, 04 May 2007 13:49:43 -0700
Message-ID: <200705042049.l44Knh6Z013823@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42368 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031562AbXEDUts (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2007 16:49:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ssatyam@cse.iitk.ac.in


The patch titled
     drivers/scsi/aic7xxx_old.c: remove redundant GFP_ATOMIC from kmalloc
has been added to the -mm tree.  Its filename is
     drivers-scsi-aic7xxx_oldc-remove-redundant-gfp_atomic-from-kmalloc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/scsi/aic7xxx_old.c: remove redundant GFP_ATOMIC from kmalloc
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>

drivers/scsi/aic7xxx_old.c:aic7xxx_slave_alloc() unnecessarily passes
GFP_ATOMIC (along with GFP_KERNEL) to kmalloc() from a context that is not
atomic. Remove the pointless GFP_ATOMIC.

Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aic7xxx_old.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/aic7xxx_old.c~drivers-scsi-aic7xxx_oldc-remove-redundant-gfp_atomic-from-kmalloc drivers/scsi/aic7xxx_old.c
--- a/drivers/scsi/aic7xxx_old.c~drivers-scsi-aic7xxx_oldc-remove-redundant-gfp_atomic-from-kmalloc
+++ a/drivers/scsi/aic7xxx_old.c
@@ -6581,7 +6581,7 @@ aic7xxx_slave_alloc(struct scsi_device *
   struct aic7xxx_host *p = (struct aic7xxx_host *)SDptr->host->hostdata;
   struct aic_dev_data *aic_dev;
 
-  aic_dev = kmalloc(sizeof(struct aic_dev_data), GFP_ATOMIC | GFP_KERNEL);
+  aic_dev = kmalloc(sizeof(struct aic_dev_data), GFP_KERNEL);
   if(!aic_dev)
     return 1;
   /*
_

Patches currently in -mm which might be from ssatyam@cse.iitk.ac.in are

drivers-message-i2o-devicec-remove-redundant-gfp_atomic-from-kmalloc.patch
drivers-scsi-aic7xxx_oldc-remove-redundant-gfp_atomic-from-kmalloc.patch
