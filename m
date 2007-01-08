From: akpm@osdl.org
Subject: + libata-sff-dont-try-and-activate-channels-which-are-not.patch added to -mm tree
Date: Mon, 08 Jan 2007 15:06:17 -0800
Message-ID: <200701082306.l08N6HsG022021@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51867 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161098AbXAHXGZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 8 Jan 2007 18:06:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorgukCox, alan@redhat.com


The patch titled
     libata-sff: Don't try and activate channels which are not  in use
has been added to the -mm tree.  Its filename is
     libata-sff-dont-try-and-activate-channels-which-are-not.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: libata-sff: Don't try and activate channels which are not  in use
From: Alan <alan@lxorgukCox .ukuu.org.uk>

An ATA controller in native mode may have one or more channels disabled and
not assigned resources.  In that case the existing code crashes trying to
access I/O ports 0-7.

Add the neccessary check.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ata/libata-sff.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+)

diff -puN drivers/ata/libata-sff.c~libata-sff-dont-try-and-activate-channels-which-are-not drivers/ata/libata-sff.c
--- a/drivers/ata/libata-sff.c~libata-sff-dont-try-and-activate-channels-which-are-not
+++ a/drivers/ata/libata-sff.c
@@ -831,6 +831,21 @@ void ata_bmdma_post_internal_cmd(struct 
 }
 
 #ifdef CONFIG_PCI
+
+static int ata_resources_present(struct pci_dev *pdev, int port)
+{
+	int i;
+
+	/* Check the PCI resources for this channel are enabled */
+	port = port * 2;
+	for (i = 0; i < 2; i ++) {
+		if (pci_resource_start(pdev, port + i) == 0 ||
+			pci_resource_len(pdev, port + i) == 0)
+		return 0;
+	}
+	return 1;
+}
+
 /**
  *	ata_pci_init_native_mode - Initialize native-mode driver
  *	@pdev:  pci device to be initialized
@@ -863,6 +878,13 @@ ata_pci_init_native_mode(struct pci_dev 
 	probe_ent->irq = pdev->irq;
 	probe_ent->irq_flags = IRQF_SHARED;
 
+	/* Discard disabled ports. Some controllers show their
+	   unused channels this way */
+	if (ata_resources_present(pdev, 0) == 0)
+		ports &= ~ATA_PORT_PRIMARY;
+	if (ata_resources_present(pdev, 1) == 0)
+		ports &= ~ATA_PORT_SECONDARY;
+
 	if (ports & ATA_PORT_PRIMARY) {
 		probe_ent->port[p].cmd_addr = pci_resource_start(pdev, 0);
 		probe_ent->port[p].altstatus_addr =
_

Patches currently in -mm which might be from alan@lxorgukCox are

libata-sff-dont-try-and-activate-channels-which-are-not.patch
ide-generic-jmicron-has-its-own-drivers-now.patch
