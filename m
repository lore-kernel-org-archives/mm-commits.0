From: akpm@linux-foundation.org
Subject: + drivers-scsi-ncr_d700c-fix-irq-handler-return-type.patch added to -mm tree
Date: Thu, 23 Apr 2009 13:24:53 -0700
Message-ID: <200904232024.n3NKOr9O023246@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50282 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753187AbZDWU1M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Apr 2009 16:27:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: helight.xu@gmail.com, James.Bottomley@HansenPartnership.com


The patch titled
     drivers/scsi/NCR_D700.c: fix IRQ handler return type
has been added to the -mm tree.  Its filename is
     drivers-scsi-ncr_d700c-fix-irq-handler-return-type.patch

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
Subject: drivers/scsi/NCR_D700.c: fix IRQ handler return type
From: Zhenwen Xu <helight.xu@gmail.com>

drivers/scsi/NCR_D700.c: In function `NCR_D700_probe':
drivers/scsi/NCR_D700.c:322: warning: passing argument 2 of `request_irq' from incompatible pointer type
drivers/scsi/NCR_D700.c:322: warning: passing argument 2 of `request_irq' from incompatible pointer type
drivers/scsi/NCR_D700.c:322: warning: passing argument 2 of `request_irq' from incompatible pointer type

Signed-off-by: Zhenwen Xu <helight.xu@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/NCR_D700.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/NCR_D700.c~drivers-scsi-ncr_d700c-fix-irq-handler-return-type drivers/scsi/NCR_D700.c
--- a/drivers/scsi/NCR_D700.c~drivers-scsi-ncr_d700c-fix-irq-handler-return-type
+++ a/drivers/scsi/NCR_D700.c
@@ -224,7 +224,7 @@ NCR_D700_probe_one(struct NCR_D700_priva
 	return ret;
 }
 
-static int
+static irqreturn_t
 NCR_D700_intr(int irq, void *data)
 {
 	struct NCR_D700_private *p = (struct NCR_D700_private *)data;
_

Patches currently in -mm which might be from helight.xu@gmail.com are

drivers-infiniband-hw-nes-nes_cmc-fix-unused-var-warning.patch
drivers-mtd-nand-cafe_nandc-fix-irq-handler-return-type.patch
drivers-pci-hotplug-ibmphp_corec-fix-warning-due-to-missing-module_exit.patch
drivers-scsi-ncr_d700c-fix-irq-handler-return-type.patch

