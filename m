From: akpm@linux-foundation.org
Subject: - drivers-ata-pata_at32c-avoid-unnecessary-memset.patch removed from -mm tree
Date: Tue, 20 May 2008 14:14:16 -0700
Message-ID: <200805202114.m4KLEGJi011448@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54265 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762214AbYETVX2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 17:23:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: christophe.jaillet@wanadoo.fr, haavard.skinnemoen@atmel.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     drivers/ata/pata_at32.c: avoid unnecessary memset
has been removed from the -mm tree.  Its filename was
     drivers-ata-pata_at32c-avoid-unnecessary-memset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/ata/pata_at32.c: avoid unnecessary memset
From: Christophe Jaillet <christophe.jaillet@wanadoo.fr>

Remove an explicit memset(.., 0, ...) to a variable allocated with kzalloc
(i.e.  'info').

Signed-off-by: Christophe Jaillet <christophe.jaillet@wanadoo.fr>
Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_at32.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/ata/pata_at32.c~drivers-ata-pata_at32c-avoid-unnecessary-memset drivers/ata/pata_at32.c
--- a/drivers/ata/pata_at32.c~drivers-ata-pata_at32c-avoid-unnecessary-memset
+++ a/drivers/ata/pata_at32.c
@@ -291,8 +291,6 @@ static int __init pata_at32_probe(struct
 	if (!info)
 		return -ENOMEM;
 
-	memset(info, 0, sizeof(struct at32_ide_info));
