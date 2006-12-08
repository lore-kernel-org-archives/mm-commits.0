From: akpm@osdl.org
Subject: - 2.6.17-rc4-mm1-ich8-fix.patch removed from -mm tree
Date: Fri, 08 Dec 2006 03:04:34 -0800
Message-ID: <200612081104.kB8B4Ygp018568@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:48622 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938033AbWLHLEl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 06:04:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: htejun@gmail.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     libata: ich8 fix
has been removed from the -mm tree.  Its filename was
     2.6.17-rc4-mm1-ich8-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: libata: ich8 fix


Mystery patch from Intel - needed on an ICH8-based preproduction machine.

Cc: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/ata_piix.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN drivers/scsi/ata_piix.c~2.6.17-rc4-mm1-ich8-fix drivers/scsi/ata_piix.c
--- a/drivers/scsi/ata_piix.c~2.6.17-rc4-mm1-ich8-fix
+++ a/drivers/scsi/ata_piix.c
@@ -654,6 +654,14 @@ static int piix_sata_prereset(struct ata
 		port = map[base + i];
 		if (port < 0)
 			continue;
+		if (ap->flags & PIIX_FLAG_AHCI) {
+			/* FIXME: Port status of AHCI controllers
+			 * should be accessed in AHCI memory space.  */
+			if (pcs & 1 << port)
+				present_mask |= 1 << i;
+			else
+				pcs &= ~(1 << port);
+		}
 		if (ap->flags & PIIX_FLAG_IGNORE_PCS || pcs & 1 << (4 + port))
 			present_mask |= 1 << i;
 		else
_

Patches currently in -mm which might be from htejun@gmail.com are

origin.patch
ata_piix-ide-mode-sata-patch-for-intel-ich9.patch

