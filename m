From: akpm@linux-foundation.org
Subject: - scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:38:18 -0700
Message-ID: <200810202038.m9KKcIXg011836@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59711 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754123AbYJTUqn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:46:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, hare@suse.de, mm-commits@vger.kernel.org


The patch titled
     scsi: aic79xx aic79xx_pci.c fix shadowed variables
has been removed from the -mm tree.  Its filename was
     scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scsi: aic79xx aic79xx_pci.c fix shadowed variables
From: Harvey Harrison <harvey.harrison@gmail.com>

OK to just reuse the outer declaration as it is never used again.
drivers/scsi/aic7xxx/aic79xx_pci.c:340:12: warning: symbol 'devconfig' shadows an earlier one
drivers/scsi/aic7xxx/aic79xx_pci.c:299:12: originally declared here

targpcistat is always assigned just before use, remove the inner declaration.
drivers/scsi/aic7xxx/aic79xx_pci.c:486:9: warning: symbol 'targpcistat' shadows an earlier one
drivers/scsi/aic7xxx/aic79xx_pci.c:429:9: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aic7xxx/aic79xx_pci.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN drivers/scsi/aic7xxx/aic79xx_pci.c~scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables drivers/scsi/aic7xxx/aic79xx_pci.c
--- a/drivers/scsi/aic7xxx/aic79xx_pci.c~scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables
+++ a/drivers/scsi/aic7xxx/aic79xx_pci.c
@@ -337,8 +337,6 @@ ahd_pci_config(struct ahd_softc *ahd, co
 	 * 64bit bus (PCI64BIT set in devconfig).
 	 */
 	if ((ahd->flags & (AHD_39BIT_ADDRESSING|AHD_64BIT_ADDRESSING)) != 0) {
-		uint32_t devconfig;
-
 		if (bootverbose)
 			printf("%s: Enabling 39Bit Addressing\n",
 			       ahd_name(ahd));
@@ -483,8 +481,6 @@ ahd_pci_test_register_access(struct ahd_
 		goto fail;
 
 	if ((ahd_inb(ahd, INTSTAT) & PCIINT) != 0) {
-		u_int targpcistat;
