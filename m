From: akpm@linux-foundation.org
Subject: - ata-sata_promise-do-not-freeze-ports.patch removed from -mm tree
Date: Wed, 09 May 2007 13:54:31 -0700
Message-ID: <200705092054.l49KsVtX000839@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58723 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756016AbXEIUyn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 16:54:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, htejun@gmail.com, jgarzik@pobox.com, mikpe@it.uu.se, mm-commits@vger.kernel.org


The patch titled
     ATA: sata_promise, do not freeze ports
has been removed from the -mm tree.  Its filename was
     ata-sata_promise-do-not-freeze-ports.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
Subject: ATA: sata_promise, do not freeze ports
From: Jiri Slaby <jirislaby@gmail.com>
revert return 1 thing in the error isr, that causes port freezing, so that the
system is unusable when exception is thrown.

See http://lkml.org/lkml/2007/4/30/268

Cc: Jeff Garzik <jgarzik@pobox.com>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/sata_promise.c |    4 +---
 1 files changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/ata/sata_promise.c~ata-sata_promise-do-not-freeze-ports drivers/ata/sata_promise.c
--- a/drivers/ata/sata_promise.c~ata-sata_promise-do-not-freeze-ports
+++ a/drivers/ata/sata_promise.c
@@ -668,10 +668,8 @@ static inline unsigned int pdc_host_intr
 	else
 		err_mask &= ~PDC2_ERR_MASK;
 	port_status = readl(port_mmio + PDC_GLOBAL_CTL);
-	if (unlikely(port_status & err_mask)) {
+	if (unlikely(port_status & err_mask))
 		pdc_error_intr(ap, qc, port_status, err_mask);
-		return 1;
-	}
 
 	switch (qc->tf.protocol) {
 	case ATA_PROT_DMA:
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
vmstat-use-our-own-timer-events.patch
git-dvb.patch
cinergyt2-fix-file-release-handler.patch
ata-sata_promise-do-not-freeze-ports.patch
auerswald-fix-file-release-handler.patch
shrink_slab-handle-bad-shrinkers.patch
