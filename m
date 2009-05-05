From: akpm@linux-foundation.org
Subject: + edac-add-cpc925-memory-controller-driver-mc-check-fixup.patch added to -mm tree
Date: Tue, 05 May 2009 13:32:32 -0700
Message-ID: <200905052032.n45KWWjM015757@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38204 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754423AbZEEUhI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 May 2009 16:37:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: qingtao.cao@windriver.com, benh@kernel.crashing.org, galak@gate.crashing.org, michael@ellerman.id.au, norsk5@yahoo.com, paulus@samba.org


The patch titled
     EDAC: CPC925 MC check fixup
has been added to the -mm tree.  Its filename is
     edac-add-cpc925-memory-controller-driver-mc-check-fixup.patch

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
edac-add-cpc925-memory-controller-driver-cleanup.patch
edac-add-cpc925-memory-controller-driver-mc-check-fixup.patch
edac-add-edac_device_alloc_index.patch
edac-add-edac_device_alloc_index-cleanup.patch
edac-cpc925-mc-platform-device-setup.patch
edac-cpc925-mc-platform-device-setup-v3.patch

