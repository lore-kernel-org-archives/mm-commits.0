From: akpm@linux-foundation.org
Subject: - uml-fix-confusion-irq-early-reenabling.patch removed from -mm tree
Date: Thu, 15 Mar 2007 13:56:07 -0800
Message-ID: <200703152156.l2FLu7gW027522@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42237 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793AbXCOV4J (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 17:56:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: blaisorblade@yahoo.it, jdike@addtoit.com, mm-commits@vger.kernel.org


The patch titled
     um: fix confusion irq early reenabling
has been removed from the -mm tree.  Its filename was
     uml-fix-confusion-irq-early-reenabling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: um: fix confusion irq early reenabling
From: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>

Fix confusion about call context - comments and code are inconsistent and
plain wrong, my fault.

Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Acked-by: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/line.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/um/drivers/line.c~uml-fix-confusion-irq-early-reenabling arch/um/drivers/line.c
--- a/arch/um/drivers/line.c~uml-fix-confusion-irq-early-reenabling
+++ a/arch/um/drivers/line.c
@@ -370,10 +370,10 @@ static irqreturn_t line_write_interrupt(
 	struct tty_struct *tty = line->tty;
 	int err;
 
-	/* Interrupts are enabled here because we registered the interrupt with
+	/* Interrupts are disabled here because we registered the interrupt with
 	 * IRQF_DISABLED (see line_setup_irq).*/
 
-	spin_lock_irq(&line->lock);
+	spin_lock(&line->lock);
 	err = flush_buffer(line);
 	if (err == 0) {
 		return IRQ_NONE;
@@ -381,7 +381,7 @@ static irqreturn_t line_write_interrupt(
 		line->head = line->buffer;
 		line->tail = line->buffer;
 	}
-	spin_unlock_irq(&line->lock);
+	spin_unlock(&line->lock);
 
 	if(tty == NULL)
 		return IRQ_NONE;
_

Patches currently in -mm which might be from blaisorblade@yahoo.it are

origin.patch
uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-mark-tt-mode-code-for-future-removal.patch
uml-print-coredump-limits.patch
uml-handle-block-device-hotplug-errors.patch
uml-driver-formatting-fixes.patch
uml-driver-formatting-fixes-fix.patch
uml-network-interface-hotplug-error-handling.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
uml-fix-prototypes.patch
git-gccbug.patch
