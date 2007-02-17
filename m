From: akpm@linux-foundation.org
Subject: - small-irq-management-simplification.patch removed from -mm tree
Date: Fri, 16 Feb 2007 23:16:01 -0800
Message-ID: <200702170716.l1H7G184021672@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51105 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946486AbXBQHQV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 02:16:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbeulich@novell.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     small irq management simplification
has been removed from the -mm tree.  Its filename was
     small-irq-management-simplification.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: small irq management simplification
From: "Jan Beulich" <jbeulich@novell.com>

Use mask_ack_irq() where possible.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/chip.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN kernel/irq/chip.c~small-irq-management-simplification kernel/irq/chip.c
--- a/kernel/irq/chip.c~small-irq-management-simplification
+++ a/kernel/irq/chip.c
@@ -565,10 +565,8 @@ __set_irq_handler(unsigned int irq, irq_
 
 	/* Uninstall? */
 	if (handle == handle_bad_irq) {
-		if (desc->chip != &no_irq_chip) {
-			desc->chip->mask(irq);
-			desc->chip->ack(irq);
-		}
+		if (desc->chip != &no_irq_chip)
+			mask_ack_irq(desc, irq);
 		desc->status |= IRQ_DISABLED;
 		desc->depth = 1;
 	}
_

Patches currently in -mm which might be from jbeulich@novell.com are

origin.patch
adjust-legacy-ide-resource-setting-v2.patch
i386-adjustments-to-page-table-dump-during-oops-v3.patch
i386-adjustments-to-page-table-dump-during-oops-v4.patch
x86-mtrr-range-check-correction.patch
x86-consolidate-smp_send_stop.patch
fix-i386-and-x86_64-fault-information-pollution.patch
