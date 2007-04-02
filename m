From: akpm@linux-foundation.org
Subject: + pci-define-pci_request-release_regions-for-config_pci=n.patch added to -mm tree
Date: Sun, 01 Apr 2007 22:28:53 -0700
Message-ID: <200704020528.l325Sr4O024992@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36070 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296AbXDBF26 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 2 Apr 2007 01:28:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sshtylyov@ru.mvista.com, greg@kroah.com


The patch titled
     PCI: define pci_request/release_regions() for CONFIG_PCI=n
has been added to the -mm tree.  Its filename is
     pci-define-pci_request-release_regions-for-config_pci=n.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -586,7 +586,6 @@ void pdev_enable_device(struct pci_dev *
 void pdev_sort_resources(struct pci_dev *, struct resource_list *);
 void pci_fixup_irqs(u8 (*)(struct pci_dev *, u8 *),
 		    int (*)(struct pci_dev *, u8, u8));
-#define HAVE_PCI_REQ_REGIONS	2
 int __must_check pci_request_regions(struct pci_dev *, const char *);
 void pci_release_regions(struct pci_dev *);
 int __must_check pci_request_region(struct pci_dev *, int, const char *);
@@ -749,6 +748,9 @@ static inline int pci_set_power_state(st
 static inline pci_power_t pci_choose_state(struct pci_dev *dev, pm_message_t state) { return PCI_D0; }
 static inline int pci_enable_wake(struct pci_dev *dev, pci_power_t state, int enable) { return 0; }
 
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
