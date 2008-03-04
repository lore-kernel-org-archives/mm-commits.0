From: akpm@linux-foundation.org
Subject: + arcmsr-modify-the-type-of-element-of-messageunit_b.patch added to -mm tree
Date: Tue, 04 Mar 2008 01:56:52 -0800
Message-ID: <200803040956.m249uquT002315@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46658 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758046AbYCDJ47 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2008 04:56:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nick.cheng@areca.com.tw, James.Bottomley@HansenPartnership.com, erich@areca.com.tw


The patch titled
     arcmsr: modify the type of element of MessageUnit_B
has been added to the -mm tree.  Its filename is
     arcmsr-modify-the-type-of-element-of-messageunit_b.patch

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

arcmsr-modify-the-type-of-element-of-messageunit_b.patch
scsi-arcmsr-update-driver-version.patch

