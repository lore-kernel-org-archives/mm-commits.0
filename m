From: akpm@linux-foundation.org
Subject: - pata_platform-fix-null-pointer-dereference.patch removed from -mm tree
Date: Fri, 20 Jul 2007 12:42:24 -0700
Message-ID: <200707201942.l6KJgOTm013087@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58334 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763613AbXGTTmi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 15:42:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: magnus.damm@gmail.com, alan@lxorguk.ukuu.org.uk, damm@igel.co.jp, jeff@garzik.org, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     pata_platform: Fix NULL pointer dereference
has been removed from the -mm tree.  Its filename was
     pata_platform-fix-null-pointer-dereference.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pata_platform: Fix NULL pointer dereference
From: Magnus Damm <magnus.damm@gmail.com>

pata_platform: Fix NULL pointer dereference

pata_platform currently dereferences a NULL pointer in pata_platform_probe()
if pdev->dev.platform_data is set to NULL. This breakage was most likely
introduced by commit 5f45bc50976ee1f408f7171af155aec646655a37.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_platform.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/ata/pata_platform.c~pata_platform-fix-null-pointer-dereference drivers/ata/pata_platform.c
--- a/drivers/ata/pata_platform.c~pata_platform-fix-null-pointer-dereference
+++ a/drivers/ata/pata_platform.c
@@ -213,8 +213,9 @@ static int __devinit pata_platform_probe
 	pata_platform_setup_port(&ap->ioaddr, pp_info);
 
 	/* activate */
-	return ata_host_activate(host, platform_get_irq(pdev, 0), ata_interrupt,
-				 pp_info->irq_flags, &pata_platform_sht);
+	return ata_host_activate(host, platform_get_irq(pdev, 0),
+				 ata_interrupt, pp_info ? pp_info->irq_flags
+				 : 0, &pata_platform_sht);
 }
 
 /**
_

Patches currently in -mm which might be from magnus.damm@gmail.com are

origin.patch
