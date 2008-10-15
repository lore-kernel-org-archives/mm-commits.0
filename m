From: akpm@linux-foundation.org
Subject: - pata_sil680-convert-config_ppc_merge-to-config_ppc.patch removed from -mm tree
Date: Wed, 15 Oct 2008 14:13:36 -0700
Message-ID: <200810152113.m9FLDa4d005586@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56311 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753157AbYJOVOW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Oct 2008 17:14:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: galak@kernel.crashing.org, alan@lxorguk.ukuu.org.uk, benh@kernel.crashing.org, jeff@garzik.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     pata_sil680: convert CONFIG_PPC_MERGE to CONFIG_PPC
has been removed from the -mm tree.  Its filename was
     pata_sil680-convert-config_ppc_merge-to-config_ppc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pata_sil680: convert CONFIG_PPC_MERGE to CONFIG_PPC
From: Kumar Gala <galak@kernel.crashing.org>

Now that arch/ppc is dead CONFIG_PPC_MERGE is always defined for all
powerpc platforms and we want to get rid of CONFIG_PPC_MERGE use
CONFIG_PPC instead.

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_sil680.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/ata/pata_sil680.c~pata_sil680-convert-config_ppc_merge-to-config_ppc drivers/ata/pata_sil680.c
--- a/drivers/ata/pata_sil680.c~pata_sil680-convert-config_ppc_merge-to-config_ppc
+++ a/drivers/ata/pata_sil680.c
@@ -230,7 +230,7 @@ static u8 sil680_init_chip(struct pci_de
 		tmpbyte & 1, tmpbyte & 0x30);
 
 	*try_mmio = 0;
-#ifdef CONFIG_PPC_MERGE
+#ifdef CONFIG_PPC
 	if (machine_is(cell))
 		*try_mmio = (tmpbyte & 1) || pci_resource_start(pdev, 5);
 #endif
_

Patches currently in -mm which might be from galak@kernel.crashing.org are

origin.patch
mpc52xx_psc_spi-remove-code-associated-with-config_ppc_merge.patch
rtc-use-config_ppc-instead-of-config_ppc_merge.patch

