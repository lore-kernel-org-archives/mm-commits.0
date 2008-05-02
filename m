From: akpm@linux-foundation.org
Subject: - scsi-megaraid-fix-suspend-resume-sections.patch removed from -mm tree
Date: Fri, 02 May 2008 12:43:54 -0700
Message-ID: <200805021943.m42Jhs5Z011328@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42462 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756253AbYEBTob (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 15:44:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, Bo.Yang@lsi.com, James.Bottomley@HansenPartnership.com, megaraidlinux@lsi.com, mm-commits@vger.kernel.org


The patch titled
     scsi: megaraid, fix suspend/resume sections
has been removed from the -mm tree.  Its filename was
     scsi-megaraid-fix-suspend-resume-sections.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scsi: megaraid, fix suspend/resume sections
From: Jiri Slaby <jirislaby@gmail.com>

megaraid_sas suspend and resume are incorrectly placed in the __devinit
section.  Remove those placements and make the stuff dependent on CONFIG_PM.

While at it, mark remove function as __devexit.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Neela Syam Kolli <megaraidlinux@lsi.com>
Cc: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/megaraid/megaraid_sas.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/megaraid/megaraid_sas.c~scsi-megaraid-fix-suspend-resume-sections drivers/scsi/megaraid/megaraid_sas.c
--- a/drivers/scsi/megaraid/megaraid_sas.c~scsi-megaraid-fix-suspend-resume-sections
+++ a/drivers/scsi/megaraid/megaraid_sas.c
@@ -2650,12 +2650,13 @@ static void megasas_shutdown_controller(
 	return;
 }
 
+#ifdef CONFIG_PM
 /**
  * megasas_suspend -	driver suspend entry point
  * @pdev:		PCI device structure
  * @state:		PCI power state to suspend routine
  */
-static int __devinit
+static int
 megasas_suspend(struct pci_dev *pdev, pm_message_t state)
 {
 	struct Scsi_Host *host;
@@ -2687,7 +2688,7 @@ megasas_suspend(struct pci_dev *pdev, pm
  * megasas_resume-      driver resume entry point
  * @pdev:               PCI device structure
  */
-static int __devinit
+static int
 megasas_resume(struct pci_dev *pdev)
 {
 	int rval;
@@ -2782,12 +2783,16 @@ fail_ready_state:
 
 	return -ENODEV;
 }
+#else
+#define megasas_suspend	NULL
+#define megasas_resume	NULL
+#endif
 
 /**
  * megasas_detach_one -	PCI hot"un"plug entry point
  * @pdev:		PCI device structure
  */
-static void megasas_detach_one(struct pci_dev *pdev)
+static void __devexit megasas_detach_one(struct pci_dev *pdev)
 {
 	int i;
 	struct Scsi_Host *host;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch
git-scsi-misc.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

