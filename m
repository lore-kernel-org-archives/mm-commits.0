From: akpm@linux-foundation.org
Subject: [merged] pci-avoid-potential-null-pointer-dereference-in-pci_scan_bridge.patch removed from -mm tree
Date: Thu, 10 Feb 2011 12:16:05 -0800
Message-ID: <201102102016.p1AKG5Go016263@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36287 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756877Ab1BJUQK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Feb 2011 15:16:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jj@chaosbits.net, jbarnes@virtuousgeek.org, mm-commits@vger.kernel.org


The patch titled
     pci: avoid potential NULL pointer dereference in pci_scan_bridge()
has been removed from the -mm tree.  Its filename was
     pci-avoid-potential-null-pointer-dereference-in-pci_scan_bridge.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci: avoid potential NULL pointer dereference in pci_scan_bridge()
From: Jesper Juhl <jj@chaosbits.net>

pci_add_new_bus() returns NULL on ENOMEM.

Also remove some trailing whitespace.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/probe.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/pci/probe.c~pci-avoid-potential-null-pointer-dereference-in-pci_scan_bridge drivers/pci/probe.c
--- a/drivers/pci/probe.c~pci-avoid-potential-null-pointer-dereference-in-pci_scan_bridge
+++ a/drivers/pci/probe.c
@@ -764,6 +764,8 @@ int __devinit pci_scan_bridge(struct pci
 		if (pci_find_bus(pci_domain_nr(bus), max+1))
 			goto out;
 		child = pci_add_new_bus(bus, dev, ++max);
+		if (!child)
+			goto out;
 		buses = (buses & 0xff000000)
 		      | ((unsigned int)(child->primary)     <<  0)
 		      | ((unsigned int)(child->secondary)   <<  8)
@@ -777,7 +779,7 @@ int __devinit pci_scan_bridge(struct pci
 			buses &= ~0xff000000;
 			buses |= CARDBUS_LATENCY_TIMER << 24;
 		}
-			
+
 		/*
 		 * We need to blast all three values with a single write.
 		 */
_

Patches currently in -mm which might be from jj@chaosbits.net are

linux-next.patch
x86-numa-add-error-handling-for-bad-cpu-to-node-mappings.patch
audit-always-follow-va_copy-with-va_end.patch

