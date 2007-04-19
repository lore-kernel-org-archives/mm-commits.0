From: akpm@linux-foundation.org
Subject: - pci-add-debug-information-to-resource-collision-message.patch removed from -mm tree
Date: Thu, 19 Apr 2007 13:02:34 -0700
Message-ID: <200704192002.l3JK2YFU029397@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44798 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767000AbXDSUCs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Apr 2007 16:02:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cebbert@redhat.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     PCI: add debug information to resource collision message
has been removed from the -mm tree.  Its filename was
     pci-add-debug-information-to-resource-collision-message.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: PCI: add debug information to resource collision message
From: Chuck Ebbert <cebbert@redhat.com>

Add more information to PCI resource collision message to help with
debugging.

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/pci/i386.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/i386/pci/i386.c~pci-add-debug-information-to-resource-collision-message arch/i386/pci/i386.c
--- a/arch/i386/pci/i386.c~pci-add-debug-information-to-resource-collision-message
+++ a/arch/i386/pci/i386.c
@@ -246,8 +246,8 @@ int pcibios_enable_resources(struct pci_
 			continue;
 		if (!r->start && r->end) {
 			printk(KERN_ERR "PCI: Device %s not available "
-				"because of resource collisions\n",
-				pci_name(dev));
+				"because of resource %d collisions\n",
+				pci_name(dev), idx);
 			return -EINVAL;
 		}
 		if (r->flags & IORESOURCE_IO)
_

Patches currently in -mm which might be from cebbert@redhat.com are
