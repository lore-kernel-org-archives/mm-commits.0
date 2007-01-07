From: akpm@osdl.org
Subject: - start_kernel-test-if-irqs-got-enabled-early-barf-and-disable-them-again.patch removed from -mm tree
Date: Sat, 06 Jan 2007 23:58:02 -0800
Message-ID: <200701070758.l077w2GB012927@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40694 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932426AbXAGH6F (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 7 Jan 2007 02:58:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ard@telegraafnet.nl, mm-commits@vger.kernel.org


The patch titled
     start_kernel: test if irq's got enabled early, barf, and disable them again
has been removed from the -mm tree.  Its filename was
     start_kernel-test-if-irqs-got-enabled-early-barf-and-disable-them-again.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: start_kernel: test if irq's got enabled early, barf, and disable them again
From: Ard van Breemen <ard@telegraafnet.nl>

The calls made by parse_parms to other initialization code might enable
interrupts again way too early.

Having interrupts on this early can make systems PANIC when they initialize
the IRQ controllers (which happens later in the code).  This patch detects
that irq's are enabled again, barfs about it and disables them again as a
safety net.

[akpm@osdl.org: cleanups]
Signed-off-by: Ard van Breemen <ard@telegraafnet.nl>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 init/main.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN init/main.c~start_kernel-test-if-irqs-got-enabled-early-barf-and-disable-them-again init/main.c
--- a/init/main.c~start_kernel-test-if-irqs-got-enabled-early-barf-and-disable-them-again
+++ a/init/main.c
@@ -538,6 +538,11 @@ asmlinkage void __init start_kernel(void
 	parse_args("Booting kernel", command_line, __start___param,
 		   __stop___param - __start___param,
 		   &unknown_bootoption);
+	if (!irqs_disabled()) {
+		printk(KERN_WARNING "start_kernel(): bug: interrupts were "
+				"enabled *very* early, fixing it\n");
+		local_irq_disable();
+	}
 	sort_main_extable();
 	trap_init();
 	rcu_init();
_

Patches currently in -mm which might be from ard@telegraafnet.nl are

pci-prevent-down_read-when-pci_devices-is-empty.patch
