From: akpm@linux-foundation.org
Subject: - pci_set_power_state-check-for-pm-capabilities-earlier.patch removed from -mm tree
Date: Fri, 24 Aug 2007 22:18:10 -0700
Message-ID: <200708250518.l7P5IAY1031843@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39628 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754447AbXHYFSi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 25 Aug 2007 01:18:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andrew.lunn@ascom.ch, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     pci_set_power_state(): check for PM capabilities earlier
has been removed from the -mm tree.  Its filename was
     pci_set_power_state-check-for-pm-capabilities-earlier.patch

This patch was dropped because it isn't in the present -mm lineup

------------------------------------------------------
Subject: pci_set_power_state(): check for PM capabilities earlier
From: Andrew Lunn <andrew.lunn@ascom.ch>

Check for PCI_CAP_ID_PM before checking the device state.  Apparently fixes
some log spam via the 3c59x driver.

Signed-off-by: Andrew Lunn <andrew.lunn@ascom.ch>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pci.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/pci/pci.c~pci_set_power_state-check-for-pm-capabilities-earlier drivers/pci/pci.c
--- a/drivers/pci/pci.c~pci_set_power_state-check-for-pm-capabilities-earlier
+++ a/drivers/pci/pci.c
@@ -406,6 +406,13 @@ pci_set_power_state(struct pci_dev *dev,
 	if ((state == PCI_D1 || state == PCI_D2) && pci_no_d1d2(dev))
 		return 0;
 
+	/* find PCI PM capability in list */
+	pm = pci_find_capability(dev, PCI_CAP_ID_PM);
+
+	/* abort if the device doesn't support PM capabilities */
+	if (!pm)
+		return -EIO;
+
 	/* Validate current state:
 	 * Can enter D0 from any state, but if we can only go deeper 
 	 * to sleep if we're already in a low power state
@@ -418,13 +425,6 @@ pci_set_power_state(struct pci_dev *dev,
 		return 0;        /* we're already there */
 
 
-	/* find PCI PM capability in list */
-	pm = pci_find_capability(dev, PCI_CAP_ID_PM);
-	
-	/* abort if the device doesn't support PM capabilities */
-	if (!pm)
-		return -EIO; 
-
 	pci_read_config_word(dev,pm + PCI_PM_PMC,&pmc);
 	if ((pmc & PCI_PM_CAP_VER_MASK) > 3) {
 		printk(KERN_DEBUG
_

Patches currently in -mm which might be from andrew.lunn@ascom.ch are
