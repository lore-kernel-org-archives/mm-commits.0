From: akpm@linux-foundation.org
Subject: - sym53c8xx_2-claims-cpqarray-device.patch removed from -mm tree
Date: Wed, 25 Jul 2007 21:23:48 -0700
Message-ID: <200707260423.l6Q4Nmem013735@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54857 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751267AbXGZEYu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 00:24:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: coldwell@redhat.com, willy@debian.org, yaneti@declera.com, mm-commits@vger.kernel.org


The patch titled
     sym53c8xx_2 claims cpqarray device
has been removed from the -mm tree.  Its filename was
     sym53c8xx_2-claims-cpqarray-device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sym53c8xx_2 claims cpqarray device
From: Chip Coldwell <coldwell@redhat.com>

Apropos this thread

http://marc.theaimsgroup.com/?l=linux-scsi&m=115591706804045&w=2

which led to this patch

http://www.kernel.org/git/?p=linux/kernel/git/jejb/scsi-rc-fixes-2.6.git;a=commit;h=b2b3c121076961333977f485f0d54c22121df920

do we not also need the following patch, nine lines lower in the same file?

Signed-off-by: Chip Coldwell <coldwell@redhat.com>
Cc: Matthew Wilcox <willy@debian.org>
Cc: Yanko Kaneti <yaneti@declera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/sym53c8xx_2/sym_glue.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/sym53c8xx_2/sym_glue.c~sym53c8xx_2-claims-cpqarray-device drivers/scsi/sym53c8xx_2/sym_glue.c
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c~sym53c8xx_2-claims-cpqarray-device
+++ a/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -2033,7 +2033,7 @@ static struct pci_device_id sym2_id_tabl
 	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_NCR_53C875,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
 	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_NCR_53C1510,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL }, /* new */
+	  PCI_ANY_ID, PCI_ANY_ID,  PCI_CLASS_STORAGE_SCSI<<8,  0xffff00, 0UL }, /* new */
 	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_53C895A,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
 	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_53C875A,
_

Patches currently in -mm which might be from coldwell@redhat.com are

git-scsi-rc-fixes.patch
