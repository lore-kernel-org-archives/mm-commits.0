From: akpm@linux-foundation.org
Subject: - pci-fix-printk-warnings-in-probec.patch removed from -mm tree
Date: Tue, 02 Sep 2008 13:41:41 -0700
Message-ID: <200809022041.m82KffmJ011655@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35349 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752359AbYIBUlw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Sep 2008 16:41:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johfel@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     pci: fix printk warnings in probe.c
has been removed from the -mm tree.  Its filename was
     pci-fix-printk-warnings-in-probec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci: fix printk warnings in probe.c
From: Johann Felix Soden <johfel@users.sourceforge.net>

drivers/pci/probe.c: In function 'pci_read_bridge_bases':
drivers/pci/probe.c:386: warning: format '%llx' expects type 'long long unsigned int', but argument 3 has type 'resource_size_t'
drivers/pci/probe.c:386: warning: format '%llx' expects type 'long long unsigned int', but argument 4 has type 'resource_size_t'
drivers/pci/probe.c:398: warning: format '%llx' expects type 'long long unsigned int', but argument 3 has type 'resource_size_t'
drivers/pci/probe.c:398: warning: format '%llx' expects type 'long long unsigned int', but argument 4 has type 'resource_size_t'
drivers/pci/probe.c:434: warning: format '%llx' expects type 'long long unsigned int', but argument 4 has type 'resource_size_t'
drivers/pci/probe.c:434: warning: format '%llx' expects type 'long long unsigned int', but argument 5 has type 'resource_size_t'

Signed-off-by: Johann Felix Soden <johfel@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/probe.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN drivers/pci/probe.c~pci-fix-printk-warnings-in-probec drivers/pci/probe.c
--- a/drivers/pci/probe.c~pci-fix-printk-warnings-in-probec
+++ a/drivers/pci/probe.c
@@ -383,7 +383,9 @@ void __devinit pci_read_bridge_bases(str
 			res->start = base;
 		if (!res->end)
 			res->end = limit + 0xfff;
-		printk(KERN_INFO "PCI: bridge %s io port: [%llx, %llx]\n", pci_name(dev), res->start, res->end);
+		printk(KERN_INFO "PCI: bridge %s io port: [%llx, %llx]\n",
+			pci_name(dev), (unsigned long long) res->start,
+			(unsigned long long) res->end);
 	}
 
 	res = child->resource[1];
@@ -395,7 +397,8 @@ void __devinit pci_read_bridge_bases(str
 		res->flags = (mem_base_lo & PCI_MEMORY_RANGE_TYPE_MASK) | IORESOURCE_MEM;
 		res->start = base;
 		res->end = limit + 0xfffff;
-		printk(KERN_INFO "PCI: bridge %s 32bit mmio: [%llx, %llx]\n", pci_name(dev), res->start, res->end);
+		printk(KERN_INFO "PCI: bridge %s 32bit mmio: [%llx, %llx]\n", pci_name(dev),
+			(unsigned long long) res->start, (unsigned long long) res->end);
 	}
 
 	res = child->resource[2];
@@ -431,7 +434,9 @@ void __devinit pci_read_bridge_bases(str
 		res->flags = (mem_base_lo & PCI_MEMORY_RANGE_TYPE_MASK) | IORESOURCE_MEM | IORESOURCE_PREFETCH;
 		res->start = base;
 		res->end = limit + 0xfffff;
-		printk(KERN_INFO "PCI: bridge %s %sbit mmio pref: [%llx, %llx]\n", pci_name(dev), (res->flags & PCI_PREF_RANGE_TYPE_64)?"64":"32",res->start, res->end);
+		printk(KERN_INFO "PCI: bridge %s %sbit mmio pref: [%llx, %llx]\n",
+			pci_name(dev), (res->flags & PCI_PREF_RANGE_TYPE_64) ? "64" : "32",
+			(unsigned long long) res->start, (unsigned long long) res->end);
 	}
 }
 
_

Patches currently in -mm which might be from johfel@users.sourceforge.net are

linux-next.patch

