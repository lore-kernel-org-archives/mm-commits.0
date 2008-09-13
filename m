From: akpm@linux-foundation.org
Subject: - pci-fix-merging-left-out-for-bar-print-out-v2.patch removed from -mm tree
Date: Sat, 13 Sep 2008 00:45:56 -0700
Message-ID: <200809130745.m8D7juG1026803@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48524 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753282AbYIMHp6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 13 Sep 2008 03:45:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yhlu.kernel@gmail.com, mm-commits@vger.kernel.org


The patch titled
     pci: fix merging left out for BAR print out
has been removed from the -mm tree.  Its filename was
     pci-fix-merging-left-out-for-bar-print-out-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci: fix merging left out for BAR print out
From: Yinghai Lu <yhlu.kernel@gmail.com>

Print out Device BAR addresses before trying to update them.

Also change it to KERN_DEBUG instead.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/probe.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff -puN drivers/pci/probe.c~pci-fix-merging-left-out-for-bar-print-out-v2 drivers/pci/probe.c
--- a/drivers/pci/probe.c~pci-fix-merging-left-out-for-bar-print-out-v2
+++ a/drivers/pci/probe.c
@@ -304,6 +304,9 @@ static int __pci_read_base(struct pci_de
 		} else {
 			res->start = l64;
 			res->end = l64 + sz64;
+			printk(KERN_DEBUG "PCI: %s reg %x 64bit mmio: [%llx, %llx]\n",
+				pci_name(dev), pos, (unsigned long long)res->start,
+				(unsigned long long)res->end);
 		}
 	} else {
 		sz = pci_size(l, sz, mask);
@@ -313,6 +316,9 @@ static int __pci_read_base(struct pci_de
 
 		res->start = l;
 		res->end = l + sz;
+		printk(KERN_DEBUG "PCI: %s reg %x %s: [%llx, %llx]\n", pci_name(dev),
+			pos, (res->flags & IORESOURCE_IO) ? "io port":"32bit mmio",
+			(unsigned long long)res->start, (unsigned long long)res->end);
 	}
 
  out:
@@ -383,7 +389,7 @@ void __devinit pci_read_bridge_bases(str
 			res->start = base;
 		if (!res->end)
 			res->end = limit + 0xfff;
-		printk(KERN_INFO "PCI: bridge %s io port: [%llx, %llx]\n",
+		printk(KERN_DEBUG "PCI: bridge %s io port: [%llx, %llx]\n",
 			pci_name(dev), (unsigned long long) res->start,
 			(unsigned long long) res->end);
 	}
@@ -397,8 +403,9 @@ void __devinit pci_read_bridge_bases(str
 		res->flags = (mem_base_lo & PCI_MEMORY_RANGE_TYPE_MASK) | IORESOURCE_MEM;
 		res->start = base;
 		res->end = limit + 0xfffff;
-		printk(KERN_INFO "PCI: bridge %s 32bit mmio: [%llx, %llx]\n", pci_name(dev),
-			(unsigned long long) res->start, (unsigned long long) res->end);
+		printk(KERN_DEBUG "PCI: bridge %s 32bit mmio: [%llx, %llx]\n",
+			pci_name(dev), (unsigned long long) res->start,
+			(unsigned long long) res->end);
 	}
 
 	res = child->resource[2];
@@ -434,7 +441,7 @@ void __devinit pci_read_bridge_bases(str
 		res->flags = (mem_base_lo & PCI_MEMORY_RANGE_TYPE_MASK) | IORESOURCE_MEM | IORESOURCE_PREFETCH;
 		res->start = base;
 		res->end = limit + 0xfffff;
-		printk(KERN_INFO "PCI: bridge %s %sbit mmio pref: [%llx, %llx]\n",
+		printk(KERN_DEBUG "PCI: bridge %s %sbit mmio pref: [%llx, %llx]\n",
 			pci_name(dev), (res->flags & PCI_PREF_RANGE_TYPE_64) ? "64" : "32",
 			(unsigned long long) res->start, (unsigned long long) res->end);
 	}
_

Patches currently in -mm which might be from yhlu.kernel@gmail.com are

linux-next.patch
apci-dump-slit.patch
arch-x86-kernel-early_printkc-remove-unused-enable_debug_console.patch
dyn_array-use-%pf-instead-of-print_fn_descriptor_symbol.patch
net-forcedeth-call-restore-mac-addr-in-nv_shutdown-path-v2.patch

