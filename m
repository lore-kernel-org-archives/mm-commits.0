From: akpm@linux-foundation.org
Subject: + mpt-fusion-handle-mpt_resume-failure-while-resuming.patch added to -mm tree
Date: Tue, 27 Feb 2007 12:49:32 -0800
Message-ID: <200702272049.l1RKnanh028052@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51235 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572AbXB0Uts (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 15:49:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmonakhov@openvz.org, Eric.Moore@lsil.com, James.Bottomley@steeleye.com, jeff@garzik.org


The patch titled
     MPT fusion: handle mpt_resume() failure while resuming
has been added to the -mm tree.  Its filename is
     mpt-fusion-handle-mpt_resume-failure-while-resuming.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

ecryptfs-set-o_largefile-when-opening-lower-file.patch
ecryptfs-remove-unnecessary-flush_dcache_page.patch
ecryptfs-no-path_release-after-path_lookup-error.patch
libata-handle-ata_pci_device_do_resume-failure-while-resuming-v2.patch
3c59x-handle-pci_enable_device-failure-while-resuming.patch
mpt-fusion-handle-mpt_resume-failure-while-resuming.patch
freevxfs-possible-null-pointer-dereference-fix.patch
reiserfs-possible-null-pointer-dereference-during-resize.patch
ecryptfs-handles-aop_truncated_page-better.patch
