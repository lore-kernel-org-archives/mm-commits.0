From: akpm@linux-foundation.org
Subject: + powerpc-fix-pci-domain-detection.patch added to -mm tree
Date: Thu, 04 Oct 2007 12:13:25 -0700
Message-ID: <200710041913.l94JDPG8024545@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37042 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756064AbXJDTNj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Oct 2007 15:13:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arnd@arndb.de, arnd.bergmann@de.ibm.com, benh@kernel.crashing.org


The patch titled
     powerpc: fix pci domain detection
has been added to the -mm tree.  Its filename is
     powerpc-fix-pci-domain-detection.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

powerpc-fix-pci-domain-detection.patch
whitespace-fixes-compat-syscalls.patch
