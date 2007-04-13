From: akpm@linux-foundation.org
Subject: + pci-add-debug-information-to-resource-collision-message.patch added to -mm tree
Date: Fri, 13 Apr 2007 11:32:24 -0700
Message-ID: <200704131832.l3DIWOYf006470@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45433 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754128AbXDMSe2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 14:34:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cebbert@redhat.com, greg@kroah.com


The patch titled
     PCI: add debug information to resource collision message
has been added to the -mm tree.  Its filename is
     pci-add-debug-information-to-resource-collision-message.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

pci-add-debug-information-to-resource-collision-message.patch
