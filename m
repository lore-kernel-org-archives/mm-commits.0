From: akpm@linux-foundation.org
Subject: [merged] eisa-pci_eisac-fix-section-mismatch.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:55:13 -0700
Message-ID: <201107260754.p6Q7sHdF003338@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53237 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752412Ab1GZHzI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:55:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lacombar@gmail.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     eisa/pci_eisa.c: fix section mismatch
has been removed from the -mm tree.  Its filename was
     eisa-pci_eisac-fix-section-mismatch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: eisa/pci_eisa.c: fix section mismatch
From: Arnaud Lacombe <lacombar@gmail.com>

WARNING: vmlinux.o(.data+0x15d3ac): Section mismatch in reference from the variable pci_eisa_driver to the function .init.text:pci_eisa_init()
The variable pci_eisa_driver references the function __init pci_eisa_init()
If the reference is valid then annotate the variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/eisa/pci_eisa.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/eisa/pci_eisa.c~eisa-pci_eisac-fix-section-mismatch drivers/eisa/pci_eisa.c
--- a/drivers/eisa/pci_eisa.c~eisa-pci_eisac-fix-section-mismatch
+++ a/drivers/eisa/pci_eisa.c
@@ -45,13 +45,13 @@ static int __init pci_eisa_init(struct p
 	return 0;
 }
 
-static struct pci_device_id pci_eisa_pci_tbl[] = {
+static struct pci_device_id __initdata pci_eisa_pci_tbl[] = {
 	{ PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
 	  PCI_CLASS_BRIDGE_EISA << 8, 0xffff00, 0 },
 	{ 0, }
 };
 
-static struct pci_driver pci_eisa_driver = {
+static struct pci_driver __initdata pci_eisa_driver = {
 	.name		= "pci_eisa",
 	.id_table	= pci_eisa_pci_tbl,
 	.probe		= pci_eisa_init,
_

Patches currently in -mm which might be from lacombar@gmail.com are

origin.patch
linux-next.patch

