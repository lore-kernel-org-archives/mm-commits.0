From: akpm@linux-foundation.org
Subject: + uml-fix-confusion-irq-early-reenabling.patch added to -mm tree
Date: Mon, 05 Mar 2007 20:26:35 -0800
Message-ID: <200703060426.l264QZXW011754@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50209 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933946AbXCFE0j (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 23:26:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: blaisorblade@yahoo.it, jdike@addtoit.com


The patch titled
     um: fix confusion irq early reenabling
has been added to the -mm tree.  Its filename is
     uml-fix-confusion-irq-early-reenabling.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: um: fix confusion irq early reenabling
From: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>

Fix confusion about call context - comments and code are inconsistent and
plain wrong, my fault.

Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Cc: Jeff Dike <jdike@addtoit.com>
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
x86_64-fix-2618-regression-ptrace_oldsetoptions-should-be-accepted.patch
uml-hostfs-fix-double-free.patch
uml-hostfs-make-hostfs=-option-work-as-a-jail-as-intended.patch
uml-fix-a-memory-leak-in-the-multicast-driver.patch
uml-remove-dead-code-about-os_usr1_signal-and-os_usr1_process.patch
uml-mark-both-consoles-as-con_anytime.patch
uml-fix-confusion-irq-early-reenabling.patch
uml-activate_fd-return-enomem-only-when-appropriate.patch
uml-fix-errno-usage.patch
uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-fix-prototypes.patch
git-gccbug.patch
