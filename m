From: akpm@linux-foundation.org
Subject: [merged] drivers-scsi-ncr_d700c-fix-irq-handler-return-type.patch removed from -mm tree
Date: Tue, 26 May 2009 12:35:47 -0700
Message-ID: <200905261935.n4QJZlb8006606@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35391 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757168AbZEZTgQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 May 2009 15:36:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: helight.xu@gmail.com, James.Bottomley@HansenPartnership.com, mm-commits@vger.kernel.org


The patch titled
     drivers/scsi/NCR_D700.c: fix IRQ handler return type
has been removed from the -mm tree.  Its filename was
     drivers-scsi-ncr_d700c-fix-irq-handler-return-type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch
drivers-leds-leds-gpioc-fix-a-section-mismatch.patch

