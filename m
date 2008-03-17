From: akpm@linux-foundation.org
Subject: - arcmsr-modify-the-type-of-element-of-messageunit_b.patch removed from -mm tree
Date: Mon, 17 Mar 2008 14:00:23 -0700
Message-ID: <200803172100.m2HL0NKv030856@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58059 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753853AbYCQVAr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 17:00:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nick.cheng@areca.com.tw, James.Bottomley@HansenPartnership.com, erich@areca.com.tw, mm-commits@vger.kernel.org


The patch titled
     arcmsr: modify the type of element of MessageUnit_B
has been removed from the -mm tree.  Its filename was
     arcmsr-modify-the-type-of-element-of-messageunit_b.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arcmsr: modify the type of element of MessageUnit_B
From: Nick Cheng <nick.cheng@areca.com.tw>

Modify the element type of MessageUnit_B in arcmsr-1.20.00.15-80227 to keep
off the error while doing iounmap in arcmsr_free_ccb_pool().

Signed-off-by: Nick Cheng <nick.cheng@areca.com.tw>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: erich <erich@areca.com.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/arcmsr/arcmsr.h |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/scsi/arcmsr/arcmsr.h~arcmsr-modify-the-type-of-element-of-messageunit_b drivers/scsi/arcmsr/arcmsr.h
--- a/drivers/scsi/arcmsr/arcmsr.h~arcmsr-modify-the-type-of-element-of-messageunit_b
+++ a/drivers/scsi/arcmsr/arcmsr.h
@@ -341,13 +341,13 @@ struct MessageUnit_B
 	uint32_t	done_qbuffer[ARCMSR_MAX_HBB_POSTQUEUE];
 	uint32_t	postq_index;
 	uint32_t	doneq_index;
-	uint32_t	__iomem *drv2iop_doorbell_reg;
-	uint32_t	__iomem *drv2iop_doorbell_mask_reg;
-	uint32_t	__iomem *iop2drv_doorbell_reg;
-	uint32_t	__iomem *iop2drv_doorbell_mask_reg;
-	uint32_t	__iomem *msgcode_rwbuffer_reg;
-	uint32_t	__iomem *ioctl_wbuffer_reg;
-	uint32_t	__iomem *ioctl_rbuffer_reg;
+	void		__iomem *drv2iop_doorbell_reg;
+	void		__iomem *drv2iop_doorbell_mask_reg;
+	void		__iomem *iop2drv_doorbell_reg;
+	void		__iomem *iop2drv_doorbell_mask_reg;
+	void		__iomem *msgcode_rwbuffer_reg;
+	void		__iomem *ioctl_wbuffer_reg;
+	void		__iomem *ioctl_rbuffer_reg;
 };
 
 /*
_

Patches currently in -mm which might be from nick.cheng@areca.com.tw are

git-scsi-rc-fixes.patch

