From: akpm@linux-foundation.org
Subject: - piix3-warn-softer-about-enabling-passive-release.patch removed from -mm tree
Date: Wed, 17 Dec 2008 12:48:32 -0800
Message-ID: <200812172048.mBHKmWwg006881@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47577 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751542AbYLQUt0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Dec 2008 15:49:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ajax@redhat.com, bzolnier@gmail.com, htejun@gmail.com, jbarnes@virtuousgeek.org, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     piix3: warn softer about enabling passive release
has been removed from the -mm tree.  Its filename was
     piix3-warn-softer-about-enabling-passive-release.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: piix3: warn softer about enabling passive release
From: Adam Jackson <ajax@redhat.com>

All the other quirks are dev_info() not dev_err(), this one isn't special.
This makes 'quiet' boot in qemu really quiet.

Signed-off-by: Adam Jackson <ajax@redhat.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/quirks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pci/quirks.c~piix3-warn-softer-about-enabling-passive-release drivers/pci/quirks.c
--- a/drivers/pci/quirks.c~piix3-warn-softer-about-enabling-passive-release
+++ a/drivers/pci/quirks.c
@@ -56,7 +56,7 @@ static void quirk_passive_release(struct
 	while ((d = pci_get_device(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82371SB_0, d))) {
 		pci_read_config_byte(d, 0x82, &dlc);
 		if (!(dlc & 1<<1)) {
-			dev_err(&d->dev, "PIIX3: Enabling Passive Release\n");
+			dev_info(&d->dev, "PIIX3: Enabling Passive Release\n");
 			dlc |= 1<<1;
 			pci_write_config_byte(d, 0x82, dlc);
 		}
_

Patches currently in -mm which might be from ajax@redhat.com are

linux-next.patch

