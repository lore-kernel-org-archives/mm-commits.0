From: akpm@linux-foundation.org
Subject: + pci-use-fixed-up-device-class-when-configuring-device.patch added to -mm tree
Date: Mon, 01 Jun 2009 14:29:03 -0700
Message-ID: <200906012129.n51LT3pZ023712@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750785AbZFAVan (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Jun 2009 17:30:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yu.zhao@intel.com, grundler@parisc-linux.org, htejun@gmail.com, jeff@garzik.org, marc.c.dionne@gmail.com


The patch titled
     pci: use fixed-up device class when configuring device
has been added to the -mm tree.  Its filename is
     pci-use-fixed-up-device-class-when-configuring-device.patch

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
pci-use-fixed-up-device-class-when-configuring-device.patch

