From: akpm@linux-foundation.org
Subject: + mips-qemu-network-work-again.patch added to -mm tree
Date: Mon, 30 Jul 2007 17:00:30 -0700
Message-ID: <200707310000.l6V00ULR005210@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58816 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936275AbXGaABI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 20:01:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kyungmin.park@samsung.com, mingo@elte.hu, ralf@linux-mips.org


The patch titled
     mips: qemu network work again
has been added to the -mm tree.  Its filename is
     mips-qemu-network-work-again.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mips: qemu network work again
From: "Kyungmin Park" <kyungmin.park@samsung.com>

After kernel 2.6.21, the qemu of mips with nfsroot is not working.

There are too much WATCHDOG timeout.

I try to find what makes it not working and I found it.  After Ingo
Monlar's patch "[PATCH] genirq: do not mask interrupts by default" [1],
it's not working.  To solve this, we also have to register the IRQ disable
field in MIPS, as x86 does.

1. http://www.uwsg.iu.edu/hypermail/linux/kernel/0701.3/1892.html

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/i8259.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN arch/mips/kernel/i8259.c~mips-qemu-network-work-again arch/mips/kernel/i8259.c
--- a/arch/mips/kernel/i8259.c~mips-qemu-network-work-again
+++ a/arch/mips/kernel/i8259.c
@@ -36,6 +36,7 @@ void mask_and_ack_8259A(unsigned int);
 static struct irq_chip i8259A_chip = {
 	.name		= "XT-PIC",
 	.mask		= disable_8259A_irq,
+	.disable	= disable_8259A_irq,
 	.unmask		= enable_8259A_irq,
 	.mask_ack	= mask_and_ack_8259A,
 };
_

Patches currently in -mm which might be from kyungmin.park@samsung.com are

mips-qemu-network-work-again.patch
git-mtd.patch
