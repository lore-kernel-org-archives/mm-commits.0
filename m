From: akpm@linux-foundation.org
Subject: [merged] edac-amd8111-amd8131-use-dev_name.patch removed from -mm tree
Date: Fri, 29 May 2009 11:43:25 -0700
Message-ID: <200905291843.n4TIhPjO011611@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54097 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752810AbZE2Snv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 May 2009 14:43:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qingtao.cao@windriver.com, norsk5@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     edac: AMD8111 & AMD8131 use dev_name()
has been removed from the -mm tree.  Its filename was
     edac-amd8111-amd8131-use-dev_name.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: AMD8111 & AMD8131 use dev_name()
From: Harry Ciao <qingtao.cao@windriver.com>

The "bus_id" member in the device structure has been obsolete, use
dev_name() instead.

Signed-off-by: Harry Ciao <qingtao.cao@windriver.com>
Cc: Doug Thompson <norsk5@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/amd8111_edac.c |    4 ++--
 drivers/edac/amd8131_edac.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/edac/amd8111_edac.c~edac-amd8111-amd8131-use-dev_name drivers/edac/amd8111_edac.c
--- a/drivers/edac/amd8111_edac.c~edac-amd8111-amd8131-use-dev_name
+++ a/drivers/edac/amd8111_edac.c
@@ -389,7 +389,7 @@ static int amd8111_dev_probe(struct pci_
 	dev_info->edac_dev->dev = &dev_info->dev->dev;
 	dev_info->edac_dev->mod_name = AMD8111_EDAC_MOD_STR;
 	dev_info->edac_dev->ctl_name = dev_info->ctl_name;
-	dev_info->edac_dev->dev_name = dev_info->dev->dev.bus_id;
+	dev_info->edac_dev->dev_name = dev_name(&dev_info->dev->dev);
 
 	if (edac_op_state == EDAC_OPSTATE_POLL)
 		dev_info->edac_dev->edac_check = dev_info->check;
@@ -473,7 +473,7 @@ static int amd8111_pci_probe(struct pci_
 	pci_info->edac_dev->dev = &pci_info->dev->dev;
 	pci_info->edac_dev->mod_name = AMD8111_EDAC_MOD_STR;
 	pci_info->edac_dev->ctl_name = pci_info->ctl_name;
-	pci_info->edac_dev->dev_name = pci_info->dev->dev.bus_id;
+	pci_info->edac_dev->dev_name = dev_name(&pci_info->dev->dev);
 
 	if (edac_op_state == EDAC_OPSTATE_POLL)
 		pci_info->edac_dev->edac_check = pci_info->check;
diff -puN drivers/edac/amd8131_edac.c~edac-amd8111-amd8131-use-dev_name drivers/edac/amd8131_edac.c
--- a/drivers/edac/amd8131_edac.c~edac-amd8111-amd8131-use-dev_name
+++ a/drivers/edac/amd8131_edac.c
@@ -287,7 +287,7 @@ static int amd8131_probe(struct pci_dev 
 	dev_info->edac_dev->dev = &dev_info->dev->dev;
 	dev_info->edac_dev->mod_name = AMD8131_EDAC_MOD_STR;
 	dev_info->edac_dev->ctl_name = dev_info->ctl_name;
-	dev_info->edac_dev->dev_name = dev_info->dev->dev.bus_id;
+	dev_info->edac_dev->dev_name = dev_name(&dev_info->dev->dev);
 
 	if (edac_op_state == EDAC_OPSTATE_POLL)
 		dev_info->edac_dev->edac_check = amd8131_chipset.check;
_

Patches currently in -mm which might be from qingtao.cao@windriver.com are

origin.patch
edac-add-cpc925-memory-controller-driver.patch
edac-add-cpc925-memory-controller-driver-cleanup.patch
edac-add-cpc925-memory-controller-driver-mc-check-fixup.patch
edac-add-edac_device_alloc_index.patch
edac-add-edac_device_alloc_index-cleanup.patch
edac-cpc925-mc-platform-device-setup.patch
edac-cpc925-mc-platform-device-setup-v3.patch

