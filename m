From: akpm@linux-foundation.org
Subject: + ata-use-printk_once.patch added to -mm tree
Date: Mon, 24 Aug 2009 14:25:33 -0700
Message-ID: <200908242125.n7OLPXC1030346@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43738 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752637AbZHXV0j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Aug 2009 17:26:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin.slusarz@gmail.com, jgarzik@pobox.com, tj@kernel.org


The patch titled
     ata: use printk_once
has been added to the -mm tree.  Its filename is
     ata-use-printk_once.patch

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
Subject: ata: use printk_once
From: Marcin Slusarz <marcin.slusarz@gmail.com>

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_rz1000.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/ata/pata_rz1000.c~ata-use-printk_once drivers/ata/pata_rz1000.c
--- a/drivers/ata/pata_rz1000.c~ata-use-printk_once
+++ a/drivers/ata/pata_rz1000.c
@@ -85,7 +85,6 @@ static int rz1000_fifo_disable(struct pc
 
 static int rz1000_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	static int printed_version;
 	static const struct ata_port_info info = {
 		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = ATA_PIO4,
@@ -93,8 +92,7 @@ static int rz1000_init_one (struct pci_d
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
 
-	if (!printed_version++)
-		printk(KERN_DEBUG DRV_NAME " version " DRV_VERSION "\n");
+	printk_once(KERN_DEBUG DRV_NAME " version " DRV_VERSION "\n");
 
 	if (rz1000_fifo_disable(pdev) == 0)
 		return ata_pci_sff_init_one(pdev, ppi, &rz1000_sht, NULL);
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

linux-next.patch
alpha-use-printk_once.patch
ia64-use-printk_once.patch
ata-use-printk_once.patch
ide-use-printk_once.patch
vsprintf-use-warn_on_once.patch

