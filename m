From: akpm@linux-foundation.org
Subject: + sata_promise-fix-20619-new-eh-merge-error.patch added to -mm tree
Date: Tue, 27 Feb 2007 12:38:23 -0800
Message-ID: <200702272038.l1RKcRYu027668@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50840 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933092AbXB0Uic (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 15:38:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mikpe@it.uu.se


The patch titled
     sata_promise: fix 20619 new EH merge error
has been added to the -mm tree.  Its filename is
     sata_promise-fix-20619-new-eh-merge-error.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

credits-update-mikpes-email-address.patch
sata_promise-simplify-port-setup.patch
sata_promise-fix-20619-new-eh-merge-error.patch
