From: akpm@linux-foundation.org
Subject: - sata_promise-fix-20619-new-eh-merge-error.patch removed from -mm tree
Date: Wed, 28 Feb 2007 15:52:09 -0800
Message-ID: <200702282352.l1SNq9j0030970@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48204 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932605AbXB1XwN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 18:52:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mikpe@it.uu.se, mm-commits@vger.kernel.org


The patch titled
     sata_promise: fix 20619 new EH merge error
has been removed from the -mm tree.  Its filename was
     sata_promise-fix-20619-new-eh-merge-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sata_promise: fix 20619 new EH merge error
From: Mikael Pettersson <mikpe@it.uu.se>

When I merged my 20619 new EH conversion with #libata-upstream I had to
manually resolve a conflict, and inadvertently lost pdc_pata_ops'
->post_internal_cmd binding.  Corrected by this patch.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/sata_promise.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/ata/sata_promise.c~sata_promise-fix-20619-new-eh-merge-error drivers/ata/sata_promise.c
--- a/drivers/ata/sata_promise.c~sata_promise-fix-20619-new-eh-merge-error
+++ a/drivers/ata/sata_promise.c
@@ -218,6 +218,7 @@ static const struct ata_port_operations 
 	.freeze			= pdc_freeze,
 	.thaw			= pdc_thaw,
 	.error_handler		= pdc_error_handler,
+	.post_internal_cmd	= pdc_post_internal_cmd,
 	.data_xfer		= ata_data_xfer,
 	.irq_handler		= pdc_interrupt,
 	.irq_clear		= pdc_irq_clear,
_

Patches currently in -mm which might be from mikpe@it.uu.se are
