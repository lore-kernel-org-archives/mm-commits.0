From: akpm@linux-foundation.org
Subject: + driver-edac-mod-race-fix-i82875p.patch added to -mm tree
Date: Fri, 08 Jun 2007 12:40:33 -0700
Message-ID: <200706081940.l58JeXGR009868@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38967 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752046AbXFHTkn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 15:40:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: juhlenko@akamai.com, alan@lxorguk.ukuu.org.uk, dougthompson@xmission.com


The patch titled
     drivers/edac: mod race fix i82875p
has been added to the -mm tree.  Its filename is
     driver-edac-mod-race-fix-i82875p.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/edac: mod race fix i82875p
From: Jason Uhlenkott <juhlenko@akamai.com>

If ERRSTS indicates that there's no error then we don't need to bother reading
the other registers.

In addition to making the common case faster, this actually fixes a small race
where we don't see an error but we clear the error bits anyway, potentially
wiping away info on an error that happened in the interim (or where a CE
arrives between the first and second read of ERRSTS, causing us to falsely
claim "UE overwrote CE").

Signed-off-by: Jason Uhlenkott <juhlenko@akamai.com>
Signed-off-by: Douglas Thompson <dougthompson@xmission.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/i82875p_edac.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff -puN drivers/edac/i82875p_edac.c~driver-edac-mod-race-fix-i82875p drivers/edac/i82875p_edac.c
--- a/drivers/edac/i82875p_edac.c~driver-edac-mod-race-fix-i82875p
+++ a/drivers/edac/i82875p_edac.c
@@ -198,27 +198,28 @@ static void i82875p_get_error_info(struc
 	 * overwritten by UE.
 	 */
 	pci_read_config_word(pdev, I82875P_ERRSTS, &info->errsts);
+
+	if (!(info->errsts & 0x0081))
+		return;
+
 	pci_read_config_dword(pdev, I82875P_EAP, &info->eap);
 	pci_read_config_byte(pdev, I82875P_DES, &info->des);
 	pci_read_config_byte(pdev, I82875P_DERRSYN, &info->derrsyn);
 	pci_read_config_word(pdev, I82875P_ERRSTS, &info->errsts2);
 
-	pci_write_bits16(pdev, I82875P_ERRSTS, 0x0081, 0x0081);
-
 	/*
 	 * If the error is the same then we can for both reads then
 	 * the first set of reads is valid.  If there is a change then
 	 * there is a CE no info and the second set of reads is valid
 	 * and should be UE info.
 	 */
-	if (!(info->errsts2 & 0x0081))
-		return;
-
 	if ((info->errsts ^ info->errsts2) & 0x0081) {
 		pci_read_config_dword(pdev, I82875P_EAP, &info->eap);
 		pci_read_config_byte(pdev, I82875P_DES, &info->des);
 		pci_read_config_byte(pdev, I82875P_DERRSYN, &info->derrsyn);
 	}
+
+	pci_write_bits16(pdev, I82875P_ERRSTS, 0x0081, 0x0081);
 }
 
 static int i82875p_process_error_info(struct mem_ctl_info *mci,
@@ -229,7 +230,7 @@ static int i82875p_process_error_info(st
 
 	multi_chan = mci->csrows[0].nr_channels - 1;
 
-	if (!(info->errsts2 & 0x0081))
+	if (!(info->errsts & 0x0081))
 		return 0;
 
 	if (!handle_errors)
_

Patches currently in -mm which might be from juhlenko@akamai.com are

drivers-edac-new-inte-30x0-mc-driver.patch
driver-edac-mod-race-fix-i82875p.patch
