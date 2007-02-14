From: akpm@linux-foundation.org
Subject: + small-irq-management-simplification.patch added to -mm tree
Date: Wed, 14 Feb 2007 15:26:35 -0800
Message-ID: <200702142326.l1ENQZTN012664@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50681 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365AbXBNX0x (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 18:26:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbeulich@novell.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     small irq management simplification
has been added to the -mm tree.  Its filename is
     small-irq-management-simplification.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 2 insertions(+), 4 deletions(-)

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
broken-config_compat_vdso-on-i386.patch
x86-fatal-kernel-faults-should-update-thread-struct.patch
i386-adjustments-to-page-table-dump-during-oops-v3.patch
small-irq-management-simplification.patch
x86-mtrr-range-check-correction.patch
x86-consolidate-smp_send_stop.patch
