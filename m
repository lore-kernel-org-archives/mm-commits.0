From: akpm@linux-foundation.org
Subject: - kexec-avoid-migration-of-already-disabled-irqs-ia64.patch removed from -mm tree
Date: Mon, 05 Feb 2007 01:25:14 -0800
Message-ID: <200702050925.l159PEVb016426@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37334 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142AbXBEJZd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Feb 2007 04:25:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: magnus@valinux.co.jp, horms@verge.net.au, jlan@sgi.com, nanhai.zou@intel.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     kexec: Avoid migration of already disabled irqs (ia64)
has been removed from the -mm tree.  Its filename was
     kexec-avoid-migration-of-already-disabled-irqs-ia64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kexec: Avoid migration of already disabled irqs (ia64)
From: Magnus Damm <magnus@valinux.co.jp>

This patch fixes up ia64 kexec support for HP rx2620 hardware.  It does
this by skipping migration of already disabled irqs.  This is most likely a
problem on other ia64 platforms as well, but I've only been able to
reproduce it on one machine so far.

The full story is that handle_bad_irq() gets invoked before starting the
new kernel without this patch.  This seems to happen when fixup_irqs()
calls generic_handle_irq() on already migrated (and disabled) irqs.  So by
avoiding migration of disabled irqs we stay away of handle_bad_irq().

The code has been tested on three different ia64 machines, all with good
results.  It is possible to trigger the same bug by offlining a processor
using echo 0 > /sys/devices/system/cpu/cpuX/online.

More detailed information is available in the following mail thread:
http://lists.osdl.org/pipermail/fastboot/2007-January/thread.html#5774

Signed-off-by: Magnus Damm <magnus@valinux.co.jp>
Acked-by: Simon Horman <horms@verge.net.au>
Acked-by: Zou, Nanhai <nanhai.zou@intel.com>
Acked-by: Jay Lan <jlan@sgi.com>
Acked-by: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/irq.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN arch/ia64/kernel/irq.c~kexec-avoid-migration-of-already-disabled-irqs-ia64 arch/ia64/kernel/irq.c
--- a/arch/ia64/kernel/irq.c~kexec-avoid-migration-of-already-disabled-irqs-ia64
+++ a/arch/ia64/kernel/irq.c
@@ -122,6 +122,9 @@ static void migrate_irqs(void)
 	for (irq=0; irq < NR_IRQS; irq++) {
 		desc = irq_desc + irq;
 
+		if (desc->status == IRQ_DISABLED)
+			continue;
+
 		/*
 		 * No handling for now.
 		 * TBD: Implement a disable function so we can now
_

Patches currently in -mm which might be from magnus@valinux.co.jp are
