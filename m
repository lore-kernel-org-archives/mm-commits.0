From: akpm@linux-foundation.org
Subject: [folded] edac-add-cpc925-memory-controller-driver-mc-check-fixup.patch removed from -mm tree
Date: Wed, 17 Jun 2009 15:54:00 -0700
Message-ID: <200906172254.n5HMs05p013684@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60668 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762180AbZFQWyH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 18:54:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qingtao.cao@windriver.com, benh@kernel.crashing.org, galak@gate.crashing.org, michael@ellerman.id.au, norsk5@yahoo.com, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     EDAC: CPC925 MC check fixup
has been removed from the -mm tree.  Its filename was
     edac-add-cpc925-memory-controller-driver-mc-check-fixup.patch

This patch was dropped because it was folded into edac-add-cpc925-memory-controller-driver.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: EDAC: CPC925 MC check fixup
From: Harry Ciao <qingtao.cao@windriver.com>

Fix an obvious bug in CPC925 Memory Controller's check routine -
edac_mc_handle_ue() should have been called for UECC errors and
edac_mc_handle_ce() for CECC errors.

Signed-off-by: Harry Ciao <qingtao.cao@windriver.com>
Cc: Doug Thompson <norsk5@yahoo.com>
Cc: Michael Ellerman <michael@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/cpc925_edac.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN drivers/edac/cpc925_edac.c~edac-add-cpc925-memory-controller-driver-mc-check-fixup drivers/edac/cpc925_edac.c
--- a/drivers/edac/cpc925_edac.c~edac-add-cpc925-memory-controller-driver-mc-check-fixup
+++ a/drivers/edac/cpc925_edac.c
@@ -544,17 +544,16 @@ static void cpc925_mc_check(struct mem_c
 	/* Revert column/row addresses into page frame number, etc */
 	cpc925_mc_get_pfn(mci, mear, &pfn, &offset, &csrow);
 
-	if (apiexcp & UECC_EXCP_DETECTED) {
-		cpc925_mc_printk(mci, KERN_INFO, "DRAM UECC Fault\n");
+	if (apiexcp & CECC_EXCP_DETECTED) {
+		cpc925_mc_printk(mci, KERN_INFO, "DRAM CECC Fault\n");
 		channel = cpc925_mc_find_channel(mci, syndrome);
 		edac_mc_handle_ce(mci, pfn, offset, syndrome,
 				  csrow, channel, mci->ctl_name);
 	}
 
-	if (apiexcp & CECC_EXCP_DETECTED) {
-		cpc925_mc_printk(mci, KERN_INFO, "DRAM CECC Fault\n");
-		edac_mc_handle_ue(mci, pfn, offset,
-				  csrow, mci->ctl_name);
+	if (apiexcp & UECC_EXCP_DETECTED) {
+		cpc925_mc_printk(mci, KERN_INFO, "DRAM UECC Fault\n");
+		edac_mc_handle_ue(mci, pfn, offset, csrow, mci->ctl_name);
 	}
 
 	cpc925_mc_printk(mci, KERN_INFO, "Dump registers:\n");
_

Patches currently in -mm which might be from qingtao.cao@windriver.com are

edac-add-cpc925-memory-controller-driver.patch
edac-add-cpc925-memory-controller-driver-mc-check-fixup.patch
edac-add-edac_device_alloc_index.patch
edac-add-edac_device_alloc_index-cleanup.patch
edac-cpc925-mc-platform-device-setup.patch
edac-cpc925-mc-platform-device-setup-v3.patch

