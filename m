From: akpm@linux-foundation.org
Subject: - fix-up-pci-power-management-doc.patch removed from -mm tree
Date: Mon, 26 Mar 2007 15:35:19 -0800
Message-ID: <200703262335.l2QNZJLe001164@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58999 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933779AbXCZXfW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Mar 2007 19:35:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: corbet@lwn.net, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     Fix up PCI power management doc
has been removed from the -mm tree.  Its filename was
     fix-up-pci-power-management-doc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix up PCI power management doc
From: Jonathan Corbet <corbet@lwn.net>

Update the documentation of PCI power management functions.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/power/pci.txt |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

diff -puN Documentation/power/pci.txt~fix-up-pci-power-management-doc Documentation/power/pci.txt
--- a/Documentation/power/pci.txt~fix-up-pci-power-management-doc
+++ a/Documentation/power/pci.txt
@@ -102,31 +102,28 @@ pci_save_state
 --------------
 
 Usage:
-	pci_save_state(dev, buffer);
+	pci_save_state(struct pci_dev *dev);
 
 Description:
-	Save first 64 bytes of PCI config space. Buffer must be allocated by
-	caller.
+	Save first 64 bytes of PCI config space, along with any additional
+	PCI-Express or PCI-X information.
 
 
 pci_restore_state
 -----------------
 
 Usage:
-	pci_restore_state(dev, buffer);
+	pci_restore_state(struct pci_dev *dev);
 
 Description:
-	Restore previously saved config space. (First 64 bytes only);
-
-	If buffer is NULL, then restore what information we know about the
-	device from bootup: BARs and interrupt line.
+	Restore previously saved config space.
 
 
 pci_set_power_state
 -------------------
 
 Usage:
-	pci_set_power_state(dev, state);
+	pci_set_power_state(struct pci_dev *dev, pci_power_t state);
 
 Description:
 	Transition device to low power state using PCI PM Capabilities
@@ -142,7 +139,7 @@ pci_enable_wake
 ---------------
 
 Usage:
-	pci_enable_wake(dev, state, enable);
+	pci_enable_wake(struct pci_dev *dev, pci_power_t state, int enable);
 
 Description:
 	Enable device to generate PME# during low power state using PCI PM 
_

Patches currently in -mm which might be from corbet@lwn.net are

origin.patch
git-dvb.patch
