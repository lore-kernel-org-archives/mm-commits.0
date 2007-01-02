From: akpm@osdl.org
Subject: + start_kernel-test-if-irqs-got-enabled-early-barf-and-disable-them-again.patch added to -mm tree
Date: Tue, 02 Jan 2007 13:49:33 -0800
Message-ID: <200701022149.l02LnXkJ030882@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:35710 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753646AbXABVto (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 16:49:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ard@telegraafnet.nl


The patch titled
     start_kernel: Test if irq's got enabled early, barf, and disable them again
has been added to the -mm tree.  Its filename is
     start_kernel-test-if-irqs-got-enabled-early-barf-and-disable-them-again.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: start_kernel: Test if irq's got enabled early, barf, and disable them again
From: Ard van Breemen <ard@telegraafnet.nl>

The calls made by parse_parms to other initialization code might enable
interrupts again way too early.

Having interrupts on this early can make systems PANIC when they initialize
the IRQ controllers (which happens later in the code).  This patch detects
that irq's are enabled again, barfs about it and disables them again as a
safety net.

Signed-off-by: Ard van Breemen <ard@telegraafnet.nl>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 init/main.c |    4 ++++
 1 files changed, 4 insertions(+)

diff -puN init/main.c~start_kernel-test-if-irqs-got-enabled-early-barf-and-disable-them-again init/main.c
--- a/init/main.c~start_kernel-test-if-irqs-got-enabled-early-barf-and-disable-them-again
+++ a/init/main.c
@@ -538,6 +538,10 @@ asmlinkage void __init start_kernel(void
 	parse_args("Booting kernel", command_line, __start___param,
 		   __stop___param - __start___param,
 		   &unknown_bootoption);
+	if (!irqs_disabled()) {
+		printk(KERN_WARNING "start_kernel(): bug: interrupts were enabled *very* early, fixing it\n");
+		local_irq_disable();
+	}
 	sort_main_extable();
 	trap_init();
 	rcu_init();
_

Patches currently in -mm which might be from ard@telegraafnet.nl are

start_kernel-test-if-irqs-got-enabled-early-barf-and-disable-them-again.patch
kernelparams-detect-if-and-which-parameter-parsing-enabled-irqs.patch
pci-prevent-down_read-when-pci_devices-is-empty.patch
pci-avoid-taking-pci_bus_sem-early-in-boot.patch
down_write-preserve-local-irqs.patch
