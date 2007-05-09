From: akpm@linux-foundation.org
Subject: - kernel-irq-procc-unprotected-iteration-over-the-irq-action-list-in-name_unique.patch removed from -mm tree
Date: Tue, 08 May 2007 19:47:48 -0700
Message-ID: <200705090247.l492lmNt009019@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49515 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032095AbXEICsB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:48:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dmitry.adamushko@gmail.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     kernel/irq/proc.c: unprotected iteration over the IRQ action list in name_unique()
has been removed from the -mm tree.  Its filename was
     kernel-irq-procc-unprotected-iteration-over-the-irq-action-list-in-name_unique.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kernel/irq/proc.c: unprotected iteration over the IRQ action list in name_unique()
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>

setup_irq() releases a desc->lock before calling register_handler_proc(), so
the iteration over the IRQ action list is not protected.

(akpm: the check itself is still racy, but at least it probably won't oops
now).

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/proc.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff -puN kernel/irq/proc.c~kernel-irq-procc-unprotected-iteration-over-the-irq-action-list-in-name_unique kernel/irq/proc.c
--- a/kernel/irq/proc.c~kernel-irq-procc-unprotected-iteration-over-the-irq-action-list-in-name_unique
+++ a/kernel/irq/proc.c
@@ -66,12 +66,19 @@ static int name_unique(unsigned int irq,
 {
 	struct irq_desc *desc = irq_desc + irq;
 	struct irqaction *action;
+	unsigned long flags;
+	int ret = 1;
 
-	for (action = desc->action ; action; action = action->next)
+	spin_lock_irqsave(&desc->lock, flags);
+	for (action = desc->action ; action; action = action->next) {
 		if ((action != new_action) && action->name &&
-				!strcmp(new_action->name, action->name))
-			return 0;
-	return 1;
+				!strcmp(new_action->name, action->name)) {
+			ret = 0;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&desc->lock, flags);
+	return ret;
 }
 
 void register_handler_proc(unsigned int irq, struct irqaction *action)
_

Patches currently in -mm which might be from dmitry.adamushko@gmail.com are

origin.patch
