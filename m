From: akpm@linux-foundation.org
Subject: - pci_module_init-convertion-in-the-legacy-megaraid-driver.patch removed from -mm tree
Date: Fri, 16 Feb 2007 23:16:53 -0800
Message-ID: <200702170716.l1H7Gr3m021749@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51189 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946522AbXBQHQ6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 02:16:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: henne@nachtwindheim.de, mm-commits@vger.kernel.org


The patch titled
     pci_module_init() convertion in the legacy megaraid driver
has been removed from the -mm tree.  Its filename was
     pci_module_init-convertion-in-the-legacy-megaraid-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pci_module_init() convertion in the legacy megaraid driver
From: Henrik Kretzschmar <henne@nachtwindheim.de>

pci_module_init() convertion in the legacy megaraid driver.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/megaraid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/megaraid.c~pci_module_init-convertion-in-the-legacy-megaraid-driver drivers/scsi/megaraid.c
--- a/drivers/scsi/megaraid.c~pci_module_init-convertion-in-the-legacy-megaraid-driver
+++ a/drivers/scsi/megaraid.c
@@ -5077,7 +5077,7 @@ static int __init megaraid_init(void)
 				"megaraid: failed to create megaraid root\n");
 	}
 #endif
-	error = pci_module_init(&megaraid_pci_driver);
+	error = pci_register_driver(&megaraid_pci_driver);
 	if (error) {
 #ifdef CONFIG_PROC_FS
 		remove_proc_entry("megaraid", &proc_root);
_

Patches currently in -mm which might be from henne@nachtwindheim.de are

pci_module_init-convertion-in-tmscsimc.patch
scsi-whitespace-cleanup-in-the-dpt-driver.patch
pci_module_init-convertion-for-k8_edacc.patch
mark-pci_module_init-deprecated.patch
