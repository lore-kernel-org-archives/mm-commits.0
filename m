From: akpm@linux-foundation.org
Subject: + pci-avoid-potential-null-pointer-dereference-in-pci_scan_bridge.patch added to -mm tree
Date: Thu, 27 Jan 2011 16:41:00 -0800
Message-ID: <201101280041.p0S0f0to009236@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56445 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753404Ab1A1AlG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Jan 2011 19:41:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jj@chaosbits.net, jbarnes@virtuousgeek.org


The patch titled
     pci: avoid potential NULL pointer dereference in pci_scan_bridge()
has been added to the -mm tree.  Its filename is
     pci-avoid-potential-null-pointer-dereference-in-pci_scan_bridge.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
linux-next.patch
x86-numa-add-error-handling-for-bad-cpu-to-node-mappings.patch
audit-always-follow-va_copy-with-va_end.patch
pci-avoid-potential-null-pointer-dereference-in-pci_scan_bridge.patch

