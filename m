From: akpm@linux-foundation.org
Subject: + pci-fix-printk-warnings-in-probec.patch added to -mm tree
Date: Fri, 22 Aug 2008 12:49:49 -0700
Message-ID: <200808221949.m7MJnnUY013310@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49819 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755168AbYHVTua (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Aug 2008 15:50:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johfel@users.sourceforge.net


The patch titled
     pci: fix printk warnings in probe.c
has been added to the -mm tree.  Its filename is
     pci-fix-printk-warnings-in-probec.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

pci-fix-printk-warnings-in-setup-busc.patch
pci-fix-printk-warnings-in-probec.patch

