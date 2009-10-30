From: akpm@linux-foundation.org
Subject: [merged] edac-i5100-fix-initialization-code.patch removed from -mm tree
Date: Fri, 30 Oct 2009 13:51:47 -0700
Message-ID: <200910302051.n9UKplaM013774@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46186 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932607AbZJ3UwY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Oct 2009 16:52:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kmannth@us.ibm.com, aris@ruivo.org, dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     edac: i5100 fix initialization code
has been removed from the -mm tree.  Its filename was
     edac-i5100-fix-initialization-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: i5100 fix initialization code
From: Keith Mannthey <kmannth@us.ibm.com>

Allow csrows to properly initialize when the topology only has active
channels on 2 and 3.  This new check allows proper detection and
initialization in this topology.  Only checking the first mrt that
represented channels 0 and 1 is not sufficient.

I also fixed up the related debug information path.  I can submit as a 2nd
patch if needed.

Signed-off-by: Keith Mannthey <kmannth@us.ibm.com>
Acked-by: Aristeu Rozanski <aris@ruivo.org>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/edac/i5000_edac.c~edac-i5100-fix-initialization-code drivers/edac/i5000_edac.c
--- a/drivers/edac/i5000_edac.c~edac-i5100-fix-initialization-code
+++ a/drivers/edac/i5000_edac.c
@@ -1173,7 +1173,7 @@ static void i5000_get_mc_regs(struct mem
 			pci_read_config_word(pvt->branch_1, where,
 					&pvt->b1_mtr[slot_row]);
 			debugf2("MTR%d where=0x%x B1 value=0x%x\n", slot_row,
-				where, pvt->b0_mtr[slot_row]);
+				where, pvt->b1_mtr[slot_row]);
 		} else {
 			pvt->b1_mtr[slot_row] = 0;
 		}
@@ -1232,7 +1232,7 @@ static int i5000_init_csrows(struct mem_
 	struct csrow_info *p_csrow;
 	int empty, channel_count;
 	int max_csrows;
-	int mtr;
+	int mtr, mtr1;
 	int csrow_megs;
 	int channel;
 	int csrow;
@@ -1251,9 +1251,10 @@ static int i5000_init_csrows(struct mem_
 
 		/* use branch 0 for the basis */
 		mtr = pvt->b0_mtr[csrow >> 1];
+		mtr1 = pvt->b1_mtr[csrow >> 1];
 
 		/* if no DIMMS on this row, continue */
-		if (!MTR_DIMMS_PRESENT(mtr))
+		if (!MTR_DIMMS_PRESENT(mtr) && !MTR_DIMMS_PRESENT(mtr1))
 			continue;
 
 		/* FAKE OUT VALUES, FIXME */
_

Patches currently in -mm which might be from kmannth@us.ibm.com are

origin.patch
linux-next.patch

