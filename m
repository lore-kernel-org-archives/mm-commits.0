From: akpm@linux-foundation.org
Subject: - fix-2-sparc64-gregkh-driver-core-read-dev_name-instead-of-bus_id.patch removed from -mm tree
Date: Tue, 13 May 2008 21:00:44 -0600
Message-ID: <200805140301.m4E317T9013248@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45983 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757803AbYENDBL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 23:01:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davem@davemloft.net, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     fix-2-sparc64-gregkh-driver-core-read-dev_name-instead-of-bus_id.patch added to -mm tree
has been removed from the -mm tree.  Its filename was
     fix-2-sparc64-gregkh-driver-core-read-dev_name-instead-of-bus_id.patch

This patch was dropped because -gregkh-driver-core-read-dev_name-instead-of-bus_id appears to have gone away

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix-2-sparc64-gregkh-driver-core-read-dev_name-instead-of-bus_id.patch added to -mm tree
From: David Miller <davem@davemloft.net>

I posted a proper fix for this on linux-next yesterday when
Stephen reported the build failure.

Here it is again, and it fixes the powerpc build too:

Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/pci_64.c |    4 ++--
 arch/sparc64/kernel/pci.c    |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/powerpc/kernel/pci_64.c~fix-2-sparc64-gregkh-driver-core-read-dev_name-instead-of-bus_id arch/powerpc/kernel/pci_64.c
--- a/arch/powerpc/kernel/pci_64.c~fix-2-sparc64-gregkh-driver-core-read-dev_name-instead-of-bus_id
+++ a/arch/powerpc/kernel/pci_64.c
@@ -189,8 +189,8 @@ struct pci_dev *of_create_pci_dev(struct
 
 	dev->cfg_size = pci_cfg_space_size(dev);
 
-	sprintf(pci_name(dev), "%04x:%02x:%02x.%d", pci_domain_nr(bus),
-		dev->bus->number, PCI_SLOT(devfn), PCI_FUNC(devfn));
+	dev_set_name(&dev->dev, "%04x:%02x:%02x.%d", pci_domain_nr(bus),
+		     dev->bus->number, PCI_SLOT(devfn), PCI_FUNC(devfn));
 	dev->class = get_int_prop(node, "class-code", 0);
 	dev->revision = get_int_prop(node, "revision-id", 0);
 
diff -puN arch/sparc64/kernel/pci.c~fix-2-sparc64-gregkh-driver-core-read-dev_name-instead-of-bus_id arch/sparc64/kernel/pci.c
--- a/arch/sparc64/kernel/pci.c~fix-2-sparc64-gregkh-driver-core-read-dev_name-instead-of-bus_id
+++ a/arch/sparc64/kernel/pci.c
@@ -408,8 +408,8 @@ struct pci_dev *of_create_pci_dev(struct
 	dev->class = class >> 8;
 	dev->revision = class & 0xff;
 
-	sprintf(pci_name(dev), "%04x:%02x:%02x.%d", pci_domain_nr(bus),
-		dev->bus->number, PCI_SLOT(devfn), PCI_FUNC(devfn));
+	dev_set_name(&dev->dev, "%04x:%02x:%02x.%d", pci_domain_nr(bus),
+		     dev->bus->number, PCI_SLOT(devfn), PCI_FUNC(devfn));
 
 	if (ofpci_verbose)
 		printk("    class: 0x%x device name: %s\n",
_

Patches currently in -mm which might be from davem@davemloft.net are

origin.patch
linux-next.patch
fix-2-sparc64-gregkh-driver-core-read-dev_name-instead-of-bus_id.patch
git-net.patch
iphase-fix-64bit-warning.patch
list_for_each_rcu-must-die-networking.patch
net-hso-driver-uses-rfkill-functions.patch
rndis_host-increase-delay-in-command-response-loop.patch
mm-move-bootmem-descriptors-definition-to-a-single-place.patch
flag-parameters-socket-and-socketpair.patch
flag-parameters-nonblock-in-socket-and-socketpair.patch
printk-ratelimiting-rewrite.patch
unexport-proc_clear_tty.patch
unexport-uts_sem.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch

