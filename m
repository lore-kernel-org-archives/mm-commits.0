From: akpm@linux-foundation.org
Subject: - pci-define-pci_request-release_regions-for-config_pci=n.patch removed from -mm tree
Date: Sat, 21 Apr 2007 23:23:47 -0700
Message-ID: <200704220626.l3M6QNgM021064@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34890 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964934AbXDVG0d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 22 Apr 2007 02:26:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sshtylyov@ru.mvista.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     PCI: define pci_request/release_regions() for CONFIG_PCI=n
has been removed from the -mm tree.  Its filename was
     pci-define-pci_request-release_regions-for-config_pci=n.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: PCI: define pci_request/release_regions() for CONFIG_PCI=n
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

Balance declarations of pci_request_regions() and pci_release_regions()
with empty inline definitions for the CONFIG_PCI=n case -- otherwise my
patch to drivers/net/3c59x.c in the -mm tree doesn't compile.  :-)

While at it, get rid of unused #define HAVE_PCI_REQ_REGIONS...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pci.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN include/linux/pci.h~pci-define-pci_request-release_regions-for-config_pci=n include/linux/pci.h
--- a/include/linux/pci.h~pci-define-pci_request-release_regions-for-config_pci=n
+++ a/include/linux/pci.h
@@ -582,7 +582,6 @@ void pdev_enable_device(struct pci_dev *
 void pdev_sort_resources(struct pci_dev *, struct resource_list *);
 void pci_fixup_irqs(u8 (*)(struct pci_dev *, u8 *),
 		    int (*)(struct pci_dev *, u8, u8));
-#define HAVE_PCI_REQ_REGIONS	2
 int __must_check pci_request_regions(struct pci_dev *, const char *);
 void pci_release_regions(struct pci_dev *);
 int __must_check pci_request_region(struct pci_dev *, int, const char *);
@@ -748,6 +747,9 @@ static inline int pci_enable_wake(struct
 static inline int pci_request_regions(struct pci_dev *dev, const char *res_name) { return -EIO; }
 static inline void pci_release_regions(struct pci_dev *dev) { }
 
+static inline int pci_request_regions(struct pci_dev *dev, const char *res_name) { return -EIO; }
+static inline void pci_release_regions(struct pci_dev *dev) { }
+
 #define pci_dma_burst_advice(pdev, strat, strategy_parameter) do { } while (0)
 
 static inline void pci_block_user_cfg_access(struct pci_dev *dev) { }
_

Patches currently in -mm which might be from sshtylyov@ru.mvista.com are

origin.patch
3x59x-fix-pci-resource-management.patch
pci-define-pci_request-release_regions-for-config_pci=n.patch
