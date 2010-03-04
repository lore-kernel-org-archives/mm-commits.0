From: akpm@linux-foundation.org
Subject: [merged] drivers-scsi-hpsac-fix-section-mismatch.patch removed from -mm tree
Date: Thu, 04 Mar 2010 11:41:56 -0800
Message-ID: <201003041941.o24JfuZO025962@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43425 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932233Ab0CDTmJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Mar 2010 14:42:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeffm@suse.com, James.Bottomley@HansenPartnership.com, scameron@beardog.cce.hp.com, mm-commits@vger.kernel.org


The patch titled
     drivers/scsi/hpsa.c: fix section mismatch
has been removed from the -mm tree.  Its filename was
     drivers-scsi-hpsac-fix-section-mismatch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/scsi/hpsa.c: fix section mismatch
From: Jeff Mahoney <jeffm@suse.com>

hpsa_pci_init() calls hpsa_interrupt_mode() which is a __devinit function.
 hpsa_pci_init() is only called by hpsa_init_one() which is also
__devinit, so mark it __devinit as well.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Acked-by: "Stephen M.Cameron" <scameron@beardog.cce.hp.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hpsa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/hpsa.c~drivers-scsi-hpsac-fix-section-mismatch drivers/scsi/hpsa.c
--- a/drivers/scsi/hpsa.c~drivers-scsi-hpsac-fix-section-mismatch
+++ a/drivers/scsi/hpsa.c
@@ -3296,7 +3296,7 @@ default_int_mode:
 	h->intr[PERF_MODE_INT] = pdev->irq;
 }
 
-static int hpsa_pci_init(struct ctlr_info *h, struct pci_dev *pdev)
+static int __devinit hpsa_pci_init(struct ctlr_info *h, struct pci_dev *pdev)
 {
 	ushort subsystem_vendor_id, subsystem_device_id, command;
 	u32 board_id, scratchpad = 0;
_

Patches currently in -mm which might be from jeffm@suse.com are

origin.patch
linux-next.patch
delayacct-align-to-8-byte-boundary-on-64-bit-systems.patch

