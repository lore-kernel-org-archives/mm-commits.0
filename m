From: akpm@linux-foundation.org
Subject: - pci-fix-msi-howtotxt-info-about-msi-x-mmio-space.patch removed from -mm tree
Date: Wed, 01 Oct 2008 14:51:46 -0700
Message-ID: <200810012151.m91Lpkwe005954@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33537 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754272AbYJAVvt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2008 17:51:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@digitalvampire.org, mm-commits@vger.kernel.org


The patch titled
     pci: fix MSI-HOWTO.txt info about MSI-X MMIO space
has been removed from the -mm tree.  Its filename was
     pci-fix-msi-howtotxt-info-about-msi-x-mmio-space.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci: fix MSI-HOWTO.txt info about MSI-X MMIO space
From: Roland Dreier <roland@digitalvampire.org>

The current MSI-HOWTO.txt says that device drivers should not request the
memory space that contains MSI-X tables.  This is because the original
MSI-X implementation did a request_mem_region() on this space, but that
code was removed long ago (in the pre-git era, in fact).  Years after the
code was changed, we might as well clean up the documention to avoid a
confusing mention of requesting regions: drivers using MSI-X can just use
pci_request_regions() just like any other driver, and so there's no need
for MSI-HOWTO.txt to talk about this at all.

Signed-off-by: Roland Dreier <roland@digitalvampire.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/MSI-HOWTO.txt |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN Documentation/MSI-HOWTO.txt~pci-fix-msi-howtotxt-info-about-msi-x-mmio-space Documentation/MSI-HOWTO.txt
--- a/Documentation/MSI-HOWTO.txt~pci-fix-msi-howtotxt-info-about-msi-x-mmio-space
+++ a/Documentation/MSI-HOWTO.txt
@@ -236,10 +236,8 @@ software system can set different pages 
 MSI-X structure. The implementation of MSI support requires the PCI
 subsystem, not a device driver, to maintain full control of the MSI-X
 table/MSI-X PBA (Pending Bit Array) and MMIO address space of the MSI-X
-table/MSI-X PBA.  A device driver is prohibited from requesting the MMIO
-address space of the MSI-X table/MSI-X PBA. Otherwise, the PCI subsystem
-will fail enabling MSI-X on its hardware device when it calls the function
-pci_enable_msix().
+table/MSI-X PBA.  A device driver should not access the MMIO address
+space of the MSI-X table/MSI-X PBA.
 
 5.3.2 API pci_enable_msix
 
_

Patches currently in -mm which might be from roland@digitalvampire.org are

git-pci.patch

