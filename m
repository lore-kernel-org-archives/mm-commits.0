From: akpm@linux-foundation.org
Subject: - powerpc-fix-pci-domain-detection.patch removed from -mm tree
Date: Fri, 05 Oct 2007 12:56:48 -0700
Message-ID: <200710051956.l95Jumjs022398@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41584 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763201AbXJEUB3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 16:01:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, arnd.bergmann@de.ibm.com, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     powerpc: fix pci domain detection
has been removed from the -mm tree.  Its filename was
     powerpc-fix-pci-domain-detection.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: powerpc: fix pci domain detection
From: Arnd Bergmann <arnd@arndb.de>

The /proc/bus/pci/* files list PCI domain numbers only for devices that
claim to be on a multi-domain system.  The check for this is broken on
powerpc, because the buid value is truncated to 32 bits.

There is at least one machine (IBM QS21) that only uses the high-order bits
of the buid, so the return value of pci_proc_domain() ends up being always
zero, which makes /proc/bus/pci useless.

Change the logic to always return '1' for a nonzero buid value.

Signed-off-by: Arnd Bergmann <arnd.bergmann@de.ibm.com>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN arch/powerpc/kernel/pci_64.c~powerpc-fix-pci-domain-detection arch/powerpc/kernel/pci_64.c
--- a/arch/powerpc/kernel/pci_64.c~powerpc-fix-pci-domain-detection
+++ a/arch/powerpc/kernel/pci_64.c
@@ -588,7 +588,7 @@ int pci_proc_domain(struct pci_bus *bus)
 		return 0;
 	else {
 		struct pci_controller *hose = pci_bus_to_host(bus);
-		return hose->buid;
+		return hose->buid != 0;
 	}
 }
 
_

Patches currently in -mm which might be from arnd@arndb.de are

git-powerpc.patch
whitespace-fixes-compat-syscalls.patch
