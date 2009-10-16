From: akpm@linux-foundation.org
Subject: [merged] pata_sc1200-fix-crash-on-boot.patch removed from -mm tree
Date: Fri, 16 Oct 2009 13:48:46 -0700
Message-ID: <200910162048.n9GKmkL8030619@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33691 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750825AbZJPUuJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Oct 2009 16:50:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@linux.intel.com, alex@ozo.com, jeff@garzik.org, stable@kernel.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     pata_sc1200: fix crash on boot
has been removed from the -mm tree.  Its filename was
     pata_sc1200-fix-crash-on-boot.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pata_sc1200: fix crash on boot
From: Alan Cox <alan@linux.intel.com>

The SC1200 needs a NULL terminator or it may cause a crash on boot.

Also correct a bogus comment as the driver had serializing added so can
run dual port.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=14227

Reported-by: Alexandros C. Couloumbis <alex@ozo.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: <stable@kernel.org>		[2.6.30.x, 2.6.31.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_sc1200.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/ata/pata_sc1200.c~pata_sc1200-fix-crash-on-boot drivers/ata/pata_sc1200.c
--- a/drivers/ata/pata_sc1200.c~pata_sc1200-fix-crash-on-boot
+++ a/drivers/ata/pata_sc1200.c
@@ -235,8 +235,7 @@ static int sc1200_init_one(struct pci_de
 		.udma_mask = ATA_UDMA2,
 		.port_ops = &sc1200_port_ops
 	};
-	/* Can't enable port 2 yet, see top comments */
-	const struct ata_port_info *ppi[] = { &info, };
+	const struct ata_port_info *ppi[] = { &info, NULL };
 
 	return ata_pci_sff_init_one(dev, ppi, &sc1200_sht, NULL);
 }
_

Patches currently in -mm which might be from alan@linux.intel.com are

origin.patch
linux-next.patch
atmel_serial-fix-bad-build_bug_on-usage.patch

