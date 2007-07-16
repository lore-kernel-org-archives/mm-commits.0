From: akpm@linux-foundation.org
Subject: - drivers-scsi-aic7xxx_oldc-remove-redundant-gfp_atomic-from-kmalloc.patch removed from -mm tree
Date: Mon, 16 Jul 2007 14:00:20 -0700
Message-ID: <200707162100.l6GL0KGJ002590@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53027 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755636AbXGPVGW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:06:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ssatyam@cse.iitk.ac.in, mm-commits@vger.kernel.org


The patch titled
     drivers/scsi/aic7xxx_old.c: remove redundant GFP_ATOMIC from kmalloc
has been removed from the -mm tree.  Its filename was
     drivers-scsi-aic7xxx_oldc-remove-redundant-gfp_atomic-from-kmalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -6572,7 +6572,7 @@ aic7xxx_slave_alloc(struct scsi_device *
   struct aic7xxx_host *p = (struct aic7xxx_host *)SDptr->host->hostdata;
   struct aic_dev_data *aic_dev;
 
-  aic_dev = kmalloc(sizeof(struct aic_dev_data), GFP_ATOMIC | GFP_KERNEL);
+  aic_dev = kmalloc(sizeof(struct aic_dev_data), GFP_KERNEL);
   if(!aic_dev)
     return 1;
   /*
_

Patches currently in -mm which might be from ssatyam@cse.iitk.ac.in are

origin.patch
git-ocfs2.patch
