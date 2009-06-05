From: akpm@linux-foundation.org
Subject: [merged] pci-use-fixed-up-device-class-when-configuring-device.patch removed from -mm tree
Date: Fri, 05 Jun 2009 11:55:25 -0700
Message-ID: <200906051855.n55ItP6a020738@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36332 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751226AbZFES4a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Jun 2009 14:56:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yu.zhao@intel.com, grundler@parisc-linux.org, htejun@gmail.com, jeff@garzik.org, marc.c.dionne@gmail.com, mm-commits@vger.kernel.org


The patch titled
     pci: use fixed-up device class when configuring device
has been removed from the -mm tree.  Its filename was
     pci-use-fixed-up-device-class-when-configuring-device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci: use fixed-up device class when configuring device
From: Yu Zhao <yu.zhao@intel.com>

The device class may be changed after the early fixup. Need to
re-read the class value from pci_dev when configuring the device.
Otherwise some devices such as JMicron SATA controller won't work.

Tested-by: Marc Dionne <marc.c.dionne@gmail.com>
Signed-off-by: Yu Zhao <yu.zhao@intel.com>
Reviewed-by: Grant Grundler <grundler@parisc-linux.org>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/probe.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/pci/probe.c~pci-use-fixed-up-device-class-when-configuring-device drivers/pci/probe.c
--- a/drivers/pci/probe.c~pci-use-fixed-up-device-class-when-configuring-device
+++ a/drivers/pci/probe.c
@@ -750,6 +750,8 @@ int pci_setup_device(struct pci_dev *dev
 
 	/* Early fixups, before probing the BARs */
 	pci_fixup_device(pci_fixup_early, dev);
+	/* device class may be changed after fixup */
+	class = dev->class >> 8;
 
 	switch (dev->hdr_type) {		    /* header type */
 	case PCI_HEADER_TYPE_NORMAL:		    /* standard header */
_

Patches currently in -mm which might be from yu.zhao@intel.com are

linux-next.patch

