From: akpm@linux-foundation.org
Subject: [folded] edac-amd8131-driver-source-file-v2.patch removed from -mm tree
Date: Thu, 02 Apr 2009 16:24:25 -0700
Message-ID: <200904022324.n32NOPJJ012189@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57277 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759907AbZDBX0S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Apr 2009 19:26:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qingtao.cao@windriver.com, norsk5@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     edac: AMD8131 driver source file v2
has been removed from the -mm tree.  Its filename was
     edac-amd8131-driver-source-file-v2.patch

This patch was dropped because it was folded into edac-amd8131-driver-source-file.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: AMD8131 driver source file v2
From: Harry Ciao <qingtao.cao@windriver.com>

Introduce AMD8131 EDAC driver source file, which makes use of error
detections on the PCI-X Bridge Controllers on the AMD8131 HyperTransport
PCI-X Tunnel.

Signed-off-by: Harry Ciao <qingtao.cao@windriver.com>
Cc: Doug Thompson <norsk5@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/amd8131_edac.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/edac/amd8131_edac.c~edac-amd8131-driver-source-file-v2 drivers/edac/amd8131_edac.c
--- a/drivers/edac/amd8131_edac.c~edac-amd8131-driver-source-file-v2
+++ a/drivers/edac/amd8131_edac.c
@@ -42,7 +42,7 @@ static void edac_pci_read_dword(struct p
 	int ret;
 
 	ret = pci_read_config_dword(dev, reg, val32);
-	if (ret > 0)
+	if (ret != 0)
 		printk(KERN_ERR AMD8131_EDAC_MOD_STR
 			" PCI Access Read Error at 0x%x\n", reg);
 }
@@ -52,7 +52,7 @@ static void edac_pci_write_dword(struct 
 	int ret;
 
 	ret = pci_write_config_dword(dev, reg, val32);
-	if (ret > 0)
+	if (ret != 0)
 		printk(KERN_ERR AMD8131_EDAC_MOD_STR
 			" PCI Access Write Error at 0x%x\n", reg);
 }
@@ -357,6 +357,9 @@ static struct pci_driver amd8131_edac_dr
 
 static int __init amd8131_edac_init(void)
 {
+	printk(KERN_INFO "AMD8131 EDAC driver " AMD8131_EDAC_REVISION "\n");
+	printk(KERN_INFO "\t(c) 2008 Wind River Systems, Inc.\n");
+
 	/* Only POLL mode supported so far */
 	edac_op_state = EDAC_OPSTATE_POLL;
 
_

Patches currently in -mm which might be from qingtao.cao@windriver.com are

edac-amd8111-driver-header-file.patch
edac-amd8111-driver-source-file.patch
edac-add-edac_pci_alloc_index.patch
pci-add-amd8111-pci-bridge-pci-device-id.patch
edac-amd8131-driver-header-file.patch
edac-amd8131-driver-source-file.patch
edac-amd8131-driver-source-file-v2.patch
edac-amd8131-driver-kconfig-makefile.patch
edac-amd8111-driver-kconfig-makefile.patch

