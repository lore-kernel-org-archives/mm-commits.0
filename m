From: akpm@linux-foundation.org
Subject: - mpt-fusion-handle-mpt_resume-failure-while-resuming.patch removed from -mm tree
Date: Thu, 22 Mar 2007 12:09:38 -0800
Message-ID: <200703222009.l2MK9cBu029156@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48893 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbXCVUJr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Mar 2007 16:09:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dmonakhov@openvz.org, Eric.Moore@lsil.com, James.Bottomley@steeleye.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     MPT fusion: handle mpt_resume() failure while resuming
has been removed from the -mm tree.  Its filename was
     mpt-fusion-handle-mpt_resume-failure-while-resuming.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: MPT fusion: handle mpt_resume() failure while resuming
From: Dmitriy Monakhov <dmonakhov@openvz.org>

Since mpt-fusion-handle-pci-layer-error-on-resume.patch function
mpt_resume() can return error code.

Signed-off-by: Monakhov Dmitriy <dmonakhov@openvz.org>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptscsih.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/message/fusion/mptscsih.c~mpt-fusion-handle-mpt_resume-failure-while-resuming drivers/message/fusion/mptscsih.c
--- a/drivers/message/fusion/mptscsih.c~mpt-fusion-handle-mpt_resume-failure-while-resuming
+++ a/drivers/message/fusion/mptscsih.c
@@ -1191,8 +1191,11 @@ mptscsih_resume(struct pci_dev *pdev)
 	MPT_ADAPTER 		*ioc = pci_get_drvdata(pdev);
 	struct Scsi_Host 	*host = ioc->sh;
 	MPT_SCSI_HOST		*hd;
+	int ret;
 
-	mpt_resume(pdev);
+	ret = mpt_resume(pdev);
+	if (ret)
+		return  ret;
 
 	if(!host)
 		return 0;
_

Patches currently in -mm which might be from dmonakhov@openvz.org are

git-libata-all.patch
git-netdev-all.patch
mpt-fusion-handle-mpt_resume-failure-while-resuming.patch
mm-move-common-segment-checks-to-separate-helper-function-v7.patch
mm-move-common-segment-checks-to-separate-helper-function-v7-tidy.patch
freevxfs-possible-null-pointer-dereference-fix.patch
reiserfs-possible-null-pointer-dereference-during-resize.patch
irq-add-__must_check-to-request_irq.patch
ext3-dirindex-error-pointer-issues.patch
ext3-dirindex-error-pointer-issues-fix.patch
floppy-handle-device_create_file-failure-while-init.patch
splice-partial-write-handling-fix.patch
udf-possible-null-pointer-dereference-while-load_partition.patch
