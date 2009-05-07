From: akpm@linux-foundation.org
Subject: + edac-use-dev_name-for-amd8111-amd8131-edac-driver.patch added to -mm tree
Date: Thu, 07 May 2009 13:06:58 -0700
Message-ID: <200905072006.n47K6wCT019973@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52789 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754234AbZEGUJA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 May 2009 16:09:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: qingtao.cao@windriver.com, norsk5@yahoo.com


The patch titled
     edac: use dev_name() for AMD8111/AMD8131 EDAC driver
has been added to the -mm tree.  Its filename is
     edac-use-dev_name-for-amd8111-amd8131-edac-driver.patch

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
Subject: edac: use dev_name() for AMD8111/AMD8131 EDAC driver
From: Harry Ciao <qingtao.cao@windriver.com>

The device structure no longer has bus_id member, dev_name() should be
used for AMD8111 & AMD8131 EDAC driver instead.  Also, their Makefile
entries are lost, add them.

Signed-off-by: Harry Ciao <qingtao.cao@windriver.com>
Cc: Doug Thompson <norsk5@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/Makefile       |    2 ++
 drivers/edac/amd8111_edac.c |    4 ++--
 drivers/edac/amd8131_edac.c |    2 +-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/edac/Makefile~edac-use-dev_name-for-amd8111-amd8131-edac-driver drivers/edac/Makefile
--- a/drivers/edac/Makefile~edac-use-dev_name-for-amd8111-amd8131-edac-driver
+++ a/drivers/edac/Makefile
@@ -35,3 +35,5 @@ obj-$(CONFIG_EDAC_MPC85XX)		+= mpc85xx_e
 obj-$(CONFIG_EDAC_MV64X60)		+= mv64x60_edac.o
 obj-$(CONFIG_EDAC_CELL)			+= cell_edac.o
 obj-$(CONFIG_EDAC_PPC4XX)		+= ppc4xx_edac.o
+obj-$(CONFIG_EDAC_AMD8111)		+= amd8111_edac.o
+obj-$(CONFIG_EDAC_AMD8131)		+= amd8131_edac.o
diff -puN drivers/edac/amd8111_edac.c~edac-use-dev_name-for-amd8111-amd8131-edac-driver drivers/edac/amd8111_edac.c
--- a/drivers/edac/amd8111_edac.c~edac-use-dev_name-for-amd8111-amd8131-edac-driver
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
diff -puN drivers/edac/amd8131_edac.c~edac-use-dev_name-for-amd8111-amd8131-edac-driver drivers/edac/amd8131_edac.c
--- a/drivers/edac/amd8131_edac.c~edac-use-dev_name-for-amd8111-amd8131-edac-driver
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

edac-use-dev_name-for-amd8111-amd8131-edac-driver.patch
edac-add-cpc925-memory-controller-driver.patch
edac-add-cpc925-memory-controller-driver-cleanup.patch
edac-add-cpc925-memory-controller-driver-mc-check-fixup.patch
edac-add-edac_device_alloc_index.patch
edac-add-edac_device_alloc_index-cleanup.patch
edac-cpc925-mc-platform-device-setup.patch
edac-cpc925-mc-platform-device-setup-v3.patch

