From: akpm@linux-foundation.org
Subject: + edac-amd8111-driver-source-file-v2.patch added to -mm tree
Date: Wed, 11 Mar 2009 13:49:49 -0700
Message-ID: <200903112049.n2BKnoT6002453@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59983 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750916AbZCKUvX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Mar 2009 16:51:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: qingtao.cao@windriver.com, norsk5@yahoo.com


The patch titled
     EDAC: AMD8111 driver source file v2
has been added to the -mm tree.  Its filename is
     edac-amd8111-driver-source-file-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: EDAC: AMD8111 driver source file v2
From: Harry Ciao <qingtao.cao@windriver.com>

Introduce AMD8111 EDAC driver source file, which makes use of error
detections on the LPC Bridge Controller and PCI Bridge Controller on
the AMD8111 HyperTransport I/O Hub.

Signed-off-by: Harry Ciao <qingtao.cao@windriver.com>
Cc: Doug Thompson <norsk5@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/amd8111_edac.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/edac/amd8111_edac.c~edac-amd8111-driver-source-file-v2 drivers/edac/amd8111_edac.c
--- a/drivers/edac/amd8111_edac.c~edac-amd8111-driver-source-file-v2
+++ a/drivers/edac/amd8111_edac.c
@@ -36,6 +36,7 @@
 #define AMD8111_EDAC_REVISION	" Ver: 1.0.0 " __DATE__
 #define AMD8111_EDAC_MOD_STR	"amd8111_edac"
 
+#define PCI_DEVICE_ID_AMD_8111_PCI	0x7460
 static int edac_dev_idx;
 
 enum amd8111_edac_devs {
@@ -52,7 +53,7 @@ static int edac_pci_read_dword(struct pc
 	int ret;
 
 	ret = pci_read_config_dword(dev, reg, val32);
-	if (ret > 0)
+	if (ret != 0)
 		printk(KERN_ERR AMD8111_EDAC_MOD_STR
 			" PCI Access Read Error at 0x%x\n", reg);
 
@@ -64,7 +65,7 @@ static void edac_pci_read_byte(struct pc
 	int ret;
 
 	ret = pci_read_config_byte(dev, reg, val8);
-	if (ret > 0)
+	if (ret != 0)
 		printk(KERN_ERR AMD8111_EDAC_MOD_STR
 			" PCI Access Read Error at 0x%x\n", reg);
 }
@@ -74,7 +75,7 @@ static void edac_pci_write_dword(struct 
 	int ret;
 
 	ret = pci_write_config_dword(dev, reg, val32);
-	if (ret > 0)
+	if (ret != 0)
 		printk(KERN_ERR AMD8111_EDAC_MOD_STR
 			" PCI Access Write Error at 0x%x\n", reg);
 }
@@ -84,7 +85,7 @@ static void edac_pci_write_byte(struct p
 	int ret;
 
 	ret = pci_write_config_byte(dev, reg, val8);
-	if (ret > 0)
+	if (ret != 0)
 		printk(KERN_ERR AMD8111_EDAC_MOD_STR
 			" PCI Access Write Error at 0x%x\n", reg);
 }
_

Patches currently in -mm which might be from qingtao.cao@windriver.com are

edac-amd8111-driver-header-file.patch
edac-amd8111-driver-source-file.patch
edac-amd8111-driver-source-file-v2.patch
edac-add-edac_pci_alloc_index.patch
pci-add-amd8111-pci-bridge-pci-device-id.patch
edac-amd8131-driver-header-file.patch
edac-amd8131-driver-source-file.patch
edac-amd8131-driver-source-file-v2.patch
edac-amd8131-driver-kconfig-makefile.patch
edac-amd8111-driver-kconfig-makefile.patch

