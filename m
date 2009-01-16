From: akpm@linux-foundation.org
Subject: [merged] alpha-nautilus-fix-hang-on-boot.patch removed from -mm tree
Date: Fri, 16 Jan 2009 11:17:39 -0800
Message-ID: <200901161917.n0GJHdDT026241@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38045 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765924AbZAPTVA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 14:21:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ink@jurassic.park.msu.ru, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     alpha: nautilus - fix hang on boot
has been removed from the -mm tree.  Its filename was
     alpha-nautilus-fix-hang-on-boot.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alpha: nautilus - fix hang on boot
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

Recently introduced generic pci_common_swizzle() relies on bus->self
being NULL for the root PCI bus. But on nautilus bus->self points to
the host bridge device, which is necessary as we do a root bus sizing
on this system. As a result, pci_common_swizzle() loops infinitely.
This worked until 2.6.29-rc1 because the alpha-specific swizzle routine
checked for bus->parent == NULL (instead of bus->self).

Fixed by clearing bus->self after bus sizing is done.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/sys_nautilus.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN arch/alpha/kernel/sys_nautilus.c~alpha-nautilus-fix-hang-on-boot arch/alpha/kernel/sys_nautilus.c
--- a/arch/alpha/kernel/sys_nautilus.c~alpha-nautilus-fix-hang-on-boot
+++ a/arch/alpha/kernel/sys_nautilus.c
@@ -245,6 +245,10 @@ nautilus_init_pci(void)
 		IRONGATE0->pci_mem = pci_mem;
 
 	pci_bus_assign_resources(bus);
+
+	/* pci_common_swizzle() relies on bus->self being NULL
+	   for the root bus, so just clear it. */
+	bus->self = NULL;
 	pci_fixup_irqs(alpha_mv.pci_swizzle, alpha_mv.pci_map_irq);
 }
 
_

Patches currently in -mm which might be from ink@jurassic.park.msu.ru are

origin.patch
make-sure-nobodys-leaking-resources.patch

