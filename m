From: akpm@linux-foundation.org
Subject: - net-yellowfin-parenthesis-fix.patch removed from -mm tree
Date: Mon, 31 Mar 2008 13:18:54 -0700
Message-ID: <200803312018.m2VKIsI2024093@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47828 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754086AbYCaUTl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Mar 2008 16:19:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, mm-commits@vger.kernel.org


The patch titled
     net: yellowfin parenthesis fix
has been removed from the -mm tree.  Its filename was
     net-yellowfin-parenthesis-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: net: yellowfin parenthesis fix
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

The code is under unused #ifdef NO_TXSTATS branch but its better to have it
fixed.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/yellowfin.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/yellowfin.c~net-yellowfin-parenthesis-fix drivers/net/yellowfin.c
--- a/drivers/net/yellowfin.c~net-yellowfin-parenthesis-fix
+++ a/drivers/net/yellowfin.c
@@ -770,14 +770,14 @@ static void yellowfin_init_ring(struct n
 		/* Branch on Tx error. */
 		yp->tx_ring[j].dbdma_cmd = cpu_to_le32(CMD_STOP);
 		yp->tx_ring[j].branch_addr = cpu_to_le32(yp->tx_ring_dma +
-			(j+1)*sizeof(struct yellowfin_desc);
+			(j+1)*sizeof(struct yellowfin_desc));
 		j++;
 		if (yp->flags & FullTxStatus) {
 			yp->tx_ring[j].dbdma_cmd =
 				cpu_to_le32(CMD_TXSTATUS | sizeof(*yp->tx_status));
 			yp->tx_ring[j].request_cnt = sizeof(*yp->tx_status);
 			yp->tx_ring[j].addr = cpu_to_le32(yp->tx_status_dma +
-				i*sizeof(struct tx_status_words);
+				i*sizeof(struct tx_status_words));
 		} else {
 			/* Symbios chips write only tx_errs word. */
 			yp->tx_ring[j].dbdma_cmd =
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

git-alsa-tiwai.patch
git-net.patch
revert-gregkh-pci-pci-alpha-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-arm-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-cris-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-frv-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-ia64-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-mips-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-mn10300-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-parisc-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-powerpc-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-ppc-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-sh-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-sparc64-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-v850-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-x86-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-xtensa-use-generic-pci_enable_resources.patch
reiser4.patch

